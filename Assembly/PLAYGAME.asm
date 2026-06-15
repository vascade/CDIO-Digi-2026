    .ORIG x3000 ;test her skal det være x3000

    ;play
        AND R0, R0, #0
        LEA R0, START
        PUTS
        
    fromStart
        LEA R0, startSate
        PUTS
        
        AND R0, R0, #0
        GETC
        LEA R2, ASCII_ZERO
        LDR R2, R2, #0
        ADD R0, R0, R2
        
        ADD R1, R0, #-1
        BRnp next
        JSR CHOOSEPLAYER
        BRnzp fromStart
    
    next
        ADD R1, R0, #-2
        BRnp fromStart
        JSR SPIN
        BRnzp fromStart

START               .STRINGZ "PLAY\n" 
ASCII_ZERO          .FILL #-48
startSate           .STRINGZ "CHOOSE 1 FOR EDIT PLAYERNAME, CHOOSE 2 FOR BETTING\n"


loop
    JSR CHOOSEPLAYER
    BRnzp loop
    HALT
    
    
    ;spin
    SPIN 
        HALT
    
    ;choose player
    CHOOSEPLAYER
        ST R7, SaveR7
        AND R0, R0, #0
        
        GETC 
        LEA R2, ASCII_ZERO
        LDR R2, R2, #0
        ADD R0, R0, R2 ;Finder værdien fra char til int, aka -48
        
        ADD R1, R0, #-4
        BRz goToPlayer4
        
        ADD R1, R0, #-3
        BRz goToPlayer3
    
        ADD R1, R0, #-2
        BRz goToPlayer2
        
        ADD R1, R0, #-1
        BRz goToPlayer1
        BRnzp CHOOSEPLAYER
    
    goToPlayer4
        JSR PLAYER4
        BRnzp CHOOSEPLAYER
        
    goToPlayer3
        JSR PLAYER3
        BRnzp CHOOSEPLAYER
        
    goToPlayer2
        JSR PLAYER2
        BRnzp CHOOSEPLAYER
        
    goToPlayer1
        JSR PLAYER1
        BRnzp CHOOSEPLAYER
    
    
    
;Player 1
    PLAYER1
        AND R0, R0, #0
        LEA R0, P1
        PUTS
        
        LEA R0, PLAYERVALUES1
        JSR MAKE_NAME
        
        LEA R0, PLAYERVALUES1
        JSR PRINT_NAME
        
        ;JSR PRINT_PENGE
        
        ;JSR PRINT_OLD_SPINS
        
        LD R7, SaveR7
        RET
    
;Player 2
    PLAYER2
        AND R0, R0, #0
        LEA R0, P2
        PUTS
        
        LEA R0, PLAYERVALUES1
        JSR MAKE_NAME
        
        LEA R0, PLAYERVALUES1
        JSR PRINT_NAME
        
        LD R7, SaveR7
        RET
        
;Player 3
    PLAYER3
        AND R0, R0, #0
        LEA R0, P3
        PUTS
        
        LEA R0, PLAYERVALUES1
        JSR MAKE_NAME
        
        LEA R0, PLAYERVALUES1
        JSR PRINT_NAME
        
        LD R7, SaveR7
        RET

;Player 4
    PLAYER4
        AND R0, R0, #0
        LEA R0, P4
        PUTS
        
        LEA R0, PLAYERVALUES1
        JSR MAKE_NAME 
        
        LEA R0, PLAYERVALUES1
        JSR PRINT_NAME 
        
        LD R7, SaveR7
        RET
    


    MAKE_NAME ;Giver player et nyt navn
        ADD R1, R0, #0
        AND R2, R2, #0
        ADD R2, R2, #4 ;Bruger 4 tegn for navn. 

    ekstraChar       
        AND R0, R0, #0
        GETC 
        STR R0, R1, #0
        ADD R1, R1, #1
        ADD R2, R2, #-1
        BRp ekstraChar
        
        AND R0, R0, #0  ;DONE
        STR R0, R1, #0
        
        RET

;Print name
    PRINT_NAME
        PUTS ;Printer navn
        
        LEA R0, Enter ;Gør næste linje klar
        PUTS
        
        RET
        
        

SaveR7              .BLKW 1
PlAYERVALUES1       .BLKW 16 ;4 tegn + 1 til navn samt 1 til pengene, og 10 til sidste spins 
PlAYERVALUES2       .BLKW 16
PlAYERVALUES3       .BLKW 16
PlAYERVALUES4       .BLKW 16
P1                  .STRINGZ "P1-" 
P2                  .STRINGZ "P2-" 
P3                  .STRINGZ "P3-" 
P4                  .STRINGZ "P4-" 
Enter               .STRINGZ "\n"

WHEEL               .BLKW 37 ;

StartPenge          .FILL #100


.END