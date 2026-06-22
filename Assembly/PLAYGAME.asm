.ORIG x3000 ;test her skal det være x3000 eller x0500
        
        BRnzp MAIN
        
PTR_ASCII_ZERO      .FILL ASCII_ZERO
PTR_START           .FILL start
PTR_startState      .FILL startState
PTR_wrong_number    .FILL wrong_number
PTR_noMoreMoney     .FILL noMoreMoney
PTR_howMuchToBet    .FILL howMuchToBet
PTR_playerName      .FILL playerName
PTR_RAND_COUNTER    .FILL RAND_COUNTER 
PTR_WHEEL           .FILL WHEEL
PTR_PLAYERVALUES4_1 .FILL PLAYERVALUES4
PTR_PLAYERVALUES3_1 .FILL PLAYERVALUES3
PTR_PLAYERVALUES2_1 .FILL PLAYERVALUES2
PTR_PLAYERVALUES1_1 .FILL PLAYERVALUES1
PTR_ASCII_ZERO2_1   .FILL ASCII_ZERO
PTR_PlayerBetString     .FILL PlayerBetString
money1                  .STRINGZ "Money: "

money               .FILL #100
    ;play
    MAIN
        LD R0, money 
        LD R6 PTR_PLAYERVALUES4_1
        STR R0, R6 #5
        
        LD R0, money
        LD R6 PTR_PLAYERVALUES3_1
        STR R0, R6 #5
        
        LD R0, money
        LD R6 PTR_PLAYERVALUES2_1
        STR R0, R6 #5
        
        LD R0, money
        LD R6 PTR_PLAYERVALUES1_1
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
        JSR PLAY                    ;Går til funktionen spin 
        BRnzp fromStart


;Player
    loop
        JSR CHOOSEPLAYER
        BRnzp loop
        HALT
    
