         TITLE 'SQXTR - CALC LD EXTENDED DFP SQUARE ROOT'
*********************************************************************
* 1.  ROUTINE CALLED BY SQXTR.MAC AFTER STORING ARG AT SQXTR+8
* 2.  CALCULATES SQUARE ROOT OF ARG AND REPLACES ARG
* 3.  USES NEWTON-RAPHSON STARTING WITH GUESS OF X**(EXP/2)
* 4.  RESULTS FOR ARG  SQRT(ARG) ITERATIONS
*                 1E4  1E2       1
*                 1E-4 1E-2      1
*                 3.5  1.87...   7
* 5. FIRST GUESS CAN STILL BE IMPROVED BUT MAY NOT BE WORTH OVERHEAD?
*********************************************************************
* 02/28/08 DSH RPI 814 ADD SQXTR.MAC AND SQXTR.MLC AS EXTENDED INS.
*********************************************************************
SQXTR    CSECT 
         USING SQXTR,R15
         ST    R14,SAVER14
         B     SKIPARG
ARG      DS    LD      DFP LD ARGUMENT TO BE REPLACED WITH SQUARE ROOT
SKIPARG  DS    0H
         ST    R12,SAVER12
         LR    R12,R15
         USING SQXTR,R12
         DROP  R15
*MCALL #=     1 LV= 1          STX   F0,SAVEF0      X
         LA    15,SAVEF0
         STD   F0,0(15)
         STD   F0+2,8(15)
*MEXIT #=     1 LV= 1 STX
*MCALL #=     2 LV= 1          STX   F1,SAVEF1      SQRT(X)
         LA    15,SAVEF1
         STD   F1,0(15)
         STD   F1+2,8(15)
*MEXIT #=     2 LV= 1 STX
*MCALL #=     3 LV= 1          STX   F4,SAVEF4      0.5
         LA    15,SAVEF4
         STD   F4,0(15)
         STD   F4+2,8(15)
*MEXIT #=     3 LV= 1 STX
*MCALL #=     4 LV= 1          STX   F5,SAVEF5      WORK
         LA    15,SAVEF5
         STD   F5,0(15)
         STD   F5+2,8(15)
*MEXIT #=     4 LV= 1 STX
*MCALL #=     5 LV= 1          STX   F8,SAVEF8      ERROR LIMIT
         LA    15,SAVEF8
         STD   F8,0(15)
         STD   F8+2,8(15)
*MEXIT #=     5 LV= 1 STX
*MCALL #=     6 LV= 1          LX    F0,ARG         F0 = X
         LA    15,ARG
         LD    F0,0(15)
         LD    F0+2,8(15)
*MEXIT #=     6 LV= 1 LX
         LXR   F1,F0          F1 = X
         EEXTR R0,F1
         AHI   R0,-LD_BIAS
         TMLL  R0,1
         BZ    EXPOK
         LTR   R0,R0
         BM    DIV10
MPY10    DS    0H
*MCALL #=     7 LV= 1          LX    F4,=LD'10'
         LA    15,=LD'10'
         LD    F4,0(15)
         LD    F4+2,8(15)
*MEXIT #=     7 LV= 1 LX
         MXTR  F1,F1,F4       F1 = X * 10 IF EXP +ODD
         B     EXPOK
DIV10    DS    0H
*MCALL #=     8 LV= 1          LX    F4,=LD'.1'
         LA    15,=LD'.1'
         LD    F4,0(15)
         LD    F4+2,8(15)
*MEXIT #=     8 LV= 1 LX
         MXTR  F1,F1,F4       F1 = X / 10 IF EXP -ODD
EXPOK    DS    0H
         SRA   R0,1
         AHI   R0,LD_BIAS
         IEXTR F1,F1,R0       F1 = X**(EXP/2)
*MCALL #=     9 LV= 1          LX    F4,=LD'.5'     F4 = 0.5
         LA    15,=LD'.5'
         LD    F4,0(15)
         LD    F4+2,8(15)
*MEXIT #=     9 LV= 1 LX
*MCALL #=    10 LV= 1          LX    F8,=LD'(MIN)'  F8 = ERROR LIMIT
         LA    15,=LD'(MIN)'
         LD    F8,0(15)
         LD    F8+2,8(15)
*MEXIT #=    10 LV= 1 LX
         LA    R0,0
LOOP     DS    0H
         AHI   R0,1
