*********************************************************************
* Copyright 2006 Automated Software Tools Corporation               *
* This source code is part of z390 assembler/emulator package       *
* The z390 package is distributed under GNU general public license  *
* Author - Don Higgins                                              *
* Date   - 07/17/07                                                 *
*********************************************************************
* FPCONMFC IS LINKAGE=MF INTERFACE CALLED BY CTD AND CFD MACROS TO
* TO CALL FPCONVRT TO PERFORM FP CONVERSIONS USING MAINFRAME
* INSTRUCTIONS VERSUS Z390 SVC 170 AND 170 FOR LINKAGE=SVC DEFAULT.
*
* NOTE THE ARCHLVL 1-5 ON THE FPCONVRT MACRO IN THIS PROGRAM USED
* TO DEFINE FPCON CONTROL BLOCK MUST MATCH THE ARCHLVL 2-5 IN
* FPCONVRT.MLC USED TO ASSEMBLE THE CODE.  BOTH THIS FPCONMFC.MLC
* DRIVER PROGRAM AND FPCONVRT.MLC USED TO ASSEMBLE FPCONVRT USE
* SHARED MACRO ARCHLVL TO SET GBLA &ARCHLVL SETTING FOR FPCONVRT
* GENERATION MACRO CALL.  THE &ARCHLVL IS ALSO USED TO SWITCH
* BETWEEN 31 BIT AND 64 BIT SAVE AREA AND PARM ADDRESS FIELDS.
*
*********************************************************************
* 07/17/06 RPI 374 - add FPCONMFC interface to FPCONVRT routines
* 07/21/06 RPI 379 - use compound DO conditions in (...)
* 08/04/06 RPI 391 - replace trailing output nulls with spaces
* 12/11/06 RPI 514 - add DD, ED, and LD DFP conversion support
* 04/27/07 RPI 600 - add GBLA &ARCHLVL to FPCON_CALL
* 12/07/07 RPI 749 - move LBUFF to front of pgm to avoid lit errors
* 03/27/08 RPI 829 - clearn high bits of 64 bit register parm
* 04/25/11 RPI 1161 - remove & from ARCHLVL macro comments
*********************************************************************
         PRINT DATA
         COPY  ASMMSP       STRUCTURED PROGRAM MACROS AND EQUS
         COPY ZSTRMAC  Z390 STRUCTURED PROGRAMMING MACROS
*MCALL #=     1 LV= 1          ARCHLVL            GET SHARED ARCHLVL=1-X
               5 (SEE FPCONVRT.MAC)
         MNOTE 'ARCHLVL=7 ARCHSFX=G'
*MEXIT #=     1 LV= 1 ARCHLVL
         MACRO
         FPCON_CALL
         GBLA  &ARCHLVL          RPI 600
         AIF   (&ARCHLVL GT 2).ZOS_CALL
.OS_CALL ANOP
         LA    R1,=A(FPCON)      R1 > 32 BIT ADDR
         L     R15,=V(FPCONVRT)
         BASR  R14,R15           CALL USING STD SUBENTRY SAVE
         AGO   .END_CALL
.ZOS_CALL ANOP
         SGR   R1,R1             CLEAR HIGH BITS RPI 829
         LA    R1,=AD(FPCON)     R1 > 64 BIT ADDR
         LG    R15,=VD(FPCONVRT)
         ST    R13,MYSAVE        SAVE CALLERS 18F SAVE AREA
         LA    R13,BIGSAVE       FORMAT 4 - 18FD SAVE AREA
         BASR  R14,R15           CALL USING BIG SAVE AREA
         L     R13,MYSAVE-*(R14) RESTORE CALLERS SAVE AREA
.END_CALL ANOP
         MEND
*MCALL #=     2 LV= 1 FPCONMFC SUBENTRY 
FPCONMFC CSECT 
         STM   14,12,12(13)
         BAL   15,104(15)
         DC    18F'0'
         DC    CL8'FPCONMFC'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
         USING FPCONMFC+8,13
*MEXIT #=     2 LV= 1 SUBENTRY
LBUFF    EQU    45 CONSTANT PER CFD AND CTD MACRO DEFINITIONS
         SGR   R5,R5 CLEAR HIGH BITS FOR FPCONVRT USE RPI 829
         LM    R3,R5,0(R1)  R3=TYPE, R4=ARG2, R5=ARG3
         STC   R3,TYPE
*MCALL #=     3 LV= 1          IF    (CLI,TYPE,GE,21)     RPI 514
*MCALL #=     4 LV= 2          ZSTREQU 
         PUSH  PRINT,NOPRINT
         PRINT OFF,NOPRINT
H        EQU   2
L        EQU   4
E        EQU   8
NH       EQU   13
NL       EQU   11
NE       EQU   7
O        EQU   1
P        EQU   2
M        EQU   4
Z        EQU   8
NP       EQU   13
NM       EQU   11
NZ       EQU   7
NO       EQU   14
EQ       EQU   8
GT       EQU   2
LT       EQU   4
GE       EQU   11
LE       EQU   13
         POP   PRINT,NOPRINT
*MEXIT #=     4 LV= 2 ZSTREQU
         CLI   TYPE,21
         BC    15-GE,#@IF_1_2
*MEXIT #=     3 LV= 1 IF
               BAS   R12,CFD_RTNS
*MCALL #=     5 LV= 1          ELSE 
*MCALL #=     6 LV= 2          ZSTREQU 
*MEXIT #=     6 LV= 2 ZSTREQU
        B      #@IF_1_E
#@IF_1_2                                                 DS 0H
*MEXIT #=     5 LV= 1 ELSE
               BAS   R12,CTD_RTNS
*MCALL #=     7 LV= 1          ENDIF 
*MCALL #=     8 LV= 2          ZSTREQU 
*MEXIT #=     8 LV= 2 ZSTREQU
#@IF_1_E                         DS 0H
*MEXIT #=     7 LV= 1 ENDIF
*MCALL #=     9 LV= 1          SUBEXIT RC=(R15)
*MCALL #=    10 LV= 2          ZOPTLR 15,(R15)
*MEXIT #=    10 LV= 2 ZOPTLR
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=     9 LV= 1 SUBEXIT
*********************************************************************
* Level 1 support routines using R12
*********************************************************************
*
* CONVERT FROM DECIMAL R4=A(OUT), R5=A(IN)
*
CFD_RTNS EQU   *
         LM    R14,R1,=A(Fpcon,FpconLength,0,0)
         MVCL  R14,R0
         LA    R15,0
*MCALL #=    11 LV= 1          IF     (CLI,TYPE,EQ,21) CFD INT128 FROM X
               D40
*MCALL #=    12 LV= 2          ZSTREQU 
*MEXIT #=    12 LV= 2 ZSTREQU
         CLI   TYPE,21
         BC    15-EQ,#@IF_2_2