;play
    PLAY
        LD  R6, PTR_SaveR7_Sp1
        STR R7, R6, #0
    
    resetBet
        AND R0, R0, #0
        ADD R0, R0, #-1     ; -1 = ikke bettet 
        
        LD R6, PTR_PLAYERVALUES1_1
        STR R0, R6, #17             ;fortæller at spiller ikke better
        STR R0, R6, #18             ;fortæller at vi ikke better b/r/g
        STR R0, R6, #19             ;fortæller at vi ikke better o/e
        STR R0, R6, #20             ;fortæller at vi ikke better n
        
        LD R6, PTR_PLAYERVALUES2_1
        STR R0, R6, #17             ;fortæller at spiller ikke better
        STR R0, R6, #18
        STR R0, R6, #19
        STR R0, R6, #20
        
        LD R6, PTR_PLAYERVALUES3_1
        STR R0, R6, #17             ;fortæller at spiller ikke better
        STR R0, R6, #18
        STR R0, R6, #19
        STR R0, R6, #20             
        
        LD R6, PTR_PLAYERVALUES4_1
        STR R0, R6, #17             ;fortæller at spiller ikke better
        STR R0, R6, #18
        STR R0, R6, #19
        STR R0, R6, #20
    
    back1
        LD R0, PTR_playerBet_1
        PUTS
    
        GETC
        
        LD  R2, PTR_ASCII_ZERO2_1
        LDR R2, R2, #0
        ADD R0, R0, R2              ;Finder værdien fra char til int, aka -48
        
        ADD R1, R0, #-6
        BRnp neste01
        JSR SPIN 
        BRnzp resetBet
    
    neste01   
        ADD R1, R0, #-5
        BRnp neste
        LD R6, PTR_SaveR7_Sp1
        LDR R7, R6, #0
        RET
    
    neste  
        ADD R1, R0, #-4
        BRnp neste0 
        LD R5, PTR_PLAYERVALUES4_1
        JSR PLACEBET
        BRnzp back1
    
    neste0
        ADD R1, R0, #-3
        BRnp neste1
        LD R5, PTR_PLAYERVALUES3_1
        JSR PLACEBET
        BRnzp back1
    
    neste1
        ADD R1, R0, #-2
        BRnp neste2
        LD R5, PTR_PLAYERVALUES2_1
        JSR PLACEBET
        BRnzp back1
    
    neste2 
        ADD R1, R0, #-1
        BRnp back1
        LD R5, PTR_PLAYERVALUES1_1
        JSR PLACEBET
        BRnzp back1
        
        LD R6, PTR_SaveR7_Sp1
        LDR R7, R6, #0
        RET
        
        
    PLACEBET
        LD  R6, PTR_SaveR7_Sp2
        STR R7, R6, #0
        
        LD R0, PTR_playerName
        PUTS
        JSR SHOW_NAME
        
        LEA R0, money1
        PUTS
        JSR CHECKPLAYERMONEY
        
        LD R0, PTR_howMuchToBet
        PUTS
        
        JSR SIFFER2
        STR R4, R5 #16  ;gemmer antal penge man vil spille med
        
        LD R0, PTR_PlayerBetString
        PUTS
        
        GETC
        
        LD R1, b
        ADD R1, R1, R0
        BRnp neste11
        AND R0, R0, #0
        ADD R0, R0, #2  ;lægger 2 ind da wheel definer black som 22
        STR R0, R5, #18 ;gemmer værdien af b inde i plasdsen 18 på playervalues.
        STR R0, R5, #17 ;fortæller at play better. 
        BRnzp SLUT
    
    neste11
        LD R1, r
        ADD R1, R1, R0
        BRnp neste22
        AND R0, R0, #0
        ADD R0, R0, #1  ;lægger 1 ind da wheel definer Rød som 22
        STR R0, R5, #18 ;gemmer værdien af r inde i plasdsen 18 på playervalues.
        STR R0, R5, #17 ;fortæller at play better. 
        BRnzp SLUT
    
    neste22
        LD  R1, g
        ADD R1, R1, R0
        BRnp neste33
        AND R0, R0, #0  ;lægger 0 ind da wheel definer Grøn som 22
        STR R0, R5, #18 ;gemmer værdien af g inde i plasdsen 19 på playervalues.
        STR R0, R5, #17 ;fortæller at play better. 
        BRnzp SLUT
        
    
    neste33
        LD R1, e
        ADD R1, R1, R0
        BRnp neste44
        AND R0, R0, #0
        ADD R0, R0, #2
        STR R0, R5, #19 ;gemmer værdien af e inde i plasdsen 20 på playervalues.
        STR R0, R5, #17 ;fortæller at play better. 
        BRnzp SLUT
        
        
    neste44 
        LD R1, o
        ADD R1, R1, R0
        BRnp neste55
        AND R0, R0, #0
        ADD R0, R0, #1
        STR R0, R5, #19 ;gemmer værdien af o inde i plasdsen 20 på playervalues.
        STR R0, R5, #17 ;fortæller at play better. 
        BRnzp SLUT
        
        
    neste55 
        LD R1, n
        ADD R1, R1, R0
        STR R0, R5, #20 ;gemmer værdien af player indput
        STR R0, R5, #17 ;fortæller at play better.
        BRnp SLUT
        BRnzp skip1
        
        wrong
        LD R0, PTR_wrong_number
        PUTS
        
    skip1
        JSR SIFFER2
        
        LD  R6, checksiffer
        ADD R6, R4, R6
        BRp wrong
        
        STR R4, R5, #20
        BRnzp SLUT
        
    SLUT
        LD R6, PTR_SaveR7_Sp2
        LDR R7, R6, #0
        RET
        
b                   .FILL #-98
r                   .FILL #-114
g                   .FILL #-103
e                   .FILL #-101
o                   .FILL #-111
n                   .FILL #-110
checksiffer         .FILL #-37
PTR_SaveR7_Sp1      .FILL SaveR7_Sp1
PTR_SaveR7_Sp2      .FILL SaveR7_Sp2
PTR_SaveR7_Sp3      .FILL SaveR7_Sp3
PTR_SaveR7_Sp4      .FILL SaveR7_Sp4

    SIFFER2
        LD  R6, PTR_SaveR7_Sp3
        STR R7, R6, #0
        BRnzp begin
        
    begin
        GETC    ; læs første ciffer tier
        OUT
        LD R2, PTR_ASCII_ZERO2_1
        LDR R2, R2, #0
        ADD R3, R0, R2      ; konverter fra ASCII til tal, gem i R3
        
        ; gang R3 med 10
        ADD R4, R3, R3      ; R4 = R3 * 2
        ADD R4, R4, R4      ; R4 = R3 * 4
        ADD R4, R4, R4      ; R4 = R3 * 8
        ADD R4, R4, R3      ; R4 = R3 * 9
        ADD R4, R4, R3      ; R4 = R3 * 10
    
        GETC                ; læs andet ciffer
        OUT
        ADD R0, R0, R2      ; konverter fra ASCII til tal
        ADD R4, R4, R0      ; R4 = tier*10 + ener
    
        LD  R6, PTR_SaveR7_Sp3
        LDR R7, R6, #0
        RET
        
    CHECKPLAYERMONEY
        LD  R6, PTR_SaveR7_Sp3
        STR R7, R6, #0
        
        LDR R1, R5, #5
        ADD R1, R1, #0
        BRnz noMoney
        
        LDR R0, R5, #5      ;loader penge ind
        JSR PRINT_NUMBER
        LD R0, PTR_Enter ;Gør næste linje klar
        PUTS
        BRnzp back000
        
    noMoney
        AND R0, R0, #0
        STR R0, R5, #5
        LD R0, PTR_noMoreMoney
        PUTS
        
        LD  R6, PTR_SaveR7_Sp1
        LDR R7, R6, #0
        RET
        
    back000
        LD  R6, PTR_SaveR7_Sp3
        LDR R7, R6, #0
        RET

