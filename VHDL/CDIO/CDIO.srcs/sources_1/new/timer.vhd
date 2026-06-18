library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
generic(
    CLOCK_COUNT: natural := 50000
);
port(
    clk        : in  std_logic;
    start      : in  std_logic;                      -- one-cycle pulse from CPU write
    wait_time  : in  std_logic_vector(15 downto 0);   -- sampled only when start='1'
    timer_done : out std_logic
);
end timer;

architecture arch of timer is
signal internal_timer : integer range 0 to 65535 := 0;
signal ms_timer        : integer range 0 to 65535 := 0;
signal ms_target       : integer range 0 to 65535 := 0;
signal running         : std_logic := '0';
begin
    process(clk)
    begin
        if (clk'event and clk = '1') then
            timer_done <= '0';  -- default every cycle

            if (start = '1') then
                -- CPU just wrote a new wait_time: latch it and begin counting
                ms_target      <= to_integer(unsigned(wait_time));
                ms_timer       <= 0;
                internal_timer <= 0;
                running        <= '1';

            elsif (running = '1') then
                internal_timer <= internal_timer + 1;

                if (internal_timer = CLOCK_COUNT - 1) then
                    internal_timer <= 0;

                    if (ms_timer = ms_target - 1) then
                        timer_done <= '1';
                        running    <= '0';
                    else
                        ms_timer <= ms_timer + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
end arch;