*MEXIT #=    11 LV= 1 IF
               BAS   R11,CFD_GET_INT128
*MCALL #=    13 LV= 1          ELSEIF (CLI,TYPE,EQ,22) CFD EH     FROM X
               D40
*MCALL #=    14 LV= 2          ZSTREQU 
*MEXIT #=    14 LV= 2 ZSTREQU
         B     #@IF_2_E
#@IF_2_2                                                 DS 0H
         CLI   TYPE,22
         BC    15-EQ,#@IF_2_4
*MEXIT #=    13 LV= 1 ELSEIF
               MVI   FpconValueLen,FpconValueLenE
               MVI   FpconBase,FpconBase16
               BAS   R11,CFD_CALL
               LE    F0,FpconValueE  F0 =  EH
               STE   F0,0(R4)        STORE EH
*MCALL #=    15 LV= 1          ELSEIF (CLI,TYPE,EQ,23) CFD EB     FROM X
               D40
*MCALL #=    16 LV= 2          ZSTREQU 
*MEXIT #=    16 LV= 2 ZSTREQU
         B     #@IF_2_E
#@IF_2_4                                                 DS 0H
         CLI   TYPE,23
         BC    15-EQ,#@IF_2_6
*MEXIT #=    15 LV= 1 ELSEIF
               MVI   FpconValueLen,FpconValueLenE
               MVI   FpconBase,FpconBase2
               BAS   R11,CFD_CALL
               LE    F0,FpconValueE  F0 =  EB
               STE   F0,0(R4)        STORE EB
*MCALL #=    17 LV= 1          ELSEIF (CLI,TYPE,EQ,24) CFD DH     FROM X
               D40
*MCALL #=    18 LV= 2          ZSTREQU 
*MEXIT #=    18 LV= 2 ZSTREQU
         B     #@IF_2_E
#@IF_2_6                                                 DS 0H
         CLI   TYPE,24
         BC    15-EQ,#@IF_2_8
*MEXIT #=    17 LV= 1 ELSEIF
               MVI   FpconValueLen,FpconValueLenD
               MVI   FpconBase,FpconBase16
               BAS   R11,CFD_CALL
               LD    F0,FpconValueD  F0 =  DH
               STD   F0,0(R4)        STORE DH
*MCALL #=    19 LV= 1          ELSEIF (CLI,TYPE,EQ,25) CFD DB     FROM X
               D40
*MCALL #=    20 LV= 2          ZSTREQU 
*MEXIT #=    20 LV= 2 ZSTREQU
         B     #@IF_2_E
#@IF_2_8                                                 DS 0H
         CLI   TYPE,25
         BC    15-EQ,#@IF_2_10
*MEXIT #=    19 LV= 1 ELSEIF
               MVI   FpconValueLen,FpconValueLenD
               MVI   FpconBase,FpconBase2
               BAS   R11,CFD_CALL
               LD    F0,FpconValueD  F0 =  DB
               STD   F0,0(R4)        STORE DB
*MCALL #=    21 LV= 1          ELSEIF (CLI,TYPE,EQ,26) CFD LH     FROM X
               D40
*MCALL #=    22 LV= 2          ZSTREQU 
*MEXIT #=    22 LV= 2 ZSTREQU
         B     #@IF_2_E
#@IF_2_10                                                DS 0H
         CLI   TYPE,26
         BC    15-EQ,#@IF_2_12
*MEXIT #=    21 LV= 1 ELSEIF
               MVI   FpconValueLen,FpconValueLenL
               MVI   FpconBase,FpconBase16
               BAS   R11,CFD_CALL
               LD    F0,FpconValueL    F0 =  LH1
               LD    F2,FpconValueL+8  F2 =  LH2
               STD   F0,0(R4)        STORE   LB1
               STD   F2,8(R4)        STORE   LB2
*MCALL #=    23 LV= 1          ELSEIF (CLI,TYPE,EQ,27) CFD LB     FROM X
               D40
*MCALL #=    24 LV= 2          ZSTREQU 
*MEXIT #=    24 LV= 2 ZSTREQU
         B     #@IF_2_E
#@IF_2_12                                                DS 0H
         CLI   TYPE,27
         BC    15-EQ,#@IF_2_14
*MEXIT #=    23 LV= 1 ELSEIF
               MVI   FpconValueLen,FpconValueLenL
               MVI   FpconBase,FpconBase2
               BAS   R11,CFD_CALL
               LD    F0,FpconValueL    F0 =  LB1
               LD    F2,FpconValueL+8  F2 =  LB2
               STD   F0,0(R4)        STORE   LB1
               STD   F2,8(R4)        STORE   LB2
*MCALL #=    25 LV= 1          ELSEIF (CLI,TYPE,EQ,28) CFD DD     FROM X
               D40
*MCALL #=    26 LV= 2          ZSTREQU 
*MEXIT #=    26 LV= 2 ZSTREQU
         B     #@IF_2_E
#@IF_2_14                                                DS 0H
         CLI   TYPE,28
         BC    15-EQ,#@IF_2_16
*MEXIT #=    25 LV= 1 ELSEIF
               MVI   FpconValueLen,FpconValueLenD
               MVI   FpconBase,FpconBase10
               BAS   R11,CFD_CALL
               LD    F0,FpconValueD  F0 =  DD
               STD   F0,0(R4)        STORE DD
*MCALL #=    27 LV= 1          ELSEIF (CLI,TYPE,EQ,29) CFD ED     FROM X
               D40
*MCALL #=    28 LV= 2          ZSTREQU 
*MEXIT #=    28 LV= 2 ZSTREQU
         B     #@IF_2_E
#@IF_2_16                                                DS 0H
         CLI   TYPE,29
         BC    15-EQ,#@IF_2_18
*MEXIT #=    27 LV= 1 ELSEIF
               MVI   FpconValueLen,FpconValueLenE
               MVI   FpconBase,FpconBase10
               BAS   R11,CFD_CALL
               LE    F0,FpconValueE  F0 =  ED
               STE   F0,0(R4)        STORE ED
*MCALL #=    29 LV= 1          ELSEIF (CLI,TYPE,EQ,30) CFD LD     FROM X
               D40
*MCALL #=    30 LV= 2          ZSTREQU 
*MEXIT #=    30 LV= 2 ZSTREQU
         B     #@IF_2_E
#@IF_2_18                                                DS 0H
         CLI   TYPE,30
         BC    15-EQ,#@IF_2_20
*MEXIT #=    29 LV= 1 ELSEIF
               MVI   FpconValueLen,FpconValueLenL
               MVI   FpconBase,FpconBase10
               BAS   R11,CFD_CALL
               LD    F0,FpconValueL    F0 =  LD1
               LD    F2,FpconValueL+8  F2 =  LD2
               STD   F0,0(R4)        STORE   LD1
               STD   F2,8(R4)        STORE   LD2