PTR_GreenSpotST     .FILL GreenSpotST
PTR_RedSpotST       .FILL RedSpotST
PTR_BlackSpotST     .FILL BlackSpotST
PTR_OddST           .FILL OddST
PTR_EvenST          .FILL EvenST
PTR_ZeroST          .FILL ZeroST     
PTR_playerBet_1     .FILL playerBet
PTR_RAND_COUNTER_1  .FILL RAND_COUNTER 
PTR_VR5             .FILL VR5
PSY_BUTTEN_ADDR     .FILL xFE0F         ; Den fysiske adresse på knappen
PTR_RAND_PSYCON     .FILL RAND_COUNTER
VR0                 .BLKW 1
MAX_PRESS           .FILL #-15000
MINUS_51            .FILL #-51
PLUS_51             .FILL #51
        
    SPIN
        LD  R6, PTR_SaveR7_Sp3_1
        STR R7, R6, #0
        
        
        JSR BUTTENPRESS
        
        JSR RANDOM
        ADD R1, R4, R4      ;Ganger vores random værdi fra R4 3 gange, for at finde det rigte tilsvarende værdi i WHEEL
        ADD R1, R1, R4
        LD  R2, PTR_WHEEL
        ADD R2, R2, R1
        
        ST R2, PTR_VR2      ;R2 gemmer nu den rigtige adresse for hvor tallet i wheel ligger
        
        LDR R0, R2, #0      ;loader 
        JSR PRINT_NUMBER
        LD R0, PTR_Enter ;Gør næste linje klar
        PUTS
        
        LD R2, PTR_VR2
        LDR R0, R2, #1
        BRz GreenSpot
        
        ADD R0, R0, #-1
        BRz RedSpot
        LD R0, PTR_BlackSpotST
        PUTS
        BRnzp next001
        
    RedSpot
        LD R0, PTR_RedSpotST
        PUTS
        BRnzp next001
        
    GreenSpot
        LD R0, PTR_GreenSpotST
        PUTS
    
    next001
        LD R2, PTR_VR2
        LDR R0, R2, #2
        BRz ZeroSpot
        ADD R0, R0, #-1
        BRz Oddspot
        LD R0, PTR_EvenST
        PUTS
        BRnzp next002
        
    OddSpot
        LD R0, PTR_OddST
        PUTS
        BRnzp next002
        
    ZeroSpot
        LD R0, PTR_ZeroST
        PUTS
        
    next002
        JSR CHECKWIN
        
        LD  R6, PTR_SaveR7_Sp3_1
        LDR R7, R6, #0
        RET
    
    BUTTENPRESS
        LD  R6, PTR_SaveR7_Sp4_1
        STR R7, R6, #0
        
        AND R4, R4, #0      ;Nulstiler tælleren
        LD R5, MAX_PRESS    ;loader max væriden ind
     
    waitForPress  
        LDI R0, PSY_BUTTEN_ADDR     ;loader buttenpress ind
        BRz waitForPress
        
    countLoop    
        ADD, R4, R4, #1         ;øger tryk tæller
        
        ADD R1, R4, R5
        Brzp forceRelease       ;hvis knappen holdes ned i mere end ca. 3 sekunder. 
        
        LDI R0, PSY_BUTTEN_ADDR ;Tjek knappen igen
        BRp countLoop
        
    forceRelease
        LD  R2, MINUS_51        ;vi sikre at tiden er melle 10 - 60 sek med % 51
    
    modulo
        ADD R4, R4, R2          ;Trejker 51 fra 
        BRzp modulo
        
        LD R2, PLUS_51          ;lægger 51 til for at få den positive rest
        ADD R4, R4, R2
        
        ADD R4, R4, #10         ;lægger 10 til så vi får interevalet mellem 10 - 60
        
        LD  R1, PTR_RAND_PSYCON ;Vi gemmer værdien af hvor længe hjulet skal spinne, både til RANDOM og til WHEEL
        STR R4, R1, #0          ;gemer værdien.
        
        LD  R6, PTR_SaveR7_Sp4_1
        LDR R7, R6, #0
        RET
    
    RANDOM
        LD  R6, PTR_SaveR7_Sp4_1
        STR R7, R6, #0
        
        LD R3, PTR_RAND_COUNTER_1 ;Lægger randcount sammen med seed
        LDR R3, R3 #0
        LD R0, SEED
        ADD R0, R0, R3
        
        ADD R1, R0, R0      ;R1 = seed * 2 Vi laver en masse gange for at komme op på 75 da c og m skal være indbrydes primiske
        ADD R2, R1, R1      ;R2 = seed * 4 og så skal a-1 = 74 hvilket er delelig med primfaktor 2
        ADD R2, R2, R2      ;R2 = seed * 8
        ADD R0, R0, R2      ;R0 = seed * 9
        ADD R2, R2, R2      ;R2 = seed * 16
        ADD R2, R2, R2      ;R2 = seed * 32
        ADD R2, R2, R2      ;R2 = seed * 64
        ADD R0, R0, R2      ;R0 = seed * 73
        ADD R0, R0, R1      ;R0 = seed * 73 + seed * 2 = seed * 75
        
        LD  R2, LCG_C       ;Tilføjer c
        ADD R0, R0, R2
        
        ST  R0, SEED        ;gemmer det nye seed til næste omgang. 
        
        BRzp startModulo    ;hvis vores tal er negativ 
        NOT R0, R0          ;laver det om til positivt
        ADD R0, R0, #1
        
    
    startModulo
        LD R2, NEG_37       ;Henter værdien -37 
    loopRand
        ADD R3, R0, R2      ;Tester om R0 >= 37
        BRn doneRand        ;Hvis negativ er vi færdige
        ADD R0, R0, R2      ;trækker 37 fra
        BRnzp loopRand      ;Gentager
        
    doneRand
        AND R4, R4, #0      ;gemmer væriden i R4
        ADD R4, R4, R0
        
        
        AND R0, R0, #0
        LD  R1, PTR_RAND_PSYCON ;nulstiller knap værdien.
        STR R0, R1, #0          
        
        LD  R6, PTR_SaveR7_Sp4_1
        LDR R7, R6, #0
        RET
        
    SPINMATION
        
    CHECKWIN
        LD  R6, PTR_SaveR7_Sp4_1
        STR R7, R6, #0
        
        AND R0, R0, #0
    
    nextPlayer
        ST  R0, VR0
        
        LD  R5, PTR_PLAYERVALUES_TABLE      ;Loader hver player values ind
        ADD R5, R5, R0
        LDR R5, R5, #0
        
        LDR R1, R5, #17                     ;finder om player har bettet
        BRn noBetPlaced
                
        LDR R1, R5, #20                     ;lægger værdien af n ind i R1, 
        BRn Next011                         ;chekcer om der er blevet bettet med n
        
        LD  R2, PTR_VR2                     ;Henter adressen på hvor fra Wheel landte
        LDR R3, R2, #0                      ;Tal værdien ligger i R3
        NOT R3, R3                          ;Vender R3 om altså hjulets talværdi
        ADD R3, R3, #1                      ; +1 da 2 signed
        ADD R3, R1, R3
        BRz WinX35
        BRnzp Lost
    
    WinX35
        STI R5, PTR_VR5
        JSR WIN_35
        LDI R5, PTR_VR5
        BRnzp Next011
    Lost
        STI R5, PTR_VR5
        JSR LOST_DAMN
        LDI R5, PTR_VR5
        BRnzp Next011

    Next011  
        LD  R2, PTR_VR2                     ;Henter adressen på hvor fra Wheel landte
        LDR R1, R5, #19                     ;lægger værdien af o/e ind i R1, 
        BRn Next012                         ;checker om værdien er blevet bettet på                        
        
        LD  R2, PTR_VR2                     ;Henter adressen på hvor fra Wheel landte
        LDR R3, R2, #2                      ;Tal værdien ligger i R3
        NOT R3, R3                          ;Vender R3 om altså hjulets talværdi
        ADD R3, R3, #1                      ; +1 da 2 signed
        ADD R3, R1, R3
        BRz WinX2
        BRnzp Lost1
    
    WinX2
        STI R5, PTR_VR5
        JSR WIN_2
        LDI R5, PTR_VR5
        BRnzp Next012
    Lost1
        STI R5, PTR_VR5
        JSR LOST_DAMN
        LDI R5, PTR_VR5
        BRnzp Next012
        
    Next012
        LD  R2, PTR_VR2                     ;Henter adressen på hvor fra Wheel landte
        LDR R1, R5, #18                     ;lægger værdien af o/e ind i R1, 
        BRn Next013                         ;checker om værdien er blevet bettet på                        
        BRz maybeX35
        
        LD  R2, PTR_VR2                     ;Henter adressen på hvor fra Wheel landte
        LDR R3, R2, #1                      ;Tal værdien ligger i R3
        NOT R3, R3                          ;Vender R3 om altså hjulets talværdi
        ADD R3, R3, #1                      ; +1 da 2 signed
        ADD R3, R1, R3
        BRz WinX2_1
        BRnzp Lost2
        
    maybeX35
        LD  R2, PTR_VR2                     ;Henter adressen på hvor fra Wheel landte
        LDR R3, R2, #1                      ;Tal værdien ligger i R3
        NOT R3, R3                          ;Vender R3 om altså hjulets talværdi
        ADD R3, R3, #1                      ; +1 da 2 signed
        ADD R3, R1, R3
        BRz WinX35_1
        BRnzp Lost2
    
    WinX35_1
        STI R5, PTR_VR5
        JSR WIN_35
        LDI R5, PTR_VR5
        BRnzp Next013
    WinX2_1
        STI R5, PTR_VR5
        JSR WIN_2
        LDI R5, PTR_VR5
        BRnzp Next013
    Lost2
        STI R5, PTR_VR5
        JSR LOST_DAMN
        LDI R5, PTR_VR5
        BRnzp Next013
    
    
    Next013
    noBetPlaced
    
    
    ;skal lige huske at lave R0 < 4
    ;aka vi skal også lige gemme den i starten af Jsr her
        LD  R0, VR0
        ADD R0, R0, #1
        AND R6, R6, #0
        ADD R6, R0, #-4
        BRn nextPlayer
    
        LD  R6, PTR_SaveR7_Sp4_1
        LDR R7, R6, #0
        RET
        
    WIN_35
        LD  R6, PTR_SaveR7_Sp5_1
        STR R7, R6, #0
        
        LDR R1, R5, #16     ; R1 = Hent bet-beløbet fra offset #16
    
        ADD R2, R1, R1      ; R2 = Bet * 2
        ADD R3, R2, R2      ; R3 = Bet * 4
        ADD R3, R3, R3      ; R3 = Bet * 8
        ADD R3, R3, R3      ; R3 = Bet * 16
        ADD R3, R3, R3      ; R3 = Bet * 32
        
        ADD R3, R3, R2      ; R3 = Bet * 34
        ADD R4, R3, R1      ; R4 = Bet * 35 
        
        LDR R0, R5, #5      
        ADD R0, R0, R4      
        STR R0, R5, #5
        
        LD  R6, PTR_SaveR7_Sp5_1
        LDR R7, R6, #0
        RET
    
    WIN_2
        LD  R6, PTR_SaveR7_Sp5_1
        STR R7, R6, #0
        
        LDR R1, R5, #16     
        LDR R0, R5, #5      
        ADD R0, R0, R1      
        STR R0, R5, #5     
        
        LD  R6, PTR_SaveR7_Sp5_1
        LDR R7, R6, #0
        RET 
    
    LOST_DAMN
        LD  R6, PTR_SaveR7_Sp5_1
        STR R7, R6, #0
    
        LDR R1, R5, #16     
        LDR R0, R5, #5      
        
        
        NOT R1, R1          
        ADD R1, R1, #1      
        
        
        ADD R0, R0, R1      
        STR R0, R5, #5      
        
        LD  R6, PTR_SaveR7_Sp5_1
        LDR R7, R6, #0
        RET 

    ;WHEEL_SPINNER
