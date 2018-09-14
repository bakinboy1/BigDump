*********************************************************************
* Copyright 2005 Automated Software Tools Corporation               *
* This source code is part of z390 assembler/emulator package       *
* The z390 package is distributed under GNU general public license  *
* Author - Don Higgins                                              *
* Date   - 07/17/06                                                 *
*********************************************************************
* 07/17/06 RPI 370 test CTD and CFD including SVC and MF call option
* 11/10/06 RPI 477 use IN= and OUT= on CTD and CFD macros
* 12/11/06 RPI 513 test ED, DD, and LD CTD and CFD options
* 12/15/06 RPI 406 add additional ED and LD tests
* 12/22/06 RPI 406 skip bug in DFP MF and skip slow BFP/HFP extended MF
*                  add check that SVC and MF display values match
* 01/13/08 RPI 786 use fp compares to handle equivalent DFP values
* 03/19/08 RPI 819 clear high 32 bits of gprs to avoid bugs in fpconvrt
* 04/19/08 RPI 833 add SETC quotes for HLASM compatibilitys in fpconvrt
*********************************************************************
* Test conversion from and to 128 bit integer and all 6 floating
* point types using default svc 170 and 171 and also using
* LINKAGE=MF call to FPCONVRT contributed by David Bond.
*********************************************************************
         COPY  ASMMSP
         COPY ZSTRMAC  Z390 STRUCTURED PROGRAMMING MACROS
         PRINT DATA
*MCALL #=     1 LV= 1 TESTFPC1 RT1   MAIN
*MCALL #=     2 LV= 2 TESTFPC1 SUBENTRY 
TESTFPC1 CSECT 
         STM   14,12,12(13)
         BAL   15,104(15)
         DC    18F'0'
         DC    CL8'TESTFPC1'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
         USING TESTFPC1+8,13
*MEXIT #=     2 LV= 2 SUBENTRY
*MCALL #=     3 LV= 2          WTO   'TESTFPC1 RT1 STARTED'
         BRAS  1,*+(WTO#0003_EOT-*+1)/2*2
         DC    AL2(WTO#0003_EOT-*,0),C'TESTFPC1 RT1 STARTED'
WTO#0003_EOT     EQU *
         SVC   35
*MEXIT #=     3 LV= 2 WTO
         BRCL    15,RT1_START
RT1_ABORT DS 0H
         MVI   RT1_ABORTED,C'T'
*MCALL #=     4 LV= 2          WTO   'TESTFPC1 RT1 TESTING ABORTED'
         BRAS  1,*+(WTO#0004_EOT-*+1)/2*2
         DC    AL2(WTO#0004_EOT-*,0),C'TESTFPC1 RT1 TESTING ABORTED'
WTO#0004_EOT     EQU *
         SVC   35
*MEXIT #=     4 LV= 2 WTO
RT1_END  DS    0H
         MVC   RT1_DTOT,=X'402020202020'
         ED    RT1_DTOT,RT1_TOT
*MCALL #=     5 LV= 2          WTO   MF=(E,RT1_WTO1)
         LA    1,RT1_WTO1
         SVC   35
*MEXIT #=     5 LV= 2 WTO
         CLI   RT1_ABORTED,C'T'
         BE    RT1_DUMP
*MCALL #=     6 LV= 2          WTO   'TESTFPC1 RT1 ENDED OK'
         BRAS  1,*+(WTO#0006_EOT-*+1)/2*2
         DC    AL2(WTO#0006_EOT-*,0),C'TESTFPC1 RT1 ENDED OK'
WTO#0006_EOT     EQU *
         SVC   35
*MEXIT #=     6 LV= 2 WTO
*MCALL #=     7 LV= 2          SUBEXIT 
         LA    15,0
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=     7 LV= 2 SUBEXIT
RT1_DUMP DS    0H
*MCALL #=     8 LV= 2          ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=     8 LV= 2 ABEND
RT1_LINK EQU   11
RT1_DATA EQU   *
RT1_TOT  DC    PL3'0' TOTAL RT1 TESTS COMPLETED
RT1_ONE  DC    P'1'
RT1_WTO1 DC    AL2(RT1_WTO_END-*,0),C'TESTFPC1 RT1 TESTS COMPLETED = '
RT1_DTOT DC    CL6' ZZZZZ'
RT1_WTO_END EQU *
RT1_ABORTED DC C'F'
         LTORG 
RT1_TEST_CC0  DS    0H
         BNE   RT1_ABORT
RT1_OK   DS    0H
         AP    RT1_TOT,RT1_ONE
         BR    RT1_LINK
RT1_TEST_CC1  DS    0H
         BNL   RT1_ABORT
         AP    RT1_TOT,RT1_ONE
         BR    RT1_LINK
RT1_TEST_CC2  DS    0H
         BNH   RT1_ABORT
         AP    RT1_TOT,RT1_ONE
         BR    RT1_LINK
RT1_TEST_CC3  DS    0H
         BNO   RT1_ABORT
         AP    RT1_TOT,RT1_ONE
         BR    RT1_LINK
RT1_TEST_CCGE  DS    0H
         BL    RT1_ABORT
         AP    RT1_TOT,RT1_ONE
         BR    RT1_LINK
RT1_TEST_CCLE  DS    0H
         BH    RT1_ABORT
         AP    RT1_TOT,RT1_ONE
         BR    RT1_LINK
*MEXIT #=     1 LV= 1 RT1
INT128   DC    0XL16,X'80',15X'00'      largest negative 128 bit int
WORK16   DC    XL16'00'
WTOMSG   DC    AL2(WTOEND-*,0)
DTYPE    DC    CL6' ',C' '
DHEX     DC    CL32' ',C'='
DECIMAL  DC    CL45' '
SAVE_DECIMAL  DC    CL45' '
WTOEND   EQU   *
PRC      DC    PL8'0'
WTOPRC   DC    AL2(WTOPRC_END-*,0)
         DC    C'ERROR RC ='
DRC      DC    CL4' '
WTOPRC_END   EQU   *
LBT1     DC    LB'-567678867789987898'
LDT1     DC    LD'-567678867789987898'
LHT1     DC    LH'-567678867789987898'
*MCALL #=     9 LV= 1          EQUREGS 
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
*MEXIT #=     9 LV= 1 EQUREGS
         MACRO
         TEST  &TYPE,&VAL
         AIF   ('&TYPE'(2,1) EQ 'D').SKPMF SKIP DFP MF FOR NOW (BUG?)
         AIF   ('&TYPE'(1,1) EQ 'L').SKPMF SKIP EXT MF FOR NOW (SLOW)
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
         TEST1 MF,&TYPE,&VAL
         MVC   SAVE_DECIMAL,DECIMAL
         TEST1 SVC,&TYPE,&VAL
         CLC   DECIMAL,SAVE_DECIMAL
         RT1   CCE
         MEXIT
.SKPMF   ANOP
         TEST1 SVC,&TYPE,&VAL
         MEND
         MACRO
         TEST1 &LINKAGE,&TYPE,&VAL
         GBLA  &TESTNO
&TESTNO  SETA  &TESTNO+1
         BASR  R12,0
         USING *,R12
         CTD   CTD_&TYPE,IN=&VAL,OUT=DECIMAL,LINKAGE=&LINKAGE
         CVD   R15,PRC
&LK      SETC  '&LINKAGE'(1,1)
         MVC   DTYPE,=CL6'&LK.>D &TYPE'
         MVC   DHEX,=CL32' '
         LA    R2,&VAL
         LA    R3,L'&VAL
         CALL  CVTTOHEX,((R2),DHEX,(R3))
         WTO   MF=(E,WTOMSG)
         IF    (CP,PRC,NE,=P'0')
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
               WTO MF=(E,WTOPRC)
               ABEND 101
         ENDIF
         XC    WORK16,WORK16
         CFD   CFD_&TYPE,OUT=WORK16,IN=DECIMAL,LINKAGE=&LINKAGE
         CVD   R15,PRC
         MVC   DTYPE,=CL6'&LK.<D &TYPE'
         MVC   DHEX,=CL32' '
         LA    R3,L'&VAL
         CALL  CVTTOHEX,(WORK16,DHEX,(R3))
         WTO   MF=(E,WTOMSG)
         IF    (CP,PRC,NE,=P'0')
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
               WTO MF=(E,WTOPRC)
               ABEND 102
         ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         AIF   ('&TYPE' EQ 'ED').ED_COMP
         AIF   ('&TYPE' EQ 'DD').DD_COMP
         AIF   ('&TYPE' EQ 'LD').LD_COMP
         AGO   .CLC_COMP
.ED_COMP ANOP
         LE    R0,&VAL
         LDETR R0,R0,0
         LE    R1,WORK16
         LDETR R1,R1,0
         CDTR  R0,R1
         AGO   .END_COMP
.DD_COMP ANOP
         LD    R0,&VAL
         LD    R1,WORK16
         CDTR  R0,R1
         AGO   .END_COMP
.LD_COMP ANOP
         LX    R0,&VAL
         LX    R1,WORK16
         CXTR  R0,R1
         AGO   .END_COMP
.CLC_COMP ANOP
         LA    R1,L'&VAL
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),&VAL  VERIFY CTD CONSTANT WITH CFD RESULT
.END_COMP ANOP
* RPI 786 START TEST FOR DFP
         RT1   CCE
         B     EXIT&TESTNO
         LTORG
EXIT&TESTNO DS 0H
         MEND
*MCALL #=    10 LV= 1          RT1   START
RT1_START DS  0H
*MEXIT #=    10 LV= 1 RT1
         IIHH  R0,0            RPI 819 FIX
         IIHL  R0,0            RPI 819 FIX
         IIHH  R1,0            RPI 819 FIX
         IIHL  R1,0            RPI 819 FIX
         IIHH  R2,0            RPI 819 FIX
         IIHL  R2,0            RPI 819 FIX
         IIHH  R3,0            RPI 819 FIX
         IIHL  R3,0            RPI 819 FIX
         IIHH  R4,0            RPI 819 FIX
         IIHL  R4,0            RPI 819 FIX
         IIHH  R5,0            RPI 819 FIX
         IIHL  R5,0            RPI 819 FIX
         IIHH  R6,0            RPI 819 FIX
         IIHL  R6,0            RPI 819 FIX
         IIHH  R7,0            RPI 819 FIX
         IIHL  R7,0            RPI 819 FIX
         IIHH  R8,0            RPI 819 FIX
         IIHL  R8,0            RPI 819 FIX
         IIHH  R9,0            RPI 819 FIX
         IIHL  R9,0            RPI 819 FIX
         IIHH  R10,0            RPI 819 FIX
         IIHL  R10,0            RPI 819 FIX
         IIHH  R11,0            RPI 819 FIX
         IIHL  R11,0            RPI 819 FIX
         IIHH  R12,0            RPI 819 FIX
         IIHL  R12,0            RPI 819 FIX
         IIHH  R13,0            RPI 819 FIX
         IIHL  R13,0            RPI 819 FIX
         IIHH  R14,0            RPI 819 FIX
         IIHL  R14,0            RPI 819 FIX
         IIHH  R15,0            RPI 819 FIX
         IIHL  R15,0            RPI 819 FIX
* DB
*MCALL #=    11 LV= 1          TEST   DB,=DB'0'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=    12 LV= 2          TEST1 MF,DB,=DB'0'
         BASR  R12,0
         USING *,R12
*MCALL #=    13 LV= 3          CTD   CTD_DB,IN==DB'0',OUT=DECIMAL,LINKAX
               GE=MF
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
         LA    1,=A(CTD_DB,0,DECIMAL)
         LA    0,=DB'0'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=    13 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D DB'
         MVC   DHEX,=CL32' '
         LA    R2,=DB'0'
         LA    R3,L'=DB'0'
*MCALL #=    14 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=    15 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=    15 LV= 4 ZCALL
*MEXIT #=    14 LV= 3 CALL
*MCALL #=    16 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=    16 LV= 3 WTO
*MCALL #=    17 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=    18 LV= 4          ZSTREQU 
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
*MEXIT #=    18 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_1_2
*MEXIT #=    17 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=    19 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=    19 LV= 3 WTO
*MCALL #=    20 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=    20 LV= 3 ABEND
*MCALL #=    21 LV= 3          ENDIF 
*MCALL #=    22 LV= 4          ZSTREQU 
*MEXIT #=    22 LV= 4 ZSTREQU
#@IF_1_2                                                 DS 0H
*MEXIT #=    21 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=    23 LV= 3          CFD   CFD_DB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
CFD_INT128 EQU 21 CONVERT TO 128 BIT INT FROM 45 BYTE SN(39)
CFD_EH   EQU   22 CONVERT TO HFP SHORT EH FROM 45 BYTE SN.N(7)+ENNNN
CFD_EB   EQU   23 CONVERT TO BFP SHORT EB FROM 45 BYTE SN.N(7)+ENNNN
CFD_DH   EQU   24 CONVERT TO HFP LONG  DH FROM 45 BYTE SN.N(14)+ENNNN
CFD_DB   EQU   25 CONVERT TO BFP LONG  DB FROM 45 BYTE SN.N(14)+ENNNN
CFD_LH   EQU   26 CONVERT TO HFP EXT.  LH FROM 45 BYTE SN.N(34)+ENNNN
CFD_LB   EQU   27 CONVERT TO BFP EXT.  LB FROM 45 BYTE SN.N(34)+ENNNN
CFD_DD   EQU   28 CONVERT TO DFP LONG  DD FROM 45 BYTE SN.N(16)+ENNNN
CFD_ED   EQU   29 CONVERT TO DFP SHORT ED FROM 45 BYTE SN.N( 7)+ENNNN
CFD_LD   EQU   30 CONVERT TO DFP EXT.  LD FROM 45 BYTE SN.N(34)+ENNNN
         LA    1,=A(CFD_DB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=    23 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D DB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DB'0'
*MCALL #=    24 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=    25 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=    25 LV= 4 ZCALL
*MEXIT #=    24 LV= 3 CALL
*MCALL #=    26 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=    26 LV= 3 WTO
*MCALL #=    27 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=    28 LV= 4          ZSTREQU 
*MEXIT #=    28 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_2_2
*MEXIT #=    27 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=    29 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=    29 LV= 3 WTO
*MCALL #=    30 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=    30 LV= 3 ABEND
*MCALL #=    31 LV= 3          ENDIF 
*MCALL #=    32 LV= 4          ZSTREQU 
*MEXIT #=    32 LV= 4 ZSTREQU
#@IF_2_2                                                 DS 0H
*MEXIT #=    31 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DB'0'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DB'0'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=    33 LV= 3          RT1   CCE
         DS    0H
RT1_TEST1        BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE1
         LTORG 
RT1_CCE1        DS 0H
*MEXIT #=    33 LV= 3 RT1
         B     EXIT1
         LTORG 
EXIT1       DS 0H
*MEXIT #=    12 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=    34 LV= 2          TEST1 SVC,DB,=DB'0'
         BASR  R12,0
         USING *,R12
*MCALL #=    35 LV= 3          CTD   CTD_DB,IN==DB'0',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_DB,0,DECIMAL)
         LA    0,=DB'0'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=    35 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DB'
         MVC   DHEX,=CL32' '
         LA    R2,=DB'0'
         LA    R3,L'=DB'0'
*MCALL #=    36 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=    37 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=    37 LV= 4 ZCALL
*MEXIT #=    36 LV= 3 CALL
*MCALL #=    38 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=    38 LV= 3 WTO
*MCALL #=    39 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=    40 LV= 4          ZSTREQU 
*MEXIT #=    40 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_3_2
*MEXIT #=    39 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=    41 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=    41 LV= 3 WTO
*MCALL #=    42 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=    42 LV= 3 ABEND
*MCALL #=    43 LV= 3          ENDIF 
*MCALL #=    44 LV= 4          ZSTREQU 
*MEXIT #=    44 LV= 4 ZSTREQU
#@IF_3_2                                                 DS 0H
*MEXIT #=    43 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=    45 LV= 3          CFD   CFD_DB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=    45 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DB'0'
*MCALL #=    46 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=    47 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=    47 LV= 4 ZCALL
*MEXIT #=    46 LV= 3 CALL
*MCALL #=    48 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=    48 LV= 3 WTO
*MCALL #=    49 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=    50 LV= 4          ZSTREQU 
*MEXIT #=    50 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_4_2
*MEXIT #=    49 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=    51 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=    51 LV= 3 WTO
*MCALL #=    52 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=    52 LV= 3 ABEND
*MCALL #=    53 LV= 3          ENDIF 
*MCALL #=    54 LV= 4          ZSTREQU 
*MEXIT #=    54 LV= 4 ZSTREQU
#@IF_4_2                                                 DS 0H
*MEXIT #=    53 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DB'0'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DB'0'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=    55 LV= 3          RT1   CCE
         DS    0H
RT1_TEST2        BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE2
         LTORG 
RT1_CCE2        DS 0H
*MEXIT #=    55 LV= 3 RT1
         B     EXIT2
         LTORG 
EXIT2       DS 0H
*MEXIT #=    34 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=    56 LV= 2          RT1   CCE
         DS    0H
RT1_TEST3        BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE3
         LTORG 
RT1_CCE3        DS 0H
*MEXIT #=    56 LV= 2 RT1
*MEXIT #=    11 LV= 1 TEST
*MCALL #=    57 LV= 1          TEST   DB,=DB'1E-307'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=    58 LV= 2          TEST1 MF,DB,=DB'1E-307'
         BASR  R12,0
         USING *,R12
*MCALL #=    59 LV= 3          CTD   CTD_DB,IN==DB'1E-307',OUT=DECIMAL,X
               LINKAGE=MF
         LA    1,=A(CTD_DB,0,DECIMAL)
         LA    0,=DB'1E-307'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=    59 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D DB'
         MVC   DHEX,=CL32' '
         LA    R2,=DB'1E-307'
         LA    R3,L'=DB'1E-307'
*MCALL #=    60 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=    61 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=    61 LV= 4 ZCALL
*MEXIT #=    60 LV= 3 CALL
*MCALL #=    62 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=    62 LV= 3 WTO
*MCALL #=    63 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=    64 LV= 4          ZSTREQU 
*MEXIT #=    64 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_5_2
*MEXIT #=    63 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=    65 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=    65 LV= 3 WTO
*MCALL #=    66 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=    66 LV= 3 ABEND
*MCALL #=    67 LV= 3          ENDIF 
*MCALL #=    68 LV= 4          ZSTREQU 
*MEXIT #=    68 LV= 4 ZSTREQU
#@IF_5_2                                                 DS 0H
*MEXIT #=    67 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=    69 LV= 3          CFD   CFD_DB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_DB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=    69 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D DB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DB'1E-307'
*MCALL #=    70 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=    71 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=    71 LV= 4 ZCALL
*MEXIT #=    70 LV= 3 CALL
*MCALL #=    72 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=    72 LV= 3 WTO
*MCALL #=    73 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=    74 LV= 4          ZSTREQU 
*MEXIT #=    74 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_6_2
*MEXIT #=    73 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=    75 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=    75 LV= 3 WTO
*MCALL #=    76 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=    76 LV= 3 ABEND
*MCALL #=    77 LV= 3          ENDIF 
*MCALL #=    78 LV= 4          ZSTREQU 
*MEXIT #=    78 LV= 4 ZSTREQU
#@IF_6_2                                                 DS 0H
*MEXIT #=    77 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DB'1E-307'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DB'1E-307'  VERIFY CTD CONSTANT WITH CFD RESUX
               LT
* RPI 786 START TEST FOR DFP
*MCALL #=    79 LV= 3          RT1   CCE
         DS    0H
RT1_TEST4        BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE4
         LTORG 
RT1_CCE4        DS 0H
*MEXIT #=    79 LV= 3 RT1
         B     EXIT3
         LTORG 
EXIT3       DS 0H
*MEXIT #=    58 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=    80 LV= 2          TEST1 SVC,DB,=DB'1E-307'
         BASR  R12,0
         USING *,R12
*MCALL #=    81 LV= 3          CTD   CTD_DB,IN==DB'1E-307',OUT=DECIMAL,X
               LINKAGE=SVC
         LA    1,=A(CTD_DB,0,DECIMAL)
         LA    0,=DB'1E-307'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=    81 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DB'
         MVC   DHEX,=CL32' '
         LA    R2,=DB'1E-307'
         LA    R3,L'=DB'1E-307'
*MCALL #=    82 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=    83 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=    83 LV= 4 ZCALL
*MEXIT #=    82 LV= 3 CALL
*MCALL #=    84 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=    84 LV= 3 WTO
*MCALL #=    85 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=    86 LV= 4          ZSTREQU 
*MEXIT #=    86 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_7_2
*MEXIT #=    85 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=    87 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=    87 LV= 3 WTO
*MCALL #=    88 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=    88 LV= 3 ABEND
*MCALL #=    89 LV= 3          ENDIF 
*MCALL #=    90 LV= 4          ZSTREQU 
*MEXIT #=    90 LV= 4 ZSTREQU
#@IF_7_2                                                 DS 0H
*MEXIT #=    89 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=    91 LV= 3          CFD   CFD_DB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=    91 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DB'1E-307'
*MCALL #=    92 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=    93 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=    93 LV= 4 ZCALL
*MEXIT #=    92 LV= 3 CALL
*MCALL #=    94 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=    94 LV= 3 WTO
*MCALL #=    95 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=    96 LV= 4          ZSTREQU 
*MEXIT #=    96 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_8_2
*MEXIT #=    95 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=    97 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=    97 LV= 3 WTO
*MCALL #=    98 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=    98 LV= 3 ABEND
*MCALL #=    99 LV= 3          ENDIF 
*MCALL #=   100 LV= 4          ZSTREQU 
*MEXIT #=   100 LV= 4 ZSTREQU
#@IF_8_2                                                 DS 0H
*MEXIT #=    99 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DB'1E-307'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DB'1E-307'  VERIFY CTD CONSTANT WITH CFD RESUX
               LT
* RPI 786 START TEST FOR DFP
*MCALL #=   101 LV= 3          RT1   CCE
         DS    0H
RT1_TEST5        BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE5
         LTORG 
RT1_CCE5        DS 0H
*MEXIT #=   101 LV= 3 RT1
         B     EXIT4
         LTORG 
EXIT4       DS 0H
*MEXIT #=    80 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=   102 LV= 2          RT1   CCE
         DS    0H
RT1_TEST6        BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE6
         LTORG 
RT1_CCE6        DS 0H
*MEXIT #=   102 LV= 2 RT1
*MEXIT #=    57 LV= 1 TEST
*MCALL #=   103 LV= 1          TEST   DB,=DB'1'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=   104 LV= 2          TEST1 MF,DB,=DB'1'
         BASR  R12,0
         USING *,R12
*MCALL #=   105 LV= 3          CTD   CTD_DB,IN==DB'1',OUT=DECIMAL,LINKAX
               GE=MF
         LA    1,=A(CTD_DB,0,DECIMAL)
         LA    0,=DB'1'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   105 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D DB'
         MVC   DHEX,=CL32' '
         LA    R2,=DB'1'
         LA    R3,L'=DB'1'
*MCALL #=   106 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   107 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   107 LV= 4 ZCALL
*MEXIT #=   106 LV= 3 CALL
*MCALL #=   108 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   108 LV= 3 WTO
*MCALL #=   109 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   110 LV= 4          ZSTREQU 
*MEXIT #=   110 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_9_2
*MEXIT #=   109 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   111 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   111 LV= 3 WTO
*MCALL #=   112 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   112 LV= 3 ABEND
*MCALL #=   113 LV= 3          ENDIF 
*MCALL #=   114 LV= 4          ZSTREQU 
*MEXIT #=   114 LV= 4 ZSTREQU
#@IF_9_2                                                 DS 0H
*MEXIT #=   113 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   115 LV= 3          CFD   CFD_DB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_DB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   115 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D DB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DB'1'
*MCALL #=   116 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   117 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   117 LV= 4 ZCALL
*MEXIT #=   116 LV= 3 CALL
*MCALL #=   118 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   118 LV= 3 WTO
*MCALL #=   119 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   120 LV= 4          ZSTREQU 
*MEXIT #=   120 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_10_2
*MEXIT #=   119 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   121 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   121 LV= 3 WTO
*MCALL #=   122 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   122 LV= 3 ABEND
*MCALL #=   123 LV= 3          ENDIF 
*MCALL #=   124 LV= 4          ZSTREQU 
*MEXIT #=   124 LV= 4 ZSTREQU
#@IF_10_2                                                DS 0H
*MEXIT #=   123 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DB'1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DB'1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=   125 LV= 3          RT1   CCE
         DS    0H
RT1_TEST7        BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE7
         LTORG 
RT1_CCE7        DS 0H
*MEXIT #=   125 LV= 3 RT1
         B     EXIT5
         LTORG 
EXIT5       DS 0H
*MEXIT #=   104 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=   126 LV= 2          TEST1 SVC,DB,=DB'1'
         BASR  R12,0
         USING *,R12
*MCALL #=   127 LV= 3          CTD   CTD_DB,IN==DB'1',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_DB,0,DECIMAL)
         LA    0,=DB'1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   127 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DB'
         MVC   DHEX,=CL32' '
         LA    R2,=DB'1'
         LA    R3,L'=DB'1'
*MCALL #=   128 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   129 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   129 LV= 4 ZCALL
*MEXIT #=   128 LV= 3 CALL
*MCALL #=   130 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   130 LV= 3 WTO
*MCALL #=   131 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   132 LV= 4          ZSTREQU 
*MEXIT #=   132 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_11_2
*MEXIT #=   131 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   133 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   133 LV= 3 WTO
*MCALL #=   134 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   134 LV= 3 ABEND
*MCALL #=   135 LV= 3          ENDIF 
*MCALL #=   136 LV= 4          ZSTREQU 
*MEXIT #=   136 LV= 4 ZSTREQU
#@IF_11_2                                                DS 0H
*MEXIT #=   135 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   137 LV= 3          CFD   CFD_DB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   137 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DB'1'
*MCALL #=   138 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   139 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   139 LV= 4 ZCALL
*MEXIT #=   138 LV= 3 CALL
*MCALL #=   140 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   140 LV= 3 WTO
*MCALL #=   141 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   142 LV= 4          ZSTREQU 
*MEXIT #=   142 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_12_2
*MEXIT #=   141 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   143 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   143 LV= 3 WTO
*MCALL #=   144 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   144 LV= 3 ABEND
*MCALL #=   145 LV= 3          ENDIF 
*MCALL #=   146 LV= 4          ZSTREQU 
*MEXIT #=   146 LV= 4 ZSTREQU
#@IF_12_2                                                DS 0H
*MEXIT #=   145 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DB'1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DB'1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=   147 LV= 3          RT1   CCE
         DS    0H
RT1_TEST8        BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE8
         LTORG 
RT1_CCE8        DS 0H
*MEXIT #=   147 LV= 3 RT1
         B     EXIT6
         LTORG 
EXIT6       DS 0H
*MEXIT #=   126 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=   148 LV= 2          RT1   CCE
         DS    0H
RT1_TEST9        BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE9
         LTORG 
RT1_CCE9        DS 0H
*MEXIT #=   148 LV= 2 RT1
*MEXIT #=   103 LV= 1 TEST
*MCALL #=   149 LV= 1          TEST   DB,=DB'2'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=   150 LV= 2          TEST1 MF,DB,=DB'2'
         BASR  R12,0
         USING *,R12
*MCALL #=   151 LV= 3          CTD   CTD_DB,IN==DB'2',OUT=DECIMAL,LINKAX
               GE=MF
         LA    1,=A(CTD_DB,0,DECIMAL)
         LA    0,=DB'2'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   151 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D DB'
         MVC   DHEX,=CL32' '
         LA    R2,=DB'2'
         LA    R3,L'=DB'2'
*MCALL #=   152 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   153 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   153 LV= 4 ZCALL
*MEXIT #=   152 LV= 3 CALL
*MCALL #=   154 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   154 LV= 3 WTO
*MCALL #=   155 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   156 LV= 4          ZSTREQU 
*MEXIT #=   156 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_13_2
*MEXIT #=   155 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   157 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   157 LV= 3 WTO
*MCALL #=   158 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   158 LV= 3 ABEND
*MCALL #=   159 LV= 3          ENDIF 
*MCALL #=   160 LV= 4          ZSTREQU 
*MEXIT #=   160 LV= 4 ZSTREQU
#@IF_13_2                                                DS 0H
*MEXIT #=   159 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   161 LV= 3          CFD   CFD_DB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_DB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   161 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D DB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DB'2'
*MCALL #=   162 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   163 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   163 LV= 4 ZCALL
*MEXIT #=   162 LV= 3 CALL
*MCALL #=   164 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   164 LV= 3 WTO
*MCALL #=   165 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   166 LV= 4          ZSTREQU 
*MEXIT #=   166 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_14_2
*MEXIT #=   165 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   167 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   167 LV= 3 WTO
*MCALL #=   168 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   168 LV= 3 ABEND
*MCALL #=   169 LV= 3          ENDIF 
*MCALL #=   170 LV= 4          ZSTREQU 
*MEXIT #=   170 LV= 4 ZSTREQU
#@IF_14_2                                                DS 0H
*MEXIT #=   169 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DB'2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DB'2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=   171 LV= 3          RT1   CCE
         DS    0H
RT1_TEST10       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE10
         LTORG 
RT1_CCE10       DS 0H
*MEXIT #=   171 LV= 3 RT1
         B     EXIT7
         LTORG 
EXIT7       DS 0H
*MEXIT #=   150 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=   172 LV= 2          TEST1 SVC,DB,=DB'2'
         BASR  R12,0
         USING *,R12
*MCALL #=   173 LV= 3          CTD   CTD_DB,IN==DB'2',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_DB,0,DECIMAL)
         LA    0,=DB'2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   173 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DB'
         MVC   DHEX,=CL32' '
         LA    R2,=DB'2'
         LA    R3,L'=DB'2'
*MCALL #=   174 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   175 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   175 LV= 4 ZCALL
*MEXIT #=   174 LV= 3 CALL
*MCALL #=   176 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   176 LV= 3 WTO
*MCALL #=   177 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   178 LV= 4          ZSTREQU 
*MEXIT #=   178 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_15_2
*MEXIT #=   177 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   179 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   179 LV= 3 WTO
*MCALL #=   180 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   180 LV= 3 ABEND
*MCALL #=   181 LV= 3          ENDIF 
*MCALL #=   182 LV= 4          ZSTREQU 
*MEXIT #=   182 LV= 4 ZSTREQU
#@IF_15_2                                                DS 0H
*MEXIT #=   181 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   183 LV= 3          CFD   CFD_DB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   183 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DB'2'
*MCALL #=   184 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   185 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   185 LV= 4 ZCALL
*MEXIT #=   184 LV= 3 CALL
*MCALL #=   186 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   186 LV= 3 WTO
*MCALL #=   187 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   188 LV= 4          ZSTREQU 
*MEXIT #=   188 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_16_2
*MEXIT #=   187 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   189 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   189 LV= 3 WTO
*MCALL #=   190 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   190 LV= 3 ABEND
*MCALL #=   191 LV= 3          ENDIF 
*MCALL #=   192 LV= 4          ZSTREQU 
*MEXIT #=   192 LV= 4 ZSTREQU
#@IF_16_2                                                DS 0H
*MEXIT #=   191 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DB'2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DB'2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=   193 LV= 3          RT1   CCE
         DS    0H
RT1_TEST11       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE11
         LTORG 
RT1_CCE11       DS 0H
*MEXIT #=   193 LV= 3 RT1
         B     EXIT8
         LTORG 
EXIT8       DS 0H
*MEXIT #=   172 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=   194 LV= 2          RT1   CCE
         DS    0H
RT1_TEST12       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE12
         LTORG 
RT1_CCE12       DS 0H
*MEXIT #=   194 LV= 2 RT1
*MEXIT #=   149 LV= 1 TEST
*MCALL #=   195 LV= 1          TEST   DB,=DB'1E2'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=   196 LV= 2          TEST1 MF,DB,=DB'1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=   197 LV= 3          CTD   CTD_DB,IN==DB'1E2',OUT=DECIMAL,LINX
               KAGE=MF
         LA    1,=A(CTD_DB,0,DECIMAL)
         LA    0,=DB'1E2'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   197 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D DB'
         MVC   DHEX,=CL32' '
         LA    R2,=DB'1E2'
         LA    R3,L'=DB'1E2'
*MCALL #=   198 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   199 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   199 LV= 4 ZCALL
*MEXIT #=   198 LV= 3 CALL
*MCALL #=   200 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   200 LV= 3 WTO
*MCALL #=   201 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   202 LV= 4          ZSTREQU 
*MEXIT #=   202 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_17_2
*MEXIT #=   201 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   203 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   203 LV= 3 WTO
*MCALL #=   204 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   204 LV= 3 ABEND
*MCALL #=   205 LV= 3          ENDIF 
*MCALL #=   206 LV= 4          ZSTREQU 
*MEXIT #=   206 LV= 4 ZSTREQU
#@IF_17_2                                                DS 0H
*MEXIT #=   205 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   207 LV= 3          CFD   CFD_DB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_DB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   207 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D DB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DB'1E2'
*MCALL #=   208 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   209 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   209 LV= 4 ZCALL
*MEXIT #=   208 LV= 3 CALL
*MCALL #=   210 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   210 LV= 3 WTO
*MCALL #=   211 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   212 LV= 4          ZSTREQU 
*MEXIT #=   212 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_18_2
*MEXIT #=   211 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   213 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   213 LV= 3 WTO
*MCALL #=   214 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   214 LV= 3 ABEND
*MCALL #=   215 LV= 3          ENDIF 
*MCALL #=   216 LV= 4          ZSTREQU 
*MEXIT #=   216 LV= 4 ZSTREQU
#@IF_18_2                                                DS 0H
*MEXIT #=   215 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DB'1E2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DB'1E2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=   217 LV= 3          RT1   CCE
         DS    0H
RT1_TEST13       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE13
         LTORG 
RT1_CCE13       DS 0H
*MEXIT #=   217 LV= 3 RT1
         B     EXIT9
         LTORG 
EXIT9       DS 0H
*MEXIT #=   196 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=   218 LV= 2          TEST1 SVC,DB,=DB'1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=   219 LV= 3          CTD   CTD_DB,IN==DB'1E2',OUT=DECIMAL,LINX
               KAGE=SVC
         LA    1,=A(CTD_DB,0,DECIMAL)
         LA    0,=DB'1E2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   219 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DB'
         MVC   DHEX,=CL32' '
         LA    R2,=DB'1E2'
         LA    R3,L'=DB'1E2'
*MCALL #=   220 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   221 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   221 LV= 4 ZCALL
*MEXIT #=   220 LV= 3 CALL
*MCALL #=   222 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   222 LV= 3 WTO
*MCALL #=   223 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   224 LV= 4          ZSTREQU 
*MEXIT #=   224 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_19_2
*MEXIT #=   223 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   225 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   225 LV= 3 WTO
*MCALL #=   226 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   226 LV= 3 ABEND
*MCALL #=   227 LV= 3          ENDIF 
*MCALL #=   228 LV= 4          ZSTREQU 
*MEXIT #=   228 LV= 4 ZSTREQU
#@IF_19_2                                                DS 0H
*MEXIT #=   227 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   229 LV= 3          CFD   CFD_DB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   229 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DB'1E2'
*MCALL #=   230 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   231 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   231 LV= 4 ZCALL
*MEXIT #=   230 LV= 3 CALL
*MCALL #=   232 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   232 LV= 3 WTO
*MCALL #=   233 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   234 LV= 4          ZSTREQU 
*MEXIT #=   234 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_20_2
*MEXIT #=   233 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   235 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   235 LV= 3 WTO
*MCALL #=   236 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   236 LV= 3 ABEND
*MCALL #=   237 LV= 3          ENDIF 
*MCALL #=   238 LV= 4          ZSTREQU 
*MEXIT #=   238 LV= 4 ZSTREQU
#@IF_20_2                                                DS 0H
*MEXIT #=   237 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DB'1E2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DB'1E2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=   239 LV= 3          RT1   CCE
         DS    0H
RT1_TEST14       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE14
         LTORG 
RT1_CCE14       DS 0H
*MEXIT #=   239 LV= 3 RT1
         B     EXIT10
         LTORG 
EXIT10      DS 0H
*MEXIT #=   218 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=   240 LV= 2          RT1   CCE
         DS    0H
RT1_TEST15       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE15
         LTORG 
RT1_CCE15       DS 0H
*MEXIT #=   240 LV= 2 RT1
*MEXIT #=   195 LV= 1 TEST
*MCALL #=   241 LV= 1          TEST   DB,=DB'1E307'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=   242 LV= 2          TEST1 MF,DB,=DB'1E307'
         BASR  R12,0
         USING *,R12
*MCALL #=   243 LV= 3          CTD   CTD_DB,IN==DB'1E307',OUT=DECIMAL,LX
               INKAGE=MF
         LA    1,=A(CTD_DB,0,DECIMAL)
         LA    0,=DB'1E307'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   243 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D DB'
         MVC   DHEX,=CL32' '
         LA    R2,=DB'1E307'
         LA    R3,L'=DB'1E307'
*MCALL #=   244 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   245 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   245 LV= 4 ZCALL
*MEXIT #=   244 LV= 3 CALL
*MCALL #=   246 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   246 LV= 3 WTO
*MCALL #=   247 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   248 LV= 4          ZSTREQU 
*MEXIT #=   248 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_21_2
*MEXIT #=   247 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   249 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   249 LV= 3 WTO
*MCALL #=   250 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   250 LV= 3 ABEND
*MCALL #=   251 LV= 3          ENDIF 
*MCALL #=   252 LV= 4          ZSTREQU 
*MEXIT #=   252 LV= 4 ZSTREQU
#@IF_21_2                                                DS 0H
*MEXIT #=   251 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   253 LV= 3          CFD   CFD_DB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_DB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   253 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D DB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DB'1E307'
*MCALL #=   254 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   255 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   255 LV= 4 ZCALL
*MEXIT #=   254 LV= 3 CALL
*MCALL #=   256 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   256 LV= 3 WTO
*MCALL #=   257 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   258 LV= 4          ZSTREQU 
*MEXIT #=   258 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_22_2
*MEXIT #=   257 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   259 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   259 LV= 3 WTO
*MCALL #=   260 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   260 LV= 3 ABEND
*MCALL #=   261 LV= 3          ENDIF 
*MCALL #=   262 LV= 4          ZSTREQU 
*MEXIT #=   262 LV= 4 ZSTREQU
#@IF_22_2                                                DS 0H
*MEXIT #=   261 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DB'1E307'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DB'1E307'  VERIFY CTD CONSTANT WITH CFD RESULX
               T
* RPI 786 START TEST FOR DFP
*MCALL #=   263 LV= 3          RT1   CCE
         DS    0H
RT1_TEST16       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE16
         LTORG 
RT1_CCE16       DS 0H
*MEXIT #=   263 LV= 3 RT1
         B     EXIT11
         LTORG 
EXIT11      DS 0H
*MEXIT #=   242 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=   264 LV= 2          TEST1 SVC,DB,=DB'1E307'
         BASR  R12,0
         USING *,R12
*MCALL #=   265 LV= 3          CTD   CTD_DB,IN==DB'1E307',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_DB,0,DECIMAL)
         LA    0,=DB'1E307'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   265 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DB'
         MVC   DHEX,=CL32' '
         LA    R2,=DB'1E307'
         LA    R3,L'=DB'1E307'
*MCALL #=   266 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   267 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   267 LV= 4 ZCALL
*MEXIT #=   266 LV= 3 CALL
*MCALL #=   268 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   268 LV= 3 WTO
*MCALL #=   269 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   270 LV= 4          ZSTREQU 
*MEXIT #=   270 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_23_2
*MEXIT #=   269 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   271 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   271 LV= 3 WTO
*MCALL #=   272 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   272 LV= 3 ABEND
*MCALL #=   273 LV= 3          ENDIF 
*MCALL #=   274 LV= 4          ZSTREQU 
*MEXIT #=   274 LV= 4 ZSTREQU
#@IF_23_2                                                DS 0H
*MEXIT #=   273 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   275 LV= 3          CFD   CFD_DB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   275 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DB'1E307'
*MCALL #=   276 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   277 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   277 LV= 4 ZCALL
*MEXIT #=   276 LV= 3 CALL
*MCALL #=   278 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   278 LV= 3 WTO
*MCALL #=   279 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   280 LV= 4          ZSTREQU 
*MEXIT #=   280 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_24_2
*MEXIT #=   279 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   281 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   281 LV= 3 WTO
*MCALL #=   282 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   282 LV= 3 ABEND
*MCALL #=   283 LV= 3          ENDIF 
*MCALL #=   284 LV= 4          ZSTREQU 
*MEXIT #=   284 LV= 4 ZSTREQU
#@IF_24_2                                                DS 0H
*MEXIT #=   283 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DB'1E307'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DB'1E307'  VERIFY CTD CONSTANT WITH CFD RESULX
               T
* RPI 786 START TEST FOR DFP
*MCALL #=   285 LV= 3          RT1   CCE
         DS    0H
RT1_TEST17       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE17
         LTORG 
RT1_CCE17       DS 0H
*MEXIT #=   285 LV= 3 RT1
         B     EXIT12
         LTORG 
EXIT12      DS 0H
*MEXIT #=   264 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=   286 LV= 2          RT1   CCE
         DS    0H
RT1_TEST18       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE18
         LTORG 
RT1_CCE18       DS 0H
*MEXIT #=   286 LV= 2 RT1
*MEXIT #=   241 LV= 1 TEST
*MCALL #=   287 LV= 1          TEST   DB,=DB'-1'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=   288 LV= 2          TEST1 MF,DB,=DB'-1'
         BASR  R12,0
         USING *,R12
*MCALL #=   289 LV= 3          CTD   CTD_DB,IN==DB'-1',OUT=DECIMAL,LINKX
               AGE=MF
         LA    1,=A(CTD_DB,0,DECIMAL)
         LA    0,=DB'-1'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   289 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D DB'
         MVC   DHEX,=CL32' '
         LA    R2,=DB'-1'
         LA    R3,L'=DB'-1'
*MCALL #=   290 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   291 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   291 LV= 4 ZCALL
*MEXIT #=   290 LV= 3 CALL
*MCALL #=   292 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   292 LV= 3 WTO
*MCALL #=   293 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   294 LV= 4          ZSTREQU 
*MEXIT #=   294 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_25_2
*MEXIT #=   293 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   295 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   295 LV= 3 WTO
*MCALL #=   296 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   296 LV= 3 ABEND
*MCALL #=   297 LV= 3          ENDIF 
*MCALL #=   298 LV= 4          ZSTREQU 
*MEXIT #=   298 LV= 4 ZSTREQU
#@IF_25_2                                                DS 0H
*MEXIT #=   297 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   299 LV= 3          CFD   CFD_DB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_DB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   299 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D DB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DB'-1'
*MCALL #=   300 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   301 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   301 LV= 4 ZCALL
*MEXIT #=   300 LV= 3 CALL
*MCALL #=   302 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   302 LV= 3 WTO
*MCALL #=   303 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   304 LV= 4          ZSTREQU 
*MEXIT #=   304 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_26_2
*MEXIT #=   303 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   305 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   305 LV= 3 WTO
*MCALL #=   306 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   306 LV= 3 ABEND
*MCALL #=   307 LV= 3          ENDIF 
*MCALL #=   308 LV= 4          ZSTREQU 
*MEXIT #=   308 LV= 4 ZSTREQU
#@IF_26_2                                                DS 0H
*MEXIT #=   307 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DB'-1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DB'-1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=   309 LV= 3          RT1   CCE
         DS    0H
RT1_TEST19       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE19
         LTORG 
RT1_CCE19       DS 0H
*MEXIT #=   309 LV= 3 RT1
         B     EXIT13
         LTORG 
EXIT13      DS 0H
*MEXIT #=   288 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=   310 LV= 2          TEST1 SVC,DB,=DB'-1'
         BASR  R12,0
         USING *,R12
*MCALL #=   311 LV= 3          CTD   CTD_DB,IN==DB'-1',OUT=DECIMAL,LINKX
               AGE=SVC
         LA    1,=A(CTD_DB,0,DECIMAL)
         LA    0,=DB'-1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   311 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DB'
         MVC   DHEX,=CL32' '
         LA    R2,=DB'-1'
         LA    R3,L'=DB'-1'
*MCALL #=   312 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   313 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   313 LV= 4 ZCALL
*MEXIT #=   312 LV= 3 CALL
*MCALL #=   314 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   314 LV= 3 WTO
*MCALL #=   315 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   316 LV= 4          ZSTREQU 
*MEXIT #=   316 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_27_2
*MEXIT #=   315 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   317 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   317 LV= 3 WTO
*MCALL #=   318 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   318 LV= 3 ABEND
*MCALL #=   319 LV= 3          ENDIF 
*MCALL #=   320 LV= 4          ZSTREQU 
*MEXIT #=   320 LV= 4 ZSTREQU
#@IF_27_2                                                DS 0H
*MEXIT #=   319 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   321 LV= 3          CFD   CFD_DB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   321 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DB'-1'
*MCALL #=   322 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   323 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   323 LV= 4 ZCALL
*MEXIT #=   322 LV= 3 CALL
*MCALL #=   324 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   324 LV= 3 WTO
*MCALL #=   325 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   326 LV= 4          ZSTREQU 
*MEXIT #=   326 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_28_2
*MEXIT #=   325 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   327 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   327 LV= 3 WTO
*MCALL #=   328 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   328 LV= 3 ABEND
*MCALL #=   329 LV= 3          ENDIF 
*MCALL #=   330 LV= 4          ZSTREQU 
*MEXIT #=   330 LV= 4 ZSTREQU
#@IF_28_2                                                DS 0H
*MEXIT #=   329 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DB'-1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DB'-1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=   331 LV= 3          RT1   CCE
         DS    0H
RT1_TEST20       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE20
         LTORG 
RT1_CCE20       DS 0H
*MEXIT #=   331 LV= 3 RT1
         B     EXIT14
         LTORG 
EXIT14      DS 0H
*MEXIT #=   310 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=   332 LV= 2          RT1   CCE
         DS    0H
RT1_TEST21       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE21
         LTORG 
RT1_CCE21       DS 0H
*MEXIT #=   332 LV= 2 RT1
*MEXIT #=   287 LV= 1 TEST
*MCALL #=   333 LV= 1          TEST   DB,=DB'-2'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=   334 LV= 2          TEST1 MF,DB,=DB'-2'
         BASR  R12,0
         USING *,R12
*MCALL #=   335 LV= 3          CTD   CTD_DB,IN==DB'-2',OUT=DECIMAL,LINKX
               AGE=MF
         LA    1,=A(CTD_DB,0,DECIMAL)
         LA    0,=DB'-2'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   335 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D DB'
         MVC   DHEX,=CL32' '
         LA    R2,=DB'-2'
         LA    R3,L'=DB'-2'
*MCALL #=   336 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   337 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   337 LV= 4 ZCALL
*MEXIT #=   336 LV= 3 CALL
*MCALL #=   338 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   338 LV= 3 WTO
*MCALL #=   339 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   340 LV= 4          ZSTREQU 
*MEXIT #=   340 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_29_2
*MEXIT #=   339 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   341 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   341 LV= 3 WTO
*MCALL #=   342 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   342 LV= 3 ABEND
*MCALL #=   343 LV= 3          ENDIF 
*MCALL #=   344 LV= 4          ZSTREQU 
*MEXIT #=   344 LV= 4 ZSTREQU
#@IF_29_2                                                DS 0H
*MEXIT #=   343 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   345 LV= 3          CFD   CFD_DB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_DB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   345 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D DB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DB'-2'
*MCALL #=   346 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   347 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   347 LV= 4 ZCALL
*MEXIT #=   346 LV= 3 CALL
*MCALL #=   348 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   348 LV= 3 WTO
*MCALL #=   349 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   350 LV= 4          ZSTREQU 
*MEXIT #=   350 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_30_2
*MEXIT #=   349 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   351 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   351 LV= 3 WTO
*MCALL #=   352 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   352 LV= 3 ABEND
*MCALL #=   353 LV= 3          ENDIF 
*MCALL #=   354 LV= 4          ZSTREQU 
*MEXIT #=   354 LV= 4 ZSTREQU
#@IF_30_2                                                DS 0H
*MEXIT #=   353 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DB'-2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DB'-2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=   355 LV= 3          RT1   CCE
         DS    0H
RT1_TEST22       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE22
         LTORG 
RT1_CCE22       DS 0H
*MEXIT #=   355 LV= 3 RT1
         B     EXIT15
         LTORG 
EXIT15      DS 0H
*MEXIT #=   334 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=   356 LV= 2          TEST1 SVC,DB,=DB'-2'
         BASR  R12,0
         USING *,R12
*MCALL #=   357 LV= 3          CTD   CTD_DB,IN==DB'-2',OUT=DECIMAL,LINKX
               AGE=SVC
         LA    1,=A(CTD_DB,0,DECIMAL)
         LA    0,=DB'-2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   357 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DB'
         MVC   DHEX,=CL32' '
         LA    R2,=DB'-2'
         LA    R3,L'=DB'-2'
*MCALL #=   358 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   359 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   359 LV= 4 ZCALL
*MEXIT #=   358 LV= 3 CALL
*MCALL #=   360 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   360 LV= 3 WTO
*MCALL #=   361 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   362 LV= 4          ZSTREQU 
*MEXIT #=   362 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_31_2
*MEXIT #=   361 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   363 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   363 LV= 3 WTO
*MCALL #=   364 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   364 LV= 3 ABEND
*MCALL #=   365 LV= 3          ENDIF 
*MCALL #=   366 LV= 4          ZSTREQU 
*MEXIT #=   366 LV= 4 ZSTREQU
#@IF_31_2                                                DS 0H
*MEXIT #=   365 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   367 LV= 3          CFD   CFD_DB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   367 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DB'-2'
*MCALL #=   368 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   369 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   369 LV= 4 ZCALL
*MEXIT #=   368 LV= 3 CALL
*MCALL #=   370 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   370 LV= 3 WTO
*MCALL #=   371 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   372 LV= 4          ZSTREQU 
*MEXIT #=   372 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_32_2
*MEXIT #=   371 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   373 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   373 LV= 3 WTO
*MCALL #=   374 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   374 LV= 3 ABEND
*MCALL #=   375 LV= 3          ENDIF 
*MCALL #=   376 LV= 4          ZSTREQU 
*MEXIT #=   376 LV= 4 ZSTREQU
#@IF_32_2                                                DS 0H
*MEXIT #=   375 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DB'-2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DB'-2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=   377 LV= 3          RT1   CCE
         DS    0H
RT1_TEST23       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE23
         LTORG 
RT1_CCE23       DS 0H
*MEXIT #=   377 LV= 3 RT1
         B     EXIT16
         LTORG 
EXIT16      DS 0H
*MEXIT #=   356 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=   378 LV= 2          RT1   CCE
         DS    0H
RT1_TEST24       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE24
         LTORG 
RT1_CCE24       DS 0H
*MEXIT #=   378 LV= 2 RT1
*MEXIT #=   333 LV= 1 TEST
*MCALL #=   379 LV= 1          TEST   DB,=DB'-1E2'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=   380 LV= 2          TEST1 MF,DB,=DB'-1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=   381 LV= 3          CTD   CTD_DB,IN==DB'-1E2',OUT=DECIMAL,LIX
               NKAGE=MF
         LA    1,=A(CTD_DB,0,DECIMAL)
         LA    0,=DB'-1E2'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   381 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D DB'
         MVC   DHEX,=CL32' '
         LA    R2,=DB'-1E2'
         LA    R3,L'=DB'-1E2'
*MCALL #=   382 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   383 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   383 LV= 4 ZCALL
*MEXIT #=   382 LV= 3 CALL
*MCALL #=   384 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   384 LV= 3 WTO
*MCALL #=   385 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   386 LV= 4          ZSTREQU 
*MEXIT #=   386 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_33_2
*MEXIT #=   385 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   387 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   387 LV= 3 WTO
*MCALL #=   388 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   388 LV= 3 ABEND
*MCALL #=   389 LV= 3          ENDIF 
*MCALL #=   390 LV= 4          ZSTREQU 
*MEXIT #=   390 LV= 4 ZSTREQU
#@IF_33_2                                                DS 0H
*MEXIT #=   389 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   391 LV= 3          CFD   CFD_DB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_DB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   391 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D DB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DB'-1E2'
*MCALL #=   392 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   393 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   393 LV= 4 ZCALL
*MEXIT #=   392 LV= 3 CALL
*MCALL #=   394 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   394 LV= 3 WTO
*MCALL #=   395 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   396 LV= 4          ZSTREQU 
*MEXIT #=   396 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_34_2
*MEXIT #=   395 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   397 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   397 LV= 3 WTO
*MCALL #=   398 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   398 LV= 3 ABEND
*MCALL #=   399 LV= 3          ENDIF 
*MCALL #=   400 LV= 4          ZSTREQU 
*MEXIT #=   400 LV= 4 ZSTREQU
#@IF_34_2                                                DS 0H
*MEXIT #=   399 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DB'-1E2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DB'-1E2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=   401 LV= 3          RT1   CCE
         DS    0H
RT1_TEST25       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE25
         LTORG 
RT1_CCE25       DS 0H
*MEXIT #=   401 LV= 3 RT1
         B     EXIT17
         LTORG 
EXIT17      DS 0H
*MEXIT #=   380 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=   402 LV= 2          TEST1 SVC,DB,=DB'-1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=   403 LV= 3          CTD   CTD_DB,IN==DB'-1E2',OUT=DECIMAL,LIX
               NKAGE=SVC
         LA    1,=A(CTD_DB,0,DECIMAL)
         LA    0,=DB'-1E2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   403 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DB'
         MVC   DHEX,=CL32' '
         LA    R2,=DB'-1E2'
         LA    R3,L'=DB'-1E2'
*MCALL #=   404 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   405 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   405 LV= 4 ZCALL
*MEXIT #=   404 LV= 3 CALL
*MCALL #=   406 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   406 LV= 3 WTO
*MCALL #=   407 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   408 LV= 4          ZSTREQU 
*MEXIT #=   408 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_35_2
*MEXIT #=   407 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   409 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   409 LV= 3 WTO
*MCALL #=   410 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   410 LV= 3 ABEND
*MCALL #=   411 LV= 3          ENDIF 
*MCALL #=   412 LV= 4          ZSTREQU 
*MEXIT #=   412 LV= 4 ZSTREQU
#@IF_35_2                                                DS 0H
*MEXIT #=   411 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   413 LV= 3          CFD   CFD_DB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   413 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DB'-1E2'
*MCALL #=   414 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   415 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   415 LV= 4 ZCALL
*MEXIT #=   414 LV= 3 CALL
*MCALL #=   416 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   416 LV= 3 WTO
*MCALL #=   417 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   418 LV= 4          ZSTREQU 
*MEXIT #=   418 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_36_2
*MEXIT #=   417 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   419 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   419 LV= 3 WTO
*MCALL #=   420 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   420 LV= 3 ABEND
*MCALL #=   421 LV= 3          ENDIF 
*MCALL #=   422 LV= 4          ZSTREQU 
*MEXIT #=   422 LV= 4 ZSTREQU
#@IF_36_2                                                DS 0H
*MEXIT #=   421 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DB'-1E2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DB'-1E2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=   423 LV= 3          RT1   CCE
         DS    0H
RT1_TEST26       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE26
         LTORG 
RT1_CCE26       DS 0H
*MEXIT #=   423 LV= 3 RT1
         B     EXIT18
         LTORG 
EXIT18      DS 0H
*MEXIT #=   402 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=   424 LV= 2          RT1   CCE
         DS    0H
RT1_TEST27       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE27
         LTORG 
RT1_CCE27       DS 0H
*MEXIT #=   424 LV= 2 RT1
*MEXIT #=   379 LV= 1 TEST
* DD
*MCALL #=   425 LV= 1          TEST   DD,=DD'0'
*MCALL #=   426 LV= 2          TEST1 SVC,DD,=DD'0'
         BASR  R12,0
         USING *,R12
*MCALL #=   427 LV= 3          CTD   CTD_DD,IN==DD'0',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_DD,0,DECIMAL)
         LA    0,=DD'0'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   427 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DD'
         MVC   DHEX,=CL32' '
         LA    R2,=DD'0'
         LA    R3,L'=DD'0'
*MCALL #=   428 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   429 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   429 LV= 4 ZCALL
*MEXIT #=   428 LV= 3 CALL
*MCALL #=   430 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   430 LV= 3 WTO
*MCALL #=   431 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   432 LV= 4          ZSTREQU 
*MEXIT #=   432 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_37_2
*MEXIT #=   431 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   433 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   433 LV= 3 WTO
*MCALL #=   434 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   434 LV= 3 ABEND
*MCALL #=   435 LV= 3          ENDIF 
*MCALL #=   436 LV= 4          ZSTREQU 
*MEXIT #=   436 LV= 4 ZSTREQU
#@IF_37_2                                                DS 0H
*MEXIT #=   435 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   437 LV= 3          CFD   CFD_DD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   437 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DD'0'
*MCALL #=   438 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   439 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   439 LV= 4 ZCALL
*MEXIT #=   438 LV= 3 CALL
*MCALL #=   440 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   440 LV= 3 WTO
*MCALL #=   441 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   442 LV= 4          ZSTREQU 
*MEXIT #=   442 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_38_2
*MEXIT #=   441 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   443 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   443 LV= 3 WTO
*MCALL #=   444 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   444 LV= 3 ABEND
*MCALL #=   445 LV= 3          ENDIF 
*MCALL #=   446 LV= 4          ZSTREQU 
*MEXIT #=   446 LV= 4 ZSTREQU
#@IF_38_2                                                DS 0H
*MEXIT #=   445 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LD    R0,=DD'0'
         LD    R1,WORK16
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=   447 LV= 3          RT1   CCE
         DS    0H
RT1_TEST28       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE28
         LTORG 
RT1_CCE28       DS 0H
*MEXIT #=   447 LV= 3 RT1
         B     EXIT19
         LTORG 
EXIT19      DS 0H
*MEXIT #=   426 LV= 2 TEST1
*MEXIT #=   425 LV= 1 TEST
*MCALL #=   448 LV= 1          TEST   DD,=DD'0.1234567890123456'
*MCALL #=   449 LV= 2          TEST1 SVC,DD,=DD'0.1234567890123456'
         BASR  R12,0
         USING *,R12
*MCALL #=   450 LV= 3          CTD   CTD_DD,IN==DD'0.1234567890123456',X
               OUT=DECIMAL,LINKAGE=SVC
         LA    1,=A(CTD_DD,0,DECIMAL)
         LA    0,=DD'0.1234567890123456'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   450 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DD'
         MVC   DHEX,=CL32' '
         LA    R2,=DD'0.1234567890123456'
         LA    R3,L'=DD'0.1234567890123456'
*MCALL #=   451 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   452 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   452 LV= 4 ZCALL
*MEXIT #=   451 LV= 3 CALL
*MCALL #=   453 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   453 LV= 3 WTO
*MCALL #=   454 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   455 LV= 4          ZSTREQU 
*MEXIT #=   455 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_39_2
*MEXIT #=   454 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   456 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   456 LV= 3 WTO
*MCALL #=   457 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   457 LV= 3 ABEND
*MCALL #=   458 LV= 3          ENDIF 
*MCALL #=   459 LV= 4          ZSTREQU 
*MEXIT #=   459 LV= 4 ZSTREQU
#@IF_39_2                                                DS 0H
*MEXIT #=   458 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   460 LV= 3          CFD   CFD_DD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   460 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DD'0.1234567890123456'
*MCALL #=   461 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   462 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   462 LV= 4 ZCALL
*MEXIT #=   461 LV= 3 CALL
*MCALL #=   463 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   463 LV= 3 WTO
*MCALL #=   464 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   465 LV= 4          ZSTREQU 
*MEXIT #=   465 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_40_2
*MEXIT #=   464 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   466 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   466 LV= 3 WTO
*MCALL #=   467 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   467 LV= 3 ABEND
*MCALL #=   468 LV= 3          ENDIF 
*MCALL #=   469 LV= 4          ZSTREQU 
*MEXIT #=   469 LV= 4 ZSTREQU
#@IF_40_2                                                DS 0H
*MEXIT #=   468 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LD    R0,=DD'0.1234567890123456'
         LD    R1,WORK16
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=   470 LV= 3          RT1   CCE
         DS    0H
RT1_TEST29       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE29
         LTORG 
RT1_CCE29       DS 0H
*MEXIT #=   470 LV= 3 RT1
         B     EXIT20
         LTORG 
EXIT20      DS 0H
*MEXIT #=   449 LV= 2 TEST1
*MEXIT #=   448 LV= 1 TEST
*MCALL #=   471 LV= 1          TEST   DD,=DD'0.12345678901234560'
*MCALL #=   472 LV= 2          TEST1 SVC,DD,=DD'0.12345678901234560'
         BASR  R12,0
         USING *,R12
*MCALL #=   473 LV= 3          CTD   CTD_DD,IN==DD'0.12345678901234560'X
               ,OUT=DECIMAL,LINKAGE=SVC
         LA    1,=A(CTD_DD,0,DECIMAL)
         LA    0,=DD'0.12345678901234560'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   473 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DD'
         MVC   DHEX,=CL32' '
         LA    R2,=DD'0.12345678901234560'
         LA    R3,L'=DD'0.12345678901234560'
*MCALL #=   474 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   475 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   475 LV= 4 ZCALL
*MEXIT #=   474 LV= 3 CALL
*MCALL #=   476 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   476 LV= 3 WTO
*MCALL #=   477 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   478 LV= 4          ZSTREQU 
*MEXIT #=   478 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_41_2
*MEXIT #=   477 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   479 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   479 LV= 3 WTO
*MCALL #=   480 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   480 LV= 3 ABEND
*MCALL #=   481 LV= 3          ENDIF 
*MCALL #=   482 LV= 4          ZSTREQU 
*MEXIT #=   482 LV= 4 ZSTREQU
#@IF_41_2                                                DS 0H
*MEXIT #=   481 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   483 LV= 3          CFD   CFD_DD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   483 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DD'0.12345678901234560'
*MCALL #=   484 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   485 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   485 LV= 4 ZCALL
*MEXIT #=   484 LV= 3 CALL
*MCALL #=   486 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   486 LV= 3 WTO
*MCALL #=   487 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   488 LV= 4          ZSTREQU 
*MEXIT #=   488 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_42_2
*MEXIT #=   487 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   489 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   489 LV= 3 WTO
*MCALL #=   490 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   490 LV= 3 ABEND
*MCALL #=   491 LV= 3          ENDIF 
*MCALL #=   492 LV= 4          ZSTREQU 
*MEXIT #=   492 LV= 4 ZSTREQU
#@IF_42_2                                                DS 0H
*MEXIT #=   491 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LD    R0,=DD'0.12345678901234560'
         LD    R1,WORK16
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=   493 LV= 3          RT1   CCE
         DS    0H
RT1_TEST30       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE30
         LTORG 
RT1_CCE30       DS 0H
*MEXIT #=   493 LV= 3 RT1
         B     EXIT21
         LTORG 
EXIT21      DS 0H
*MEXIT #=   472 LV= 2 TEST1
*MEXIT #=   471 LV= 1 TEST
*MCALL #=   494 LV= 1          TEST   DD,=DD'1E-398'
*MCALL #=   495 LV= 2          TEST1 SVC,DD,=DD'1E-398'
         BASR  R12,0
         USING *,R12
*MCALL #=   496 LV= 3          CTD   CTD_DD,IN==DD'1E-398',OUT=DECIMAL,X
               LINKAGE=SVC
         LA    1,=A(CTD_DD,0,DECIMAL)
         LA    0,=DD'1E-398'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   496 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DD'
         MVC   DHEX,=CL32' '
         LA    R2,=DD'1E-398'
         LA    R3,L'=DD'1E-398'
*MCALL #=   497 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   498 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   498 LV= 4 ZCALL
*MEXIT #=   497 LV= 3 CALL
*MCALL #=   499 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   499 LV= 3 WTO
*MCALL #=   500 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   501 LV= 4          ZSTREQU 
*MEXIT #=   501 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_43_2
*MEXIT #=   500 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   502 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   502 LV= 3 WTO
*MCALL #=   503 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   503 LV= 3 ABEND
*MCALL #=   504 LV= 3          ENDIF 
*MCALL #=   505 LV= 4          ZSTREQU 
*MEXIT #=   505 LV= 4 ZSTREQU
#@IF_43_2                                                DS 0H
*MEXIT #=   504 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   506 LV= 3          CFD   CFD_DD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   506 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DD'1E-398'
*MCALL #=   507 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   508 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   508 LV= 4 ZCALL
*MEXIT #=   507 LV= 3 CALL
*MCALL #=   509 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   509 LV= 3 WTO
*MCALL #=   510 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   511 LV= 4          ZSTREQU 
*MEXIT #=   511 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_44_2
*MEXIT #=   510 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   512 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   512 LV= 3 WTO
*MCALL #=   513 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   513 LV= 3 ABEND
*MCALL #=   514 LV= 3          ENDIF 
*MCALL #=   515 LV= 4          ZSTREQU 
*MEXIT #=   515 LV= 4 ZSTREQU
#@IF_44_2                                                DS 0H
*MEXIT #=   514 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LD    R0,=DD'1E-398'
         LD    R1,WORK16
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=   516 LV= 3          RT1   CCE
         DS    0H
RT1_TEST31       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE31
         LTORG 
RT1_CCE31       DS 0H
*MEXIT #=   516 LV= 3 RT1
         B     EXIT22
         LTORG 
EXIT22      DS 0H
*MEXIT #=   495 LV= 2 TEST1
*MEXIT #=   494 LV= 1 TEST
*MCALL #=   517 LV= 1          TEST   DD,=DD'1'
*MCALL #=   518 LV= 2          TEST1 SVC,DD,=DD'1'
         BASR  R12,0
         USING *,R12
*MCALL #=   519 LV= 3          CTD   CTD_DD,IN==DD'1',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_DD,0,DECIMAL)
         LA    0,=DD'1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   519 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DD'
         MVC   DHEX,=CL32' '
         LA    R2,=DD'1'
         LA    R3,L'=DD'1'
*MCALL #=   520 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   521 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   521 LV= 4 ZCALL
*MEXIT #=   520 LV= 3 CALL
*MCALL #=   522 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   522 LV= 3 WTO
*MCALL #=   523 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   524 LV= 4          ZSTREQU 
*MEXIT #=   524 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_45_2
*MEXIT #=   523 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   525 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   525 LV= 3 WTO
*MCALL #=   526 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   526 LV= 3 ABEND
*MCALL #=   527 LV= 3          ENDIF 
*MCALL #=   528 LV= 4          ZSTREQU 
*MEXIT #=   528 LV= 4 ZSTREQU
#@IF_45_2                                                DS 0H
*MEXIT #=   527 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   529 LV= 3          CFD   CFD_DD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   529 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DD'1'
*MCALL #=   530 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   531 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   531 LV= 4 ZCALL
*MEXIT #=   530 LV= 3 CALL
*MCALL #=   532 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   532 LV= 3 WTO
*MCALL #=   533 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   534 LV= 4          ZSTREQU 
*MEXIT #=   534 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_46_2
*MEXIT #=   533 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   535 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   535 LV= 3 WTO
*MCALL #=   536 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   536 LV= 3 ABEND
*MCALL #=   537 LV= 3          ENDIF 
*MCALL #=   538 LV= 4          ZSTREQU 
*MEXIT #=   538 LV= 4 ZSTREQU
#@IF_46_2                                                DS 0H
*MEXIT #=   537 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LD    R0,=DD'1'
         LD    R1,WORK16
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=   539 LV= 3          RT1   CCE
         DS    0H
RT1_TEST32       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE32
         LTORG 
RT1_CCE32       DS 0H
*MEXIT #=   539 LV= 3 RT1
         B     EXIT23
         LTORG 
EXIT23      DS 0H
*MEXIT #=   518 LV= 2 TEST1
*MEXIT #=   517 LV= 1 TEST
*MCALL #=   540 LV= 1          TEST   DD,=DD'2'
*MCALL #=   541 LV= 2          TEST1 SVC,DD,=DD'2'
         BASR  R12,0
         USING *,R12
*MCALL #=   542 LV= 3          CTD   CTD_DD,IN==DD'2',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_DD,0,DECIMAL)
         LA    0,=DD'2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   542 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DD'
         MVC   DHEX,=CL32' '
         LA    R2,=DD'2'
         LA    R3,L'=DD'2'
*MCALL #=   543 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   544 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   544 LV= 4 ZCALL
*MEXIT #=   543 LV= 3 CALL
*MCALL #=   545 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   545 LV= 3 WTO
*MCALL #=   546 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   547 LV= 4          ZSTREQU 
*MEXIT #=   547 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_47_2
*MEXIT #=   546 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   548 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   548 LV= 3 WTO
*MCALL #=   549 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   549 LV= 3 ABEND
*MCALL #=   550 LV= 3          ENDIF 
*MCALL #=   551 LV= 4          ZSTREQU 
*MEXIT #=   551 LV= 4 ZSTREQU
#@IF_47_2                                                DS 0H
*MEXIT #=   550 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   552 LV= 3          CFD   CFD_DD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   552 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DD'2'
*MCALL #=   553 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   554 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   554 LV= 4 ZCALL
*MEXIT #=   553 LV= 3 CALL
*MCALL #=   555 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   555 LV= 3 WTO
*MCALL #=   556 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   557 LV= 4          ZSTREQU 
*MEXIT #=   557 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_48_2
*MEXIT #=   556 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   558 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   558 LV= 3 WTO
*MCALL #=   559 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   559 LV= 3 ABEND
*MCALL #=   560 LV= 3          ENDIF 
*MCALL #=   561 LV= 4          ZSTREQU 
*MEXIT #=   561 LV= 4 ZSTREQU
#@IF_48_2                                                DS 0H
*MEXIT #=   560 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LD    R0,=DD'2'
         LD    R1,WORK16
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=   562 LV= 3          RT1   CCE
         DS    0H
RT1_TEST33       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE33
         LTORG 
RT1_CCE33       DS 0H
*MEXIT #=   562 LV= 3 RT1
         B     EXIT24
         LTORG 
EXIT24      DS 0H
*MEXIT #=   541 LV= 2 TEST1
*MEXIT #=   540 LV= 1 TEST
*MCALL #=   563 LV= 1          TEST   DD,=DD'1E2'
*MCALL #=   564 LV= 2          TEST1 SVC,DD,=DD'1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=   565 LV= 3          CTD   CTD_DD,IN==DD'1E2',OUT=DECIMAL,LINX
               KAGE=SVC
         LA    1,=A(CTD_DD,0,DECIMAL)
         LA    0,=DD'1E2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   565 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DD'
         MVC   DHEX,=CL32' '
         LA    R2,=DD'1E2'
         LA    R3,L'=DD'1E2'
*MCALL #=   566 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   567 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   567 LV= 4 ZCALL
*MEXIT #=   566 LV= 3 CALL
*MCALL #=   568 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   568 LV= 3 WTO
*MCALL #=   569 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   570 LV= 4          ZSTREQU 
*MEXIT #=   570 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_49_2
*MEXIT #=   569 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   571 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   571 LV= 3 WTO
*MCALL #=   572 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   572 LV= 3 ABEND
*MCALL #=   573 LV= 3          ENDIF 
*MCALL #=   574 LV= 4          ZSTREQU 
*MEXIT #=   574 LV= 4 ZSTREQU
#@IF_49_2                                                DS 0H
*MEXIT #=   573 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   575 LV= 3          CFD   CFD_DD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   575 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DD'1E2'
*MCALL #=   576 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   577 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   577 LV= 4 ZCALL
*MEXIT #=   576 LV= 3 CALL
*MCALL #=   578 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   578 LV= 3 WTO
*MCALL #=   579 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   580 LV= 4          ZSTREQU 
*MEXIT #=   580 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_50_2
*MEXIT #=   579 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   581 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   581 LV= 3 WTO
*MCALL #=   582 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   582 LV= 3 ABEND
*MCALL #=   583 LV= 3          ENDIF 
*MCALL #=   584 LV= 4          ZSTREQU 
*MEXIT #=   584 LV= 4 ZSTREQU
#@IF_50_2                                                DS 0H
*MEXIT #=   583 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LD    R0,=DD'1E2'
         LD    R1,WORK16
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=   585 LV= 3          RT1   CCE
         DS    0H
RT1_TEST34       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE34
         LTORG 
RT1_CCE34       DS 0H
*MEXIT #=   585 LV= 3 RT1
         B     EXIT25
         LTORG 
EXIT25      DS 0H
*MEXIT #=   564 LV= 2 TEST1
*MEXIT #=   563 LV= 1 TEST
*MCALL #=   586 LV= 1          TEST   DD,=DD'123456789012345'
*MCALL #=   587 LV= 2          TEST1 SVC,DD,=DD'123456789012345'
         BASR  R12,0
         USING *,R12
*MCALL #=   588 LV= 3          CTD   CTD_DD,IN==DD'123456789012345',OUTX
               =DECIMAL,LINKAGE=SVC
         LA    1,=A(CTD_DD,0,DECIMAL)
         LA    0,=DD'123456789012345'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   588 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DD'
         MVC   DHEX,=CL32' '
         LA    R2,=DD'123456789012345'
         LA    R3,L'=DD'123456789012345'
*MCALL #=   589 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   590 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   590 LV= 4 ZCALL
*MEXIT #=   589 LV= 3 CALL
*MCALL #=   591 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   591 LV= 3 WTO
*MCALL #=   592 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   593 LV= 4          ZSTREQU 
*MEXIT #=   593 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_51_2
*MEXIT #=   592 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   594 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   594 LV= 3 WTO
*MCALL #=   595 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   595 LV= 3 ABEND
*MCALL #=   596 LV= 3          ENDIF 
*MCALL #=   597 LV= 4          ZSTREQU 
*MEXIT #=   597 LV= 4 ZSTREQU
#@IF_51_2                                                DS 0H
*MEXIT #=   596 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   598 LV= 3          CFD   CFD_DD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   598 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DD'123456789012345'
*MCALL #=   599 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   600 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   600 LV= 4 ZCALL
*MEXIT #=   599 LV= 3 CALL
*MCALL #=   601 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   601 LV= 3 WTO
*MCALL #=   602 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   603 LV= 4          ZSTREQU 
*MEXIT #=   603 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_52_2
*MEXIT #=   602 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   604 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   604 LV= 3 WTO
*MCALL #=   605 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   605 LV= 3 ABEND
*MCALL #=   606 LV= 3          ENDIF 
*MCALL #=   607 LV= 4          ZSTREQU 
*MEXIT #=   607 LV= 4 ZSTREQU
#@IF_52_2                                                DS 0H
*MEXIT #=   606 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LD    R0,=DD'123456789012345'
         LD    R1,WORK16
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=   608 LV= 3          RT1   CCE
         DS    0H
RT1_TEST35       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE35
         LTORG 
RT1_CCE35       DS 0H
*MEXIT #=   608 LV= 3 RT1
         B     EXIT26
         LTORG 
EXIT26      DS 0H
*MEXIT #=   587 LV= 2 TEST1
*MEXIT #=   586 LV= 1 TEST
*MCALL #=   609 LV= 1          TEST   DD,=DD'1.23456789012345E14'
*MCALL #=   610 LV= 2          TEST1 SVC,DD,=DD'1.23456789012345E14'
         BASR  R12,0
         USING *,R12
*MCALL #=   611 LV= 3          CTD   CTD_DD,IN==DD'1.23456789012345E14'X
               ,OUT=DECIMAL,LINKAGE=SVC
         LA    1,=A(CTD_DD,0,DECIMAL)
         LA    0,=DD'1.23456789012345E14'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   611 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DD'
         MVC   DHEX,=CL32' '
         LA    R2,=DD'1.23456789012345E14'
         LA    R3,L'=DD'1.23456789012345E14'
*MCALL #=   612 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   613 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   613 LV= 4 ZCALL
*MEXIT #=   612 LV= 3 CALL
*MCALL #=   614 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   614 LV= 3 WTO
*MCALL #=   615 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   616 LV= 4          ZSTREQU 
*MEXIT #=   616 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_53_2
*MEXIT #=   615 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   617 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   617 LV= 3 WTO
*MCALL #=   618 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   618 LV= 3 ABEND
*MCALL #=   619 LV= 3          ENDIF 
*MCALL #=   620 LV= 4          ZSTREQU 
*MEXIT #=   620 LV= 4 ZSTREQU
#@IF_53_2                                                DS 0H
*MEXIT #=   619 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   621 LV= 3          CFD   CFD_DD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   621 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DD'1.23456789012345E14'
*MCALL #=   622 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   623 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   623 LV= 4 ZCALL
*MEXIT #=   622 LV= 3 CALL
*MCALL #=   624 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   624 LV= 3 WTO
*MCALL #=   625 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   626 LV= 4          ZSTREQU 
*MEXIT #=   626 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_54_2
*MEXIT #=   625 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   627 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   627 LV= 3 WTO
*MCALL #=   628 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   628 LV= 3 ABEND
*MCALL #=   629 LV= 3          ENDIF 
*MCALL #=   630 LV= 4          ZSTREQU 
*MEXIT #=   630 LV= 4 ZSTREQU
#@IF_54_2                                                DS 0H
*MEXIT #=   629 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LD    R0,=DD'1.23456789012345E14'
         LD    R1,WORK16
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=   631 LV= 3          RT1   CCE
         DS    0H
RT1_TEST36       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE36
         LTORG 
RT1_CCE36       DS 0H
*MEXIT #=   631 LV= 3 RT1
         B     EXIT27
         LTORG 
EXIT27      DS 0H
*MEXIT #=   610 LV= 2 TEST1
*MEXIT #=   609 LV= 1 TEST
*MCALL #=   632 LV= 1          TEST   DD,=DD'1234567890123456'
*MCALL #=   633 LV= 2          TEST1 SVC,DD,=DD'1234567890123456'
         BASR  R12,0
         USING *,R12
*MCALL #=   634 LV= 3          CTD   CTD_DD,IN==DD'1234567890123456',OUX
               T=DECIMAL,LINKAGE=SVC
         LA    1,=A(CTD_DD,0,DECIMAL)
         LA    0,=DD'1234567890123456'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   634 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DD'
         MVC   DHEX,=CL32' '
         LA    R2,=DD'1234567890123456'
         LA    R3,L'=DD'1234567890123456'
*MCALL #=   635 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   636 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   636 LV= 4 ZCALL
*MEXIT #=   635 LV= 3 CALL
*MCALL #=   637 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   637 LV= 3 WTO
*MCALL #=   638 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   639 LV= 4          ZSTREQU 
*MEXIT #=   639 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_55_2
*MEXIT #=   638 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   640 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   640 LV= 3 WTO
*MCALL #=   641 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   641 LV= 3 ABEND
*MCALL #=   642 LV= 3          ENDIF 
*MCALL #=   643 LV= 4          ZSTREQU 
*MEXIT #=   643 LV= 4 ZSTREQU
#@IF_55_2                                                DS 0H
*MEXIT #=   642 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   644 LV= 3          CFD   CFD_DD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   644 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DD'1234567890123456'
*MCALL #=   645 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   646 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   646 LV= 4 ZCALL
*MEXIT #=   645 LV= 3 CALL
*MCALL #=   647 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   647 LV= 3 WTO
*MCALL #=   648 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   649 LV= 4          ZSTREQU 
*MEXIT #=   649 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_56_2
*MEXIT #=   648 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   650 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   650 LV= 3 WTO
*MCALL #=   651 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   651 LV= 3 ABEND
*MCALL #=   652 LV= 3          ENDIF 
*MCALL #=   653 LV= 4          ZSTREQU 
*MEXIT #=   653 LV= 4 ZSTREQU
#@IF_56_2                                                DS 0H
*MEXIT #=   652 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LD    R0,=DD'1234567890123456'
         LD    R1,WORK16
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=   654 LV= 3          RT1   CCE
         DS    0H
RT1_TEST37       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE37
         LTORG 
RT1_CCE37       DS 0H
*MEXIT #=   654 LV= 3 RT1
         B     EXIT28
         LTORG 
EXIT28      DS 0H
*MEXIT #=   633 LV= 2 TEST1
*MEXIT #=   632 LV= 1 TEST
*MCALL #=   655 LV= 1          TEST   DD,=DD'1234567890123456E300'
*MCALL #=   656 LV= 2          TEST1 SVC,DD,=DD'1234567890123456E300'
         BASR  R12,0
         USING *,R12
*MCALL #=   657 LV= 3          CTD   CTD_DD,IN==DD'1234567890123456E300X
               ',OUT=DECIMAL,LINKAGE=SVC
         LA    1,=A(CTD_DD,0,DECIMAL)
         LA    0,=DD'1234567890123456E300'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   657 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DD'
         MVC   DHEX,=CL32' '
         LA    R2,=DD'1234567890123456E300'
         LA    R3,L'=DD'1234567890123456E300'
*MCALL #=   658 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   659 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   659 LV= 4 ZCALL
*MEXIT #=   658 LV= 3 CALL
*MCALL #=   660 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   660 LV= 3 WTO
*MCALL #=   661 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   662 LV= 4          ZSTREQU 
*MEXIT #=   662 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_57_2
*MEXIT #=   661 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   663 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   663 LV= 3 WTO
*MCALL #=   664 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   664 LV= 3 ABEND
*MCALL #=   665 LV= 3          ENDIF 
*MCALL #=   666 LV= 4          ZSTREQU 
*MEXIT #=   666 LV= 4 ZSTREQU
#@IF_57_2                                                DS 0H
*MEXIT #=   665 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   667 LV= 3          CFD   CFD_DD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   667 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DD'1234567890123456E300'
*MCALL #=   668 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   669 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   669 LV= 4 ZCALL
*MEXIT #=   668 LV= 3 CALL
*MCALL #=   670 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   670 LV= 3 WTO
*MCALL #=   671 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   672 LV= 4          ZSTREQU 
*MEXIT #=   672 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_58_2
*MEXIT #=   671 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   673 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   673 LV= 3 WTO
*MCALL #=   674 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   674 LV= 3 ABEND
*MCALL #=   675 LV= 3          ENDIF 
*MCALL #=   676 LV= 4          ZSTREQU 
*MEXIT #=   676 LV= 4 ZSTREQU
#@IF_58_2                                                DS 0H
*MEXIT #=   675 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LD    R0,=DD'1234567890123456E300'
         LD    R1,WORK16
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=   677 LV= 3          RT1   CCE
         DS    0H
RT1_TEST38       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE38
         LTORG 
RT1_CCE38       DS 0H
*MEXIT #=   677 LV= 3 RT1
         B     EXIT29
         LTORG 
EXIT29      DS 0H
*MEXIT #=   656 LV= 2 TEST1
*MEXIT #=   655 LV= 1 TEST
*MCALL #=   678 LV= 1          TEST   DD,=DD'9999999999999999E369'
*MCALL #=   679 LV= 2          TEST1 SVC,DD,=DD'9999999999999999E369'
         BASR  R12,0
         USING *,R12
*MCALL #=   680 LV= 3          CTD   CTD_DD,IN==DD'9999999999999999E369X
               ',OUT=DECIMAL,LINKAGE=SVC
         LA    1,=A(CTD_DD,0,DECIMAL)
         LA    0,=DD'9999999999999999E369'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   680 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DD'
         MVC   DHEX,=CL32' '
         LA    R2,=DD'9999999999999999E369'
         LA    R3,L'=DD'9999999999999999E369'
*MCALL #=   681 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   682 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   682 LV= 4 ZCALL
*MEXIT #=   681 LV= 3 CALL
*MCALL #=   683 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   683 LV= 3 WTO
*MCALL #=   684 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   685 LV= 4          ZSTREQU 
*MEXIT #=   685 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_59_2
*MEXIT #=   684 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   686 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   686 LV= 3 WTO
*MCALL #=   687 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   687 LV= 3 ABEND
*MCALL #=   688 LV= 3          ENDIF 
*MCALL #=   689 LV= 4          ZSTREQU 
*MEXIT #=   689 LV= 4 ZSTREQU
#@IF_59_2                                                DS 0H
*MEXIT #=   688 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   690 LV= 3          CFD   CFD_DD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   690 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DD'9999999999999999E369'
*MCALL #=   691 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   692 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   692 LV= 4 ZCALL
*MEXIT #=   691 LV= 3 CALL
*MCALL #=   693 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   693 LV= 3 WTO
*MCALL #=   694 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   695 LV= 4          ZSTREQU 
*MEXIT #=   695 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_60_2
*MEXIT #=   694 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   696 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   696 LV= 3 WTO
*MCALL #=   697 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   697 LV= 3 ABEND
*MCALL #=   698 LV= 3          ENDIF 
*MCALL #=   699 LV= 4          ZSTREQU 
*MEXIT #=   699 LV= 4 ZSTREQU
#@IF_60_2                                                DS 0H
*MEXIT #=   698 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LD    R0,=DD'9999999999999999E369'
         LD    R1,WORK16
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=   700 LV= 3          RT1   CCE
         DS    0H
RT1_TEST39       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE39
         LTORG 
RT1_CCE39       DS 0H
*MEXIT #=   700 LV= 3 RT1
         B     EXIT30
         LTORG 
EXIT30      DS 0H
*MEXIT #=   679 LV= 2 TEST1
*MEXIT #=   678 LV= 1 TEST
*MCALL #=   701 LV= 1          TEST   DD,=DD'-1'
*MCALL #=   702 LV= 2          TEST1 SVC,DD,=DD'-1'
         BASR  R12,0
         USING *,R12
*MCALL #=   703 LV= 3          CTD   CTD_DD,IN==DD'-1',OUT=DECIMAL,LINKX
               AGE=SVC
         LA    1,=A(CTD_DD,0,DECIMAL)
         LA    0,=DD'-1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   703 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DD'
         MVC   DHEX,=CL32' '
         LA    R2,=DD'-1'
         LA    R3,L'=DD'-1'
*MCALL #=   704 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   705 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   705 LV= 4 ZCALL
*MEXIT #=   704 LV= 3 CALL
*MCALL #=   706 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   706 LV= 3 WTO
*MCALL #=   707 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   708 LV= 4          ZSTREQU 
*MEXIT #=   708 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_61_2
*MEXIT #=   707 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   709 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   709 LV= 3 WTO
*MCALL #=   710 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   710 LV= 3 ABEND
*MCALL #=   711 LV= 3          ENDIF 
*MCALL #=   712 LV= 4          ZSTREQU 
*MEXIT #=   712 LV= 4 ZSTREQU
#@IF_61_2                                                DS 0H
*MEXIT #=   711 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   713 LV= 3          CFD   CFD_DD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   713 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DD'-1'
*MCALL #=   714 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   715 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   715 LV= 4 ZCALL
*MEXIT #=   714 LV= 3 CALL
*MCALL #=   716 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   716 LV= 3 WTO
*MCALL #=   717 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   718 LV= 4          ZSTREQU 
*MEXIT #=   718 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_62_2
*MEXIT #=   717 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   719 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   719 LV= 3 WTO
*MCALL #=   720 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   720 LV= 3 ABEND
*MCALL #=   721 LV= 3          ENDIF 
*MCALL #=   722 LV= 4          ZSTREQU 
*MEXIT #=   722 LV= 4 ZSTREQU
#@IF_62_2                                                DS 0H
*MEXIT #=   721 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LD    R0,=DD'-1'
         LD    R1,WORK16
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=   723 LV= 3          RT1   CCE
         DS    0H
RT1_TEST40       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE40
         LTORG 
RT1_CCE40       DS 0H
*MEXIT #=   723 LV= 3 RT1
         B     EXIT31
         LTORG 
EXIT31      DS 0H
*MEXIT #=   702 LV= 2 TEST1
*MEXIT #=   701 LV= 1 TEST
*MCALL #=   724 LV= 1          TEST   DD,=DD'-2'
*MCALL #=   725 LV= 2          TEST1 SVC,DD,=DD'-2'
         BASR  R12,0
         USING *,R12
*MCALL #=   726 LV= 3          CTD   CTD_DD,IN==DD'-2',OUT=DECIMAL,LINKX
               AGE=SVC
         LA    1,=A(CTD_DD,0,DECIMAL)
         LA    0,=DD'-2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   726 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DD'
         MVC   DHEX,=CL32' '
         LA    R2,=DD'-2'
         LA    R3,L'=DD'-2'
*MCALL #=   727 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   728 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   728 LV= 4 ZCALL
*MEXIT #=   727 LV= 3 CALL
*MCALL #=   729 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   729 LV= 3 WTO
*MCALL #=   730 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   731 LV= 4          ZSTREQU 
*MEXIT #=   731 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_63_2
*MEXIT #=   730 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   732 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   732 LV= 3 WTO
*MCALL #=   733 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   733 LV= 3 ABEND
*MCALL #=   734 LV= 3          ENDIF 
*MCALL #=   735 LV= 4          ZSTREQU 
*MEXIT #=   735 LV= 4 ZSTREQU
#@IF_63_2                                                DS 0H
*MEXIT #=   734 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   736 LV= 3          CFD   CFD_DD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   736 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DD'-2'
*MCALL #=   737 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   738 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   738 LV= 4 ZCALL
*MEXIT #=   737 LV= 3 CALL
*MCALL #=   739 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   739 LV= 3 WTO
*MCALL #=   740 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   741 LV= 4          ZSTREQU 
*MEXIT #=   741 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_64_2
*MEXIT #=   740 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   742 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   742 LV= 3 WTO
*MCALL #=   743 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   743 LV= 3 ABEND
*MCALL #=   744 LV= 3          ENDIF 
*MCALL #=   745 LV= 4          ZSTREQU 
*MEXIT #=   745 LV= 4 ZSTREQU
#@IF_64_2                                                DS 0H
*MEXIT #=   744 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LD    R0,=DD'-2'
         LD    R1,WORK16
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=   746 LV= 3          RT1   CCE
         DS    0H
RT1_TEST41       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE41
         LTORG 
RT1_CCE41       DS 0H
*MEXIT #=   746 LV= 3 RT1
         B     EXIT32
         LTORG 
EXIT32      DS 0H
*MEXIT #=   725 LV= 2 TEST1
*MEXIT #=   724 LV= 1 TEST
*MCALL #=   747 LV= 1          TEST   DD,=DD'-1E2'
*MCALL #=   748 LV= 2          TEST1 SVC,DD,=DD'-1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=   749 LV= 3          CTD   CTD_DD,IN==DD'-1E2',OUT=DECIMAL,LIX
               NKAGE=SVC
         LA    1,=A(CTD_DD,0,DECIMAL)
         LA    0,=DD'-1E2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   749 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DD'
         MVC   DHEX,=CL32' '
         LA    R2,=DD'-1E2'
         LA    R3,L'=DD'-1E2'
*MCALL #=   750 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   751 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   751 LV= 4 ZCALL
*MEXIT #=   750 LV= 3 CALL
*MCALL #=   752 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   752 LV= 3 WTO
*MCALL #=   753 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   754 LV= 4          ZSTREQU 
*MEXIT #=   754 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_65_2
*MEXIT #=   753 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   755 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   755 LV= 3 WTO
*MCALL #=   756 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   756 LV= 3 ABEND
*MCALL #=   757 LV= 3          ENDIF 
*MCALL #=   758 LV= 4          ZSTREQU 
*MEXIT #=   758 LV= 4 ZSTREQU
#@IF_65_2                                                DS 0H
*MEXIT #=   757 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   759 LV= 3          CFD   CFD_DD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   759 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DD'-1E2'
*MCALL #=   760 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   761 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   761 LV= 4 ZCALL
*MEXIT #=   760 LV= 3 CALL
*MCALL #=   762 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   762 LV= 3 WTO
*MCALL #=   763 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   764 LV= 4          ZSTREQU 
*MEXIT #=   764 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_66_2
*MEXIT #=   763 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   765 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   765 LV= 3 WTO
*MCALL #=   766 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   766 LV= 3 ABEND
*MCALL #=   767 LV= 3          ENDIF 
*MCALL #=   768 LV= 4          ZSTREQU 
*MEXIT #=   768 LV= 4 ZSTREQU
#@IF_66_2                                                DS 0H
*MEXIT #=   767 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LD    R0,=DD'-1E2'
         LD    R1,WORK16
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=   769 LV= 3          RT1   CCE
         DS    0H
RT1_TEST42       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE42
         LTORG 
RT1_CCE42       DS 0H
*MEXIT #=   769 LV= 3 RT1
         B     EXIT33
         LTORG 
EXIT33      DS 0H
*MEXIT #=   748 LV= 2 TEST1
*MEXIT #=   747 LV= 1 TEST
* DH
*MCALL #=   770 LV= 1          TEST   DH,=DH'0'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=   771 LV= 2          TEST1 MF,DH,=DH'0'
         BASR  R12,0
         USING *,R12
*MCALL #=   772 LV= 3          CTD   CTD_DH,IN==DH'0',OUT=DECIMAL,LINKAX
               GE=MF
         LA    1,=A(CTD_DH,0,DECIMAL)
         LA    0,=DH'0'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   772 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D DH'
         MVC   DHEX,=CL32' '
         LA    R2,=DH'0'
         LA    R3,L'=DH'0'
*MCALL #=   773 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   774 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   774 LV= 4 ZCALL
*MEXIT #=   773 LV= 3 CALL
*MCALL #=   775 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   775 LV= 3 WTO
*MCALL #=   776 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   777 LV= 4          ZSTREQU 
*MEXIT #=   777 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_67_2
*MEXIT #=   776 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   778 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   778 LV= 3 WTO
*MCALL #=   779 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   779 LV= 3 ABEND
*MCALL #=   780 LV= 3          ENDIF 
*MCALL #=   781 LV= 4          ZSTREQU 
*MEXIT #=   781 LV= 4 ZSTREQU
#@IF_67_2                                                DS 0H
*MEXIT #=   780 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   782 LV= 3          CFD   CFD_DH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_DH,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   782 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D DH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DH'0'
*MCALL #=   783 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   784 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   784 LV= 4 ZCALL
*MEXIT #=   783 LV= 3 CALL
*MCALL #=   785 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   785 LV= 3 WTO
*MCALL #=   786 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   787 LV= 4          ZSTREQU 
*MEXIT #=   787 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_68_2
*MEXIT #=   786 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   788 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   788 LV= 3 WTO
*MCALL #=   789 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   789 LV= 3 ABEND
*MCALL #=   790 LV= 3          ENDIF 
*MCALL #=   791 LV= 4          ZSTREQU 
*MEXIT #=   791 LV= 4 ZSTREQU
#@IF_68_2                                                DS 0H
*MEXIT #=   790 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DH'0'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DH'0'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=   792 LV= 3          RT1   CCE
         DS    0H
RT1_TEST43       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE43
         LTORG 
RT1_CCE43       DS 0H
*MEXIT #=   792 LV= 3 RT1
         B     EXIT34
         LTORG 
EXIT34      DS 0H
*MEXIT #=   771 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=   793 LV= 2          TEST1 SVC,DH,=DH'0'
         BASR  R12,0
         USING *,R12
*MCALL #=   794 LV= 3          CTD   CTD_DH,IN==DH'0',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_DH,0,DECIMAL)
         LA    0,=DH'0'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   794 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DH'
         MVC   DHEX,=CL32' '
         LA    R2,=DH'0'
         LA    R3,L'=DH'0'
*MCALL #=   795 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   796 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   796 LV= 4 ZCALL
*MEXIT #=   795 LV= 3 CALL
*MCALL #=   797 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   797 LV= 3 WTO
*MCALL #=   798 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   799 LV= 4          ZSTREQU 
*MEXIT #=   799 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_69_2
*MEXIT #=   798 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   800 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   800 LV= 3 WTO
*MCALL #=   801 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   801 LV= 3 ABEND
*MCALL #=   802 LV= 3          ENDIF 
*MCALL #=   803 LV= 4          ZSTREQU 
*MEXIT #=   803 LV= 4 ZSTREQU
#@IF_69_2                                                DS 0H
*MEXIT #=   802 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   804 LV= 3          CFD   CFD_DH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   804 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DH'0'
*MCALL #=   805 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   806 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   806 LV= 4 ZCALL
*MEXIT #=   805 LV= 3 CALL
*MCALL #=   807 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   807 LV= 3 WTO
*MCALL #=   808 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   809 LV= 4          ZSTREQU 
*MEXIT #=   809 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_70_2
*MEXIT #=   808 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   810 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   810 LV= 3 WTO
*MCALL #=   811 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   811 LV= 3 ABEND
*MCALL #=   812 LV= 3          ENDIF 
*MCALL #=   813 LV= 4          ZSTREQU 
*MEXIT #=   813 LV= 4 ZSTREQU
#@IF_70_2                                                DS 0H
*MEXIT #=   812 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DH'0'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DH'0'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=   814 LV= 3          RT1   CCE
         DS    0H
RT1_TEST44       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE44
         LTORG 
RT1_CCE44       DS 0H
*MEXIT #=   814 LV= 3 RT1
         B     EXIT35
         LTORG 
EXIT35      DS 0H
*MEXIT #=   793 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=   815 LV= 2          RT1   CCE
         DS    0H
RT1_TEST45       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE45
         LTORG 
RT1_CCE45       DS 0H
*MEXIT #=   815 LV= 2 RT1
*MEXIT #=   770 LV= 1 TEST
*MCALL #=   816 LV= 1          TEST   DH,=DH'1E-78'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=   817 LV= 2          TEST1 MF,DH,=DH'1E-78'
         BASR  R12,0
         USING *,R12
*MCALL #=   818 LV= 3          CTD   CTD_DH,IN==DH'1E-78',OUT=DECIMAL,LX
               INKAGE=MF
         LA    1,=A(CTD_DH,0,DECIMAL)
         LA    0,=DH'1E-78'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   818 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D DH'
         MVC   DHEX,=CL32' '
         LA    R2,=DH'1E-78'
         LA    R3,L'=DH'1E-78'
*MCALL #=   819 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   820 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   820 LV= 4 ZCALL
*MEXIT #=   819 LV= 3 CALL
*MCALL #=   821 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   821 LV= 3 WTO
*MCALL #=   822 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   823 LV= 4          ZSTREQU 
*MEXIT #=   823 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_71_2
*MEXIT #=   822 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   824 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   824 LV= 3 WTO
*MCALL #=   825 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   825 LV= 3 ABEND
*MCALL #=   826 LV= 3          ENDIF 
*MCALL #=   827 LV= 4          ZSTREQU 
*MEXIT #=   827 LV= 4 ZSTREQU
#@IF_71_2                                                DS 0H
*MEXIT #=   826 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   828 LV= 3          CFD   CFD_DH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_DH,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   828 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D DH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DH'1E-78'
*MCALL #=   829 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   830 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   830 LV= 4 ZCALL
*MEXIT #=   829 LV= 3 CALL
*MCALL #=   831 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   831 LV= 3 WTO
*MCALL #=   832 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   833 LV= 4          ZSTREQU 
*MEXIT #=   833 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_72_2
*MEXIT #=   832 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   834 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   834 LV= 3 WTO
*MCALL #=   835 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   835 LV= 3 ABEND
*MCALL #=   836 LV= 3          ENDIF 
*MCALL #=   837 LV= 4          ZSTREQU 
*MEXIT #=   837 LV= 4 ZSTREQU
#@IF_72_2                                                DS 0H
*MEXIT #=   836 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DH'1E-78'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DH'1E-78'  VERIFY CTD CONSTANT WITH CFD RESULX
               T
* RPI 786 START TEST FOR DFP
*MCALL #=   838 LV= 3          RT1   CCE
         DS    0H
RT1_TEST46       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE46
         LTORG 
RT1_CCE46       DS 0H
*MEXIT #=   838 LV= 3 RT1
         B     EXIT36
         LTORG 
EXIT36      DS 0H
*MEXIT #=   817 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=   839 LV= 2          TEST1 SVC,DH,=DH'1E-78'
         BASR  R12,0
         USING *,R12
*MCALL #=   840 LV= 3          CTD   CTD_DH,IN==DH'1E-78',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_DH,0,DECIMAL)
         LA    0,=DH'1E-78'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   840 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DH'
         MVC   DHEX,=CL32' '
         LA    R2,=DH'1E-78'
         LA    R3,L'=DH'1E-78'
*MCALL #=   841 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   842 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   842 LV= 4 ZCALL
*MEXIT #=   841 LV= 3 CALL
*MCALL #=   843 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   843 LV= 3 WTO
*MCALL #=   844 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   845 LV= 4          ZSTREQU 
*MEXIT #=   845 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_73_2
*MEXIT #=   844 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   846 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   846 LV= 3 WTO
*MCALL #=   847 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   847 LV= 3 ABEND
*MCALL #=   848 LV= 3          ENDIF 
*MCALL #=   849 LV= 4          ZSTREQU 
*MEXIT #=   849 LV= 4 ZSTREQU
#@IF_73_2                                                DS 0H
*MEXIT #=   848 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   850 LV= 3          CFD   CFD_DH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   850 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DH'1E-78'
*MCALL #=   851 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   852 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   852 LV= 4 ZCALL
*MEXIT #=   851 LV= 3 CALL
*MCALL #=   853 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   853 LV= 3 WTO
*MCALL #=   854 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   855 LV= 4          ZSTREQU 
*MEXIT #=   855 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_74_2
*MEXIT #=   854 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   856 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   856 LV= 3 WTO
*MCALL #=   857 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   857 LV= 3 ABEND
*MCALL #=   858 LV= 3          ENDIF 
*MCALL #=   859 LV= 4          ZSTREQU 
*MEXIT #=   859 LV= 4 ZSTREQU
#@IF_74_2                                                DS 0H
*MEXIT #=   858 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DH'1E-78'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DH'1E-78'  VERIFY CTD CONSTANT WITH CFD RESULX
               T
* RPI 786 START TEST FOR DFP
*MCALL #=   860 LV= 3          RT1   CCE
         DS    0H
RT1_TEST47       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE47
         LTORG 
RT1_CCE47       DS 0H
*MEXIT #=   860 LV= 3 RT1
         B     EXIT37
         LTORG 
EXIT37      DS 0H
*MEXIT #=   839 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=   861 LV= 2          RT1   CCE
         DS    0H
RT1_TEST48       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE48
         LTORG 
RT1_CCE48       DS 0H
*MEXIT #=   861 LV= 2 RT1
*MEXIT #=   816 LV= 1 TEST
*MCALL #=   862 LV= 1          TEST   DH,=DH'1'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=   863 LV= 2          TEST1 MF,DH,=DH'1'
         BASR  R12,0
         USING *,R12
*MCALL #=   864 LV= 3          CTD   CTD_DH,IN==DH'1',OUT=DECIMAL,LINKAX
               GE=MF
         LA    1,=A(CTD_DH,0,DECIMAL)
         LA    0,=DH'1'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   864 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D DH'
         MVC   DHEX,=CL32' '
         LA    R2,=DH'1'
         LA    R3,L'=DH'1'
*MCALL #=   865 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   866 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   866 LV= 4 ZCALL
*MEXIT #=   865 LV= 3 CALL
*MCALL #=   867 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   867 LV= 3 WTO
*MCALL #=   868 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   869 LV= 4          ZSTREQU 
*MEXIT #=   869 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_75_2
*MEXIT #=   868 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   870 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   870 LV= 3 WTO
*MCALL #=   871 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   871 LV= 3 ABEND
*MCALL #=   872 LV= 3          ENDIF 
*MCALL #=   873 LV= 4          ZSTREQU 
*MEXIT #=   873 LV= 4 ZSTREQU
#@IF_75_2                                                DS 0H
*MEXIT #=   872 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   874 LV= 3          CFD   CFD_DH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_DH,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   874 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D DH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DH'1'
*MCALL #=   875 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   876 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   876 LV= 4 ZCALL
*MEXIT #=   875 LV= 3 CALL
*MCALL #=   877 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   877 LV= 3 WTO
*MCALL #=   878 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   879 LV= 4          ZSTREQU 
*MEXIT #=   879 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_76_2
*MEXIT #=   878 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   880 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   880 LV= 3 WTO
*MCALL #=   881 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   881 LV= 3 ABEND
*MCALL #=   882 LV= 3          ENDIF 
*MCALL #=   883 LV= 4          ZSTREQU 
*MEXIT #=   883 LV= 4 ZSTREQU
#@IF_76_2                                                DS 0H
*MEXIT #=   882 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DH'1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DH'1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=   884 LV= 3          RT1   CCE
         DS    0H
RT1_TEST49       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE49
         LTORG 
RT1_CCE49       DS 0H
*MEXIT #=   884 LV= 3 RT1
         B     EXIT38
         LTORG 
EXIT38      DS 0H
*MEXIT #=   863 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=   885 LV= 2          TEST1 SVC,DH,=DH'1'
         BASR  R12,0
         USING *,R12
*MCALL #=   886 LV= 3          CTD   CTD_DH,IN==DH'1',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_DH,0,DECIMAL)
         LA    0,=DH'1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   886 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DH'
         MVC   DHEX,=CL32' '
         LA    R2,=DH'1'
         LA    R3,L'=DH'1'
*MCALL #=   887 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   888 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   888 LV= 4 ZCALL
*MEXIT #=   887 LV= 3 CALL
*MCALL #=   889 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   889 LV= 3 WTO
*MCALL #=   890 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   891 LV= 4          ZSTREQU 
*MEXIT #=   891 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_77_2
*MEXIT #=   890 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   892 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   892 LV= 3 WTO
*MCALL #=   893 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   893 LV= 3 ABEND
*MCALL #=   894 LV= 3          ENDIF 
*MCALL #=   895 LV= 4          ZSTREQU 
*MEXIT #=   895 LV= 4 ZSTREQU
#@IF_77_2                                                DS 0H
*MEXIT #=   894 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   896 LV= 3          CFD   CFD_DH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   896 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DH'1'
*MCALL #=   897 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   898 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   898 LV= 4 ZCALL
*MEXIT #=   897 LV= 3 CALL
*MCALL #=   899 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   899 LV= 3 WTO
*MCALL #=   900 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   901 LV= 4          ZSTREQU 
*MEXIT #=   901 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_78_2
*MEXIT #=   900 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   902 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   902 LV= 3 WTO
*MCALL #=   903 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   903 LV= 3 ABEND
*MCALL #=   904 LV= 3          ENDIF 
*MCALL #=   905 LV= 4          ZSTREQU 
*MEXIT #=   905 LV= 4 ZSTREQU
#@IF_78_2                                                DS 0H
*MEXIT #=   904 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DH'1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DH'1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=   906 LV= 3          RT1   CCE
         DS    0H
RT1_TEST50       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE50
         LTORG 
RT1_CCE50       DS 0H
*MEXIT #=   906 LV= 3 RT1
         B     EXIT39
         LTORG 
EXIT39      DS 0H
*MEXIT #=   885 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=   907 LV= 2          RT1   CCE
         DS    0H
RT1_TEST51       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE51
         LTORG 
RT1_CCE51       DS 0H
*MEXIT #=   907 LV= 2 RT1
*MEXIT #=   862 LV= 1 TEST
*MCALL #=   908 LV= 1          TEST   DH,=DH'2'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=   909 LV= 2          TEST1 MF,DH,=DH'2'
         BASR  R12,0
         USING *,R12
*MCALL #=   910 LV= 3          CTD   CTD_DH,IN==DH'2',OUT=DECIMAL,LINKAX
               GE=MF
         LA    1,=A(CTD_DH,0,DECIMAL)
         LA    0,=DH'2'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   910 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D DH'
         MVC   DHEX,=CL32' '
         LA    R2,=DH'2'
         LA    R3,L'=DH'2'
*MCALL #=   911 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   912 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   912 LV= 4 ZCALL
*MEXIT #=   911 LV= 3 CALL
*MCALL #=   913 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   913 LV= 3 WTO
*MCALL #=   914 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   915 LV= 4          ZSTREQU 
*MEXIT #=   915 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_79_2
*MEXIT #=   914 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   916 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   916 LV= 3 WTO
*MCALL #=   917 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   917 LV= 3 ABEND
*MCALL #=   918 LV= 3          ENDIF 
*MCALL #=   919 LV= 4          ZSTREQU 
*MEXIT #=   919 LV= 4 ZSTREQU
#@IF_79_2                                                DS 0H
*MEXIT #=   918 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   920 LV= 3          CFD   CFD_DH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_DH,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   920 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D DH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DH'2'
*MCALL #=   921 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   922 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   922 LV= 4 ZCALL
*MEXIT #=   921 LV= 3 CALL
*MCALL #=   923 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   923 LV= 3 WTO
*MCALL #=   924 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   925 LV= 4          ZSTREQU 
*MEXIT #=   925 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_80_2
*MEXIT #=   924 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   926 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   926 LV= 3 WTO
*MCALL #=   927 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   927 LV= 3 ABEND
*MCALL #=   928 LV= 3          ENDIF 
*MCALL #=   929 LV= 4          ZSTREQU 
*MEXIT #=   929 LV= 4 ZSTREQU
#@IF_80_2                                                DS 0H
*MEXIT #=   928 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DH'2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DH'2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=   930 LV= 3          RT1   CCE
         DS    0H
RT1_TEST52       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE52
         LTORG 
RT1_CCE52       DS 0H
*MEXIT #=   930 LV= 3 RT1
         B     EXIT40
         LTORG 
EXIT40      DS 0H
*MEXIT #=   909 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=   931 LV= 2          TEST1 SVC,DH,=DH'2'
         BASR  R12,0
         USING *,R12
*MCALL #=   932 LV= 3          CTD   CTD_DH,IN==DH'2',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_DH,0,DECIMAL)
         LA    0,=DH'2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   932 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DH'
         MVC   DHEX,=CL32' '
         LA    R2,=DH'2'
         LA    R3,L'=DH'2'
*MCALL #=   933 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   934 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   934 LV= 4 ZCALL
*MEXIT #=   933 LV= 3 CALL
*MCALL #=   935 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   935 LV= 3 WTO
*MCALL #=   936 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   937 LV= 4          ZSTREQU 
*MEXIT #=   937 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_81_2
*MEXIT #=   936 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   938 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   938 LV= 3 WTO
*MCALL #=   939 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   939 LV= 3 ABEND
*MCALL #=   940 LV= 3          ENDIF 
*MCALL #=   941 LV= 4          ZSTREQU 
*MEXIT #=   941 LV= 4 ZSTREQU
#@IF_81_2                                                DS 0H
*MEXIT #=   940 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   942 LV= 3          CFD   CFD_DH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   942 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DH'2'
*MCALL #=   943 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   944 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   944 LV= 4 ZCALL
*MEXIT #=   943 LV= 3 CALL
*MCALL #=   945 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   945 LV= 3 WTO
*MCALL #=   946 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   947 LV= 4          ZSTREQU 
*MEXIT #=   947 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_82_2
*MEXIT #=   946 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   948 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   948 LV= 3 WTO
*MCALL #=   949 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   949 LV= 3 ABEND
*MCALL #=   950 LV= 3          ENDIF 
*MCALL #=   951 LV= 4          ZSTREQU 
*MEXIT #=   951 LV= 4 ZSTREQU
#@IF_82_2                                                DS 0H
*MEXIT #=   950 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DH'2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DH'2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=   952 LV= 3          RT1   CCE
         DS    0H
RT1_TEST53       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE53
         LTORG 
RT1_CCE53       DS 0H
*MEXIT #=   952 LV= 3 RT1
         B     EXIT41
         LTORG 
EXIT41      DS 0H
*MEXIT #=   931 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=   953 LV= 2          RT1   CCE
         DS    0H
RT1_TEST54       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE54
         LTORG 
RT1_CCE54       DS 0H
*MEXIT #=   953 LV= 2 RT1
*MEXIT #=   908 LV= 1 TEST
*MCALL #=   954 LV= 1          TEST   DH,=DH'1E2'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=   955 LV= 2          TEST1 MF,DH,=DH'1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=   956 LV= 3          CTD   CTD_DH,IN==DH'1E2',OUT=DECIMAL,LINX
               KAGE=MF
         LA    1,=A(CTD_DH,0,DECIMAL)
         LA    0,=DH'1E2'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   956 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D DH'
         MVC   DHEX,=CL32' '
         LA    R2,=DH'1E2'
         LA    R3,L'=DH'1E2'
*MCALL #=   957 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   958 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   958 LV= 4 ZCALL
*MEXIT #=   957 LV= 3 CALL
*MCALL #=   959 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   959 LV= 3 WTO
*MCALL #=   960 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   961 LV= 4          ZSTREQU 
*MEXIT #=   961 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_83_2
*MEXIT #=   960 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   962 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   962 LV= 3 WTO
*MCALL #=   963 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   963 LV= 3 ABEND
*MCALL #=   964 LV= 3          ENDIF 
*MCALL #=   965 LV= 4          ZSTREQU 
*MEXIT #=   965 LV= 4 ZSTREQU
#@IF_83_2                                                DS 0H
*MEXIT #=   964 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   966 LV= 3          CFD   CFD_DH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_DH,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   966 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D DH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DH'1E2'
*MCALL #=   967 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   968 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   968 LV= 4 ZCALL
*MEXIT #=   967 LV= 3 CALL
*MCALL #=   969 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   969 LV= 3 WTO
*MCALL #=   970 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   971 LV= 4          ZSTREQU 
*MEXIT #=   971 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_84_2
*MEXIT #=   970 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   972 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   972 LV= 3 WTO
*MCALL #=   973 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   973 LV= 3 ABEND
*MCALL #=   974 LV= 3          ENDIF 
*MCALL #=   975 LV= 4          ZSTREQU 
*MEXIT #=   975 LV= 4 ZSTREQU
#@IF_84_2                                                DS 0H
*MEXIT #=   974 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DH'1E2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DH'1E2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=   976 LV= 3          RT1   CCE
         DS    0H
RT1_TEST55       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE55
         LTORG 
RT1_CCE55       DS 0H
*MEXIT #=   976 LV= 3 RT1
         B     EXIT42
         LTORG 
EXIT42      DS 0H
*MEXIT #=   955 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=   977 LV= 2          TEST1 SVC,DH,=DH'1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=   978 LV= 3          CTD   CTD_DH,IN==DH'1E2',OUT=DECIMAL,LINX
               KAGE=SVC
         LA    1,=A(CTD_DH,0,DECIMAL)
         LA    0,=DH'1E2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   978 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DH'
         MVC   DHEX,=CL32' '
         LA    R2,=DH'1E2'
         LA    R3,L'=DH'1E2'
*MCALL #=   979 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   980 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   980 LV= 4 ZCALL
*MEXIT #=   979 LV= 3 CALL
*MCALL #=   981 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   981 LV= 3 WTO
*MCALL #=   982 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   983 LV= 4          ZSTREQU 
*MEXIT #=   983 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_85_2
*MEXIT #=   982 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   984 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   984 LV= 3 WTO
*MCALL #=   985 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   985 LV= 3 ABEND
*MCALL #=   986 LV= 3          ENDIF 
*MCALL #=   987 LV= 4          ZSTREQU 
*MEXIT #=   987 LV= 4 ZSTREQU
#@IF_85_2                                                DS 0H
*MEXIT #=   986 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   988 LV= 3          CFD   CFD_DH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   988 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DH'1E2'
*MCALL #=   989 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   990 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   990 LV= 4 ZCALL
*MEXIT #=   989 LV= 3 CALL
*MCALL #=   991 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   991 LV= 3 WTO
*MCALL #=   992 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   993 LV= 4          ZSTREQU 
*MEXIT #=   993 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_86_2
*MEXIT #=   992 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   994 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   994 LV= 3 WTO
*MCALL #=   995 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   995 LV= 3 ABEND
*MCALL #=   996 LV= 3          ENDIF 
*MCALL #=   997 LV= 4          ZSTREQU 
*MEXIT #=   997 LV= 4 ZSTREQU
#@IF_86_2                                                DS 0H
*MEXIT #=   996 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DH'1E2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DH'1E2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=   998 LV= 3          RT1   CCE
         DS    0H
RT1_TEST56       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE56
         LTORG 
RT1_CCE56       DS 0H
*MEXIT #=   998 LV= 3 RT1
         B     EXIT43
         LTORG 
EXIT43      DS 0H
*MEXIT #=   977 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=   999 LV= 2          RT1   CCE
         DS    0H
RT1_TEST57       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE57
         LTORG 
RT1_CCE57       DS 0H
*MEXIT #=   999 LV= 2 RT1
*MEXIT #=   954 LV= 1 TEST
*MCALL #=  1000 LV= 1          TEST   DH,=DH'6E75' 1E75 CAUSES 1 BIT ROX
               UNDING ERROR
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  1001 LV= 2          TEST1 MF,DH,=DH'6E75'
         BASR  R12,0
         USING *,R12
*MCALL #=  1002 LV= 3          CTD   CTD_DH,IN==DH'6E75',OUT=DECIMAL,LIX
               NKAGE=MF
         LA    1,=A(CTD_DH,0,DECIMAL)
         LA    0,=DH'6E75'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1002 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D DH'
         MVC   DHEX,=CL32' '
         LA    R2,=DH'6E75'
         LA    R3,L'=DH'6E75'
*MCALL #=  1003 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1004 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1004 LV= 4 ZCALL
*MEXIT #=  1003 LV= 3 CALL
*MCALL #=  1005 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1005 LV= 3 WTO
*MCALL #=  1006 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1007 LV= 4          ZSTREQU 
*MEXIT #=  1007 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_87_2
*MEXIT #=  1006 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1008 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1008 LV= 3 WTO
*MCALL #=  1009 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1009 LV= 3 ABEND
*MCALL #=  1010 LV= 3          ENDIF 
*MCALL #=  1011 LV= 4          ZSTREQU 
*MEXIT #=  1011 LV= 4 ZSTREQU
#@IF_87_2                                                DS 0H
*MEXIT #=  1010 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1012 LV= 3          CFD   CFD_DH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_DH,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1012 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D DH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DH'6E75'
*MCALL #=  1013 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1014 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1014 LV= 4 ZCALL
*MEXIT #=  1013 LV= 3 CALL
*MCALL #=  1015 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1015 LV= 3 WTO
*MCALL #=  1016 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1017 LV= 4          ZSTREQU 
*MEXIT #=  1017 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_88_2
*MEXIT #=  1016 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1018 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1018 LV= 3 WTO
*MCALL #=  1019 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1019 LV= 3 ABEND
*MCALL #=  1020 LV= 3          ENDIF 
*MCALL #=  1021 LV= 4          ZSTREQU 
*MEXIT #=  1021 LV= 4 ZSTREQU
#@IF_88_2                                                DS 0H
*MEXIT #=  1020 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DH'6E75'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DH'6E75'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1022 LV= 3          RT1   CCE
         DS    0H
RT1_TEST58       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE58
         LTORG 
RT1_CCE58       DS 0H
*MEXIT #=  1022 LV= 3 RT1
         B     EXIT44
         LTORG 
EXIT44      DS 0H
*MEXIT #=  1001 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  1023 LV= 2          TEST1 SVC,DH,=DH'6E75'
         BASR  R12,0
         USING *,R12
*MCALL #=  1024 LV= 3          CTD   CTD_DH,IN==DH'6E75',OUT=DECIMAL,LIX
               NKAGE=SVC
         LA    1,=A(CTD_DH,0,DECIMAL)
         LA    0,=DH'6E75'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1024 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DH'
         MVC   DHEX,=CL32' '
         LA    R2,=DH'6E75'
         LA    R3,L'=DH'6E75'
*MCALL #=  1025 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1026 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1026 LV= 4 ZCALL
*MEXIT #=  1025 LV= 3 CALL
*MCALL #=  1027 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1027 LV= 3 WTO
*MCALL #=  1028 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1029 LV= 4          ZSTREQU 
*MEXIT #=  1029 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_89_2
*MEXIT #=  1028 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1030 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1030 LV= 3 WTO
*MCALL #=  1031 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1031 LV= 3 ABEND
*MCALL #=  1032 LV= 3          ENDIF 
*MCALL #=  1033 LV= 4          ZSTREQU 
*MEXIT #=  1033 LV= 4 ZSTREQU
#@IF_89_2                                                DS 0H
*MEXIT #=  1032 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1034 LV= 3          CFD   CFD_DH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1034 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DH'6E75'
*MCALL #=  1035 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1036 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1036 LV= 4 ZCALL
*MEXIT #=  1035 LV= 3 CALL
*MCALL #=  1037 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1037 LV= 3 WTO
*MCALL #=  1038 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1039 LV= 4          ZSTREQU 
*MEXIT #=  1039 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_90_2
*MEXIT #=  1038 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1040 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1040 LV= 3 WTO
*MCALL #=  1041 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1041 LV= 3 ABEND
*MCALL #=  1042 LV= 3          ENDIF 
*MCALL #=  1043 LV= 4          ZSTREQU 
*MEXIT #=  1043 LV= 4 ZSTREQU
#@IF_90_2                                                DS 0H
*MEXIT #=  1042 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DH'6E75'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DH'6E75'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1044 LV= 3          RT1   CCE
         DS    0H
RT1_TEST59       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE59
         LTORG 
RT1_CCE59       DS 0H
*MEXIT #=  1044 LV= 3 RT1
         B     EXIT45
         LTORG 
EXIT45      DS 0H
*MEXIT #=  1023 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  1045 LV= 2          RT1   CCE
         DS    0H
RT1_TEST60       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE60
         LTORG 
RT1_CCE60       DS 0H
*MEXIT #=  1045 LV= 2 RT1
*MEXIT #=  1000 LV= 1 TEST
*MCALL #=  1046 LV= 1          TEST   DH,=DH'-1'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  1047 LV= 2          TEST1 MF,DH,=DH'-1'
         BASR  R12,0
         USING *,R12
*MCALL #=  1048 LV= 3          CTD   CTD_DH,IN==DH'-1',OUT=DECIMAL,LINKX
               AGE=MF
         LA    1,=A(CTD_DH,0,DECIMAL)
         LA    0,=DH'-1'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1048 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D DH'
         MVC   DHEX,=CL32' '
         LA    R2,=DH'-1'
         LA    R3,L'=DH'-1'
*MCALL #=  1049 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1050 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1050 LV= 4 ZCALL
*MEXIT #=  1049 LV= 3 CALL
*MCALL #=  1051 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1051 LV= 3 WTO
*MCALL #=  1052 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1053 LV= 4          ZSTREQU 
*MEXIT #=  1053 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_91_2
*MEXIT #=  1052 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1054 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1054 LV= 3 WTO
*MCALL #=  1055 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1055 LV= 3 ABEND
*MCALL #=  1056 LV= 3          ENDIF 
*MCALL #=  1057 LV= 4          ZSTREQU 
*MEXIT #=  1057 LV= 4 ZSTREQU
#@IF_91_2                                                DS 0H
*MEXIT #=  1056 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1058 LV= 3          CFD   CFD_DH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_DH,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1058 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D DH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DH'-1'
*MCALL #=  1059 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1060 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1060 LV= 4 ZCALL
*MEXIT #=  1059 LV= 3 CALL
*MCALL #=  1061 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1061 LV= 3 WTO
*MCALL #=  1062 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1063 LV= 4          ZSTREQU 
*MEXIT #=  1063 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_92_2
*MEXIT #=  1062 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1064 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1064 LV= 3 WTO
*MCALL #=  1065 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1065 LV= 3 ABEND
*MCALL #=  1066 LV= 3          ENDIF 
*MCALL #=  1067 LV= 4          ZSTREQU 
*MEXIT #=  1067 LV= 4 ZSTREQU
#@IF_92_2                                                DS 0H
*MEXIT #=  1066 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DH'-1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DH'-1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1068 LV= 3          RT1   CCE
         DS    0H
RT1_TEST61       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE61
         LTORG 
RT1_CCE61       DS 0H
*MEXIT #=  1068 LV= 3 RT1
         B     EXIT46
         LTORG 
EXIT46      DS 0H
*MEXIT #=  1047 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  1069 LV= 2          TEST1 SVC,DH,=DH'-1'
         BASR  R12,0
         USING *,R12
*MCALL #=  1070 LV= 3          CTD   CTD_DH,IN==DH'-1',OUT=DECIMAL,LINKX
               AGE=SVC
         LA    1,=A(CTD_DH,0,DECIMAL)
         LA    0,=DH'-1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1070 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DH'
         MVC   DHEX,=CL32' '
         LA    R2,=DH'-1'
         LA    R3,L'=DH'-1'
*MCALL #=  1071 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1072 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1072 LV= 4 ZCALL
*MEXIT #=  1071 LV= 3 CALL
*MCALL #=  1073 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1073 LV= 3 WTO
*MCALL #=  1074 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1075 LV= 4          ZSTREQU 
*MEXIT #=  1075 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_93_2
*MEXIT #=  1074 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1076 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1076 LV= 3 WTO
*MCALL #=  1077 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1077 LV= 3 ABEND
*MCALL #=  1078 LV= 3          ENDIF 
*MCALL #=  1079 LV= 4          ZSTREQU 
*MEXIT #=  1079 LV= 4 ZSTREQU
#@IF_93_2                                                DS 0H
*MEXIT #=  1078 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1080 LV= 3          CFD   CFD_DH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1080 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DH'-1'
*MCALL #=  1081 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1082 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1082 LV= 4 ZCALL
*MEXIT #=  1081 LV= 3 CALL
*MCALL #=  1083 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1083 LV= 3 WTO
*MCALL #=  1084 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1085 LV= 4          ZSTREQU 
*MEXIT #=  1085 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_94_2
*MEXIT #=  1084 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1086 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1086 LV= 3 WTO
*MCALL #=  1087 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1087 LV= 3 ABEND
*MCALL #=  1088 LV= 3          ENDIF 
*MCALL #=  1089 LV= 4          ZSTREQU 
*MEXIT #=  1089 LV= 4 ZSTREQU
#@IF_94_2                                                DS 0H
*MEXIT #=  1088 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DH'-1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DH'-1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1090 LV= 3          RT1   CCE
         DS    0H
RT1_TEST62       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE62
         LTORG 
RT1_CCE62       DS 0H
*MEXIT #=  1090 LV= 3 RT1
         B     EXIT47
         LTORG 
EXIT47      DS 0H
*MEXIT #=  1069 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  1091 LV= 2          RT1   CCE
         DS    0H
RT1_TEST63       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE63
         LTORG 
RT1_CCE63       DS 0H
*MEXIT #=  1091 LV= 2 RT1
*MEXIT #=  1046 LV= 1 TEST
*MCALL #=  1092 LV= 1          TEST   DH,=DH'-2'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  1093 LV= 2          TEST1 MF,DH,=DH'-2'
         BASR  R12,0
         USING *,R12
*MCALL #=  1094 LV= 3          CTD   CTD_DH,IN==DH'-2',OUT=DECIMAL,LINKX
               AGE=MF
         LA    1,=A(CTD_DH,0,DECIMAL)
         LA    0,=DH'-2'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1094 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D DH'
         MVC   DHEX,=CL32' '
         LA    R2,=DH'-2'
         LA    R3,L'=DH'-2'
*MCALL #=  1095 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1096 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1096 LV= 4 ZCALL
*MEXIT #=  1095 LV= 3 CALL
*MCALL #=  1097 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1097 LV= 3 WTO
*MCALL #=  1098 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1099 LV= 4          ZSTREQU 
*MEXIT #=  1099 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_95_2
*MEXIT #=  1098 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1100 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1100 LV= 3 WTO
*MCALL #=  1101 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1101 LV= 3 ABEND
*MCALL #=  1102 LV= 3          ENDIF 
*MCALL #=  1103 LV= 4          ZSTREQU 
*MEXIT #=  1103 LV= 4 ZSTREQU
#@IF_95_2                                                DS 0H
*MEXIT #=  1102 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1104 LV= 3          CFD   CFD_DH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_DH,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1104 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D DH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DH'-2'
*MCALL #=  1105 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1106 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1106 LV= 4 ZCALL
*MEXIT #=  1105 LV= 3 CALL
*MCALL #=  1107 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1107 LV= 3 WTO
*MCALL #=  1108 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1109 LV= 4          ZSTREQU 
*MEXIT #=  1109 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_96_2
*MEXIT #=  1108 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1110 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1110 LV= 3 WTO
*MCALL #=  1111 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1111 LV= 3 ABEND
*MCALL #=  1112 LV= 3          ENDIF 
*MCALL #=  1113 LV= 4          ZSTREQU 
*MEXIT #=  1113 LV= 4 ZSTREQU
#@IF_96_2                                                DS 0H
*MEXIT #=  1112 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DH'-2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DH'-2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1114 LV= 3          RT1   CCE
         DS    0H
RT1_TEST64       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE64
         LTORG 
RT1_CCE64       DS 0H
*MEXIT #=  1114 LV= 3 RT1
         B     EXIT48
         LTORG 
EXIT48      DS 0H
*MEXIT #=  1093 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  1115 LV= 2          TEST1 SVC,DH,=DH'-2'
         BASR  R12,0
         USING *,R12
*MCALL #=  1116 LV= 3          CTD   CTD_DH,IN==DH'-2',OUT=DECIMAL,LINKX
               AGE=SVC
         LA    1,=A(CTD_DH,0,DECIMAL)
         LA    0,=DH'-2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1116 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DH'
         MVC   DHEX,=CL32' '
         LA    R2,=DH'-2'
         LA    R3,L'=DH'-2'
*MCALL #=  1117 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1118 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1118 LV= 4 ZCALL
*MEXIT #=  1117 LV= 3 CALL
*MCALL #=  1119 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1119 LV= 3 WTO
*MCALL #=  1120 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1121 LV= 4          ZSTREQU 
*MEXIT #=  1121 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_97_2
*MEXIT #=  1120 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1122 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1122 LV= 3 WTO
*MCALL #=  1123 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1123 LV= 3 ABEND
*MCALL #=  1124 LV= 3          ENDIF 
*MCALL #=  1125 LV= 4          ZSTREQU 
*MEXIT #=  1125 LV= 4 ZSTREQU
#@IF_97_2                                                DS 0H
*MEXIT #=  1124 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1126 LV= 3          CFD   CFD_DH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1126 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DH'-2'
*MCALL #=  1127 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1128 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1128 LV= 4 ZCALL
*MEXIT #=  1127 LV= 3 CALL
*MCALL #=  1129 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1129 LV= 3 WTO
*MCALL #=  1130 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1131 LV= 4          ZSTREQU 
*MEXIT #=  1131 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_98_2
*MEXIT #=  1130 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1132 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1132 LV= 3 WTO
*MCALL #=  1133 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1133 LV= 3 ABEND
*MCALL #=  1134 LV= 3          ENDIF 
*MCALL #=  1135 LV= 4          ZSTREQU 
*MEXIT #=  1135 LV= 4 ZSTREQU
#@IF_98_2                                                DS 0H
*MEXIT #=  1134 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DH'-2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DH'-2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1136 LV= 3          RT1   CCE
         DS    0H
RT1_TEST65       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE65
         LTORG 
RT1_CCE65       DS 0H
*MEXIT #=  1136 LV= 3 RT1
         B     EXIT49
         LTORG 
EXIT49      DS 0H
*MEXIT #=  1115 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  1137 LV= 2          RT1   CCE
         DS    0H
RT1_TEST66       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE66
         LTORG 
RT1_CCE66       DS 0H
*MEXIT #=  1137 LV= 2 RT1
*MEXIT #=  1092 LV= 1 TEST
*MCALL #=  1138 LV= 1          TEST   DH,=DH'-1E2'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  1139 LV= 2          TEST1 MF,DH,=DH'-1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=  1140 LV= 3          CTD   CTD_DH,IN==DH'-1E2',OUT=DECIMAL,LIX
               NKAGE=MF
         LA    1,=A(CTD_DH,0,DECIMAL)
         LA    0,=DH'-1E2'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1140 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D DH'
         MVC   DHEX,=CL32' '
         LA    R2,=DH'-1E2'
         LA    R3,L'=DH'-1E2'
*MCALL #=  1141 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1142 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1142 LV= 4 ZCALL
*MEXIT #=  1141 LV= 3 CALL
*MCALL #=  1143 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1143 LV= 3 WTO
*MCALL #=  1144 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1145 LV= 4          ZSTREQU 
*MEXIT #=  1145 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_99_2
*MEXIT #=  1144 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1146 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1146 LV= 3 WTO
*MCALL #=  1147 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1147 LV= 3 ABEND
*MCALL #=  1148 LV= 3          ENDIF 
*MCALL #=  1149 LV= 4          ZSTREQU 
*MEXIT #=  1149 LV= 4 ZSTREQU
#@IF_99_2                                                DS 0H
*MEXIT #=  1148 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1150 LV= 3          CFD   CFD_DH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_DH,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1150 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D DH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DH'-1E2'
*MCALL #=  1151 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1152 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1152 LV= 4 ZCALL
*MEXIT #=  1151 LV= 3 CALL
*MCALL #=  1153 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1153 LV= 3 WTO
*MCALL #=  1154 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1155 LV= 4          ZSTREQU 
*MEXIT #=  1155 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_100_2
*MEXIT #=  1154 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1156 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1156 LV= 3 WTO
*MCALL #=  1157 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1157 LV= 3 ABEND
*MCALL #=  1158 LV= 3          ENDIF 
*MCALL #=  1159 LV= 4          ZSTREQU 
*MEXIT #=  1159 LV= 4 ZSTREQU
#@IF_100_2                                               DS 0H
*MEXIT #=  1158 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DH'-1E2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DH'-1E2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1160 LV= 3          RT1   CCE
         DS    0H
RT1_TEST67       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE67
         LTORG 
RT1_CCE67       DS 0H
*MEXIT #=  1160 LV= 3 RT1
         B     EXIT50
         LTORG 
EXIT50      DS 0H
*MEXIT #=  1139 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  1161 LV= 2          TEST1 SVC,DH,=DH'-1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=  1162 LV= 3          CTD   CTD_DH,IN==DH'-1E2',OUT=DECIMAL,LIX
               NKAGE=SVC
         LA    1,=A(CTD_DH,0,DECIMAL)
         LA    0,=DH'-1E2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1162 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DH'
         MVC   DHEX,=CL32' '
         LA    R2,=DH'-1E2'
         LA    R3,L'=DH'-1E2'
*MCALL #=  1163 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1164 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1164 LV= 4 ZCALL
*MEXIT #=  1163 LV= 3 CALL
*MCALL #=  1165 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1165 LV= 3 WTO
*MCALL #=  1166 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1167 LV= 4          ZSTREQU 
*MEXIT #=  1167 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_101_2
*MEXIT #=  1166 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1168 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1168 LV= 3 WTO
*MCALL #=  1169 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1169 LV= 3 ABEND
*MCALL #=  1170 LV= 3          ENDIF 
*MCALL #=  1171 LV= 4          ZSTREQU 
*MEXIT #=  1171 LV= 4 ZSTREQU
#@IF_101_2                                               DS 0H
*MEXIT #=  1170 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1172 LV= 3          CFD   CFD_DH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1172 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D DH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DH'-1E2'
*MCALL #=  1173 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1174 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1174 LV= 4 ZCALL
*MEXIT #=  1173 LV= 3 CALL
*MCALL #=  1175 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1175 LV= 3 WTO
*MCALL #=  1176 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1177 LV= 4          ZSTREQU 
*MEXIT #=  1177 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_102_2
*MEXIT #=  1176 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1178 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1178 LV= 3 WTO
*MCALL #=  1179 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1179 LV= 3 ABEND
*MCALL #=  1180 LV= 3          ENDIF 
*MCALL #=  1181 LV= 4          ZSTREQU 
*MEXIT #=  1181 LV= 4 ZSTREQU
#@IF_102_2                                               DS 0H
*MEXIT #=  1180 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=DH'-1E2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=DH'-1E2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1182 LV= 3          RT1   CCE
         DS    0H
RT1_TEST68       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE68
         LTORG 
RT1_CCE68       DS 0H
*MEXIT #=  1182 LV= 3 RT1
         B     EXIT51
         LTORG 
EXIT51      DS 0H
*MEXIT #=  1161 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  1183 LV= 2          RT1   CCE
         DS    0H
RT1_TEST69       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE69
         LTORG 
RT1_CCE69       DS 0H
*MEXIT #=  1183 LV= 2 RT1
*MEXIT #=  1138 LV= 1 TEST
* EB
*MCALL #=  1184 LV= 1          TEST   EB,=EB'0'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  1185 LV= 2          TEST1 MF,EB,=EB'0'
         BASR  R12,0
         USING *,R12
*MCALL #=  1186 LV= 3          CTD   CTD_EB,IN==EB'0',OUT=DECIMAL,LINKAX
               GE=MF
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'0'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1186 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'0'
         LA    R3,L'=EB'0'
*MCALL #=  1187 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1188 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1188 LV= 4 ZCALL
*MEXIT #=  1187 LV= 3 CALL
*MCALL #=  1189 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1189 LV= 3 WTO
*MCALL #=  1190 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1191 LV= 4          ZSTREQU 
*MEXIT #=  1191 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_103_2
*MEXIT #=  1190 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1192 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1192 LV= 3 WTO
*MCALL #=  1193 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1193 LV= 3 ABEND
*MCALL #=  1194 LV= 3          ENDIF 
*MCALL #=  1195 LV= 4          ZSTREQU 
*MEXIT #=  1195 LV= 4 ZSTREQU
#@IF_103_2                                               DS 0H
*MEXIT #=  1194 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1196 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1196 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'0'
*MCALL #=  1197 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1198 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1198 LV= 4 ZCALL
*MEXIT #=  1197 LV= 3 CALL
*MCALL #=  1199 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1199 LV= 3 WTO
*MCALL #=  1200 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1201 LV= 4          ZSTREQU 
*MEXIT #=  1201 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_104_2
*MEXIT #=  1200 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1202 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1202 LV= 3 WTO
*MCALL #=  1203 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1203 LV= 3 ABEND
*MCALL #=  1204 LV= 3          ENDIF 
*MCALL #=  1205 LV= 4          ZSTREQU 
*MEXIT #=  1205 LV= 4 ZSTREQU
#@IF_104_2                                               DS 0H
*MEXIT #=  1204 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EB'0'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EB'0'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1206 LV= 3          RT1   CCE
         DS    0H
RT1_TEST70       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE70
         LTORG 
RT1_CCE70       DS 0H
*MEXIT #=  1206 LV= 3 RT1
         B     EXIT52
         LTORG 
EXIT52      DS 0H
*MEXIT #=  1185 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  1207 LV= 2          TEST1 SVC,EB,=EB'0'
         BASR  R12,0
         USING *,R12
*MCALL #=  1208 LV= 3          CTD   CTD_EB,IN==EB'0',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'0'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1208 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'0'
         LA    R3,L'=EB'0'
*MCALL #=  1209 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1210 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1210 LV= 4 ZCALL
*MEXIT #=  1209 LV= 3 CALL
*MCALL #=  1211 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1211 LV= 3 WTO
*MCALL #=  1212 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1213 LV= 4          ZSTREQU 
*MEXIT #=  1213 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_105_2
*MEXIT #=  1212 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1214 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1214 LV= 3 WTO
*MCALL #=  1215 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1215 LV= 3 ABEND
*MCALL #=  1216 LV= 3          ENDIF 
*MCALL #=  1217 LV= 4          ZSTREQU 
*MEXIT #=  1217 LV= 4 ZSTREQU
#@IF_105_2                                               DS 0H
*MEXIT #=  1216 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1218 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1218 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'0'
*MCALL #=  1219 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1220 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1220 LV= 4 ZCALL
*MEXIT #=  1219 LV= 3 CALL
*MCALL #=  1221 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1221 LV= 3 WTO
*MCALL #=  1222 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1223 LV= 4          ZSTREQU 
*MEXIT #=  1223 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_106_2
*MEXIT #=  1222 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1224 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1224 LV= 3 WTO
*MCALL #=  1225 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1225 LV= 3 ABEND
*MCALL #=  1226 LV= 3          ENDIF 
*MCALL #=  1227 LV= 4          ZSTREQU 
*MEXIT #=  1227 LV= 4 ZSTREQU
#@IF_106_2                                               DS 0H
*MEXIT #=  1226 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EB'0'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EB'0'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1228 LV= 3          RT1   CCE
         DS    0H
RT1_TEST71       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE71
         LTORG 
RT1_CCE71       DS 0H
*MEXIT #=  1228 LV= 3 RT1
         B     EXIT53
         LTORG 
EXIT53      DS 0H
*MEXIT #=  1207 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  1229 LV= 2          RT1   CCE
         DS    0H
RT1_TEST72       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE72
         LTORG 
RT1_CCE72       DS 0H
*MEXIT #=  1229 LV= 2 RT1
*MEXIT #=  1184 LV= 1 TEST
*MCALL #=  1230 LV= 1          TEST   EB,=EB'2E-38' 1E-38 CAUSES UNDERFX
               LOW
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  1231 LV= 2          TEST1 MF,EB,=EB'2E-38'
         BASR  R12,0
         USING *,R12
*MCALL #=  1232 LV= 3          CTD   CTD_EB,IN==EB'2E-38',OUT=DECIMAL,LX
               INKAGE=MF
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'2E-38'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1232 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'2E-38'
         LA    R3,L'=EB'2E-38'
*MCALL #=  1233 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1234 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1234 LV= 4 ZCALL
*MEXIT #=  1233 LV= 3 CALL
*MCALL #=  1235 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1235 LV= 3 WTO
*MCALL #=  1236 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1237 LV= 4          ZSTREQU 
*MEXIT #=  1237 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_107_2
*MEXIT #=  1236 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1238 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1238 LV= 3 WTO
*MCALL #=  1239 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1239 LV= 3 ABEND
*MCALL #=  1240 LV= 3          ENDIF 
*MCALL #=  1241 LV= 4          ZSTREQU 
*MEXIT #=  1241 LV= 4 ZSTREQU
#@IF_107_2                                               DS 0H
*MEXIT #=  1240 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1242 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1242 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'2E-38'
*MCALL #=  1243 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1244 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1244 LV= 4 ZCALL
*MEXIT #=  1243 LV= 3 CALL
*MCALL #=  1245 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1245 LV= 3 WTO
*MCALL #=  1246 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1247 LV= 4          ZSTREQU 
*MEXIT #=  1247 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_108_2
*MEXIT #=  1246 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1248 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1248 LV= 3 WTO
*MCALL #=  1249 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1249 LV= 3 ABEND
*MCALL #=  1250 LV= 3          ENDIF 
*MCALL #=  1251 LV= 4          ZSTREQU 
*MEXIT #=  1251 LV= 4 ZSTREQU
#@IF_108_2                                               DS 0H
*MEXIT #=  1250 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EB'2E-38'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EB'2E-38'  VERIFY CTD CONSTANT WITH CFD RESULX
               T
* RPI 786 START TEST FOR DFP
*MCALL #=  1252 LV= 3          RT1   CCE
         DS    0H
RT1_TEST73       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE73
         LTORG 
RT1_CCE73       DS 0H
*MEXIT #=  1252 LV= 3 RT1
         B     EXIT54
         LTORG 
EXIT54      DS 0H
*MEXIT #=  1231 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  1253 LV= 2          TEST1 SVC,EB,=EB'2E-38'
         BASR  R12,0
         USING *,R12
*MCALL #=  1254 LV= 3          CTD   CTD_EB,IN==EB'2E-38',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'2E-38'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1254 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'2E-38'
         LA    R3,L'=EB'2E-38'
*MCALL #=  1255 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1256 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1256 LV= 4 ZCALL
*MEXIT #=  1255 LV= 3 CALL
*MCALL #=  1257 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1257 LV= 3 WTO
*MCALL #=  1258 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1259 LV= 4          ZSTREQU 
*MEXIT #=  1259 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_109_2
*MEXIT #=  1258 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1260 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1260 LV= 3 WTO
*MCALL #=  1261 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1261 LV= 3 ABEND
*MCALL #=  1262 LV= 3          ENDIF 
*MCALL #=  1263 LV= 4          ZSTREQU 
*MEXIT #=  1263 LV= 4 ZSTREQU
#@IF_109_2                                               DS 0H
*MEXIT #=  1262 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1264 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1264 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'2E-38'
*MCALL #=  1265 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1266 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1266 LV= 4 ZCALL
*MEXIT #=  1265 LV= 3 CALL
*MCALL #=  1267 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1267 LV= 3 WTO
*MCALL #=  1268 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1269 LV= 4          ZSTREQU 
*MEXIT #=  1269 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_110_2
*MEXIT #=  1268 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1270 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1270 LV= 3 WTO
*MCALL #=  1271 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1271 LV= 3 ABEND
*MCALL #=  1272 LV= 3          ENDIF 
*MCALL #=  1273 LV= 4          ZSTREQU 
*MEXIT #=  1273 LV= 4 ZSTREQU
#@IF_110_2                                               DS 0H
*MEXIT #=  1272 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EB'2E-38'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EB'2E-38'  VERIFY CTD CONSTANT WITH CFD RESULX
               T
* RPI 786 START TEST FOR DFP
*MCALL #=  1274 LV= 3          RT1   CCE
         DS    0H
RT1_TEST74       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE74
         LTORG 
RT1_CCE74       DS 0H
*MEXIT #=  1274 LV= 3 RT1
         B     EXIT55
         LTORG 
EXIT55      DS 0H
*MEXIT #=  1253 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  1275 LV= 2          RT1   CCE
         DS    0H
RT1_TEST75       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE75
         LTORG 
RT1_CCE75       DS 0H
*MEXIT #=  1275 LV= 2 RT1
*MEXIT #=  1230 LV= 1 TEST
*MCALL #=  1276 LV= 1          TEST   EB,=EB'1'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  1277 LV= 2          TEST1 MF,EB,=EB'1'
         BASR  R12,0
         USING *,R12
*MCALL #=  1278 LV= 3          CTD   CTD_EB,IN==EB'1',OUT=DECIMAL,LINKAX
               GE=MF
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'1'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1278 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'1'
         LA    R3,L'=EB'1'
*MCALL #=  1279 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1280 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1280 LV= 4 ZCALL
*MEXIT #=  1279 LV= 3 CALL
*MCALL #=  1281 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1281 LV= 3 WTO
*MCALL #=  1282 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1283 LV= 4          ZSTREQU 
*MEXIT #=  1283 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_111_2
*MEXIT #=  1282 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1284 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1284 LV= 3 WTO
*MCALL #=  1285 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1285 LV= 3 ABEND
*MCALL #=  1286 LV= 3          ENDIF 
*MCALL #=  1287 LV= 4          ZSTREQU 
*MEXIT #=  1287 LV= 4 ZSTREQU
#@IF_111_2                                               DS 0H
*MEXIT #=  1286 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1288 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1288 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'1'
*MCALL #=  1289 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1290 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1290 LV= 4 ZCALL
*MEXIT #=  1289 LV= 3 CALL
*MCALL #=  1291 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1291 LV= 3 WTO
*MCALL #=  1292 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1293 LV= 4          ZSTREQU 
*MEXIT #=  1293 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_112_2
*MEXIT #=  1292 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1294 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1294 LV= 3 WTO
*MCALL #=  1295 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1295 LV= 3 ABEND
*MCALL #=  1296 LV= 3          ENDIF 
*MCALL #=  1297 LV= 4          ZSTREQU 
*MEXIT #=  1297 LV= 4 ZSTREQU
#@IF_112_2                                               DS 0H
*MEXIT #=  1296 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EB'1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EB'1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1298 LV= 3          RT1   CCE
         DS    0H
RT1_TEST76       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE76
         LTORG 
RT1_CCE76       DS 0H
*MEXIT #=  1298 LV= 3 RT1
         B     EXIT56
         LTORG 
EXIT56      DS 0H
*MEXIT #=  1277 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  1299 LV= 2          TEST1 SVC,EB,=EB'1'
         BASR  R12,0
         USING *,R12
*MCALL #=  1300 LV= 3          CTD   CTD_EB,IN==EB'1',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1300 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'1'
         LA    R3,L'=EB'1'
*MCALL #=  1301 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1302 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1302 LV= 4 ZCALL
*MEXIT #=  1301 LV= 3 CALL
*MCALL #=  1303 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1303 LV= 3 WTO
*MCALL #=  1304 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1305 LV= 4          ZSTREQU 
*MEXIT #=  1305 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_113_2
*MEXIT #=  1304 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1306 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1306 LV= 3 WTO
*MCALL #=  1307 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1307 LV= 3 ABEND
*MCALL #=  1308 LV= 3          ENDIF 
*MCALL #=  1309 LV= 4          ZSTREQU 
*MEXIT #=  1309 LV= 4 ZSTREQU
#@IF_113_2                                               DS 0H
*MEXIT #=  1308 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1310 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1310 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'1'
*MCALL #=  1311 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1312 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1312 LV= 4 ZCALL
*MEXIT #=  1311 LV= 3 CALL
*MCALL #=  1313 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1313 LV= 3 WTO
*MCALL #=  1314 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1315 LV= 4          ZSTREQU 
*MEXIT #=  1315 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_114_2
*MEXIT #=  1314 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1316 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1316 LV= 3 WTO
*MCALL #=  1317 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1317 LV= 3 ABEND
*MCALL #=  1318 LV= 3          ENDIF 
*MCALL #=  1319 LV= 4          ZSTREQU 
*MEXIT #=  1319 LV= 4 ZSTREQU
#@IF_114_2                                               DS 0H
*MEXIT #=  1318 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EB'1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EB'1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1320 LV= 3          RT1   CCE
         DS    0H
RT1_TEST77       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE77
         LTORG 
RT1_CCE77       DS 0H
*MEXIT #=  1320 LV= 3 RT1
         B     EXIT57
         LTORG 
EXIT57      DS 0H
*MEXIT #=  1299 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  1321 LV= 2          RT1   CCE
         DS    0H
RT1_TEST78       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE78
         LTORG 
RT1_CCE78       DS 0H
*MEXIT #=  1321 LV= 2 RT1
*MEXIT #=  1276 LV= 1 TEST
*MCALL #=  1322 LV= 1          TEST   EB,=EB'2'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  1323 LV= 2          TEST1 MF,EB,=EB'2'
         BASR  R12,0
         USING *,R12
*MCALL #=  1324 LV= 3          CTD   CTD_EB,IN==EB'2',OUT=DECIMAL,LINKAX
               GE=MF
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'2'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1324 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'2'
         LA    R3,L'=EB'2'
*MCALL #=  1325 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1326 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1326 LV= 4 ZCALL
*MEXIT #=  1325 LV= 3 CALL
*MCALL #=  1327 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1327 LV= 3 WTO
*MCALL #=  1328 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1329 LV= 4          ZSTREQU 
*MEXIT #=  1329 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_115_2
*MEXIT #=  1328 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1330 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1330 LV= 3 WTO
*MCALL #=  1331 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1331 LV= 3 ABEND
*MCALL #=  1332 LV= 3          ENDIF 
*MCALL #=  1333 LV= 4          ZSTREQU 
*MEXIT #=  1333 LV= 4 ZSTREQU
#@IF_115_2                                               DS 0H
*MEXIT #=  1332 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1334 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1334 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'2'
*MCALL #=  1335 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1336 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1336 LV= 4 ZCALL
*MEXIT #=  1335 LV= 3 CALL
*MCALL #=  1337 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1337 LV= 3 WTO
*MCALL #=  1338 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1339 LV= 4          ZSTREQU 
*MEXIT #=  1339 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_116_2
*MEXIT #=  1338 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1340 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1340 LV= 3 WTO
*MCALL #=  1341 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1341 LV= 3 ABEND
*MCALL #=  1342 LV= 3          ENDIF 
*MCALL #=  1343 LV= 4          ZSTREQU 
*MEXIT #=  1343 LV= 4 ZSTREQU
#@IF_116_2                                               DS 0H
*MEXIT #=  1342 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EB'2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EB'2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1344 LV= 3          RT1   CCE
         DS    0H
RT1_TEST79       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE79
         LTORG 
RT1_CCE79       DS 0H
*MEXIT #=  1344 LV= 3 RT1
         B     EXIT58
         LTORG 
EXIT58      DS 0H
*MEXIT #=  1323 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  1345 LV= 2          TEST1 SVC,EB,=EB'2'
         BASR  R12,0
         USING *,R12
*MCALL #=  1346 LV= 3          CTD   CTD_EB,IN==EB'2',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1346 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'2'
         LA    R3,L'=EB'2'
*MCALL #=  1347 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1348 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1348 LV= 4 ZCALL
*MEXIT #=  1347 LV= 3 CALL
*MCALL #=  1349 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1349 LV= 3 WTO
*MCALL #=  1350 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1351 LV= 4          ZSTREQU 
*MEXIT #=  1351 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_117_2
*MEXIT #=  1350 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1352 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1352 LV= 3 WTO
*MCALL #=  1353 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1353 LV= 3 ABEND
*MCALL #=  1354 LV= 3          ENDIF 
*MCALL #=  1355 LV= 4          ZSTREQU 
*MEXIT #=  1355 LV= 4 ZSTREQU
#@IF_117_2                                               DS 0H
*MEXIT #=  1354 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1356 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1356 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'2'
*MCALL #=  1357 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1358 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1358 LV= 4 ZCALL
*MEXIT #=  1357 LV= 3 CALL
*MCALL #=  1359 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1359 LV= 3 WTO
*MCALL #=  1360 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1361 LV= 4          ZSTREQU 
*MEXIT #=  1361 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_118_2
*MEXIT #=  1360 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1362 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1362 LV= 3 WTO
*MCALL #=  1363 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1363 LV= 3 ABEND
*MCALL #=  1364 LV= 3          ENDIF 
*MCALL #=  1365 LV= 4          ZSTREQU 
*MEXIT #=  1365 LV= 4 ZSTREQU
#@IF_118_2                                               DS 0H
*MEXIT #=  1364 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EB'2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EB'2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1366 LV= 3          RT1   CCE
         DS    0H
RT1_TEST80       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE80
         LTORG 
RT1_CCE80       DS 0H
*MEXIT #=  1366 LV= 3 RT1
         B     EXIT59
         LTORG 
EXIT59      DS 0H
*MEXIT #=  1345 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  1367 LV= 2          RT1   CCE
         DS    0H
RT1_TEST81       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE81
         LTORG 
RT1_CCE81       DS 0H
*MEXIT #=  1367 LV= 2 RT1
*MEXIT #=  1322 LV= 1 TEST
*MCALL #=  1368 LV= 1          TEST   EB,=EB'3'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  1369 LV= 2          TEST1 MF,EB,=EB'3'
         BASR  R12,0
         USING *,R12
*MCALL #=  1370 LV= 3          CTD   CTD_EB,IN==EB'3',OUT=DECIMAL,LINKAX
               GE=MF
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'3'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1370 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'3'
         LA    R3,L'=EB'3'
*MCALL #=  1371 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1372 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1372 LV= 4 ZCALL
*MEXIT #=  1371 LV= 3 CALL
*MCALL #=  1373 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1373 LV= 3 WTO
*MCALL #=  1374 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1375 LV= 4          ZSTREQU 
*MEXIT #=  1375 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_119_2
*MEXIT #=  1374 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1376 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1376 LV= 3 WTO
*MCALL #=  1377 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1377 LV= 3 ABEND
*MCALL #=  1378 LV= 3          ENDIF 
*MCALL #=  1379 LV= 4          ZSTREQU 
*MEXIT #=  1379 LV= 4 ZSTREQU
#@IF_119_2                                               DS 0H
*MEXIT #=  1378 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1380 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1380 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'3'
*MCALL #=  1381 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1382 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1382 LV= 4 ZCALL
*MEXIT #=  1381 LV= 3 CALL
*MCALL #=  1383 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1383 LV= 3 WTO
*MCALL #=  1384 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1385 LV= 4          ZSTREQU 
*MEXIT #=  1385 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_120_2
*MEXIT #=  1384 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1386 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1386 LV= 3 WTO
*MCALL #=  1387 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1387 LV= 3 ABEND
*MCALL #=  1388 LV= 3          ENDIF 
*MCALL #=  1389 LV= 4          ZSTREQU 
*MEXIT #=  1389 LV= 4 ZSTREQU
#@IF_120_2                                               DS 0H
*MEXIT #=  1388 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EB'3'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EB'3'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1390 LV= 3          RT1   CCE
         DS    0H
RT1_TEST82       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE82
         LTORG 
RT1_CCE82       DS 0H
*MEXIT #=  1390 LV= 3 RT1
         B     EXIT60
         LTORG 
EXIT60      DS 0H
*MEXIT #=  1369 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  1391 LV= 2          TEST1 SVC,EB,=EB'3'
         BASR  R12,0
         USING *,R12
*MCALL #=  1392 LV= 3          CTD   CTD_EB,IN==EB'3',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'3'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1392 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'3'
         LA    R3,L'=EB'3'
*MCALL #=  1393 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1394 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1394 LV= 4 ZCALL
*MEXIT #=  1393 LV= 3 CALL
*MCALL #=  1395 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1395 LV= 3 WTO
*MCALL #=  1396 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1397 LV= 4          ZSTREQU 
*MEXIT #=  1397 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_121_2
*MEXIT #=  1396 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1398 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1398 LV= 3 WTO
*MCALL #=  1399 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1399 LV= 3 ABEND
*MCALL #=  1400 LV= 3          ENDIF 
*MCALL #=  1401 LV= 4          ZSTREQU 
*MEXIT #=  1401 LV= 4 ZSTREQU
#@IF_121_2                                               DS 0H
*MEXIT #=  1400 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1402 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1402 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'3'
*MCALL #=  1403 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1404 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1404 LV= 4 ZCALL
*MEXIT #=  1403 LV= 3 CALL
*MCALL #=  1405 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1405 LV= 3 WTO
*MCALL #=  1406 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1407 LV= 4          ZSTREQU 
*MEXIT #=  1407 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_122_2
*MEXIT #=  1406 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1408 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1408 LV= 3 WTO
*MCALL #=  1409 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1409 LV= 3 ABEND
*MCALL #=  1410 LV= 3          ENDIF 
*MCALL #=  1411 LV= 4          ZSTREQU 
*MEXIT #=  1411 LV= 4 ZSTREQU
#@IF_122_2                                               DS 0H
*MEXIT #=  1410 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EB'3'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EB'3'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1412 LV= 3          RT1   CCE
         DS    0H
RT1_TEST83       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE83
         LTORG 
RT1_CCE83       DS 0H
*MEXIT #=  1412 LV= 3 RT1
         B     EXIT61
         LTORG 
EXIT61      DS 0H
*MEXIT #=  1391 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  1413 LV= 2          RT1   CCE
         DS    0H
RT1_TEST84       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE84
         LTORG 
RT1_CCE84       DS 0H
*MEXIT #=  1413 LV= 2 RT1
*MEXIT #=  1368 LV= 1 TEST
*MCALL #=  1414 LV= 1          TEST   EB,=EB'1E2'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  1415 LV= 2          TEST1 MF,EB,=EB'1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=  1416 LV= 3          CTD   CTD_EB,IN==EB'1E2',OUT=DECIMAL,LINX
               KAGE=MF
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'1E2'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1416 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'1E2'
         LA    R3,L'=EB'1E2'
*MCALL #=  1417 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1418 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1418 LV= 4 ZCALL
*MEXIT #=  1417 LV= 3 CALL
*MCALL #=  1419 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1419 LV= 3 WTO
*MCALL #=  1420 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1421 LV= 4          ZSTREQU 
*MEXIT #=  1421 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_123_2
*MEXIT #=  1420 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1422 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1422 LV= 3 WTO
*MCALL #=  1423 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1423 LV= 3 ABEND
*MCALL #=  1424 LV= 3          ENDIF 
*MCALL #=  1425 LV= 4          ZSTREQU 
*MEXIT #=  1425 LV= 4 ZSTREQU
#@IF_123_2                                               DS 0H
*MEXIT #=  1424 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1426 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1426 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'1E2'
*MCALL #=  1427 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1428 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1428 LV= 4 ZCALL
*MEXIT #=  1427 LV= 3 CALL
*MCALL #=  1429 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1429 LV= 3 WTO
*MCALL #=  1430 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1431 LV= 4          ZSTREQU 
*MEXIT #=  1431 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_124_2
*MEXIT #=  1430 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1432 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1432 LV= 3 WTO
*MCALL #=  1433 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1433 LV= 3 ABEND
*MCALL #=  1434 LV= 3          ENDIF 
*MCALL #=  1435 LV= 4          ZSTREQU 
*MEXIT #=  1435 LV= 4 ZSTREQU
#@IF_124_2                                               DS 0H
*MEXIT #=  1434 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EB'1E2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EB'1E2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1436 LV= 3          RT1   CCE
         DS    0H
RT1_TEST85       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE85
         LTORG 
RT1_CCE85       DS 0H
*MEXIT #=  1436 LV= 3 RT1
         B     EXIT62
         LTORG 
EXIT62      DS 0H
*MEXIT #=  1415 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  1437 LV= 2          TEST1 SVC,EB,=EB'1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=  1438 LV= 3          CTD   CTD_EB,IN==EB'1E2',OUT=DECIMAL,LINX
               KAGE=SVC
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'1E2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1438 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'1E2'
         LA    R3,L'=EB'1E2'
*MCALL #=  1439 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1440 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1440 LV= 4 ZCALL
*MEXIT #=  1439 LV= 3 CALL
*MCALL #=  1441 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1441 LV= 3 WTO
*MCALL #=  1442 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1443 LV= 4          ZSTREQU 
*MEXIT #=  1443 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_125_2
*MEXIT #=  1442 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1444 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1444 LV= 3 WTO
*MCALL #=  1445 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1445 LV= 3 ABEND
*MCALL #=  1446 LV= 3          ENDIF 
*MCALL #=  1447 LV= 4          ZSTREQU 
*MEXIT #=  1447 LV= 4 ZSTREQU
#@IF_125_2                                               DS 0H
*MEXIT #=  1446 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1448 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1448 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'1E2'
*MCALL #=  1449 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1450 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1450 LV= 4 ZCALL
*MEXIT #=  1449 LV= 3 CALL
*MCALL #=  1451 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1451 LV= 3 WTO
*MCALL #=  1452 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1453 LV= 4          ZSTREQU 
*MEXIT #=  1453 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_126_2
*MEXIT #=  1452 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1454 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1454 LV= 3 WTO
*MCALL #=  1455 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1455 LV= 3 ABEND
*MCALL #=  1456 LV= 3          ENDIF 
*MCALL #=  1457 LV= 4          ZSTREQU 
*MEXIT #=  1457 LV= 4 ZSTREQU
#@IF_126_2                                               DS 0H
*MEXIT #=  1456 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EB'1E2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EB'1E2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1458 LV= 3          RT1   CCE
         DS    0H
RT1_TEST86       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE86
         LTORG 
RT1_CCE86       DS 0H
*MEXIT #=  1458 LV= 3 RT1
         B     EXIT63
         LTORG 
EXIT63      DS 0H
*MEXIT #=  1437 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  1459 LV= 2          RT1   CCE
         DS    0H
RT1_TEST87       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE87
         LTORG 
RT1_CCE87       DS 0H
*MEXIT #=  1459 LV= 2 RT1
*MEXIT #=  1414 LV= 1 TEST
*MCALL #=  1460 LV= 1          TEST   EB,=EB'1E38'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  1461 LV= 2          TEST1 MF,EB,=EB'1E38'
         BASR  R12,0
         USING *,R12
*MCALL #=  1462 LV= 3          CTD   CTD_EB,IN==EB'1E38',OUT=DECIMAL,LIX
               NKAGE=MF
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'1E38'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1462 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'1E38'
         LA    R3,L'=EB'1E38'
*MCALL #=  1463 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1464 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1464 LV= 4 ZCALL
*MEXIT #=  1463 LV= 3 CALL
*MCALL #=  1465 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1465 LV= 3 WTO
*MCALL #=  1466 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1467 LV= 4          ZSTREQU 
*MEXIT #=  1467 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_127_2
*MEXIT #=  1466 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1468 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1468 LV= 3 WTO
*MCALL #=  1469 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1469 LV= 3 ABEND
*MCALL #=  1470 LV= 3          ENDIF 
*MCALL #=  1471 LV= 4          ZSTREQU 
*MEXIT #=  1471 LV= 4 ZSTREQU
#@IF_127_2                                               DS 0H
*MEXIT #=  1470 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1472 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1472 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'1E38'
*MCALL #=  1473 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1474 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1474 LV= 4 ZCALL
*MEXIT #=  1473 LV= 3 CALL
*MCALL #=  1475 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1475 LV= 3 WTO
*MCALL #=  1476 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1477 LV= 4          ZSTREQU 
*MEXIT #=  1477 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_128_2
*MEXIT #=  1476 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1478 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1478 LV= 3 WTO
*MCALL #=  1479 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1479 LV= 3 ABEND
*MCALL #=  1480 LV= 3          ENDIF 
*MCALL #=  1481 LV= 4          ZSTREQU 
*MEXIT #=  1481 LV= 4 ZSTREQU
#@IF_128_2                                               DS 0H
*MEXIT #=  1480 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EB'1E38'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EB'1E38'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1482 LV= 3          RT1   CCE
         DS    0H
RT1_TEST88       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE88
         LTORG 
RT1_CCE88       DS 0H
*MEXIT #=  1482 LV= 3 RT1
         B     EXIT64
         LTORG 
EXIT64      DS 0H
*MEXIT #=  1461 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  1483 LV= 2          TEST1 SVC,EB,=EB'1E38'
         BASR  R12,0
         USING *,R12
*MCALL #=  1484 LV= 3          CTD   CTD_EB,IN==EB'1E38',OUT=DECIMAL,LIX
               NKAGE=SVC
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'1E38'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1484 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'1E38'
         LA    R3,L'=EB'1E38'
*MCALL #=  1485 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1486 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1486 LV= 4 ZCALL
*MEXIT #=  1485 LV= 3 CALL
*MCALL #=  1487 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1487 LV= 3 WTO
*MCALL #=  1488 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1489 LV= 4          ZSTREQU 
*MEXIT #=  1489 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_129_2
*MEXIT #=  1488 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1490 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1490 LV= 3 WTO
*MCALL #=  1491 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1491 LV= 3 ABEND
*MCALL #=  1492 LV= 3          ENDIF 
*MCALL #=  1493 LV= 4          ZSTREQU 
*MEXIT #=  1493 LV= 4 ZSTREQU
#@IF_129_2                                               DS 0H
*MEXIT #=  1492 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1494 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1494 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'1E38'
*MCALL #=  1495 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1496 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1496 LV= 4 ZCALL
*MEXIT #=  1495 LV= 3 CALL
*MCALL #=  1497 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1497 LV= 3 WTO
*MCALL #=  1498 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1499 LV= 4          ZSTREQU 
*MEXIT #=  1499 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_130_2
*MEXIT #=  1498 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1500 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1500 LV= 3 WTO
*MCALL #=  1501 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1501 LV= 3 ABEND
*MCALL #=  1502 LV= 3          ENDIF 
*MCALL #=  1503 LV= 4          ZSTREQU 
*MEXIT #=  1503 LV= 4 ZSTREQU
#@IF_130_2                                               DS 0H
*MEXIT #=  1502 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EB'1E38'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EB'1E38'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1504 LV= 3          RT1   CCE
         DS    0H
RT1_TEST89       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE89
         LTORG 
RT1_CCE89       DS 0H
*MEXIT #=  1504 LV= 3 RT1
         B     EXIT65
         LTORG 
EXIT65      DS 0H
*MEXIT #=  1483 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  1505 LV= 2          RT1   CCE
         DS    0H
RT1_TEST90       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE90
         LTORG 
RT1_CCE90       DS 0H
*MEXIT #=  1505 LV= 2 RT1
*MEXIT #=  1460 LV= 1 TEST
*MCALL #=  1506 LV= 1          TEST   EB,=EB'-1'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  1507 LV= 2          TEST1 MF,EB,=EB'-1'
         BASR  R12,0
         USING *,R12
*MCALL #=  1508 LV= 3          CTD   CTD_EB,IN==EB'-1',OUT=DECIMAL,LINKX
               AGE=MF
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'-1'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1508 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'-1'
         LA    R3,L'=EB'-1'
*MCALL #=  1509 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1510 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1510 LV= 4 ZCALL
*MEXIT #=  1509 LV= 3 CALL
*MCALL #=  1511 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1511 LV= 3 WTO
*MCALL #=  1512 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1513 LV= 4          ZSTREQU 
*MEXIT #=  1513 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_131_2
*MEXIT #=  1512 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1514 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1514 LV= 3 WTO
*MCALL #=  1515 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1515 LV= 3 ABEND
*MCALL #=  1516 LV= 3          ENDIF 
*MCALL #=  1517 LV= 4          ZSTREQU 
*MEXIT #=  1517 LV= 4 ZSTREQU
#@IF_131_2                                               DS 0H
*MEXIT #=  1516 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1518 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1518 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'-1'
*MCALL #=  1519 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1520 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1520 LV= 4 ZCALL
*MEXIT #=  1519 LV= 3 CALL
*MCALL #=  1521 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1521 LV= 3 WTO
*MCALL #=  1522 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1523 LV= 4          ZSTREQU 
*MEXIT #=  1523 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_132_2
*MEXIT #=  1522 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1524 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1524 LV= 3 WTO
*MCALL #=  1525 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1525 LV= 3 ABEND
*MCALL #=  1526 LV= 3          ENDIF 
*MCALL #=  1527 LV= 4          ZSTREQU 
*MEXIT #=  1527 LV= 4 ZSTREQU
#@IF_132_2                                               DS 0H
*MEXIT #=  1526 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EB'-1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EB'-1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1528 LV= 3          RT1   CCE
         DS    0H
RT1_TEST91       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE91
         LTORG 
RT1_CCE91       DS 0H
*MEXIT #=  1528 LV= 3 RT1
         B     EXIT66
         LTORG 
EXIT66      DS 0H
*MEXIT #=  1507 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  1529 LV= 2          TEST1 SVC,EB,=EB'-1'
         BASR  R12,0
         USING *,R12
*MCALL #=  1530 LV= 3          CTD   CTD_EB,IN==EB'-1',OUT=DECIMAL,LINKX
               AGE=SVC
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'-1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1530 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'-1'
         LA    R3,L'=EB'-1'
*MCALL #=  1531 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1532 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1532 LV= 4 ZCALL
*MEXIT #=  1531 LV= 3 CALL
*MCALL #=  1533 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1533 LV= 3 WTO
*MCALL #=  1534 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1535 LV= 4          ZSTREQU 
*MEXIT #=  1535 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_133_2
*MEXIT #=  1534 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1536 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1536 LV= 3 WTO
*MCALL #=  1537 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1537 LV= 3 ABEND
*MCALL #=  1538 LV= 3          ENDIF 
*MCALL #=  1539 LV= 4          ZSTREQU 
*MEXIT #=  1539 LV= 4 ZSTREQU
#@IF_133_2                                               DS 0H
*MEXIT #=  1538 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1540 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1540 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'-1'
*MCALL #=  1541 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1542 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1542 LV= 4 ZCALL
*MEXIT #=  1541 LV= 3 CALL
*MCALL #=  1543 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1543 LV= 3 WTO
*MCALL #=  1544 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1545 LV= 4          ZSTREQU 
*MEXIT #=  1545 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_134_2
*MEXIT #=  1544 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1546 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1546 LV= 3 WTO
*MCALL #=  1547 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1547 LV= 3 ABEND
*MCALL #=  1548 LV= 3          ENDIF 
*MCALL #=  1549 LV= 4          ZSTREQU 
*MEXIT #=  1549 LV= 4 ZSTREQU
#@IF_134_2                                               DS 0H
*MEXIT #=  1548 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EB'-1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EB'-1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1550 LV= 3          RT1   CCE
         DS    0H
RT1_TEST92       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE92
         LTORG 
RT1_CCE92       DS 0H
*MEXIT #=  1550 LV= 3 RT1
         B     EXIT67
         LTORG 
EXIT67      DS 0H
*MEXIT #=  1529 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  1551 LV= 2          RT1   CCE
         DS    0H
RT1_TEST93       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE93
         LTORG 
RT1_CCE93       DS 0H
*MEXIT #=  1551 LV= 2 RT1
*MEXIT #=  1506 LV= 1 TEST
*MCALL #=  1552 LV= 1          TEST   EB,=EB'-2'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  1553 LV= 2          TEST1 MF,EB,=EB'-2'
         BASR  R12,0
         USING *,R12
*MCALL #=  1554 LV= 3          CTD   CTD_EB,IN==EB'-2',OUT=DECIMAL,LINKX
               AGE=MF
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'-2'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1554 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'-2'
         LA    R3,L'=EB'-2'
*MCALL #=  1555 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1556 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1556 LV= 4 ZCALL
*MEXIT #=  1555 LV= 3 CALL
*MCALL #=  1557 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1557 LV= 3 WTO
*MCALL #=  1558 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1559 LV= 4          ZSTREQU 
*MEXIT #=  1559 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_135_2
*MEXIT #=  1558 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1560 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1560 LV= 3 WTO
*MCALL #=  1561 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1561 LV= 3 ABEND
*MCALL #=  1562 LV= 3          ENDIF 
*MCALL #=  1563 LV= 4          ZSTREQU 
*MEXIT #=  1563 LV= 4 ZSTREQU
#@IF_135_2                                               DS 0H
*MEXIT #=  1562 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1564 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1564 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'-2'
*MCALL #=  1565 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1566 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1566 LV= 4 ZCALL
*MEXIT #=  1565 LV= 3 CALL
*MCALL #=  1567 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1567 LV= 3 WTO
*MCALL #=  1568 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1569 LV= 4          ZSTREQU 
*MEXIT #=  1569 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_136_2
*MEXIT #=  1568 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1570 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1570 LV= 3 WTO
*MCALL #=  1571 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1571 LV= 3 ABEND
*MCALL #=  1572 LV= 3          ENDIF 
*MCALL #=  1573 LV= 4          ZSTREQU 
*MEXIT #=  1573 LV= 4 ZSTREQU
#@IF_136_2                                               DS 0H
*MEXIT #=  1572 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EB'-2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EB'-2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1574 LV= 3          RT1   CCE
         DS    0H
RT1_TEST94       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE94
         LTORG 
RT1_CCE94       DS 0H
*MEXIT #=  1574 LV= 3 RT1
         B     EXIT68
         LTORG 
EXIT68      DS 0H
*MEXIT #=  1553 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  1575 LV= 2          TEST1 SVC,EB,=EB'-2'
         BASR  R12,0
         USING *,R12
*MCALL #=  1576 LV= 3          CTD   CTD_EB,IN==EB'-2',OUT=DECIMAL,LINKX
               AGE=SVC
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'-2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1576 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'-2'
         LA    R3,L'=EB'-2'
*MCALL #=  1577 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1578 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1578 LV= 4 ZCALL
*MEXIT #=  1577 LV= 3 CALL
*MCALL #=  1579 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1579 LV= 3 WTO
*MCALL #=  1580 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1581 LV= 4          ZSTREQU 
*MEXIT #=  1581 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_137_2
*MEXIT #=  1580 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1582 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1582 LV= 3 WTO
*MCALL #=  1583 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1583 LV= 3 ABEND
*MCALL #=  1584 LV= 3          ENDIF 
*MCALL #=  1585 LV= 4          ZSTREQU 
*MEXIT #=  1585 LV= 4 ZSTREQU
#@IF_137_2                                               DS 0H
*MEXIT #=  1584 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1586 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1586 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'-2'
*MCALL #=  1587 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1588 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1588 LV= 4 ZCALL
*MEXIT #=  1587 LV= 3 CALL
*MCALL #=  1589 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1589 LV= 3 WTO
*MCALL #=  1590 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1591 LV= 4          ZSTREQU 
*MEXIT #=  1591 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_138_2
*MEXIT #=  1590 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1592 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1592 LV= 3 WTO
*MCALL #=  1593 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1593 LV= 3 ABEND
*MCALL #=  1594 LV= 3          ENDIF 
*MCALL #=  1595 LV= 4          ZSTREQU 
*MEXIT #=  1595 LV= 4 ZSTREQU
#@IF_138_2                                               DS 0H
*MEXIT #=  1594 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EB'-2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EB'-2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1596 LV= 3          RT1   CCE
         DS    0H
RT1_TEST95       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE95
         LTORG 
RT1_CCE95       DS 0H
*MEXIT #=  1596 LV= 3 RT1
         B     EXIT69
         LTORG 
EXIT69      DS 0H
*MEXIT #=  1575 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  1597 LV= 2          RT1   CCE
         DS    0H
RT1_TEST96       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE96
         LTORG 
RT1_CCE96       DS 0H
*MEXIT #=  1597 LV= 2 RT1
*MEXIT #=  1552 LV= 1 TEST
*MCALL #=  1598 LV= 1          TEST   EB,=EB'-1E2'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  1599 LV= 2          TEST1 MF,EB,=EB'-1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=  1600 LV= 3          CTD   CTD_EB,IN==EB'-1E2',OUT=DECIMAL,LIX
               NKAGE=MF
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'-1E2'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1600 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'-1E2'
         LA    R3,L'=EB'-1E2'
*MCALL #=  1601 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1602 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1602 LV= 4 ZCALL
*MEXIT #=  1601 LV= 3 CALL
*MCALL #=  1603 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1603 LV= 3 WTO
*MCALL #=  1604 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1605 LV= 4          ZSTREQU 
*MEXIT #=  1605 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_139_2
*MEXIT #=  1604 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1606 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1606 LV= 3 WTO
*MCALL #=  1607 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1607 LV= 3 ABEND
*MCALL #=  1608 LV= 3          ENDIF 
*MCALL #=  1609 LV= 4          ZSTREQU 
*MEXIT #=  1609 LV= 4 ZSTREQU
#@IF_139_2                                               DS 0H
*MEXIT #=  1608 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1610 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1610 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'-1E2'
*MCALL #=  1611 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1612 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1612 LV= 4 ZCALL
*MEXIT #=  1611 LV= 3 CALL
*MCALL #=  1613 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1613 LV= 3 WTO
*MCALL #=  1614 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1615 LV= 4          ZSTREQU 
*MEXIT #=  1615 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_140_2
*MEXIT #=  1614 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1616 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1616 LV= 3 WTO
*MCALL #=  1617 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1617 LV= 3 ABEND
*MCALL #=  1618 LV= 3          ENDIF 
*MCALL #=  1619 LV= 4          ZSTREQU 
*MEXIT #=  1619 LV= 4 ZSTREQU
#@IF_140_2                                               DS 0H
*MEXIT #=  1618 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EB'-1E2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EB'-1E2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1620 LV= 3          RT1   CCE
         DS    0H
RT1_TEST97       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE97
         LTORG 
RT1_CCE97       DS 0H
*MEXIT #=  1620 LV= 3 RT1
         B     EXIT70
         LTORG 
EXIT70      DS 0H
*MEXIT #=  1599 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  1621 LV= 2          TEST1 SVC,EB,=EB'-1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=  1622 LV= 3          CTD   CTD_EB,IN==EB'-1E2',OUT=DECIMAL,LIX
               NKAGE=SVC
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'-1E2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1622 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'-1E2'
         LA    R3,L'=EB'-1E2'
*MCALL #=  1623 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1624 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1624 LV= 4 ZCALL
*MEXIT #=  1623 LV= 3 CALL
*MCALL #=  1625 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1625 LV= 3 WTO
*MCALL #=  1626 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1627 LV= 4          ZSTREQU 
*MEXIT #=  1627 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_141_2
*MEXIT #=  1626 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1628 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1628 LV= 3 WTO
*MCALL #=  1629 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1629 LV= 3 ABEND
*MCALL #=  1630 LV= 3          ENDIF 
*MCALL #=  1631 LV= 4          ZSTREQU 
*MEXIT #=  1631 LV= 4 ZSTREQU
#@IF_141_2                                               DS 0H
*MEXIT #=  1630 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1632 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1632 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'-1E2'
*MCALL #=  1633 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1634 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1634 LV= 4 ZCALL
*MEXIT #=  1633 LV= 3 CALL
*MCALL #=  1635 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1635 LV= 3 WTO
*MCALL #=  1636 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1637 LV= 4          ZSTREQU 
*MEXIT #=  1637 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_142_2
*MEXIT #=  1636 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1638 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1638 LV= 3 WTO
*MCALL #=  1639 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1639 LV= 3 ABEND
*MCALL #=  1640 LV= 3          ENDIF 
*MCALL #=  1641 LV= 4          ZSTREQU 
*MEXIT #=  1641 LV= 4 ZSTREQU
#@IF_142_2                                               DS 0H
*MEXIT #=  1640 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EB'-1E2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EB'-1E2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  1642 LV= 3          RT1   CCE
         DS    0H
RT1_TEST98       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE98
         LTORG 
RT1_CCE98       DS 0H
*MEXIT #=  1642 LV= 3 RT1
         B     EXIT71
         LTORG 
EXIT71      DS 0H
*MEXIT #=  1621 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  1643 LV= 2          RT1   CCE
         DS    0H
RT1_TEST99       BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE99
         LTORG 
RT1_CCE99       DS 0H
*MEXIT #=  1643 LV= 2 RT1
*MEXIT #=  1598 LV= 1 TEST
* ED
*MCALL #=  1644 LV= 1          TEST   ED,=ED'0'
*MCALL #=  1645 LV= 2          TEST1 SVC,ED,=ED'0'
         BASR  R12,0
         USING *,R12
*MCALL #=  1646 LV= 3          CTD   CTD_ED,IN==ED'0',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_ED,0,DECIMAL)
         LA    0,=ED'0'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1646 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D ED'
         MVC   DHEX,=CL32' '
         LA    R2,=ED'0'
         LA    R3,L'=ED'0'
*MCALL #=  1647 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1648 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1648 LV= 4 ZCALL
*MEXIT #=  1647 LV= 3 CALL
*MCALL #=  1649 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1649 LV= 3 WTO
*MCALL #=  1650 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1651 LV= 4          ZSTREQU 
*MEXIT #=  1651 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_143_2
*MEXIT #=  1650 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1652 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1652 LV= 3 WTO
*MCALL #=  1653 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1653 LV= 3 ABEND
*MCALL #=  1654 LV= 3          ENDIF 
*MCALL #=  1655 LV= 4          ZSTREQU 
*MEXIT #=  1655 LV= 4 ZSTREQU
#@IF_143_2                                               DS 0H
*MEXIT #=  1654 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1656 LV= 3          CFD   CFD_ED,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_ED,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1656 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D ED'
         MVC   DHEX,=CL32' '
         LA    R3,L'=ED'0'
*MCALL #=  1657 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1658 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1658 LV= 4 ZCALL
*MEXIT #=  1657 LV= 3 CALL
*MCALL #=  1659 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1659 LV= 3 WTO
*MCALL #=  1660 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1661 LV= 4          ZSTREQU 
*MEXIT #=  1661 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_144_2
*MEXIT #=  1660 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1662 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1662 LV= 3 WTO
*MCALL #=  1663 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1663 LV= 3 ABEND
*MCALL #=  1664 LV= 3          ENDIF 
*MCALL #=  1665 LV= 4          ZSTREQU 
*MEXIT #=  1665 LV= 4 ZSTREQU
#@IF_144_2                                               DS 0H
*MEXIT #=  1664 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LE    R0,=ED'0'
         LDETR R0,R0,0
         LE    R1,WORK16
         LDETR R1,R1,0
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  1666 LV= 3          RT1   CCE
         DS    0H
RT1_TEST100      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE100
         LTORG 
RT1_CCE100      DS 0H
*MEXIT #=  1666 LV= 3 RT1
         B     EXIT72
         LTORG 
EXIT72      DS 0H
*MEXIT #=  1645 LV= 2 TEST1
*MEXIT #=  1644 LV= 1 TEST
*MCALL #=  1667 LV= 1          TEST   ED,=ED'0.1234567'
*MCALL #=  1668 LV= 2          TEST1 SVC,ED,=ED'0.1234567'
         BASR  R12,0
         USING *,R12
*MCALL #=  1669 LV= 3          CTD   CTD_ED,IN==ED'0.1234567',OUT=DECIMX
               AL,LINKAGE=SVC
         LA    1,=A(CTD_ED,0,DECIMAL)
         LA    0,=ED'0.1234567'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1669 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D ED'
         MVC   DHEX,=CL32' '
         LA    R2,=ED'0.1234567'
         LA    R3,L'=ED'0.1234567'
*MCALL #=  1670 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1671 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1671 LV= 4 ZCALL
*MEXIT #=  1670 LV= 3 CALL
*MCALL #=  1672 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1672 LV= 3 WTO
*MCALL #=  1673 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1674 LV= 4          ZSTREQU 
*MEXIT #=  1674 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_145_2
*MEXIT #=  1673 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1675 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1675 LV= 3 WTO
*MCALL #=  1676 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1676 LV= 3 ABEND
*MCALL #=  1677 LV= 3          ENDIF 
*MCALL #=  1678 LV= 4          ZSTREQU 
*MEXIT #=  1678 LV= 4 ZSTREQU
#@IF_145_2                                               DS 0H
*MEXIT #=  1677 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1679 LV= 3          CFD   CFD_ED,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_ED,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1679 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D ED'
         MVC   DHEX,=CL32' '
         LA    R3,L'=ED'0.1234567'
*MCALL #=  1680 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1681 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1681 LV= 4 ZCALL
*MEXIT #=  1680 LV= 3 CALL
*MCALL #=  1682 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1682 LV= 3 WTO
*MCALL #=  1683 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1684 LV= 4          ZSTREQU 
*MEXIT #=  1684 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_146_2
*MEXIT #=  1683 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1685 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1685 LV= 3 WTO
*MCALL #=  1686 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1686 LV= 3 ABEND
*MCALL #=  1687 LV= 3          ENDIF 
*MCALL #=  1688 LV= 4          ZSTREQU 
*MEXIT #=  1688 LV= 4 ZSTREQU
#@IF_146_2                                               DS 0H
*MEXIT #=  1687 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LE    R0,=ED'0.1234567'
         LDETR R0,R0,0
         LE    R1,WORK16
         LDETR R1,R1,0
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  1689 LV= 3          RT1   CCE
         DS    0H
RT1_TEST101      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE101
         LTORG 
RT1_CCE101      DS 0H
*MEXIT #=  1689 LV= 3 RT1
         B     EXIT73
         LTORG 
EXIT73      DS 0H
*MEXIT #=  1668 LV= 2 TEST1
*MEXIT #=  1667 LV= 1 TEST
*MCALL #=  1690 LV= 1          TEST   ED,=ED'0.12345670'
*MCALL #=  1691 LV= 2          TEST1 SVC,ED,=ED'0.12345670'
         BASR  R12,0
         USING *,R12
*MCALL #=  1692 LV= 3          CTD   CTD_ED,IN==ED'0.12345670',OUT=DECIX
               MAL,LINKAGE=SVC
         LA    1,=A(CTD_ED,0,DECIMAL)
         LA    0,=ED'0.12345670'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1692 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D ED'
         MVC   DHEX,=CL32' '
         LA    R2,=ED'0.12345670'
         LA    R3,L'=ED'0.12345670'
*MCALL #=  1693 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1694 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1694 LV= 4 ZCALL
*MEXIT #=  1693 LV= 3 CALL
*MCALL #=  1695 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1695 LV= 3 WTO
*MCALL #=  1696 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1697 LV= 4          ZSTREQU 
*MEXIT #=  1697 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_147_2
*MEXIT #=  1696 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1698 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1698 LV= 3 WTO
*MCALL #=  1699 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1699 LV= 3 ABEND
*MCALL #=  1700 LV= 3          ENDIF 
*MCALL #=  1701 LV= 4          ZSTREQU 
*MEXIT #=  1701 LV= 4 ZSTREQU
#@IF_147_2                                               DS 0H
*MEXIT #=  1700 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1702 LV= 3          CFD   CFD_ED,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_ED,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1702 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D ED'
         MVC   DHEX,=CL32' '
         LA    R3,L'=ED'0.12345670'
*MCALL #=  1703 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1704 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1704 LV= 4 ZCALL
*MEXIT #=  1703 LV= 3 CALL
*MCALL #=  1705 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1705 LV= 3 WTO
*MCALL #=  1706 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1707 LV= 4          ZSTREQU 
*MEXIT #=  1707 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_148_2
*MEXIT #=  1706 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1708 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1708 LV= 3 WTO
*MCALL #=  1709 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1709 LV= 3 ABEND
*MCALL #=  1710 LV= 3          ENDIF 
*MCALL #=  1711 LV= 4          ZSTREQU 
*MEXIT #=  1711 LV= 4 ZSTREQU
#@IF_148_2                                               DS 0H
*MEXIT #=  1710 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LE    R0,=ED'0.12345670'
         LDETR R0,R0,0
         LE    R1,WORK16
         LDETR R1,R1,0
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  1712 LV= 3          RT1   CCE
         DS    0H
RT1_TEST102      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE102
         LTORG 
RT1_CCE102      DS 0H
*MEXIT #=  1712 LV= 3 RT1
         B     EXIT74
         LTORG 
EXIT74      DS 0H
*MEXIT #=  1691 LV= 2 TEST1
*MEXIT #=  1690 LV= 1 TEST
*MCALL #=  1713 LV= 1          TEST   ED,=ED'1E-101'
*MCALL #=  1714 LV= 2          TEST1 SVC,ED,=ED'1E-101'
         BASR  R12,0
         USING *,R12
*MCALL #=  1715 LV= 3          CTD   CTD_ED,IN==ED'1E-101',OUT=DECIMAL,X
               LINKAGE=SVC
         LA    1,=A(CTD_ED,0,DECIMAL)
         LA    0,=ED'1E-101'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1715 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D ED'
         MVC   DHEX,=CL32' '
         LA    R2,=ED'1E-101'
         LA    R3,L'=ED'1E-101'
*MCALL #=  1716 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1717 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1717 LV= 4 ZCALL
*MEXIT #=  1716 LV= 3 CALL
*MCALL #=  1718 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1718 LV= 3 WTO
*MCALL #=  1719 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1720 LV= 4          ZSTREQU 
*MEXIT #=  1720 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_149_2
*MEXIT #=  1719 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1721 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1721 LV= 3 WTO
*MCALL #=  1722 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1722 LV= 3 ABEND
*MCALL #=  1723 LV= 3          ENDIF 
*MCALL #=  1724 LV= 4          ZSTREQU 
*MEXIT #=  1724 LV= 4 ZSTREQU
#@IF_149_2                                               DS 0H
*MEXIT #=  1723 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1725 LV= 3          CFD   CFD_ED,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_ED,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1725 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D ED'
         MVC   DHEX,=CL32' '
         LA    R3,L'=ED'1E-101'
*MCALL #=  1726 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1727 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1727 LV= 4 ZCALL
*MEXIT #=  1726 LV= 3 CALL
*MCALL #=  1728 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1728 LV= 3 WTO
*MCALL #=  1729 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1730 LV= 4          ZSTREQU 
*MEXIT #=  1730 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_150_2
*MEXIT #=  1729 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1731 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1731 LV= 3 WTO
*MCALL #=  1732 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1732 LV= 3 ABEND
*MCALL #=  1733 LV= 3          ENDIF 
*MCALL #=  1734 LV= 4          ZSTREQU 
*MEXIT #=  1734 LV= 4 ZSTREQU
#@IF_150_2                                               DS 0H
*MEXIT #=  1733 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LE    R0,=ED'1E-101'
         LDETR R0,R0,0
         LE    R1,WORK16
         LDETR R1,R1,0
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  1735 LV= 3          RT1   CCE
         DS    0H
RT1_TEST103      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE103
         LTORG 
RT1_CCE103      DS 0H
*MEXIT #=  1735 LV= 3 RT1
         B     EXIT75
         LTORG 
EXIT75      DS 0H
*MEXIT #=  1714 LV= 2 TEST1
*MEXIT #=  1713 LV= 1 TEST
*MCALL #=  1736 LV= 1          TEST   ED,=ED'1'
*MCALL #=  1737 LV= 2          TEST1 SVC,ED,=ED'1'
         BASR  R12,0
         USING *,R12
*MCALL #=  1738 LV= 3          CTD   CTD_ED,IN==ED'1',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_ED,0,DECIMAL)
         LA    0,=ED'1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1738 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D ED'
         MVC   DHEX,=CL32' '
         LA    R2,=ED'1'
         LA    R3,L'=ED'1'
*MCALL #=  1739 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1740 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1740 LV= 4 ZCALL
*MEXIT #=  1739 LV= 3 CALL
*MCALL #=  1741 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1741 LV= 3 WTO
*MCALL #=  1742 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1743 LV= 4          ZSTREQU 
*MEXIT #=  1743 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_151_2
*MEXIT #=  1742 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1744 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1744 LV= 3 WTO
*MCALL #=  1745 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1745 LV= 3 ABEND
*MCALL #=  1746 LV= 3          ENDIF 
*MCALL #=  1747 LV= 4          ZSTREQU 
*MEXIT #=  1747 LV= 4 ZSTREQU
#@IF_151_2                                               DS 0H
*MEXIT #=  1746 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1748 LV= 3          CFD   CFD_ED,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_ED,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1748 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D ED'
         MVC   DHEX,=CL32' '
         LA    R3,L'=ED'1'
*MCALL #=  1749 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1750 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1750 LV= 4 ZCALL
*MEXIT #=  1749 LV= 3 CALL
*MCALL #=  1751 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1751 LV= 3 WTO
*MCALL #=  1752 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1753 LV= 4          ZSTREQU 
*MEXIT #=  1753 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_152_2
*MEXIT #=  1752 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1754 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1754 LV= 3 WTO
*MCALL #=  1755 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1755 LV= 3 ABEND
*MCALL #=  1756 LV= 3          ENDIF 
*MCALL #=  1757 LV= 4          ZSTREQU 
*MEXIT #=  1757 LV= 4 ZSTREQU
#@IF_152_2                                               DS 0H
*MEXIT #=  1756 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LE    R0,=ED'1'
         LDETR R0,R0,0
         LE    R1,WORK16
         LDETR R1,R1,0
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  1758 LV= 3          RT1   CCE
         DS    0H
RT1_TEST104      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE104
         LTORG 
RT1_CCE104      DS 0H
*MEXIT #=  1758 LV= 3 RT1
         B     EXIT76
         LTORG 
EXIT76      DS 0H
*MEXIT #=  1737 LV= 2 TEST1
*MEXIT #=  1736 LV= 1 TEST
*MCALL #=  1759 LV= 1          TEST   ED,=ED'2'
*MCALL #=  1760 LV= 2          TEST1 SVC,ED,=ED'2'
         BASR  R12,0
         USING *,R12
*MCALL #=  1761 LV= 3          CTD   CTD_ED,IN==ED'2',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_ED,0,DECIMAL)
         LA    0,=ED'2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1761 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D ED'
         MVC   DHEX,=CL32' '
         LA    R2,=ED'2'
         LA    R3,L'=ED'2'
*MCALL #=  1762 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1763 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1763 LV= 4 ZCALL
*MEXIT #=  1762 LV= 3 CALL
*MCALL #=  1764 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1764 LV= 3 WTO
*MCALL #=  1765 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1766 LV= 4          ZSTREQU 
*MEXIT #=  1766 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_153_2
*MEXIT #=  1765 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1767 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1767 LV= 3 WTO
*MCALL #=  1768 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1768 LV= 3 ABEND
*MCALL #=  1769 LV= 3          ENDIF 
*MCALL #=  1770 LV= 4          ZSTREQU 
*MEXIT #=  1770 LV= 4 ZSTREQU
#@IF_153_2                                               DS 0H
*MEXIT #=  1769 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1771 LV= 3          CFD   CFD_ED,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_ED,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1771 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D ED'
         MVC   DHEX,=CL32' '
         LA    R3,L'=ED'2'
*MCALL #=  1772 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1773 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1773 LV= 4 ZCALL
*MEXIT #=  1772 LV= 3 CALL
*MCALL #=  1774 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1774 LV= 3 WTO
*MCALL #=  1775 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1776 LV= 4          ZSTREQU 
*MEXIT #=  1776 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_154_2
*MEXIT #=  1775 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1777 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1777 LV= 3 WTO
*MCALL #=  1778 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1778 LV= 3 ABEND
*MCALL #=  1779 LV= 3          ENDIF 
*MCALL #=  1780 LV= 4          ZSTREQU 
*MEXIT #=  1780 LV= 4 ZSTREQU
#@IF_154_2                                               DS 0H
*MEXIT #=  1779 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LE    R0,=ED'2'
         LDETR R0,R0,0
         LE    R1,WORK16
         LDETR R1,R1,0
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  1781 LV= 3          RT1   CCE
         DS    0H
RT1_TEST105      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE105
         LTORG 
RT1_CCE105      DS 0H
*MEXIT #=  1781 LV= 3 RT1
         B     EXIT77
         LTORG 
EXIT77      DS 0H
*MEXIT #=  1760 LV= 2 TEST1
*MEXIT #=  1759 LV= 1 TEST
*MCALL #=  1782 LV= 1          TEST   ED,=ED'3'
*MCALL #=  1783 LV= 2          TEST1 SVC,ED,=ED'3'
         BASR  R12,0
         USING *,R12
*MCALL #=  1784 LV= 3          CTD   CTD_ED,IN==ED'3',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_ED,0,DECIMAL)
         LA    0,=ED'3'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1784 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D ED'
         MVC   DHEX,=CL32' '
         LA    R2,=ED'3'
         LA    R3,L'=ED'3'
*MCALL #=  1785 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1786 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1786 LV= 4 ZCALL
*MEXIT #=  1785 LV= 3 CALL
*MCALL #=  1787 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1787 LV= 3 WTO
*MCALL #=  1788 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1789 LV= 4          ZSTREQU 
*MEXIT #=  1789 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_155_2
*MEXIT #=  1788 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1790 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1790 LV= 3 WTO
*MCALL #=  1791 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1791 LV= 3 ABEND
*MCALL #=  1792 LV= 3          ENDIF 
*MCALL #=  1793 LV= 4          ZSTREQU 
*MEXIT #=  1793 LV= 4 ZSTREQU
#@IF_155_2                                               DS 0H
*MEXIT #=  1792 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1794 LV= 3          CFD   CFD_ED,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_ED,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1794 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D ED'
         MVC   DHEX,=CL32' '
         LA    R3,L'=ED'3'
*MCALL #=  1795 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1796 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1796 LV= 4 ZCALL
*MEXIT #=  1795 LV= 3 CALL
*MCALL #=  1797 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1797 LV= 3 WTO
*MCALL #=  1798 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1799 LV= 4          ZSTREQU 
*MEXIT #=  1799 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_156_2
*MEXIT #=  1798 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1800 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1800 LV= 3 WTO
*MCALL #=  1801 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1801 LV= 3 ABEND
*MCALL #=  1802 LV= 3          ENDIF 
*MCALL #=  1803 LV= 4          ZSTREQU 
*MEXIT #=  1803 LV= 4 ZSTREQU
#@IF_156_2                                               DS 0H
*MEXIT #=  1802 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LE    R0,=ED'3'
         LDETR R0,R0,0
         LE    R1,WORK16
         LDETR R1,R1,0
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  1804 LV= 3          RT1   CCE
         DS    0H
RT1_TEST106      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE106
         LTORG 
RT1_CCE106      DS 0H
*MEXIT #=  1804 LV= 3 RT1
         B     EXIT78
         LTORG 
EXIT78      DS 0H
*MEXIT #=  1783 LV= 2 TEST1
*MEXIT #=  1782 LV= 1 TEST
*MCALL #=  1805 LV= 1          TEST   ED,=ED'1E2'
*MCALL #=  1806 LV= 2          TEST1 SVC,ED,=ED'1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=  1807 LV= 3          CTD   CTD_ED,IN==ED'1E2',OUT=DECIMAL,LINX
               KAGE=SVC
         LA    1,=A(CTD_ED,0,DECIMAL)
         LA    0,=ED'1E2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1807 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D ED'
         MVC   DHEX,=CL32' '
         LA    R2,=ED'1E2'
         LA    R3,L'=ED'1E2'
*MCALL #=  1808 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1809 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1809 LV= 4 ZCALL
*MEXIT #=  1808 LV= 3 CALL
*MCALL #=  1810 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1810 LV= 3 WTO
*MCALL #=  1811 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1812 LV= 4          ZSTREQU 
*MEXIT #=  1812 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_157_2
*MEXIT #=  1811 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1813 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1813 LV= 3 WTO
*MCALL #=  1814 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1814 LV= 3 ABEND
*MCALL #=  1815 LV= 3          ENDIF 
*MCALL #=  1816 LV= 4          ZSTREQU 
*MEXIT #=  1816 LV= 4 ZSTREQU
#@IF_157_2                                               DS 0H
*MEXIT #=  1815 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1817 LV= 3          CFD   CFD_ED,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_ED,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1817 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D ED'
         MVC   DHEX,=CL32' '
         LA    R3,L'=ED'1E2'
*MCALL #=  1818 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1819 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1819 LV= 4 ZCALL
*MEXIT #=  1818 LV= 3 CALL
*MCALL #=  1820 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1820 LV= 3 WTO
*MCALL #=  1821 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1822 LV= 4          ZSTREQU 
*MEXIT #=  1822 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_158_2
*MEXIT #=  1821 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1823 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1823 LV= 3 WTO
*MCALL #=  1824 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1824 LV= 3 ABEND
*MCALL #=  1825 LV= 3          ENDIF 
*MCALL #=  1826 LV= 4          ZSTREQU 
*MEXIT #=  1826 LV= 4 ZSTREQU
#@IF_158_2                                               DS 0H
*MEXIT #=  1825 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LE    R0,=ED'1E2'
         LDETR R0,R0,0
         LE    R1,WORK16
         LDETR R1,R1,0
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  1827 LV= 3          RT1   CCE
         DS    0H
RT1_TEST107      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE107
         LTORG 
RT1_CCE107      DS 0H
*MEXIT #=  1827 LV= 3 RT1
         B     EXIT79
         LTORG 
EXIT79      DS 0H
*MEXIT #=  1806 LV= 2 TEST1
*MEXIT #=  1805 LV= 1 TEST
*MCALL #=  1828 LV= 1          TEST   ED,=ED'1234567'
*MCALL #=  1829 LV= 2          TEST1 SVC,ED,=ED'1234567'
         BASR  R12,0
         USING *,R12
*MCALL #=  1830 LV= 3          CTD   CTD_ED,IN==ED'1234567',OUT=DECIMALX
               ,LINKAGE=SVC
         LA    1,=A(CTD_ED,0,DECIMAL)
         LA    0,=ED'1234567'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1830 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D ED'
         MVC   DHEX,=CL32' '
         LA    R2,=ED'1234567'
         LA    R3,L'=ED'1234567'
*MCALL #=  1831 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1832 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1832 LV= 4 ZCALL
*MEXIT #=  1831 LV= 3 CALL
*MCALL #=  1833 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1833 LV= 3 WTO
*MCALL #=  1834 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1835 LV= 4          ZSTREQU 
*MEXIT #=  1835 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_159_2
*MEXIT #=  1834 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1836 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1836 LV= 3 WTO
*MCALL #=  1837 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1837 LV= 3 ABEND
*MCALL #=  1838 LV= 3          ENDIF 
*MCALL #=  1839 LV= 4          ZSTREQU 
*MEXIT #=  1839 LV= 4 ZSTREQU
#@IF_159_2                                               DS 0H
*MEXIT #=  1838 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1840 LV= 3          CFD   CFD_ED,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_ED,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1840 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D ED'
         MVC   DHEX,=CL32' '
         LA    R3,L'=ED'1234567'
*MCALL #=  1841 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1842 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1842 LV= 4 ZCALL
*MEXIT #=  1841 LV= 3 CALL
*MCALL #=  1843 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1843 LV= 3 WTO
*MCALL #=  1844 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1845 LV= 4          ZSTREQU 
*MEXIT #=  1845 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_160_2
*MEXIT #=  1844 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1846 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1846 LV= 3 WTO
*MCALL #=  1847 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1847 LV= 3 ABEND
*MCALL #=  1848 LV= 3          ENDIF 
*MCALL #=  1849 LV= 4          ZSTREQU 
*MEXIT #=  1849 LV= 4 ZSTREQU
#@IF_160_2                                               DS 0H
*MEXIT #=  1848 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LE    R0,=ED'1234567'
         LDETR R0,R0,0
         LE    R1,WORK16
         LDETR R1,R1,0
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  1850 LV= 3          RT1   CCE
         DS    0H
RT1_TEST108      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE108
         LTORG 
RT1_CCE108      DS 0H
*MEXIT #=  1850 LV= 3 RT1
         B     EXIT80
         LTORG 
EXIT80      DS 0H
*MEXIT #=  1829 LV= 2 TEST1
*MEXIT #=  1828 LV= 1 TEST
*MCALL #=  1851 LV= 1          TEST   ED,=ED'1.234567E6'
*MCALL #=  1852 LV= 2          TEST1 SVC,ED,=ED'1.234567E6'
         BASR  R12,0
         USING *,R12
*MCALL #=  1853 LV= 3          CTD   CTD_ED,IN==ED'1.234567E6',OUT=DECIX
               MAL,LINKAGE=SVC
         LA    1,=A(CTD_ED,0,DECIMAL)
         LA    0,=ED'1.234567E6'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1853 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D ED'
         MVC   DHEX,=CL32' '
         LA    R2,=ED'1.234567E6'
         LA    R3,L'=ED'1.234567E6'
*MCALL #=  1854 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1855 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1855 LV= 4 ZCALL
*MEXIT #=  1854 LV= 3 CALL
*MCALL #=  1856 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1856 LV= 3 WTO
*MCALL #=  1857 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1858 LV= 4          ZSTREQU 
*MEXIT #=  1858 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_161_2
*MEXIT #=  1857 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1859 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1859 LV= 3 WTO
*MCALL #=  1860 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1860 LV= 3 ABEND
*MCALL #=  1861 LV= 3          ENDIF 
*MCALL #=  1862 LV= 4          ZSTREQU 
*MEXIT #=  1862 LV= 4 ZSTREQU
#@IF_161_2                                               DS 0H
*MEXIT #=  1861 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1863 LV= 3          CFD   CFD_ED,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_ED,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1863 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D ED'
         MVC   DHEX,=CL32' '
         LA    R3,L'=ED'1.234567E6'
*MCALL #=  1864 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1865 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1865 LV= 4 ZCALL
*MEXIT #=  1864 LV= 3 CALL
*MCALL #=  1866 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1866 LV= 3 WTO
*MCALL #=  1867 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1868 LV= 4          ZSTREQU 
*MEXIT #=  1868 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_162_2
*MEXIT #=  1867 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1869 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1869 LV= 3 WTO
*MCALL #=  1870 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1870 LV= 3 ABEND
*MCALL #=  1871 LV= 3          ENDIF 
*MCALL #=  1872 LV= 4          ZSTREQU 
*MEXIT #=  1872 LV= 4 ZSTREQU
#@IF_162_2                                               DS 0H
*MEXIT #=  1871 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LE    R0,=ED'1.234567E6'
         LDETR R0,R0,0
         LE    R1,WORK16
         LDETR R1,R1,0
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  1873 LV= 3          RT1   CCE
         DS    0H
RT1_TEST109      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE109
         LTORG 
RT1_CCE109      DS 0H
*MEXIT #=  1873 LV= 3 RT1
         B     EXIT81
         LTORG 
EXIT81      DS 0H
*MEXIT #=  1852 LV= 2 TEST1
*MEXIT #=  1851 LV= 1 TEST
*MCALL #=  1874 LV= 1          TEST   ED,=ED'1234567E90'
*MCALL #=  1875 LV= 2          TEST1 SVC,ED,=ED'1234567E90'
         BASR  R12,0
         USING *,R12
*MCALL #=  1876 LV= 3          CTD   CTD_ED,IN==ED'1234567E90',OUT=DECIX
               MAL,LINKAGE=SVC
         LA    1,=A(CTD_ED,0,DECIMAL)
         LA    0,=ED'1234567E90'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1876 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D ED'
         MVC   DHEX,=CL32' '
         LA    R2,=ED'1234567E90'
         LA    R3,L'=ED'1234567E90'
*MCALL #=  1877 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1878 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1878 LV= 4 ZCALL
*MEXIT #=  1877 LV= 3 CALL
*MCALL #=  1879 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1879 LV= 3 WTO
*MCALL #=  1880 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1881 LV= 4          ZSTREQU 
*MEXIT #=  1881 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_163_2
*MEXIT #=  1880 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1882 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1882 LV= 3 WTO
*MCALL #=  1883 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1883 LV= 3 ABEND
*MCALL #=  1884 LV= 3          ENDIF 
*MCALL #=  1885 LV= 4          ZSTREQU 
*MEXIT #=  1885 LV= 4 ZSTREQU
#@IF_163_2                                               DS 0H
*MEXIT #=  1884 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1886 LV= 3          CFD   CFD_ED,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_ED,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1886 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D ED'
         MVC   DHEX,=CL32' '
         LA    R3,L'=ED'1234567E90'
*MCALL #=  1887 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1888 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1888 LV= 4 ZCALL
*MEXIT #=  1887 LV= 3 CALL
*MCALL #=  1889 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1889 LV= 3 WTO
*MCALL #=  1890 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1891 LV= 4          ZSTREQU 
*MEXIT #=  1891 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_164_2
*MEXIT #=  1890 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1892 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1892 LV= 3 WTO
*MCALL #=  1893 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1893 LV= 3 ABEND
*MCALL #=  1894 LV= 3          ENDIF 
*MCALL #=  1895 LV= 4          ZSTREQU 
*MEXIT #=  1895 LV= 4 ZSTREQU
#@IF_164_2                                               DS 0H
*MEXIT #=  1894 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LE    R0,=ED'1234567E90'
         LDETR R0,R0,0
         LE    R1,WORK16
         LDETR R1,R1,0
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  1896 LV= 3          RT1   CCE
         DS    0H
RT1_TEST110      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE110
         LTORG 
RT1_CCE110      DS 0H
*MEXIT #=  1896 LV= 3 RT1
         B     EXIT82
         LTORG 
EXIT82      DS 0H
*MEXIT #=  1875 LV= 2 TEST1
*MEXIT #=  1874 LV= 1 TEST
*MCALL #=  1897 LV= 1          TEST   ED,=ED'9999999E90'
*MCALL #=  1898 LV= 2          TEST1 SVC,ED,=ED'9999999E90'
         BASR  R12,0
         USING *,R12
*MCALL #=  1899 LV= 3          CTD   CTD_ED,IN==ED'9999999E90',OUT=DECIX
               MAL,LINKAGE=SVC
         LA    1,=A(CTD_ED,0,DECIMAL)
         LA    0,=ED'9999999E90'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1899 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D ED'
         MVC   DHEX,=CL32' '
         LA    R2,=ED'9999999E90'
         LA    R3,L'=ED'9999999E90'
*MCALL #=  1900 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1901 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1901 LV= 4 ZCALL
*MEXIT #=  1900 LV= 3 CALL
*MCALL #=  1902 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1902 LV= 3 WTO
*MCALL #=  1903 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1904 LV= 4          ZSTREQU 
*MEXIT #=  1904 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_165_2
*MEXIT #=  1903 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1905 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1905 LV= 3 WTO
*MCALL #=  1906 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1906 LV= 3 ABEND
*MCALL #=  1907 LV= 3          ENDIF 
*MCALL #=  1908 LV= 4          ZSTREQU 
*MEXIT #=  1908 LV= 4 ZSTREQU
#@IF_165_2                                               DS 0H
*MEXIT #=  1907 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1909 LV= 3          CFD   CFD_ED,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_ED,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1909 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D ED'
         MVC   DHEX,=CL32' '
         LA    R3,L'=ED'9999999E90'
*MCALL #=  1910 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1911 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1911 LV= 4 ZCALL
*MEXIT #=  1910 LV= 3 CALL
*MCALL #=  1912 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1912 LV= 3 WTO
*MCALL #=  1913 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1914 LV= 4          ZSTREQU 
*MEXIT #=  1914 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_166_2
*MEXIT #=  1913 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1915 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1915 LV= 3 WTO
*MCALL #=  1916 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1916 LV= 3 ABEND
*MCALL #=  1917 LV= 3          ENDIF 
*MCALL #=  1918 LV= 4          ZSTREQU 
*MEXIT #=  1918 LV= 4 ZSTREQU
#@IF_166_2                                               DS 0H
*MEXIT #=  1917 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LE    R0,=ED'9999999E90'
         LDETR R0,R0,0
         LE    R1,WORK16
         LDETR R1,R1,0
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  1919 LV= 3          RT1   CCE
         DS    0H
RT1_TEST111      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE111
         LTORG 
RT1_CCE111      DS 0H
*MEXIT #=  1919 LV= 3 RT1
         B     EXIT83
         LTORG 
EXIT83      DS 0H
*MEXIT #=  1898 LV= 2 TEST1
*MEXIT #=  1897 LV= 1 TEST
*MCALL #=  1920 LV= 1          TEST   ED,=ED'-1'
*MCALL #=  1921 LV= 2          TEST1 SVC,ED,=ED'-1'
         BASR  R12,0
         USING *,R12
*MCALL #=  1922 LV= 3          CTD   CTD_ED,IN==ED'-1',OUT=DECIMAL,LINKX
               AGE=SVC
         LA    1,=A(CTD_ED,0,DECIMAL)
         LA    0,=ED'-1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1922 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D ED'
         MVC   DHEX,=CL32' '
         LA    R2,=ED'-1'
         LA    R3,L'=ED'-1'
*MCALL #=  1923 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1924 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1924 LV= 4 ZCALL
*MEXIT #=  1923 LV= 3 CALL
*MCALL #=  1925 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1925 LV= 3 WTO
*MCALL #=  1926 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1927 LV= 4          ZSTREQU 
*MEXIT #=  1927 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_167_2
*MEXIT #=  1926 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1928 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1928 LV= 3 WTO
*MCALL #=  1929 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1929 LV= 3 ABEND
*MCALL #=  1930 LV= 3          ENDIF 
*MCALL #=  1931 LV= 4          ZSTREQU 
*MEXIT #=  1931 LV= 4 ZSTREQU
#@IF_167_2                                               DS 0H
*MEXIT #=  1930 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1932 LV= 3          CFD   CFD_ED,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_ED,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1932 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D ED'
         MVC   DHEX,=CL32' '
         LA    R3,L'=ED'-1'
*MCALL #=  1933 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1934 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1934 LV= 4 ZCALL
*MEXIT #=  1933 LV= 3 CALL
*MCALL #=  1935 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1935 LV= 3 WTO
*MCALL #=  1936 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1937 LV= 4          ZSTREQU 
*MEXIT #=  1937 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_168_2
*MEXIT #=  1936 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1938 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1938 LV= 3 WTO
*MCALL #=  1939 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1939 LV= 3 ABEND
*MCALL #=  1940 LV= 3          ENDIF 
*MCALL #=  1941 LV= 4          ZSTREQU 
*MEXIT #=  1941 LV= 4 ZSTREQU
#@IF_168_2                                               DS 0H
*MEXIT #=  1940 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LE    R0,=ED'-1'
         LDETR R0,R0,0
         LE    R1,WORK16
         LDETR R1,R1,0
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  1942 LV= 3          RT1   CCE
         DS    0H
RT1_TEST112      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE112
         LTORG 
RT1_CCE112      DS 0H
*MEXIT #=  1942 LV= 3 RT1
         B     EXIT84
         LTORG 
EXIT84      DS 0H
*MEXIT #=  1921 LV= 2 TEST1
*MEXIT #=  1920 LV= 1 TEST
*MCALL #=  1943 LV= 1          TEST   ED,=ED'-2'
*MCALL #=  1944 LV= 2          TEST1 SVC,ED,=ED'-2'
         BASR  R12,0
         USING *,R12
*MCALL #=  1945 LV= 3          CTD   CTD_ED,IN==ED'-2',OUT=DECIMAL,LINKX
               AGE=SVC
         LA    1,=A(CTD_ED,0,DECIMAL)
         LA    0,=ED'-2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1945 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D ED'
         MVC   DHEX,=CL32' '
         LA    R2,=ED'-2'
         LA    R3,L'=ED'-2'
*MCALL #=  1946 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1947 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1947 LV= 4 ZCALL
*MEXIT #=  1946 LV= 3 CALL
*MCALL #=  1948 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1948 LV= 3 WTO
*MCALL #=  1949 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1950 LV= 4          ZSTREQU 
*MEXIT #=  1950 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_169_2
*MEXIT #=  1949 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1951 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1951 LV= 3 WTO
*MCALL #=  1952 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1952 LV= 3 ABEND
*MCALL #=  1953 LV= 3          ENDIF 
*MCALL #=  1954 LV= 4          ZSTREQU 
*MEXIT #=  1954 LV= 4 ZSTREQU
#@IF_169_2                                               DS 0H
*MEXIT #=  1953 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1955 LV= 3          CFD   CFD_ED,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_ED,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1955 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D ED'
         MVC   DHEX,=CL32' '
         LA    R3,L'=ED'-2'
*MCALL #=  1956 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1957 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1957 LV= 4 ZCALL
*MEXIT #=  1956 LV= 3 CALL
*MCALL #=  1958 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1958 LV= 3 WTO
*MCALL #=  1959 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1960 LV= 4          ZSTREQU 
*MEXIT #=  1960 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_170_2
*MEXIT #=  1959 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1961 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1961 LV= 3 WTO
*MCALL #=  1962 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1962 LV= 3 ABEND
*MCALL #=  1963 LV= 3          ENDIF 
*MCALL #=  1964 LV= 4          ZSTREQU 
*MEXIT #=  1964 LV= 4 ZSTREQU
#@IF_170_2                                               DS 0H
*MEXIT #=  1963 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LE    R0,=ED'-2'
         LDETR R0,R0,0
         LE    R1,WORK16
         LDETR R1,R1,0
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  1965 LV= 3          RT1   CCE
         DS    0H
RT1_TEST113      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE113
         LTORG 
RT1_CCE113      DS 0H
*MEXIT #=  1965 LV= 3 RT1
         B     EXIT85
         LTORG 
EXIT85      DS 0H
*MEXIT #=  1944 LV= 2 TEST1
*MEXIT #=  1943 LV= 1 TEST
*MCALL #=  1966 LV= 1          TEST   ED,=ED'-1E2'
*MCALL #=  1967 LV= 2          TEST1 SVC,ED,=ED'-1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=  1968 LV= 3          CTD   CTD_ED,IN==ED'-1E2',OUT=DECIMAL,LIX
               NKAGE=SVC
         LA    1,=A(CTD_ED,0,DECIMAL)
         LA    0,=ED'-1E2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  1968 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D ED'
         MVC   DHEX,=CL32' '
         LA    R2,=ED'-1E2'
         LA    R3,L'=ED'-1E2'
*MCALL #=  1969 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1970 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1970 LV= 4 ZCALL
*MEXIT #=  1969 LV= 3 CALL
*MCALL #=  1971 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1971 LV= 3 WTO
*MCALL #=  1972 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1973 LV= 4          ZSTREQU 
*MEXIT #=  1973 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_171_2
*MEXIT #=  1972 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1974 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1974 LV= 3 WTO
*MCALL #=  1975 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1975 LV= 3 ABEND
*MCALL #=  1976 LV= 3          ENDIF 
*MCALL #=  1977 LV= 4          ZSTREQU 
*MEXIT #=  1977 LV= 4 ZSTREQU
#@IF_171_2                                               DS 0H
*MEXIT #=  1976 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  1978 LV= 3          CFD   CFD_ED,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_ED,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  1978 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D ED'
         MVC   DHEX,=CL32' '
         LA    R3,L'=ED'-1E2'
*MCALL #=  1979 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  1980 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1980 LV= 4 ZCALL
*MEXIT #=  1979 LV= 3 CALL
*MCALL #=  1981 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1981 LV= 3 WTO
*MCALL #=  1982 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1983 LV= 4          ZSTREQU 
*MEXIT #=  1983 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_172_2
*MEXIT #=  1982 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1984 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1984 LV= 3 WTO
*MCALL #=  1985 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1985 LV= 3 ABEND
*MCALL #=  1986 LV= 3          ENDIF 
*MCALL #=  1987 LV= 4          ZSTREQU 
*MEXIT #=  1987 LV= 4 ZSTREQU
#@IF_172_2                                               DS 0H
*MEXIT #=  1986 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LE    R0,=ED'-1E2'
         LDETR R0,R0,0
         LE    R1,WORK16
         LDETR R1,R1,0
         CDTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  1988 LV= 3          RT1   CCE
         DS    0H
RT1_TEST114      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE114
         LTORG 
RT1_CCE114      DS 0H
*MEXIT #=  1988 LV= 3 RT1
         B     EXIT86
         LTORG 
EXIT86      DS 0H
*MEXIT #=  1967 LV= 2 TEST1
*MEXIT #=  1966 LV= 1 TEST
* EH
*MCALL #=  1989 LV= 1          TEST   EH,=EH'0'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  1990 LV= 2          TEST1 MF,EH,=EH'0'
         BASR  R12,0
         USING *,R12
*MCALL #=  1991 LV= 3          CTD   CTD_EH,IN==EH'0',OUT=DECIMAL,LINKAX
               GE=MF
         LA    1,=A(CTD_EH,0,DECIMAL)
         LA    0,=EH'0'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  1991 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EH'
         MVC   DHEX,=CL32' '
         LA    R2,=EH'0'
         LA    R3,L'=EH'0'
*MCALL #=  1992 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  1993 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  1993 LV= 4 ZCALL
*MEXIT #=  1992 LV= 3 CALL
*MCALL #=  1994 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  1994 LV= 3 WTO
*MCALL #=  1995 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  1996 LV= 4          ZSTREQU 
*MEXIT #=  1996 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_173_2
*MEXIT #=  1995 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  1997 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  1997 LV= 3 WTO
*MCALL #=  1998 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  1998 LV= 3 ABEND
*MCALL #=  1999 LV= 3          ENDIF 
*MCALL #=  2000 LV= 4          ZSTREQU 
*MEXIT #=  2000 LV= 4 ZSTREQU
#@IF_173_2                                               DS 0H
*MEXIT #=  1999 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2001 LV= 3          CFD   CFD_EH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_EH,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  2001 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D EH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EH'0'
*MCALL #=  2002 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2003 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2003 LV= 4 ZCALL
*MEXIT #=  2002 LV= 3 CALL
*MCALL #=  2004 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2004 LV= 3 WTO
*MCALL #=  2005 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2006 LV= 4          ZSTREQU 
*MEXIT #=  2006 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_174_2
*MEXIT #=  2005 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2007 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2007 LV= 3 WTO
*MCALL #=  2008 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2008 LV= 3 ABEND
*MCALL #=  2009 LV= 3          ENDIF 
*MCALL #=  2010 LV= 4          ZSTREQU 
*MEXIT #=  2010 LV= 4 ZSTREQU
#@IF_174_2                                               DS 0H
*MEXIT #=  2009 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EH'0'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EH'0'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2011 LV= 3          RT1   CCE
         DS    0H
RT1_TEST115      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE115
         LTORG 
RT1_CCE115      DS 0H
*MEXIT #=  2011 LV= 3 RT1
         B     EXIT87
         LTORG 
EXIT87      DS 0H
*MEXIT #=  1990 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  2012 LV= 2          TEST1 SVC,EH,=EH'0'
         BASR  R12,0
         USING *,R12
*MCALL #=  2013 LV= 3          CTD   CTD_EH,IN==EH'0',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_EH,0,DECIMAL)
         LA    0,=EH'0'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2013 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EH'
         MVC   DHEX,=CL32' '
         LA    R2,=EH'0'
         LA    R3,L'=EH'0'
*MCALL #=  2014 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2015 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2015 LV= 4 ZCALL
*MEXIT #=  2014 LV= 3 CALL
*MCALL #=  2016 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2016 LV= 3 WTO
*MCALL #=  2017 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2018 LV= 4          ZSTREQU 
*MEXIT #=  2018 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_175_2
*MEXIT #=  2017 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2019 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2019 LV= 3 WTO
*MCALL #=  2020 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2020 LV= 3 ABEND
*MCALL #=  2021 LV= 3          ENDIF 
*MCALL #=  2022 LV= 4          ZSTREQU 
*MEXIT #=  2022 LV= 4 ZSTREQU
#@IF_175_2                                               DS 0H
*MEXIT #=  2021 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2023 LV= 3          CFD   CFD_EH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2023 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D EH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EH'0'
*MCALL #=  2024 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2025 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2025 LV= 4 ZCALL
*MEXIT #=  2024 LV= 3 CALL
*MCALL #=  2026 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2026 LV= 3 WTO
*MCALL #=  2027 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2028 LV= 4          ZSTREQU 
*MEXIT #=  2028 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_176_2
*MEXIT #=  2027 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2029 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2029 LV= 3 WTO
*MCALL #=  2030 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2030 LV= 3 ABEND
*MCALL #=  2031 LV= 3          ENDIF 
*MCALL #=  2032 LV= 4          ZSTREQU 
*MEXIT #=  2032 LV= 4 ZSTREQU
#@IF_176_2                                               DS 0H
*MEXIT #=  2031 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EH'0'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EH'0'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2033 LV= 3          RT1   CCE
         DS    0H
RT1_TEST116      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE116
         LTORG 
RT1_CCE116      DS 0H
*MEXIT #=  2033 LV= 3 RT1
         B     EXIT88
         LTORG 
EXIT88      DS 0H
*MEXIT #=  2012 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  2034 LV= 2          RT1   CCE
         DS    0H
RT1_TEST117      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE117
         LTORG 
RT1_CCE117      DS 0H
*MEXIT #=  2034 LV= 2 RT1
*MEXIT #=  1989 LV= 1 TEST
*MCALL #=  2035 LV= 1          TEST   EH,=EH'1E-78'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  2036 LV= 2          TEST1 MF,EH,=EH'1E-78'
         BASR  R12,0
         USING *,R12
*MCALL #=  2037 LV= 3          CTD   CTD_EH,IN==EH'1E-78',OUT=DECIMAL,LX
               INKAGE=MF
         LA    1,=A(CTD_EH,0,DECIMAL)
         LA    0,=EH'1E-78'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  2037 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EH'
         MVC   DHEX,=CL32' '
         LA    R2,=EH'1E-78'
         LA    R3,L'=EH'1E-78'
*MCALL #=  2038 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2039 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2039 LV= 4 ZCALL
*MEXIT #=  2038 LV= 3 CALL
*MCALL #=  2040 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2040 LV= 3 WTO
*MCALL #=  2041 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2042 LV= 4          ZSTREQU 
*MEXIT #=  2042 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_177_2
*MEXIT #=  2041 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2043 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2043 LV= 3 WTO
*MCALL #=  2044 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2044 LV= 3 ABEND
*MCALL #=  2045 LV= 3          ENDIF 
*MCALL #=  2046 LV= 4          ZSTREQU 
*MEXIT #=  2046 LV= 4 ZSTREQU
#@IF_177_2                                               DS 0H
*MEXIT #=  2045 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2047 LV= 3          CFD   CFD_EH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_EH,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  2047 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D EH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EH'1E-78'
*MCALL #=  2048 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2049 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2049 LV= 4 ZCALL
*MEXIT #=  2048 LV= 3 CALL
*MCALL #=  2050 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2050 LV= 3 WTO
*MCALL #=  2051 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2052 LV= 4          ZSTREQU 
*MEXIT #=  2052 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_178_2
*MEXIT #=  2051 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2053 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2053 LV= 3 WTO
*MCALL #=  2054 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2054 LV= 3 ABEND
*MCALL #=  2055 LV= 3          ENDIF 
*MCALL #=  2056 LV= 4          ZSTREQU 
*MEXIT #=  2056 LV= 4 ZSTREQU
#@IF_178_2                                               DS 0H
*MEXIT #=  2055 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EH'1E-78'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EH'1E-78'  VERIFY CTD CONSTANT WITH CFD RESULX
               T
* RPI 786 START TEST FOR DFP
*MCALL #=  2057 LV= 3          RT1   CCE
         DS    0H
RT1_TEST118      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE118
         LTORG 
RT1_CCE118      DS 0H
*MEXIT #=  2057 LV= 3 RT1
         B     EXIT89
         LTORG 
EXIT89      DS 0H
*MEXIT #=  2036 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  2058 LV= 2          TEST1 SVC,EH,=EH'1E-78'
         BASR  R12,0
         USING *,R12
*MCALL #=  2059 LV= 3          CTD   CTD_EH,IN==EH'1E-78',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_EH,0,DECIMAL)
         LA    0,=EH'1E-78'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2059 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EH'
         MVC   DHEX,=CL32' '
         LA    R2,=EH'1E-78'
         LA    R3,L'=EH'1E-78'
*MCALL #=  2060 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2061 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2061 LV= 4 ZCALL
*MEXIT #=  2060 LV= 3 CALL
*MCALL #=  2062 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2062 LV= 3 WTO
*MCALL #=  2063 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2064 LV= 4          ZSTREQU 
*MEXIT #=  2064 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_179_2
*MEXIT #=  2063 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2065 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2065 LV= 3 WTO
*MCALL #=  2066 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2066 LV= 3 ABEND
*MCALL #=  2067 LV= 3          ENDIF 
*MCALL #=  2068 LV= 4          ZSTREQU 
*MEXIT #=  2068 LV= 4 ZSTREQU
#@IF_179_2                                               DS 0H
*MEXIT #=  2067 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2069 LV= 3          CFD   CFD_EH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2069 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D EH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EH'1E-78'
*MCALL #=  2070 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2071 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2071 LV= 4 ZCALL
*MEXIT #=  2070 LV= 3 CALL
*MCALL #=  2072 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2072 LV= 3 WTO
*MCALL #=  2073 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2074 LV= 4          ZSTREQU 
*MEXIT #=  2074 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_180_2
*MEXIT #=  2073 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2075 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2075 LV= 3 WTO
*MCALL #=  2076 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2076 LV= 3 ABEND
*MCALL #=  2077 LV= 3          ENDIF 
*MCALL #=  2078 LV= 4          ZSTREQU 
*MEXIT #=  2078 LV= 4 ZSTREQU
#@IF_180_2                                               DS 0H
*MEXIT #=  2077 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EH'1E-78'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EH'1E-78'  VERIFY CTD CONSTANT WITH CFD RESULX
               T
* RPI 786 START TEST FOR DFP
*MCALL #=  2079 LV= 3          RT1   CCE
         DS    0H
RT1_TEST119      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE119
         LTORG 
RT1_CCE119      DS 0H
*MEXIT #=  2079 LV= 3 RT1
         B     EXIT90
         LTORG 
EXIT90      DS 0H
*MEXIT #=  2058 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  2080 LV= 2          RT1   CCE
         DS    0H
RT1_TEST120      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE120
         LTORG 
RT1_CCE120      DS 0H
*MEXIT #=  2080 LV= 2 RT1
*MEXIT #=  2035 LV= 1 TEST
*MCALL #=  2081 LV= 1          TEST   EH,=EH'1'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  2082 LV= 2          TEST1 MF,EH,=EH'1'
         BASR  R12,0
         USING *,R12
*MCALL #=  2083 LV= 3          CTD   CTD_EH,IN==EH'1',OUT=DECIMAL,LINKAX
               GE=MF
         LA    1,=A(CTD_EH,0,DECIMAL)
         LA    0,=EH'1'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  2083 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EH'
         MVC   DHEX,=CL32' '
         LA    R2,=EH'1'
         LA    R3,L'=EH'1'
*MCALL #=  2084 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2085 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2085 LV= 4 ZCALL
*MEXIT #=  2084 LV= 3 CALL
*MCALL #=  2086 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2086 LV= 3 WTO
*MCALL #=  2087 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2088 LV= 4          ZSTREQU 
*MEXIT #=  2088 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_181_2
*MEXIT #=  2087 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2089 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2089 LV= 3 WTO
*MCALL #=  2090 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2090 LV= 3 ABEND
*MCALL #=  2091 LV= 3          ENDIF 
*MCALL #=  2092 LV= 4          ZSTREQU 
*MEXIT #=  2092 LV= 4 ZSTREQU
#@IF_181_2                                               DS 0H
*MEXIT #=  2091 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2093 LV= 3          CFD   CFD_EH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_EH,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  2093 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D EH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EH'1'
*MCALL #=  2094 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2095 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2095 LV= 4 ZCALL
*MEXIT #=  2094 LV= 3 CALL
*MCALL #=  2096 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2096 LV= 3 WTO
*MCALL #=  2097 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2098 LV= 4          ZSTREQU 
*MEXIT #=  2098 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_182_2
*MEXIT #=  2097 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2099 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2099 LV= 3 WTO
*MCALL #=  2100 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2100 LV= 3 ABEND
*MCALL #=  2101 LV= 3          ENDIF 
*MCALL #=  2102 LV= 4          ZSTREQU 
*MEXIT #=  2102 LV= 4 ZSTREQU
#@IF_182_2                                               DS 0H
*MEXIT #=  2101 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EH'1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EH'1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2103 LV= 3          RT1   CCE
         DS    0H
RT1_TEST121      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE121
         LTORG 
RT1_CCE121      DS 0H
*MEXIT #=  2103 LV= 3 RT1
         B     EXIT91
         LTORG 
EXIT91      DS 0H
*MEXIT #=  2082 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  2104 LV= 2          TEST1 SVC,EH,=EH'1'
         BASR  R12,0
         USING *,R12
*MCALL #=  2105 LV= 3          CTD   CTD_EH,IN==EH'1',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_EH,0,DECIMAL)
         LA    0,=EH'1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2105 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EH'
         MVC   DHEX,=CL32' '
         LA    R2,=EH'1'
         LA    R3,L'=EH'1'
*MCALL #=  2106 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2107 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2107 LV= 4 ZCALL
*MEXIT #=  2106 LV= 3 CALL
*MCALL #=  2108 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2108 LV= 3 WTO
*MCALL #=  2109 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2110 LV= 4          ZSTREQU 
*MEXIT #=  2110 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_183_2
*MEXIT #=  2109 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2111 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2111 LV= 3 WTO
*MCALL #=  2112 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2112 LV= 3 ABEND
*MCALL #=  2113 LV= 3          ENDIF 
*MCALL #=  2114 LV= 4          ZSTREQU 
*MEXIT #=  2114 LV= 4 ZSTREQU
#@IF_183_2                                               DS 0H
*MEXIT #=  2113 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2115 LV= 3          CFD   CFD_EH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2115 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D EH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EH'1'
*MCALL #=  2116 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2117 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2117 LV= 4 ZCALL
*MEXIT #=  2116 LV= 3 CALL
*MCALL #=  2118 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2118 LV= 3 WTO
*MCALL #=  2119 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2120 LV= 4          ZSTREQU 
*MEXIT #=  2120 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_184_2
*MEXIT #=  2119 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2121 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2121 LV= 3 WTO
*MCALL #=  2122 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2122 LV= 3 ABEND
*MCALL #=  2123 LV= 3          ENDIF 
*MCALL #=  2124 LV= 4          ZSTREQU 
*MEXIT #=  2124 LV= 4 ZSTREQU
#@IF_184_2                                               DS 0H
*MEXIT #=  2123 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EH'1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EH'1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2125 LV= 3          RT1   CCE
         DS    0H
RT1_TEST122      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE122
         LTORG 
RT1_CCE122      DS 0H
*MEXIT #=  2125 LV= 3 RT1
         B     EXIT92
         LTORG 
EXIT92      DS 0H
*MEXIT #=  2104 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  2126 LV= 2          RT1   CCE
         DS    0H
RT1_TEST123      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE123
         LTORG 
RT1_CCE123      DS 0H
*MEXIT #=  2126 LV= 2 RT1
*MEXIT #=  2081 LV= 1 TEST
*MCALL #=  2127 LV= 1          TEST   EH,=EH'2'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  2128 LV= 2          TEST1 MF,EH,=EH'2'
         BASR  R12,0
         USING *,R12
*MCALL #=  2129 LV= 3          CTD   CTD_EH,IN==EH'2',OUT=DECIMAL,LINKAX
               GE=MF
         LA    1,=A(CTD_EH,0,DECIMAL)
         LA    0,=EH'2'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  2129 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EH'
         MVC   DHEX,=CL32' '
         LA    R2,=EH'2'
         LA    R3,L'=EH'2'
*MCALL #=  2130 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2131 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2131 LV= 4 ZCALL
*MEXIT #=  2130 LV= 3 CALL
*MCALL #=  2132 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2132 LV= 3 WTO
*MCALL #=  2133 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2134 LV= 4          ZSTREQU 
*MEXIT #=  2134 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_185_2
*MEXIT #=  2133 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2135 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2135 LV= 3 WTO
*MCALL #=  2136 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2136 LV= 3 ABEND
*MCALL #=  2137 LV= 3          ENDIF 
*MCALL #=  2138 LV= 4          ZSTREQU 
*MEXIT #=  2138 LV= 4 ZSTREQU
#@IF_185_2                                               DS 0H
*MEXIT #=  2137 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2139 LV= 3          CFD   CFD_EH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_EH,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  2139 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D EH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EH'2'
*MCALL #=  2140 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2141 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2141 LV= 4 ZCALL
*MEXIT #=  2140 LV= 3 CALL
*MCALL #=  2142 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2142 LV= 3 WTO
*MCALL #=  2143 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2144 LV= 4          ZSTREQU 
*MEXIT #=  2144 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_186_2
*MEXIT #=  2143 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2145 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2145 LV= 3 WTO
*MCALL #=  2146 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2146 LV= 3 ABEND
*MCALL #=  2147 LV= 3          ENDIF 
*MCALL #=  2148 LV= 4          ZSTREQU 
*MEXIT #=  2148 LV= 4 ZSTREQU
#@IF_186_2                                               DS 0H
*MEXIT #=  2147 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EH'2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EH'2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2149 LV= 3          RT1   CCE
         DS    0H
RT1_TEST124      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE124
         LTORG 
RT1_CCE124      DS 0H
*MEXIT #=  2149 LV= 3 RT1
         B     EXIT93
         LTORG 
EXIT93      DS 0H
*MEXIT #=  2128 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  2150 LV= 2          TEST1 SVC,EH,=EH'2'
         BASR  R12,0
         USING *,R12
*MCALL #=  2151 LV= 3          CTD   CTD_EH,IN==EH'2',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_EH,0,DECIMAL)
         LA    0,=EH'2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2151 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EH'
         MVC   DHEX,=CL32' '
         LA    R2,=EH'2'
         LA    R3,L'=EH'2'
*MCALL #=  2152 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2153 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2153 LV= 4 ZCALL
*MEXIT #=  2152 LV= 3 CALL
*MCALL #=  2154 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2154 LV= 3 WTO
*MCALL #=  2155 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2156 LV= 4          ZSTREQU 
*MEXIT #=  2156 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_187_2
*MEXIT #=  2155 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2157 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2157 LV= 3 WTO
*MCALL #=  2158 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2158 LV= 3 ABEND
*MCALL #=  2159 LV= 3          ENDIF 
*MCALL #=  2160 LV= 4          ZSTREQU 
*MEXIT #=  2160 LV= 4 ZSTREQU
#@IF_187_2                                               DS 0H
*MEXIT #=  2159 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2161 LV= 3          CFD   CFD_EH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2161 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D EH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EH'2'
*MCALL #=  2162 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2163 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2163 LV= 4 ZCALL
*MEXIT #=  2162 LV= 3 CALL
*MCALL #=  2164 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2164 LV= 3 WTO
*MCALL #=  2165 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2166 LV= 4          ZSTREQU 
*MEXIT #=  2166 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_188_2
*MEXIT #=  2165 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2167 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2167 LV= 3 WTO
*MCALL #=  2168 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2168 LV= 3 ABEND
*MCALL #=  2169 LV= 3          ENDIF 
*MCALL #=  2170 LV= 4          ZSTREQU 
*MEXIT #=  2170 LV= 4 ZSTREQU
#@IF_188_2                                               DS 0H
*MEXIT #=  2169 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EH'2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EH'2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2171 LV= 3          RT1   CCE
         DS    0H
RT1_TEST125      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE125
         LTORG 
RT1_CCE125      DS 0H
*MEXIT #=  2171 LV= 3 RT1
         B     EXIT94
         LTORG 
EXIT94      DS 0H
*MEXIT #=  2150 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  2172 LV= 2          RT1   CCE
         DS    0H
RT1_TEST126      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE126
         LTORG 
RT1_CCE126      DS 0H
*MEXIT #=  2172 LV= 2 RT1
*MEXIT #=  2127 LV= 1 TEST
*MCALL #=  2173 LV= 1          TEST   EH,=EH'1E2'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  2174 LV= 2          TEST1 MF,EH,=EH'1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=  2175 LV= 3          CTD   CTD_EH,IN==EH'1E2',OUT=DECIMAL,LINX
               KAGE=MF
         LA    1,=A(CTD_EH,0,DECIMAL)
         LA    0,=EH'1E2'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  2175 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EH'
         MVC   DHEX,=CL32' '
         LA    R2,=EH'1E2'
         LA    R3,L'=EH'1E2'
*MCALL #=  2176 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2177 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2177 LV= 4 ZCALL
*MEXIT #=  2176 LV= 3 CALL
*MCALL #=  2178 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2178 LV= 3 WTO
*MCALL #=  2179 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2180 LV= 4          ZSTREQU 
*MEXIT #=  2180 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_189_2
*MEXIT #=  2179 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2181 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2181 LV= 3 WTO
*MCALL #=  2182 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2182 LV= 3 ABEND
*MCALL #=  2183 LV= 3          ENDIF 
*MCALL #=  2184 LV= 4          ZSTREQU 
*MEXIT #=  2184 LV= 4 ZSTREQU
#@IF_189_2                                               DS 0H
*MEXIT #=  2183 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2185 LV= 3          CFD   CFD_EH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_EH,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  2185 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D EH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EH'1E2'
*MCALL #=  2186 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2187 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2187 LV= 4 ZCALL
*MEXIT #=  2186 LV= 3 CALL
*MCALL #=  2188 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2188 LV= 3 WTO
*MCALL #=  2189 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2190 LV= 4          ZSTREQU 
*MEXIT #=  2190 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_190_2
*MEXIT #=  2189 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2191 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2191 LV= 3 WTO
*MCALL #=  2192 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2192 LV= 3 ABEND
*MCALL #=  2193 LV= 3          ENDIF 
*MCALL #=  2194 LV= 4          ZSTREQU 
*MEXIT #=  2194 LV= 4 ZSTREQU
#@IF_190_2                                               DS 0H
*MEXIT #=  2193 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EH'1E2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EH'1E2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2195 LV= 3          RT1   CCE
         DS    0H
RT1_TEST127      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE127
         LTORG 
RT1_CCE127      DS 0H
*MEXIT #=  2195 LV= 3 RT1
         B     EXIT95
         LTORG 
EXIT95      DS 0H
*MEXIT #=  2174 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  2196 LV= 2          TEST1 SVC,EH,=EH'1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=  2197 LV= 3          CTD   CTD_EH,IN==EH'1E2',OUT=DECIMAL,LINX
               KAGE=SVC
         LA    1,=A(CTD_EH,0,DECIMAL)
         LA    0,=EH'1E2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2197 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EH'
         MVC   DHEX,=CL32' '
         LA    R2,=EH'1E2'
         LA    R3,L'=EH'1E2'
*MCALL #=  2198 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2199 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2199 LV= 4 ZCALL
*MEXIT #=  2198 LV= 3 CALL
*MCALL #=  2200 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2200 LV= 3 WTO
*MCALL #=  2201 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2202 LV= 4          ZSTREQU 
*MEXIT #=  2202 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_191_2
*MEXIT #=  2201 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2203 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2203 LV= 3 WTO
*MCALL #=  2204 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2204 LV= 3 ABEND
*MCALL #=  2205 LV= 3          ENDIF 
*MCALL #=  2206 LV= 4          ZSTREQU 
*MEXIT #=  2206 LV= 4 ZSTREQU
#@IF_191_2                                               DS 0H
*MEXIT #=  2205 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2207 LV= 3          CFD   CFD_EH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2207 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D EH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EH'1E2'
*MCALL #=  2208 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2209 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2209 LV= 4 ZCALL
*MEXIT #=  2208 LV= 3 CALL
*MCALL #=  2210 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2210 LV= 3 WTO
*MCALL #=  2211 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2212 LV= 4          ZSTREQU 
*MEXIT #=  2212 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_192_2
*MEXIT #=  2211 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2213 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2213 LV= 3 WTO
*MCALL #=  2214 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2214 LV= 3 ABEND
*MCALL #=  2215 LV= 3          ENDIF 
*MCALL #=  2216 LV= 4          ZSTREQU 
*MEXIT #=  2216 LV= 4 ZSTREQU
#@IF_192_2                                               DS 0H
*MEXIT #=  2215 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EH'1E2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EH'1E2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2217 LV= 3          RT1   CCE
         DS    0H
RT1_TEST128      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE128
         LTORG 
RT1_CCE128      DS 0H
*MEXIT #=  2217 LV= 3 RT1
         B     EXIT96
         LTORG 
EXIT96      DS 0H
*MEXIT #=  2196 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  2218 LV= 2          RT1   CCE
         DS    0H
RT1_TEST129      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE129
         LTORG 
RT1_CCE129      DS 0H
*MEXIT #=  2218 LV= 2 RT1
*MEXIT #=  2173 LV= 1 TEST
*MCALL #=  2219 LV= 1          TEST   EH,=EH'1E75'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  2220 LV= 2          TEST1 MF,EH,=EH'1E75'
         BASR  R12,0
         USING *,R12
*MCALL #=  2221 LV= 3          CTD   CTD_EH,IN==EH'1E75',OUT=DECIMAL,LIX
               NKAGE=MF
         LA    1,=A(CTD_EH,0,DECIMAL)
         LA    0,=EH'1E75'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  2221 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EH'
         MVC   DHEX,=CL32' '
         LA    R2,=EH'1E75'
         LA    R3,L'=EH'1E75'
*MCALL #=  2222 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2223 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2223 LV= 4 ZCALL
*MEXIT #=  2222 LV= 3 CALL
*MCALL #=  2224 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2224 LV= 3 WTO
*MCALL #=  2225 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2226 LV= 4          ZSTREQU 
*MEXIT #=  2226 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_193_2
*MEXIT #=  2225 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2227 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2227 LV= 3 WTO
*MCALL #=  2228 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2228 LV= 3 ABEND
*MCALL #=  2229 LV= 3          ENDIF 
*MCALL #=  2230 LV= 4          ZSTREQU 
*MEXIT #=  2230 LV= 4 ZSTREQU
#@IF_193_2                                               DS 0H
*MEXIT #=  2229 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2231 LV= 3          CFD   CFD_EH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_EH,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  2231 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D EH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EH'1E75'
*MCALL #=  2232 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2233 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2233 LV= 4 ZCALL
*MEXIT #=  2232 LV= 3 CALL
*MCALL #=  2234 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2234 LV= 3 WTO
*MCALL #=  2235 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2236 LV= 4          ZSTREQU 
*MEXIT #=  2236 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_194_2
*MEXIT #=  2235 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2237 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2237 LV= 3 WTO
*MCALL #=  2238 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2238 LV= 3 ABEND
*MCALL #=  2239 LV= 3          ENDIF 
*MCALL #=  2240 LV= 4          ZSTREQU 
*MEXIT #=  2240 LV= 4 ZSTREQU
#@IF_194_2                                               DS 0H
*MEXIT #=  2239 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EH'1E75'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EH'1E75'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2241 LV= 3          RT1   CCE
         DS    0H
RT1_TEST130      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE130
         LTORG 
RT1_CCE130      DS 0H
*MEXIT #=  2241 LV= 3 RT1
         B     EXIT97
         LTORG 
EXIT97      DS 0H
*MEXIT #=  2220 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  2242 LV= 2          TEST1 SVC,EH,=EH'1E75'
         BASR  R12,0
         USING *,R12
*MCALL #=  2243 LV= 3          CTD   CTD_EH,IN==EH'1E75',OUT=DECIMAL,LIX
               NKAGE=SVC
         LA    1,=A(CTD_EH,0,DECIMAL)
         LA    0,=EH'1E75'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2243 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EH'
         MVC   DHEX,=CL32' '
         LA    R2,=EH'1E75'
         LA    R3,L'=EH'1E75'
*MCALL #=  2244 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2245 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2245 LV= 4 ZCALL
*MEXIT #=  2244 LV= 3 CALL
*MCALL #=  2246 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2246 LV= 3 WTO
*MCALL #=  2247 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2248 LV= 4          ZSTREQU 
*MEXIT #=  2248 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_195_2
*MEXIT #=  2247 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2249 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2249 LV= 3 WTO
*MCALL #=  2250 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2250 LV= 3 ABEND
*MCALL #=  2251 LV= 3          ENDIF 
*MCALL #=  2252 LV= 4          ZSTREQU 
*MEXIT #=  2252 LV= 4 ZSTREQU
#@IF_195_2                                               DS 0H
*MEXIT #=  2251 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2253 LV= 3          CFD   CFD_EH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2253 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D EH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EH'1E75'
*MCALL #=  2254 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2255 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2255 LV= 4 ZCALL
*MEXIT #=  2254 LV= 3 CALL
*MCALL #=  2256 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2256 LV= 3 WTO
*MCALL #=  2257 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2258 LV= 4          ZSTREQU 
*MEXIT #=  2258 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_196_2
*MEXIT #=  2257 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2259 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2259 LV= 3 WTO
*MCALL #=  2260 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2260 LV= 3 ABEND
*MCALL #=  2261 LV= 3          ENDIF 
*MCALL #=  2262 LV= 4          ZSTREQU 
*MEXIT #=  2262 LV= 4 ZSTREQU
#@IF_196_2                                               DS 0H
*MEXIT #=  2261 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EH'1E75'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EH'1E75'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2263 LV= 3          RT1   CCE
         DS    0H
RT1_TEST131      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE131
         LTORG 
RT1_CCE131      DS 0H
*MEXIT #=  2263 LV= 3 RT1
         B     EXIT98
         LTORG 
EXIT98      DS 0H
*MEXIT #=  2242 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  2264 LV= 2          RT1   CCE
         DS    0H
RT1_TEST132      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE132
         LTORG 
RT1_CCE132      DS 0H
*MEXIT #=  2264 LV= 2 RT1
*MEXIT #=  2219 LV= 1 TEST
*MCALL #=  2265 LV= 1          TEST   EH,=EH'-1'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  2266 LV= 2          TEST1 MF,EH,=EH'-1'
         BASR  R12,0
         USING *,R12
*MCALL #=  2267 LV= 3          CTD   CTD_EH,IN==EH'-1',OUT=DECIMAL,LINKX
               AGE=MF
         LA    1,=A(CTD_EH,0,DECIMAL)
         LA    0,=EH'-1'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  2267 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EH'
         MVC   DHEX,=CL32' '
         LA    R2,=EH'-1'
         LA    R3,L'=EH'-1'
*MCALL #=  2268 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2269 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2269 LV= 4 ZCALL
*MEXIT #=  2268 LV= 3 CALL
*MCALL #=  2270 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2270 LV= 3 WTO
*MCALL #=  2271 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2272 LV= 4          ZSTREQU 
*MEXIT #=  2272 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_197_2
*MEXIT #=  2271 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2273 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2273 LV= 3 WTO
*MCALL #=  2274 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2274 LV= 3 ABEND
*MCALL #=  2275 LV= 3          ENDIF 
*MCALL #=  2276 LV= 4          ZSTREQU 
*MEXIT #=  2276 LV= 4 ZSTREQU
#@IF_197_2                                               DS 0H
*MEXIT #=  2275 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2277 LV= 3          CFD   CFD_EH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_EH,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  2277 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D EH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EH'-1'
*MCALL #=  2278 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2279 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2279 LV= 4 ZCALL
*MEXIT #=  2278 LV= 3 CALL
*MCALL #=  2280 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2280 LV= 3 WTO
*MCALL #=  2281 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2282 LV= 4          ZSTREQU 
*MEXIT #=  2282 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_198_2
*MEXIT #=  2281 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2283 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2283 LV= 3 WTO
*MCALL #=  2284 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2284 LV= 3 ABEND
*MCALL #=  2285 LV= 3          ENDIF 
*MCALL #=  2286 LV= 4          ZSTREQU 
*MEXIT #=  2286 LV= 4 ZSTREQU
#@IF_198_2                                               DS 0H
*MEXIT #=  2285 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EH'-1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EH'-1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2287 LV= 3          RT1   CCE
         DS    0H
RT1_TEST133      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE133
         LTORG 
RT1_CCE133      DS 0H
*MEXIT #=  2287 LV= 3 RT1
         B     EXIT99
         LTORG 
EXIT99      DS 0H
*MEXIT #=  2266 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  2288 LV= 2          TEST1 SVC,EH,=EH'-1'
         BASR  R12,0
         USING *,R12
*MCALL #=  2289 LV= 3          CTD   CTD_EH,IN==EH'-1',OUT=DECIMAL,LINKX
               AGE=SVC
         LA    1,=A(CTD_EH,0,DECIMAL)
         LA    0,=EH'-1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2289 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EH'
         MVC   DHEX,=CL32' '
         LA    R2,=EH'-1'
         LA    R3,L'=EH'-1'
*MCALL #=  2290 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2291 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2291 LV= 4 ZCALL
*MEXIT #=  2290 LV= 3 CALL
*MCALL #=  2292 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2292 LV= 3 WTO
*MCALL #=  2293 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2294 LV= 4          ZSTREQU 
*MEXIT #=  2294 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_199_2
*MEXIT #=  2293 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2295 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2295 LV= 3 WTO
*MCALL #=  2296 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2296 LV= 3 ABEND
*MCALL #=  2297 LV= 3          ENDIF 
*MCALL #=  2298 LV= 4          ZSTREQU 
*MEXIT #=  2298 LV= 4 ZSTREQU
#@IF_199_2                                               DS 0H
*MEXIT #=  2297 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2299 LV= 3          CFD   CFD_EH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2299 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D EH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EH'-1'
*MCALL #=  2300 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2301 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2301 LV= 4 ZCALL
*MEXIT #=  2300 LV= 3 CALL
*MCALL #=  2302 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2302 LV= 3 WTO
*MCALL #=  2303 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2304 LV= 4          ZSTREQU 
*MEXIT #=  2304 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_200_2
*MEXIT #=  2303 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2305 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2305 LV= 3 WTO
*MCALL #=  2306 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2306 LV= 3 ABEND
*MCALL #=  2307 LV= 3          ENDIF 
*MCALL #=  2308 LV= 4          ZSTREQU 
*MEXIT #=  2308 LV= 4 ZSTREQU
#@IF_200_2                                               DS 0H
*MEXIT #=  2307 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EH'-1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EH'-1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2309 LV= 3          RT1   CCE
         DS    0H
RT1_TEST134      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE134
         LTORG 
RT1_CCE134      DS 0H
*MEXIT #=  2309 LV= 3 RT1
         B     EXIT100
         LTORG 
EXIT100     DS 0H
*MEXIT #=  2288 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  2310 LV= 2          RT1   CCE
         DS    0H
RT1_TEST135      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE135
         LTORG 
RT1_CCE135      DS 0H
*MEXIT #=  2310 LV= 2 RT1
*MEXIT #=  2265 LV= 1 TEST
*MCALL #=  2311 LV= 1          TEST   EH,=EH'-2'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  2312 LV= 2          TEST1 MF,EH,=EH'-2'
         BASR  R12,0
         USING *,R12
*MCALL #=  2313 LV= 3          CTD   CTD_EH,IN==EH'-2',OUT=DECIMAL,LINKX
               AGE=MF
         LA    1,=A(CTD_EH,0,DECIMAL)
         LA    0,=EH'-2'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  2313 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EH'
         MVC   DHEX,=CL32' '
         LA    R2,=EH'-2'
         LA    R3,L'=EH'-2'
*MCALL #=  2314 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2315 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2315 LV= 4 ZCALL
*MEXIT #=  2314 LV= 3 CALL
*MCALL #=  2316 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2316 LV= 3 WTO
*MCALL #=  2317 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2318 LV= 4          ZSTREQU 
*MEXIT #=  2318 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_201_2
*MEXIT #=  2317 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2319 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2319 LV= 3 WTO
*MCALL #=  2320 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2320 LV= 3 ABEND
*MCALL #=  2321 LV= 3          ENDIF 
*MCALL #=  2322 LV= 4          ZSTREQU 
*MEXIT #=  2322 LV= 4 ZSTREQU
#@IF_201_2                                               DS 0H
*MEXIT #=  2321 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2323 LV= 3          CFD   CFD_EH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_EH,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  2323 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D EH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EH'-2'
*MCALL #=  2324 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2325 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2325 LV= 4 ZCALL
*MEXIT #=  2324 LV= 3 CALL
*MCALL #=  2326 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2326 LV= 3 WTO
*MCALL #=  2327 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2328 LV= 4          ZSTREQU 
*MEXIT #=  2328 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_202_2
*MEXIT #=  2327 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2329 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2329 LV= 3 WTO
*MCALL #=  2330 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2330 LV= 3 ABEND
*MCALL #=  2331 LV= 3          ENDIF 
*MCALL #=  2332 LV= 4          ZSTREQU 
*MEXIT #=  2332 LV= 4 ZSTREQU
#@IF_202_2                                               DS 0H
*MEXIT #=  2331 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EH'-2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EH'-2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2333 LV= 3          RT1   CCE
         DS    0H
RT1_TEST136      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE136
         LTORG 
RT1_CCE136      DS 0H
*MEXIT #=  2333 LV= 3 RT1
         B     EXIT101
         LTORG 
EXIT101     DS 0H
*MEXIT #=  2312 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  2334 LV= 2          TEST1 SVC,EH,=EH'-2'
         BASR  R12,0
         USING *,R12
*MCALL #=  2335 LV= 3          CTD   CTD_EH,IN==EH'-2',OUT=DECIMAL,LINKX
               AGE=SVC
         LA    1,=A(CTD_EH,0,DECIMAL)
         LA    0,=EH'-2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2335 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EH'
         MVC   DHEX,=CL32' '
         LA    R2,=EH'-2'
         LA    R3,L'=EH'-2'
*MCALL #=  2336 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2337 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2337 LV= 4 ZCALL
*MEXIT #=  2336 LV= 3 CALL
*MCALL #=  2338 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2338 LV= 3 WTO
*MCALL #=  2339 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2340 LV= 4          ZSTREQU 
*MEXIT #=  2340 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_203_2
*MEXIT #=  2339 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2341 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2341 LV= 3 WTO
*MCALL #=  2342 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2342 LV= 3 ABEND
*MCALL #=  2343 LV= 3          ENDIF 
*MCALL #=  2344 LV= 4          ZSTREQU 
*MEXIT #=  2344 LV= 4 ZSTREQU
#@IF_203_2                                               DS 0H
*MEXIT #=  2343 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2345 LV= 3          CFD   CFD_EH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2345 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D EH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EH'-2'
*MCALL #=  2346 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2347 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2347 LV= 4 ZCALL
*MEXIT #=  2346 LV= 3 CALL
*MCALL #=  2348 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2348 LV= 3 WTO
*MCALL #=  2349 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2350 LV= 4          ZSTREQU 
*MEXIT #=  2350 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_204_2
*MEXIT #=  2349 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2351 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2351 LV= 3 WTO
*MCALL #=  2352 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2352 LV= 3 ABEND
*MCALL #=  2353 LV= 3          ENDIF 
*MCALL #=  2354 LV= 4          ZSTREQU 
*MEXIT #=  2354 LV= 4 ZSTREQU
#@IF_204_2                                               DS 0H
*MEXIT #=  2353 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EH'-2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EH'-2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2355 LV= 3          RT1   CCE
         DS    0H
RT1_TEST137      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE137
         LTORG 
RT1_CCE137      DS 0H
*MEXIT #=  2355 LV= 3 RT1
         B     EXIT102
         LTORG 
EXIT102     DS 0H
*MEXIT #=  2334 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  2356 LV= 2          RT1   CCE
         DS    0H
RT1_TEST138      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE138
         LTORG 
RT1_CCE138      DS 0H
*MEXIT #=  2356 LV= 2 RT1
*MEXIT #=  2311 LV= 1 TEST
*MCALL #=  2357 LV= 1          TEST   EH,=EH'-1E2'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  2358 LV= 2          TEST1 MF,EH,=EH'-1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=  2359 LV= 3          CTD   CTD_EH,IN==EH'-1E2',OUT=DECIMAL,LIX
               NKAGE=MF
         LA    1,=A(CTD_EH,0,DECIMAL)
         LA    0,=EH'-1E2'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  2359 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EH'
         MVC   DHEX,=CL32' '
         LA    R2,=EH'-1E2'
         LA    R3,L'=EH'-1E2'
*MCALL #=  2360 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2361 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2361 LV= 4 ZCALL
*MEXIT #=  2360 LV= 3 CALL
*MCALL #=  2362 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2362 LV= 3 WTO
*MCALL #=  2363 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2364 LV= 4          ZSTREQU 
*MEXIT #=  2364 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_205_2
*MEXIT #=  2363 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2365 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2365 LV= 3 WTO
*MCALL #=  2366 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2366 LV= 3 ABEND
*MCALL #=  2367 LV= 3          ENDIF 
*MCALL #=  2368 LV= 4          ZSTREQU 
*MEXIT #=  2368 LV= 4 ZSTREQU
#@IF_205_2                                               DS 0H
*MEXIT #=  2367 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2369 LV= 3          CFD   CFD_EH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_EH,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  2369 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D EH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EH'-1E2'
*MCALL #=  2370 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2371 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2371 LV= 4 ZCALL
*MEXIT #=  2370 LV= 3 CALL
*MCALL #=  2372 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2372 LV= 3 WTO
*MCALL #=  2373 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2374 LV= 4          ZSTREQU 
*MEXIT #=  2374 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_206_2
*MEXIT #=  2373 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2375 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2375 LV= 3 WTO
*MCALL #=  2376 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2376 LV= 3 ABEND
*MCALL #=  2377 LV= 3          ENDIF 
*MCALL #=  2378 LV= 4          ZSTREQU 
*MEXIT #=  2378 LV= 4 ZSTREQU
#@IF_206_2                                               DS 0H
*MEXIT #=  2377 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EH'-1E2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EH'-1E2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2379 LV= 3          RT1   CCE
         DS    0H
RT1_TEST139      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE139
         LTORG 
RT1_CCE139      DS 0H
*MEXIT #=  2379 LV= 3 RT1
         B     EXIT103
         LTORG 
EXIT103     DS 0H
*MEXIT #=  2358 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  2380 LV= 2          TEST1 SVC,EH,=EH'-1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=  2381 LV= 3          CTD   CTD_EH,IN==EH'-1E2',OUT=DECIMAL,LIX
               NKAGE=SVC
         LA    1,=A(CTD_EH,0,DECIMAL)
         LA    0,=EH'-1E2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2381 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EH'
         MVC   DHEX,=CL32' '
         LA    R2,=EH'-1E2'
         LA    R3,L'=EH'-1E2'
*MCALL #=  2382 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2383 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2383 LV= 4 ZCALL
*MEXIT #=  2382 LV= 3 CALL
*MCALL #=  2384 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2384 LV= 3 WTO
*MCALL #=  2385 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2386 LV= 4          ZSTREQU 
*MEXIT #=  2386 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_207_2
*MEXIT #=  2385 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2387 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2387 LV= 3 WTO
*MCALL #=  2388 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2388 LV= 3 ABEND
*MCALL #=  2389 LV= 3          ENDIF 
*MCALL #=  2390 LV= 4          ZSTREQU 
*MEXIT #=  2390 LV= 4 ZSTREQU
#@IF_207_2                                               DS 0H
*MEXIT #=  2389 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2391 LV= 3          CFD   CFD_EH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2391 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D EH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EH'-1E2'
*MCALL #=  2392 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2393 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2393 LV= 4 ZCALL
*MEXIT #=  2392 LV= 3 CALL
*MCALL #=  2394 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2394 LV= 3 WTO
*MCALL #=  2395 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2396 LV= 4          ZSTREQU 
*MEXIT #=  2396 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_208_2
*MEXIT #=  2395 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2397 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2397 LV= 3 WTO
*MCALL #=  2398 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2398 LV= 3 ABEND
*MCALL #=  2399 LV= 3          ENDIF 
*MCALL #=  2400 LV= 4          ZSTREQU 
*MEXIT #=  2400 LV= 4 ZSTREQU
#@IF_208_2                                               DS 0H
*MEXIT #=  2399 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=EH'-1E2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=EH'-1E2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2401 LV= 3          RT1   CCE
         DS    0H
RT1_TEST140      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE140
         LTORG 
RT1_CCE140      DS 0H
*MEXIT #=  2401 LV= 3 RT1
         B     EXIT104
         LTORG 
EXIT104     DS 0H
*MEXIT #=  2380 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  2402 LV= 2          RT1   CCE
         DS    0H
RT1_TEST141      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE141
         LTORG 
RT1_CCE141      DS 0H
*MEXIT #=  2402 LV= 2 RT1
*MEXIT #=  2357 LV= 1 TEST
* LB
*MCALL #=  2403 LV= 1          TEST   LB,=LB'0'
*MCALL #=  2404 LV= 2          TEST1 SVC,LB,=LB'0'
         BASR  R12,0
         USING *,R12
*MCALL #=  2405 LV= 3          CTD   CTD_LB,IN==LB'0',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_LB,0,DECIMAL)
         LA    0,=LB'0'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2405 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LB'
         MVC   DHEX,=CL32' '
         LA    R2,=LB'0'
         LA    R3,L'=LB'0'
*MCALL #=  2406 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2407 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2407 LV= 4 ZCALL
*MEXIT #=  2406 LV= 3 CALL
*MCALL #=  2408 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2408 LV= 3 WTO
*MCALL #=  2409 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2410 LV= 4          ZSTREQU 
*MEXIT #=  2410 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_209_2
*MEXIT #=  2409 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2411 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2411 LV= 3 WTO
*MCALL #=  2412 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2412 LV= 3 ABEND
*MCALL #=  2413 LV= 3          ENDIF 
*MCALL #=  2414 LV= 4          ZSTREQU 
*MEXIT #=  2414 LV= 4 ZSTREQU
#@IF_209_2                                               DS 0H
*MEXIT #=  2413 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2415 LV= 3          CFD   CFD_LB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2415 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LB'0'
*MCALL #=  2416 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2417 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2417 LV= 4 ZCALL
*MEXIT #=  2416 LV= 3 CALL
*MCALL #=  2418 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2418 LV= 3 WTO
*MCALL #=  2419 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2420 LV= 4          ZSTREQU 
*MEXIT #=  2420 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_210_2
*MEXIT #=  2419 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2421 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2421 LV= 3 WTO
*MCALL #=  2422 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2422 LV= 3 ABEND
*MCALL #=  2423 LV= 3          ENDIF 
*MCALL #=  2424 LV= 4          ZSTREQU 
*MEXIT #=  2424 LV= 4 ZSTREQU
#@IF_210_2                                               DS 0H
*MEXIT #=  2423 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=LB'0'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=LB'0'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2425 LV= 3          RT1   CCE
         DS    0H
RT1_TEST142      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE142
         LTORG 
RT1_CCE142      DS 0H
*MEXIT #=  2425 LV= 3 RT1
         B     EXIT105
         LTORG 
EXIT105     DS 0H
*MEXIT #=  2404 LV= 2 TEST1
*MEXIT #=  2403 LV= 1 TEST
*MCALL #=  2426 LV= 1          TEST   LB,=LB'1E-4931'
*MCALL #=  2427 LV= 2          TEST1 SVC,LB,=LB'1E-4931'
         BASR  R12,0
         USING *,R12
*MCALL #=  2428 LV= 3          CTD   CTD_LB,IN==LB'1E-4931',OUT=DECIMALX
               ,LINKAGE=SVC
         LA    1,=A(CTD_LB,0,DECIMAL)
         LA    0,=LB'1E-4931'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2428 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LB'
         MVC   DHEX,=CL32' '
         LA    R2,=LB'1E-4931'
         LA    R3,L'=LB'1E-4931'
*MCALL #=  2429 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2430 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2430 LV= 4 ZCALL
*MEXIT #=  2429 LV= 3 CALL
*MCALL #=  2431 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2431 LV= 3 WTO
*MCALL #=  2432 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2433 LV= 4          ZSTREQU 
*MEXIT #=  2433 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_211_2
*MEXIT #=  2432 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2434 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2434 LV= 3 WTO
*MCALL #=  2435 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2435 LV= 3 ABEND
*MCALL #=  2436 LV= 3          ENDIF 
*MCALL #=  2437 LV= 4          ZSTREQU 
*MEXIT #=  2437 LV= 4 ZSTREQU
#@IF_211_2                                               DS 0H
*MEXIT #=  2436 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2438 LV= 3          CFD   CFD_LB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2438 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LB'1E-4931'
*MCALL #=  2439 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2440 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2440 LV= 4 ZCALL
*MEXIT #=  2439 LV= 3 CALL
*MCALL #=  2441 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2441 LV= 3 WTO
*MCALL #=  2442 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2443 LV= 4          ZSTREQU 
*MEXIT #=  2443 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_212_2
*MEXIT #=  2442 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2444 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2444 LV= 3 WTO
*MCALL #=  2445 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2445 LV= 3 ABEND
*MCALL #=  2446 LV= 3          ENDIF 
*MCALL #=  2447 LV= 4          ZSTREQU 
*MEXIT #=  2447 LV= 4 ZSTREQU
#@IF_212_2                                               DS 0H
*MEXIT #=  2446 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=LB'1E-4931'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=LB'1E-4931'  VERIFY CTD CONSTANT WITH CFD RESX
               ULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2448 LV= 3          RT1   CCE
         DS    0H
RT1_TEST143      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE143
         LTORG 
RT1_CCE143      DS 0H
*MEXIT #=  2448 LV= 3 RT1
         B     EXIT106
         LTORG 
EXIT106     DS 0H
*MEXIT #=  2427 LV= 2 TEST1
*MEXIT #=  2426 LV= 1 TEST
*MCALL #=  2449 LV= 1          TEST   LB,=LB'1'
*MCALL #=  2450 LV= 2          TEST1 SVC,LB,=LB'1'
         BASR  R12,0
         USING *,R12
*MCALL #=  2451 LV= 3          CTD   CTD_LB,IN==LB'1',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_LB,0,DECIMAL)
         LA    0,=LB'1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2451 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LB'
         MVC   DHEX,=CL32' '
         LA    R2,=LB'1'
         LA    R3,L'=LB'1'
*MCALL #=  2452 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2453 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2453 LV= 4 ZCALL
*MEXIT #=  2452 LV= 3 CALL
*MCALL #=  2454 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2454 LV= 3 WTO
*MCALL #=  2455 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2456 LV= 4          ZSTREQU 
*MEXIT #=  2456 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_213_2
*MEXIT #=  2455 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2457 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2457 LV= 3 WTO
*MCALL #=  2458 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2458 LV= 3 ABEND
*MCALL #=  2459 LV= 3          ENDIF 
*MCALL #=  2460 LV= 4          ZSTREQU 
*MEXIT #=  2460 LV= 4 ZSTREQU
#@IF_213_2                                               DS 0H
*MEXIT #=  2459 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2461 LV= 3          CFD   CFD_LB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2461 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LB'1'
*MCALL #=  2462 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2463 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2463 LV= 4 ZCALL
*MEXIT #=  2462 LV= 3 CALL
*MCALL #=  2464 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2464 LV= 3 WTO
*MCALL #=  2465 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2466 LV= 4          ZSTREQU 
*MEXIT #=  2466 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_214_2
*MEXIT #=  2465 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2467 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2467 LV= 3 WTO
*MCALL #=  2468 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2468 LV= 3 ABEND
*MCALL #=  2469 LV= 3          ENDIF 
*MCALL #=  2470 LV= 4          ZSTREQU 
*MEXIT #=  2470 LV= 4 ZSTREQU
#@IF_214_2                                               DS 0H
*MEXIT #=  2469 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=LB'1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=LB'1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2471 LV= 3          RT1   CCE
         DS    0H
RT1_TEST144      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE144
         LTORG 
RT1_CCE144      DS 0H
*MEXIT #=  2471 LV= 3 RT1
         B     EXIT107
         LTORG 
EXIT107     DS 0H
*MEXIT #=  2450 LV= 2 TEST1
*MEXIT #=  2449 LV= 1 TEST
*MCALL #=  2472 LV= 1          TEST   LB,=LB'2'
*MCALL #=  2473 LV= 2          TEST1 SVC,LB,=LB'2'
         BASR  R12,0
         USING *,R12
*MCALL #=  2474 LV= 3          CTD   CTD_LB,IN==LB'2',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_LB,0,DECIMAL)
         LA    0,=LB'2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2474 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LB'
         MVC   DHEX,=CL32' '
         LA    R2,=LB'2'
         LA    R3,L'=LB'2'
*MCALL #=  2475 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2476 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2476 LV= 4 ZCALL
*MEXIT #=  2475 LV= 3 CALL
*MCALL #=  2477 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2477 LV= 3 WTO
*MCALL #=  2478 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2479 LV= 4          ZSTREQU 
*MEXIT #=  2479 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_215_2
*MEXIT #=  2478 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2480 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2480 LV= 3 WTO
*MCALL #=  2481 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2481 LV= 3 ABEND
*MCALL #=  2482 LV= 3          ENDIF 
*MCALL #=  2483 LV= 4          ZSTREQU 
*MEXIT #=  2483 LV= 4 ZSTREQU
#@IF_215_2                                               DS 0H
*MEXIT #=  2482 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2484 LV= 3          CFD   CFD_LB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2484 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LB'2'
*MCALL #=  2485 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2486 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2486 LV= 4 ZCALL
*MEXIT #=  2485 LV= 3 CALL
*MCALL #=  2487 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2487 LV= 3 WTO
*MCALL #=  2488 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2489 LV= 4          ZSTREQU 
*MEXIT #=  2489 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_216_2
*MEXIT #=  2488 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2490 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2490 LV= 3 WTO
*MCALL #=  2491 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2491 LV= 3 ABEND
*MCALL #=  2492 LV= 3          ENDIF 
*MCALL #=  2493 LV= 4          ZSTREQU 
*MEXIT #=  2493 LV= 4 ZSTREQU
#@IF_216_2                                               DS 0H
*MEXIT #=  2492 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=LB'2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=LB'2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2494 LV= 3          RT1   CCE
         DS    0H
RT1_TEST145      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE145
         LTORG 
RT1_CCE145      DS 0H
*MEXIT #=  2494 LV= 3 RT1
         B     EXIT108
         LTORG 
EXIT108     DS 0H
*MEXIT #=  2473 LV= 2 TEST1
*MEXIT #=  2472 LV= 1 TEST
*MCALL #=  2495 LV= 1          TEST   LB,=LB'1E2'
*MCALL #=  2496 LV= 2          TEST1 SVC,LB,=LB'1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=  2497 LV= 3          CTD   CTD_LB,IN==LB'1E2',OUT=DECIMAL,LINX
               KAGE=SVC
         LA    1,=A(CTD_LB,0,DECIMAL)
         LA    0,=LB'1E2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2497 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LB'
         MVC   DHEX,=CL32' '
         LA    R2,=LB'1E2'
         LA    R3,L'=LB'1E2'
*MCALL #=  2498 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2499 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2499 LV= 4 ZCALL
*MEXIT #=  2498 LV= 3 CALL
*MCALL #=  2500 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2500 LV= 3 WTO
*MCALL #=  2501 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2502 LV= 4          ZSTREQU 
*MEXIT #=  2502 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_217_2
*MEXIT #=  2501 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2503 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2503 LV= 3 WTO
*MCALL #=  2504 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2504 LV= 3 ABEND
*MCALL #=  2505 LV= 3          ENDIF 
*MCALL #=  2506 LV= 4          ZSTREQU 
*MEXIT #=  2506 LV= 4 ZSTREQU
#@IF_217_2                                               DS 0H
*MEXIT #=  2505 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2507 LV= 3          CFD   CFD_LB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2507 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LB'1E2'
*MCALL #=  2508 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2509 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2509 LV= 4 ZCALL
*MEXIT #=  2508 LV= 3 CALL
*MCALL #=  2510 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2510 LV= 3 WTO
*MCALL #=  2511 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2512 LV= 4          ZSTREQU 
*MEXIT #=  2512 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_218_2
*MEXIT #=  2511 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2513 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2513 LV= 3 WTO
*MCALL #=  2514 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2514 LV= 3 ABEND
*MCALL #=  2515 LV= 3          ENDIF 
*MCALL #=  2516 LV= 4          ZSTREQU 
*MEXIT #=  2516 LV= 4 ZSTREQU
#@IF_218_2                                               DS 0H
*MEXIT #=  2515 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=LB'1E2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=LB'1E2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2517 LV= 3          RT1   CCE
         DS    0H
RT1_TEST146      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE146
         LTORG 
RT1_CCE146      DS 0H
*MEXIT #=  2517 LV= 3 RT1
         B     EXIT109
         LTORG 
EXIT109     DS 0H
*MEXIT #=  2496 LV= 2 TEST1
*MEXIT #=  2495 LV= 1 TEST
*MCALL #=  2518 LV= 1          TEST   LB,=LB'1E4931'
*MCALL #=  2519 LV= 2          TEST1 SVC,LB,=LB'1E4931'
         BASR  R12,0
         USING *,R12
*MCALL #=  2520 LV= 3          CTD   CTD_LB,IN==LB'1E4931',OUT=DECIMAL,X
               LINKAGE=SVC
         LA    1,=A(CTD_LB,0,DECIMAL)
         LA    0,=LB'1E4931'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2520 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LB'
         MVC   DHEX,=CL32' '
         LA    R2,=LB'1E4931'
         LA    R3,L'=LB'1E4931'
*MCALL #=  2521 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2522 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2522 LV= 4 ZCALL
*MEXIT #=  2521 LV= 3 CALL
*MCALL #=  2523 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2523 LV= 3 WTO
*MCALL #=  2524 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2525 LV= 4          ZSTREQU 
*MEXIT #=  2525 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_219_2
*MEXIT #=  2524 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2526 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2526 LV= 3 WTO
*MCALL #=  2527 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2527 LV= 3 ABEND
*MCALL #=  2528 LV= 3          ENDIF 
*MCALL #=  2529 LV= 4          ZSTREQU 
*MEXIT #=  2529 LV= 4 ZSTREQU
#@IF_219_2                                               DS 0H
*MEXIT #=  2528 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2530 LV= 3          CFD   CFD_LB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2530 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LB'1E4931'
*MCALL #=  2531 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2532 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2532 LV= 4 ZCALL
*MEXIT #=  2531 LV= 3 CALL
*MCALL #=  2533 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2533 LV= 3 WTO
*MCALL #=  2534 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2535 LV= 4          ZSTREQU 
*MEXIT #=  2535 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_220_2
*MEXIT #=  2534 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2536 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2536 LV= 3 WTO
*MCALL #=  2537 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2537 LV= 3 ABEND
*MCALL #=  2538 LV= 3          ENDIF 
*MCALL #=  2539 LV= 4          ZSTREQU 
*MEXIT #=  2539 LV= 4 ZSTREQU
#@IF_220_2                                               DS 0H
*MEXIT #=  2538 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=LB'1E4931'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=LB'1E4931'  VERIFY CTD CONSTANT WITH CFD RESUX
               LT
* RPI 786 START TEST FOR DFP
*MCALL #=  2540 LV= 3          RT1   CCE
         DS    0H
RT1_TEST147      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE147
         LTORG 
RT1_CCE147      DS 0H
*MEXIT #=  2540 LV= 3 RT1
         B     EXIT110
         LTORG 
EXIT110     DS 0H
*MEXIT #=  2519 LV= 2 TEST1
*MEXIT #=  2518 LV= 1 TEST
*MCALL #=  2541 LV= 1          TEST   LB,=LB'-1'
*MCALL #=  2542 LV= 2          TEST1 SVC,LB,=LB'-1'
         BASR  R12,0
         USING *,R12
*MCALL #=  2543 LV= 3          CTD   CTD_LB,IN==LB'-1',OUT=DECIMAL,LINKX
               AGE=SVC
         LA    1,=A(CTD_LB,0,DECIMAL)
         LA    0,=LB'-1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2543 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LB'
         MVC   DHEX,=CL32' '
         LA    R2,=LB'-1'
         LA    R3,L'=LB'-1'
*MCALL #=  2544 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2545 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2545 LV= 4 ZCALL
*MEXIT #=  2544 LV= 3 CALL
*MCALL #=  2546 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2546 LV= 3 WTO
*MCALL #=  2547 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2548 LV= 4          ZSTREQU 
*MEXIT #=  2548 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_221_2
*MEXIT #=  2547 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2549 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2549 LV= 3 WTO
*MCALL #=  2550 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2550 LV= 3 ABEND
*MCALL #=  2551 LV= 3          ENDIF 
*MCALL #=  2552 LV= 4          ZSTREQU 
*MEXIT #=  2552 LV= 4 ZSTREQU
#@IF_221_2                                               DS 0H
*MEXIT #=  2551 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2553 LV= 3          CFD   CFD_LB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2553 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LB'-1'
*MCALL #=  2554 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2555 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2555 LV= 4 ZCALL
*MEXIT #=  2554 LV= 3 CALL
*MCALL #=  2556 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2556 LV= 3 WTO
*MCALL #=  2557 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2558 LV= 4          ZSTREQU 
*MEXIT #=  2558 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_222_2
*MEXIT #=  2557 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2559 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2559 LV= 3 WTO
*MCALL #=  2560 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2560 LV= 3 ABEND
*MCALL #=  2561 LV= 3          ENDIF 
*MCALL #=  2562 LV= 4          ZSTREQU 
*MEXIT #=  2562 LV= 4 ZSTREQU
#@IF_222_2                                               DS 0H
*MEXIT #=  2561 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=LB'-1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=LB'-1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2563 LV= 3          RT1   CCE
         DS    0H
RT1_TEST148      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE148
         LTORG 
RT1_CCE148      DS 0H
*MEXIT #=  2563 LV= 3 RT1
         B     EXIT111
         LTORG 
EXIT111     DS 0H
*MEXIT #=  2542 LV= 2 TEST1
*MEXIT #=  2541 LV= 1 TEST
*MCALL #=  2564 LV= 1          TEST   LB,=LB'-2'
*MCALL #=  2565 LV= 2          TEST1 SVC,LB,=LB'-2'
         BASR  R12,0
         USING *,R12
*MCALL #=  2566 LV= 3          CTD   CTD_LB,IN==LB'-2',OUT=DECIMAL,LINKX
               AGE=SVC
         LA    1,=A(CTD_LB,0,DECIMAL)
         LA    0,=LB'-2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2566 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LB'
         MVC   DHEX,=CL32' '
         LA    R2,=LB'-2'
         LA    R3,L'=LB'-2'
*MCALL #=  2567 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2568 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2568 LV= 4 ZCALL
*MEXIT #=  2567 LV= 3 CALL
*MCALL #=  2569 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2569 LV= 3 WTO
*MCALL #=  2570 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2571 LV= 4          ZSTREQU 
*MEXIT #=  2571 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_223_2
*MEXIT #=  2570 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2572 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2572 LV= 3 WTO
*MCALL #=  2573 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2573 LV= 3 ABEND
*MCALL #=  2574 LV= 3          ENDIF 
*MCALL #=  2575 LV= 4          ZSTREQU 
*MEXIT #=  2575 LV= 4 ZSTREQU
#@IF_223_2                                               DS 0H
*MEXIT #=  2574 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2576 LV= 3          CFD   CFD_LB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2576 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LB'-2'
*MCALL #=  2577 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2578 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2578 LV= 4 ZCALL
*MEXIT #=  2577 LV= 3 CALL
*MCALL #=  2579 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2579 LV= 3 WTO
*MCALL #=  2580 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2581 LV= 4          ZSTREQU 
*MEXIT #=  2581 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_224_2
*MEXIT #=  2580 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2582 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2582 LV= 3 WTO
*MCALL #=  2583 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2583 LV= 3 ABEND
*MCALL #=  2584 LV= 3          ENDIF 
*MCALL #=  2585 LV= 4          ZSTREQU 
*MEXIT #=  2585 LV= 4 ZSTREQU
#@IF_224_2                                               DS 0H
*MEXIT #=  2584 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=LB'-2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=LB'-2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2586 LV= 3          RT1   CCE
         DS    0H
RT1_TEST149      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE149
         LTORG 
RT1_CCE149      DS 0H
*MEXIT #=  2586 LV= 3 RT1
         B     EXIT112
         LTORG 
EXIT112     DS 0H
*MEXIT #=  2565 LV= 2 TEST1
*MEXIT #=  2564 LV= 1 TEST
*MCALL #=  2587 LV= 1          TEST   LB,=LB'-1E2'
*MCALL #=  2588 LV= 2          TEST1 SVC,LB,=LB'-1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=  2589 LV= 3          CTD   CTD_LB,IN==LB'-1E2',OUT=DECIMAL,LIX
               NKAGE=SVC
         LA    1,=A(CTD_LB,0,DECIMAL)
         LA    0,=LB'-1E2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2589 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LB'
         MVC   DHEX,=CL32' '
         LA    R2,=LB'-1E2'
         LA    R3,L'=LB'-1E2'
*MCALL #=  2590 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2591 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2591 LV= 4 ZCALL
*MEXIT #=  2590 LV= 3 CALL
*MCALL #=  2592 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2592 LV= 3 WTO
*MCALL #=  2593 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2594 LV= 4          ZSTREQU 
*MEXIT #=  2594 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_225_2
*MEXIT #=  2593 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2595 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2595 LV= 3 WTO
*MCALL #=  2596 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2596 LV= 3 ABEND
*MCALL #=  2597 LV= 3          ENDIF 
*MCALL #=  2598 LV= 4          ZSTREQU 
*MEXIT #=  2598 LV= 4 ZSTREQU
#@IF_225_2                                               DS 0H
*MEXIT #=  2597 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2599 LV= 3          CFD   CFD_LB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2599 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LB'-1E2'
*MCALL #=  2600 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2601 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2601 LV= 4 ZCALL
*MEXIT #=  2600 LV= 3 CALL
*MCALL #=  2602 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2602 LV= 3 WTO
*MCALL #=  2603 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2604 LV= 4          ZSTREQU 
*MEXIT #=  2604 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_226_2
*MEXIT #=  2603 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2605 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2605 LV= 3 WTO
*MCALL #=  2606 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2606 LV= 3 ABEND
*MCALL #=  2607 LV= 3          ENDIF 
*MCALL #=  2608 LV= 4          ZSTREQU 
*MEXIT #=  2608 LV= 4 ZSTREQU
#@IF_226_2                                               DS 0H
*MEXIT #=  2607 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=LB'-1E2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=LB'-1E2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2609 LV= 3          RT1   CCE
         DS    0H
RT1_TEST150      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE150
         LTORG 
RT1_CCE150      DS 0H
*MEXIT #=  2609 LV= 3 RT1
         B     EXIT113
         LTORG 
EXIT113     DS 0H
*MEXIT #=  2588 LV= 2 TEST1
*MEXIT #=  2587 LV= 1 TEST
*MCALL #=  2610 LV= 1          TEST   LB,LBT1 TEST VALUE FOR FPCONVRT
*MCALL #=  2611 LV= 2          TEST1 SVC,LB,LBT1
         BASR  R12,0
         USING *,R12
*MCALL #=  2612 LV= 3          CTD   CTD_LB,IN=LBT1,OUT=DECIMAL,LINKAGEX
               =SVC
         LA    1,=A(CTD_LB,LBT1,DECIMAL)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2612 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LB'
         MVC   DHEX,=CL32' '
         LA    R2,LBT1
         LA    R3,L'LBT1
*MCALL #=  2613 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2614 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2614 LV= 4 ZCALL
*MEXIT #=  2613 LV= 3 CALL
*MCALL #=  2615 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2615 LV= 3 WTO
*MCALL #=  2616 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2617 LV= 4          ZSTREQU 
*MEXIT #=  2617 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_227_2
*MEXIT #=  2616 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2618 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2618 LV= 3 WTO
*MCALL #=  2619 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2619 LV= 3 ABEND
*MCALL #=  2620 LV= 3          ENDIF 
*MCALL #=  2621 LV= 4          ZSTREQU 
*MEXIT #=  2621 LV= 4 ZSTREQU
#@IF_227_2                                               DS 0H
*MEXIT #=  2620 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2622 LV= 3          CFD   CFD_LB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2622 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LB'
         MVC   DHEX,=CL32' '
         LA    R3,L'LBT1
*MCALL #=  2623 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2624 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2624 LV= 4 ZCALL
*MEXIT #=  2623 LV= 3 CALL
*MCALL #=  2625 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2625 LV= 3 WTO
*MCALL #=  2626 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2627 LV= 4          ZSTREQU 
*MEXIT #=  2627 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_228_2
*MEXIT #=  2626 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2628 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2628 LV= 3 WTO
*MCALL #=  2629 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2629 LV= 3 ABEND
*MCALL #=  2630 LV= 3          ENDIF 
*MCALL #=  2631 LV= 4          ZSTREQU 
*MEXIT #=  2631 LV= 4 ZSTREQU
#@IF_228_2                                               DS 0H
*MEXIT #=  2630 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'LBT1
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),LBT1  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  2632 LV= 3          RT1   CCE
         DS    0H
RT1_TEST151      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE151
         LTORG 
RT1_CCE151      DS 0H
*MEXIT #=  2632 LV= 3 RT1
         B     EXIT114
         LTORG 
EXIT114     DS 0H
*MEXIT #=  2611 LV= 2 TEST1
*MEXIT #=  2610 LV= 1 TEST
* LD
*MCALL #=  2633 LV= 1          TEST   LD,=LD'0'
*MCALL #=  2634 LV= 2          TEST1 SVC,LD,=LD'0'
         BASR  R12,0
         USING *,R12
*MCALL #=  2635 LV= 3          CTD   CTD_LD,IN==LD'0',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_LD,0,DECIMAL)
         LA    0,=LD'0'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2635 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LD'
         MVC   DHEX,=CL32' '
         LA    R2,=LD'0'
         LA    R3,L'=LD'0'
*MCALL #=  2636 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2637 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2637 LV= 4 ZCALL
*MEXIT #=  2636 LV= 3 CALL
*MCALL #=  2638 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2638 LV= 3 WTO
*MCALL #=  2639 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2640 LV= 4          ZSTREQU 
*MEXIT #=  2640 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_229_2
*MEXIT #=  2639 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2641 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2641 LV= 3 WTO
*MCALL #=  2642 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2642 LV= 3 ABEND
*MCALL #=  2643 LV= 3          ENDIF 
*MCALL #=  2644 LV= 4          ZSTREQU 
*MEXIT #=  2644 LV= 4 ZSTREQU
#@IF_229_2                                               DS 0H
*MEXIT #=  2643 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2645 LV= 3          CFD   CFD_LD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2645 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LD'0'
*MCALL #=  2646 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2647 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2647 LV= 4 ZCALL
*MEXIT #=  2646 LV= 3 CALL
*MCALL #=  2648 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2648 LV= 3 WTO
*MCALL #=  2649 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2650 LV= 4          ZSTREQU 
*MEXIT #=  2650 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_230_2
*MEXIT #=  2649 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2651 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2651 LV= 3 WTO
*MCALL #=  2652 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2652 LV= 3 ABEND
*MCALL #=  2653 LV= 3          ENDIF 
*MCALL #=  2654 LV= 4          ZSTREQU 
*MEXIT #=  2654 LV= 4 ZSTREQU
#@IF_230_2                                               DS 0H
*MEXIT #=  2653 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
*MCALL #=  2655 LV= 3          LX    R0,=LD'0'
         LA    15,=LD'0'
         LD    R0,0(15)
         LD    R0+2,8(15)
*MEXIT #=  2655 LV= 3 LX
*MCALL #=  2656 LV= 3          LX    R1,WORK16
         LA    15,WORK16
         LD    R1,0(15)
         LD    R1+2,8(15)
*MEXIT #=  2656 LV= 3 LX
         CXTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  2657 LV= 3          RT1   CCE
         DS    0H
RT1_TEST152      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE152
         LTORG 
RT1_CCE152      DS 0H
*MEXIT #=  2657 LV= 3 RT1
         B     EXIT115
         LTORG 
EXIT115     DS 0H
*MEXIT #=  2634 LV= 2 TEST1
*MEXIT #=  2633 LV= 1 TEST
*MCALL #=  2658 LV= 1          TEST   LD,=LD'0.123456789012345678901234X
               5678901234'
*MCALL #=  2659 LV= 2          TEST1 SVC,LD,=LD'0.123456789012345678901X
               2345678901234'
         BASR  R12,0
         USING *,R12
*MCALL #=  2660 LV= 3          CTD   CTD_LD,IN==LD'0.123456789012345678X
               9012345678901234',OUT=DECIMAL,LINKAGE=SVC
         LA    1,=A(CTD_LD,0,DECIMAL)
         LA    0,=LD'0.1234567890123456789012345678901234'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2660 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LD'
         MVC   DHEX,=CL32' '
         LA    R2,=LD'0.1234567890123456789012345678901234'
         LA    R3,L'=LD'0.1234567890123456789012345678901234'
*MCALL #=  2661 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2662 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2662 LV= 4 ZCALL
*MEXIT #=  2661 LV= 3 CALL
*MCALL #=  2663 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2663 LV= 3 WTO
*MCALL #=  2664 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2665 LV= 4          ZSTREQU 
*MEXIT #=  2665 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_231_2
*MEXIT #=  2664 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2666 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2666 LV= 3 WTO
*MCALL #=  2667 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2667 LV= 3 ABEND
*MCALL #=  2668 LV= 3          ENDIF 
*MCALL #=  2669 LV= 4          ZSTREQU 
*MEXIT #=  2669 LV= 4 ZSTREQU
#@IF_231_2                                               DS 0H
*MEXIT #=  2668 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2670 LV= 3          CFD   CFD_LD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2670 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LD'0.1234567890123456789012345678901234'
*MCALL #=  2671 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2672 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2672 LV= 4 ZCALL
*MEXIT #=  2671 LV= 3 CALL
*MCALL #=  2673 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2673 LV= 3 WTO
*MCALL #=  2674 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2675 LV= 4          ZSTREQU 
*MEXIT #=  2675 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_232_2
*MEXIT #=  2674 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2676 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2676 LV= 3 WTO
*MCALL #=  2677 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2677 LV= 3 ABEND
*MCALL #=  2678 LV= 3          ENDIF 
*MCALL #=  2679 LV= 4          ZSTREQU 
*MEXIT #=  2679 LV= 4 ZSTREQU
#@IF_232_2                                               DS 0H
*MEXIT #=  2678 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
*MCALL #=  2680 LV= 3          LX    R0,=LD'0.1234567890123456789012345X
               678901234'
         LA    15,=LD'0.1234567890123456789012345678901234'
         LD    R0,0(15)
         LD    R0+2,8(15)
*MEXIT #=  2680 LV= 3 LX
*MCALL #=  2681 LV= 3          LX    R1,WORK16
         LA    15,WORK16
         LD    R1,0(15)
         LD    R1+2,8(15)
*MEXIT #=  2681 LV= 3 LX
         CXTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  2682 LV= 3          RT1   CCE
         DS    0H
RT1_TEST153      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE153
         LTORG 
RT1_CCE153      DS 0H
*MEXIT #=  2682 LV= 3 RT1
         B     EXIT116
         LTORG 
EXIT116     DS 0H
*MEXIT #=  2659 LV= 2 TEST1
*MEXIT #=  2658 LV= 1 TEST
*MCALL #=  2683 LV= 1          TEST   LD,=LD'0.123456789012345678901234X
               56789012340'
*MCALL #=  2684 LV= 2          TEST1 SVC,LD,=LD'0.123456789012345678901X
               23456789012340'
         BASR  R12,0
         USING *,R12
*MCALL #=  2685 LV= 3          CTD   CTD_LD,IN==LD'0.123456789012345678X
               90123456789012340',OUT=DECIMAL,LINKAGE=SVC
         LA    1,=A(CTD_LD,0,DECIMAL)
         LA    0,=LD'0.12345678901234567890123456789012340'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2685 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LD'
         MVC   DHEX,=CL32' '
         LA    R2,=LD'0.12345678901234567890123456789012340'
         LA    R3,L'=LD'0.12345678901234567890123456789012340'
*MCALL #=  2686 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2687 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2687 LV= 4 ZCALL
*MEXIT #=  2686 LV= 3 CALL
*MCALL #=  2688 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2688 LV= 3 WTO
*MCALL #=  2689 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2690 LV= 4          ZSTREQU 
*MEXIT #=  2690 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_233_2
*MEXIT #=  2689 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2691 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2691 LV= 3 WTO
*MCALL #=  2692 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2692 LV= 3 ABEND
*MCALL #=  2693 LV= 3          ENDIF 
*MCALL #=  2694 LV= 4          ZSTREQU 
*MEXIT #=  2694 LV= 4 ZSTREQU
#@IF_233_2                                               DS 0H
*MEXIT #=  2693 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2695 LV= 3          CFD   CFD_LD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2695 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LD'0.12345678901234567890123456789012340'
*MCALL #=  2696 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2697 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2697 LV= 4 ZCALL
*MEXIT #=  2696 LV= 3 CALL
*MCALL #=  2698 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2698 LV= 3 WTO
*MCALL #=  2699 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2700 LV= 4          ZSTREQU 
*MEXIT #=  2700 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_234_2
*MEXIT #=  2699 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2701 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2701 LV= 3 WTO
*MCALL #=  2702 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2702 LV= 3 ABEND
*MCALL #=  2703 LV= 3          ENDIF 
*MCALL #=  2704 LV= 4          ZSTREQU 
*MEXIT #=  2704 LV= 4 ZSTREQU
#@IF_234_2                                               DS 0H
*MEXIT #=  2703 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
*MCALL #=  2705 LV= 3          LX    R0,=LD'0.1234567890123456789012345X
               6789012340'
         LA    15,=LD'0.12345678901234567890123456789012340'
         LD    R0,0(15)
         LD    R0+2,8(15)
*MEXIT #=  2705 LV= 3 LX
*MCALL #=  2706 LV= 3          LX    R1,WORK16
         LA    15,WORK16
         LD    R1,0(15)
         LD    R1+2,8(15)
*MEXIT #=  2706 LV= 3 LX
         CXTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  2707 LV= 3          RT1   CCE
         DS    0H
RT1_TEST154      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE154
         LTORG 
RT1_CCE154      DS 0H
*MEXIT #=  2707 LV= 3 RT1
         B     EXIT117
         LTORG 
EXIT117     DS 0H
*MEXIT #=  2684 LV= 2 TEST1
*MEXIT #=  2683 LV= 1 TEST
*MCALL #=  2708 LV= 1          TEST   LD,=LD'1E-6176'
*MCALL #=  2709 LV= 2          TEST1 SVC,LD,=LD'1E-6176'
         BASR  R12,0
         USING *,R12
*MCALL #=  2710 LV= 3          CTD   CTD_LD,IN==LD'1E-6176',OUT=DECIMALX
               ,LINKAGE=SVC
         LA    1,=A(CTD_LD,0,DECIMAL)
         LA    0,=LD'1E-6176'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2710 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LD'
         MVC   DHEX,=CL32' '
         LA    R2,=LD'1E-6176'
         LA    R3,L'=LD'1E-6176'
*MCALL #=  2711 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2712 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2712 LV= 4 ZCALL
*MEXIT #=  2711 LV= 3 CALL
*MCALL #=  2713 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2713 LV= 3 WTO
*MCALL #=  2714 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2715 LV= 4          ZSTREQU 
*MEXIT #=  2715 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_235_2
*MEXIT #=  2714 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2716 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2716 LV= 3 WTO
*MCALL #=  2717 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2717 LV= 3 ABEND
*MCALL #=  2718 LV= 3          ENDIF 
*MCALL #=  2719 LV= 4          ZSTREQU 
*MEXIT #=  2719 LV= 4 ZSTREQU
#@IF_235_2                                               DS 0H
*MEXIT #=  2718 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2720 LV= 3          CFD   CFD_LD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2720 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LD'1E-6176'
*MCALL #=  2721 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2722 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2722 LV= 4 ZCALL
*MEXIT #=  2721 LV= 3 CALL
*MCALL #=  2723 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2723 LV= 3 WTO
*MCALL #=  2724 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2725 LV= 4          ZSTREQU 
*MEXIT #=  2725 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_236_2
*MEXIT #=  2724 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2726 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2726 LV= 3 WTO
*MCALL #=  2727 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2727 LV= 3 ABEND
*MCALL #=  2728 LV= 3          ENDIF 
*MCALL #=  2729 LV= 4          ZSTREQU 
*MEXIT #=  2729 LV= 4 ZSTREQU
#@IF_236_2                                               DS 0H
*MEXIT #=  2728 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
*MCALL #=  2730 LV= 3          LX    R0,=LD'1E-6176'
         LA    15,=LD'1E-6176'
         LD    R0,0(15)
         LD    R0+2,8(15)
*MEXIT #=  2730 LV= 3 LX
*MCALL #=  2731 LV= 3          LX    R1,WORK16
         LA    15,WORK16
         LD    R1,0(15)
         LD    R1+2,8(15)
*MEXIT #=  2731 LV= 3 LX
         CXTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  2732 LV= 3          RT1   CCE
         DS    0H
RT1_TEST155      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE155
         LTORG 
RT1_CCE155      DS 0H
*MEXIT #=  2732 LV= 3 RT1
         B     EXIT118
         LTORG 
EXIT118     DS 0H
*MEXIT #=  2709 LV= 2 TEST1
*MEXIT #=  2708 LV= 1 TEST
*MCALL #=  2733 LV= 1          TEST   LD,=LD'1'
*MCALL #=  2734 LV= 2          TEST1 SVC,LD,=LD'1'
         BASR  R12,0
         USING *,R12
*MCALL #=  2735 LV= 3          CTD   CTD_LD,IN==LD'1',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_LD,0,DECIMAL)
         LA    0,=LD'1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2735 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LD'
         MVC   DHEX,=CL32' '
         LA    R2,=LD'1'
         LA    R3,L'=LD'1'
*MCALL #=  2736 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2737 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2737 LV= 4 ZCALL
*MEXIT #=  2736 LV= 3 CALL
*MCALL #=  2738 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2738 LV= 3 WTO
*MCALL #=  2739 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2740 LV= 4          ZSTREQU 
*MEXIT #=  2740 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_237_2
*MEXIT #=  2739 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2741 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2741 LV= 3 WTO
*MCALL #=  2742 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2742 LV= 3 ABEND
*MCALL #=  2743 LV= 3          ENDIF 
*MCALL #=  2744 LV= 4          ZSTREQU 
*MEXIT #=  2744 LV= 4 ZSTREQU
#@IF_237_2                                               DS 0H
*MEXIT #=  2743 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2745 LV= 3          CFD   CFD_LD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2745 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LD'1'
*MCALL #=  2746 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2747 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2747 LV= 4 ZCALL
*MEXIT #=  2746 LV= 3 CALL
*MCALL #=  2748 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2748 LV= 3 WTO
*MCALL #=  2749 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2750 LV= 4          ZSTREQU 
*MEXIT #=  2750 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_238_2
*MEXIT #=  2749 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2751 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2751 LV= 3 WTO
*MCALL #=  2752 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2752 LV= 3 ABEND
*MCALL #=  2753 LV= 3          ENDIF 
*MCALL #=  2754 LV= 4          ZSTREQU 
*MEXIT #=  2754 LV= 4 ZSTREQU
#@IF_238_2                                               DS 0H
*MEXIT #=  2753 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
*MCALL #=  2755 LV= 3          LX    R0,=LD'1'
         LA    15,=LD'1'
         LD    R0,0(15)
         LD    R0+2,8(15)
*MEXIT #=  2755 LV= 3 LX
*MCALL #=  2756 LV= 3          LX    R1,WORK16
         LA    15,WORK16
         LD    R1,0(15)
         LD    R1+2,8(15)
*MEXIT #=  2756 LV= 3 LX
         CXTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  2757 LV= 3          RT1   CCE
         DS    0H
RT1_TEST156      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE156
         LTORG 
RT1_CCE156      DS 0H
*MEXIT #=  2757 LV= 3 RT1
         B     EXIT119
         LTORG 
EXIT119     DS 0H
*MEXIT #=  2734 LV= 2 TEST1
*MEXIT #=  2733 LV= 1 TEST
*MCALL #=  2758 LV= 1          TEST   LD,=LD'2'
*MCALL #=  2759 LV= 2          TEST1 SVC,LD,=LD'2'
         BASR  R12,0
         USING *,R12
*MCALL #=  2760 LV= 3          CTD   CTD_LD,IN==LD'2',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_LD,0,DECIMAL)
         LA    0,=LD'2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2760 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LD'
         MVC   DHEX,=CL32' '
         LA    R2,=LD'2'
         LA    R3,L'=LD'2'
*MCALL #=  2761 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2762 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2762 LV= 4 ZCALL
*MEXIT #=  2761 LV= 3 CALL
*MCALL #=  2763 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2763 LV= 3 WTO
*MCALL #=  2764 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2765 LV= 4          ZSTREQU 
*MEXIT #=  2765 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_239_2
*MEXIT #=  2764 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2766 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2766 LV= 3 WTO
*MCALL #=  2767 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2767 LV= 3 ABEND
*MCALL #=  2768 LV= 3          ENDIF 
*MCALL #=  2769 LV= 4          ZSTREQU 
*MEXIT #=  2769 LV= 4 ZSTREQU
#@IF_239_2                                               DS 0H
*MEXIT #=  2768 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2770 LV= 3          CFD   CFD_LD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2770 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LD'2'
*MCALL #=  2771 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2772 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2772 LV= 4 ZCALL
*MEXIT #=  2771 LV= 3 CALL
*MCALL #=  2773 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2773 LV= 3 WTO
*MCALL #=  2774 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2775 LV= 4          ZSTREQU 
*MEXIT #=  2775 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_240_2
*MEXIT #=  2774 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2776 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2776 LV= 3 WTO
*MCALL #=  2777 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2777 LV= 3 ABEND
*MCALL #=  2778 LV= 3          ENDIF 
*MCALL #=  2779 LV= 4          ZSTREQU 
*MEXIT #=  2779 LV= 4 ZSTREQU
#@IF_240_2                                               DS 0H
*MEXIT #=  2778 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
*MCALL #=  2780 LV= 3          LX    R0,=LD'2'
         LA    15,=LD'2'
         LD    R0,0(15)
         LD    R0+2,8(15)
*MEXIT #=  2780 LV= 3 LX
*MCALL #=  2781 LV= 3          LX    R1,WORK16
         LA    15,WORK16
         LD    R1,0(15)
         LD    R1+2,8(15)
*MEXIT #=  2781 LV= 3 LX
         CXTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  2782 LV= 3          RT1   CCE
         DS    0H
RT1_TEST157      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE157
         LTORG 
RT1_CCE157      DS 0H
*MEXIT #=  2782 LV= 3 RT1
         B     EXIT120
         LTORG 
EXIT120     DS 0H
*MEXIT #=  2759 LV= 2 TEST1
*MEXIT #=  2758 LV= 1 TEST
*MCALL #=  2783 LV= 1          TEST   LD,=LD'1E2'
*MCALL #=  2784 LV= 2          TEST1 SVC,LD,=LD'1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=  2785 LV= 3          CTD   CTD_LD,IN==LD'1E2',OUT=DECIMAL,LINX
               KAGE=SVC
         LA    1,=A(CTD_LD,0,DECIMAL)
         LA    0,=LD'1E2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2785 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LD'
         MVC   DHEX,=CL32' '
         LA    R2,=LD'1E2'
         LA    R3,L'=LD'1E2'
*MCALL #=  2786 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2787 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2787 LV= 4 ZCALL
*MEXIT #=  2786 LV= 3 CALL
*MCALL #=  2788 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2788 LV= 3 WTO
*MCALL #=  2789 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2790 LV= 4          ZSTREQU 
*MEXIT #=  2790 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_241_2
*MEXIT #=  2789 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2791 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2791 LV= 3 WTO
*MCALL #=  2792 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2792 LV= 3 ABEND
*MCALL #=  2793 LV= 3          ENDIF 
*MCALL #=  2794 LV= 4          ZSTREQU 
*MEXIT #=  2794 LV= 4 ZSTREQU
#@IF_241_2                                               DS 0H
*MEXIT #=  2793 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2795 LV= 3          CFD   CFD_LD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2795 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LD'1E2'
*MCALL #=  2796 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2797 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2797 LV= 4 ZCALL
*MEXIT #=  2796 LV= 3 CALL
*MCALL #=  2798 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2798 LV= 3 WTO
*MCALL #=  2799 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2800 LV= 4          ZSTREQU 
*MEXIT #=  2800 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_242_2
*MEXIT #=  2799 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2801 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2801 LV= 3 WTO
*MCALL #=  2802 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2802 LV= 3 ABEND
*MCALL #=  2803 LV= 3          ENDIF 
*MCALL #=  2804 LV= 4          ZSTREQU 
*MEXIT #=  2804 LV= 4 ZSTREQU
#@IF_242_2                                               DS 0H
*MEXIT #=  2803 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
*MCALL #=  2805 LV= 3          LX    R0,=LD'1E2'
         LA    15,=LD'1E2'
         LD    R0,0(15)
         LD    R0+2,8(15)
*MEXIT #=  2805 LV= 3 LX
*MCALL #=  2806 LV= 3          LX    R1,WORK16
         LA    15,WORK16
         LD    R1,0(15)
         LD    R1+2,8(15)
*MEXIT #=  2806 LV= 3 LX
         CXTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  2807 LV= 3          RT1   CCE
         DS    0H
RT1_TEST158      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE158
         LTORG 
RT1_CCE158      DS 0H
*MEXIT #=  2807 LV= 3 RT1
         B     EXIT121
         LTORG 
EXIT121     DS 0H
*MEXIT #=  2784 LV= 2 TEST1
*MEXIT #=  2783 LV= 1 TEST
*MCALL #=  2808 LV= 1          TEST   LD,=LD'12345678901234567890123456X
               78901234'
*MCALL #=  2809 LV= 2          TEST1 SVC,LD,=LD'12345678901234567890123X
               45678901234'
         BASR  R12,0
         USING *,R12
*MCALL #=  2810 LV= 3          CTD   CTD_LD,IN==LD'12345678901234567890X
               12345678901234',OUT=DECIMAL,LINKAGE=SVC
         LA    1,=A(CTD_LD,0,DECIMAL)
         LA    0,=LD'1234567890123456789012345678901234'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2810 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LD'
         MVC   DHEX,=CL32' '
         LA    R2,=LD'1234567890123456789012345678901234'
         LA    R3,L'=LD'1234567890123456789012345678901234'
*MCALL #=  2811 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2812 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2812 LV= 4 ZCALL
*MEXIT #=  2811 LV= 3 CALL
*MCALL #=  2813 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2813 LV= 3 WTO
*MCALL #=  2814 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2815 LV= 4          ZSTREQU 
*MEXIT #=  2815 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_243_2
*MEXIT #=  2814 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2816 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2816 LV= 3 WTO
*MCALL #=  2817 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2817 LV= 3 ABEND
*MCALL #=  2818 LV= 3          ENDIF 
*MCALL #=  2819 LV= 4          ZSTREQU 
*MEXIT #=  2819 LV= 4 ZSTREQU
#@IF_243_2                                               DS 0H
*MEXIT #=  2818 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2820 LV= 3          CFD   CFD_LD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2820 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LD'1234567890123456789012345678901234'
*MCALL #=  2821 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2822 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2822 LV= 4 ZCALL
*MEXIT #=  2821 LV= 3 CALL
*MCALL #=  2823 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2823 LV= 3 WTO
*MCALL #=  2824 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2825 LV= 4          ZSTREQU 
*MEXIT #=  2825 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_244_2
*MEXIT #=  2824 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2826 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2826 LV= 3 WTO
*MCALL #=  2827 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2827 LV= 3 ABEND
*MCALL #=  2828 LV= 3          ENDIF 
*MCALL #=  2829 LV= 4          ZSTREQU 
*MEXIT #=  2829 LV= 4 ZSTREQU
#@IF_244_2                                               DS 0H
*MEXIT #=  2828 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
*MCALL #=  2830 LV= 3          LX    R0,=LD'123456789012345678901234567X
               8901234'
         LA    15,=LD'1234567890123456789012345678901234'
         LD    R0,0(15)
         LD    R0+2,8(15)
*MEXIT #=  2830 LV= 3 LX
*MCALL #=  2831 LV= 3          LX    R1,WORK16
         LA    15,WORK16
         LD    R1,0(15)
         LD    R1+2,8(15)
*MEXIT #=  2831 LV= 3 LX
         CXTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  2832 LV= 3          RT1   CCE
         DS    0H
RT1_TEST159      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE159
         LTORG 
RT1_CCE159      DS 0H
*MEXIT #=  2832 LV= 3 RT1
         B     EXIT122
         LTORG 
EXIT122     DS 0H
*MEXIT #=  2809 LV= 2 TEST1
*MEXIT #=  2808 LV= 1 TEST
*MCALL #=  2833 LV= 1          TEST   LD,=LD'1.234567890123456789012345X
               678901234E33'
*MCALL #=  2834 LV= 2          TEST1 SVC,LD,=LD'1.234567890123456789012X
               345678901234E33'
         BASR  R12,0
         USING *,R12
*MCALL #=  2835 LV= 3          CTD   CTD_LD,IN==LD'1.234567890123456789X
               012345678901234E33',OUT=DECIMAL,LINKAGE=SVC
         LA    1,=A(CTD_LD,0,DECIMAL)
         LA    0,=LD'1.234567890123456789012345678901234E33'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2835 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LD'
         MVC   DHEX,=CL32' '
         LA    R2,=LD'1.234567890123456789012345678901234E33'
         LA    R3,L'=LD'1.234567890123456789012345678901234E33'
*MCALL #=  2836 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2837 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2837 LV= 4 ZCALL
*MEXIT #=  2836 LV= 3 CALL
*MCALL #=  2838 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2838 LV= 3 WTO
*MCALL #=  2839 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2840 LV= 4          ZSTREQU 
*MEXIT #=  2840 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_245_2
*MEXIT #=  2839 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2841 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2841 LV= 3 WTO
*MCALL #=  2842 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2842 LV= 3 ABEND
*MCALL #=  2843 LV= 3          ENDIF 
*MCALL #=  2844 LV= 4          ZSTREQU 
*MEXIT #=  2844 LV= 4 ZSTREQU
#@IF_245_2                                               DS 0H
*MEXIT #=  2843 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2845 LV= 3          CFD   CFD_LD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2845 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LD'1.234567890123456789012345678901234E33'
*MCALL #=  2846 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2847 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2847 LV= 4 ZCALL
*MEXIT #=  2846 LV= 3 CALL
*MCALL #=  2848 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2848 LV= 3 WTO
*MCALL #=  2849 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2850 LV= 4          ZSTREQU 
*MEXIT #=  2850 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_246_2
*MEXIT #=  2849 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2851 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2851 LV= 3 WTO
*MCALL #=  2852 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2852 LV= 3 ABEND
*MCALL #=  2853 LV= 3          ENDIF 
*MCALL #=  2854 LV= 4          ZSTREQU 
*MEXIT #=  2854 LV= 4 ZSTREQU
#@IF_246_2                                               DS 0H
*MEXIT #=  2853 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
*MCALL #=  2855 LV= 3          LX    R0,=LD'1.2345678901234567890123456X
               78901234E33'
         LA    15,=LD'1.234567890123456789012345678901234E33'
         LD    R0,0(15)
         LD    R0+2,8(15)
*MEXIT #=  2855 LV= 3 LX
*MCALL #=  2856 LV= 3          LX    R1,WORK16
         LA    15,WORK16
         LD    R1,0(15)
         LD    R1+2,8(15)
*MEXIT #=  2856 LV= 3 LX
         CXTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  2857 LV= 3          RT1   CCE
         DS    0H
RT1_TEST160      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE160
         LTORG 
RT1_CCE160      DS 0H
*MEXIT #=  2857 LV= 3 RT1
         B     EXIT123
         LTORG 
EXIT123     DS 0H
*MEXIT #=  2834 LV= 2 TEST1
*MEXIT #=  2833 LV= 1 TEST
*MCALL #=  2858 LV= 1          TEST   LD,=LD'12345678901234567890123456X
               78901234'
*MCALL #=  2859 LV= 2          TEST1 SVC,LD,=LD'12345678901234567890123X
               45678901234'
         BASR  R12,0
         USING *,R12
*MCALL #=  2860 LV= 3          CTD   CTD_LD,IN==LD'12345678901234567890X
               12345678901234',OUT=DECIMAL,LINKAGE=SVC
         LA    1,=A(CTD_LD,0,DECIMAL)
         LA    0,=LD'1234567890123456789012345678901234'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2860 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LD'
         MVC   DHEX,=CL32' '
         LA    R2,=LD'1234567890123456789012345678901234'
         LA    R3,L'=LD'1234567890123456789012345678901234'
*MCALL #=  2861 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2862 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2862 LV= 4 ZCALL
*MEXIT #=  2861 LV= 3 CALL
*MCALL #=  2863 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2863 LV= 3 WTO
*MCALL #=  2864 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2865 LV= 4          ZSTREQU 
*MEXIT #=  2865 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_247_2
*MEXIT #=  2864 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2866 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2866 LV= 3 WTO
*MCALL #=  2867 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2867 LV= 3 ABEND
*MCALL #=  2868 LV= 3          ENDIF 
*MCALL #=  2869 LV= 4          ZSTREQU 
*MEXIT #=  2869 LV= 4 ZSTREQU
#@IF_247_2                                               DS 0H
*MEXIT #=  2868 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2870 LV= 3          CFD   CFD_LD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2870 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LD'1234567890123456789012345678901234'
*MCALL #=  2871 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2872 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2872 LV= 4 ZCALL
*MEXIT #=  2871 LV= 3 CALL
*MCALL #=  2873 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2873 LV= 3 WTO
*MCALL #=  2874 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2875 LV= 4          ZSTREQU 
*MEXIT #=  2875 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_248_2
*MEXIT #=  2874 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2876 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2876 LV= 3 WTO
*MCALL #=  2877 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2877 LV= 3 ABEND
*MCALL #=  2878 LV= 3          ENDIF 
*MCALL #=  2879 LV= 4          ZSTREQU 
*MEXIT #=  2879 LV= 4 ZSTREQU
#@IF_248_2                                               DS 0H
*MEXIT #=  2878 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
*MCALL #=  2880 LV= 3          LX    R0,=LD'123456789012345678901234567X
               8901234'
         LA    15,=LD'1234567890123456789012345678901234'
         LD    R0,0(15)
         LD    R0+2,8(15)
*MEXIT #=  2880 LV= 3 LX
*MCALL #=  2881 LV= 3          LX    R1,WORK16
         LA    15,WORK16
         LD    R1,0(15)
         LD    R1+2,8(15)
*MEXIT #=  2881 LV= 3 LX
         CXTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  2882 LV= 3          RT1   CCE
         DS    0H
RT1_TEST161      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE161
         LTORG 
RT1_CCE161      DS 0H
*MEXIT #=  2882 LV= 3 RT1
         B     EXIT124
         LTORG 
EXIT124     DS 0H
*MEXIT #=  2859 LV= 2 TEST1
*MEXIT #=  2858 LV= 1 TEST
*MCALL #=  2883 LV= 1          TEST   LD,=LD'12345678901234567890123456X
               78901234E6111'
*MCALL #=  2884 LV= 2          TEST1 SVC,LD,=LD'12345678901234567890123X
               45678901234E6111'
         BASR  R12,0
         USING *,R12
*MCALL #=  2885 LV= 3          CTD   CTD_LD,IN==LD'12345678901234567890X
               12345678901234E6111',OUT=DECIMAL,LINKAGE=SVC
         LA    1,=A(CTD_LD,0,DECIMAL)
         LA    0,=LD'1234567890123456789012345678901234E6111'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2885 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LD'
         MVC   DHEX,=CL32' '
         LA    R2,=LD'1234567890123456789012345678901234E6111'
         LA    R3,L'=LD'1234567890123456789012345678901234E6111'
*MCALL #=  2886 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2887 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2887 LV= 4 ZCALL
*MEXIT #=  2886 LV= 3 CALL
*MCALL #=  2888 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2888 LV= 3 WTO
*MCALL #=  2889 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2890 LV= 4          ZSTREQU 
*MEXIT #=  2890 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_249_2
*MEXIT #=  2889 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2891 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2891 LV= 3 WTO
*MCALL #=  2892 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2892 LV= 3 ABEND
*MCALL #=  2893 LV= 3          ENDIF 
*MCALL #=  2894 LV= 4          ZSTREQU 
*MEXIT #=  2894 LV= 4 ZSTREQU
#@IF_249_2                                               DS 0H
*MEXIT #=  2893 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2895 LV= 3          CFD   CFD_LD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2895 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LD'1234567890123456789012345678901234E6111'
*MCALL #=  2896 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2897 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2897 LV= 4 ZCALL
*MEXIT #=  2896 LV= 3 CALL
*MCALL #=  2898 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2898 LV= 3 WTO
*MCALL #=  2899 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2900 LV= 4          ZSTREQU 
*MEXIT #=  2900 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_250_2
*MEXIT #=  2899 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2901 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2901 LV= 3 WTO
*MCALL #=  2902 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2902 LV= 3 ABEND
*MCALL #=  2903 LV= 3          ENDIF 
*MCALL #=  2904 LV= 4          ZSTREQU 
*MEXIT #=  2904 LV= 4 ZSTREQU
#@IF_250_2                                               DS 0H
*MEXIT #=  2903 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
*MCALL #=  2905 LV= 3          LX    R0,=LD'123456789012345678901234567X
               8901234E6111'
         LA    15,=LD'1234567890123456789012345678901234E6111'
         LD    R0,0(15)
         LD    R0+2,8(15)
*MEXIT #=  2905 LV= 3 LX
*MCALL #=  2906 LV= 3          LX    R1,WORK16
         LA    15,WORK16
         LD    R1,0(15)
         LD    R1+2,8(15)
*MEXIT #=  2906 LV= 3 LX
         CXTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  2907 LV= 3          RT1   CCE
         DS    0H
RT1_TEST162      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE162
         LTORG 
RT1_CCE162      DS 0H
*MEXIT #=  2907 LV= 3 RT1
         B     EXIT125
         LTORG 
EXIT125     DS 0H
*MEXIT #=  2884 LV= 2 TEST1
*MEXIT #=  2883 LV= 1 TEST
*MCALL #=  2908 LV= 1          TEST   LD,=LD'99999999999999999999999999X
               99999999E6111'
*MCALL #=  2909 LV= 2          TEST1 SVC,LD,=LD'99999999999999999999999X
               99999999999E6111'
         BASR  R12,0
         USING *,R12
*MCALL #=  2910 LV= 3          CTD   CTD_LD,IN==LD'99999999999999999999X
               99999999999999E6111',OUT=DECIMAL,LINKAGE=SVC
         LA    1,=A(CTD_LD,0,DECIMAL)
         LA    0,=LD'9999999999999999999999999999999999E6111'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2910 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LD'
         MVC   DHEX,=CL32' '
         LA    R2,=LD'9999999999999999999999999999999999E6111'
         LA    R3,L'=LD'9999999999999999999999999999999999E6111'
*MCALL #=  2911 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2912 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2912 LV= 4 ZCALL
*MEXIT #=  2911 LV= 3 CALL
*MCALL #=  2913 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2913 LV= 3 WTO
*MCALL #=  2914 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2915 LV= 4          ZSTREQU 
*MEXIT #=  2915 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_251_2
*MEXIT #=  2914 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2916 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2916 LV= 3 WTO
*MCALL #=  2917 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2917 LV= 3 ABEND
*MCALL #=  2918 LV= 3          ENDIF 
*MCALL #=  2919 LV= 4          ZSTREQU 
*MEXIT #=  2919 LV= 4 ZSTREQU
#@IF_251_2                                               DS 0H
*MEXIT #=  2918 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2920 LV= 3          CFD   CFD_LD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2920 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LD'9999999999999999999999999999999999E6111'
*MCALL #=  2921 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2922 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2922 LV= 4 ZCALL
*MEXIT #=  2921 LV= 3 CALL
*MCALL #=  2923 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2923 LV= 3 WTO
*MCALL #=  2924 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2925 LV= 4          ZSTREQU 
*MEXIT #=  2925 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_252_2
*MEXIT #=  2924 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2926 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2926 LV= 3 WTO
*MCALL #=  2927 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2927 LV= 3 ABEND
*MCALL #=  2928 LV= 3          ENDIF 
*MCALL #=  2929 LV= 4          ZSTREQU 
*MEXIT #=  2929 LV= 4 ZSTREQU
#@IF_252_2                                               DS 0H
*MEXIT #=  2928 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
*MCALL #=  2930 LV= 3          LX    R0,=LD'999999999999999999999999999X
               9999999E6111'
         LA    15,=LD'9999999999999999999999999999999999E6111'
         LD    R0,0(15)
         LD    R0+2,8(15)
*MEXIT #=  2930 LV= 3 LX
*MCALL #=  2931 LV= 3          LX    R1,WORK16
         LA    15,WORK16
         LD    R1,0(15)
         LD    R1+2,8(15)
*MEXIT #=  2931 LV= 3 LX
         CXTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  2932 LV= 3          RT1   CCE
         DS    0H
RT1_TEST163      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE163
         LTORG 
RT1_CCE163      DS 0H
*MEXIT #=  2932 LV= 3 RT1
         B     EXIT126
         LTORG 
EXIT126     DS 0H
*MEXIT #=  2909 LV= 2 TEST1
*MEXIT #=  2908 LV= 1 TEST
*MCALL #=  2933 LV= 1          TEST   LD,=LD'1E6111'
*MCALL #=  2934 LV= 2          TEST1 SVC,LD,=LD'1E6111'
         BASR  R12,0
         USING *,R12
*MCALL #=  2935 LV= 3          CTD   CTD_LD,IN==LD'1E6111',OUT=DECIMAL,X
               LINKAGE=SVC
         LA    1,=A(CTD_LD,0,DECIMAL)
         LA    0,=LD'1E6111'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2935 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LD'
         MVC   DHEX,=CL32' '
         LA    R2,=LD'1E6111'
         LA    R3,L'=LD'1E6111'
*MCALL #=  2936 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2937 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2937 LV= 4 ZCALL
*MEXIT #=  2936 LV= 3 CALL
*MCALL #=  2938 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2938 LV= 3 WTO
*MCALL #=  2939 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2940 LV= 4          ZSTREQU 
*MEXIT #=  2940 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_253_2
*MEXIT #=  2939 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2941 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2941 LV= 3 WTO
*MCALL #=  2942 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2942 LV= 3 ABEND
*MCALL #=  2943 LV= 3          ENDIF 
*MCALL #=  2944 LV= 4          ZSTREQU 
*MEXIT #=  2944 LV= 4 ZSTREQU
#@IF_253_2                                               DS 0H
*MEXIT #=  2943 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2945 LV= 3          CFD   CFD_LD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2945 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LD'1E6111'
*MCALL #=  2946 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2947 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2947 LV= 4 ZCALL
*MEXIT #=  2946 LV= 3 CALL
*MCALL #=  2948 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2948 LV= 3 WTO
*MCALL #=  2949 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2950 LV= 4          ZSTREQU 
*MEXIT #=  2950 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_254_2
*MEXIT #=  2949 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2951 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2951 LV= 3 WTO
*MCALL #=  2952 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2952 LV= 3 ABEND
*MCALL #=  2953 LV= 3          ENDIF 
*MCALL #=  2954 LV= 4          ZSTREQU 
*MEXIT #=  2954 LV= 4 ZSTREQU
#@IF_254_2                                               DS 0H
*MEXIT #=  2953 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
*MCALL #=  2955 LV= 3          LX    R0,=LD'1E6111'
         LA    15,=LD'1E6111'
         LD    R0,0(15)
         LD    R0+2,8(15)
*MEXIT #=  2955 LV= 3 LX
*MCALL #=  2956 LV= 3          LX    R1,WORK16
         LA    15,WORK16
         LD    R1,0(15)
         LD    R1+2,8(15)
*MEXIT #=  2956 LV= 3 LX
         CXTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  2957 LV= 3          RT1   CCE
         DS    0H
RT1_TEST164      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE164
         LTORG 
RT1_CCE164      DS 0H
*MEXIT #=  2957 LV= 3 RT1
         B     EXIT127
         LTORG 
EXIT127     DS 0H
*MEXIT #=  2934 LV= 2 TEST1
*MEXIT #=  2933 LV= 1 TEST
*MCALL #=  2958 LV= 1          TEST   LD,=LD'-1'
*MCALL #=  2959 LV= 2          TEST1 SVC,LD,=LD'-1'
         BASR  R12,0
         USING *,R12
*MCALL #=  2960 LV= 3          CTD   CTD_LD,IN==LD'-1',OUT=DECIMAL,LINKX
               AGE=SVC
         LA    1,=A(CTD_LD,0,DECIMAL)
         LA    0,=LD'-1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2960 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LD'
         MVC   DHEX,=CL32' '
         LA    R2,=LD'-1'
         LA    R3,L'=LD'-1'
*MCALL #=  2961 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2962 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2962 LV= 4 ZCALL
*MEXIT #=  2961 LV= 3 CALL
*MCALL #=  2963 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2963 LV= 3 WTO
*MCALL #=  2964 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2965 LV= 4          ZSTREQU 
*MEXIT #=  2965 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_255_2
*MEXIT #=  2964 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2966 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2966 LV= 3 WTO
*MCALL #=  2967 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2967 LV= 3 ABEND
*MCALL #=  2968 LV= 3          ENDIF 
*MCALL #=  2969 LV= 4          ZSTREQU 
*MEXIT #=  2969 LV= 4 ZSTREQU
#@IF_255_2                                               DS 0H
*MEXIT #=  2968 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2970 LV= 3          CFD   CFD_LD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2970 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LD'-1'
*MCALL #=  2971 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2972 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2972 LV= 4 ZCALL
*MEXIT #=  2971 LV= 3 CALL
*MCALL #=  2973 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2973 LV= 3 WTO
*MCALL #=  2974 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2975 LV= 4          ZSTREQU 
*MEXIT #=  2975 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_256_2
*MEXIT #=  2974 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2976 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2976 LV= 3 WTO
*MCALL #=  2977 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2977 LV= 3 ABEND
*MCALL #=  2978 LV= 3          ENDIF 
*MCALL #=  2979 LV= 4          ZSTREQU 
*MEXIT #=  2979 LV= 4 ZSTREQU
#@IF_256_2                                               DS 0H
*MEXIT #=  2978 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
*MCALL #=  2980 LV= 3          LX    R0,=LD'-1'
         LA    15,=LD'-1'
         LD    R0,0(15)
         LD    R0+2,8(15)
*MEXIT #=  2980 LV= 3 LX
*MCALL #=  2981 LV= 3          LX    R1,WORK16
         LA    15,WORK16
         LD    R1,0(15)
         LD    R1+2,8(15)
*MEXIT #=  2981 LV= 3 LX
         CXTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  2982 LV= 3          RT1   CCE
         DS    0H
RT1_TEST165      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE165
         LTORG 
RT1_CCE165      DS 0H
*MEXIT #=  2982 LV= 3 RT1
         B     EXIT128
         LTORG 
EXIT128     DS 0H
*MEXIT #=  2959 LV= 2 TEST1
*MEXIT #=  2958 LV= 1 TEST
*MCALL #=  2983 LV= 1          TEST   LD,=LD'-2'
*MCALL #=  2984 LV= 2          TEST1 SVC,LD,=LD'-2'
         BASR  R12,0
         USING *,R12
*MCALL #=  2985 LV= 3          CTD   CTD_LD,IN==LD'-2',OUT=DECIMAL,LINKX
               AGE=SVC
         LA    1,=A(CTD_LD,0,DECIMAL)
         LA    0,=LD'-2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  2985 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LD'
         MVC   DHEX,=CL32' '
         LA    R2,=LD'-2'
         LA    R3,L'=LD'-2'
*MCALL #=  2986 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  2987 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2987 LV= 4 ZCALL
*MEXIT #=  2986 LV= 3 CALL
*MCALL #=  2988 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2988 LV= 3 WTO
*MCALL #=  2989 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  2990 LV= 4          ZSTREQU 
*MEXIT #=  2990 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_257_2
*MEXIT #=  2989 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  2991 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  2991 LV= 3 WTO
*MCALL #=  2992 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  2992 LV= 3 ABEND
*MCALL #=  2993 LV= 3          ENDIF 
*MCALL #=  2994 LV= 4          ZSTREQU 
*MEXIT #=  2994 LV= 4 ZSTREQU
#@IF_257_2                                               DS 0H
*MEXIT #=  2993 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  2995 LV= 3          CFD   CFD_LD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  2995 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LD'-2'
*MCALL #=  2996 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  2997 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  2997 LV= 4 ZCALL
*MEXIT #=  2996 LV= 3 CALL
*MCALL #=  2998 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  2998 LV= 3 WTO
*MCALL #=  2999 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3000 LV= 4          ZSTREQU 
*MEXIT #=  3000 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_258_2
*MEXIT #=  2999 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3001 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3001 LV= 3 WTO
*MCALL #=  3002 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3002 LV= 3 ABEND
*MCALL #=  3003 LV= 3          ENDIF 
*MCALL #=  3004 LV= 4          ZSTREQU 
*MEXIT #=  3004 LV= 4 ZSTREQU
#@IF_258_2                                               DS 0H
*MEXIT #=  3003 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
*MCALL #=  3005 LV= 3          LX    R0,=LD'-2'
         LA    15,=LD'-2'
         LD    R0,0(15)
         LD    R0+2,8(15)
*MEXIT #=  3005 LV= 3 LX
*MCALL #=  3006 LV= 3          LX    R1,WORK16
         LA    15,WORK16
         LD    R1,0(15)
         LD    R1+2,8(15)
*MEXIT #=  3006 LV= 3 LX
         CXTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  3007 LV= 3          RT1   CCE
         DS    0H
RT1_TEST166      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE166
         LTORG 
RT1_CCE166      DS 0H
*MEXIT #=  3007 LV= 3 RT1
         B     EXIT129
         LTORG 
EXIT129     DS 0H
*MEXIT #=  2984 LV= 2 TEST1
*MEXIT #=  2983 LV= 1 TEST
*MCALL #=  3008 LV= 1          TEST   LD,=LD'-1E2'
*MCALL #=  3009 LV= 2          TEST1 SVC,LD,=LD'-1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=  3010 LV= 3          CTD   CTD_LD,IN==LD'-1E2',OUT=DECIMAL,LIX
               NKAGE=SVC
         LA    1,=A(CTD_LD,0,DECIMAL)
         LA    0,=LD'-1E2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3010 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LD'
         MVC   DHEX,=CL32' '
         LA    R2,=LD'-1E2'
         LA    R3,L'=LD'-1E2'
*MCALL #=  3011 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3012 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3012 LV= 4 ZCALL
*MEXIT #=  3011 LV= 3 CALL
*MCALL #=  3013 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3013 LV= 3 WTO
*MCALL #=  3014 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3015 LV= 4          ZSTREQU 
*MEXIT #=  3015 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_259_2
*MEXIT #=  3014 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3016 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3016 LV= 3 WTO
*MCALL #=  3017 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3017 LV= 3 ABEND
*MCALL #=  3018 LV= 3          ENDIF 
*MCALL #=  3019 LV= 4          ZSTREQU 
*MEXIT #=  3019 LV= 4 ZSTREQU
#@IF_259_2                                               DS 0H
*MEXIT #=  3018 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3020 LV= 3          CFD   CFD_LD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3020 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LD'-1E2'
*MCALL #=  3021 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3022 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3022 LV= 4 ZCALL
*MEXIT #=  3021 LV= 3 CALL
*MCALL #=  3023 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3023 LV= 3 WTO
*MCALL #=  3024 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3025 LV= 4          ZSTREQU 
*MEXIT #=  3025 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_260_2
*MEXIT #=  3024 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3026 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3026 LV= 3 WTO
*MCALL #=  3027 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3027 LV= 3 ABEND
*MCALL #=  3028 LV= 3          ENDIF 
*MCALL #=  3029 LV= 4          ZSTREQU 
*MEXIT #=  3029 LV= 4 ZSTREQU
#@IF_260_2                                               DS 0H
*MEXIT #=  3028 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
*MCALL #=  3030 LV= 3          LX    R0,=LD'-1E2'
         LA    15,=LD'-1E2'
         LD    R0,0(15)
         LD    R0+2,8(15)
*MEXIT #=  3030 LV= 3 LX
*MCALL #=  3031 LV= 3          LX    R1,WORK16
         LA    15,WORK16
         LD    R1,0(15)
         LD    R1+2,8(15)
*MEXIT #=  3031 LV= 3 LX
         CXTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  3032 LV= 3          RT1   CCE
         DS    0H
RT1_TEST167      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE167
         LTORG 
RT1_CCE167      DS 0H
*MEXIT #=  3032 LV= 3 RT1
         B     EXIT130
         LTORG 
EXIT130     DS 0H
*MEXIT #=  3009 LV= 2 TEST1
*MEXIT #=  3008 LV= 1 TEST
*MCALL #=  3033 LV= 1          TEST   LD,LDT1 TEST VALUE FOR FPCONVRT
*MCALL #=  3034 LV= 2          TEST1 SVC,LD,LDT1
         BASR  R12,0
         USING *,R12
*MCALL #=  3035 LV= 3          CTD   CTD_LD,IN=LDT1,OUT=DECIMAL,LINKAGEX
               =SVC
         LA    1,=A(CTD_LD,LDT1,DECIMAL)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3035 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LD'
         MVC   DHEX,=CL32' '
         LA    R2,LDT1
         LA    R3,L'LDT1
*MCALL #=  3036 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3037 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3037 LV= 4 ZCALL
*MEXIT #=  3036 LV= 3 CALL
*MCALL #=  3038 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3038 LV= 3 WTO
*MCALL #=  3039 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3040 LV= 4          ZSTREQU 
*MEXIT #=  3040 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_261_2
*MEXIT #=  3039 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3041 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3041 LV= 3 WTO
*MCALL #=  3042 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3042 LV= 3 ABEND
*MCALL #=  3043 LV= 3          ENDIF 
*MCALL #=  3044 LV= 4          ZSTREQU 
*MEXIT #=  3044 LV= 4 ZSTREQU
#@IF_261_2                                               DS 0H
*MEXIT #=  3043 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3045 LV= 3          CFD   CFD_LD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3045 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LD'
         MVC   DHEX,=CL32' '
         LA    R3,L'LDT1
*MCALL #=  3046 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3047 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3047 LV= 4 ZCALL
*MEXIT #=  3046 LV= 3 CALL
*MCALL #=  3048 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3048 LV= 3 WTO
*MCALL #=  3049 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3050 LV= 4          ZSTREQU 
*MEXIT #=  3050 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_262_2
*MEXIT #=  3049 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3051 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3051 LV= 3 WTO
*MCALL #=  3052 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3052 LV= 3 ABEND
*MCALL #=  3053 LV= 3          ENDIF 
*MCALL #=  3054 LV= 4          ZSTREQU 
*MEXIT #=  3054 LV= 4 ZSTREQU
#@IF_262_2                                               DS 0H
*MEXIT #=  3053 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
*MCALL #=  3055 LV= 3          LX    R0,LDT1
         LA    15,LDT1
         LD    R0,0(15)
         LD    R0+2,8(15)
*MEXIT #=  3055 LV= 3 LX
*MCALL #=  3056 LV= 3          LX    R1,WORK16
         LA    15,WORK16
         LD    R1,0(15)
         LD    R1+2,8(15)
*MEXIT #=  3056 LV= 3 LX
         CXTR  R0,R1
* RPI 786 START TEST FOR DFP
*MCALL #=  3057 LV= 3          RT1   CCE
         DS    0H
RT1_TEST168      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE168
         LTORG 
RT1_CCE168      DS 0H
*MEXIT #=  3057 LV= 3 RT1
         B     EXIT131
         LTORG 
EXIT131     DS 0H
*MEXIT #=  3034 LV= 2 TEST1
*MEXIT #=  3033 LV= 1 TEST
* LH
*MCALL #=  3058 LV= 1          TEST   LH,=LH'0'
*MCALL #=  3059 LV= 2          TEST1 SVC,LH,=LH'0'
         BASR  R12,0
         USING *,R12
*MCALL #=  3060 LV= 3          CTD   CTD_LH,IN==LH'0',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_LH,0,DECIMAL)
         LA    0,=LH'0'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3060 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LH'
         MVC   DHEX,=CL32' '
         LA    R2,=LH'0'
         LA    R3,L'=LH'0'
*MCALL #=  3061 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3062 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3062 LV= 4 ZCALL
*MEXIT #=  3061 LV= 3 CALL
*MCALL #=  3063 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3063 LV= 3 WTO
*MCALL #=  3064 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3065 LV= 4          ZSTREQU 
*MEXIT #=  3065 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_263_2
*MEXIT #=  3064 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3066 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3066 LV= 3 WTO
*MCALL #=  3067 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3067 LV= 3 ABEND
*MCALL #=  3068 LV= 3          ENDIF 
*MCALL #=  3069 LV= 4          ZSTREQU 
*MEXIT #=  3069 LV= 4 ZSTREQU
#@IF_263_2                                               DS 0H
*MEXIT #=  3068 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3070 LV= 3          CFD   CFD_LH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3070 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LH'0'
*MCALL #=  3071 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3072 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3072 LV= 4 ZCALL
*MEXIT #=  3071 LV= 3 CALL
*MCALL #=  3073 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3073 LV= 3 WTO
*MCALL #=  3074 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3075 LV= 4          ZSTREQU 
*MEXIT #=  3075 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_264_2
*MEXIT #=  3074 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3076 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3076 LV= 3 WTO
*MCALL #=  3077 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3077 LV= 3 ABEND
*MCALL #=  3078 LV= 3          ENDIF 
*MCALL #=  3079 LV= 4          ZSTREQU 
*MEXIT #=  3079 LV= 4 ZSTREQU
#@IF_264_2                                               DS 0H
*MEXIT #=  3078 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=LH'0'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=LH'0'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  3080 LV= 3          RT1   CCE
         DS    0H
RT1_TEST169      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE169
         LTORG 
RT1_CCE169      DS 0H
*MEXIT #=  3080 LV= 3 RT1
         B     EXIT132
         LTORG 
EXIT132     DS 0H
*MEXIT #=  3059 LV= 2 TEST1
*MEXIT #=  3058 LV= 1 TEST
*MCALL #=  3081 LV= 1          TEST   LH,=LH'3E-78' 1E-78 CAUSES 1 BIT X
               ROUNDING ERROR
*MCALL #=  3082 LV= 2          TEST1 SVC,LH,=LH'3E-78'
         BASR  R12,0
         USING *,R12
*MCALL #=  3083 LV= 3          CTD   CTD_LH,IN==LH'3E-78',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_LH,0,DECIMAL)
         LA    0,=LH'3E-78'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3083 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LH'
         MVC   DHEX,=CL32' '
         LA    R2,=LH'3E-78'
         LA    R3,L'=LH'3E-78'
*MCALL #=  3084 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3085 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3085 LV= 4 ZCALL
*MEXIT #=  3084 LV= 3 CALL
*MCALL #=  3086 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3086 LV= 3 WTO
*MCALL #=  3087 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3088 LV= 4          ZSTREQU 
*MEXIT #=  3088 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_265_2
*MEXIT #=  3087 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3089 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3089 LV= 3 WTO
*MCALL #=  3090 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3090 LV= 3 ABEND
*MCALL #=  3091 LV= 3          ENDIF 
*MCALL #=  3092 LV= 4          ZSTREQU 
*MEXIT #=  3092 LV= 4 ZSTREQU
#@IF_265_2                                               DS 0H
*MEXIT #=  3091 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3093 LV= 3          CFD   CFD_LH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3093 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LH'3E-78'
*MCALL #=  3094 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3095 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3095 LV= 4 ZCALL
*MEXIT #=  3094 LV= 3 CALL
*MCALL #=  3096 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3096 LV= 3 WTO
*MCALL #=  3097 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3098 LV= 4          ZSTREQU 
*MEXIT #=  3098 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_266_2
*MEXIT #=  3097 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3099 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3099 LV= 3 WTO
*MCALL #=  3100 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3100 LV= 3 ABEND
*MCALL #=  3101 LV= 3          ENDIF 
*MCALL #=  3102 LV= 4          ZSTREQU 
*MEXIT #=  3102 LV= 4 ZSTREQU
#@IF_266_2                                               DS 0H
*MEXIT #=  3101 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=LH'3E-78'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=LH'3E-78'  VERIFY CTD CONSTANT WITH CFD RESULX
               T
* RPI 786 START TEST FOR DFP
*MCALL #=  3103 LV= 3          RT1   CCE
         DS    0H
RT1_TEST170      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE170
         LTORG 
RT1_CCE170      DS 0H
*MEXIT #=  3103 LV= 3 RT1
         B     EXIT133
         LTORG 
EXIT133     DS 0H
*MEXIT #=  3082 LV= 2 TEST1
*MEXIT #=  3081 LV= 1 TEST
*MCALL #=  3104 LV= 1          TEST   LH,=LH'1'
*MCALL #=  3105 LV= 2          TEST1 SVC,LH,=LH'1'
         BASR  R12,0
         USING *,R12
*MCALL #=  3106 LV= 3          CTD   CTD_LH,IN==LH'1',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_LH,0,DECIMAL)
         LA    0,=LH'1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3106 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LH'
         MVC   DHEX,=CL32' '
         LA    R2,=LH'1'
         LA    R3,L'=LH'1'
*MCALL #=  3107 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3108 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3108 LV= 4 ZCALL
*MEXIT #=  3107 LV= 3 CALL
*MCALL #=  3109 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3109 LV= 3 WTO
*MCALL #=  3110 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3111 LV= 4          ZSTREQU 
*MEXIT #=  3111 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_267_2
*MEXIT #=  3110 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3112 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3112 LV= 3 WTO
*MCALL #=  3113 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3113 LV= 3 ABEND
*MCALL #=  3114 LV= 3          ENDIF 
*MCALL #=  3115 LV= 4          ZSTREQU 
*MEXIT #=  3115 LV= 4 ZSTREQU
#@IF_267_2                                               DS 0H
*MEXIT #=  3114 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3116 LV= 3          CFD   CFD_LH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3116 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LH'1'
*MCALL #=  3117 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3118 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3118 LV= 4 ZCALL
*MEXIT #=  3117 LV= 3 CALL
*MCALL #=  3119 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3119 LV= 3 WTO
*MCALL #=  3120 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3121 LV= 4          ZSTREQU 
*MEXIT #=  3121 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_268_2
*MEXIT #=  3120 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3122 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3122 LV= 3 WTO
*MCALL #=  3123 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3123 LV= 3 ABEND
*MCALL #=  3124 LV= 3          ENDIF 
*MCALL #=  3125 LV= 4          ZSTREQU 
*MEXIT #=  3125 LV= 4 ZSTREQU
#@IF_268_2                                               DS 0H
*MEXIT #=  3124 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=LH'1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=LH'1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  3126 LV= 3          RT1   CCE
         DS    0H
RT1_TEST171      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE171
         LTORG 
RT1_CCE171      DS 0H
*MEXIT #=  3126 LV= 3 RT1
         B     EXIT134
         LTORG 
EXIT134     DS 0H
*MEXIT #=  3105 LV= 2 TEST1
*MEXIT #=  3104 LV= 1 TEST
*MCALL #=  3127 LV= 1          TEST   LH,=LH'2'
*MCALL #=  3128 LV= 2          TEST1 SVC,LH,=LH'2'
         BASR  R12,0
         USING *,R12
*MCALL #=  3129 LV= 3          CTD   CTD_LH,IN==LH'2',OUT=DECIMAL,LINKAX
               GE=SVC
         LA    1,=A(CTD_LH,0,DECIMAL)
         LA    0,=LH'2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3129 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LH'
         MVC   DHEX,=CL32' '
         LA    R2,=LH'2'
         LA    R3,L'=LH'2'
*MCALL #=  3130 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3131 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3131 LV= 4 ZCALL
*MEXIT #=  3130 LV= 3 CALL
*MCALL #=  3132 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3132 LV= 3 WTO
*MCALL #=  3133 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3134 LV= 4          ZSTREQU 
*MEXIT #=  3134 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_269_2
*MEXIT #=  3133 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3135 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3135 LV= 3 WTO
*MCALL #=  3136 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3136 LV= 3 ABEND
*MCALL #=  3137 LV= 3          ENDIF 
*MCALL #=  3138 LV= 4          ZSTREQU 
*MEXIT #=  3138 LV= 4 ZSTREQU
#@IF_269_2                                               DS 0H
*MEXIT #=  3137 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3139 LV= 3          CFD   CFD_LH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3139 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LH'2'
*MCALL #=  3140 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3141 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3141 LV= 4 ZCALL
*MEXIT #=  3140 LV= 3 CALL
*MCALL #=  3142 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3142 LV= 3 WTO
*MCALL #=  3143 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3144 LV= 4          ZSTREQU 
*MEXIT #=  3144 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_270_2
*MEXIT #=  3143 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3145 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3145 LV= 3 WTO
*MCALL #=  3146 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3146 LV= 3 ABEND
*MCALL #=  3147 LV= 3          ENDIF 
*MCALL #=  3148 LV= 4          ZSTREQU 
*MEXIT #=  3148 LV= 4 ZSTREQU
#@IF_270_2                                               DS 0H
*MEXIT #=  3147 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=LH'2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=LH'2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  3149 LV= 3          RT1   CCE
         DS    0H
RT1_TEST172      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE172
         LTORG 
RT1_CCE172      DS 0H
*MEXIT #=  3149 LV= 3 RT1
         B     EXIT135
         LTORG 
EXIT135     DS 0H
*MEXIT #=  3128 LV= 2 TEST1
*MEXIT #=  3127 LV= 1 TEST
*MCALL #=  3150 LV= 1          TEST   LH,=LH'1E2'
*MCALL #=  3151 LV= 2          TEST1 SVC,LH,=LH'1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=  3152 LV= 3          CTD   CTD_LH,IN==LH'1E2',OUT=DECIMAL,LINX
               KAGE=SVC
         LA    1,=A(CTD_LH,0,DECIMAL)
         LA    0,=LH'1E2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3152 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LH'
         MVC   DHEX,=CL32' '
         LA    R2,=LH'1E2'
         LA    R3,L'=LH'1E2'
*MCALL #=  3153 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3154 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3154 LV= 4 ZCALL
*MEXIT #=  3153 LV= 3 CALL
*MCALL #=  3155 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3155 LV= 3 WTO
*MCALL #=  3156 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3157 LV= 4          ZSTREQU 
*MEXIT #=  3157 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_271_2
*MEXIT #=  3156 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3158 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3158 LV= 3 WTO
*MCALL #=  3159 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3159 LV= 3 ABEND
*MCALL #=  3160 LV= 3          ENDIF 
*MCALL #=  3161 LV= 4          ZSTREQU 
*MEXIT #=  3161 LV= 4 ZSTREQU
#@IF_271_2                                               DS 0H
*MEXIT #=  3160 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3162 LV= 3          CFD   CFD_LH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3162 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LH'1E2'
*MCALL #=  3163 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3164 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3164 LV= 4 ZCALL
*MEXIT #=  3163 LV= 3 CALL
*MCALL #=  3165 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3165 LV= 3 WTO
*MCALL #=  3166 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3167 LV= 4          ZSTREQU 
*MEXIT #=  3167 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_272_2
*MEXIT #=  3166 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3168 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3168 LV= 3 WTO
*MCALL #=  3169 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3169 LV= 3 ABEND
*MCALL #=  3170 LV= 3          ENDIF 
*MCALL #=  3171 LV= 4          ZSTREQU 
*MEXIT #=  3171 LV= 4 ZSTREQU
#@IF_272_2                                               DS 0H
*MEXIT #=  3170 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=LH'1E2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=LH'1E2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  3172 LV= 3          RT1   CCE
         DS    0H
RT1_TEST173      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE173
         LTORG 
RT1_CCE173      DS 0H
*MEXIT #=  3172 LV= 3 RT1
         B     EXIT136
         LTORG 
EXIT136     DS 0H
*MEXIT #=  3151 LV= 2 TEST1
*MEXIT #=  3150 LV= 1 TEST
*MCALL #=  3173 LV= 1          TEST   LH,=LH'2E75'  1E75 CAUSES 1 BIT RX
               OUNDING ERROR
*MCALL #=  3174 LV= 2          TEST1 SVC,LH,=LH'2E75'
         BASR  R12,0
         USING *,R12
*MCALL #=  3175 LV= 3          CTD   CTD_LH,IN==LH'2E75',OUT=DECIMAL,LIX
               NKAGE=SVC
         LA    1,=A(CTD_LH,0,DECIMAL)
         LA    0,=LH'2E75'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3175 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LH'
         MVC   DHEX,=CL32' '
         LA    R2,=LH'2E75'
         LA    R3,L'=LH'2E75'
*MCALL #=  3176 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3177 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3177 LV= 4 ZCALL
*MEXIT #=  3176 LV= 3 CALL
*MCALL #=  3178 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3178 LV= 3 WTO
*MCALL #=  3179 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3180 LV= 4          ZSTREQU 
*MEXIT #=  3180 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_273_2
*MEXIT #=  3179 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3181 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3181 LV= 3 WTO
*MCALL #=  3182 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3182 LV= 3 ABEND
*MCALL #=  3183 LV= 3          ENDIF 
*MCALL #=  3184 LV= 4          ZSTREQU 
*MEXIT #=  3184 LV= 4 ZSTREQU
#@IF_273_2                                               DS 0H
*MEXIT #=  3183 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3185 LV= 3          CFD   CFD_LH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3185 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LH'2E75'
*MCALL #=  3186 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3187 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3187 LV= 4 ZCALL
*MEXIT #=  3186 LV= 3 CALL
*MCALL #=  3188 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3188 LV= 3 WTO
*MCALL #=  3189 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3190 LV= 4          ZSTREQU 
*MEXIT #=  3190 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_274_2
*MEXIT #=  3189 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3191 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3191 LV= 3 WTO
*MCALL #=  3192 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3192 LV= 3 ABEND
*MCALL #=  3193 LV= 3          ENDIF 
*MCALL #=  3194 LV= 4          ZSTREQU 
*MEXIT #=  3194 LV= 4 ZSTREQU
#@IF_274_2                                               DS 0H
*MEXIT #=  3193 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=LH'2E75'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=LH'2E75'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  3195 LV= 3          RT1   CCE
         DS    0H
RT1_TEST174      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE174
         LTORG 
RT1_CCE174      DS 0H
*MEXIT #=  3195 LV= 3 RT1
         B     EXIT137
         LTORG 
EXIT137     DS 0H
*MEXIT #=  3174 LV= 2 TEST1
*MEXIT #=  3173 LV= 1 TEST
*MCALL #=  3196 LV= 1          TEST   LH,=LH'-1'
*MCALL #=  3197 LV= 2          TEST1 SVC,LH,=LH'-1'
         BASR  R12,0
         USING *,R12
*MCALL #=  3198 LV= 3          CTD   CTD_LH,IN==LH'-1',OUT=DECIMAL,LINKX
               AGE=SVC
         LA    1,=A(CTD_LH,0,DECIMAL)
         LA    0,=LH'-1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3198 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LH'
         MVC   DHEX,=CL32' '
         LA    R2,=LH'-1'
         LA    R3,L'=LH'-1'
*MCALL #=  3199 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3200 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3200 LV= 4 ZCALL
*MEXIT #=  3199 LV= 3 CALL
*MCALL #=  3201 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3201 LV= 3 WTO
*MCALL #=  3202 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3203 LV= 4          ZSTREQU 
*MEXIT #=  3203 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_275_2
*MEXIT #=  3202 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3204 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3204 LV= 3 WTO
*MCALL #=  3205 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3205 LV= 3 ABEND
*MCALL #=  3206 LV= 3          ENDIF 
*MCALL #=  3207 LV= 4          ZSTREQU 
*MEXIT #=  3207 LV= 4 ZSTREQU
#@IF_275_2                                               DS 0H
*MEXIT #=  3206 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3208 LV= 3          CFD   CFD_LH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3208 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LH'-1'
*MCALL #=  3209 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3210 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3210 LV= 4 ZCALL
*MEXIT #=  3209 LV= 3 CALL
*MCALL #=  3211 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3211 LV= 3 WTO
*MCALL #=  3212 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3213 LV= 4          ZSTREQU 
*MEXIT #=  3213 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_276_2
*MEXIT #=  3212 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3214 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3214 LV= 3 WTO
*MCALL #=  3215 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3215 LV= 3 ABEND
*MCALL #=  3216 LV= 3          ENDIF 
*MCALL #=  3217 LV= 4          ZSTREQU 
*MEXIT #=  3217 LV= 4 ZSTREQU
#@IF_276_2                                               DS 0H
*MEXIT #=  3216 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=LH'-1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=LH'-1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  3218 LV= 3          RT1   CCE
         DS    0H
RT1_TEST175      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE175
         LTORG 
RT1_CCE175      DS 0H
*MEXIT #=  3218 LV= 3 RT1
         B     EXIT138
         LTORG 
EXIT138     DS 0H
*MEXIT #=  3197 LV= 2 TEST1
*MEXIT #=  3196 LV= 1 TEST
*MCALL #=  3219 LV= 1          TEST   LH,=LH'-2'
*MCALL #=  3220 LV= 2          TEST1 SVC,LH,=LH'-2'
         BASR  R12,0
         USING *,R12
*MCALL #=  3221 LV= 3          CTD   CTD_LH,IN==LH'-2',OUT=DECIMAL,LINKX
               AGE=SVC
         LA    1,=A(CTD_LH,0,DECIMAL)
         LA    0,=LH'-2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3221 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LH'
         MVC   DHEX,=CL32' '
         LA    R2,=LH'-2'
         LA    R3,L'=LH'-2'
*MCALL #=  3222 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3223 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3223 LV= 4 ZCALL
*MEXIT #=  3222 LV= 3 CALL
*MCALL #=  3224 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3224 LV= 3 WTO
*MCALL #=  3225 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3226 LV= 4          ZSTREQU 
*MEXIT #=  3226 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_277_2
*MEXIT #=  3225 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3227 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3227 LV= 3 WTO
*MCALL #=  3228 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3228 LV= 3 ABEND
*MCALL #=  3229 LV= 3          ENDIF 
*MCALL #=  3230 LV= 4          ZSTREQU 
*MEXIT #=  3230 LV= 4 ZSTREQU
#@IF_277_2                                               DS 0H
*MEXIT #=  3229 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3231 LV= 3          CFD   CFD_LH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3231 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LH'-2'
*MCALL #=  3232 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3233 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3233 LV= 4 ZCALL
*MEXIT #=  3232 LV= 3 CALL
*MCALL #=  3234 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3234 LV= 3 WTO
*MCALL #=  3235 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3236 LV= 4          ZSTREQU 
*MEXIT #=  3236 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_278_2
*MEXIT #=  3235 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3237 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3237 LV= 3 WTO
*MCALL #=  3238 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3238 LV= 3 ABEND
*MCALL #=  3239 LV= 3          ENDIF 
*MCALL #=  3240 LV= 4          ZSTREQU 
*MEXIT #=  3240 LV= 4 ZSTREQU
#@IF_278_2                                               DS 0H
*MEXIT #=  3239 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=LH'-2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=LH'-2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  3241 LV= 3          RT1   CCE
         DS    0H
RT1_TEST176      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE176
         LTORG 
RT1_CCE176      DS 0H
*MEXIT #=  3241 LV= 3 RT1
         B     EXIT139
         LTORG 
EXIT139     DS 0H
*MEXIT #=  3220 LV= 2 TEST1
*MEXIT #=  3219 LV= 1 TEST
*MCALL #=  3242 LV= 1          TEST   LH,=LH'-1E2'
*MCALL #=  3243 LV= 2          TEST1 SVC,LH,=LH'-1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=  3244 LV= 3          CTD   CTD_LH,IN==LH'-1E2',OUT=DECIMAL,LIX
               NKAGE=SVC
         LA    1,=A(CTD_LH,0,DECIMAL)
         LA    0,=LH'-1E2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3244 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LH'
         MVC   DHEX,=CL32' '
         LA    R2,=LH'-1E2'
         LA    R3,L'=LH'-1E2'
*MCALL #=  3245 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3246 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3246 LV= 4 ZCALL
*MEXIT #=  3245 LV= 3 CALL
*MCALL #=  3247 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3247 LV= 3 WTO
*MCALL #=  3248 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3249 LV= 4          ZSTREQU 
*MEXIT #=  3249 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_279_2
*MEXIT #=  3248 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3250 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3250 LV= 3 WTO
*MCALL #=  3251 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3251 LV= 3 ABEND
*MCALL #=  3252 LV= 3          ENDIF 
*MCALL #=  3253 LV= 4          ZSTREQU 
*MEXIT #=  3253 LV= 4 ZSTREQU
#@IF_279_2                                               DS 0H
*MEXIT #=  3252 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3254 LV= 3          CFD   CFD_LH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3254 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LH'-1E2'
*MCALL #=  3255 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3256 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3256 LV= 4 ZCALL
*MEXIT #=  3255 LV= 3 CALL
*MCALL #=  3257 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3257 LV= 3 WTO
*MCALL #=  3258 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3259 LV= 4          ZSTREQU 
*MEXIT #=  3259 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_280_2
*MEXIT #=  3258 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3260 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3260 LV= 3 WTO
*MCALL #=  3261 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3261 LV= 3 ABEND
*MCALL #=  3262 LV= 3          ENDIF 
*MCALL #=  3263 LV= 4          ZSTREQU 
*MEXIT #=  3263 LV= 4 ZSTREQU
#@IF_280_2                                               DS 0H
*MEXIT #=  3262 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=LH'-1E2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=LH'-1E2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  3264 LV= 3          RT1   CCE
         DS    0H
RT1_TEST177      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE177
         LTORG 
RT1_CCE177      DS 0H
*MEXIT #=  3264 LV= 3 RT1
         B     EXIT140
         LTORG 
EXIT140     DS 0H
*MEXIT #=  3243 LV= 2 TEST1
*MEXIT #=  3242 LV= 1 TEST
*MCALL #=  3265 LV= 1          TEST   LH,LHT1 TEST VALUE FOR FPCONVRT
*MCALL #=  3266 LV= 2          TEST1 SVC,LH,LHT1
         BASR  R12,0
         USING *,R12
*MCALL #=  3267 LV= 3          CTD   CTD_LH,IN=LHT1,OUT=DECIMAL,LINKAGEX
               =SVC
         LA    1,=A(CTD_LH,LHT1,DECIMAL)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3267 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LH'
         MVC   DHEX,=CL32' '
         LA    R2,LHT1
         LA    R3,L'LHT1
*MCALL #=  3268 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3269 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3269 LV= 4 ZCALL
*MEXIT #=  3268 LV= 3 CALL
*MCALL #=  3270 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3270 LV= 3 WTO
*MCALL #=  3271 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3272 LV= 4          ZSTREQU 
*MEXIT #=  3272 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_281_2
*MEXIT #=  3271 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3273 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3273 LV= 3 WTO
*MCALL #=  3274 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3274 LV= 3 ABEND
*MCALL #=  3275 LV= 3          ENDIF 
*MCALL #=  3276 LV= 4          ZSTREQU 
*MEXIT #=  3276 LV= 4 ZSTREQU
#@IF_281_2                                               DS 0H
*MEXIT #=  3275 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3277 LV= 3          CFD   CFD_LH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3277 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D LH'
         MVC   DHEX,=CL32' '
         LA    R3,L'LHT1
*MCALL #=  3278 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3279 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3279 LV= 4 ZCALL
*MEXIT #=  3278 LV= 3 CALL
*MCALL #=  3280 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3280 LV= 3 WTO
*MCALL #=  3281 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3282 LV= 4          ZSTREQU 
*MEXIT #=  3282 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_282_2
*MEXIT #=  3281 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3283 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3283 LV= 3 WTO
*MCALL #=  3284 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3284 LV= 3 ABEND
*MCALL #=  3285 LV= 3          ENDIF 
*MCALL #=  3286 LV= 4          ZSTREQU 
*MEXIT #=  3286 LV= 4 ZSTREQU
#@IF_282_2                                               DS 0H
*MEXIT #=  3285 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'LHT1
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),LHT1  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  3287 LV= 3          RT1   CCE
         DS    0H
RT1_TEST178      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE178
         LTORG 
RT1_CCE178      DS 0H
*MEXIT #=  3287 LV= 3 RT1
         B     EXIT141
         LTORG 
EXIT141     DS 0H
*MEXIT #=  3266 LV= 2 TEST1
*MEXIT #=  3265 LV= 1 TEST
* INT128
*MCALL #=  3288 LV= 1          TEST   INT128,=FL16'0'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  3289 LV= 2          TEST1 MF,INT128,=FL16'0'
         BASR  R12,0
         USING *,R12
*MCALL #=  3290 LV= 3          CTD   CTD_INT128,IN==FL16'0',OUT=DECIMALX
               ,LINKAGE=MF
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'0'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3290 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'0'
         LA    R3,L'=FL16'0'
*MCALL #=  3291 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3292 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3292 LV= 4 ZCALL
*MEXIT #=  3291 LV= 3 CALL
*MCALL #=  3293 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3293 LV= 3 WTO
*MCALL #=  3294 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3295 LV= 4          ZSTREQU 
*MEXIT #=  3295 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_283_2
*MEXIT #=  3294 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3296 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3296 LV= 3 WTO
*MCALL #=  3297 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3297 LV= 3 ABEND
*MCALL #=  3298 LV= 3          ENDIF 
*MCALL #=  3299 LV= 4          ZSTREQU 
*MEXIT #=  3299 LV= 4 ZSTREQU
#@IF_283_2                                               DS 0H
*MEXIT #=  3298 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3300 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3300 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'0'
*MCALL #=  3301 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3302 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3302 LV= 4 ZCALL
*MEXIT #=  3301 LV= 3 CALL
*MCALL #=  3303 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3303 LV= 3 WTO
*MCALL #=  3304 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3305 LV= 4          ZSTREQU 
*MEXIT #=  3305 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_284_2
*MEXIT #=  3304 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3306 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3306 LV= 3 WTO
*MCALL #=  3307 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3307 LV= 3 ABEND
*MCALL #=  3308 LV= 3          ENDIF 
*MCALL #=  3309 LV= 4          ZSTREQU 
*MEXIT #=  3309 LV= 4 ZSTREQU
#@IF_284_2                                               DS 0H
*MEXIT #=  3308 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'0'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'0'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  3310 LV= 3          RT1   CCE
         DS    0H
RT1_TEST179      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE179
         LTORG 
RT1_CCE179      DS 0H
*MEXIT #=  3310 LV= 3 RT1
         B     EXIT142
         LTORG 
EXIT142     DS 0H
*MEXIT #=  3289 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  3311 LV= 2          TEST1 SVC,INT128,=FL16'0'
         BASR  R12,0
         USING *,R12
*MCALL #=  3312 LV= 3          CTD   CTD_INT128,IN==FL16'0',OUT=DECIMALX
               ,LINKAGE=SVC
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'0'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3312 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'0'
         LA    R3,L'=FL16'0'
*MCALL #=  3313 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3314 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3314 LV= 4 ZCALL
*MEXIT #=  3313 LV= 3 CALL
*MCALL #=  3315 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3315 LV= 3 WTO
*MCALL #=  3316 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3317 LV= 4          ZSTREQU 
*MEXIT #=  3317 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_285_2
*MEXIT #=  3316 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3318 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3318 LV= 3 WTO
*MCALL #=  3319 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3319 LV= 3 ABEND
*MCALL #=  3320 LV= 3          ENDIF 
*MCALL #=  3321 LV= 4          ZSTREQU 
*MEXIT #=  3321 LV= 4 ZSTREQU
#@IF_285_2                                               DS 0H
*MEXIT #=  3320 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3322 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3322 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'0'
*MCALL #=  3323 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3324 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3324 LV= 4 ZCALL
*MEXIT #=  3323 LV= 3 CALL
*MCALL #=  3325 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3325 LV= 3 WTO
*MCALL #=  3326 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3327 LV= 4          ZSTREQU 
*MEXIT #=  3327 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_286_2
*MEXIT #=  3326 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3328 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3328 LV= 3 WTO
*MCALL #=  3329 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3329 LV= 3 ABEND
*MCALL #=  3330 LV= 3          ENDIF 
*MCALL #=  3331 LV= 4          ZSTREQU 
*MEXIT #=  3331 LV= 4 ZSTREQU
#@IF_286_2                                               DS 0H
*MEXIT #=  3330 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'0'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'0'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  3332 LV= 3          RT1   CCE
         DS    0H
RT1_TEST180      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE180
         LTORG 
RT1_CCE180      DS 0H
*MEXIT #=  3332 LV= 3 RT1
         B     EXIT143
         LTORG 
EXIT143     DS 0H
*MEXIT #=  3311 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  3333 LV= 2          RT1   CCE
         DS    0H
RT1_TEST181      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE181
         LTORG 
RT1_CCE181      DS 0H
*MEXIT #=  3333 LV= 2 RT1
*MEXIT #=  3288 LV= 1 TEST
*MCALL #=  3334 LV= 1          TEST   INT128,=FL16'1'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  3335 LV= 2          TEST1 MF,INT128,=FL16'1'
         BASR  R12,0
         USING *,R12
*MCALL #=  3336 LV= 3          CTD   CTD_INT128,IN==FL16'1',OUT=DECIMALX
               ,LINKAGE=MF
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'1'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3336 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'1'
         LA    R3,L'=FL16'1'
*MCALL #=  3337 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3338 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3338 LV= 4 ZCALL
*MEXIT #=  3337 LV= 3 CALL
*MCALL #=  3339 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3339 LV= 3 WTO
*MCALL #=  3340 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3341 LV= 4          ZSTREQU 
*MEXIT #=  3341 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_287_2
*MEXIT #=  3340 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3342 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3342 LV= 3 WTO
*MCALL #=  3343 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3343 LV= 3 ABEND
*MCALL #=  3344 LV= 3          ENDIF 
*MCALL #=  3345 LV= 4          ZSTREQU 
*MEXIT #=  3345 LV= 4 ZSTREQU
#@IF_287_2                                               DS 0H
*MEXIT #=  3344 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3346 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3346 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'1'
*MCALL #=  3347 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3348 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3348 LV= 4 ZCALL
*MEXIT #=  3347 LV= 3 CALL
*MCALL #=  3349 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3349 LV= 3 WTO
*MCALL #=  3350 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3351 LV= 4          ZSTREQU 
*MEXIT #=  3351 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_288_2
*MEXIT #=  3350 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3352 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3352 LV= 3 WTO
*MCALL #=  3353 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3353 LV= 3 ABEND
*MCALL #=  3354 LV= 3          ENDIF 
*MCALL #=  3355 LV= 4          ZSTREQU 
*MEXIT #=  3355 LV= 4 ZSTREQU
#@IF_288_2                                               DS 0H
*MEXIT #=  3354 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  3356 LV= 3          RT1   CCE
         DS    0H
RT1_TEST182      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE182
         LTORG 
RT1_CCE182      DS 0H
*MEXIT #=  3356 LV= 3 RT1
         B     EXIT144
         LTORG 
EXIT144     DS 0H
*MEXIT #=  3335 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  3357 LV= 2          TEST1 SVC,INT128,=FL16'1'
         BASR  R12,0
         USING *,R12
*MCALL #=  3358 LV= 3          CTD   CTD_INT128,IN==FL16'1',OUT=DECIMALX
               ,LINKAGE=SVC
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3358 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'1'
         LA    R3,L'=FL16'1'
*MCALL #=  3359 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3360 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3360 LV= 4 ZCALL
*MEXIT #=  3359 LV= 3 CALL
*MCALL #=  3361 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3361 LV= 3 WTO
*MCALL #=  3362 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3363 LV= 4          ZSTREQU 
*MEXIT #=  3363 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_289_2
*MEXIT #=  3362 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3364 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3364 LV= 3 WTO
*MCALL #=  3365 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3365 LV= 3 ABEND
*MCALL #=  3366 LV= 3          ENDIF 
*MCALL #=  3367 LV= 4          ZSTREQU 
*MEXIT #=  3367 LV= 4 ZSTREQU
#@IF_289_2                                               DS 0H
*MEXIT #=  3366 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3368 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3368 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'1'
*MCALL #=  3369 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3370 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3370 LV= 4 ZCALL
*MEXIT #=  3369 LV= 3 CALL
*MCALL #=  3371 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3371 LV= 3 WTO
*MCALL #=  3372 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3373 LV= 4          ZSTREQU 
*MEXIT #=  3373 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_290_2
*MEXIT #=  3372 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3374 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3374 LV= 3 WTO
*MCALL #=  3375 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3375 LV= 3 ABEND
*MCALL #=  3376 LV= 3          ENDIF 
*MCALL #=  3377 LV= 4          ZSTREQU 
*MEXIT #=  3377 LV= 4 ZSTREQU
#@IF_290_2                                               DS 0H
*MEXIT #=  3376 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  3378 LV= 3          RT1   CCE
         DS    0H
RT1_TEST183      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE183
         LTORG 
RT1_CCE183      DS 0H
*MEXIT #=  3378 LV= 3 RT1
         B     EXIT145
         LTORG 
EXIT145     DS 0H
*MEXIT #=  3357 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  3379 LV= 2          RT1   CCE
         DS    0H
RT1_TEST184      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE184
         LTORG 
RT1_CCE184      DS 0H
*MEXIT #=  3379 LV= 2 RT1
*MEXIT #=  3334 LV= 1 TEST
*MCALL #=  3380 LV= 1          TEST   INT128,=FL16'2'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  3381 LV= 2          TEST1 MF,INT128,=FL16'2'
         BASR  R12,0
         USING *,R12
*MCALL #=  3382 LV= 3          CTD   CTD_INT128,IN==FL16'2',OUT=DECIMALX
               ,LINKAGE=MF
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'2'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3382 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'2'
         LA    R3,L'=FL16'2'
*MCALL #=  3383 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3384 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3384 LV= 4 ZCALL
*MEXIT #=  3383 LV= 3 CALL
*MCALL #=  3385 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3385 LV= 3 WTO
*MCALL #=  3386 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3387 LV= 4          ZSTREQU 
*MEXIT #=  3387 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_291_2
*MEXIT #=  3386 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3388 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3388 LV= 3 WTO
*MCALL #=  3389 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3389 LV= 3 ABEND
*MCALL #=  3390 LV= 3          ENDIF 
*MCALL #=  3391 LV= 4          ZSTREQU 
*MEXIT #=  3391 LV= 4 ZSTREQU
#@IF_291_2                                               DS 0H
*MEXIT #=  3390 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3392 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3392 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'2'
*MCALL #=  3393 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3394 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3394 LV= 4 ZCALL
*MEXIT #=  3393 LV= 3 CALL
*MCALL #=  3395 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3395 LV= 3 WTO
*MCALL #=  3396 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3397 LV= 4          ZSTREQU 
*MEXIT #=  3397 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_292_2
*MEXIT #=  3396 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3398 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3398 LV= 3 WTO
*MCALL #=  3399 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3399 LV= 3 ABEND
*MCALL #=  3400 LV= 3          ENDIF 
*MCALL #=  3401 LV= 4          ZSTREQU 
*MEXIT #=  3401 LV= 4 ZSTREQU
#@IF_292_2                                               DS 0H
*MEXIT #=  3400 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  3402 LV= 3          RT1   CCE
         DS    0H
RT1_TEST185      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE185
         LTORG 
RT1_CCE185      DS 0H
*MEXIT #=  3402 LV= 3 RT1
         B     EXIT146
         LTORG 
EXIT146     DS 0H
*MEXIT #=  3381 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  3403 LV= 2          TEST1 SVC,INT128,=FL16'2'
         BASR  R12,0
         USING *,R12
*MCALL #=  3404 LV= 3          CTD   CTD_INT128,IN==FL16'2',OUT=DECIMALX
               ,LINKAGE=SVC
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3404 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'2'
         LA    R3,L'=FL16'2'
*MCALL #=  3405 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3406 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3406 LV= 4 ZCALL
*MEXIT #=  3405 LV= 3 CALL
*MCALL #=  3407 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3407 LV= 3 WTO
*MCALL #=  3408 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3409 LV= 4          ZSTREQU 
*MEXIT #=  3409 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_293_2
*MEXIT #=  3408 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3410 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3410 LV= 3 WTO
*MCALL #=  3411 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3411 LV= 3 ABEND
*MCALL #=  3412 LV= 3          ENDIF 
*MCALL #=  3413 LV= 4          ZSTREQU 
*MEXIT #=  3413 LV= 4 ZSTREQU
#@IF_293_2                                               DS 0H
*MEXIT #=  3412 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3414 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3414 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'2'
*MCALL #=  3415 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3416 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3416 LV= 4 ZCALL
*MEXIT #=  3415 LV= 3 CALL
*MCALL #=  3417 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3417 LV= 3 WTO
*MCALL #=  3418 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3419 LV= 4          ZSTREQU 
*MEXIT #=  3419 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_294_2
*MEXIT #=  3418 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3420 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3420 LV= 3 WTO
*MCALL #=  3421 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3421 LV= 3 ABEND
*MCALL #=  3422 LV= 3          ENDIF 
*MCALL #=  3423 LV= 4          ZSTREQU 
*MEXIT #=  3423 LV= 4 ZSTREQU
#@IF_294_2                                               DS 0H
*MEXIT #=  3422 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  3424 LV= 3          RT1   CCE
         DS    0H
RT1_TEST186      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE186
         LTORG 
RT1_CCE186      DS 0H
*MEXIT #=  3424 LV= 3 RT1
         B     EXIT147
         LTORG 
EXIT147     DS 0H
*MEXIT #=  3403 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  3425 LV= 2          RT1   CCE
         DS    0H
RT1_TEST187      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE187
         LTORG 
RT1_CCE187      DS 0H
*MEXIT #=  3425 LV= 2 RT1
*MEXIT #=  3380 LV= 1 TEST
*MCALL #=  3426 LV= 1          TEST   INT128,=FL16'1E2'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  3427 LV= 2          TEST1 MF,INT128,=FL16'1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=  3428 LV= 3          CTD   CTD_INT128,IN==FL16'1E2',OUT=DECIMX
               AL,LINKAGE=MF
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'1E2'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3428 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'1E2'
         LA    R3,L'=FL16'1E2'
*MCALL #=  3429 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3430 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3430 LV= 4 ZCALL
*MEXIT #=  3429 LV= 3 CALL
*MCALL #=  3431 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3431 LV= 3 WTO
*MCALL #=  3432 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3433 LV= 4          ZSTREQU 
*MEXIT #=  3433 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_295_2
*MEXIT #=  3432 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3434 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3434 LV= 3 WTO
*MCALL #=  3435 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3435 LV= 3 ABEND
*MCALL #=  3436 LV= 3          ENDIF 
*MCALL #=  3437 LV= 4          ZSTREQU 
*MEXIT #=  3437 LV= 4 ZSTREQU
#@IF_295_2                                               DS 0H
*MEXIT #=  3436 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3438 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3438 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'1E2'
*MCALL #=  3439 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3440 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3440 LV= 4 ZCALL
*MEXIT #=  3439 LV= 3 CALL
*MCALL #=  3441 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3441 LV= 3 WTO
*MCALL #=  3442 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3443 LV= 4          ZSTREQU 
*MEXIT #=  3443 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_296_2
*MEXIT #=  3442 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3444 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3444 LV= 3 WTO
*MCALL #=  3445 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3445 LV= 3 ABEND
*MCALL #=  3446 LV= 3          ENDIF 
*MCALL #=  3447 LV= 4          ZSTREQU 
*MEXIT #=  3447 LV= 4 ZSTREQU
#@IF_296_2                                               DS 0H
*MEXIT #=  3446 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'1E2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'1E2'  VERIFY CTD CONSTANT WITH CFD RESULX
               T
* RPI 786 START TEST FOR DFP
*MCALL #=  3448 LV= 3          RT1   CCE
         DS    0H
RT1_TEST188      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE188
         LTORG 
RT1_CCE188      DS 0H
*MEXIT #=  3448 LV= 3 RT1
         B     EXIT148
         LTORG 
EXIT148     DS 0H
*MEXIT #=  3427 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  3449 LV= 2          TEST1 SVC,INT128,=FL16'1E2'
         BASR  R12,0
         USING *,R12
*MCALL #=  3450 LV= 3          CTD   CTD_INT128,IN==FL16'1E2',OUT=DECIMX
               AL,LINKAGE=SVC
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'1E2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3450 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'1E2'
         LA    R3,L'=FL16'1E2'
*MCALL #=  3451 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3452 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3452 LV= 4 ZCALL
*MEXIT #=  3451 LV= 3 CALL
*MCALL #=  3453 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3453 LV= 3 WTO
*MCALL #=  3454 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3455 LV= 4          ZSTREQU 
*MEXIT #=  3455 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_297_2
*MEXIT #=  3454 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3456 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3456 LV= 3 WTO
*MCALL #=  3457 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3457 LV= 3 ABEND
*MCALL #=  3458 LV= 3          ENDIF 
*MCALL #=  3459 LV= 4          ZSTREQU 
*MEXIT #=  3459 LV= 4 ZSTREQU
#@IF_297_2                                               DS 0H
*MEXIT #=  3458 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3460 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3460 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'1E2'
*MCALL #=  3461 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3462 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3462 LV= 4 ZCALL
*MEXIT #=  3461 LV= 3 CALL
*MCALL #=  3463 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3463 LV= 3 WTO
*MCALL #=  3464 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3465 LV= 4          ZSTREQU 
*MEXIT #=  3465 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_298_2
*MEXIT #=  3464 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3466 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3466 LV= 3 WTO
*MCALL #=  3467 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3467 LV= 3 ABEND
*MCALL #=  3468 LV= 3          ENDIF 
*MCALL #=  3469 LV= 4          ZSTREQU 
*MEXIT #=  3469 LV= 4 ZSTREQU
#@IF_298_2                                               DS 0H
*MEXIT #=  3468 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'1E2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'1E2'  VERIFY CTD CONSTANT WITH CFD RESULX
               T
* RPI 786 START TEST FOR DFP
*MCALL #=  3470 LV= 3          RT1   CCE
         DS    0H
RT1_TEST189      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE189
         LTORG 
RT1_CCE189      DS 0H
*MEXIT #=  3470 LV= 3 RT1
         B     EXIT149
         LTORG 
EXIT149     DS 0H
*MEXIT #=  3449 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  3471 LV= 2          RT1   CCE
         DS    0H
RT1_TEST190      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE190
         LTORG 
RT1_CCE190      DS 0H
*MEXIT #=  3471 LV= 2 RT1
*MEXIT #=  3426 LV= 1 TEST
*MCALL #=  3472 LV= 1          TEST   INT128,=FL16'1E6'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  3473 LV= 2          TEST1 MF,INT128,=FL16'1E6'
         BASR  R12,0
         USING *,R12
*MCALL #=  3474 LV= 3          CTD   CTD_INT128,IN==FL16'1E6',OUT=DECIMX
               AL,LINKAGE=MF
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'1E6'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3474 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'1E6'
         LA    R3,L'=FL16'1E6'
*MCALL #=  3475 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3476 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3476 LV= 4 ZCALL
*MEXIT #=  3475 LV= 3 CALL
*MCALL #=  3477 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3477 LV= 3 WTO
*MCALL #=  3478 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3479 LV= 4          ZSTREQU 
*MEXIT #=  3479 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_299_2
*MEXIT #=  3478 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3480 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3480 LV= 3 WTO
*MCALL #=  3481 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3481 LV= 3 ABEND
*MCALL #=  3482 LV= 3          ENDIF 
*MCALL #=  3483 LV= 4          ZSTREQU 
*MEXIT #=  3483 LV= 4 ZSTREQU
#@IF_299_2                                               DS 0H
*MEXIT #=  3482 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3484 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3484 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'1E6'
*MCALL #=  3485 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3486 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3486 LV= 4 ZCALL
*MEXIT #=  3485 LV= 3 CALL
*MCALL #=  3487 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3487 LV= 3 WTO
*MCALL #=  3488 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3489 LV= 4          ZSTREQU 
*MEXIT #=  3489 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_300_2
*MEXIT #=  3488 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3490 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3490 LV= 3 WTO
*MCALL #=  3491 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3491 LV= 3 ABEND
*MCALL #=  3492 LV= 3          ENDIF 
*MCALL #=  3493 LV= 4          ZSTREQU 
*MEXIT #=  3493 LV= 4 ZSTREQU
#@IF_300_2                                               DS 0H
*MEXIT #=  3492 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'1E6'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'1E6'  VERIFY CTD CONSTANT WITH CFD RESULX
               T
* RPI 786 START TEST FOR DFP
*MCALL #=  3494 LV= 3          RT1   CCE
         DS    0H
RT1_TEST191      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE191
         LTORG 
RT1_CCE191      DS 0H
*MEXIT #=  3494 LV= 3 RT1
         B     EXIT150
         LTORG 
EXIT150     DS 0H
*MEXIT #=  3473 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  3495 LV= 2          TEST1 SVC,INT128,=FL16'1E6'
         BASR  R12,0
         USING *,R12
*MCALL #=  3496 LV= 3          CTD   CTD_INT128,IN==FL16'1E6',OUT=DECIMX
               AL,LINKAGE=SVC
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'1E6'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3496 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'1E6'
         LA    R3,L'=FL16'1E6'
*MCALL #=  3497 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3498 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3498 LV= 4 ZCALL
*MEXIT #=  3497 LV= 3 CALL
*MCALL #=  3499 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3499 LV= 3 WTO
*MCALL #=  3500 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3501 LV= 4          ZSTREQU 
*MEXIT #=  3501 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_301_2
*MEXIT #=  3500 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3502 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3502 LV= 3 WTO
*MCALL #=  3503 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3503 LV= 3 ABEND
*MCALL #=  3504 LV= 3          ENDIF 
*MCALL #=  3505 LV= 4          ZSTREQU 
*MEXIT #=  3505 LV= 4 ZSTREQU
#@IF_301_2                                               DS 0H
*MEXIT #=  3504 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3506 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3506 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'1E6'
*MCALL #=  3507 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3508 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3508 LV= 4 ZCALL
*MEXIT #=  3507 LV= 3 CALL
*MCALL #=  3509 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3509 LV= 3 WTO
*MCALL #=  3510 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3511 LV= 4          ZSTREQU 
*MEXIT #=  3511 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_302_2
*MEXIT #=  3510 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3512 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3512 LV= 3 WTO
*MCALL #=  3513 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3513 LV= 3 ABEND
*MCALL #=  3514 LV= 3          ENDIF 
*MCALL #=  3515 LV= 4          ZSTREQU 
*MEXIT #=  3515 LV= 4 ZSTREQU
#@IF_302_2                                               DS 0H
*MEXIT #=  3514 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'1E6'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'1E6'  VERIFY CTD CONSTANT WITH CFD RESULX
               T
* RPI 786 START TEST FOR DFP
*MCALL #=  3516 LV= 3          RT1   CCE
         DS    0H
RT1_TEST192      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE192
         LTORG 
RT1_CCE192      DS 0H
*MEXIT #=  3516 LV= 3 RT1
         B     EXIT151
         LTORG 
EXIT151     DS 0H
*MEXIT #=  3495 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  3517 LV= 2          RT1   CCE
         DS    0H
RT1_TEST193      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE193
         LTORG 
RT1_CCE193      DS 0H
*MEXIT #=  3517 LV= 2 RT1
*MEXIT #=  3472 LV= 1 TEST
*MCALL #=  3518 LV= 1          TEST   INT128,=FL16'1E13'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  3519 LV= 2          TEST1 MF,INT128,=FL16'1E13'
         BASR  R12,0
         USING *,R12
*MCALL #=  3520 LV= 3          CTD   CTD_INT128,IN==FL16'1E13',OUT=DECIX
               MAL,LINKAGE=MF
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'1E13'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3520 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'1E13'
         LA    R3,L'=FL16'1E13'
*MCALL #=  3521 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3522 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3522 LV= 4 ZCALL
*MEXIT #=  3521 LV= 3 CALL
*MCALL #=  3523 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3523 LV= 3 WTO
*MCALL #=  3524 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3525 LV= 4          ZSTREQU 
*MEXIT #=  3525 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_303_2
*MEXIT #=  3524 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3526 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3526 LV= 3 WTO
*MCALL #=  3527 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3527 LV= 3 ABEND
*MCALL #=  3528 LV= 3          ENDIF 
*MCALL #=  3529 LV= 4          ZSTREQU 
*MEXIT #=  3529 LV= 4 ZSTREQU
#@IF_303_2                                               DS 0H
*MEXIT #=  3528 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3530 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3530 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'1E13'
*MCALL #=  3531 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3532 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3532 LV= 4 ZCALL
*MEXIT #=  3531 LV= 3 CALL
*MCALL #=  3533 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3533 LV= 3 WTO
*MCALL #=  3534 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3535 LV= 4          ZSTREQU 
*MEXIT #=  3535 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_304_2
*MEXIT #=  3534 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3536 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3536 LV= 3 WTO
*MCALL #=  3537 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3537 LV= 3 ABEND
*MCALL #=  3538 LV= 3          ENDIF 
*MCALL #=  3539 LV= 4          ZSTREQU 
*MEXIT #=  3539 LV= 4 ZSTREQU
#@IF_304_2                                               DS 0H
*MEXIT #=  3538 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'1E13'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'1E13'  VERIFY CTD CONSTANT WITH CFD RESUX
               LT
* RPI 786 START TEST FOR DFP
*MCALL #=  3540 LV= 3          RT1   CCE
         DS    0H
RT1_TEST194      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE194
         LTORG 
RT1_CCE194      DS 0H
*MEXIT #=  3540 LV= 3 RT1
         B     EXIT152
         LTORG 
EXIT152     DS 0H
*MEXIT #=  3519 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  3541 LV= 2          TEST1 SVC,INT128,=FL16'1E13'
         BASR  R12,0
         USING *,R12
*MCALL #=  3542 LV= 3          CTD   CTD_INT128,IN==FL16'1E13',OUT=DECIX
               MAL,LINKAGE=SVC
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'1E13'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3542 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'1E13'
         LA    R3,L'=FL16'1E13'
*MCALL #=  3543 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3544 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3544 LV= 4 ZCALL
*MEXIT #=  3543 LV= 3 CALL
*MCALL #=  3545 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3545 LV= 3 WTO
*MCALL #=  3546 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3547 LV= 4          ZSTREQU 
*MEXIT #=  3547 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_305_2
*MEXIT #=  3546 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3548 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3548 LV= 3 WTO
*MCALL #=  3549 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3549 LV= 3 ABEND
*MCALL #=  3550 LV= 3          ENDIF 
*MCALL #=  3551 LV= 4          ZSTREQU 
*MEXIT #=  3551 LV= 4 ZSTREQU
#@IF_305_2                                               DS 0H
*MEXIT #=  3550 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3552 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3552 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'1E13'
*MCALL #=  3553 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3554 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3554 LV= 4 ZCALL
*MEXIT #=  3553 LV= 3 CALL
*MCALL #=  3555 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3555 LV= 3 WTO
*MCALL #=  3556 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3557 LV= 4          ZSTREQU 
*MEXIT #=  3557 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_306_2
*MEXIT #=  3556 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3558 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3558 LV= 3 WTO
*MCALL #=  3559 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3559 LV= 3 ABEND
*MCALL #=  3560 LV= 3          ENDIF 
*MCALL #=  3561 LV= 4          ZSTREQU 
*MEXIT #=  3561 LV= 4 ZSTREQU
#@IF_306_2                                               DS 0H
*MEXIT #=  3560 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'1E13'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'1E13'  VERIFY CTD CONSTANT WITH CFD RESUX
               LT
* RPI 786 START TEST FOR DFP
*MCALL #=  3562 LV= 3          RT1   CCE
         DS    0H
RT1_TEST195      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE195
         LTORG 
RT1_CCE195      DS 0H
*MEXIT #=  3562 LV= 3 RT1
         B     EXIT153
         LTORG 
EXIT153     DS 0H
*MEXIT #=  3541 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  3563 LV= 2          RT1   CCE
         DS    0H
RT1_TEST196      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE196
         LTORG 
RT1_CCE196      DS 0H
*MEXIT #=  3563 LV= 2 RT1
*MEXIT #=  3518 LV= 1 TEST
*MCALL #=  3564 LV= 1          TEST   INT128,=FL16'1E14'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  3565 LV= 2          TEST1 MF,INT128,=FL16'1E14'
         BASR  R12,0
         USING *,R12
*MCALL #=  3566 LV= 3          CTD   CTD_INT128,IN==FL16'1E14',OUT=DECIX
               MAL,LINKAGE=MF
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'1E14'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3566 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'1E14'
         LA    R3,L'=FL16'1E14'
*MCALL #=  3567 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3568 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3568 LV= 4 ZCALL
*MEXIT #=  3567 LV= 3 CALL
*MCALL #=  3569 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3569 LV= 3 WTO
*MCALL #=  3570 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3571 LV= 4          ZSTREQU 
*MEXIT #=  3571 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_307_2
*MEXIT #=  3570 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3572 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3572 LV= 3 WTO
*MCALL #=  3573 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3573 LV= 3 ABEND
*MCALL #=  3574 LV= 3          ENDIF 
*MCALL #=  3575 LV= 4          ZSTREQU 
*MEXIT #=  3575 LV= 4 ZSTREQU
#@IF_307_2                                               DS 0H
*MEXIT #=  3574 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3576 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3576 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'1E14'
*MCALL #=  3577 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3578 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3578 LV= 4 ZCALL
*MEXIT #=  3577 LV= 3 CALL
*MCALL #=  3579 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3579 LV= 3 WTO
*MCALL #=  3580 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3581 LV= 4          ZSTREQU 
*MEXIT #=  3581 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_308_2
*MEXIT #=  3580 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3582 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3582 LV= 3 WTO
*MCALL #=  3583 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3583 LV= 3 ABEND
*MCALL #=  3584 LV= 3          ENDIF 
*MCALL #=  3585 LV= 4          ZSTREQU 
*MEXIT #=  3585 LV= 4 ZSTREQU
#@IF_308_2                                               DS 0H
*MEXIT #=  3584 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'1E14'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'1E14'  VERIFY CTD CONSTANT WITH CFD RESUX
               LT
* RPI 786 START TEST FOR DFP
*MCALL #=  3586 LV= 3          RT1   CCE
         DS    0H
RT1_TEST197      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE197
         LTORG 
RT1_CCE197      DS 0H
*MEXIT #=  3586 LV= 3 RT1
         B     EXIT154
         LTORG 
EXIT154     DS 0H
*MEXIT #=  3565 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  3587 LV= 2          TEST1 SVC,INT128,=FL16'1E14'
         BASR  R12,0
         USING *,R12
*MCALL #=  3588 LV= 3          CTD   CTD_INT128,IN==FL16'1E14',OUT=DECIX
               MAL,LINKAGE=SVC
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'1E14'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3588 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'1E14'
         LA    R3,L'=FL16'1E14'
*MCALL #=  3589 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3590 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3590 LV= 4 ZCALL
*MEXIT #=  3589 LV= 3 CALL
*MCALL #=  3591 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3591 LV= 3 WTO
*MCALL #=  3592 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3593 LV= 4          ZSTREQU 
*MEXIT #=  3593 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_309_2
*MEXIT #=  3592 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3594 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3594 LV= 3 WTO
*MCALL #=  3595 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3595 LV= 3 ABEND
*MCALL #=  3596 LV= 3          ENDIF 
*MCALL #=  3597 LV= 4          ZSTREQU 
*MEXIT #=  3597 LV= 4 ZSTREQU
#@IF_309_2                                               DS 0H
*MEXIT #=  3596 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3598 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3598 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'1E14'
*MCALL #=  3599 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3600 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3600 LV= 4 ZCALL
*MEXIT #=  3599 LV= 3 CALL
*MCALL #=  3601 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3601 LV= 3 WTO
*MCALL #=  3602 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3603 LV= 4          ZSTREQU 
*MEXIT #=  3603 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_310_2
*MEXIT #=  3602 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3604 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3604 LV= 3 WTO
*MCALL #=  3605 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3605 LV= 3 ABEND
*MCALL #=  3606 LV= 3          ENDIF 
*MCALL #=  3607 LV= 4          ZSTREQU 
*MEXIT #=  3607 LV= 4 ZSTREQU
#@IF_310_2                                               DS 0H
*MEXIT #=  3606 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'1E14'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'1E14'  VERIFY CTD CONSTANT WITH CFD RESUX
               LT
* RPI 786 START TEST FOR DFP
*MCALL #=  3608 LV= 3          RT1   CCE
         DS    0H
RT1_TEST198      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE198
         LTORG 
RT1_CCE198      DS 0H
*MEXIT #=  3608 LV= 3 RT1
         B     EXIT155
         LTORG 
EXIT155     DS 0H
*MEXIT #=  3587 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  3609 LV= 2          RT1   CCE
         DS    0H
RT1_TEST199      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE199
         LTORG 
RT1_CCE199      DS 0H
*MEXIT #=  3609 LV= 2 RT1
*MEXIT #=  3564 LV= 1 TEST
*MCALL #=  3610 LV= 1          TEST   INT128,=FL16S63'1'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  3611 LV= 2          TEST1 MF,INT128,=FL16S63'1'
         BASR  R12,0
         USING *,R12
*MCALL #=  3612 LV= 3          CTD   CTD_INT128,IN==FL16S63'1',OUT=DECIX
               MAL,LINKAGE=MF
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16S63'1'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3612 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16S63'1'
         LA    R3,L'=FL16S63'1'
*MCALL #=  3613 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3614 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3614 LV= 4 ZCALL
*MEXIT #=  3613 LV= 3 CALL
*MCALL #=  3615 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3615 LV= 3 WTO
*MCALL #=  3616 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3617 LV= 4          ZSTREQU 
*MEXIT #=  3617 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_311_2
*MEXIT #=  3616 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3618 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3618 LV= 3 WTO
*MCALL #=  3619 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3619 LV= 3 ABEND
*MCALL #=  3620 LV= 3          ENDIF 
*MCALL #=  3621 LV= 4          ZSTREQU 
*MEXIT #=  3621 LV= 4 ZSTREQU
#@IF_311_2                                               DS 0H
*MEXIT #=  3620 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3622 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3622 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16S63'1'
*MCALL #=  3623 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3624 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3624 LV= 4 ZCALL
*MEXIT #=  3623 LV= 3 CALL
*MCALL #=  3625 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3625 LV= 3 WTO
*MCALL #=  3626 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3627 LV= 4          ZSTREQU 
*MEXIT #=  3627 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_312_2
*MEXIT #=  3626 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3628 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3628 LV= 3 WTO
*MCALL #=  3629 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3629 LV= 3 ABEND
*MCALL #=  3630 LV= 3          ENDIF 
*MCALL #=  3631 LV= 4          ZSTREQU 
*MEXIT #=  3631 LV= 4 ZSTREQU
#@IF_312_2                                               DS 0H
*MEXIT #=  3630 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16S63'1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16S63'1'  VERIFY CTD CONSTANT WITH CFD RESUX
               LT
* RPI 786 START TEST FOR DFP
*MCALL #=  3632 LV= 3          RT1   CCE
         DS    0H
RT1_TEST200      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE200
         LTORG 
RT1_CCE200      DS 0H
*MEXIT #=  3632 LV= 3 RT1
         B     EXIT156
         LTORG 
EXIT156     DS 0H
*MEXIT #=  3611 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  3633 LV= 2          TEST1 SVC,INT128,=FL16S63'1'
         BASR  R12,0
         USING *,R12
*MCALL #=  3634 LV= 3          CTD   CTD_INT128,IN==FL16S63'1',OUT=DECIX
               MAL,LINKAGE=SVC
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16S63'1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3634 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16S63'1'
         LA    R3,L'=FL16S63'1'
*MCALL #=  3635 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3636 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3636 LV= 4 ZCALL
*MEXIT #=  3635 LV= 3 CALL
*MCALL #=  3637 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3637 LV= 3 WTO
*MCALL #=  3638 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3639 LV= 4          ZSTREQU 
*MEXIT #=  3639 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_313_2
*MEXIT #=  3638 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3640 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3640 LV= 3 WTO
*MCALL #=  3641 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3641 LV= 3 ABEND
*MCALL #=  3642 LV= 3          ENDIF 
*MCALL #=  3643 LV= 4          ZSTREQU 
*MEXIT #=  3643 LV= 4 ZSTREQU
#@IF_313_2                                               DS 0H
*MEXIT #=  3642 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3644 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3644 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16S63'1'
*MCALL #=  3645 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3646 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3646 LV= 4 ZCALL
*MEXIT #=  3645 LV= 3 CALL
*MCALL #=  3647 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3647 LV= 3 WTO
*MCALL #=  3648 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3649 LV= 4          ZSTREQU 
*MEXIT #=  3649 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_314_2
*MEXIT #=  3648 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3650 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3650 LV= 3 WTO
*MCALL #=  3651 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3651 LV= 3 ABEND
*MCALL #=  3652 LV= 3          ENDIF 
*MCALL #=  3653 LV= 4          ZSTREQU 
*MEXIT #=  3653 LV= 4 ZSTREQU
#@IF_314_2                                               DS 0H
*MEXIT #=  3652 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16S63'1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16S63'1'  VERIFY CTD CONSTANT WITH CFD RESUX
               LT
* RPI 786 START TEST FOR DFP
*MCALL #=  3654 LV= 3          RT1   CCE
         DS    0H
RT1_TEST201      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE201
         LTORG 
RT1_CCE201      DS 0H
*MEXIT #=  3654 LV= 3 RT1
         B     EXIT157
         LTORG 
EXIT157     DS 0H
*MEXIT #=  3633 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  3655 LV= 2          RT1   CCE
         DS    0H
RT1_TEST202      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE202
         LTORG 
RT1_CCE202      DS 0H
*MEXIT #=  3655 LV= 2 RT1
*MEXIT #=  3610 LV= 1 TEST
*MCALL #=  3656 LV= 1          TEST   INT128,=FL16S64'1'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  3657 LV= 2          TEST1 MF,INT128,=FL16S64'1'
         BASR  R12,0
         USING *,R12
*MCALL #=  3658 LV= 3          CTD   CTD_INT128,IN==FL16S64'1',OUT=DECIX
               MAL,LINKAGE=MF
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16S64'1'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3658 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16S64'1'
         LA    R3,L'=FL16S64'1'
*MCALL #=  3659 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3660 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3660 LV= 4 ZCALL
*MEXIT #=  3659 LV= 3 CALL
*MCALL #=  3661 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3661 LV= 3 WTO
*MCALL #=  3662 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3663 LV= 4          ZSTREQU 
*MEXIT #=  3663 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_315_2
*MEXIT #=  3662 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3664 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3664 LV= 3 WTO
*MCALL #=  3665 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3665 LV= 3 ABEND
*MCALL #=  3666 LV= 3          ENDIF 
*MCALL #=  3667 LV= 4          ZSTREQU 
*MEXIT #=  3667 LV= 4 ZSTREQU
#@IF_315_2                                               DS 0H
*MEXIT #=  3666 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3668 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3668 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16S64'1'
*MCALL #=  3669 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3670 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3670 LV= 4 ZCALL
*MEXIT #=  3669 LV= 3 CALL
*MCALL #=  3671 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3671 LV= 3 WTO
*MCALL #=  3672 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3673 LV= 4          ZSTREQU 
*MEXIT #=  3673 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_316_2
*MEXIT #=  3672 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3674 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3674 LV= 3 WTO
*MCALL #=  3675 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3675 LV= 3 ABEND
*MCALL #=  3676 LV= 3          ENDIF 
*MCALL #=  3677 LV= 4          ZSTREQU 
*MEXIT #=  3677 LV= 4 ZSTREQU
#@IF_316_2                                               DS 0H
*MEXIT #=  3676 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16S64'1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16S64'1'  VERIFY CTD CONSTANT WITH CFD RESUX
               LT
* RPI 786 START TEST FOR DFP
*MCALL #=  3678 LV= 3          RT1   CCE
         DS    0H
RT1_TEST203      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE203
         LTORG 
RT1_CCE203      DS 0H
*MEXIT #=  3678 LV= 3 RT1
         B     EXIT158
         LTORG 
EXIT158     DS 0H
*MEXIT #=  3657 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  3679 LV= 2          TEST1 SVC,INT128,=FL16S64'1'
         BASR  R12,0
         USING *,R12
*MCALL #=  3680 LV= 3          CTD   CTD_INT128,IN==FL16S64'1',OUT=DECIX
               MAL,LINKAGE=SVC
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16S64'1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3680 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16S64'1'
         LA    R3,L'=FL16S64'1'
*MCALL #=  3681 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3682 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3682 LV= 4 ZCALL
*MEXIT #=  3681 LV= 3 CALL
*MCALL #=  3683 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3683 LV= 3 WTO
*MCALL #=  3684 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3685 LV= 4          ZSTREQU 
*MEXIT #=  3685 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_317_2
*MEXIT #=  3684 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3686 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3686 LV= 3 WTO
*MCALL #=  3687 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3687 LV= 3 ABEND
*MCALL #=  3688 LV= 3          ENDIF 
*MCALL #=  3689 LV= 4          ZSTREQU 
*MEXIT #=  3689 LV= 4 ZSTREQU
#@IF_317_2                                               DS 0H
*MEXIT #=  3688 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3690 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3690 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16S64'1'
*MCALL #=  3691 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3692 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3692 LV= 4 ZCALL
*MEXIT #=  3691 LV= 3 CALL
*MCALL #=  3693 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3693 LV= 3 WTO
*MCALL #=  3694 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3695 LV= 4          ZSTREQU 
*MEXIT #=  3695 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_318_2
*MEXIT #=  3694 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3696 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3696 LV= 3 WTO
*MCALL #=  3697 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3697 LV= 3 ABEND
*MCALL #=  3698 LV= 3          ENDIF 
*MCALL #=  3699 LV= 4          ZSTREQU 
*MEXIT #=  3699 LV= 4 ZSTREQU
#@IF_318_2                                               DS 0H
*MEXIT #=  3698 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16S64'1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16S64'1'  VERIFY CTD CONSTANT WITH CFD RESUX
               LT
* RPI 786 START TEST FOR DFP
*MCALL #=  3700 LV= 3          RT1   CCE
         DS    0H
RT1_TEST204      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE204
         LTORG 
RT1_CCE204      DS 0H
*MEXIT #=  3700 LV= 3 RT1
         B     EXIT159
         LTORG 
EXIT159     DS 0H
*MEXIT #=  3679 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  3701 LV= 2          RT1   CCE
         DS    0H
RT1_TEST205      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE205
         LTORG 
RT1_CCE205      DS 0H
*MEXIT #=  3701 LV= 2 RT1
*MEXIT #=  3656 LV= 1 TEST
*MCALL #=  3702 LV= 1          TEST   INT128,=FL16'1E26'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  3703 LV= 2          TEST1 MF,INT128,=FL16'1E26'
         BASR  R12,0
         USING *,R12
*MCALL #=  3704 LV= 3          CTD   CTD_INT128,IN==FL16'1E26',OUT=DECIX
               MAL,LINKAGE=MF
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'1E26'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3704 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'1E26'
         LA    R3,L'=FL16'1E26'
*MCALL #=  3705 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3706 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3706 LV= 4 ZCALL
*MEXIT #=  3705 LV= 3 CALL
*MCALL #=  3707 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3707 LV= 3 WTO
*MCALL #=  3708 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3709 LV= 4          ZSTREQU 
*MEXIT #=  3709 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_319_2
*MEXIT #=  3708 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3710 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3710 LV= 3 WTO
*MCALL #=  3711 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3711 LV= 3 ABEND
*MCALL #=  3712 LV= 3          ENDIF 
*MCALL #=  3713 LV= 4          ZSTREQU 
*MEXIT #=  3713 LV= 4 ZSTREQU
#@IF_319_2                                               DS 0H
*MEXIT #=  3712 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3714 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3714 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'1E26'
*MCALL #=  3715 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3716 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3716 LV= 4 ZCALL
*MEXIT #=  3715 LV= 3 CALL
*MCALL #=  3717 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3717 LV= 3 WTO
*MCALL #=  3718 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3719 LV= 4          ZSTREQU 
*MEXIT #=  3719 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_320_2
*MEXIT #=  3718 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3720 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3720 LV= 3 WTO
*MCALL #=  3721 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3721 LV= 3 ABEND
*MCALL #=  3722 LV= 3          ENDIF 
*MCALL #=  3723 LV= 4          ZSTREQU 
*MEXIT #=  3723 LV= 4 ZSTREQU
#@IF_320_2                                               DS 0H
*MEXIT #=  3722 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'1E26'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'1E26'  VERIFY CTD CONSTANT WITH CFD RESUX
               LT
* RPI 786 START TEST FOR DFP
*MCALL #=  3724 LV= 3          RT1   CCE
         DS    0H
RT1_TEST206      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE206
         LTORG 
RT1_CCE206      DS 0H
*MEXIT #=  3724 LV= 3 RT1
         B     EXIT160
         LTORG 
EXIT160     DS 0H
*MEXIT #=  3703 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  3725 LV= 2          TEST1 SVC,INT128,=FL16'1E26'
         BASR  R12,0
         USING *,R12
*MCALL #=  3726 LV= 3          CTD   CTD_INT128,IN==FL16'1E26',OUT=DECIX
               MAL,LINKAGE=SVC
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'1E26'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3726 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'1E26'
         LA    R3,L'=FL16'1E26'
*MCALL #=  3727 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3728 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3728 LV= 4 ZCALL
*MEXIT #=  3727 LV= 3 CALL
*MCALL #=  3729 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3729 LV= 3 WTO
*MCALL #=  3730 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3731 LV= 4          ZSTREQU 
*MEXIT #=  3731 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_321_2
*MEXIT #=  3730 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3732 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3732 LV= 3 WTO
*MCALL #=  3733 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3733 LV= 3 ABEND
*MCALL #=  3734 LV= 3          ENDIF 
*MCALL #=  3735 LV= 4          ZSTREQU 
*MEXIT #=  3735 LV= 4 ZSTREQU
#@IF_321_2                                               DS 0H
*MEXIT #=  3734 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3736 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3736 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'1E26'
*MCALL #=  3737 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3738 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3738 LV= 4 ZCALL
*MEXIT #=  3737 LV= 3 CALL
*MCALL #=  3739 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3739 LV= 3 WTO
*MCALL #=  3740 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3741 LV= 4          ZSTREQU 
*MEXIT #=  3741 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_322_2
*MEXIT #=  3740 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3742 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3742 LV= 3 WTO
*MCALL #=  3743 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3743 LV= 3 ABEND
*MCALL #=  3744 LV= 3          ENDIF 
*MCALL #=  3745 LV= 4          ZSTREQU 
*MEXIT #=  3745 LV= 4 ZSTREQU
#@IF_322_2                                               DS 0H
*MEXIT #=  3744 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'1E26'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'1E26'  VERIFY CTD CONSTANT WITH CFD RESUX
               LT
* RPI 786 START TEST FOR DFP
*MCALL #=  3746 LV= 3          RT1   CCE
         DS    0H
RT1_TEST207      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE207
         LTORG 
RT1_CCE207      DS 0H
*MEXIT #=  3746 LV= 3 RT1
         B     EXIT161
         LTORG 
EXIT161     DS 0H
*MEXIT #=  3725 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  3747 LV= 2          RT1   CCE
         DS    0H
RT1_TEST208      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE208
         LTORG 
RT1_CCE208      DS 0H
*MEXIT #=  3747 LV= 2 RT1
*MEXIT #=  3702 LV= 1 TEST
*MCALL #=  3748 LV= 1          TEST   INT128,=FL16'1E27'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  3749 LV= 2          TEST1 MF,INT128,=FL16'1E27'
         BASR  R12,0
         USING *,R12
*MCALL #=  3750 LV= 3          CTD   CTD_INT128,IN==FL16'1E27',OUT=DECIX
               MAL,LINKAGE=MF
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'1E27'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3750 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'1E27'
         LA    R3,L'=FL16'1E27'
*MCALL #=  3751 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3752 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3752 LV= 4 ZCALL
*MEXIT #=  3751 LV= 3 CALL
*MCALL #=  3753 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3753 LV= 3 WTO
*MCALL #=  3754 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3755 LV= 4          ZSTREQU 
*MEXIT #=  3755 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_323_2
*MEXIT #=  3754 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3756 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3756 LV= 3 WTO
*MCALL #=  3757 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3757 LV= 3 ABEND
*MCALL #=  3758 LV= 3          ENDIF 
*MCALL #=  3759 LV= 4          ZSTREQU 
*MEXIT #=  3759 LV= 4 ZSTREQU
#@IF_323_2                                               DS 0H
*MEXIT #=  3758 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3760 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3760 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'1E27'
*MCALL #=  3761 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3762 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3762 LV= 4 ZCALL
*MEXIT #=  3761 LV= 3 CALL
*MCALL #=  3763 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3763 LV= 3 WTO
*MCALL #=  3764 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3765 LV= 4          ZSTREQU 
*MEXIT #=  3765 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_324_2
*MEXIT #=  3764 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3766 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3766 LV= 3 WTO
*MCALL #=  3767 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3767 LV= 3 ABEND
*MCALL #=  3768 LV= 3          ENDIF 
*MCALL #=  3769 LV= 4          ZSTREQU 
*MEXIT #=  3769 LV= 4 ZSTREQU
#@IF_324_2                                               DS 0H
*MEXIT #=  3768 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'1E27'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'1E27'  VERIFY CTD CONSTANT WITH CFD RESUX
               LT
* RPI 786 START TEST FOR DFP
*MCALL #=  3770 LV= 3          RT1   CCE
         DS    0H
RT1_TEST209      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE209
         LTORG 
RT1_CCE209      DS 0H
*MEXIT #=  3770 LV= 3 RT1
         B     EXIT162
         LTORG 
EXIT162     DS 0H
*MEXIT #=  3749 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  3771 LV= 2          TEST1 SVC,INT128,=FL16'1E27'
         BASR  R12,0
         USING *,R12
*MCALL #=  3772 LV= 3          CTD   CTD_INT128,IN==FL16'1E27',OUT=DECIX
               MAL,LINKAGE=SVC
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'1E27'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3772 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'1E27'
         LA    R3,L'=FL16'1E27'
*MCALL #=  3773 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3774 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3774 LV= 4 ZCALL
*MEXIT #=  3773 LV= 3 CALL
*MCALL #=  3775 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3775 LV= 3 WTO
*MCALL #=  3776 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3777 LV= 4          ZSTREQU 
*MEXIT #=  3777 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_325_2
*MEXIT #=  3776 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3778 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3778 LV= 3 WTO
*MCALL #=  3779 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3779 LV= 3 ABEND
*MCALL #=  3780 LV= 3          ENDIF 
*MCALL #=  3781 LV= 4          ZSTREQU 
*MEXIT #=  3781 LV= 4 ZSTREQU
#@IF_325_2                                               DS 0H
*MEXIT #=  3780 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3782 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3782 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'1E27'
*MCALL #=  3783 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3784 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3784 LV= 4 ZCALL
*MEXIT #=  3783 LV= 3 CALL
*MCALL #=  3785 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3785 LV= 3 WTO
*MCALL #=  3786 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3787 LV= 4          ZSTREQU 
*MEXIT #=  3787 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_326_2
*MEXIT #=  3786 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3788 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3788 LV= 3 WTO
*MCALL #=  3789 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3789 LV= 3 ABEND
*MCALL #=  3790 LV= 3          ENDIF 
*MCALL #=  3791 LV= 4          ZSTREQU 
*MEXIT #=  3791 LV= 4 ZSTREQU
#@IF_326_2                                               DS 0H
*MEXIT #=  3790 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'1E27'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'1E27'  VERIFY CTD CONSTANT WITH CFD RESUX
               LT
* RPI 786 START TEST FOR DFP
*MCALL #=  3792 LV= 3          RT1   CCE
         DS    0H
RT1_TEST210      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE210
         LTORG 
RT1_CCE210      DS 0H
*MEXIT #=  3792 LV= 3 RT1
         B     EXIT163
         LTORG 
EXIT163     DS 0H
*MEXIT #=  3771 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  3793 LV= 2          RT1   CCE
         DS    0H
RT1_TEST211      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE211
         LTORG 
RT1_CCE211      DS 0H
*MEXIT #=  3793 LV= 2 RT1
*MEXIT #=  3748 LV= 1 TEST
*MCALL #=  3794 LV= 1          TEST   INT128,=FL16'1E38'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  3795 LV= 2          TEST1 MF,INT128,=FL16'1E38'
         BASR  R12,0
         USING *,R12
*MCALL #=  3796 LV= 3          CTD   CTD_INT128,IN==FL16'1E38',OUT=DECIX
               MAL,LINKAGE=MF
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'1E38'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3796 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'1E38'
         LA    R3,L'=FL16'1E38'
*MCALL #=  3797 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3798 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3798 LV= 4 ZCALL
*MEXIT #=  3797 LV= 3 CALL
*MCALL #=  3799 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3799 LV= 3 WTO
*MCALL #=  3800 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3801 LV= 4          ZSTREQU 
*MEXIT #=  3801 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_327_2
*MEXIT #=  3800 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3802 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3802 LV= 3 WTO
*MCALL #=  3803 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3803 LV= 3 ABEND
*MCALL #=  3804 LV= 3          ENDIF 
*MCALL #=  3805 LV= 4          ZSTREQU 
*MEXIT #=  3805 LV= 4 ZSTREQU
#@IF_327_2                                               DS 0H
*MEXIT #=  3804 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3806 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3806 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'1E38'
*MCALL #=  3807 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3808 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3808 LV= 4 ZCALL
*MEXIT #=  3807 LV= 3 CALL
*MCALL #=  3809 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3809 LV= 3 WTO
*MCALL #=  3810 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3811 LV= 4          ZSTREQU 
*MEXIT #=  3811 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_328_2
*MEXIT #=  3810 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3812 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3812 LV= 3 WTO
*MCALL #=  3813 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3813 LV= 3 ABEND
*MCALL #=  3814 LV= 3          ENDIF 
*MCALL #=  3815 LV= 4          ZSTREQU 
*MEXIT #=  3815 LV= 4 ZSTREQU
#@IF_328_2                                               DS 0H
*MEXIT #=  3814 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'1E38'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'1E38'  VERIFY CTD CONSTANT WITH CFD RESUX
               LT
* RPI 786 START TEST FOR DFP
*MCALL #=  3816 LV= 3          RT1   CCE
         DS    0H
RT1_TEST212      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE212
         LTORG 
RT1_CCE212      DS 0H
*MEXIT #=  3816 LV= 3 RT1
         B     EXIT164
         LTORG 
EXIT164     DS 0H
*MEXIT #=  3795 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  3817 LV= 2          TEST1 SVC,INT128,=FL16'1E38'
         BASR  R12,0
         USING *,R12
*MCALL #=  3818 LV= 3          CTD   CTD_INT128,IN==FL16'1E38',OUT=DECIX
               MAL,LINKAGE=SVC
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'1E38'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3818 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'1E38'
         LA    R3,L'=FL16'1E38'
*MCALL #=  3819 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3820 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3820 LV= 4 ZCALL
*MEXIT #=  3819 LV= 3 CALL
*MCALL #=  3821 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3821 LV= 3 WTO
*MCALL #=  3822 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3823 LV= 4          ZSTREQU 
*MEXIT #=  3823 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_329_2
*MEXIT #=  3822 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3824 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3824 LV= 3 WTO
*MCALL #=  3825 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3825 LV= 3 ABEND
*MCALL #=  3826 LV= 3          ENDIF 
*MCALL #=  3827 LV= 4          ZSTREQU 
*MEXIT #=  3827 LV= 4 ZSTREQU
#@IF_329_2                                               DS 0H
*MEXIT #=  3826 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3828 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3828 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'1E38'
*MCALL #=  3829 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3830 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3830 LV= 4 ZCALL
*MEXIT #=  3829 LV= 3 CALL
*MCALL #=  3831 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3831 LV= 3 WTO
*MCALL #=  3832 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3833 LV= 4          ZSTREQU 
*MEXIT #=  3833 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_330_2
*MEXIT #=  3832 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3834 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3834 LV= 3 WTO
*MCALL #=  3835 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3835 LV= 3 ABEND
*MCALL #=  3836 LV= 3          ENDIF 
*MCALL #=  3837 LV= 4          ZSTREQU 
*MEXIT #=  3837 LV= 4 ZSTREQU
#@IF_330_2                                               DS 0H
*MEXIT #=  3836 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'1E38'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'1E38'  VERIFY CTD CONSTANT WITH CFD RESUX
               LT
* RPI 786 START TEST FOR DFP
*MCALL #=  3838 LV= 3          RT1   CCE
         DS    0H
RT1_TEST213      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE213
         LTORG 
RT1_CCE213      DS 0H
*MEXIT #=  3838 LV= 3 RT1
         B     EXIT165
         LTORG 
EXIT165     DS 0H
*MEXIT #=  3817 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  3839 LV= 2          RT1   CCE
         DS    0H
RT1_TEST214      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE214
         LTORG 
RT1_CCE214      DS 0H
*MEXIT #=  3839 LV= 2 RT1
*MEXIT #=  3794 LV= 1 TEST
*MCALL #=  3840 LV= 1          TEST   INT128,=FL16'-1'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  3841 LV= 2          TEST1 MF,INT128,=FL16'-1'
         BASR  R12,0
         USING *,R12
*MCALL #=  3842 LV= 3          CTD   CTD_INT128,IN==FL16'-1',OUT=DECIMAX
               L,LINKAGE=MF
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'-1'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3842 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'-1'
         LA    R3,L'=FL16'-1'
*MCALL #=  3843 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3844 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3844 LV= 4 ZCALL
*MEXIT #=  3843 LV= 3 CALL
*MCALL #=  3845 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3845 LV= 3 WTO
*MCALL #=  3846 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3847 LV= 4          ZSTREQU 
*MEXIT #=  3847 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_331_2
*MEXIT #=  3846 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3848 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3848 LV= 3 WTO
*MCALL #=  3849 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3849 LV= 3 ABEND
*MCALL #=  3850 LV= 3          ENDIF 
*MCALL #=  3851 LV= 4          ZSTREQU 
*MEXIT #=  3851 LV= 4 ZSTREQU
#@IF_331_2                                               DS 0H
*MEXIT #=  3850 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3852 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3852 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'-1'
*MCALL #=  3853 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3854 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3854 LV= 4 ZCALL
*MEXIT #=  3853 LV= 3 CALL
*MCALL #=  3855 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3855 LV= 3 WTO
*MCALL #=  3856 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3857 LV= 4          ZSTREQU 
*MEXIT #=  3857 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_332_2
*MEXIT #=  3856 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3858 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3858 LV= 3 WTO
*MCALL #=  3859 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3859 LV= 3 ABEND
*MCALL #=  3860 LV= 3          ENDIF 
*MCALL #=  3861 LV= 4          ZSTREQU 
*MEXIT #=  3861 LV= 4 ZSTREQU
#@IF_332_2                                               DS 0H
*MEXIT #=  3860 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'-1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'-1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  3862 LV= 3          RT1   CCE
         DS    0H
RT1_TEST215      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE215
         LTORG 
RT1_CCE215      DS 0H
*MEXIT #=  3862 LV= 3 RT1
         B     EXIT166
         LTORG 
EXIT166     DS 0H
*MEXIT #=  3841 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  3863 LV= 2          TEST1 SVC,INT128,=FL16'-1'
         BASR  R12,0
         USING *,R12
*MCALL #=  3864 LV= 3          CTD   CTD_INT128,IN==FL16'-1',OUT=DECIMAX
               L,LINKAGE=SVC
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'-1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3864 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'-1'
         LA    R3,L'=FL16'-1'
*MCALL #=  3865 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3866 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3866 LV= 4 ZCALL
*MEXIT #=  3865 LV= 3 CALL
*MCALL #=  3867 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3867 LV= 3 WTO
*MCALL #=  3868 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3869 LV= 4          ZSTREQU 
*MEXIT #=  3869 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_333_2
*MEXIT #=  3868 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3870 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3870 LV= 3 WTO
*MCALL #=  3871 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3871 LV= 3 ABEND
*MCALL #=  3872 LV= 3          ENDIF 
*MCALL #=  3873 LV= 4          ZSTREQU 
*MEXIT #=  3873 LV= 4 ZSTREQU
#@IF_333_2                                               DS 0H
*MEXIT #=  3872 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3874 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3874 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'-1'
*MCALL #=  3875 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3876 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3876 LV= 4 ZCALL
*MEXIT #=  3875 LV= 3 CALL
*MCALL #=  3877 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3877 LV= 3 WTO
*MCALL #=  3878 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3879 LV= 4          ZSTREQU 
*MEXIT #=  3879 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_334_2
*MEXIT #=  3878 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3880 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3880 LV= 3 WTO
*MCALL #=  3881 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3881 LV= 3 ABEND
*MCALL #=  3882 LV= 3          ENDIF 
*MCALL #=  3883 LV= 4          ZSTREQU 
*MEXIT #=  3883 LV= 4 ZSTREQU
#@IF_334_2                                               DS 0H
*MEXIT #=  3882 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'-1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'-1'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  3884 LV= 3          RT1   CCE
         DS    0H
RT1_TEST216      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE216
         LTORG 
RT1_CCE216      DS 0H
*MEXIT #=  3884 LV= 3 RT1
         B     EXIT167
         LTORG 
EXIT167     DS 0H
*MEXIT #=  3863 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  3885 LV= 2          RT1   CCE
         DS    0H
RT1_TEST217      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE217
         LTORG 
RT1_CCE217      DS 0H
*MEXIT #=  3885 LV= 2 RT1
*MEXIT #=  3840 LV= 1 TEST
*MCALL #=  3886 LV= 1          TEST   INT128,=FL16'-2'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  3887 LV= 2          TEST1 MF,INT128,=FL16'-2'
         BASR  R12,0
         USING *,R12
*MCALL #=  3888 LV= 3          CTD   CTD_INT128,IN==FL16'-2',OUT=DECIMAX
               L,LINKAGE=MF
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'-2'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3888 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'-2'
         LA    R3,L'=FL16'-2'
*MCALL #=  3889 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3890 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3890 LV= 4 ZCALL
*MEXIT #=  3889 LV= 3 CALL
*MCALL #=  3891 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3891 LV= 3 WTO
*MCALL #=  3892 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3893 LV= 4          ZSTREQU 
*MEXIT #=  3893 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_335_2
*MEXIT #=  3892 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3894 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3894 LV= 3 WTO
*MCALL #=  3895 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3895 LV= 3 ABEND
*MCALL #=  3896 LV= 3          ENDIF 
*MCALL #=  3897 LV= 4          ZSTREQU 
*MEXIT #=  3897 LV= 4 ZSTREQU
#@IF_335_2                                               DS 0H
*MEXIT #=  3896 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3898 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3898 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'-2'
*MCALL #=  3899 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3900 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3900 LV= 4 ZCALL
*MEXIT #=  3899 LV= 3 CALL
*MCALL #=  3901 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3901 LV= 3 WTO
*MCALL #=  3902 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3903 LV= 4          ZSTREQU 
*MEXIT #=  3903 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_336_2
*MEXIT #=  3902 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3904 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3904 LV= 3 WTO
*MCALL #=  3905 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3905 LV= 3 ABEND
*MCALL #=  3906 LV= 3          ENDIF 
*MCALL #=  3907 LV= 4          ZSTREQU 
*MEXIT #=  3907 LV= 4 ZSTREQU
#@IF_336_2                                               DS 0H
*MEXIT #=  3906 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'-2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'-2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  3908 LV= 3          RT1   CCE
         DS    0H
RT1_TEST218      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE218
         LTORG 
RT1_CCE218      DS 0H
*MEXIT #=  3908 LV= 3 RT1
         B     EXIT168
         LTORG 
EXIT168     DS 0H
*MEXIT #=  3887 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  3909 LV= 2          TEST1 SVC,INT128,=FL16'-2'
         BASR  R12,0
         USING *,R12
*MCALL #=  3910 LV= 3          CTD   CTD_INT128,IN==FL16'-2',OUT=DECIMAX
               L,LINKAGE=SVC
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'-2'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3910 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'-2'
         LA    R3,L'=FL16'-2'
*MCALL #=  3911 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3912 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3912 LV= 4 ZCALL
*MEXIT #=  3911 LV= 3 CALL
*MCALL #=  3913 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3913 LV= 3 WTO
*MCALL #=  3914 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3915 LV= 4          ZSTREQU 
*MEXIT #=  3915 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_337_2
*MEXIT #=  3914 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3916 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3916 LV= 3 WTO
*MCALL #=  3917 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3917 LV= 3 ABEND
*MCALL #=  3918 LV= 3          ENDIF 
*MCALL #=  3919 LV= 4          ZSTREQU 
*MEXIT #=  3919 LV= 4 ZSTREQU
#@IF_337_2                                               DS 0H
*MEXIT #=  3918 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3920 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3920 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'-2'
*MCALL #=  3921 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3922 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3922 LV= 4 ZCALL
*MEXIT #=  3921 LV= 3 CALL
*MCALL #=  3923 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3923 LV= 3 WTO
*MCALL #=  3924 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3925 LV= 4          ZSTREQU 
*MEXIT #=  3925 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_338_2
*MEXIT #=  3924 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3926 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3926 LV= 3 WTO
*MCALL #=  3927 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3927 LV= 3 ABEND
*MCALL #=  3928 LV= 3          ENDIF 
*MCALL #=  3929 LV= 4          ZSTREQU 
*MEXIT #=  3929 LV= 4 ZSTREQU
#@IF_338_2                                               DS 0H
*MEXIT #=  3928 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'-2'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'-2'  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  3930 LV= 3          RT1   CCE
         DS    0H
RT1_TEST219      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE219
         LTORG 
RT1_CCE219      DS 0H
*MEXIT #=  3930 LV= 3 RT1
         B     EXIT169
         LTORG 
EXIT169     DS 0H
*MEXIT #=  3909 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  3931 LV= 2          RT1   CCE
         DS    0H
RT1_TEST220      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE220
         LTORG 
RT1_CCE220      DS 0H
*MEXIT #=  3931 LV= 2 RT1
*MEXIT #=  3886 LV= 1 TEST
*MCALL #=  3932 LV= 1          TEST   INT128,=FL16'-1E6'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  3933 LV= 2          TEST1 MF,INT128,=FL16'-1E6'
         BASR  R12,0
         USING *,R12
*MCALL #=  3934 LV= 3          CTD   CTD_INT128,IN==FL16'-1E6',OUT=DECIX
               MAL,LINKAGE=MF
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'-1E6'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3934 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'-1E6'
         LA    R3,L'=FL16'-1E6'
*MCALL #=  3935 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3936 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3936 LV= 4 ZCALL
*MEXIT #=  3935 LV= 3 CALL
*MCALL #=  3937 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3937 LV= 3 WTO
*MCALL #=  3938 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3939 LV= 4          ZSTREQU 
*MEXIT #=  3939 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_339_2
*MEXIT #=  3938 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3940 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3940 LV= 3 WTO
*MCALL #=  3941 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3941 LV= 3 ABEND
*MCALL #=  3942 LV= 3          ENDIF 
*MCALL #=  3943 LV= 4          ZSTREQU 
*MEXIT #=  3943 LV= 4 ZSTREQU
#@IF_339_2                                               DS 0H
*MEXIT #=  3942 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3944 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3944 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'-1E6'
*MCALL #=  3945 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3946 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3946 LV= 4 ZCALL
*MEXIT #=  3945 LV= 3 CALL
*MCALL #=  3947 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3947 LV= 3 WTO
*MCALL #=  3948 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3949 LV= 4          ZSTREQU 
*MEXIT #=  3949 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_340_2
*MEXIT #=  3948 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3950 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3950 LV= 3 WTO
*MCALL #=  3951 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3951 LV= 3 ABEND
*MCALL #=  3952 LV= 3          ENDIF 
*MCALL #=  3953 LV= 4          ZSTREQU 
*MEXIT #=  3953 LV= 4 ZSTREQU
#@IF_340_2                                               DS 0H
*MEXIT #=  3952 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'-1E6'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'-1E6'  VERIFY CTD CONSTANT WITH CFD RESUX
               LT
* RPI 786 START TEST FOR DFP
*MCALL #=  3954 LV= 3          RT1   CCE
         DS    0H
RT1_TEST221      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE221
         LTORG 
RT1_CCE221      DS 0H
*MEXIT #=  3954 LV= 3 RT1
         B     EXIT170
         LTORG 
EXIT170     DS 0H
*MEXIT #=  3933 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  3955 LV= 2          TEST1 SVC,INT128,=FL16'-1E6'
         BASR  R12,0
         USING *,R12
*MCALL #=  3956 LV= 3          CTD   CTD_INT128,IN==FL16'-1E6',OUT=DECIX
               MAL,LINKAGE=SVC
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'-1E6'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  3956 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'-1E6'
         LA    R3,L'=FL16'-1E6'
*MCALL #=  3957 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3958 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3958 LV= 4 ZCALL
*MEXIT #=  3957 LV= 3 CALL
*MCALL #=  3959 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3959 LV= 3 WTO
*MCALL #=  3960 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3961 LV= 4          ZSTREQU 
*MEXIT #=  3961 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_341_2
*MEXIT #=  3960 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3962 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3962 LV= 3 WTO
*MCALL #=  3963 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3963 LV= 3 ABEND
*MCALL #=  3964 LV= 3          ENDIF 
*MCALL #=  3965 LV= 4          ZSTREQU 
*MEXIT #=  3965 LV= 4 ZSTREQU
#@IF_341_2                                               DS 0H
*MEXIT #=  3964 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3966 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  3966 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'-1E6'
*MCALL #=  3967 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3968 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3968 LV= 4 ZCALL
*MEXIT #=  3967 LV= 3 CALL
*MCALL #=  3969 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3969 LV= 3 WTO
*MCALL #=  3970 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3971 LV= 4          ZSTREQU 
*MEXIT #=  3971 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_342_2
*MEXIT #=  3970 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3972 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3972 LV= 3 WTO
*MCALL #=  3973 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3973 LV= 3 ABEND
*MCALL #=  3974 LV= 3          ENDIF 
*MCALL #=  3975 LV= 4          ZSTREQU 
*MEXIT #=  3975 LV= 4 ZSTREQU
#@IF_342_2                                               DS 0H
*MEXIT #=  3974 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'-1E6'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'-1E6'  VERIFY CTD CONSTANT WITH CFD RESUX
               LT
* RPI 786 START TEST FOR DFP
*MCALL #=  3976 LV= 3          RT1   CCE
         DS    0H
RT1_TEST222      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE222
         LTORG 
RT1_CCE222      DS 0H
*MEXIT #=  3976 LV= 3 RT1
         B     EXIT171
         LTORG 
EXIT171     DS 0H
*MEXIT #=  3955 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  3977 LV= 2          RT1   CCE
         DS    0H
RT1_TEST223      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE223
         LTORG 
RT1_CCE223      DS 0H
*MEXIT #=  3977 LV= 2 RT1
*MEXIT #=  3932 LV= 1 TEST
*MCALL #=  3978 LV= 1          TEST   INT128,=FL16'-1E13'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  3979 LV= 2          TEST1 MF,INT128,=FL16'-1E13'
         BASR  R12,0
         USING *,R12
*MCALL #=  3980 LV= 3          CTD   CTD_INT128,IN==FL16'-1E13',OUT=DECX
               IMAL,LINKAGE=MF
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'-1E13'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3980 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'-1E13'
         LA    R3,L'=FL16'-1E13'
*MCALL #=  3981 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  3982 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3982 LV= 4 ZCALL
*MEXIT #=  3981 LV= 3 CALL
*MCALL #=  3983 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3983 LV= 3 WTO
*MCALL #=  3984 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3985 LV= 4          ZSTREQU 
*MEXIT #=  3985 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_343_2
*MEXIT #=  3984 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3986 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3986 LV= 3 WTO
*MCALL #=  3987 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3987 LV= 3 ABEND
*MCALL #=  3988 LV= 3          ENDIF 
*MCALL #=  3989 LV= 4          ZSTREQU 
*MEXIT #=  3989 LV= 4 ZSTREQU
#@IF_343_2                                               DS 0H
*MEXIT #=  3988 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  3990 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  3990 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'-1E13'
*MCALL #=  3991 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  3992 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  3992 LV= 4 ZCALL
*MEXIT #=  3991 LV= 3 CALL
*MCALL #=  3993 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  3993 LV= 3 WTO
*MCALL #=  3994 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  3995 LV= 4          ZSTREQU 
*MEXIT #=  3995 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_344_2
*MEXIT #=  3994 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  3996 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  3996 LV= 3 WTO
*MCALL #=  3997 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  3997 LV= 3 ABEND
*MCALL #=  3998 LV= 3          ENDIF 
*MCALL #=  3999 LV= 4          ZSTREQU 
*MEXIT #=  3999 LV= 4 ZSTREQU
#@IF_344_2                                               DS 0H
*MEXIT #=  3998 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'-1E13'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'-1E13'  VERIFY CTD CONSTANT WITH CFD RESX
               ULT
* RPI 786 START TEST FOR DFP
*MCALL #=  4000 LV= 3          RT1   CCE
         DS    0H
RT1_TEST224      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE224
         LTORG 
RT1_CCE224      DS 0H
*MEXIT #=  4000 LV= 3 RT1
         B     EXIT172
         LTORG 
EXIT172     DS 0H
*MEXIT #=  3979 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  4001 LV= 2          TEST1 SVC,INT128,=FL16'-1E13'
         BASR  R12,0
         USING *,R12
*MCALL #=  4002 LV= 3          CTD   CTD_INT128,IN==FL16'-1E13',OUT=DECX
               IMAL,LINKAGE=SVC
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'-1E13'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  4002 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'-1E13'
         LA    R3,L'=FL16'-1E13'
*MCALL #=  4003 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  4004 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4004 LV= 4 ZCALL
*MEXIT #=  4003 LV= 3 CALL
*MCALL #=  4005 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4005 LV= 3 WTO
*MCALL #=  4006 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4007 LV= 4          ZSTREQU 
*MEXIT #=  4007 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_345_2
*MEXIT #=  4006 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4008 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4008 LV= 3 WTO
*MCALL #=  4009 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4009 LV= 3 ABEND
*MCALL #=  4010 LV= 3          ENDIF 
*MCALL #=  4011 LV= 4          ZSTREQU 
*MEXIT #=  4011 LV= 4 ZSTREQU
#@IF_345_2                                               DS 0H
*MEXIT #=  4010 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  4012 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  4012 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'-1E13'
*MCALL #=  4013 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  4014 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4014 LV= 4 ZCALL
*MEXIT #=  4013 LV= 3 CALL
*MCALL #=  4015 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4015 LV= 3 WTO
*MCALL #=  4016 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4017 LV= 4          ZSTREQU 
*MEXIT #=  4017 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_346_2
*MEXIT #=  4016 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4018 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4018 LV= 3 WTO
*MCALL #=  4019 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4019 LV= 3 ABEND
*MCALL #=  4020 LV= 3          ENDIF 
*MCALL #=  4021 LV= 4          ZSTREQU 
*MEXIT #=  4021 LV= 4 ZSTREQU
#@IF_346_2                                               DS 0H
*MEXIT #=  4020 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'-1E13'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'-1E13'  VERIFY CTD CONSTANT WITH CFD RESX
               ULT
* RPI 786 START TEST FOR DFP
*MCALL #=  4022 LV= 3          RT1   CCE
         DS    0H
RT1_TEST225      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE225
         LTORG 
RT1_CCE225      DS 0H
*MEXIT #=  4022 LV= 3 RT1
         B     EXIT173
         LTORG 
EXIT173     DS 0H
*MEXIT #=  4001 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  4023 LV= 2          RT1   CCE
         DS    0H
RT1_TEST226      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE226
         LTORG 
RT1_CCE226      DS 0H
*MEXIT #=  4023 LV= 2 RT1
*MEXIT #=  3978 LV= 1 TEST
*MCALL #=  4024 LV= 1          TEST   INT128,=FL16'-1E14'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  4025 LV= 2          TEST1 MF,INT128,=FL16'-1E14'
         BASR  R12,0
         USING *,R12
*MCALL #=  4026 LV= 3          CTD   CTD_INT128,IN==FL16'-1E14',OUT=DECX
               IMAL,LINKAGE=MF
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'-1E14'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  4026 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'-1E14'
         LA    R3,L'=FL16'-1E14'
*MCALL #=  4027 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  4028 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4028 LV= 4 ZCALL
*MEXIT #=  4027 LV= 3 CALL
*MCALL #=  4029 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4029 LV= 3 WTO
*MCALL #=  4030 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4031 LV= 4          ZSTREQU 
*MEXIT #=  4031 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_347_2
*MEXIT #=  4030 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4032 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4032 LV= 3 WTO
*MCALL #=  4033 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4033 LV= 3 ABEND
*MCALL #=  4034 LV= 3          ENDIF 
*MCALL #=  4035 LV= 4          ZSTREQU 
*MEXIT #=  4035 LV= 4 ZSTREQU
#@IF_347_2                                               DS 0H
*MEXIT #=  4034 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  4036 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  4036 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'-1E14'
*MCALL #=  4037 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  4038 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4038 LV= 4 ZCALL
*MEXIT #=  4037 LV= 3 CALL
*MCALL #=  4039 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4039 LV= 3 WTO
*MCALL #=  4040 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4041 LV= 4          ZSTREQU 
*MEXIT #=  4041 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_348_2
*MEXIT #=  4040 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4042 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4042 LV= 3 WTO
*MCALL #=  4043 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4043 LV= 3 ABEND
*MCALL #=  4044 LV= 3          ENDIF 
*MCALL #=  4045 LV= 4          ZSTREQU 
*MEXIT #=  4045 LV= 4 ZSTREQU
#@IF_348_2                                               DS 0H
*MEXIT #=  4044 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'-1E14'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'-1E14'  VERIFY CTD CONSTANT WITH CFD RESX
               ULT
* RPI 786 START TEST FOR DFP
*MCALL #=  4046 LV= 3          RT1   CCE
         DS    0H
RT1_TEST227      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE227
         LTORG 
RT1_CCE227      DS 0H
*MEXIT #=  4046 LV= 3 RT1
         B     EXIT174
         LTORG 
EXIT174     DS 0H
*MEXIT #=  4025 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  4047 LV= 2          TEST1 SVC,INT128,=FL16'-1E14'
         BASR  R12,0
         USING *,R12
*MCALL #=  4048 LV= 3          CTD   CTD_INT128,IN==FL16'-1E14',OUT=DECX
               IMAL,LINKAGE=SVC
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'-1E14'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  4048 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'-1E14'
         LA    R3,L'=FL16'-1E14'
*MCALL #=  4049 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  4050 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4050 LV= 4 ZCALL
*MEXIT #=  4049 LV= 3 CALL
*MCALL #=  4051 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4051 LV= 3 WTO
*MCALL #=  4052 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4053 LV= 4          ZSTREQU 
*MEXIT #=  4053 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_349_2
*MEXIT #=  4052 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4054 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4054 LV= 3 WTO
*MCALL #=  4055 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4055 LV= 3 ABEND
*MCALL #=  4056 LV= 3          ENDIF 
*MCALL #=  4057 LV= 4          ZSTREQU 
*MEXIT #=  4057 LV= 4 ZSTREQU
#@IF_349_2                                               DS 0H
*MEXIT #=  4056 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  4058 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  4058 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'-1E14'
*MCALL #=  4059 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  4060 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4060 LV= 4 ZCALL
*MEXIT #=  4059 LV= 3 CALL
*MCALL #=  4061 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4061 LV= 3 WTO
*MCALL #=  4062 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4063 LV= 4          ZSTREQU 
*MEXIT #=  4063 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_350_2
*MEXIT #=  4062 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4064 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4064 LV= 3 WTO
*MCALL #=  4065 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4065 LV= 3 ABEND
*MCALL #=  4066 LV= 3          ENDIF 
*MCALL #=  4067 LV= 4          ZSTREQU 
*MEXIT #=  4067 LV= 4 ZSTREQU
#@IF_350_2                                               DS 0H
*MEXIT #=  4066 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'-1E14'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'-1E14'  VERIFY CTD CONSTANT WITH CFD RESX
               ULT
* RPI 786 START TEST FOR DFP
*MCALL #=  4068 LV= 3          RT1   CCE
         DS    0H
RT1_TEST228      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE228
         LTORG 
RT1_CCE228      DS 0H
*MEXIT #=  4068 LV= 3 RT1
         B     EXIT175
         LTORG 
EXIT175     DS 0H
*MEXIT #=  4047 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  4069 LV= 2          RT1   CCE
         DS    0H
RT1_TEST229      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE229
         LTORG 
RT1_CCE229      DS 0H
*MEXIT #=  4069 LV= 2 RT1
*MEXIT #=  4024 LV= 1 TEST
*MCALL #=  4070 LV= 1          TEST   INT128,=FL16S63'-1'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  4071 LV= 2          TEST1 MF,INT128,=FL16S63'-1'
         BASR  R12,0
         USING *,R12
*MCALL #=  4072 LV= 3          CTD   CTD_INT128,IN==FL16S63'-1',OUT=DECX
               IMAL,LINKAGE=MF
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16S63'-1'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  4072 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16S63'-1'
         LA    R3,L'=FL16S63'-1'
*MCALL #=  4073 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  4074 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4074 LV= 4 ZCALL
*MEXIT #=  4073 LV= 3 CALL
*MCALL #=  4075 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4075 LV= 3 WTO
*MCALL #=  4076 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4077 LV= 4          ZSTREQU 
*MEXIT #=  4077 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_351_2
*MEXIT #=  4076 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4078 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4078 LV= 3 WTO
*MCALL #=  4079 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4079 LV= 3 ABEND
*MCALL #=  4080 LV= 3          ENDIF 
*MCALL #=  4081 LV= 4          ZSTREQU 
*MEXIT #=  4081 LV= 4 ZSTREQU
#@IF_351_2                                               DS 0H
*MEXIT #=  4080 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  4082 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  4082 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16S63'-1'
*MCALL #=  4083 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  4084 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4084 LV= 4 ZCALL
*MEXIT #=  4083 LV= 3 CALL
*MCALL #=  4085 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4085 LV= 3 WTO
*MCALL #=  4086 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4087 LV= 4          ZSTREQU 
*MEXIT #=  4087 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_352_2
*MEXIT #=  4086 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4088 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4088 LV= 3 WTO
*MCALL #=  4089 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4089 LV= 3 ABEND
*MCALL #=  4090 LV= 3          ENDIF 
*MCALL #=  4091 LV= 4          ZSTREQU 
*MEXIT #=  4091 LV= 4 ZSTREQU
#@IF_352_2                                               DS 0H
*MEXIT #=  4090 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16S63'-1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16S63'-1'  VERIFY CTD CONSTANT WITH CFD RESX
               ULT
* RPI 786 START TEST FOR DFP
*MCALL #=  4092 LV= 3          RT1   CCE
         DS    0H
RT1_TEST230      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE230
         LTORG 
RT1_CCE230      DS 0H
*MEXIT #=  4092 LV= 3 RT1
         B     EXIT176
         LTORG 
EXIT176     DS 0H
*MEXIT #=  4071 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  4093 LV= 2          TEST1 SVC,INT128,=FL16S63'-1'
         BASR  R12,0
         USING *,R12
*MCALL #=  4094 LV= 3          CTD   CTD_INT128,IN==FL16S63'-1',OUT=DECX
               IMAL,LINKAGE=SVC
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16S63'-1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  4094 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16S63'-1'
         LA    R3,L'=FL16S63'-1'
*MCALL #=  4095 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  4096 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4096 LV= 4 ZCALL
*MEXIT #=  4095 LV= 3 CALL
*MCALL #=  4097 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4097 LV= 3 WTO
*MCALL #=  4098 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4099 LV= 4          ZSTREQU 
*MEXIT #=  4099 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_353_2
*MEXIT #=  4098 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4100 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4100 LV= 3 WTO
*MCALL #=  4101 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4101 LV= 3 ABEND
*MCALL #=  4102 LV= 3          ENDIF 
*MCALL #=  4103 LV= 4          ZSTREQU 
*MEXIT #=  4103 LV= 4 ZSTREQU
#@IF_353_2                                               DS 0H
*MEXIT #=  4102 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  4104 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  4104 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16S63'-1'
*MCALL #=  4105 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  4106 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4106 LV= 4 ZCALL
*MEXIT #=  4105 LV= 3 CALL
*MCALL #=  4107 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4107 LV= 3 WTO
*MCALL #=  4108 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4109 LV= 4          ZSTREQU 
*MEXIT #=  4109 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_354_2
*MEXIT #=  4108 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4110 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4110 LV= 3 WTO
*MCALL #=  4111 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4111 LV= 3 ABEND
*MCALL #=  4112 LV= 3          ENDIF 
*MCALL #=  4113 LV= 4          ZSTREQU 
*MEXIT #=  4113 LV= 4 ZSTREQU
#@IF_354_2                                               DS 0H
*MEXIT #=  4112 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16S63'-1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16S63'-1'  VERIFY CTD CONSTANT WITH CFD RESX
               ULT
* RPI 786 START TEST FOR DFP
*MCALL #=  4114 LV= 3          RT1   CCE
         DS    0H
RT1_TEST231      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE231
         LTORG 
RT1_CCE231      DS 0H
*MEXIT #=  4114 LV= 3 RT1
         B     EXIT177
         LTORG 
EXIT177     DS 0H
*MEXIT #=  4093 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  4115 LV= 2          RT1   CCE
         DS    0H
RT1_TEST232      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE232
         LTORG 
RT1_CCE232      DS 0H
*MEXIT #=  4115 LV= 2 RT1
*MEXIT #=  4070 LV= 1 TEST
*MCALL #=  4116 LV= 1          TEST   INT128,=FL16S64'-1'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  4117 LV= 2          TEST1 MF,INT128,=FL16S64'-1'
         BASR  R12,0
         USING *,R12
*MCALL #=  4118 LV= 3          CTD   CTD_INT128,IN==FL16S64'-1',OUT=DECX
               IMAL,LINKAGE=MF
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16S64'-1'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  4118 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16S64'-1'
         LA    R3,L'=FL16S64'-1'
*MCALL #=  4119 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  4120 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4120 LV= 4 ZCALL
*MEXIT #=  4119 LV= 3 CALL
*MCALL #=  4121 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4121 LV= 3 WTO
*MCALL #=  4122 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4123 LV= 4          ZSTREQU 
*MEXIT #=  4123 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_355_2
*MEXIT #=  4122 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4124 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4124 LV= 3 WTO
*MCALL #=  4125 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4125 LV= 3 ABEND
*MCALL #=  4126 LV= 3          ENDIF 
*MCALL #=  4127 LV= 4          ZSTREQU 
*MEXIT #=  4127 LV= 4 ZSTREQU
#@IF_355_2                                               DS 0H
*MEXIT #=  4126 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  4128 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  4128 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16S64'-1'
*MCALL #=  4129 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  4130 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4130 LV= 4 ZCALL
*MEXIT #=  4129 LV= 3 CALL
*MCALL #=  4131 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4131 LV= 3 WTO
*MCALL #=  4132 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4133 LV= 4          ZSTREQU 
*MEXIT #=  4133 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_356_2
*MEXIT #=  4132 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4134 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4134 LV= 3 WTO
*MCALL #=  4135 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4135 LV= 3 ABEND
*MCALL #=  4136 LV= 3          ENDIF 
*MCALL #=  4137 LV= 4          ZSTREQU 
*MEXIT #=  4137 LV= 4 ZSTREQU
#@IF_356_2                                               DS 0H
*MEXIT #=  4136 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16S64'-1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16S64'-1'  VERIFY CTD CONSTANT WITH CFD RESX
               ULT
* RPI 786 START TEST FOR DFP
*MCALL #=  4138 LV= 3          RT1   CCE
         DS    0H
RT1_TEST233      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE233
         LTORG 
RT1_CCE233      DS 0H
*MEXIT #=  4138 LV= 3 RT1
         B     EXIT178
         LTORG 
EXIT178     DS 0H
*MEXIT #=  4117 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  4139 LV= 2          TEST1 SVC,INT128,=FL16S64'-1'
         BASR  R12,0
         USING *,R12
*MCALL #=  4140 LV= 3          CTD   CTD_INT128,IN==FL16S64'-1',OUT=DECX
               IMAL,LINKAGE=SVC
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16S64'-1'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  4140 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16S64'-1'
         LA    R3,L'=FL16S64'-1'
*MCALL #=  4141 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  4142 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4142 LV= 4 ZCALL
*MEXIT #=  4141 LV= 3 CALL
*MCALL #=  4143 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4143 LV= 3 WTO
*MCALL #=  4144 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4145 LV= 4          ZSTREQU 
*MEXIT #=  4145 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_357_2
*MEXIT #=  4144 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4146 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4146 LV= 3 WTO
*MCALL #=  4147 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4147 LV= 3 ABEND
*MCALL #=  4148 LV= 3          ENDIF 
*MCALL #=  4149 LV= 4          ZSTREQU 
*MEXIT #=  4149 LV= 4 ZSTREQU
#@IF_357_2                                               DS 0H
*MEXIT #=  4148 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  4150 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  4150 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16S64'-1'
*MCALL #=  4151 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  4152 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4152 LV= 4 ZCALL
*MEXIT #=  4151 LV= 3 CALL
*MCALL #=  4153 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4153 LV= 3 WTO
*MCALL #=  4154 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4155 LV= 4          ZSTREQU 
*MEXIT #=  4155 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_358_2
*MEXIT #=  4154 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4156 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4156 LV= 3 WTO
*MCALL #=  4157 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4157 LV= 3 ABEND
*MCALL #=  4158 LV= 3          ENDIF 
*MCALL #=  4159 LV= 4          ZSTREQU 
*MEXIT #=  4159 LV= 4 ZSTREQU
#@IF_358_2                                               DS 0H
*MEXIT #=  4158 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16S64'-1'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16S64'-1'  VERIFY CTD CONSTANT WITH CFD RESX
               ULT
* RPI 786 START TEST FOR DFP
*MCALL #=  4160 LV= 3          RT1   CCE
         DS    0H
RT1_TEST234      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE234
         LTORG 
RT1_CCE234      DS 0H
*MEXIT #=  4160 LV= 3 RT1
         B     EXIT179
         LTORG 
EXIT179     DS 0H
*MEXIT #=  4139 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  4161 LV= 2          RT1   CCE
         DS    0H
RT1_TEST235      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE235
         LTORG 
RT1_CCE235      DS 0H
*MEXIT #=  4161 LV= 2 RT1
*MEXIT #=  4116 LV= 1 TEST
*MCALL #=  4162 LV= 1          TEST   INT128,=FL16'-1E26'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  4163 LV= 2          TEST1 MF,INT128,=FL16'-1E26'
         BASR  R12,0
         USING *,R12
*MCALL #=  4164 LV= 3          CTD   CTD_INT128,IN==FL16'-1E26',OUT=DECX
               IMAL,LINKAGE=MF
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'-1E26'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  4164 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'-1E26'
         LA    R3,L'=FL16'-1E26'
*MCALL #=  4165 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  4166 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4166 LV= 4 ZCALL
*MEXIT #=  4165 LV= 3 CALL
*MCALL #=  4167 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4167 LV= 3 WTO
*MCALL #=  4168 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4169 LV= 4          ZSTREQU 
*MEXIT #=  4169 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_359_2
*MEXIT #=  4168 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4170 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4170 LV= 3 WTO
*MCALL #=  4171 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4171 LV= 3 ABEND
*MCALL #=  4172 LV= 3          ENDIF 
*MCALL #=  4173 LV= 4          ZSTREQU 
*MEXIT #=  4173 LV= 4 ZSTREQU
#@IF_359_2                                               DS 0H
*MEXIT #=  4172 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  4174 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  4174 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'-1E26'
*MCALL #=  4175 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  4176 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4176 LV= 4 ZCALL
*MEXIT #=  4175 LV= 3 CALL
*MCALL #=  4177 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4177 LV= 3 WTO
*MCALL #=  4178 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4179 LV= 4          ZSTREQU 
*MEXIT #=  4179 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_360_2
*MEXIT #=  4178 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4180 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4180 LV= 3 WTO
*MCALL #=  4181 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4181 LV= 3 ABEND
*MCALL #=  4182 LV= 3          ENDIF 
*MCALL #=  4183 LV= 4          ZSTREQU 
*MEXIT #=  4183 LV= 4 ZSTREQU
#@IF_360_2                                               DS 0H
*MEXIT #=  4182 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'-1E26'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'-1E26'  VERIFY CTD CONSTANT WITH CFD RESX
               ULT
* RPI 786 START TEST FOR DFP
*MCALL #=  4184 LV= 3          RT1   CCE
         DS    0H
RT1_TEST236      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE236
         LTORG 
RT1_CCE236      DS 0H
*MEXIT #=  4184 LV= 3 RT1
         B     EXIT180
         LTORG 
EXIT180     DS 0H
*MEXIT #=  4163 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  4185 LV= 2          TEST1 SVC,INT128,=FL16'-1E26'
         BASR  R12,0
         USING *,R12
*MCALL #=  4186 LV= 3          CTD   CTD_INT128,IN==FL16'-1E26',OUT=DECX
               IMAL,LINKAGE=SVC
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'-1E26'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  4186 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'-1E26'
         LA    R3,L'=FL16'-1E26'
*MCALL #=  4187 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  4188 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4188 LV= 4 ZCALL
*MEXIT #=  4187 LV= 3 CALL
*MCALL #=  4189 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4189 LV= 3 WTO
*MCALL #=  4190 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4191 LV= 4          ZSTREQU 
*MEXIT #=  4191 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_361_2
*MEXIT #=  4190 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4192 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4192 LV= 3 WTO
*MCALL #=  4193 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4193 LV= 3 ABEND
*MCALL #=  4194 LV= 3          ENDIF 
*MCALL #=  4195 LV= 4          ZSTREQU 
*MEXIT #=  4195 LV= 4 ZSTREQU
#@IF_361_2                                               DS 0H
*MEXIT #=  4194 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  4196 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  4196 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'-1E26'
*MCALL #=  4197 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  4198 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4198 LV= 4 ZCALL
*MEXIT #=  4197 LV= 3 CALL
*MCALL #=  4199 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4199 LV= 3 WTO
*MCALL #=  4200 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4201 LV= 4          ZSTREQU 
*MEXIT #=  4201 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_362_2
*MEXIT #=  4200 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4202 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4202 LV= 3 WTO
*MCALL #=  4203 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4203 LV= 3 ABEND
*MCALL #=  4204 LV= 3          ENDIF 
*MCALL #=  4205 LV= 4          ZSTREQU 
*MEXIT #=  4205 LV= 4 ZSTREQU
#@IF_362_2                                               DS 0H
*MEXIT #=  4204 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'-1E26'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'-1E26'  VERIFY CTD CONSTANT WITH CFD RESX
               ULT
* RPI 786 START TEST FOR DFP
*MCALL #=  4206 LV= 3          RT1   CCE
         DS    0H
RT1_TEST237      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE237
         LTORG 
RT1_CCE237      DS 0H
*MEXIT #=  4206 LV= 3 RT1
         B     EXIT181
         LTORG 
EXIT181     DS 0H
*MEXIT #=  4185 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  4207 LV= 2          RT1   CCE
         DS    0H
RT1_TEST238      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE238
         LTORG 
RT1_CCE238      DS 0H
*MEXIT #=  4207 LV= 2 RT1
*MEXIT #=  4162 LV= 1 TEST
*MCALL #=  4208 LV= 1          TEST   INT128,=FL16'-1E27'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  4209 LV= 2          TEST1 MF,INT128,=FL16'-1E27'
         BASR  R12,0
         USING *,R12
*MCALL #=  4210 LV= 3          CTD   CTD_INT128,IN==FL16'-1E27',OUT=DECX
               IMAL,LINKAGE=MF
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'-1E27'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  4210 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'-1E27'
         LA    R3,L'=FL16'-1E27'
*MCALL #=  4211 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  4212 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4212 LV= 4 ZCALL
*MEXIT #=  4211 LV= 3 CALL
*MCALL #=  4213 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4213 LV= 3 WTO
*MCALL #=  4214 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4215 LV= 4          ZSTREQU 
*MEXIT #=  4215 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_363_2
*MEXIT #=  4214 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4216 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4216 LV= 3 WTO
*MCALL #=  4217 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4217 LV= 3 ABEND
*MCALL #=  4218 LV= 3          ENDIF 
*MCALL #=  4219 LV= 4          ZSTREQU 
*MEXIT #=  4219 LV= 4 ZSTREQU
#@IF_363_2                                               DS 0H
*MEXIT #=  4218 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  4220 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  4220 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'-1E27'
*MCALL #=  4221 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  4222 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4222 LV= 4 ZCALL
*MEXIT #=  4221 LV= 3 CALL
*MCALL #=  4223 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4223 LV= 3 WTO
*MCALL #=  4224 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4225 LV= 4          ZSTREQU 
*MEXIT #=  4225 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_364_2
*MEXIT #=  4224 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4226 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4226 LV= 3 WTO
*MCALL #=  4227 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4227 LV= 3 ABEND
*MCALL #=  4228 LV= 3          ENDIF 
*MCALL #=  4229 LV= 4          ZSTREQU 
*MEXIT #=  4229 LV= 4 ZSTREQU
#@IF_364_2                                               DS 0H
*MEXIT #=  4228 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'-1E27'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'-1E27'  VERIFY CTD CONSTANT WITH CFD RESX
               ULT
* RPI 786 START TEST FOR DFP
*MCALL #=  4230 LV= 3          RT1   CCE
         DS    0H
RT1_TEST239      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE239
         LTORG 
RT1_CCE239      DS 0H
*MEXIT #=  4230 LV= 3 RT1
         B     EXIT182
         LTORG 
EXIT182     DS 0H
*MEXIT #=  4209 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  4231 LV= 2          TEST1 SVC,INT128,=FL16'-1E27'
         BASR  R12,0
         USING *,R12
*MCALL #=  4232 LV= 3          CTD   CTD_INT128,IN==FL16'-1E27',OUT=DECX
               IMAL,LINKAGE=SVC
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'-1E27'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  4232 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'-1E27'
         LA    R3,L'=FL16'-1E27'
*MCALL #=  4233 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  4234 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4234 LV= 4 ZCALL
*MEXIT #=  4233 LV= 3 CALL
*MCALL #=  4235 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4235 LV= 3 WTO
*MCALL #=  4236 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4237 LV= 4          ZSTREQU 
*MEXIT #=  4237 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_365_2
*MEXIT #=  4236 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4238 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4238 LV= 3 WTO
*MCALL #=  4239 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4239 LV= 3 ABEND
*MCALL #=  4240 LV= 3          ENDIF 
*MCALL #=  4241 LV= 4          ZSTREQU 
*MEXIT #=  4241 LV= 4 ZSTREQU
#@IF_365_2                                               DS 0H
*MEXIT #=  4240 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  4242 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  4242 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'-1E27'
*MCALL #=  4243 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  4244 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4244 LV= 4 ZCALL
*MEXIT #=  4243 LV= 3 CALL
*MCALL #=  4245 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4245 LV= 3 WTO
*MCALL #=  4246 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4247 LV= 4          ZSTREQU 
*MEXIT #=  4247 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_366_2
*MEXIT #=  4246 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4248 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4248 LV= 3 WTO
*MCALL #=  4249 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4249 LV= 3 ABEND
*MCALL #=  4250 LV= 3          ENDIF 
*MCALL #=  4251 LV= 4          ZSTREQU 
*MEXIT #=  4251 LV= 4 ZSTREQU
#@IF_366_2                                               DS 0H
*MEXIT #=  4250 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'-1E27'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'-1E27'  VERIFY CTD CONSTANT WITH CFD RESX
               ULT
* RPI 786 START TEST FOR DFP
*MCALL #=  4252 LV= 3          RT1   CCE
         DS    0H
RT1_TEST240      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE240
         LTORG 
RT1_CCE240      DS 0H
*MEXIT #=  4252 LV= 3 RT1
         B     EXIT183
         LTORG 
EXIT183     DS 0H
*MEXIT #=  4231 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  4253 LV= 2          RT1   CCE
         DS    0H
RT1_TEST241      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE241
         LTORG 
RT1_CCE241      DS 0H
*MEXIT #=  4253 LV= 2 RT1
*MEXIT #=  4208 LV= 1 TEST
*MCALL #=  4254 LV= 1          TEST   INT128,=FL16'-1E38'
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  4255 LV= 2          TEST1 MF,INT128,=FL16'-1E38'
         BASR  R12,0
         USING *,R12
*MCALL #=  4256 LV= 3          CTD   CTD_INT128,IN==FL16'-1E38',OUT=DECX
               IMAL,LINKAGE=MF
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'-1E38'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  4256 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'-1E38'
         LA    R3,L'=FL16'-1E38'
*MCALL #=  4257 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  4258 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4258 LV= 4 ZCALL
*MEXIT #=  4257 LV= 3 CALL
*MCALL #=  4259 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4259 LV= 3 WTO
*MCALL #=  4260 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4261 LV= 4          ZSTREQU 
*MEXIT #=  4261 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_367_2
*MEXIT #=  4260 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4262 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4262 LV= 3 WTO
*MCALL #=  4263 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4263 LV= 3 ABEND
*MCALL #=  4264 LV= 3          ENDIF 
*MCALL #=  4265 LV= 4          ZSTREQU 
*MEXIT #=  4265 LV= 4 ZSTREQU
#@IF_367_2                                               DS 0H
*MEXIT #=  4264 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  4266 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  4266 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'-1E38'
*MCALL #=  4267 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  4268 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4268 LV= 4 ZCALL
*MEXIT #=  4267 LV= 3 CALL
*MCALL #=  4269 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4269 LV= 3 WTO
*MCALL #=  4270 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4271 LV= 4          ZSTREQU 
*MEXIT #=  4271 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_368_2
*MEXIT #=  4270 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4272 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4272 LV= 3 WTO
*MCALL #=  4273 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4273 LV= 3 ABEND
*MCALL #=  4274 LV= 3          ENDIF 
*MCALL #=  4275 LV= 4          ZSTREQU 
*MEXIT #=  4275 LV= 4 ZSTREQU
#@IF_368_2                                               DS 0H
*MEXIT #=  4274 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'-1E38'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'-1E38'  VERIFY CTD CONSTANT WITH CFD RESX
               ULT
* RPI 786 START TEST FOR DFP
*MCALL #=  4276 LV= 3          RT1   CCE
         DS    0H
RT1_TEST242      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE242
         LTORG 
RT1_CCE242      DS 0H
*MEXIT #=  4276 LV= 3 RT1
         B     EXIT184
         LTORG 
EXIT184     DS 0H
*MEXIT #=  4255 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  4277 LV= 2          TEST1 SVC,INT128,=FL16'-1E38'
         BASR  R12,0
         USING *,R12
*MCALL #=  4278 LV= 3          CTD   CTD_INT128,IN==FL16'-1E38',OUT=DECX
               IMAL,LINKAGE=SVC
         LA    1,=A(CTD_INT128,0,DECIMAL)
         LA    0,=FL16'-1E38'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  4278 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,=FL16'-1E38'
         LA    R3,L'=FL16'-1E38'
*MCALL #=  4279 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  4280 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4280 LV= 4 ZCALL
*MEXIT #=  4279 LV= 3 CALL
*MCALL #=  4281 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4281 LV= 3 WTO
*MCALL #=  4282 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4283 LV= 4          ZSTREQU 
*MEXIT #=  4283 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_369_2
*MEXIT #=  4282 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4284 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4284 LV= 3 WTO
*MCALL #=  4285 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4285 LV= 3 ABEND
*MCALL #=  4286 LV= 3          ENDIF 
*MCALL #=  4287 LV= 4          ZSTREQU 
*MEXIT #=  4287 LV= 4 ZSTREQU
#@IF_369_2                                               DS 0H
*MEXIT #=  4286 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  4288 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  4288 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'=FL16'-1E38'
*MCALL #=  4289 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  4290 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4290 LV= 4 ZCALL
*MEXIT #=  4289 LV= 3 CALL
*MCALL #=  4291 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4291 LV= 3 WTO
*MCALL #=  4292 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4293 LV= 4          ZSTREQU 
*MEXIT #=  4293 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_370_2
*MEXIT #=  4292 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4294 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4294 LV= 3 WTO
*MCALL #=  4295 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4295 LV= 3 ABEND
*MCALL #=  4296 LV= 3          ENDIF 
*MCALL #=  4297 LV= 4          ZSTREQU 
*MEXIT #=  4297 LV= 4 ZSTREQU
#@IF_370_2                                               DS 0H
*MEXIT #=  4296 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'=FL16'-1E38'
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),=FL16'-1E38'  VERIFY CTD CONSTANT WITH CFD RESX
               ULT
* RPI 786 START TEST FOR DFP
*MCALL #=  4298 LV= 3          RT1   CCE
         DS    0H
RT1_TEST243      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE243
         LTORG 
RT1_CCE243      DS 0H
*MEXIT #=  4298 LV= 3 RT1
         B     EXIT185
         LTORG 
EXIT185     DS 0H
*MEXIT #=  4277 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  4299 LV= 2          RT1   CCE
         DS    0H
RT1_TEST244      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE244
         LTORG 
RT1_CCE244      DS 0H
*MEXIT #=  4299 LV= 2 RT1
*MEXIT #=  4254 LV= 1 TEST
*MCALL #=  4300 LV= 1          TEST   INT128,INT128 MAX NEG
         BALR  R10,0                              RPI 786
         USING *,R10                              RPI 786
*MCALL #=  4301 LV= 2          TEST1 MF,INT128,INT128
         BASR  R12,0
         USING *,R12
*MCALL #=  4302 LV= 3          CTD   CTD_INT128,IN=INT128,OUT=DECIMAL,LX
               INKAGE=MF
         LA    1,=A(CTD_INT128,INT128,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  4302 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,INT128
         LA    R3,L'INT128
*MCALL #=  4303 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  4304 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4304 LV= 4 ZCALL
*MEXIT #=  4303 LV= 3 CALL
*MCALL #=  4305 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4305 LV= 3 WTO
*MCALL #=  4306 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4307 LV= 4          ZSTREQU 
*MEXIT #=  4307 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_371_2
*MEXIT #=  4306 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4308 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4308 LV= 3 WTO
*MCALL #=  4309 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4309 LV= 3 ABEND
*MCALL #=  4310 LV= 3          ENDIF 
*MCALL #=  4311 LV= 4          ZSTREQU 
*MEXIT #=  4311 LV= 4 ZSTREQU
#@IF_371_2                                               DS 0H
*MEXIT #=  4310 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  4312 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=MF
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=  4312 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'INT128
*MCALL #=  4313 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  4314 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4314 LV= 4 ZCALL
*MEXIT #=  4313 LV= 3 CALL
*MCALL #=  4315 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4315 LV= 3 WTO
*MCALL #=  4316 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4317 LV= 4          ZSTREQU 
*MEXIT #=  4317 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_372_2
*MEXIT #=  4316 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4318 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4318 LV= 3 WTO
*MCALL #=  4319 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4319 LV= 3 ABEND
*MCALL #=  4320 LV= 3          ENDIF 
*MCALL #=  4321 LV= 4          ZSTREQU 
*MEXIT #=  4321 LV= 4 ZSTREQU
#@IF_372_2                                               DS 0H
*MEXIT #=  4320 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'INT128
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),INT128  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  4322 LV= 3          RT1   CCE
         DS    0H
RT1_TEST245      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE245
         LTORG 
RT1_CCE245      DS 0H
*MEXIT #=  4322 LV= 3 RT1
         B     EXIT186
         LTORG 
EXIT186     DS 0H
*MEXIT #=  4301 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=  4323 LV= 2          TEST1 SVC,INT128,INT128
         BASR  R12,0
         USING *,R12
*MCALL #=  4324 LV= 3          CTD   CTD_INT128,IN=INT128,OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_INT128,INT128,DECIMAL)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=  4324 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D INT128'
         MVC   DHEX,=CL32' '
         LA    R2,INT128
         LA    R3,L'INT128
*MCALL #=  4325 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=  4326 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4326 LV= 4 ZCALL
*MEXIT #=  4325 LV= 3 CALL
*MCALL #=  4327 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4327 LV= 3 WTO
*MCALL #=  4328 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4329 LV= 4          ZSTREQU 
*MEXIT #=  4329 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_373_2
*MEXIT #=  4328 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4330 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4330 LV= 3 WTO
*MCALL #=  4331 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4331 LV= 3 ABEND
*MCALL #=  4332 LV= 3          ENDIF 
*MCALL #=  4333 LV= 4          ZSTREQU 
*MEXIT #=  4333 LV= 4 ZSTREQU
#@IF_373_2                                               DS 0H
*MEXIT #=  4332 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=  4334 LV= 3          CFD   CFD_INT128,OUT=WORK16,IN=DECIMAL,LX
               INKAGE=SVC
         DS    0H
         LA    1,=A(CFD_INT128,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=  4334 LV= 3 CFD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S<D INT128'
         MVC   DHEX,=CL32' '
         LA    R3,L'INT128
*MCALL #=  4335 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=  4336 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=  4336 LV= 4 ZCALL
*MEXIT #=  4335 LV= 3 CALL
*MCALL #=  4337 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=  4337 LV= 3 WTO
*MCALL #=  4338 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=  4339 LV= 4          ZSTREQU 
*MEXIT #=  4339 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_374_2
*MEXIT #=  4338 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=  4340 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=  4340 LV= 3 WTO
*MCALL #=  4341 LV= 3                ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=  4341 LV= 3 ABEND
*MCALL #=  4342 LV= 3          ENDIF 
*MCALL #=  4343 LV= 4          ZSTREQU 
*MEXIT #=  4343 LV= 4 ZSTREQU
#@IF_374_2                                               DS 0H
*MEXIT #=  4342 LV= 3 ENDIF
         AP    RT1_TOT,=P'1'
* RPI 786 START TEST FOR DFP
         LA    R1,L'INT128
         BCTR  R1,0
         EX    R1,*+4+4
         B     *+4+6
         CLC   WORK16(0),INT128  VERIFY CTD CONSTANT WITH CFD RESULT
* RPI 786 START TEST FOR DFP
*MCALL #=  4344 LV= 3          RT1   CCE
         DS    0H
RT1_TEST246      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE246
         LTORG 
RT1_CCE246      DS 0H
*MEXIT #=  4344 LV= 3 RT1
         B     EXIT187
         LTORG 
EXIT187     DS 0H
*MEXIT #=  4323 LV= 2 TEST1
         CLC   DECIMAL,SAVE_DECIMAL
*MCALL #=  4345 LV= 2          RT1   CCE
         DS    0H
RT1_TEST247      BAS   RT1_LINK,RT1_TEST_CC0
         USING *,RT1_LINK
         B     RT1_CCE247
         LTORG 
RT1_CCE247      DS 0H
*MEXIT #=  4345 LV= 2 RT1
*MEXIT #=  4300 LV= 1 TEST
*MCALL #=  4346 LV= 1          RT1   END
         B      RT1_END
*MEXIT #=  4346 LV= 1 RT1
         END 
