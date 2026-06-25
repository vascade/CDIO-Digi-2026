-- This is the component that you'll need to fill in in order to create the LC3 computer.
-- It is FPGA independent. It can be used without any changes between the Zybo and the 
-- Nexys3 boards.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
entity lc3_computer is
   port (
		--System clock
      clk              : in  std_logic; 

      --Virtual I/O
      led              : out std_logic_vector(7 downto 0);
      btn              : in  std_logic_vector(4 downto 0);
      sw               : in  std_logic_vector(7 downto 0);
      hex              : out std_logic_vector(15 downto 0); --16 bit hexadecimal value (shown on 7-seg sisplay)

	  --Physical I/0 (IO on the Zybo FPGA)
	  pbtn				  : in  std_logic_vector(3 downto 0);
	  psw				  : in  std_logic_vector(3 downto 0);
	  pled				  : out  std_logic_vector(2 downto 0);

	  --VIO serial
	  rx_data          : in  std_logic_vector(7 downto 0);
      rx_rd            : out std_logic;
      rx_empty         : in  std_logic;
      tx_data          : out std_logic_vector(7 downto 0);
      tx_wr            : out std_logic;
      tx_full          : in  std_logic;
	  sink             : out std_logic;

      --Debug
      address_dbg      : out std_logic_vector(15 downto 0);
      data_dbg         : out std_logic_vector(15 downto 0);
      RE_dbg           : out std_logic;
      WE_dbg           : out std_logic;
		
	  --LC3 CPU inputs
      cpu_clk_enable   : in  std_logic;
      sys_reset        : in  std_logic;
      sys_program      : in  std_logic;
      
      -- ADDED STUDENT CODE---
      rx_pin : in std_logic ;
      tx_pin : out std_logic
   );
end lc3_computer;

architecture Behavioral of lc3_computer is
   --Creating user friently names for the buttons
   alias btn_u : std_logic is btn(0); --Button UP
   alias btn_l : std_logic is btn(1); --Button LEFT
   alias btn_d : std_logic is btn(2); --Button DOWN
   alias btn_r : std_logic is btn(3); --Button RIGHT
   alias btn_s : std_logic is btn(4); --Button SELECT (center button)
   alias btn_c : std_logic is btn(4); --Button CENTER
   
   signal sink_sw : std_logic;
   signal sink_psw : std_logic;
   signal sink_btn : std_logic;
   signal sink_pbtn : std_logic;
   signal sink_uart : std_logic;
   -- Memory interface signals
   signal address: std_logic_vector(15 downto 0);
   signal data, data_in, data_out: std_logic_vector(15 downto 0); -- data inputs
   signal RE, WE:  std_logic;


   -- I/O constants for addr from 0xFE00 to 0xFFFF:
   constant STDIN_S    : std_logic_vector(15 downto 0) := X"FE00";  -- VIO - Serial IN (terminal keyboard) -- KBSR 
   constant STDIN_D    : std_logic_vector(15 downto 0) := X"FE02";  -- VIO - Keyboard Data Register - KBDR
   constant STDOUT_S   : std_logic_vector(15 downto 0) := X"FE04";  -- VIO - Serial OUT (terminal  display) - DSR
   constant STDOUT_D   : std_logic_vector(15 downto 0) := X"FE06";  -- VIO - Display Data Register -- DDR
   constant IO_SW      : std_logic_vector(15 downto 0) := X"FE0A";  -- Switches 
   constant IO_PSW     : std_logic_vector(15 downto 0) := X"FE0B";  -- Physical Switches	
   constant IO_BTN     : std_logic_vector(15 downto 0) := X"FE0e";  -- Buttons
   constant IO_PBTN    : std_logic_vector(15 downto 0) := X"FE0F";  -- Physical Buttons	
   constant IO_SSEG    : std_logic_vector(15 downto 0) := X"FE12";  -- 7 segment
   constant IO_LED     : std_logic_vector(15 downto 0) := X"FE16";  -- Leds
   constant IO_PLED    : std_logic_vector(15 downto 0) := X"FE17";  -- Physical Leds  
   ---<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>---
   ---<<<<< End of pregenerated code >>>>>---
   ---<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>---
   ------------------------------------------
   
   --Student Signals--
   signal ram_din : std_logic_vector(15 downto 0);
   signal hex_reg : std_logic_vector(15 downto 0);
   signal led_reg : std_logic_vector(15 downto 0);
   signal pled_reg : std_logic_vector(15 downto 0);
   -- UART --
   signal tx_data_int : std_logic_vector(7 downto 0);
   signal rx_data_int : std_logic_vector(7 downto 0);
   signal rx_data_2  : std_logic_vector(7 downto 0);
   signal rx_empty_2 : std_logic;
   signal tx_full_2  : std_logic;
   signal rx_rd_2    : std_logic;
   signal tx_wr_2    : std_logic;
   signal tx_data_2  : std_logic_vector(7 downto 0);
   constant STDIN_S_2  : std_logic_vector(15 downto 0) := X"FE01";  -- UART - SERIAL IN (terminal keyboard)-- KBSR
   constant STDIN_D_2  : std_logic_vector(15 downto 0) := X"FE03";  -- UART - Keyboard Data Register - KBDR
   constant STDOUT_S_2 : std_logic_vector(15 downto 0) := X"FE05";  -- UART - Serial OUT (terminal  display) - DSR
   constant STDOUT_D_2 : std_logic_vector(15 downto 0) := X"FE07";  -- UART - Display Data Register -- DDR
   -----------
   -- Timer --
   signal timer_start, timer_done_sig : std_logic;
   signal timer_wait_time : std_logic_vector(15 downto 0);
   constant IO_TIMER_WAIT : std_logic_vector(15 downto 0) := x"FE20";
   constant IO_timer_DONE : STD_LOGIC_VECtoR(15 DOWNTO 0) := x"FE22";
       