PTR_SaveR7_Sp1_1        .FILL SaveR7_Sp1
PTR_SaveR7_Sp2_1        .FILL SaveR7_Sp2
PTR_SaveR7_Sp3_1        .FILL SaveR7_Sp3
PTR_SaveR7_Sp4_1        .FILL SaveR7_Sp4
PTR_SaveR7_Sp5_1        .FILL SaveR7_Sp5
PTR_PLAYERVALUES_TABLE  .FILL PLAYERVALUES_TABLE
PTR_playerBet           .FILL playerBet
PTR_ASCII_ZERO2         .FILL ASCII_ZERO
PTR_SaveR7              .FILL SaveR7
PTR_Enter               .FILL Enter
SEED                    .BLKW 1
LCG_C                   .FILL #74
NEG_37                  .FILL #-37
MODULO_37               .FILL x003F  ; Binært: 0000000000111111
PTR_VR2             .FILL VR2

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
        
        LD R0, PTR_Enter ;Gør næste linje klar
        PUTS
        
        LD R6, PTR_SaveR7_2
        LDR R7, R6, #0
        RET

    SHOW_MONEY
        LD  R6, PTR_SaveR7_2
        STR R7, R6, #0
    
        LDR R0, R5, #5      ;loader penge ind
        JSR PRINT_NUMBER
        
        LD R0, PTR_Enter_1
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