*MCALL #=    31 LV= 1          ELSE 
*MCALL #=    32 LV= 2          ZSTREQU 
*MEXIT #=    32 LV= 2 ZSTREQU
        B      #@IF_2_E
#@IF_2_20                                                DS 0H
*MEXIT #=    31 LV= 1 ELSE
               LA   R15,12
*MCALL #=    33 LV= 1          ENDIF 
*MCALL #=    34 LV= 2          ZSTREQU 
*MEXIT #=    34 LV= 2 ZSTREQU
#@IF_2_E                         DS 0H
*MEXIT #=    33 LV= 1 ENDIF
         BR    R12
*
* CONVERT TO DECIMAL
*
CTD_RTNS EQU   *
         LM    R14,R1,=A(Fpcon,FpconLength,0,0) ZERO FPCON
         MVCL  R14,R0
         MVC   0(LBUFF,R5),=(LBUFF)C' '         CLEAR OUTPUT
         LA    R15,0
*MCALL #=    35 LV= 1          IF     (CLI,TYPE,EQ,1) CFD INT128 TO   DX
               40
*MCALL #=    36 LV= 2          ZSTREQU 
*MEXIT #=    36 LV= 2 ZSTREQU
         CLI   TYPE,1
         BC    15-EQ,#@IF_3_2
*MEXIT #=    35 LV= 1 IF
               BAL   R11,CTD_PUT_INT128
*MCALL #=    37 LV= 1          ELSEIF (CLI,TYPE,EQ,2) CFD EH     TO   DX
               40
*MCALL #=    38 LV= 2          ZSTREQU 
*MEXIT #=    38 LV= 2 ZSTREQU
         B     #@IF_3_E
#@IF_3_2                                                 DS 0H
         CLI   TYPE,2
         BC    15-EQ,#@IF_3_4
*MEXIT #=    37 LV= 1 ELSEIF
               MVI   FpconValueLen,FpconValueLenE
               MVI   FpconBase,FpconBase16
               MVC   FpconMaxLeading,=H'7'
               MVC   FpconMinDecimal,=H'-1'
               LE    F0,0(R4)        F0 =  EH
               STE   F0,FpconValueE store  EH
               BAS   R11,CTD_CALL
*MCALL #=    39 LV= 1          ELSEIF (CLI,TYPE,EQ,3) CFD EB     TO   DX
               40
*MCALL #=    40 LV= 2          ZSTREQU 
*MEXIT #=    40 LV= 2 ZSTREQU
         B     #@IF_3_E
#@IF_3_4                                                 DS 0H
         CLI   TYPE,3
         BC    15-EQ,#@IF_3_6
*MEXIT #=    39 LV= 1 ELSEIF
               MVI   FpconValueLen,FpconValueLenE
               MVI   FpconBase,FpconBase2
               MVC   FpconMaxLeading,=H'7'
               MVC   FpconMinDecimal,=H'-1'
               LE    F0,0(R4)        F0 =  EB
               STE   F0,FpconValueE store  EB
               BAS   R11,CTD_CALL
*MCALL #=    41 LV= 1          ELSEIF (CLI,TYPE,EQ,4) CFD DH     TO   DX
               40
*MCALL #=    42 LV= 2          ZSTREQU 
*MEXIT #=    42 LV= 2 ZSTREQU
         B     #@IF_3_E
#@IF_3_6                                                 DS 0H
         CLI   TYPE,4
         BC    15-EQ,#@IF_3_8
*MEXIT #=    41 LV= 1 ELSEIF
               MVI   FpconValueLen,FpconValueLenD
               MVI   FpconBase,FpconBase16
               MVC   FpconMaxLeading,=H'15'
               MVC   FpconMinDecimal,=H'-1'
               LD    F0,0(R4)        F0 =  DH
               STD   F0,FpconValueD store  DH
               BAS   R11,CTD_CALL
*MCALL #=    43 LV= 1          ELSEIF (CLI,TYPE,EQ,5) CFD DB     TO   DX
               40
*MCALL #=    44 LV= 2          ZSTREQU 
*MEXIT #=    44 LV= 2 ZSTREQU
         B     #@IF_3_E
#@IF_3_8                                                 DS 0H
         CLI   TYPE,5
         BC    15-EQ,#@IF_3_10
*MEXIT #=    43 LV= 1 ELSEIF
               MVI   FpconValueLen,FpconValueLenD
               MVI   FpconBase,FpconBase2
               MVC   FpconMaxLeading,=H'15'
               MVC   FpconMinDecimal,=H'-1'
               LD    F0,0(R4)        F0 =  DB
               STD   F0,FpconValueD store  DB
               BAS   R11,CTD_CALL
*MCALL #=    45 LV= 1          ELSEIF (CLI,TYPE,EQ,6) CFD LH     TO   DX
               40
*MCALL #=    46 LV= 2          ZSTREQU 
*MEXIT #=    46 LV= 2 ZSTREQU
         B     #@IF_3_E
#@IF_3_10                                                DS 0H
         CLI   TYPE,6
         BC    15-EQ,#@IF_3_12
*MEXIT #=    45 LV= 1 ELSEIF
               MVI   FpconValueLen,FpconValueLenL
               MVI   FpconBase,FpconBase16
               MVC   FpconMaxLeading,=H'34'
               MVC   FpconMinDecimal,=H'-1'
               LD    F0,0(R4)        F0 =  LH1
               LD    F2,8(R4)        F2 =  LH2
               STD   F0,FpconValueD   store  LH1
               STD   F2,FpconValueD+8 store  LH2
               BAS   R11,CTD_CALL
*MCALL #=    47 LV= 1          ELSEIF (CLI,TYPE,EQ,7) CFD LB     TO   DX
               40
*MCALL #=    48 LV= 2          ZSTREQU 
*MEXIT #=    48 LV= 2 ZSTREQU
         B     #@IF_3_E
#@IF_3_12                                                DS 0H
         CLI   TYPE,7
         BC    15-EQ,#@IF_3_14
*MEXIT #=    47 LV= 1 ELSEIF
               MVI   FpconValueLen,FpconValueLenL
               MVI   FpconBase,FpconBase2
               MVC   FpconMaxLeading,=H'34'
               MVC   FpconMinDecimal,=H'-1'
               LD    F0,0(R4)        F0 =  LB1
               LD    F2,8(R4)        F2 =  LB2
               STD   F0,FpconValueD   store  LB1
               STD   F2,FpconValueD+8 store  LB2
               BAS   R11,CTD_CALL
*MCALL #=    49 LV= 1          ELSEIF (CLI,TYPE,EQ,8) CFD DD     TO   DX
               40
*MCALL #=    50 LV= 2          ZSTREQU 
*MEXIT #=    50 LV= 2 ZSTREQU
         B     #@IF_3_E
#@IF_3_14                                                DS 0H
         CLI   TYPE,8
         BC    15-EQ,#@IF_3_16