begin
   sink_psw <= psw(0) or psw(1) or psw(2) or psw(3);
   sink_pbtn <= pbtn(0) or pbtn(1) or pbtn(2) or pbtn(3);
   sink_sw <= sw(0) or sw(1) or sw(2) or sw(3) or sw(4) or sw(5) or sw(6) or sw(7); 
   sink_btn <= btn(0) or btn(1) or btn(2) or btn(3) or btn(4);
   sink_uart <= rx_data(0) or rx_data(1) or rx_data(2) or rx_data(3) or rx_data(4) or 
					 rx_data(5) or rx_data(6) or rx_data(7)or rx_empty or tx_full; 
   sink <= sink_sw or sink_psw or sink_btn or sink_pbtn or sink_uart;

   ---<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>---
   ---<<<<< End of pregenerated code >>>>>---
   ---<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>---	
	-- <<< LC3 CPU using multiplexers for the data bus>>>	
	lc3_m: entity work.lc3_wrapper_multiplexers
	port map (
		 clk        => clk,
		 clk_enable => cpu_clk_enable,
		 reset      => sys_reset,
		 program    => sys_program,
		 addr       => address,
		 data_in    => data_in,
		 data_out   => data_out,
		 WE         => WE,
		 RE         => RE 
		 );
   data_dbg <= data_in when RE='1' else data_out;
	-- <<< LC3 CPU using multiplexers end of instantiation>>>	
	
		 
