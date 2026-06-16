.ORIG x3000 ;test her skal det være x3000 eller x0500
        
        BRnzp MAIN
        
PTR_ASCII_ZERO  .FILL ASCII_ZERO
PTR_START       .FILL start
PTR_startState  .FILL startState
PTR_tempChar    .FILL tempChar
money           .FILL #100
    ;play
    MAIN
        LD R0, money 
        LD R6 PTR_PLAYERVALUES4
        STR R0, R6 #5
        
        LD R0, money
        LD R6 PTR_PLAYERVALUES3
        STR R0, R6 #5
        
        LD R0, money
        LD R6 PTR_PLAYERVALUES2
        STR R0, R6 #5
        
        LD R0, money
        LD R6 PTR_PLAYERVALUES1
        STR R0, R6 #5
        
        LD R0, PTR_start            ;tager String fra start "play"
        PUTS                        ;Printer 
        
    fromStart
        LD R0, PTR_startState       ;tager string fra startState "CHOOSE 1 FOR EDIT PLAYER, CHOOSE 2 FOR BETTING"
        PUTS
        
        GETC                        ;Player vælger om det er 1 eller 2                   
        LD  R2, PTR_ASCII_ZERO      ;Loader ascii værdien ind aka -48
        LDR R2, R2, #0
        ADD R0, R0, R2              ;lægger R2 til R0 i R0 
        
        ADD R1, R0, #-1             ;hvis vi har valgt 1    
        BRnp next               
        JSR CHOOSEPLAYER            ;går til vælg player
        BRnzp fromStart             ;går tilbage efter vi har være i funktion chooseplayer
    
    next
        ADD R1, R0, #-2         
        BRnp fromStart              ;Går tilbage til start hvis ikke 2
        JSR SPIN                    ;Går til funktionen spin 
        BRnzp fromStart


;Player
    loop
        JSR CHOOSEPLAYER
        BRnzp loop
        HALT
    
;spin
    SPIN 
        LD R0, PTR_playerBet
        PUTS
        
        HALT
        
        
PTR_playerBet   .FILL playerBet
PTR_ASCII_ZERO2 .FILL ASCII_ZERO
PTR_SaveR7      .FILL SaveR7

    ;choose player
    CHOOSEPLAYER
    choosePlayerLoop
        LD  R6, PTR_SaveR7
        STR R7, R6, #0
        
        LEA  R0, playNameEdit
        PUTS
        
        GETC
        
        LD  R2, PTR_ASCII_ZERO2
        LDR R2, R2, #0
        ADD R0, R0, R2              ;Finder værdien fra char til int, aka -48
        
        ADD R1, R0, #-4
        BRz goToPlayer4
        
        ADD R1, R0, #-3
        BRz goToPlayer3
    
        ADD R1, R0, #-2
        BRz goToPlayer2
        
        ADD R1, R0, #-1
        BRz goToPlayer1
        BRnzp choosePlayerLoop
        
PTR_PLAYERVALUES4   .FILL PLAYERVALUES4
PTR_PLAYERVALUES3   .FILL PLAYERVALUES3
PTR_PLAYERVALUES2   .FILL PLAYERVALUES2
PTR_PLAYERVALUES1   .FILL PLAYERVALUES1

    goToPlayer4
        LEA R0, P4
        PUTS
        LD R5, PTR_PLAYERVALUES4 ;Gemmer adressen for Playervalue på R5
        JSR EDITCHOISE
        BRnzp choosePlayerDone
     
    goToPlayer3
        LEA R0, P3
        PUTS
        LD R5, PTR_PLAYERVALUES3
        JSR EDITCHOISE
        BRnzp choosePlayerDone


    goToPlayer2
        LEA R0, P2
        PUTS
        LD R5, PTR_PLAYERVALUES2
        JSR EDITCHOISE
        BRnzp choosePlayerDone
        

    goToPlayer1
        LEA R0, P1
        PUTS
        LD R5, PTR_PLAYERVALUES1
        JSR EDITCHOISE
    
    choosePlayerDone
        LD R6, PTR_SaveR7
        LDR R7, R6, #0
        RET
        
        
P1                  .STRINGZ "P1" 
P2                  .STRINGZ "P2" 
P3                  .STRINGZ "P3" 
P4                  .STRINGZ "P4" 
playNameEdit        .STRINGZ "EDIT PLAYER FROM 1 TO 4\n"
chooseEdit  .STRINGZ "\nCHOOSE 1 FOR EDIT NAME, 2 FOR SHOWING NAME, 3 FOR SHOWING MONEY, 4 FOR SHOWING 10 LAST MOVES, 5 FOR ESCAPE\n"

;vælger hvilket edit for hvilken play personen har valgt 
    EDITCHOISE
    back
        LEA R0 chooseEdit
        PUTS
        
        GETC 
        LD  R2, PTR_ASCII_ZERO2
        LDR R2, R2, #0
        ADD R0, R0, R2 ;Finder værdien fra char til int, aka -48
        
        ADD R1, R0, #-5
        BRnp Next0
        LD R6, PTR_SaveR7
        LDR R7, R6, #0
        RET
        
    Next0
        ADD R1, R0, #-4
        BRnp Next1
        ;JSR SHOW_10LAST
        BRnzp back
        
    Next1
        ADD R1, R0, #-3
        BRnp Next2
        JSR SHOW_MONEY
        BRnzp back
    
    Next2
        ADD R1, R0, #-2
        BRnp Next3
        JSR SHOW_NAME
        BRnzp back
    
    Next3
        ADD R1, R0, #-1
        BRnp back
        JSR MAKE_NAME
        BRnzp back