*MEXIT #=    49 LV= 1 ELSEIF
               MVI   FpconValueLen,FpconValueLenD
               MVI   FpconBase,FpconBase10
               MVC   FpconMaxLeading,=H'16'
               MVC   FpconMinDecimal,=H'-1'
               LD    F0,0(R4)        F0 =  DD
               STD   F0,FpconValueD store  DD
               BAS   R11,CTD_CALL
*MCALL #=    51 LV= 1          ELSEIF (CLI,TYPE,EQ,9) CFD ED     TO   DX
               40
*MCALL #=    52 LV= 2          ZSTREQU 
*MEXIT #=    52 LV= 2 ZSTREQU
         B     #@IF_3_E
#@IF_3_16                                                DS 0H
         CLI   TYPE,9
         BC    15-EQ,#@IF_3_18
*MEXIT #=    51 LV= 1 ELSEIF
               MVI   FpconValueLen,FpconValueLenE
               MVI   FpconBase,FpconBase10
               MVC   FpconMaxLeading,=H'7'
               MVC   FpconMinDecimal,=H'-1'
               LE    F0,0(R4)        F0 =  ED
               STE   F0,FpconValueE store  ED
               BAS   R11,CTD_CALL
*MCALL #=    53 LV= 1          ELSEIF (CLI,TYPE,EQ,10) CFD LD     TO   X
               D40
*MCALL #=    54 LV= 2          ZSTREQU 
*MEXIT #=    54 LV= 2 ZSTREQU
         B     #@IF_3_E
#@IF_3_18                                                DS 0H
         CLI   TYPE,10
         BC    15-EQ,#@IF_3_20
*MEXIT #=    53 LV= 1 ELSEIF
               MVI   FpconValueLen,FpconValueLenL
               MVI   FpconBase,FpconBase10
               MVC   FpconMaxLeading,=H'34'
               MVC   FpconMinDecimal,=H'-1'
               LD    F0,0(R4)        F0 =  LD1
               LD    F2,8(R4)        F2 =  LD2
               STD   F0,FpconValueD   store  LD1
               STD   F2,FpconValueD+8 store  LD2
               BAS   R11,CTD_CALL
*MCALL #=    55 LV= 1          ELSE 
*MCALL #=    56 LV= 2          ZSTREQU 
*MEXIT #=    56 LV= 2 ZSTREQU
        B      #@IF_3_E
#@IF_3_20                                                DS 0H
*MEXIT #=    55 LV= 1 ELSE
               LA   R15,12
               BR   R12
*MCALL #=    57 LV= 1          ENDIF 
*MCALL #=    58 LV= 2          ZSTREQU 
*MEXIT #=    58 LV= 2 ZSTREQU
#@IF_3_E                         DS 0H
*MEXIT #=    57 LV= 1 ENDIF
         BR    R12
*********************************************************************
* Level 2 support routines using R11
*********************************************************************
*
* CFD GET 128 BIT INTEGER FROM DECIMAL
*
CFD_GET_INT128 EQU *
         MVI   SIGN,C'+'
*MCALL #=    59 LV= 1          IF    (TRT,0(LBUFF,R5),NZ,TRTTAB_MINUS)
*MCALL #=    60 LV= 2          ZSTREQU 
*MEXIT #=    60 LV= 2 ZSTREQU
         TRT   0(LBUFF,R5),TRTTAB_MINUS
         BC    15-NZ,#@IF_4_2
*MEXIT #=    59 LV= 1 IF
               MVI SIGN,C'-'
*MCALL #=    61 LV= 1          ENDIF 
*MCALL #=    62 LV= 2          ZSTREQU 
*MEXIT #=    62 LV= 2 ZSTREQU
#@IF_4_2                                                 DS 0H
*MEXIT #=    61 LV= 1 ENDIF
*MCALL #=    63 LV= 1          IF    (TRT,0(LBUFF,R5),NZ,TRTTAB_DIGITS)
*MCALL #=    64 LV= 2          ZSTREQU 
*MEXIT #=    64 LV= 2 ZSTREQU
         TRT   0(LBUFF,R5),TRTTAB_DIGITS
         BC    15-NZ,#@IF_5_2
*MEXIT #=    63 LV= 1 IF
               LR  R7,R1   R7 = ADDR FIRST DIGIT
               LA  R1,LBUFF(R5)
               SR  R1,R7
               BCTR R1,0
*MCALL #=    65 LV= 1                IF  (EX,R1,EQ,TRTSP)
*MCALL #=    66 LV= 2          ZSTREQU 
*MEXIT #=    66 LV= 2 ZSTREQU
         EX    R1,TRTSP
         BC    15-EQ,#@IF_6_2
*MEXIT #=    65 LV= 1 IF
                   LA   R1,LBUFF(R5)
*MCALL #=    67 LV= 1                ENDIF 
*MCALL #=    68 LV= 2          ZSTREQU 
*MEXIT #=    68 LV= 2 ZSTREQU
#@IF_6_2                                                 DS 0H
*MEXIT #=    67 LV= 1 ENDIF
               SR   R1,R7
               LR   R2,R1           R2 = #DIGITS
*MCALL #=    69 LV= 1                IF   (CHI,R2,GT,13)
*MCALL #=    70 LV= 2          ZSTREQU 
*MEXIT #=    70 LV= 2 ZSTREQU
         CHI   R2,13
         BC    15-GT,#@IF_7_2
*MEXIT #=    69 LV= 1 IF
                    AHI   R2,-13
                    LA    R1,0(R2,R7)
                    PACK  PWORK,0(13,R1)
                    SGR   R8,R8
                    CVBG  R9,PWORK  R8-R9 = LAST 13 DIGITS
*MCALL #=    71 LV= 1                     IF    (CHI,R2,GT,13)
*MCALL #=    72 LV= 2          ZSTREQU 
*MEXIT #=    72 LV= 2 ZSTREQU
         CHI   R2,13
         BC    15-GT,#@IF_8_2
*MEXIT #=    71 LV= 1 IF
                          AHI   R2,-13
                          LA    R1,0(R2,R7)
                          PACK  PWORK,0(13,R1)
                          CVBG  R1,PWORK
                          MLG   R0,=FL8'1E13'
                          ALGR  R9,R1
                          ALCGR R8,R0 R8-R9 = LAST 26 DIGITS
                          BCTR  R2,0
                          EX    R2,PACK
                          CVBG  R1,PWORK  R1  = FIRST 1-13 DIGITS
                          LGR   R14,R1    SAVE  FIRST 1-13 DIGITS
                          MLG   R0,INT_1E26+8 R0:R1 = X * LOW 10**26
                          ALGR  R9,R1
                          ALCGR R8,R0     R8:R9 27-39 DIGIT INT128
                          LGR   R1,R14
                          MLG   R0,INT_1E26   R0:R1 = X * HIGH 10**26
                          ALGR  R8,R1          ADD R1 TO UPPER HALF