*MCALL #=    11 LV= 1          CTD   CTD_LD,IN=F1,OUT=DSQXT
CTD_INT128 EQU 1 CONVERT 128 BIT INT TO 45 BYTE EBCDIC DECIMAL
CTD_EH   EQU   2 CONVERT HFP SHORT EH TO 45 BYTE EBCDIC N.N( 6)+ENNNN
CTD_EB   EQU   3 CONVERT BFP SHORT EB TO 45 BYTE EBCDIC N.N( 7)+ENNNN
CTD_DH   EQU   4 CONVERT HFP LONG  DH TO 45 BYTE EBCDIC N.N(14)+ENNNN
CTD_DB   EQU   5 CONVERT BFP LONG  DB TO 45 BYTE EBCDIC N.N(15)+ENNNN
CTD_LH   EQU   6 CONVERT HFP EXT.  LH TO 45 BYTE EBCDIC N.N(34)+ENNNN
CTD_LB   EQU   7 CONVERT BFP EXT.  LB TO 45 BYTE EBCDIC N.N(34)+ENNNN
CTD_DD   EQU   8 CONVERT DFP LONG  DD TO 45 BYTE EBCDIC N.N(16)+ENNNN
CTD_ED   EQU   9 CONVERT DFP SHORT ED TO 45 BYTE EBCDIC N.N( 7)+ENNNN
CTD_LD   EQU  10 CONVERT DFP EXT.  LD TO 45 BYTE EBCDIC N.N(34)+ENNNN
         LA    1,=A(CTD_LD,F1,DSQXT)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=    11 LV= 1 CTD
*MCALL #=    12 LV= 1          SNAP  ID=(0),PDATA=,STORAGE=(DSQXT,DSQXTX
               +45)
         L     14,=A(DSQXT)
         L     15,=A(DSQXT+45)
*MCALL #=    13 LV= 2          ZOPTLR 0,0                      RPI 623
*MEXIT #=    13 LV= 2 ZOPTLR
         IILH 0,32768               RPI158
         LA    1,0
         SVC   51  SNAP DUMP R0=FLAGS,ID,R1=A(TEXT),R14-15=A(LOW,HIGH)
*MEXIT #=    12 LV= 1 SNAP
         DXTR  F5,F0,F1
         AXTR  F5,F5,F1
         MXTR  F1,F5,F4       F1 = (X/SQRT(X)+SQRT(X))*.5
         MXTR  F5,F1,F1       F5 = SQRT(X)*SQRT(X)
         CXTR  F5,F0
         BM    NEGERR
         SXTR  F5,F5,F0       F5 = DIFF SQRT(X)*SQRT(X) - X
         CXTR  F5,F8
         BH    LOOP           REPEAT UNTIL ERROR < LIMIT
         B     EXIT
NEGERR   DS    0H
         SXTR  F5,F0,F5       F9 = X - SQRT(X)*SQRT(X)
         CXTR  F9,F8
         BH    LOOP           REPEAT UNTIL ERROR < LIMIT
EXIT     DS    0H
*MCALL #=    14 LV= 1          STX   F1,ARG
         LA    15,ARG
         STD   F1,0(15)
         STD   F1+2,8(15)
*MEXIT #=    14 LV= 1 STX
*MCALL #=    15 LV= 1          LX    F0,SAVEF0
         LA    15,SAVEF0
         LD    F0,0(15)
         LD    F0+2,8(15)
*MEXIT #=    15 LV= 1 LX
*MCALL #=    16 LV= 1          LX    F1,SAVEF1
         LA    15,SAVEF1
         LD    F1,0(15)
         LD    F1+2,8(15)
*MEXIT #=    16 LV= 1 LX
*MCALL #=    17 LV= 1          LX    F4,SAVEF4
         LA    15,SAVEF4
         LD    F4,0(15)
         LD    F4+2,8(15)
*MEXIT #=    17 LV= 1 LX
*MCALL #=    18 LV= 1          LX    F5,SAVEF5
         LA    15,SAVEF5
         LD    F5,0(15)
         LD    F5+2,8(15)
*MEXIT #=    18 LV= 1 LX
*MCALL #=    19 LV= 1          LX    F8,SAVEF8
         LA    15,SAVEF8
         LD    F8,0(15)
         LD    F8+2,8(15)
*MEXIT #=    19 LV= 1 LX
         LA    R15,SQXTR
         L     R14,SAVER14
         L     R12,SAVER12
         BR    R14
LD_BIAS  EQU   6176   S,C5,BXDF12,CCF110  DFP EXP BIAS
SAVER12  DS    F
SAVER14  DS    F
SAVEF0   DS    LD 0+2
SAVEF1   DS    LD 1+3
SAVEF4   DS    LD 4+6
SAVEF5   DS    LD 5+7
SAVEF8   DS    LD 8+10
*MCALL #=    20 LV= 1          EQUREGS REGS=FPR
F0     EQU 0
F1     EQU 1
F2     EQU 2
F3     EQU 3
F4     EQU 4
F5     EQU 5
F6     EQU 6
F7     EQU 7
F8     EQU 8
F9     EQU 9
F10    EQU 10
F11    EQU 11
F12    EQU 12
F13    EQU 13
F14    EQU 14
F15    EQU 15
*MEXIT #=    20 LV= 1 EQUREGS
*MCALL #=    21 LV= 1          EQUREGS REGS=GPR
R0     EQU 0
R1     EQU 1
R2     EQU 2
R3     EQU 3
R4     EQU 4
R5     EQU 5
R6     EQU 6
R7     EQU 7
R8     EQU 8
R9     EQU 9
R10    EQU 10
R11    EQU 11
R12    EQU 12
R13    EQU 13
R14    EQU 14
R15    EQU 15
*MEXIT #=    21 LV= 1 EQUREGS
DSQXT    DS      CL45
         END 