PTR_SaveR7_2        .FILL SaveR7_2
PTR_SaveR7_3        .FILL SaveR7_3

    MAKE_NAME ;Giver player et nyt navn
        LD  R6, PTR_SaveR7_2
        STR R7, R6, #0
        
        AND R0, R0, #0
        ADD R0, R5, #0  ;Loader adressen af playervalte ind. 
        ADD R1, R0, #0
        AND R2, R2, #0
        ADD R2, R2, #4  ;Bruger 4 tegn for navn. 

    ekstraChar       
        AND R0, R0, #0
        GETC 
        OUT
        STR R0, R1, #0
        ADD R1, R1, #1
        ADD R2, R2, #-1
        BRp ekstraChar
        
        AND R0, R0, #0  ;DONE
        STR R0, R1, #0
        
        LD R6, PTR_SaveR7_2
        LDR R7, R6, #0
        RET

;Show name
    SHOW_NAME
        LD  R6, PTR_SaveR7_2
        STR R7, R6, #0
        
        AND R0, R0, #0
        ADD R0, R5, #0
        PUTS ;Printer navn
        
        LEA R0, Enter ;Gør næste linje klar
        PUTS
        
        LD R6, PTR_SaveR7_2
        LDR R7, R6, #0
        RET

    SHOW_MONEY
        LD  R6, PTR_SaveR7_2
        STR R7, R6, #0
        
        STR R7, R6, #0
        LDR R0, R5, #5      ;loader penge ind
        JSR PRINT_NUMBER
        
        LEA R0, Enter
        PUTS
        
        LD R6, PTR_SaveR7_2
        LDR R7, R6, #0
        RET
        

    PRINT_NUMBER
        LD  R6, PTR_SaveR7_3
        STR R7, R6, #0
                                ;100 del
        AND R1, R1, #0          ;nulstil tæller
        LD  R2, NEG_HUNDRED     ;R2 = -100
    
    loopHundred
        ADD R3, R0, R2          ;R3 = R0 - 100
        BRn doneHundred         ;stop hvis negativt
        ADD R0, R0, R2          ;R0 -= 100
        ADD R1, R1, #1          ;tæl én hundrede mere
        BRnzp loopHundred
    
    doneHundred
        ADD R4, R0, #0          ;gem resten i R4
        LD  R3, ASCII_PLUS48
        ADD R0, R1, R3          ;konverter hundrede-tæller til ASCII ('0'+'2' = '2')
        OUT                     ;print hundrede-cifret
        ADD R0, R4, #0          ;gendan resten tilbage i R0
    
                                ;10 del
        AND R1, R1, #0          ;nulstil tæller
        LD  R2, NEG_TEN         ;R2 = -10
    
    loopTen
        ADD R3, R0, R2          ;R3 = R0 - 10
        BRn doneTen             ;stop hvis negativt
        ADD R0, R0, R2          ;R0 -= 10
        ADD R1, R1, #1          ;tæl én tier mere
        BRnzp loopTen
    
    doneTen
        ADD R4, R0, #0          ;gem enerne i R4
        LD  R3, ASCII_PLUS48
        ADD R0, R1, R3          ;konverter tier-tæller til ASCII
        OUT                     ;print tier-cifret
        ADD R0, R4, #0          ;gendan enerne tilbage i R0
    
                                ;1 del
        LD  R3, ASCII_PLUS48
        ADD R0, R0, R3          ;konverter ener til ASCII (det der er tilbage i R0)
        OUT                     ;print ener-cifret
    
        LD R6, PTR_SaveR7_3
        LDR R7, R6, #0
        RET
 
NEG_HUNDRED     .FILL #-100
NEG_TEN         .FILL #-10
ASCII_PLUS48    .FILL #48

Enter               .STRINGZ "\n"
start               .STRINGZ "PLAY\n" 
startState          .STRINGZ "CHOOSE 1 FOR EDIT PLAYER, CHOOSE 2 FOR BETTING\n"
playerBet           .STRINGZ "CHOOSE PLAYER FROM 1 - 4 TO BET"
ASCII_ZERO          .FILL #-48 
ASCII_TOSTRING      .FILL #48

StartPenge          .FILL #100
        
SaveR7              .BLKW 1
SaveR7_2            .BLKW 1
SaveR7_3            .BLKW 1
tempChar            .BlKW 1
PLAYERVALUES1       .BLKW 17 ;4 tegn + 1 til navn samt 1 til pengene, og 10 til sidste spins,  1 for sæt bet
PLAYERVALUES2       .BLKW 17
PLAYERVALUES3       .BLKW 17
PLAYERVALUES4       .BLKW 17


WHEEL               .BLKW 37 ;




.END