*MCALL #=    73 LV= 1                     ELSE 
*MCALL #=    74 LV= 2          ZSTREQU 
*MEXIT #=    74 LV= 2 ZSTREQU
        B      #@IF_8_E
#@IF_8_2                                                 DS 0H
*MEXIT #=    73 LV= 1 ELSE
                          BCTR  R2,0
                          EX    R2,PACK
                          CVBG  R1,PWORK
                          MLG   R0,=FL8'1E13'
                          ALGR  R9,R1
                          ALCGR R8,R0 R8-R9 = 14-26 DIGIT INT128
*MCALL #=    75 LV= 1                     ENDIF 
*MCALL #=    76 LV= 2          ZSTREQU 
*MEXIT #=    76 LV= 2 ZSTREQU
#@IF_8_E                         DS 0H
*MEXIT #=    75 LV= 1 ENDIF
*MCALL #=    77 LV= 1                ELSE 
*MCALL #=    78 LV= 2          ZSTREQU 
*MEXIT #=    78 LV= 2 ZSTREQU
        B      #@IF_7_E
#@IF_7_2                                                 DS 0H
*MEXIT #=    77 LV= 1 ELSE
                    BCTR  R2,0
                    EX    R2,PACK
                    SGR   R8,R8
                    CVBG  R9,PWORK     R8:R9 = 1-13 DIGIT INT128
*MCALL #=    79 LV= 1                ENDIF 
*MCALL #=    80 LV= 2          ZSTREQU 
*MEXIT #=    80 LV= 2 ZSTREQU
#@IF_7_E                         DS 0H
*MEXIT #=    79 LV= 1 ENDIF
*MCALL #=    81 LV= 1          ELSE 
*MCALL #=    82 LV= 2          ZSTREQU 
*MEXIT #=    82 LV= 2 ZSTREQU
        B      #@IF_5_E
#@IF_5_2                                                 DS 0H
*MEXIT #=    81 LV= 1 ELSE
               LA   R15,12      NO DIGITS FOUND
               BR   R11
*MCALL #=    83 LV= 1          ENDIF 
*MCALL #=    84 LV= 2          ZSTREQU 
*MEXIT #=    84 LV= 2 ZSTREQU
#@IF_5_E                         DS 0H
*MEXIT #=    83 LV= 1 ENDIF
*MCALL #=    85 LV= 1          IF    (CLI,SIGN,EQ,C'-')
*MCALL #=    86 LV= 2          ZSTREQU 
*MEXIT #=    86 LV= 2 ZSTREQU
         CLI   SIGN,C'-'
         BC    15-EQ,#@IF_9_2
*MEXIT #=    85 LV= 1 IF
               BAS  R10,COMP128 COMPLIMENT 128 BIT INT IN R8:R9
*MCALL #=    87 LV= 1          ENDIF 
*MCALL #=    88 LV= 2          ZSTREQU 
*MEXIT #=    88 LV= 2 ZSTREQU
#@IF_9_2                                                 DS 0H
*MEXIT #=    87 LV= 1 ENDIF
         STG   R8,0(R4)
         STG   R9,8(R4)
         LA    R15,0
         BR    R11
PACK     PACK  PWORK,0(0,R7)   PACK FIRST 13 OR LESS
TRTSP    TRT   0(0,R7),TRTTAB_SPACE
*
* CTD PUT INT128
*
CTD_PUT_INT128 EQU *
         MVC   0(LBUFF,R5),=(LBUFF)C' ' CLEAR DECIMAL OUTPUT
         MVC   POWER,=(LBUFF)C' '
         MVI   POWER+LBUFF-1,C'1'    INIT DECIMAL POWER TO 1
         MVI   SIGN,C'+'
         LG    R8,0(R4)
         LG    R9,8(R4)        R8-R9 = INT128
*MCALL #=    89 LV= 1          IF    (LTGR,R8,M,R8)
*MCALL #=    90 LV= 2          ZSTREQU 
*MEXIT #=    90 LV= 2 ZSTREQU
         LTGR  R8,R8
         BC    15-M,#@IF_10_2
*MEXIT #=    89 LV= 1 IF
               MVI   SIGN,C'-'
               BAL   R10,COMP128   COMPLIMENT 128 BIT INT IN R8:R9
*MCALL #=    91 LV= 1          ENDIF 
*MCALL #=    92 LV= 2          ZSTREQU 
*MEXIT #=    92 LV= 2 ZSTREQU
#@IF_10_2                                                DS 0H
*MEXIT #=    91 LV= 1 ENDIF
*MCALL #=    93 LV= 1          IF  (LTGR,R8,Z,R8),AND,(LTGR,R9,NM,R9)
*MCALL #=    94 LV= 2          ZSTREQU 
*MEXIT #=    94 LV= 2 ZSTREQU
         LTGR  R8,R8
         BC    15-Z,#@IF_11_2
         LTGR  R9,R9
         BC    15-NM,#@IF_11_2
*MEXIT #=    93 LV= 1 IF
*
*              USE PACKED DECIMAL IF LESS THAN 64 BITS
*
               CVDG R9,PWORK
               MVC  DWORK,DMASK
               SR   R1,R1
               EDMK DWORK,PWORK
*MCALL #=    95 LV= 1                IF   (CLI,SIGN,EQ,C'-'),AND,(LTR,RX
               1,NZ,R1)
*MCALL #=    96 LV= 2          ZSTREQU 
*MEXIT #=    96 LV= 2 ZSTREQU
         CLI   SIGN,C'-'
         BC    15-EQ,#@IF_12_2
         LTR   R1,R1
         BC    15-NZ,#@IF_12_2
*MEXIT #=    95 LV= 1 IF
                    BCTR R1,0
                    MVI  0(R1),C'-'
*MCALL #=    97 LV= 1                ENDIF 
*MCALL #=    98 LV= 2          ZSTREQU 
*MEXIT #=    98 LV= 2 ZSTREQU
#@IF_12_2                                                DS 0H
*MEXIT #=    97 LV= 1 ENDIF
               MVC  LBUFF-32(L'DWORK,R5),DWORK
*MCALL #=    99 LV= 1          ELSE 
*MCALL #=   100 LV= 2          ZSTREQU 
*MEXIT #=   100 LV= 2 ZSTREQU
        B      #@IF_11_E
#@IF_11_2                                                DS 0H
*MEXIT #=    99 LV= 1 ELSE
*
*             SHIFT ALL 64 TO 128 BITS OUT AND ADD POWER
*             OF 2 TO DECIMAL COUNTER WHEN BIT IS ONE
*
*MCALL #=   101 LV= 1               DO   WHILE=((LTGR,R8,NZ,R8),OR,(LTGX
               R,R9,NZ,R9))