PTR_Enter_1         .FILL Enter
Enter               .STRINGZ "\n"
start               .STRINGZ "PLAY\n" 
startState          .STRINGZ "CHOOSE 1 FOR EDIT PLAYER, CHOOSE 2 FOR BETTING\n"
playerBet           .STRINGZ "\nCHOOSE PLAYER FROM 1 - 4 TO BET, 5 FOR ESCAPE, 6 for spin\n"
PlayerBetString     .STRINGZ "\nb for Black, r for Red, g for green, e for Even, o for odd, n for number between 0 - 37\n"
wrong_number        .STRINGZ "\nNumber not on the wheel\n"
noMoreMoney         .STRINGZ "You have no money. Take another loan\n"
howMuchToBet        .STRINGZ "\nChoose how much money to bet\n"
playerName          .STRINGZ "Player name: "
GreenSpotST         .STRINGZ "Green\n"
RedSpotST           .STRINGZ "Red\n"
BlackSpotST         .STRINGZ "Black\n"
OddST               .STRINGZ "Odd"
EvenST              .STRINGZ "Even"
ZeroST              .STRINGZ "Zero"
ASCII_ZERO          .FILL #-48 
ASCII_TOSTRING      .FILL #48
RAND_COUNTER        .FILL #677

StartPenge          .FILL #100