--	-- <<< LC3 CPU using tristates for the data bus>>>
--	lc3_t: entity work.lc3_wrapper_tristates
--	port map (
--		 clk        => clk,
--		 clk_enable => cpu_clk_enable,
--		 reset      => sys_reset,
--		 program    => sys_program,
--		 addr       => address,
--		 data       => data,
--		 WE         => WE,
--		 RE         => RE 
--		 );
--   data_dbg <= data;
--	-- <<< LC3 CPU using tristates end of instantiation>>>
	
	--Information that is sent to the debugging module
   address_dbg <= address;
   RE_dbg <= RE;
   WE_dbg <= WE;
   
	-------------------------------------------------------------------------------
	-- <<< Write your VHDL code starting from here >>>
	------------------------------------------------------------------------------
    -- Ram
   	Inst_memory : entity work.xilinx_one_port_ram_sync
        port map(
           clk => clk,
           addr => address,
           din => data_out,
           dout => ram_din,
           we => WE
           );    
     
     hex <= hex_reg;
     led <= led_reg(7 downto 0);
     pled <= pled_reg(2 downto 0);
     
     Inst_uart : entity work.UART
        generic map( 
            DBIT => 8, -- 8 data bits
            SB_TICK => 16, -- 1 stop bit
            DVSR => 163, -- 50 mhz / (16 sb_tick * 19200 baud) = 163
            DVSR_bit => 8, 
            FIFO_W => 2 --4 word FIFO
            )
        port map( 
            clk => clk,
            reset => sys_reset,
            rx => rx_pin,
            tx => tx_pin,
            rd_uart => rx_rd_2,
            wr_uart => tx_wr_2,
            w_data => tx_data_2,
            tx_full => tx_full_2,
            rx_empty => rx_empty_2,
            r_data => rx_data_2
        );
              
      Inst_timer : entity work.timer 
      generic map(
          clock_count => 50000
          )
      port map(
          clk => clk, 
          start => timer_start,
          wait_time => timer_wait_time,
          timer_done => timer_done_sig
          );
            
            
            
     process(RE, WE, address, rx_empty, rx_data, tx_full, ram_din, sw, psw, btn, pbtn, data_out, rx_empty_2, rx_data_2, tx_full_2)
           begin
               --RAM
               data_in <= ram_din; -- default
               --VIO
               rx_rd   <= '0';
               tx_wr   <= '0';
               tx_data <= (others => '0');
               --UART
               rx_rd_2 <= '0';
               tx_wr_2 <= '0';
               tx_data_2 <= (others => '0');
               --Timer
               timer_start <= '0';
               
               if RE = '1' then
                   case address is
                       when STDIN_S  => --x"FE00" KBSR
                            data_in <= (not rx_empty) & "000000000000000";
                       when STDIN_D  =>  --x"FE02" KBDR
                            data_in <= X"00" & rx_data;
                            rx_rd   <= '1';
                       when STDOUT_S => --x"FE04" DSR
                            data_in <= (not tx_full) & "000000000000000";
                       when STDOUT_D => --XFE06" DDR
                            data_in <= X"0000";
                       when STDIN_S_2  => --x"FE01" KBSR
                                 data_in <= (not rx_empty_2) & "000000000000000";
                       when STDIN_D_2  =>  --x"FE03" KBDR
                                 data_in <= X"00" & rx_data_2;
                                 rx_rd_2   <= '1';
                       when STDOUT_S_2 => --x"FE05" DSR
                                 data_in <= (not tx_full_2) & "000000000000000";
                       when STDOUT_D_2 => --XFE07" DDR
                                 data_in <= X"0000";
                       when IO_SW => --x"FE0A" SW
                            data_in <= X"00" & SW;
                       when IO_PSW => --x"FE0B" PSW
                            data_in <= X"000" & PSW;
                       when IO_BTN => --x"FE0E" BTN
                            data_in <= x"00" & "000" & btn;
                       when IO_PBTN => --x"FE0F" PBTN
                            data_in <= x"000" & pbtn;
                       when IO_TIMER_DONE =>
                            data_in <= timer_done_sig & "000000000000000";
                       when others   => 
                            data_in <= ram_din;
                   end case;
               elsif WE = '1' then
                   case address is
                        when STDOUT_D =>
                            tx_data <= data_out(7 downto 0);
                            tx_wr   <= '1';
                        when STDOUT_D_2 =>
                            tx_data_2<= data_out(7 downto 0);
                            tx_wr_2 <= '1';
                        when IO_TIMER_WAIT =>
                            timer_wait_time <= data_out;
                            timer_start <= '1';
                        when others =>
                            NULL;
                   end case;
               end if;
           end process;
     
     process(clk)
     begin
        if rising_edge(clk) then
            if WE = '1' then
                case address is 
                    when IO_SSEG => 
                        hex_reg <= data_out;
                    when IO_LED => 
                        led_reg <= data_out(15 downto 0);
                    when IO_PLED => 
                        pled_reg <= data_out(15 downto 0);
                    when others => 
                        NULL;
                end case;
            end if;
        end if;
     end process;
end Behavioral;