*MCALL #=   102 LV= 2          ZSTREQU 
*MEXIT #=   102 LV= 2 ZSTREQU
#@DO_1_T                         DS 0H
*MCALL #=   103 LV= 2          IF (LTGR,R8,NZ,R8),OR,(LTGR,R9,NZ,R9)
*MCALL #=   104 LV= 3          ZSTREQU 
*MEXIT #=   104 LV= 3 ZSTREQU
         LTGR  R8,R8
         BC    15-NZ,#@IF_13_2
         B     #@IF_13_1
#@IF_13_2                                                DS 0H
         LTGR  R9,R9
         BC    15-NZ,#@IF_13_3
#@IF_13_1                               DS 0H
*MEXIT #=   103 LV= 2 IF
               B   #@DO_1_1
*MCALL #=   105 LV= 2          ENDIF 
*MCALL #=   106 LV= 3          ZSTREQU 
*MEXIT #=   106 LV= 3 ZSTREQU
#@IF_13_3                                                DS 0H
*MEXIT #=   105 LV= 2 ENDIF
         B     #@DO_1_E
#@DO_1_1                         DS 0H
*MEXIT #=   101 LV= 1 DO
*MCALL #=   107 LV= 1                   IF (TMLL,R9,NZ,1)
*MCALL #=   108 LV= 2          ZSTREQU 
*MEXIT #=   108 LV= 2 ZSTREQU
         TMLL  R9,1
         BC    15-NZ,#@IF_14_2
*MEXIT #=   107 LV= 1 IF
                     LA   R6,LBUFF-1(R5)
                     BAS  R10,CTD_ADD_POWER
                     ST   R6,ASIGN   ADDR TO SET SIGN IF NEG
*MCALL #=   109 LV= 1                   ENDIF 
*MCALL #=   110 LV= 2          ZSTREQU 
*MEXIT #=   110 LV= 2 ZSTREQU
#@IF_14_2                                                DS 0H
*MEXIT #=   109 LV= 1 ENDIF
                  LA   R6,POWER+LBUFF-1
                  BAL  R10,CTD_ADD_POWER
*MCALL #=   111 LV= 1                   IF   (TMLL,R8,NZ,1)    SHIFT R8X
               :R9 BY 1 BIT
*MCALL #=   112 LV= 2          ZSTREQU 
*MEXIT #=   112 LV= 2 ZSTREQU
         TMLL  R8,1
         BC    15-NZ,#@IF_15_2
*MEXIT #=   111 LV= 1 IF
                       SRLG R8,R8,1
                       SRLG R9,R9,1
                       OIHH R9,X'8000'
*MCALL #=   113 LV= 1                   ELSE 
*MCALL #=   114 LV= 2          ZSTREQU 
*MEXIT #=   114 LV= 2 ZSTREQU
        B      #@IF_15_E
#@IF_15_2                                                DS 0H
*MEXIT #=   113 LV= 1 ELSE
                       SRLG R8,R8,1
                       SRLG R9,R9,1
*MCALL #=   115 LV= 1                   ENDIF 
*MCALL #=   116 LV= 2          ZSTREQU 
*MEXIT #=   116 LV= 2 ZSTREQU
#@IF_15_E                        DS 0H
*MEXIT #=   115 LV= 1 ENDIF
*MCALL #=   117 LV= 1               ENDDO 
*MCALL #=   118 LV= 2          DO    END
*MCALL #=   119 LV= 3          ZSTREQU 
*MEXIT #=   119 LV= 3 ZSTREQU
         B     #@DO_1_T
#@DO_1_E                         DS 0H
*MEXIT #=   118 LV= 2 DO
*MEXIT #=   117 LV= 1 ENDDO
*MCALL #=   120 LV= 1               IF  (CLI,SIGN,EQ,C'-'),AND,(CLC,ASIX
               GN,P,=F'0')
*MCALL #=   121 LV= 2          ZSTREQU 
*MEXIT #=   121 LV= 2 ZSTREQU
         CLI   SIGN,C'-'
         BC    15-EQ,#@IF_16_2
         CLC   ASIGN,=F'0'
         BC    15-P,#@IF_16_2
*MEXIT #=   120 LV= 1 IF
                  L    R1,ASIGN
                  MVI 0(R1),C'-'
*MCALL #=   122 LV= 1               ENDIF 
*MCALL #=   123 LV= 2          ZSTREQU 
*MEXIT #=   123 LV= 2 ZSTREQU
#@IF_16_2                                                DS 0H
*MEXIT #=   122 LV= 1 ENDIF
*MCALL #=   124 LV= 1          ENDIF 
*MCALL #=   125 LV= 2          ZSTREQU 
*MEXIT #=   125 LV= 2 ZSTREQU
#@IF_11_E                        DS 0H
*MEXIT #=   124 LV= 1 ENDIF
         OI   LBUFF-1(R5),X'F0'
*MCALL #=   126 LV= 1          IF   (TRT,0(LBUFF,R5),NZ,TRTTAB_NOT_SPACX
               E)
*MCALL #=   127 LV= 2          ZSTREQU 
*MEXIT #=   127 LV= 2 ZSTREQU
         TRT   0(LBUFF,R5),TRTTAB_NOT_SPACE
         BC    15-NZ,#@IF_17_2
*MEXIT #=   126 LV= 1 IF
              LR  R8,R1
              LA  R9,LBUFF(R5)
              SR  R9,R8
              ICM R9,8,=C' '
              LR  R0,R5
              LA  R1,LBUFF
              MVCL R0,R8 MOVE DISPLAY TO FRONT AND PAD WITH SPACES
*MCALL #=   128 LV= 1          ENDIF 
*MCALL #=   129 LV= 2          ZSTREQU 
*MEXIT #=   129 LV= 2 ZSTREQU
#@IF_17_2                                                DS 0H
*MEXIT #=   128 LV= 1 ENDIF
         BR   R11
*
* CFD CALL INTERFACE TO FPCONVRT
*
CFD_CALL EQU *
*
*     SET STRING ADDR, SIZE, AND LENGTH PLUS FLAGS AND BASE
*
         LA    R6,LBUFF(R5)
*MCALL #=   130 LV= 1          DO    WHILE=((CLR,R5,LT,R6),AND,(CLI,0(RX
               5),EQ,C' '))
*MCALL #=   131 LV= 2          ZSTREQU 
*MEXIT #=   131 LV= 2 ZSTREQU
#@DO_2_T                         DS 0H
*MCALL #=   132 LV= 2          IF (CLR,R5,LT,R6),AND,(CLI,0(R5),EQ,C' 'X
               )
*MCALL #=   133 LV= 3          ZSTREQU 
*MEXIT #=   133 LV= 3 ZSTREQU
         CLR   R5,R6
         BC    15-LT,#@IF_18_2
         CLI   0(R5),C' '
         BC    15-EQ,#@IF_18_2
*MEXIT #=   132 LV= 2 IF
               B   #@DO_2_1