VR2                 .BLKW 1
VR5                 .BLKW 1
SaveR7              .BLKW 1
SaveR7_2            .BLKW 1
SaveR7_3            .BLKW 1
SaveR7_Sp1          .BLKW 1
SaveR7_Sp2          .BLKW 1
SaveR7_Sp3          .BLKW 1
SaveR7_Sp4          .BLKW 1
SaveR7_Sp5          .BLKW 1
PLAYERVALUES1       .BLKW 21 ;4 tegn + 1 til navn samt 1 til pengene, og 10 til sidste spins, 1 for mængde af penge for bettet, 1 for sæt bet, 1 for bet, 1 for bet
PLAYERVALUES2       .BLKW 21
PLAYERVALUES3       .BLKW 21
PLAYERVALUES4       .BLKW 21
PLAYERVALUES_TABLE  .FILL PLAYERVALUES1
                    .FILL PLAYERVALUES2
                    .FILL PLAYERVALUES3
                    .FILL PLAYERVALUES4

;0-3  = navn (4 tegn)
;4    = null terminator
;5    = penge
;6-15 = sidste 10 spins
;16   = bet beløb
;17   = om der bettes
;18   = bet type b/r/g
;19   = bet type e/o
;20   = bet type n

WHEEL   .FILL #0    ; tal: 0
        .FILL #0    ; farve: grøn
        .FILL #0    ; paritet: ingen

        .FILL #32   ; tal: 32
        .FILL #2    ; farve: sort
        .FILL #2    ; paritet: lige

        .FILL #15   ; tal: 15
        .FILL #2    ; farve: sort
        .FILL #1    ; paritet: ulige

        .FILL #19   ; tal: 19
        .FILL #1    ; farve: rød
        .FILL #1    ; paritet: ulige

        .FILL #4    ; tal: 4
        .FILL #2    ; farve: sort
        .FILL #2    ; paritet: lige

        .FILL #21   ; tal: 21
        .FILL #1    ; farve: rød
        .FILL #1    ; paritet: ulige

        .FILL #2    ; tal: 2
        .FILL #2    ; farve: sort
        .FILL #2    ; paritet: lige

        .FILL #25   ; tal: 25
        .FILL #1    ; farve: rød
        .FILL #1    ; paritet: ulige

        .FILL #17   ; tal: 17
        .FILL #2    ; farve: sort
        .FILL #1    ; paritet: ulige

        .FILL #34   ; tal: 34
        .FILL #1    ; farve: rød
        .FILL #2    ; paritet: lige

        .FILL #6    ; tal: 6
        .FILL #2    ; farve: sort
        .FILL #2    ; paritet: lige

        .FILL #27   ; tal: 27
        .FILL #1    ; farve: rød
        .FILL #1    ; paritet: ulige

        .FILL #13   ; tal: 13
        .FILL #2    ; farve: sort
        .FILL #1    ; paritet: ulige

        .FILL #36   ; tal: 36
        .FILL #1    ; farve: rød
        .FILL #2    ; paritet: lige

        .FILL #11   ; tal: 11
        .FILL #2    ; farve: sort
        .FILL #1    ; paritet: ulige

        .FILL #30   ; tal: 30
        .FILL #1    ; farve: rød
        .FILL #2    ; paritet: lige

        .FILL #8    ; tal: 8
        .FILL #2    ; farve: sort
        .FILL #2    ; paritet: lige

        .FILL #23   ; tal: 23
        .FILL #1    ; farve: rød
        .FILL #1    ; paritet: ulige

        .FILL #10   ; tal: 10
        .FILL #2    ; farve: sort
        .FILL #2    ; paritet: lige

        .FILL #5    ; tal: 5
        .FILL #1    ; farve: rød
        .FILL #1    ; paritet: ulige

        .FILL #24   ; tal: 24
        .FILL #2    ; farve: sort
        .FILL #2    ; paritet: lige

        .FILL #16   ; tal: 16
        .FILL #1    ; farve: rød
        .FILL #2    ; paritet: lige

        .FILL #33   ; tal: 33
        .FILL #2    ; farve: sort
        .FILL #1    ; paritet: ulige

        .FILL #1    ; tal: 1
        .FILL #1    ; farve: rød
        .FILL #1    ; paritet: ulige

        .FILL #20   ; tal: 20
        .FILL #2    ; farve: sort
        .FILL #2    ; paritet: lige

        .FILL #14   ; tal: 14
        .FILL #1    ; farve: rød
        .FILL #2    ; paritet: lige

        .FILL #31   ; tal: 31
        .FILL #2    ; farve: sort
        .FILL #1    ; paritet: ulige

        .FILL #9    ; tal: 9
        .FILL #1    ; farve: rød
        .FILL #1    ; paritet: ulige

        .FILL #22   ; tal: 22
        .FILL #2    ; farve: sort
        .FILL #2    ; paritet: lige

        .FILL #18   ; tal: 18
        .FILL #1    ; farve: rød
        .FILL #2    ; paritet: lige

        .FILL #29   ; tal: 29
        .FILL #2    ; farve: sort
        .FILL #1    ; paritet: ulige

        .FILL #7    ; tal: 7
        .FILL #1    ; farve: rød
        .FILL #1    ; paritet: ulige

        .FILL #28   ; tal: 28
        .FILL #2    ; farve: sort
        .FILL #2    ; paritet: lige

        .FILL #12   ; tal: 12
        .FILL #1    ; farve: rød
        .FILL #2    ; paritet: lige

        .FILL #35   ; tal: 35
        .FILL #2    ; farve: sort
        .FILL #1    ; paritet: ulige

        .FILL #3    ; tal: 3
        .FILL #1    ; farve: rød
        .FILL #1    ; paritet: ulige

        .FILL #26   ; tal: 26
        .FILL #2    ; farve: sort
        .FILL #2    ; paritet: lige




.END