*MCALL #=   134 LV= 2          ENDIF 
*MCALL #=   135 LV= 3          ZSTREQU 
*MEXIT #=   135 LV= 3 ZSTREQU
#@IF_18_2                                                DS 0H
*MEXIT #=   134 LV= 2 ENDIF
         B     #@DO_2_E
#@DO_2_1                         DS 0H
*MEXIT #=   130 LV= 1 DO
               LA   R5,1(R5)
*MCALL #=   136 LV= 1          ENDDO 
*MCALL #=   137 LV= 2          DO    END
*MCALL #=   138 LV= 3          ZSTREQU 
*MEXIT #=   138 LV= 3 ZSTREQU
         B     #@DO_2_T
#@DO_2_E                         DS 0H
*MEXIT #=   137 LV= 2 DO
*MEXIT #=   136 LV= 1 ENDDO
         STG         R5,FpconStringAddr SET FPCON 32/64 BIT ADDR
         SR    R0,R0
*MCALL #=   139 LV= 1          DO    WHILE=((CLR,R5,LT,R6),AND,(CLI,0(RX
               5),GT,C' '))
*MCALL #=   140 LV= 2          ZSTREQU 
*MEXIT #=   140 LV= 2 ZSTREQU
#@DO_3_T                         DS 0H
*MCALL #=   141 LV= 2          IF (CLR,R5,LT,R6),AND,(CLI,0(R5),GT,C' 'X
               )
*MCALL #=   142 LV= 3          ZSTREQU 
*MEXIT #=   142 LV= 3 ZSTREQU
         CLR   R5,R6
         BC    15-LT,#@IF_19_2
         CLI   0(R5),C' '
         BC    15-GT,#@IF_19_2
*MEXIT #=   141 LV= 2 IF
               B   #@DO_3_1
*MCALL #=   143 LV= 2          ENDIF 
*MCALL #=   144 LV= 3          ZSTREQU 
*MEXIT #=   144 LV= 3 ZSTREQU
#@IF_19_2                                                DS 0H
*MEXIT #=   143 LV= 2 ENDIF
         B     #@DO_3_E
#@DO_3_1                         DS 0H
*MEXIT #=   139 LV= 1 DO
               AHI  R5,1
               AHI  R0,1
*MCALL #=   145 LV= 1          ENDDO 
*MCALL #=   146 LV= 2          DO    END
*MCALL #=   147 LV= 3          ZSTREQU 
*MEXIT #=   147 LV= 3 ZSTREQU
         B     #@DO_3_T
#@DO_3_E                         DS 0H
*MEXIT #=   146 LV= 2 DO
*MEXIT #=   145 LV= 1 ENDDO
         STC   R0,FpconStringSize+1
         MVC   FpconStringLen,FpconStringSize
         MVI   FpconFlags,FpconToValue
*
*   CALL FPCONVRT TO CONVERT DECIMAL STRING TO FP FORMAT
*
*MCALL #=   148 LV= 1          FPCON_CALL 
         SGR   R1,R1             CLEAR HIGH BITS RPI 829
         LA    R1,=AD(FPCON)     R1 > 64 BIT ADDR
         LG    R15,=VD(FPCONVRT)
         ST    R13,MYSAVE        SAVE CALLERS 18F SAVE AREA
         LA    R13,BIGSAVE       FORMAT 4 - 18FD SAVE AREA
         BASR  R14,R15           CALL USING BIG SAVE AREA
         L     R13,MYSAVE-*(R14) RESTORE CALLERS SAVE AREA
*MEXIT #=   148 LV= 1 FPCON_CALL
         BR    R11
*
* CTD CALL INTERFACE TO FPCONVRT
*
CTD_CALL EQU *
*
*     SET STRING ADDR, SIZE, AND LENGTH PLUS FLAGS AND BASE
*
         STG         R5,FpconStringAddr  SET FPCON STRING ADDR 32/64
         MVI   FpconStringSize+1,LBUFF
         MVC   FpconStringLen,FpconStringSize
         MVI   FpconFlags,FpconToValue-FpconToValue  to decimal
*
*   CALL FPCONVRT TO CONVERT DECIMAL STRING TO BFP FORMAT
*
*MCALL #=   149 LV= 1          FPCON_CALL 
         SGR   R1,R1             CLEAR HIGH BITS RPI 829
         LA    R1,=AD(FPCON)     R1 > 64 BIT ADDR
         LG    R15,=VD(FPCONVRT)
         ST    R13,MYSAVE        SAVE CALLERS 18F SAVE AREA
         LA    R13,BIGSAVE       FORMAT 4 - 18FD SAVE AREA
         BASR  R14,R15           CALL USING BIG SAVE AREA
         L     R13,MYSAVE-*(R14) RESTORE CALLERS SAVE AREA
*MEXIT #=   149 LV= 1 FPCON_CALL
         TR    0(LBUFF,R5),TRTAB_NULL_SPACE OUTPUT NULLS > SPACES
         BR    R11
*********************************************************************
* Level 3 support routines using R10
*********************************************************************
*
* ADD DECIMAL POWER OF 2 TO DECIMAL FIELD WITH AT R6
*
CTD_ADD_POWER EQU *
         LA    R7,POWER+LBUFF-1
         SR    R3,R3                      R3=CARRY IF ANY
*MCALL #=   150 LV= 1          DO    UNTIL=((CLI,0(R7),EQ,C' '),AND,(LTX
               R,R3,Z,R3))
*MCALL #=   151 LV= 2          ZSTREQU 
*MEXIT #=   151 LV= 2 ZSTREQU
         B     #@DO_4_1
#@DO_4_T                         DS 0H
*MCALL #=   152 LV= 2          IF    (CLI,0(R7),EQ,C' '),AND,(LTR,R3,Z,X
               R3)
*MCALL #=   153 LV= 3          ZSTREQU 
*MEXIT #=   153 LV= 3 ZSTREQU
         CLI   0(R7),C' '
         BC    15-EQ,#@IF_20_2
         LTR   R3,R3
         BC    15-Z,#@IF_20_2
*MEXIT #=   152 LV= 2 IF
               B     #@DO_4_E
*MCALL #=   154 LV= 2          ENDIF 
*MCALL #=   155 LV= 3          ZSTREQU 
*MEXIT #=   155 LV= 3 ZSTREQU
#@IF_20_2                                                DS 0H
*MEXIT #=   154 LV= 2 ENDIF
#@DO_4_1                         DS 0H
*MEXIT #=   150 LV= 1 DO
               IC    R0,0(R6)
               NILF  R0,X'0000000F'
               IC    R1,0(R7)
               NILF  R1,X'0000000F'
               AR    R0,R1
               AR    R0,R3
*MCALL #=   156 LV= 1                IF    (CHI,R0,GT,9)
*MCALL #=   157 LV= 2          ZSTREQU 
*MEXIT #=   157 LV= 2 ZSTREQU
         CHI   R0,9
         BC    15-GT,#@IF_21_2
*MEXIT #=   156 LV= 1 IF
                     LA   R3,1           CARRY
                     AHI  R0,-10
*MCALL #=   158 LV= 1                ELSE 
*MCALL #=   159 LV= 2          ZSTREQU 
*MEXIT #=   159 LV= 2 ZSTREQU
        B      #@IF_21_E
#@IF_21_2                                                DS 0H
*MEXIT #=   158 LV= 1 ELSE
                     LA   R3,0           NO CARRY
*MCALL #=   160 LV= 1                ENDIF 
*MCALL #=   161 LV= 2          ZSTREQU 
*MEXIT #=   161 LV= 2 ZSTREQU
#@IF_21_E                        DS 0H
*MEXIT #=   160 LV= 1 ENDIF
               OILL R0,X'F0'
               STC  R0,0(R6)
               BCTR R6,0
               BCTR R7,0
*MCALL #=   162 LV= 1          ENDDO 
*MCALL #=   163 LV= 2          DO    END
*MCALL #=   164 LV= 3          ZSTREQU 
*MEXIT #=   164 LV= 3 ZSTREQU
         B     #@DO_4_T
#@DO_4_E                         DS 0H
*MEXIT #=   163 LV= 2 DO
*MEXIT #=   162 LV= 1 ENDDO
         BR    R10
*
* COMPLIMENT 128 BIT INT IN R8:R9
*
COMP128  EQU   *
         LG    R7,=FL8'-1'
         XGR   R8,R7
         XGR   R9,R7
         ALGF  R9,=F'1'
         ALCG  R8,=FL8'0'  R8-R9 = ABS NUM
         BR    R10
*********************************************************************
* Shared data
*********************************************************************
*
* SHARED DATA
*
MYSAVE   DC    A(0)
BIGSAVE  DC    18D'0' FOR ARCH=5 GREG SAVE AREA
INT_1E26 DC    FL16'1E26' MULTIPLIER FOR FIRST 1-13 DIGITS
         LTORG 
*MCALL #=   165 LV= 1          EQUREGS REGS=GPR
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
*MEXIT #=   165 LV= 1 EQUREGS
*MCALL #=   166 LV= 1          EQUREGS REGS=FPR
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
*MEXIT #=   166 LV= 1 EQUREGS
TYPE     DC    X'00' CTD/CFD OPERATION TYPE
SIGN     DC    C'+'  SIGN OF DECIMAL NUMBER
PWORK    DC    PL16'0'
DWORK    DC    CL32' '
DMASK    DC    C' ',31X'20'
POWER    DC    CL(LBUFF)' '
ASIGN    DC    A(0)
TRTTAB_DIGITS DC 256X'00'
         ORG   TRTTAB_DIGITS+C'0'
         DC    10X'FF'
         ORG 
TRTTAB_MINUS  DC 256X'00'
         ORG TRTTAB_MINUS+C'-'
         DC  X'FF'
         ORG 
TRTTAB_SPACE DC  256X'00'
         ORG TRTTAB_SPACE+C' '
         DC  X'FF'
         ORG 
TRTTAB_NOT_SPACE DC  256X'FF'
         ORG TRTTAB_NOT_SPACE+C' '
         DC  X'00'
         ORG 
TRTAB_NULL_SPACE DC 256AL1(*-TRTAB_NULL_SPACE)
         ORG TRTAB_NULL_SPACE+X'00'
         DC  C' '
         ORG 
*
* ASSEMBLE INLINE FPCONVRT INTERFACE BLOCK PASSED VIA R1
*
ADRCHK   DC    A(FPCON)
*MCALL #=   167 LV= 1          FPCONVRT Type=InLine,Archlvl=7 MUST MATCX
               H FPCONVRT.MLC
Fpcon           DS 0D          Floating Point Conversion Request Block
FpconSave       DS 18FD           Save area used by FPCONVRT
FpconValueE     DS 0E              Short floating point value
FpconValueD     DS 0D              Long floating point value
FpconValueL     DS L               Extended floating point value
FpconStringAddr DS AD             Address of string buffer
FpconReturnCode DS F               Return code (output)
FpconRetOk     EQU 0                   Success
FpconRetUndFlo EQU 4                   String value is too small
FpconRetDenorm EQU 4                   FP value is denormalized
FpconRetOvrFlo EQU 8                   String value is too big
FpconRetInf    EQU 8                   IEEE FP value is an infinity
FpconRetNan    EQU 12                  IEEE FP value is a NAN
FpconRetBadStr EQU 12                  Invalid floating point string
FpconRetBadPrm EQU 16                  Invalid parameters
FpconStringSize DS H               Size of string buffer
FpconStringLen  DS H               Length of string (output)
*                                  Offset to bad character (RetBadStr)
FpconMaxDigits  DS H               Maximum non-zero digits generated
FpconMaxLeading DS H               Maximum digits before decimal point
FpconMinDecimal DS H               Minimum digits after decimal point
FpconMaxDecimal DS H               Maximum digits after decimal point
FpconMinExpon   DS H               Minimum exponent digits
FpconExponent10 DS H               Base 10 exponent (output)
FpconValueLen   DS FL1             Length of floating point value (in)
FpconValueLenE EQU 4                   Short
FpconValueLenD EQU 8                   Long
FpconValueLenL EQU 16                  Extended
FpconBase       DS FL1             Base of floating point value (in)
FpconBase2     EQU 2                   Binary IEEE-754 (default)
FpconBase10    EQU 10                  Decimal (IEEE-754r)
FpconBase16    EQU 16                  Hexadecimal S/360
FpconFlags      DS X               Flags (in)
FpconToValue   EQU X'40'               Convert string to value
*                                      (otherwise convert to string)
FpconValuePlus EQU X'20'               If leading mantissa plus sign
FpconExponPlus EQU X'10'               If leading exponent plus sign
FpconZeroPlus  EQU X'08'               If zero is always positive
FpconZeroSign  EQU X'04'               If zero can be negative
FpconFixedDec  EQU X'02'               Round decimals to fit
FpconRetDigits EQU X'01'               Return digits only (ecvt/fcvt)
FpconZero       DS C               ASCII or EBCDIC '0' character
FpconPlus       DS C               ASCII or EBCDIC '+' character
FpconMinus      DS C               ASCII or EBCDIC '-' character
FpconDecimal    DS C               ASCII or EBCDIC decimal point char.
FpconExponent   DS C               Exponent character
FpconExpAlt     DS C               Alternate exponent character
                DS 3C              (Set/used by FPCONVRT)
                DS 0d              Align to doubleword
FpconWork       DS XL2096          Internal work area
FpconEnd        DS 0d              End of request block
FpconLength    EQU *-Fpcon          length of request block
***********************************************************************
*MEXIT #=   167 LV= 1 FPCONVRT
         END 
