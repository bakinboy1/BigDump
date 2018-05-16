*********************************************************************
* Copyright 2005 Automated Software Tools Corporation               *
* This source code is part of z390 assembler/emulator package       *
* The z390 package is distributed under GNU general public license  *
* Author - Don Higgins                                              *
* Date   - 07/27/06                                                 *
*********************************************************************
* 07/27/06 RPI 370 test CTD and CFD including SVC and MF MAX/MIN
* 11/10/06 RPI 477 use IN= and OUT= on CTD and CFD macros
* 12/11/06 RPI 514 test DFP DD, ED, and LD min/max using CTD/CFD
* 12/22/06 RPI 406 skip bug in DFP MF and skip slow BFP/HFP extended MF
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
*MCALL #=    10 LV= 1          RT1   START
RT1_START DS  0H
*MEXIT #=    10 LV= 1 RT1
         MACRO
         TEST  &TYPE,&VAL
         AIF   ('&TYPE'(2,1) EQ 'D').SKPMF SKIP DFP MF FOR NOW (BUG?)
         AIF   ('&TYPE'(1,1) EQ 'L').SKPMF SKIP EXT MF FOR NOW (SLOW)
         TEST1 MF,&TYPE,&VAL
         MVC   SAVE_DECIMAL,DECIMAL
         TEST1 SVC,&TYPE,&VAL
         MEXIT
.SKPMF   ANOP  dshx test
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
         IF    (CP,PRC,NE,=P'0')
               IF  (CP,PRC,LE,=P'4'),AND,(OC,WORK16,Z,WORK16)
                   MVC  WORK16,&VAL     REPLACE 0 WITH (MIN) FOR MF
               ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,&VAL,EQ,WORK16)
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
               ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
                   WTO MF=(E,WTOPRC)
                   ABEND 102
               ENDIF
         ENDIF
         MVC   DTYPE,=CL6'&LK.<D &TYPE'
         MVC   DHEX,=CL32' '
         LA    R3,L'&VAL
         CALL  CVTTOHEX,(WORK16,DHEX,(R3))
         WTO   MF=(E,WTOMSG)
         B     EXIT&TESTNO
         LTORG
EXIT&TESTNO DS 0H
         MEND
*MCALL #=    11 LV= 1          TEST   EH,=EH'(MIN)'
*MCALL #=    12 LV= 2          TEST1 MF,EH,=EH'(MIN)'
         BASR  R12,0
         USING *,R12
*MCALL #=    13 LV= 3          CTD   CTD_EH,IN==EH'(MIN)',OUT=DECIMAL,LX
               INKAGE=MF
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
         LA    1,=A(CTD_EH,0,DECIMAL)
         LA    0,=EH'(MIN)'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=    13 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EH'
         MVC   DHEX,=CL32' '
         LA    R2,=EH'(MIN)'
         LA    R3,L'=EH'(MIN)'
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
*MCALL #=    23 LV= 3          CFD   CFD_EH,OUT=WORK16,IN=DECIMAL,LINKAX
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
         LA    1,=A(CFD_EH,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=    23 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=    24 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=    25 LV= 4          ZSTREQU 
*MEXIT #=    25 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_2_2
*MEXIT #=    24 LV= 3 IF
*MCALL #=    26 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=    27 LV= 4          ZSTREQU 
*MEXIT #=    27 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_3_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_3_2
*MEXIT #=    26 LV= 3 IF
                   MVC  WORK16,=EH'(MIN)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=    28 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =EH'(MIN)',EQ,WORK16)
*MCALL #=    29 LV= 4          ZSTREQU 
*MEXIT #=    29 LV= 4 ZSTREQU
         B     #@IF_3_E
#@IF_3_2                                                 DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_3_4
         CLC   =EH'(MIN)',WORK16
         BC    15-EQ,#@IF_3_4
*MEXIT #=    28 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=    30 LV= 3                ELSE 
*MCALL #=    31 LV= 4          ZSTREQU 
*MEXIT #=    31 LV= 4 ZSTREQU
        B      #@IF_3_E
#@IF_3_4                                                 DS 0H
*MEXIT #=    30 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=    32 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=    32 LV= 3 WTO
*MCALL #=    33 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=    33 LV= 3 ABEND
*MCALL #=    34 LV= 3                ENDIF 
*MCALL #=    35 LV= 4          ZSTREQU 
*MEXIT #=    35 LV= 4 ZSTREQU
#@IF_3_E                         DS 0H
*MEXIT #=    34 LV= 3 ENDIF
*MCALL #=    36 LV= 3          ENDIF 
*MCALL #=    37 LV= 4          ZSTREQU 
*MEXIT #=    37 LV= 4 ZSTREQU
#@IF_2_2                                                 DS 0H
*MEXIT #=    36 LV= 3 ENDIF
         MVC   DTYPE,=CL6'M<D EH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EH'(MIN)'
*MCALL #=    38 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=    39 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=    39 LV= 4 ZCALL
*MEXIT #=    38 LV= 3 CALL
*MCALL #=    40 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=    40 LV= 3 WTO
         B     EXIT1
         LTORG 
EXIT1       DS 0H
*MEXIT #=    12 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=    41 LV= 2          TEST1 SVC,EH,=EH'(MIN)'
         BASR  R12,0
         USING *,R12
*MCALL #=    42 LV= 3          CTD   CTD_EH,IN==EH'(MIN)',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_EH,0,DECIMAL)
         LA    0,=EH'(MIN)'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=    42 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EH'
         MVC   DHEX,=CL32' '
         LA    R2,=EH'(MIN)'
         LA    R3,L'=EH'(MIN)'
*MCALL #=    43 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=    44 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=    44 LV= 4 ZCALL
*MEXIT #=    43 LV= 3 CALL
*MCALL #=    45 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=    45 LV= 3 WTO
*MCALL #=    46 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=    47 LV= 4          ZSTREQU 
*MEXIT #=    47 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_4_2
*MEXIT #=    46 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=    48 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=    48 LV= 3 WTO
*MCALL #=    49 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=    49 LV= 3 ABEND
*MCALL #=    50 LV= 3          ENDIF 
*MCALL #=    51 LV= 4          ZSTREQU 
*MEXIT #=    51 LV= 4 ZSTREQU
#@IF_4_2                                                 DS 0H
*MEXIT #=    50 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=    52 LV= 3          CFD   CFD_EH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=    52 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=    53 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=    54 LV= 4          ZSTREQU 
*MEXIT #=    54 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_5_2
*MEXIT #=    53 LV= 3 IF
*MCALL #=    55 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=    56 LV= 4          ZSTREQU 
*MEXIT #=    56 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_6_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_6_2
*MEXIT #=    55 LV= 3 IF
                   MVC  WORK16,=EH'(MIN)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=    57 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =EH'(MIN)',EQ,WORK16)
*MCALL #=    58 LV= 4          ZSTREQU 
*MEXIT #=    58 LV= 4 ZSTREQU
         B     #@IF_6_E
#@IF_6_2                                                 DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_6_4
         CLC   =EH'(MIN)',WORK16
         BC    15-EQ,#@IF_6_4
*MEXIT #=    57 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=    59 LV= 3                ELSE 
*MCALL #=    60 LV= 4          ZSTREQU 
*MEXIT #=    60 LV= 4 ZSTREQU
        B      #@IF_6_E
#@IF_6_4                                                 DS 0H
*MEXIT #=    59 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=    61 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=    61 LV= 3 WTO
*MCALL #=    62 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=    62 LV= 3 ABEND
*MCALL #=    63 LV= 3                ENDIF 
*MCALL #=    64 LV= 4          ZSTREQU 
*MEXIT #=    64 LV= 4 ZSTREQU
#@IF_6_E                         DS 0H
*MEXIT #=    63 LV= 3 ENDIF
*MCALL #=    65 LV= 3          ENDIF 
*MCALL #=    66 LV= 4          ZSTREQU 
*MEXIT #=    66 LV= 4 ZSTREQU
#@IF_5_2                                                 DS 0H
*MEXIT #=    65 LV= 3 ENDIF
         MVC   DTYPE,=CL6'S<D EH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EH'(MIN)'
*MCALL #=    67 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=    68 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=    68 LV= 4 ZCALL
*MEXIT #=    67 LV= 3 CALL
*MCALL #=    69 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=    69 LV= 3 WTO
         B     EXIT2
         LTORG 
EXIT2       DS 0H
*MEXIT #=    41 LV= 2 TEST1
*MEXIT #=    11 LV= 1 TEST
*MCALL #=    70 LV= 1          TEST   EH,=EH'(MAX)'
*MCALL #=    71 LV= 2          TEST1 MF,EH,=EH'(MAX)'
         BASR  R12,0
         USING *,R12
*MCALL #=    72 LV= 3          CTD   CTD_EH,IN==EH'(MAX)',OUT=DECIMAL,LX
               INKAGE=MF
         LA    1,=A(CTD_EH,0,DECIMAL)
         LA    0,=EH'(MAX)'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=    72 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EH'
         MVC   DHEX,=CL32' '
         LA    R2,=EH'(MAX)'
         LA    R3,L'=EH'(MAX)'
*MCALL #=    73 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=    74 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=    74 LV= 4 ZCALL
*MEXIT #=    73 LV= 3 CALL
*MCALL #=    75 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=    75 LV= 3 WTO
*MCALL #=    76 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=    77 LV= 4          ZSTREQU 
*MEXIT #=    77 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_7_2
*MEXIT #=    76 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=    78 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=    78 LV= 3 WTO
*MCALL #=    79 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=    79 LV= 3 ABEND
*MCALL #=    80 LV= 3          ENDIF 
*MCALL #=    81 LV= 4          ZSTREQU 
*MEXIT #=    81 LV= 4 ZSTREQU
#@IF_7_2                                                 DS 0H
*MEXIT #=    80 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=    82 LV= 3          CFD   CFD_EH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_EH,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=    82 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=    83 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=    84 LV= 4          ZSTREQU 
*MEXIT #=    84 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_8_2
*MEXIT #=    83 LV= 3 IF
*MCALL #=    85 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=    86 LV= 4          ZSTREQU 
*MEXIT #=    86 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_9_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_9_2
*MEXIT #=    85 LV= 3 IF
                   MVC  WORK16,=EH'(MAX)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=    87 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =EH'(MAX)',EQ,WORK16)
*MCALL #=    88 LV= 4          ZSTREQU 
*MEXIT #=    88 LV= 4 ZSTREQU
         B     #@IF_9_E
#@IF_9_2                                                 DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_9_4
         CLC   =EH'(MAX)',WORK16
         BC    15-EQ,#@IF_9_4
*MEXIT #=    87 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=    89 LV= 3                ELSE 
*MCALL #=    90 LV= 4          ZSTREQU 
*MEXIT #=    90 LV= 4 ZSTREQU
        B      #@IF_9_E
#@IF_9_4                                                 DS 0H
*MEXIT #=    89 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=    91 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=    91 LV= 3 WTO
*MCALL #=    92 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=    92 LV= 3 ABEND
*MCALL #=    93 LV= 3                ENDIF 
*MCALL #=    94 LV= 4          ZSTREQU 
*MEXIT #=    94 LV= 4 ZSTREQU
#@IF_9_E                         DS 0H
*MEXIT #=    93 LV= 3 ENDIF
*MCALL #=    95 LV= 3          ENDIF 
*MCALL #=    96 LV= 4          ZSTREQU 
*MEXIT #=    96 LV= 4 ZSTREQU
#@IF_8_2                                                 DS 0H
*MEXIT #=    95 LV= 3 ENDIF
         MVC   DTYPE,=CL6'M<D EH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EH'(MAX)'
*MCALL #=    97 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=    98 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=    98 LV= 4 ZCALL
*MEXIT #=    97 LV= 3 CALL
*MCALL #=    99 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=    99 LV= 3 WTO
         B     EXIT3
         LTORG 
EXIT3       DS 0H
*MEXIT #=    71 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=   100 LV= 2          TEST1 SVC,EH,=EH'(MAX)'
         BASR  R12,0
         USING *,R12
*MCALL #=   101 LV= 3          CTD   CTD_EH,IN==EH'(MAX)',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_EH,0,DECIMAL)
         LA    0,=EH'(MAX)'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   101 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EH'
         MVC   DHEX,=CL32' '
         LA    R2,=EH'(MAX)'
         LA    R3,L'=EH'(MAX)'
*MCALL #=   102 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   103 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   103 LV= 4 ZCALL
*MEXIT #=   102 LV= 3 CALL
*MCALL #=   104 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   104 LV= 3 WTO
*MCALL #=   105 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   106 LV= 4          ZSTREQU 
*MEXIT #=   106 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_10_2
*MEXIT #=   105 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   107 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   107 LV= 3 WTO
*MCALL #=   108 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   108 LV= 3 ABEND
*MCALL #=   109 LV= 3          ENDIF 
*MCALL #=   110 LV= 4          ZSTREQU 
*MEXIT #=   110 LV= 4 ZSTREQU
#@IF_10_2                                                DS 0H
*MEXIT #=   109 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   111 LV= 3          CFD   CFD_EH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   111 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   112 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   113 LV= 4          ZSTREQU 
*MEXIT #=   113 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_11_2
*MEXIT #=   112 LV= 3 IF
*MCALL #=   114 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   115 LV= 4          ZSTREQU 
*MEXIT #=   115 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_12_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_12_2
*MEXIT #=   114 LV= 3 IF
                   MVC  WORK16,=EH'(MAX)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   116 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =EH'(MAX)',EQ,WORK16)
*MCALL #=   117 LV= 4          ZSTREQU 
*MEXIT #=   117 LV= 4 ZSTREQU
         B     #@IF_12_E
#@IF_12_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_12_4
         CLC   =EH'(MAX)',WORK16
         BC    15-EQ,#@IF_12_4
*MEXIT #=   116 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   118 LV= 3                ELSE 
*MCALL #=   119 LV= 4          ZSTREQU 
*MEXIT #=   119 LV= 4 ZSTREQU
        B      #@IF_12_E
#@IF_12_4                                                DS 0H
*MEXIT #=   118 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   120 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   120 LV= 3 WTO
*MCALL #=   121 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   121 LV= 3 ABEND
*MCALL #=   122 LV= 3                ENDIF 
*MCALL #=   123 LV= 4          ZSTREQU 
*MEXIT #=   123 LV= 4 ZSTREQU
#@IF_12_E                        DS 0H
*MEXIT #=   122 LV= 3 ENDIF
*MCALL #=   124 LV= 3          ENDIF 
*MCALL #=   125 LV= 4          ZSTREQU 
*MEXIT #=   125 LV= 4 ZSTREQU
#@IF_11_2                                                DS 0H
*MEXIT #=   124 LV= 3 ENDIF
         MVC   DTYPE,=CL6'S<D EH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EH'(MAX)'
*MCALL #=   126 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   127 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   127 LV= 4 ZCALL
*MEXIT #=   126 LV= 3 CALL
*MCALL #=   128 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   128 LV= 3 WTO
         B     EXIT4
         LTORG 
EXIT4       DS 0H
*MEXIT #=   100 LV= 2 TEST1
*MEXIT #=    70 LV= 1 TEST
*MCALL #=   129 LV= 1          TEST   EB,=EB'(MIN)'
*MCALL #=   130 LV= 2          TEST1 MF,EB,=EB'(MIN)'
         BASR  R12,0
         USING *,R12
*MCALL #=   131 LV= 3          CTD   CTD_EB,IN==EB'(MIN)',OUT=DECIMAL,LX
               INKAGE=MF
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'(MIN)'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   131 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'(MIN)'
         LA    R3,L'=EB'(MIN)'
*MCALL #=   132 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   133 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   133 LV= 4 ZCALL
*MEXIT #=   132 LV= 3 CALL
*MCALL #=   134 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   134 LV= 3 WTO
*MCALL #=   135 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   136 LV= 4          ZSTREQU 
*MEXIT #=   136 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_13_2
*MEXIT #=   135 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   137 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   137 LV= 3 WTO
*MCALL #=   138 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   138 LV= 3 ABEND
*MCALL #=   139 LV= 3          ENDIF 
*MCALL #=   140 LV= 4          ZSTREQU 
*MEXIT #=   140 LV= 4 ZSTREQU
#@IF_13_2                                                DS 0H
*MEXIT #=   139 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   141 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   141 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   142 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   143 LV= 4          ZSTREQU 
*MEXIT #=   143 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_14_2
*MEXIT #=   142 LV= 3 IF
*MCALL #=   144 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   145 LV= 4          ZSTREQU 
*MEXIT #=   145 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_15_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_15_2
*MEXIT #=   144 LV= 3 IF
                   MVC  WORK16,=EB'(MIN)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   146 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =EB'(MIN)',EQ,WORK16)
*MCALL #=   147 LV= 4          ZSTREQU 
*MEXIT #=   147 LV= 4 ZSTREQU
         B     #@IF_15_E
#@IF_15_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_15_4
         CLC   =EB'(MIN)',WORK16
         BC    15-EQ,#@IF_15_4
*MEXIT #=   146 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   148 LV= 3                ELSE 
*MCALL #=   149 LV= 4          ZSTREQU 
*MEXIT #=   149 LV= 4 ZSTREQU
        B      #@IF_15_E
#@IF_15_4                                                DS 0H
*MEXIT #=   148 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   150 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   150 LV= 3 WTO
*MCALL #=   151 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   151 LV= 3 ABEND
*MCALL #=   152 LV= 3                ENDIF 
*MCALL #=   153 LV= 4          ZSTREQU 
*MEXIT #=   153 LV= 4 ZSTREQU
#@IF_15_E                        DS 0H
*MEXIT #=   152 LV= 3 ENDIF
*MCALL #=   154 LV= 3          ENDIF 
*MCALL #=   155 LV= 4          ZSTREQU 
*MEXIT #=   155 LV= 4 ZSTREQU
#@IF_14_2                                                DS 0H
*MEXIT #=   154 LV= 3 ENDIF
         MVC   DTYPE,=CL6'M<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'(MIN)'
*MCALL #=   156 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   157 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   157 LV= 4 ZCALL
*MEXIT #=   156 LV= 3 CALL
*MCALL #=   158 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   158 LV= 3 WTO
         B     EXIT5
         LTORG 
EXIT5       DS 0H
*MEXIT #=   130 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=   159 LV= 2          TEST1 SVC,EB,=EB'(MIN)'
         BASR  R12,0
         USING *,R12
*MCALL #=   160 LV= 3          CTD   CTD_EB,IN==EB'(MIN)',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'(MIN)'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   160 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'(MIN)'
         LA    R3,L'=EB'(MIN)'
*MCALL #=   161 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   162 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   162 LV= 4 ZCALL
*MEXIT #=   161 LV= 3 CALL
*MCALL #=   163 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   163 LV= 3 WTO
*MCALL #=   164 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   165 LV= 4          ZSTREQU 
*MEXIT #=   165 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_16_2
*MEXIT #=   164 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   166 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   166 LV= 3 WTO
*MCALL #=   167 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   167 LV= 3 ABEND
*MCALL #=   168 LV= 3          ENDIF 
*MCALL #=   169 LV= 4          ZSTREQU 
*MEXIT #=   169 LV= 4 ZSTREQU
#@IF_16_2                                                DS 0H
*MEXIT #=   168 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   170 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   170 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   171 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   172 LV= 4          ZSTREQU 
*MEXIT #=   172 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_17_2
*MEXIT #=   171 LV= 3 IF
*MCALL #=   173 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   174 LV= 4          ZSTREQU 
*MEXIT #=   174 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_18_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_18_2
*MEXIT #=   173 LV= 3 IF
                   MVC  WORK16,=EB'(MIN)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   175 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =EB'(MIN)',EQ,WORK16)
*MCALL #=   176 LV= 4          ZSTREQU 
*MEXIT #=   176 LV= 4 ZSTREQU
         B     #@IF_18_E
#@IF_18_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_18_4
         CLC   =EB'(MIN)',WORK16
         BC    15-EQ,#@IF_18_4
*MEXIT #=   175 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   177 LV= 3                ELSE 
*MCALL #=   178 LV= 4          ZSTREQU 
*MEXIT #=   178 LV= 4 ZSTREQU
        B      #@IF_18_E
#@IF_18_4                                                DS 0H
*MEXIT #=   177 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   179 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   179 LV= 3 WTO
*MCALL #=   180 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   180 LV= 3 ABEND
*MCALL #=   181 LV= 3                ENDIF 
*MCALL #=   182 LV= 4          ZSTREQU 
*MEXIT #=   182 LV= 4 ZSTREQU
#@IF_18_E                        DS 0H
*MEXIT #=   181 LV= 3 ENDIF
*MCALL #=   183 LV= 3          ENDIF 
*MCALL #=   184 LV= 4          ZSTREQU 
*MEXIT #=   184 LV= 4 ZSTREQU
#@IF_17_2                                                DS 0H
*MEXIT #=   183 LV= 3 ENDIF
         MVC   DTYPE,=CL6'S<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'(MIN)'
*MCALL #=   185 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   186 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   186 LV= 4 ZCALL
*MEXIT #=   185 LV= 3 CALL
*MCALL #=   187 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   187 LV= 3 WTO
         B     EXIT6
         LTORG 
EXIT6       DS 0H
*MEXIT #=   159 LV= 2 TEST1
*MEXIT #=   129 LV= 1 TEST
*MCALL #=   188 LV= 1          TEST   EB,=EB'(MAX)'
*MCALL #=   189 LV= 2          TEST1 MF,EB,=EB'(MAX)'
         BASR  R12,0
         USING *,R12
*MCALL #=   190 LV= 3          CTD   CTD_EB,IN==EB'(MAX)',OUT=DECIMAL,LX
               INKAGE=MF
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'(MAX)'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   190 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'(MAX)'
         LA    R3,L'=EB'(MAX)'
*MCALL #=   191 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   192 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   192 LV= 4 ZCALL
*MEXIT #=   191 LV= 3 CALL
*MCALL #=   193 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   193 LV= 3 WTO
*MCALL #=   194 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   195 LV= 4          ZSTREQU 
*MEXIT #=   195 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_19_2
*MEXIT #=   194 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   196 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   196 LV= 3 WTO
*MCALL #=   197 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   197 LV= 3 ABEND
*MCALL #=   198 LV= 3          ENDIF 
*MCALL #=   199 LV= 4          ZSTREQU 
*MEXIT #=   199 LV= 4 ZSTREQU
#@IF_19_2                                                DS 0H
*MEXIT #=   198 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   200 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   200 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   201 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   202 LV= 4          ZSTREQU 
*MEXIT #=   202 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_20_2
*MEXIT #=   201 LV= 3 IF
*MCALL #=   203 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   204 LV= 4          ZSTREQU 
*MEXIT #=   204 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_21_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_21_2
*MEXIT #=   203 LV= 3 IF
                   MVC  WORK16,=EB'(MAX)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   205 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =EB'(MAX)',EQ,WORK16)
*MCALL #=   206 LV= 4          ZSTREQU 
*MEXIT #=   206 LV= 4 ZSTREQU
         B     #@IF_21_E
#@IF_21_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_21_4
         CLC   =EB'(MAX)',WORK16
         BC    15-EQ,#@IF_21_4
*MEXIT #=   205 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   207 LV= 3                ELSE 
*MCALL #=   208 LV= 4          ZSTREQU 
*MEXIT #=   208 LV= 4 ZSTREQU
        B      #@IF_21_E
#@IF_21_4                                                DS 0H
*MEXIT #=   207 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   209 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   209 LV= 3 WTO
*MCALL #=   210 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   210 LV= 3 ABEND
*MCALL #=   211 LV= 3                ENDIF 
*MCALL #=   212 LV= 4          ZSTREQU 
*MEXIT #=   212 LV= 4 ZSTREQU
#@IF_21_E                        DS 0H
*MEXIT #=   211 LV= 3 ENDIF
*MCALL #=   213 LV= 3          ENDIF 
*MCALL #=   214 LV= 4          ZSTREQU 
*MEXIT #=   214 LV= 4 ZSTREQU
#@IF_20_2                                                DS 0H
*MEXIT #=   213 LV= 3 ENDIF
         MVC   DTYPE,=CL6'M<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'(MAX)'
*MCALL #=   215 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   216 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   216 LV= 4 ZCALL
*MEXIT #=   215 LV= 3 CALL
*MCALL #=   217 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   217 LV= 3 WTO
         B     EXIT7
         LTORG 
EXIT7       DS 0H
*MEXIT #=   189 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=   218 LV= 2          TEST1 SVC,EB,=EB'(MAX)'
         BASR  R12,0
         USING *,R12
*MCALL #=   219 LV= 3          CTD   CTD_EB,IN==EB'(MAX)',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_EB,0,DECIMAL)
         LA    0,=EB'(MAX)'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   219 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D EB'
         MVC   DHEX,=CL32' '
         LA    R2,=EB'(MAX)'
         LA    R3,L'=EB'(MAX)'
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
         BC    15-NE,#@IF_22_2
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
#@IF_22_2                                                DS 0H
*MEXIT #=   227 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   229 LV= 3          CFD   CFD_EB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_EB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   229 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   230 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   231 LV= 4          ZSTREQU 
*MEXIT #=   231 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_23_2
*MEXIT #=   230 LV= 3 IF
*MCALL #=   232 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   233 LV= 4          ZSTREQU 
*MEXIT #=   233 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_24_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_24_2
*MEXIT #=   232 LV= 3 IF
                   MVC  WORK16,=EB'(MAX)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   234 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =EB'(MAX)',EQ,WORK16)
*MCALL #=   235 LV= 4          ZSTREQU 
*MEXIT #=   235 LV= 4 ZSTREQU
         B     #@IF_24_E
#@IF_24_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_24_4
         CLC   =EB'(MAX)',WORK16
         BC    15-EQ,#@IF_24_4
*MEXIT #=   234 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   236 LV= 3                ELSE 
*MCALL #=   237 LV= 4          ZSTREQU 
*MEXIT #=   237 LV= 4 ZSTREQU
        B      #@IF_24_E
#@IF_24_4                                                DS 0H
*MEXIT #=   236 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   238 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   238 LV= 3 WTO
*MCALL #=   239 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   239 LV= 3 ABEND
*MCALL #=   240 LV= 3                ENDIF 
*MCALL #=   241 LV= 4          ZSTREQU 
*MEXIT #=   241 LV= 4 ZSTREQU
#@IF_24_E                        DS 0H
*MEXIT #=   240 LV= 3 ENDIF
*MCALL #=   242 LV= 3          ENDIF 
*MCALL #=   243 LV= 4          ZSTREQU 
*MEXIT #=   243 LV= 4 ZSTREQU
#@IF_23_2                                                DS 0H
*MEXIT #=   242 LV= 3 ENDIF
         MVC   DTYPE,=CL6'S<D EB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=EB'(MAX)'
*MCALL #=   244 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   245 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   245 LV= 4 ZCALL
*MEXIT #=   244 LV= 3 CALL
*MCALL #=   246 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   246 LV= 3 WTO
         B     EXIT8
         LTORG 
EXIT8       DS 0H
*MEXIT #=   218 LV= 2 TEST1
*MEXIT #=   188 LV= 1 TEST
*MCALL #=   247 LV= 1          TEST   DH,=DH'(MIN)'
*MCALL #=   248 LV= 2          TEST1 MF,DH,=DH'(MIN)'
         BASR  R12,0
         USING *,R12
*MCALL #=   249 LV= 3          CTD   CTD_DH,IN==DH'(MIN)',OUT=DECIMAL,LX
               INKAGE=MF
         LA    1,=A(CTD_DH,0,DECIMAL)
         LA    0,=DH'(MIN)'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   249 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D DH'
         MVC   DHEX,=CL32' '
         LA    R2,=DH'(MIN)'
         LA    R3,L'=DH'(MIN)'
*MCALL #=   250 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   251 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   251 LV= 4 ZCALL
*MEXIT #=   250 LV= 3 CALL
*MCALL #=   252 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   252 LV= 3 WTO
*MCALL #=   253 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   254 LV= 4          ZSTREQU 
*MEXIT #=   254 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_25_2
*MEXIT #=   253 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   255 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   255 LV= 3 WTO
*MCALL #=   256 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   256 LV= 3 ABEND
*MCALL #=   257 LV= 3          ENDIF 
*MCALL #=   258 LV= 4          ZSTREQU 
*MEXIT #=   258 LV= 4 ZSTREQU
#@IF_25_2                                                DS 0H
*MEXIT #=   257 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   259 LV= 3          CFD   CFD_DH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_DH,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   259 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   260 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   261 LV= 4          ZSTREQU 
*MEXIT #=   261 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_26_2
*MEXIT #=   260 LV= 3 IF
*MCALL #=   262 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   263 LV= 4          ZSTREQU 
*MEXIT #=   263 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_27_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_27_2
*MEXIT #=   262 LV= 3 IF
                   MVC  WORK16,=DH'(MIN)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   264 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =DH'(MIN)',EQ,WORK16)
*MCALL #=   265 LV= 4          ZSTREQU 
*MEXIT #=   265 LV= 4 ZSTREQU
         B     #@IF_27_E
#@IF_27_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_27_4
         CLC   =DH'(MIN)',WORK16
         BC    15-EQ,#@IF_27_4
*MEXIT #=   264 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   266 LV= 3                ELSE 
*MCALL #=   267 LV= 4          ZSTREQU 
*MEXIT #=   267 LV= 4 ZSTREQU
        B      #@IF_27_E
#@IF_27_4                                                DS 0H
*MEXIT #=   266 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   268 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   268 LV= 3 WTO
*MCALL #=   269 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   269 LV= 3 ABEND
*MCALL #=   270 LV= 3                ENDIF 
*MCALL #=   271 LV= 4          ZSTREQU 
*MEXIT #=   271 LV= 4 ZSTREQU
#@IF_27_E                        DS 0H
*MEXIT #=   270 LV= 3 ENDIF
*MCALL #=   272 LV= 3          ENDIF 
*MCALL #=   273 LV= 4          ZSTREQU 
*MEXIT #=   273 LV= 4 ZSTREQU
#@IF_26_2                                                DS 0H
*MEXIT #=   272 LV= 3 ENDIF
         MVC   DTYPE,=CL6'M<D DH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DH'(MIN)'
*MCALL #=   274 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   275 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   275 LV= 4 ZCALL
*MEXIT #=   274 LV= 3 CALL
*MCALL #=   276 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   276 LV= 3 WTO
         B     EXIT9
         LTORG 
EXIT9       DS 0H
*MEXIT #=   248 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=   277 LV= 2          TEST1 SVC,DH,=DH'(MIN)'
         BASR  R12,0
         USING *,R12
*MCALL #=   278 LV= 3          CTD   CTD_DH,IN==DH'(MIN)',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_DH,0,DECIMAL)
         LA    0,=DH'(MIN)'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   278 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DH'
         MVC   DHEX,=CL32' '
         LA    R2,=DH'(MIN)'
         LA    R3,L'=DH'(MIN)'
*MCALL #=   279 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   280 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   280 LV= 4 ZCALL
*MEXIT #=   279 LV= 3 CALL
*MCALL #=   281 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   281 LV= 3 WTO
*MCALL #=   282 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   283 LV= 4          ZSTREQU 
*MEXIT #=   283 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_28_2
*MEXIT #=   282 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   284 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   284 LV= 3 WTO
*MCALL #=   285 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   285 LV= 3 ABEND
*MCALL #=   286 LV= 3          ENDIF 
*MCALL #=   287 LV= 4          ZSTREQU 
*MEXIT #=   287 LV= 4 ZSTREQU
#@IF_28_2                                                DS 0H
*MEXIT #=   286 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   288 LV= 3          CFD   CFD_DH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   288 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   289 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   290 LV= 4          ZSTREQU 
*MEXIT #=   290 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_29_2
*MEXIT #=   289 LV= 3 IF
*MCALL #=   291 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   292 LV= 4          ZSTREQU 
*MEXIT #=   292 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_30_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_30_2
*MEXIT #=   291 LV= 3 IF
                   MVC  WORK16,=DH'(MIN)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   293 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =DH'(MIN)',EQ,WORK16)
*MCALL #=   294 LV= 4          ZSTREQU 
*MEXIT #=   294 LV= 4 ZSTREQU
         B     #@IF_30_E
#@IF_30_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_30_4
         CLC   =DH'(MIN)',WORK16
         BC    15-EQ,#@IF_30_4
*MEXIT #=   293 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   295 LV= 3                ELSE 
*MCALL #=   296 LV= 4          ZSTREQU 
*MEXIT #=   296 LV= 4 ZSTREQU
        B      #@IF_30_E
#@IF_30_4                                                DS 0H
*MEXIT #=   295 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   297 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   297 LV= 3 WTO
*MCALL #=   298 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   298 LV= 3 ABEND
*MCALL #=   299 LV= 3                ENDIF 
*MCALL #=   300 LV= 4          ZSTREQU 
*MEXIT #=   300 LV= 4 ZSTREQU
#@IF_30_E                        DS 0H
*MEXIT #=   299 LV= 3 ENDIF
*MCALL #=   301 LV= 3          ENDIF 
*MCALL #=   302 LV= 4          ZSTREQU 
*MEXIT #=   302 LV= 4 ZSTREQU
#@IF_29_2                                                DS 0H
*MEXIT #=   301 LV= 3 ENDIF
         MVC   DTYPE,=CL6'S<D DH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DH'(MIN)'
*MCALL #=   303 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   304 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   304 LV= 4 ZCALL
*MEXIT #=   303 LV= 3 CALL
*MCALL #=   305 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   305 LV= 3 WTO
         B     EXIT10
         LTORG 
EXIT10      DS 0H
*MEXIT #=   277 LV= 2 TEST1
*MEXIT #=   247 LV= 1 TEST
*MCALL #=   306 LV= 1          TEST   DH,=DH'(MAX)'
*MCALL #=   307 LV= 2          TEST1 MF,DH,=DH'(MAX)'
         BASR  R12,0
         USING *,R12
*MCALL #=   308 LV= 3          CTD   CTD_DH,IN==DH'(MAX)',OUT=DECIMAL,LX
               INKAGE=MF
         LA    1,=A(CTD_DH,0,DECIMAL)
         LA    0,=DH'(MAX)'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   308 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D DH'
         MVC   DHEX,=CL32' '
         LA    R2,=DH'(MAX)'
         LA    R3,L'=DH'(MAX)'
*MCALL #=   309 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   310 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   310 LV= 4 ZCALL
*MEXIT #=   309 LV= 3 CALL
*MCALL #=   311 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   311 LV= 3 WTO
*MCALL #=   312 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   313 LV= 4          ZSTREQU 
*MEXIT #=   313 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_31_2
*MEXIT #=   312 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   314 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   314 LV= 3 WTO
*MCALL #=   315 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   315 LV= 3 ABEND
*MCALL #=   316 LV= 3          ENDIF 
*MCALL #=   317 LV= 4          ZSTREQU 
*MEXIT #=   317 LV= 4 ZSTREQU
#@IF_31_2                                                DS 0H
*MEXIT #=   316 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   318 LV= 3          CFD   CFD_DH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_DH,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   318 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   319 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   320 LV= 4          ZSTREQU 
*MEXIT #=   320 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_32_2
*MEXIT #=   319 LV= 3 IF
*MCALL #=   321 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   322 LV= 4          ZSTREQU 
*MEXIT #=   322 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_33_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_33_2
*MEXIT #=   321 LV= 3 IF
                   MVC  WORK16,=DH'(MAX)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   323 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =DH'(MAX)',EQ,WORK16)
*MCALL #=   324 LV= 4          ZSTREQU 
*MEXIT #=   324 LV= 4 ZSTREQU
         B     #@IF_33_E
#@IF_33_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_33_4
         CLC   =DH'(MAX)',WORK16
         BC    15-EQ,#@IF_33_4
*MEXIT #=   323 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   325 LV= 3                ELSE 
*MCALL #=   326 LV= 4          ZSTREQU 
*MEXIT #=   326 LV= 4 ZSTREQU
        B      #@IF_33_E
#@IF_33_4                                                DS 0H
*MEXIT #=   325 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   327 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   327 LV= 3 WTO
*MCALL #=   328 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   328 LV= 3 ABEND
*MCALL #=   329 LV= 3                ENDIF 
*MCALL #=   330 LV= 4          ZSTREQU 
*MEXIT #=   330 LV= 4 ZSTREQU
#@IF_33_E                        DS 0H
*MEXIT #=   329 LV= 3 ENDIF
*MCALL #=   331 LV= 3          ENDIF 
*MCALL #=   332 LV= 4          ZSTREQU 
*MEXIT #=   332 LV= 4 ZSTREQU
#@IF_32_2                                                DS 0H
*MEXIT #=   331 LV= 3 ENDIF
         MVC   DTYPE,=CL6'M<D DH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DH'(MAX)'
*MCALL #=   333 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   334 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   334 LV= 4 ZCALL
*MEXIT #=   333 LV= 3 CALL
*MCALL #=   335 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   335 LV= 3 WTO
         B     EXIT11
         LTORG 
EXIT11      DS 0H
*MEXIT #=   307 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=   336 LV= 2          TEST1 SVC,DH,=DH'(MAX)'
         BASR  R12,0
         USING *,R12
*MCALL #=   337 LV= 3          CTD   CTD_DH,IN==DH'(MAX)',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_DH,0,DECIMAL)
         LA    0,=DH'(MAX)'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   337 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DH'
         MVC   DHEX,=CL32' '
         LA    R2,=DH'(MAX)'
         LA    R3,L'=DH'(MAX)'
*MCALL #=   338 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   339 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   339 LV= 4 ZCALL
*MEXIT #=   338 LV= 3 CALL
*MCALL #=   340 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   340 LV= 3 WTO
*MCALL #=   341 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   342 LV= 4          ZSTREQU 
*MEXIT #=   342 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_34_2
*MEXIT #=   341 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   343 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   343 LV= 3 WTO
*MCALL #=   344 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   344 LV= 3 ABEND
*MCALL #=   345 LV= 3          ENDIF 
*MCALL #=   346 LV= 4          ZSTREQU 
*MEXIT #=   346 LV= 4 ZSTREQU
#@IF_34_2                                                DS 0H
*MEXIT #=   345 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   347 LV= 3          CFD   CFD_DH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   347 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   348 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   349 LV= 4          ZSTREQU 
*MEXIT #=   349 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_35_2
*MEXIT #=   348 LV= 3 IF
*MCALL #=   350 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   351 LV= 4          ZSTREQU 
*MEXIT #=   351 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_36_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_36_2
*MEXIT #=   350 LV= 3 IF
                   MVC  WORK16,=DH'(MAX)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   352 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =DH'(MAX)',EQ,WORK16)
*MCALL #=   353 LV= 4          ZSTREQU 
*MEXIT #=   353 LV= 4 ZSTREQU
         B     #@IF_36_E
#@IF_36_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_36_4
         CLC   =DH'(MAX)',WORK16
         BC    15-EQ,#@IF_36_4
*MEXIT #=   352 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   354 LV= 3                ELSE 
*MCALL #=   355 LV= 4          ZSTREQU 
*MEXIT #=   355 LV= 4 ZSTREQU
        B      #@IF_36_E
#@IF_36_4                                                DS 0H
*MEXIT #=   354 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   356 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   356 LV= 3 WTO
*MCALL #=   357 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   357 LV= 3 ABEND
*MCALL #=   358 LV= 3                ENDIF 
*MCALL #=   359 LV= 4          ZSTREQU 
*MEXIT #=   359 LV= 4 ZSTREQU
#@IF_36_E                        DS 0H
*MEXIT #=   358 LV= 3 ENDIF
*MCALL #=   360 LV= 3          ENDIF 
*MCALL #=   361 LV= 4          ZSTREQU 
*MEXIT #=   361 LV= 4 ZSTREQU
#@IF_35_2                                                DS 0H
*MEXIT #=   360 LV= 3 ENDIF
         MVC   DTYPE,=CL6'S<D DH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DH'(MAX)'
*MCALL #=   362 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   363 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   363 LV= 4 ZCALL
*MEXIT #=   362 LV= 3 CALL
*MCALL #=   364 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   364 LV= 3 WTO
         B     EXIT12
         LTORG 
EXIT12      DS 0H
*MEXIT #=   336 LV= 2 TEST1
*MEXIT #=   306 LV= 1 TEST
*MCALL #=   365 LV= 1          TEST   DB,=DB'(MIN)'
*MCALL #=   366 LV= 2          TEST1 MF,DB,=DB'(MIN)'
         BASR  R12,0
         USING *,R12
*MCALL #=   367 LV= 3          CTD   CTD_DB,IN==DB'(MIN)',OUT=DECIMAL,LX
               INKAGE=MF
         LA    1,=A(CTD_DB,0,DECIMAL)
         LA    0,=DB'(MIN)'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   367 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D DB'
         MVC   DHEX,=CL32' '
         LA    R2,=DB'(MIN)'
         LA    R3,L'=DB'(MIN)'
*MCALL #=   368 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   369 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
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
         BC    15-NE,#@IF_37_2
*MEXIT #=   371 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   373 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   373 LV= 3 WTO
*MCALL #=   374 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   374 LV= 3 ABEND
*MCALL #=   375 LV= 3          ENDIF 
*MCALL #=   376 LV= 4          ZSTREQU 
*MEXIT #=   376 LV= 4 ZSTREQU
#@IF_37_2                                                DS 0H
*MEXIT #=   375 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   377 LV= 3          CFD   CFD_DB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_DB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   377 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   378 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   379 LV= 4          ZSTREQU 
*MEXIT #=   379 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_38_2
*MEXIT #=   378 LV= 3 IF
*MCALL #=   380 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   381 LV= 4          ZSTREQU 
*MEXIT #=   381 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_39_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_39_2
*MEXIT #=   380 LV= 3 IF
                   MVC  WORK16,=DB'(MIN)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   382 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =DB'(MIN)',EQ,WORK16)
*MCALL #=   383 LV= 4          ZSTREQU 
*MEXIT #=   383 LV= 4 ZSTREQU
         B     #@IF_39_E
#@IF_39_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_39_4
         CLC   =DB'(MIN)',WORK16
         BC    15-EQ,#@IF_39_4
*MEXIT #=   382 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   384 LV= 3                ELSE 
*MCALL #=   385 LV= 4          ZSTREQU 
*MEXIT #=   385 LV= 4 ZSTREQU
        B      #@IF_39_E
#@IF_39_4                                                DS 0H
*MEXIT #=   384 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   386 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   386 LV= 3 WTO
*MCALL #=   387 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   387 LV= 3 ABEND
*MCALL #=   388 LV= 3                ENDIF 
*MCALL #=   389 LV= 4          ZSTREQU 
*MEXIT #=   389 LV= 4 ZSTREQU
#@IF_39_E                        DS 0H
*MEXIT #=   388 LV= 3 ENDIF
*MCALL #=   390 LV= 3          ENDIF 
*MCALL #=   391 LV= 4          ZSTREQU 
*MEXIT #=   391 LV= 4 ZSTREQU
#@IF_38_2                                                DS 0H
*MEXIT #=   390 LV= 3 ENDIF
         MVC   DTYPE,=CL6'M<D DB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DB'(MIN)'
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
         B     EXIT13
         LTORG 
EXIT13      DS 0H
*MEXIT #=   366 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=   395 LV= 2          TEST1 SVC,DB,=DB'(MIN)'
         BASR  R12,0
         USING *,R12
*MCALL #=   396 LV= 3          CTD   CTD_DB,IN==DB'(MIN)',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_DB,0,DECIMAL)
         LA    0,=DB'(MIN)'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   396 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DB'
         MVC   DHEX,=CL32' '
         LA    R2,=DB'(MIN)'
         LA    R3,L'=DB'(MIN)'
*MCALL #=   397 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   398 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   398 LV= 4 ZCALL
*MEXIT #=   397 LV= 3 CALL
*MCALL #=   399 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   399 LV= 3 WTO
*MCALL #=   400 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   401 LV= 4          ZSTREQU 
*MEXIT #=   401 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_40_2
*MEXIT #=   400 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   402 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   402 LV= 3 WTO
*MCALL #=   403 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   403 LV= 3 ABEND
*MCALL #=   404 LV= 3          ENDIF 
*MCALL #=   405 LV= 4          ZSTREQU 
*MEXIT #=   405 LV= 4 ZSTREQU
#@IF_40_2                                                DS 0H
*MEXIT #=   404 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   406 LV= 3          CFD   CFD_DB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   406 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   407 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   408 LV= 4          ZSTREQU 
*MEXIT #=   408 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_41_2
*MEXIT #=   407 LV= 3 IF
*MCALL #=   409 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   410 LV= 4          ZSTREQU 
*MEXIT #=   410 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_42_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_42_2
*MEXIT #=   409 LV= 3 IF
                   MVC  WORK16,=DB'(MIN)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   411 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =DB'(MIN)',EQ,WORK16)
*MCALL #=   412 LV= 4          ZSTREQU 
*MEXIT #=   412 LV= 4 ZSTREQU
         B     #@IF_42_E
#@IF_42_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_42_4
         CLC   =DB'(MIN)',WORK16
         BC    15-EQ,#@IF_42_4
*MEXIT #=   411 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   413 LV= 3                ELSE 
*MCALL #=   414 LV= 4          ZSTREQU 
*MEXIT #=   414 LV= 4 ZSTREQU
        B      #@IF_42_E
#@IF_42_4                                                DS 0H
*MEXIT #=   413 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   415 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   415 LV= 3 WTO
*MCALL #=   416 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   416 LV= 3 ABEND
*MCALL #=   417 LV= 3                ENDIF 
*MCALL #=   418 LV= 4          ZSTREQU 
*MEXIT #=   418 LV= 4 ZSTREQU
#@IF_42_E                        DS 0H
*MEXIT #=   417 LV= 3 ENDIF
*MCALL #=   419 LV= 3          ENDIF 
*MCALL #=   420 LV= 4          ZSTREQU 
*MEXIT #=   420 LV= 4 ZSTREQU
#@IF_41_2                                                DS 0H
*MEXIT #=   419 LV= 3 ENDIF
         MVC   DTYPE,=CL6'S<D DB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DB'(MIN)'
*MCALL #=   421 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   422 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   422 LV= 4 ZCALL
*MEXIT #=   421 LV= 3 CALL
*MCALL #=   423 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   423 LV= 3 WTO
         B     EXIT14
         LTORG 
EXIT14      DS 0H
*MEXIT #=   395 LV= 2 TEST1
*MEXIT #=   365 LV= 1 TEST
*MCALL #=   424 LV= 1          TEST   DB,=DB'(MAX)'
*MCALL #=   425 LV= 2          TEST1 MF,DB,=DB'(MAX)'
         BASR  R12,0
         USING *,R12
*MCALL #=   426 LV= 3          CTD   CTD_DB,IN==DB'(MAX)',OUT=DECIMAL,LX
               INKAGE=MF
         LA    1,=A(CTD_DB,0,DECIMAL)
         LA    0,=DB'(MAX)'
         ST    0,4(1)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   426 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'M>D DB'
         MVC   DHEX,=CL32' '
         LA    R2,=DB'(MAX)'
         LA    R3,L'=DB'(MAX)'
*MCALL #=   427 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   428 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   428 LV= 4 ZCALL
*MEXIT #=   427 LV= 3 CALL
*MCALL #=   429 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   429 LV= 3 WTO
*MCALL #=   430 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   431 LV= 4          ZSTREQU 
*MEXIT #=   431 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_43_2
*MEXIT #=   430 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   432 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   432 LV= 3 WTO
*MCALL #=   433 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   433 LV= 3 ABEND
*MCALL #=   434 LV= 3          ENDIF 
*MCALL #=   435 LV= 4          ZSTREQU 
*MEXIT #=   435 LV= 4 ZSTREQU
#@IF_43_2                                                DS 0H
*MEXIT #=   434 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   436 LV= 3          CFD   CFD_DB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=MF
         DS    0H
         LA    1,=A(CFD_DB,WORK16,DECIMAL)
         L     15,=V(FPCONMFC) CFD MAINFRAME CALL ROUTINE
         BASR  14,15 CALL FPCONMFC,(TYPE,OUT,IN)
*MEXIT #=   436 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   437 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   438 LV= 4          ZSTREQU 
*MEXIT #=   438 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_44_2
*MEXIT #=   437 LV= 3 IF
*MCALL #=   439 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   440 LV= 4          ZSTREQU 
*MEXIT #=   440 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_45_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_45_2
*MEXIT #=   439 LV= 3 IF
                   MVC  WORK16,=DB'(MAX)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   441 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =DB'(MAX)',EQ,WORK16)
*MCALL #=   442 LV= 4          ZSTREQU 
*MEXIT #=   442 LV= 4 ZSTREQU
         B     #@IF_45_E
#@IF_45_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_45_4
         CLC   =DB'(MAX)',WORK16
         BC    15-EQ,#@IF_45_4
*MEXIT #=   441 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   443 LV= 3                ELSE 
*MCALL #=   444 LV= 4          ZSTREQU 
*MEXIT #=   444 LV= 4 ZSTREQU
        B      #@IF_45_E
#@IF_45_4                                                DS 0H
*MEXIT #=   443 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   445 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   445 LV= 3 WTO
*MCALL #=   446 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   446 LV= 3 ABEND
*MCALL #=   447 LV= 3                ENDIF 
*MCALL #=   448 LV= 4          ZSTREQU 
*MEXIT #=   448 LV= 4 ZSTREQU
#@IF_45_E                        DS 0H
*MEXIT #=   447 LV= 3 ENDIF
*MCALL #=   449 LV= 3          ENDIF 
*MCALL #=   450 LV= 4          ZSTREQU 
*MEXIT #=   450 LV= 4 ZSTREQU
#@IF_44_2                                                DS 0H
*MEXIT #=   449 LV= 3 ENDIF
         MVC   DTYPE,=CL6'M<D DB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DB'(MAX)'
*MCALL #=   451 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   452 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   452 LV= 4 ZCALL
*MEXIT #=   451 LV= 3 CALL
*MCALL #=   453 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   453 LV= 3 WTO
         B     EXIT15
         LTORG 
EXIT15      DS 0H
*MEXIT #=   425 LV= 2 TEST1
         MVC   SAVE_DECIMAL,DECIMAL
*MCALL #=   454 LV= 2          TEST1 SVC,DB,=DB'(MAX)'
         BASR  R12,0
         USING *,R12
*MCALL #=   455 LV= 3          CTD   CTD_DB,IN==DB'(MAX)',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_DB,0,DECIMAL)
         LA    0,=DB'(MAX)'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   455 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DB'
         MVC   DHEX,=CL32' '
         LA    R2,=DB'(MAX)'
         LA    R3,L'=DB'(MAX)'
*MCALL #=   456 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   457 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   457 LV= 4 ZCALL
*MEXIT #=   456 LV= 3 CALL
*MCALL #=   458 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   458 LV= 3 WTO
*MCALL #=   459 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   460 LV= 4          ZSTREQU 
*MEXIT #=   460 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_46_2
*MEXIT #=   459 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   461 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   461 LV= 3 WTO
*MCALL #=   462 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   462 LV= 3 ABEND
*MCALL #=   463 LV= 3          ENDIF 
*MCALL #=   464 LV= 4          ZSTREQU 
*MEXIT #=   464 LV= 4 ZSTREQU
#@IF_46_2                                                DS 0H
*MEXIT #=   463 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   465 LV= 3          CFD   CFD_DB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   465 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   466 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   467 LV= 4          ZSTREQU 
*MEXIT #=   467 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_47_2
*MEXIT #=   466 LV= 3 IF
*MCALL #=   468 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   469 LV= 4          ZSTREQU 
*MEXIT #=   469 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_48_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_48_2
*MEXIT #=   468 LV= 3 IF
                   MVC  WORK16,=DB'(MAX)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   470 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =DB'(MAX)',EQ,WORK16)
*MCALL #=   471 LV= 4          ZSTREQU 
*MEXIT #=   471 LV= 4 ZSTREQU
         B     #@IF_48_E
#@IF_48_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_48_4
         CLC   =DB'(MAX)',WORK16
         BC    15-EQ,#@IF_48_4
*MEXIT #=   470 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   472 LV= 3                ELSE 
*MCALL #=   473 LV= 4          ZSTREQU 
*MEXIT #=   473 LV= 4 ZSTREQU
        B      #@IF_48_E
#@IF_48_4                                                DS 0H
*MEXIT #=   472 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   474 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   474 LV= 3 WTO
*MCALL #=   475 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   475 LV= 3 ABEND
*MCALL #=   476 LV= 3                ENDIF 
*MCALL #=   477 LV= 4          ZSTREQU 
*MEXIT #=   477 LV= 4 ZSTREQU
#@IF_48_E                        DS 0H
*MEXIT #=   476 LV= 3 ENDIF
*MCALL #=   478 LV= 3          ENDIF 
*MCALL #=   479 LV= 4          ZSTREQU 
*MEXIT #=   479 LV= 4 ZSTREQU
#@IF_47_2                                                DS 0H
*MEXIT #=   478 LV= 3 ENDIF
         MVC   DTYPE,=CL6'S<D DB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DB'(MAX)'
*MCALL #=   480 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   481 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   481 LV= 4 ZCALL
*MEXIT #=   480 LV= 3 CALL
*MCALL #=   482 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   482 LV= 3 WTO
         B     EXIT16
         LTORG 
EXIT16      DS 0H
*MEXIT #=   454 LV= 2 TEST1
*MEXIT #=   424 LV= 1 TEST
*MCALL #=   483 LV= 1          TEST   LH,=LH'(MIN)'
*MCALL #=   484 LV= 2          TEST1 SVC,LH,=LH'(MIN)'
         BASR  R12,0
         USING *,R12
*MCALL #=   485 LV= 3          CTD   CTD_LH,IN==LH'(MIN)',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_LH,0,DECIMAL)
         LA    0,=LH'(MIN)'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   485 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LH'
         MVC   DHEX,=CL32' '
         LA    R2,=LH'(MIN)'
         LA    R3,L'=LH'(MIN)'
*MCALL #=   486 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   487 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   487 LV= 4 ZCALL
*MEXIT #=   486 LV= 3 CALL
*MCALL #=   488 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   488 LV= 3 WTO
*MCALL #=   489 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   490 LV= 4          ZSTREQU 
*MEXIT #=   490 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_49_2
*MEXIT #=   489 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   491 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   491 LV= 3 WTO
*MCALL #=   492 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   492 LV= 3 ABEND
*MCALL #=   493 LV= 3          ENDIF 
*MCALL #=   494 LV= 4          ZSTREQU 
*MEXIT #=   494 LV= 4 ZSTREQU
#@IF_49_2                                                DS 0H
*MEXIT #=   493 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   495 LV= 3          CFD   CFD_LH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   495 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   496 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   497 LV= 4          ZSTREQU 
*MEXIT #=   497 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_50_2
*MEXIT #=   496 LV= 3 IF
*MCALL #=   498 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   499 LV= 4          ZSTREQU 
*MEXIT #=   499 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_51_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_51_2
*MEXIT #=   498 LV= 3 IF
                   MVC  WORK16,=LH'(MIN)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   500 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =LH'(MIN)',EQ,WORK16)
*MCALL #=   501 LV= 4          ZSTREQU 
*MEXIT #=   501 LV= 4 ZSTREQU
         B     #@IF_51_E
#@IF_51_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_51_4
         CLC   =LH'(MIN)',WORK16
         BC    15-EQ,#@IF_51_4
*MEXIT #=   500 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   502 LV= 3                ELSE 
*MCALL #=   503 LV= 4          ZSTREQU 
*MEXIT #=   503 LV= 4 ZSTREQU
        B      #@IF_51_E
#@IF_51_4                                                DS 0H
*MEXIT #=   502 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   504 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   504 LV= 3 WTO
*MCALL #=   505 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   505 LV= 3 ABEND
*MCALL #=   506 LV= 3                ENDIF 
*MCALL #=   507 LV= 4          ZSTREQU 
*MEXIT #=   507 LV= 4 ZSTREQU
#@IF_51_E                        DS 0H
*MEXIT #=   506 LV= 3 ENDIF
*MCALL #=   508 LV= 3          ENDIF 
*MCALL #=   509 LV= 4          ZSTREQU 
*MEXIT #=   509 LV= 4 ZSTREQU
#@IF_50_2                                                DS 0H
*MEXIT #=   508 LV= 3 ENDIF
         MVC   DTYPE,=CL6'S<D LH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LH'(MIN)'
*MCALL #=   510 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   511 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   511 LV= 4 ZCALL
*MEXIT #=   510 LV= 3 CALL
*MCALL #=   512 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   512 LV= 3 WTO
         B     EXIT17
         LTORG 
EXIT17      DS 0H
*MEXIT #=   484 LV= 2 TEST1
*MEXIT #=   483 LV= 1 TEST
*MCALL #=   513 LV= 1          TEST   LH,=LH'(MAX)'
*MCALL #=   514 LV= 2          TEST1 SVC,LH,=LH'(MAX)'
         BASR  R12,0
         USING *,R12
*MCALL #=   515 LV= 3          CTD   CTD_LH,IN==LH'(MAX)',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_LH,0,DECIMAL)
         LA    0,=LH'(MAX)'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   515 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LH'
         MVC   DHEX,=CL32' '
         LA    R2,=LH'(MAX)'
         LA    R3,L'=LH'(MAX)'
*MCALL #=   516 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   517 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   517 LV= 4 ZCALL
*MEXIT #=   516 LV= 3 CALL
*MCALL #=   518 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   518 LV= 3 WTO
*MCALL #=   519 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   520 LV= 4          ZSTREQU 
*MEXIT #=   520 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_52_2
*MEXIT #=   519 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   521 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   521 LV= 3 WTO
*MCALL #=   522 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   522 LV= 3 ABEND
*MCALL #=   523 LV= 3          ENDIF 
*MCALL #=   524 LV= 4          ZSTREQU 
*MEXIT #=   524 LV= 4 ZSTREQU
#@IF_52_2                                                DS 0H
*MEXIT #=   523 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   525 LV= 3          CFD   CFD_LH,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LH,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   525 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   526 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   527 LV= 4          ZSTREQU 
*MEXIT #=   527 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_53_2
*MEXIT #=   526 LV= 3 IF
*MCALL #=   528 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   529 LV= 4          ZSTREQU 
*MEXIT #=   529 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_54_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_54_2
*MEXIT #=   528 LV= 3 IF
                   MVC  WORK16,=LH'(MAX)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   530 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =LH'(MAX)',EQ,WORK16)
*MCALL #=   531 LV= 4          ZSTREQU 
*MEXIT #=   531 LV= 4 ZSTREQU
         B     #@IF_54_E
#@IF_54_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_54_4
         CLC   =LH'(MAX)',WORK16
         BC    15-EQ,#@IF_54_4
*MEXIT #=   530 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   532 LV= 3                ELSE 
*MCALL #=   533 LV= 4          ZSTREQU 
*MEXIT #=   533 LV= 4 ZSTREQU
        B      #@IF_54_E
#@IF_54_4                                                DS 0H
*MEXIT #=   532 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   534 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   534 LV= 3 WTO
*MCALL #=   535 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   535 LV= 3 ABEND
*MCALL #=   536 LV= 3                ENDIF 
*MCALL #=   537 LV= 4          ZSTREQU 
*MEXIT #=   537 LV= 4 ZSTREQU
#@IF_54_E                        DS 0H
*MEXIT #=   536 LV= 3 ENDIF
*MCALL #=   538 LV= 3          ENDIF 
*MCALL #=   539 LV= 4          ZSTREQU 
*MEXIT #=   539 LV= 4 ZSTREQU
#@IF_53_2                                                DS 0H
*MEXIT #=   538 LV= 3 ENDIF
         MVC   DTYPE,=CL6'S<D LH'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LH'(MAX)'
*MCALL #=   540 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   541 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   541 LV= 4 ZCALL
*MEXIT #=   540 LV= 3 CALL
*MCALL #=   542 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   542 LV= 3 WTO
         B     EXIT18
         LTORG 
EXIT18      DS 0H
*MEXIT #=   514 LV= 2 TEST1
*MEXIT #=   513 LV= 1 TEST
*MCALL #=   543 LV= 1          TEST   LB,=LB'(MIN)'
*MCALL #=   544 LV= 2          TEST1 SVC,LB,=LB'(MIN)'
         BASR  R12,0
         USING *,R12
*MCALL #=   545 LV= 3          CTD   CTD_LB,IN==LB'(MIN)',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_LB,0,DECIMAL)
         LA    0,=LB'(MIN)'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   545 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LB'
         MVC   DHEX,=CL32' '
         LA    R2,=LB'(MIN)'
         LA    R3,L'=LB'(MIN)'
*MCALL #=   546 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   547 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   547 LV= 4 ZCALL
*MEXIT #=   546 LV= 3 CALL
*MCALL #=   548 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   548 LV= 3 WTO
*MCALL #=   549 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   550 LV= 4          ZSTREQU 
*MEXIT #=   550 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_55_2
*MEXIT #=   549 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   551 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   551 LV= 3 WTO
*MCALL #=   552 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   552 LV= 3 ABEND
*MCALL #=   553 LV= 3          ENDIF 
*MCALL #=   554 LV= 4          ZSTREQU 
*MEXIT #=   554 LV= 4 ZSTREQU
#@IF_55_2                                                DS 0H
*MEXIT #=   553 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   555 LV= 3          CFD   CFD_LB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   555 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   556 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   557 LV= 4          ZSTREQU 
*MEXIT #=   557 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_56_2
*MEXIT #=   556 LV= 3 IF
*MCALL #=   558 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   559 LV= 4          ZSTREQU 
*MEXIT #=   559 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_57_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_57_2
*MEXIT #=   558 LV= 3 IF
                   MVC  WORK16,=LB'(MIN)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   560 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =LB'(MIN)',EQ,WORK16)
*MCALL #=   561 LV= 4          ZSTREQU 
*MEXIT #=   561 LV= 4 ZSTREQU
         B     #@IF_57_E
#@IF_57_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_57_4
         CLC   =LB'(MIN)',WORK16
         BC    15-EQ,#@IF_57_4
*MEXIT #=   560 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   562 LV= 3                ELSE 
*MCALL #=   563 LV= 4          ZSTREQU 
*MEXIT #=   563 LV= 4 ZSTREQU
        B      #@IF_57_E
#@IF_57_4                                                DS 0H
*MEXIT #=   562 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   564 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   564 LV= 3 WTO
*MCALL #=   565 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   565 LV= 3 ABEND
*MCALL #=   566 LV= 3                ENDIF 
*MCALL #=   567 LV= 4          ZSTREQU 
*MEXIT #=   567 LV= 4 ZSTREQU
#@IF_57_E                        DS 0H
*MEXIT #=   566 LV= 3 ENDIF
*MCALL #=   568 LV= 3          ENDIF 
*MCALL #=   569 LV= 4          ZSTREQU 
*MEXIT #=   569 LV= 4 ZSTREQU
#@IF_56_2                                                DS 0H
*MEXIT #=   568 LV= 3 ENDIF
         MVC   DTYPE,=CL6'S<D LB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LB'(MIN)'
*MCALL #=   570 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   571 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   571 LV= 4 ZCALL
*MEXIT #=   570 LV= 3 CALL
*MCALL #=   572 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   572 LV= 3 WTO
         B     EXIT19
         LTORG 
EXIT19      DS 0H
*MEXIT #=   544 LV= 2 TEST1
*MEXIT #=   543 LV= 1 TEST
*MCALL #=   573 LV= 1          TEST   LB,=LB'(MAX)'
*MCALL #=   574 LV= 2          TEST1 SVC,LB,=LB'(MAX)'
         BASR  R12,0
         USING *,R12
*MCALL #=   575 LV= 3          CTD   CTD_LB,IN==LB'(MAX)',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_LB,0,DECIMAL)
         LA    0,=LB'(MAX)'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   575 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LB'
         MVC   DHEX,=CL32' '
         LA    R2,=LB'(MAX)'
         LA    R3,L'=LB'(MAX)'
*MCALL #=   576 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   577 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
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
         BC    15-NE,#@IF_58_2
*MEXIT #=   579 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   581 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   581 LV= 3 WTO
*MCALL #=   582 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   582 LV= 3 ABEND
*MCALL #=   583 LV= 3          ENDIF 
*MCALL #=   584 LV= 4          ZSTREQU 
*MEXIT #=   584 LV= 4 ZSTREQU
#@IF_58_2                                                DS 0H
*MEXIT #=   583 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   585 LV= 3          CFD   CFD_LB,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LB,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   585 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   586 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   587 LV= 4          ZSTREQU 
*MEXIT #=   587 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_59_2
*MEXIT #=   586 LV= 3 IF
*MCALL #=   588 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   589 LV= 4          ZSTREQU 
*MEXIT #=   589 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_60_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_60_2
*MEXIT #=   588 LV= 3 IF
                   MVC  WORK16,=LB'(MAX)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   590 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =LB'(MAX)',EQ,WORK16)
*MCALL #=   591 LV= 4          ZSTREQU 
*MEXIT #=   591 LV= 4 ZSTREQU
         B     #@IF_60_E
#@IF_60_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_60_4
         CLC   =LB'(MAX)',WORK16
         BC    15-EQ,#@IF_60_4
*MEXIT #=   590 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   592 LV= 3                ELSE 
*MCALL #=   593 LV= 4          ZSTREQU 
*MEXIT #=   593 LV= 4 ZSTREQU
        B      #@IF_60_E
#@IF_60_4                                                DS 0H
*MEXIT #=   592 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   594 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   594 LV= 3 WTO
*MCALL #=   595 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   595 LV= 3 ABEND
*MCALL #=   596 LV= 3                ENDIF 
*MCALL #=   597 LV= 4          ZSTREQU 
*MEXIT #=   597 LV= 4 ZSTREQU
#@IF_60_E                        DS 0H
*MEXIT #=   596 LV= 3 ENDIF
*MCALL #=   598 LV= 3          ENDIF 
*MCALL #=   599 LV= 4          ZSTREQU 
*MEXIT #=   599 LV= 4 ZSTREQU
#@IF_59_2                                                DS 0H
*MEXIT #=   598 LV= 3 ENDIF
         MVC   DTYPE,=CL6'S<D LB'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LB'(MAX)'
*MCALL #=   600 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   601 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   601 LV= 4 ZCALL
*MEXIT #=   600 LV= 3 CALL
*MCALL #=   602 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   602 LV= 3 WTO
         B     EXIT20
         LTORG 
EXIT20      DS 0H
*MEXIT #=   574 LV= 2 TEST1
*MEXIT #=   573 LV= 1 TEST
*MCALL #=   603 LV= 1          TEST   ED,=ED'(MIN)'
*MCALL #=   604 LV= 2          TEST1 SVC,ED,=ED'(MIN)'
         BASR  R12,0
         USING *,R12
*MCALL #=   605 LV= 3          CTD   CTD_ED,IN==ED'(MIN)',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_ED,0,DECIMAL)
         LA    0,=ED'(MIN)'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   605 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D ED'
         MVC   DHEX,=CL32' '
         LA    R2,=ED'(MIN)'
         LA    R3,L'=ED'(MIN)'
*MCALL #=   606 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   607 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   607 LV= 4 ZCALL
*MEXIT #=   606 LV= 3 CALL
*MCALL #=   608 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   608 LV= 3 WTO
*MCALL #=   609 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   610 LV= 4          ZSTREQU 
*MEXIT #=   610 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_61_2
*MEXIT #=   609 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   611 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   611 LV= 3 WTO
*MCALL #=   612 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   612 LV= 3 ABEND
*MCALL #=   613 LV= 3          ENDIF 
*MCALL #=   614 LV= 4          ZSTREQU 
*MEXIT #=   614 LV= 4 ZSTREQU
#@IF_61_2                                                DS 0H
*MEXIT #=   613 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   615 LV= 3          CFD   CFD_ED,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_ED,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   615 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   616 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   617 LV= 4          ZSTREQU 
*MEXIT #=   617 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_62_2
*MEXIT #=   616 LV= 3 IF
*MCALL #=   618 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   619 LV= 4          ZSTREQU 
*MEXIT #=   619 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_63_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_63_2
*MEXIT #=   618 LV= 3 IF
                   MVC  WORK16,=ED'(MIN)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   620 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =ED'(MIN)',EQ,WORK16)
*MCALL #=   621 LV= 4          ZSTREQU 
*MEXIT #=   621 LV= 4 ZSTREQU
         B     #@IF_63_E
#@IF_63_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_63_4
         CLC   =ED'(MIN)',WORK16
         BC    15-EQ,#@IF_63_4
*MEXIT #=   620 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   622 LV= 3                ELSE 
*MCALL #=   623 LV= 4          ZSTREQU 
*MEXIT #=   623 LV= 4 ZSTREQU
        B      #@IF_63_E
#@IF_63_4                                                DS 0H
*MEXIT #=   622 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   624 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   624 LV= 3 WTO
*MCALL #=   625 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   625 LV= 3 ABEND
*MCALL #=   626 LV= 3                ENDIF 
*MCALL #=   627 LV= 4          ZSTREQU 
*MEXIT #=   627 LV= 4 ZSTREQU
#@IF_63_E                        DS 0H
*MEXIT #=   626 LV= 3 ENDIF
*MCALL #=   628 LV= 3          ENDIF 
*MCALL #=   629 LV= 4          ZSTREQU 
*MEXIT #=   629 LV= 4 ZSTREQU
#@IF_62_2                                                DS 0H
*MEXIT #=   628 LV= 3 ENDIF
         MVC   DTYPE,=CL6'S<D ED'
         MVC   DHEX,=CL32' '
         LA    R3,L'=ED'(MIN)'
*MCALL #=   630 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   631 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   631 LV= 4 ZCALL
*MEXIT #=   630 LV= 3 CALL
*MCALL #=   632 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   632 LV= 3 WTO
         B     EXIT21
         LTORG 
EXIT21      DS 0H
*MEXIT #=   604 LV= 2 TEST1
*MEXIT #=   603 LV= 1 TEST
*MCALL #=   633 LV= 1          TEST   ED,=ED'(MAX)'
*MCALL #=   634 LV= 2          TEST1 SVC,ED,=ED'(MAX)'
         BASR  R12,0
         USING *,R12
*MCALL #=   635 LV= 3          CTD   CTD_ED,IN==ED'(MAX)',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_ED,0,DECIMAL)
         LA    0,=ED'(MAX)'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   635 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D ED'
         MVC   DHEX,=CL32' '
         LA    R2,=ED'(MAX)'
         LA    R3,L'=ED'(MAX)'
*MCALL #=   636 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   637 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   637 LV= 4 ZCALL
*MEXIT #=   636 LV= 3 CALL
*MCALL #=   638 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   638 LV= 3 WTO
*MCALL #=   639 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   640 LV= 4          ZSTREQU 
*MEXIT #=   640 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_64_2
*MEXIT #=   639 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   641 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   641 LV= 3 WTO
*MCALL #=   642 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   642 LV= 3 ABEND
*MCALL #=   643 LV= 3          ENDIF 
*MCALL #=   644 LV= 4          ZSTREQU 
*MEXIT #=   644 LV= 4 ZSTREQU
#@IF_64_2                                                DS 0H
*MEXIT #=   643 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   645 LV= 3          CFD   CFD_ED,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_ED,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   645 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   646 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   647 LV= 4          ZSTREQU 
*MEXIT #=   647 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_65_2
*MEXIT #=   646 LV= 3 IF
*MCALL #=   648 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   649 LV= 4          ZSTREQU 
*MEXIT #=   649 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_66_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_66_2
*MEXIT #=   648 LV= 3 IF
                   MVC  WORK16,=ED'(MAX)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   650 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =ED'(MAX)',EQ,WORK16)
*MCALL #=   651 LV= 4          ZSTREQU 
*MEXIT #=   651 LV= 4 ZSTREQU
         B     #@IF_66_E
#@IF_66_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_66_4
         CLC   =ED'(MAX)',WORK16
         BC    15-EQ,#@IF_66_4
*MEXIT #=   650 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   652 LV= 3                ELSE 
*MCALL #=   653 LV= 4          ZSTREQU 
*MEXIT #=   653 LV= 4 ZSTREQU
        B      #@IF_66_E
#@IF_66_4                                                DS 0H
*MEXIT #=   652 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   654 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   654 LV= 3 WTO
*MCALL #=   655 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   655 LV= 3 ABEND
*MCALL #=   656 LV= 3                ENDIF 
*MCALL #=   657 LV= 4          ZSTREQU 
*MEXIT #=   657 LV= 4 ZSTREQU
#@IF_66_E                        DS 0H
*MEXIT #=   656 LV= 3 ENDIF
*MCALL #=   658 LV= 3          ENDIF 
*MCALL #=   659 LV= 4          ZSTREQU 
*MEXIT #=   659 LV= 4 ZSTREQU
#@IF_65_2                                                DS 0H
*MEXIT #=   658 LV= 3 ENDIF
         MVC   DTYPE,=CL6'S<D ED'
         MVC   DHEX,=CL32' '
         LA    R3,L'=ED'(MAX)'
*MCALL #=   660 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   661 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   661 LV= 4 ZCALL
*MEXIT #=   660 LV= 3 CALL
*MCALL #=   662 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   662 LV= 3 WTO
         B     EXIT22
         LTORG 
EXIT22      DS 0H
*MEXIT #=   634 LV= 2 TEST1
*MEXIT #=   633 LV= 1 TEST
*MCALL #=   663 LV= 1          TEST   DD,=DD'(MIN)'
*MCALL #=   664 LV= 2          TEST1 SVC,DD,=DD'(MIN)'
         BASR  R12,0
         USING *,R12
*MCALL #=   665 LV= 3          CTD   CTD_DD,IN==DD'(MIN)',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_DD,0,DECIMAL)
         LA    0,=DD'(MIN)'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   665 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DD'
         MVC   DHEX,=CL32' '
         LA    R2,=DD'(MIN)'
         LA    R3,L'=DD'(MIN)'
*MCALL #=   666 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   667 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   667 LV= 4 ZCALL
*MEXIT #=   666 LV= 3 CALL
*MCALL #=   668 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   668 LV= 3 WTO
*MCALL #=   669 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   670 LV= 4          ZSTREQU 
*MEXIT #=   670 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_67_2
*MEXIT #=   669 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   671 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   671 LV= 3 WTO
*MCALL #=   672 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   672 LV= 3 ABEND
*MCALL #=   673 LV= 3          ENDIF 
*MCALL #=   674 LV= 4          ZSTREQU 
*MEXIT #=   674 LV= 4 ZSTREQU
#@IF_67_2                                                DS 0H
*MEXIT #=   673 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   675 LV= 3          CFD   CFD_DD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   675 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   676 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   677 LV= 4          ZSTREQU 
*MEXIT #=   677 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_68_2
*MEXIT #=   676 LV= 3 IF
*MCALL #=   678 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   679 LV= 4          ZSTREQU 
*MEXIT #=   679 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_69_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_69_2
*MEXIT #=   678 LV= 3 IF
                   MVC  WORK16,=DD'(MIN)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   680 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =DD'(MIN)',EQ,WORK16)
*MCALL #=   681 LV= 4          ZSTREQU 
*MEXIT #=   681 LV= 4 ZSTREQU
         B     #@IF_69_E
#@IF_69_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_69_4
         CLC   =DD'(MIN)',WORK16
         BC    15-EQ,#@IF_69_4
*MEXIT #=   680 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   682 LV= 3                ELSE 
*MCALL #=   683 LV= 4          ZSTREQU 
*MEXIT #=   683 LV= 4 ZSTREQU
        B      #@IF_69_E
#@IF_69_4                                                DS 0H
*MEXIT #=   682 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   684 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   684 LV= 3 WTO
*MCALL #=   685 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   685 LV= 3 ABEND
*MCALL #=   686 LV= 3                ENDIF 
*MCALL #=   687 LV= 4          ZSTREQU 
*MEXIT #=   687 LV= 4 ZSTREQU
#@IF_69_E                        DS 0H
*MEXIT #=   686 LV= 3 ENDIF
*MCALL #=   688 LV= 3          ENDIF 
*MCALL #=   689 LV= 4          ZSTREQU 
*MEXIT #=   689 LV= 4 ZSTREQU
#@IF_68_2                                                DS 0H
*MEXIT #=   688 LV= 3 ENDIF
         MVC   DTYPE,=CL6'S<D DD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DD'(MIN)'
*MCALL #=   690 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   691 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   691 LV= 4 ZCALL
*MEXIT #=   690 LV= 3 CALL
*MCALL #=   692 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   692 LV= 3 WTO
         B     EXIT23
         LTORG 
EXIT23      DS 0H
*MEXIT #=   664 LV= 2 TEST1
*MEXIT #=   663 LV= 1 TEST
*MCALL #=   693 LV= 1          TEST   DD,=DD'(MAX)'
*MCALL #=   694 LV= 2          TEST1 SVC,DD,=DD'(MAX)'
         BASR  R12,0
         USING *,R12
*MCALL #=   695 LV= 3          CTD   CTD_DD,IN==DD'(MAX)',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_DD,0,DECIMAL)
         LA    0,=DD'(MAX)'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   695 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D DD'
         MVC   DHEX,=CL32' '
         LA    R2,=DD'(MAX)'
         LA    R3,L'=DD'(MAX)'
*MCALL #=   696 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   697 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   697 LV= 4 ZCALL
*MEXIT #=   696 LV= 3 CALL
*MCALL #=   698 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   698 LV= 3 WTO
*MCALL #=   699 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   700 LV= 4          ZSTREQU 
*MEXIT #=   700 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_70_2
*MEXIT #=   699 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   701 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   701 LV= 3 WTO
*MCALL #=   702 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   702 LV= 3 ABEND
*MCALL #=   703 LV= 3          ENDIF 
*MCALL #=   704 LV= 4          ZSTREQU 
*MEXIT #=   704 LV= 4 ZSTREQU
#@IF_70_2                                                DS 0H
*MEXIT #=   703 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   705 LV= 3          CFD   CFD_DD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_DD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   705 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   706 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   707 LV= 4          ZSTREQU 
*MEXIT #=   707 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_71_2
*MEXIT #=   706 LV= 3 IF
*MCALL #=   708 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   709 LV= 4          ZSTREQU 
*MEXIT #=   709 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_72_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_72_2
*MEXIT #=   708 LV= 3 IF
                   MVC  WORK16,=DD'(MAX)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   710 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =DD'(MAX)',EQ,WORK16)
*MCALL #=   711 LV= 4          ZSTREQU 
*MEXIT #=   711 LV= 4 ZSTREQU
         B     #@IF_72_E
#@IF_72_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_72_4
         CLC   =DD'(MAX)',WORK16
         BC    15-EQ,#@IF_72_4
*MEXIT #=   710 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   712 LV= 3                ELSE 
*MCALL #=   713 LV= 4          ZSTREQU 
*MEXIT #=   713 LV= 4 ZSTREQU
        B      #@IF_72_E
#@IF_72_4                                                DS 0H
*MEXIT #=   712 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   714 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   714 LV= 3 WTO
*MCALL #=   715 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   715 LV= 3 ABEND
*MCALL #=   716 LV= 3                ENDIF 
*MCALL #=   717 LV= 4          ZSTREQU 
*MEXIT #=   717 LV= 4 ZSTREQU
#@IF_72_E                        DS 0H
*MEXIT #=   716 LV= 3 ENDIF
*MCALL #=   718 LV= 3          ENDIF 
*MCALL #=   719 LV= 4          ZSTREQU 
*MEXIT #=   719 LV= 4 ZSTREQU
#@IF_71_2                                                DS 0H
*MEXIT #=   718 LV= 3 ENDIF
         MVC   DTYPE,=CL6'S<D DD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=DD'(MAX)'
*MCALL #=   720 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   721 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   721 LV= 4 ZCALL
*MEXIT #=   720 LV= 3 CALL
*MCALL #=   722 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   722 LV= 3 WTO
         B     EXIT24
         LTORG 
EXIT24      DS 0H
*MEXIT #=   694 LV= 2 TEST1
*MEXIT #=   693 LV= 1 TEST
*MCALL #=   723 LV= 1          TEST   LD,=LD'(MIN)'
*MCALL #=   724 LV= 2          TEST1 SVC,LD,=LD'(MIN)'
         BASR  R12,0
         USING *,R12
*MCALL #=   725 LV= 3          CTD   CTD_LD,IN==LD'(MIN)',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_LD,0,DECIMAL)
         LA    0,=LD'(MIN)'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   725 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LD'
         MVC   DHEX,=CL32' '
         LA    R2,=LD'(MIN)'
         LA    R3,L'=LD'(MIN)'
*MCALL #=   726 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   727 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   727 LV= 4 ZCALL
*MEXIT #=   726 LV= 3 CALL
*MCALL #=   728 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   728 LV= 3 WTO
*MCALL #=   729 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   730 LV= 4          ZSTREQU 
*MEXIT #=   730 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_73_2
*MEXIT #=   729 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   731 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   731 LV= 3 WTO
*MCALL #=   732 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   732 LV= 3 ABEND
*MCALL #=   733 LV= 3          ENDIF 
*MCALL #=   734 LV= 4          ZSTREQU 
*MEXIT #=   734 LV= 4 ZSTREQU
#@IF_73_2                                                DS 0H
*MEXIT #=   733 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   735 LV= 3          CFD   CFD_LD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   735 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   736 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   737 LV= 4          ZSTREQU 
*MEXIT #=   737 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_74_2
*MEXIT #=   736 LV= 3 IF
*MCALL #=   738 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   739 LV= 4          ZSTREQU 
*MEXIT #=   739 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_75_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_75_2
*MEXIT #=   738 LV= 3 IF
                   MVC  WORK16,=LD'(MIN)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   740 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =LD'(MIN)',EQ,WORK16)
*MCALL #=   741 LV= 4          ZSTREQU 
*MEXIT #=   741 LV= 4 ZSTREQU
         B     #@IF_75_E
#@IF_75_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_75_4
         CLC   =LD'(MIN)',WORK16
         BC    15-EQ,#@IF_75_4
*MEXIT #=   740 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   742 LV= 3                ELSE 
*MCALL #=   743 LV= 4          ZSTREQU 
*MEXIT #=   743 LV= 4 ZSTREQU
        B      #@IF_75_E
#@IF_75_4                                                DS 0H
*MEXIT #=   742 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   744 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   744 LV= 3 WTO
*MCALL #=   745 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   745 LV= 3 ABEND
*MCALL #=   746 LV= 3                ENDIF 
*MCALL #=   747 LV= 4          ZSTREQU 
*MEXIT #=   747 LV= 4 ZSTREQU
#@IF_75_E                        DS 0H
*MEXIT #=   746 LV= 3 ENDIF
*MCALL #=   748 LV= 3          ENDIF 
*MCALL #=   749 LV= 4          ZSTREQU 
*MEXIT #=   749 LV= 4 ZSTREQU
#@IF_74_2                                                DS 0H
*MEXIT #=   748 LV= 3 ENDIF
         MVC   DTYPE,=CL6'S<D LD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LD'(MIN)'
*MCALL #=   750 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   751 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   751 LV= 4 ZCALL
*MEXIT #=   750 LV= 3 CALL
*MCALL #=   752 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   752 LV= 3 WTO
         B     EXIT25
         LTORG 
EXIT25      DS 0H
*MEXIT #=   724 LV= 2 TEST1
*MEXIT #=   723 LV= 1 TEST
*MCALL #=   753 LV= 1          TEST   LD,=LD'(MAX)'
*MCALL #=   754 LV= 2          TEST1 SVC,LD,=LD'(MAX)'
         BASR  R12,0
         USING *,R12
*MCALL #=   755 LV= 3          CTD   CTD_LD,IN==LD'(MAX)',OUT=DECIMAL,LX
               INKAGE=SVC
         LA    1,=A(CTD_LD,0,DECIMAL)
         LA    0,=LD'(MAX)'
         ST    0,4(1)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=   755 LV= 3 CTD
         CVD   R15,PRC
         MVC   DTYPE,=CL6'S>D LD'
         MVC   DHEX,=CL32' '
         LA    R2,=LD'(MAX)'
         LA    R3,L'=LD'(MAX)'
*MCALL #=   756 LV= 3          CALL  CVTTOHEX,((R2),DHEX,(R3))
*MCALL #=   757 LV= 4          ZCALL CVTTOHEX,((R2),DHEX,(R3)),,ID=,LINX
               KINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A((R2),DHEX,(R3))
         ST     R2,0(1)
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   757 LV= 4 ZCALL
*MEXIT #=   756 LV= 3 CALL
*MCALL #=   758 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   758 LV= 3 WTO
*MCALL #=   759 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   760 LV= 4          ZSTREQU 
*MEXIT #=   760 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_76_2
*MEXIT #=   759 LV= 3 IF
               MVC DRC,=X'40202020'
               ED  DRC,PRC+6
*MCALL #=   761 LV= 3                WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   761 LV= 3 WTO
*MCALL #=   762 LV= 3                ABEND 101
         LA   1,101
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   762 LV= 3 ABEND
*MCALL #=   763 LV= 3          ENDIF 
*MCALL #=   764 LV= 4          ZSTREQU 
*MEXIT #=   764 LV= 4 ZSTREQU
#@IF_76_2                                                DS 0H
*MEXIT #=   763 LV= 3 ENDIF
         XC    WORK16,WORK16
*MCALL #=   765 LV= 3          CFD   CFD_LD,OUT=WORK16,IN=DECIMAL,LINKAX
               GE=SVC
         DS    0H
         LA    1,=A(CFD_LD,WORK16,DECIMAL)
         SVC   171 CFD Z390 SVC R1=A(TYPE,OUT,IN)
*MEXIT #=   765 LV= 3 CFD
         CVD   R15,PRC
*MCALL #=   766 LV= 3          IF    (CP,PRC,NE,=P'0')
*MCALL #=   767 LV= 4          ZSTREQU 
*MEXIT #=   767 LV= 4 ZSTREQU
         CP    PRC,=P'0'
         BC    15-NE,#@IF_77_2
*MEXIT #=   766 LV= 3 IF
*MCALL #=   768 LV= 3                IF  (CP,PRC,LE,=P'4'),AND,(OC,WORKX
               16,Z,WORK16)
*MCALL #=   769 LV= 4          ZSTREQU 
*MEXIT #=   769 LV= 4 ZSTREQU
         CP    PRC,=P'4'
         BC    15-LE,#@IF_78_2
         OC    WORK16,WORK16
         BC    15-Z,#@IF_78_2
*MEXIT #=   768 LV= 3 IF
                   MVC  WORK16,=LD'(MAX)'     REPLACE 0 WITH (MIN) FOR X
               MF
*MCALL #=   770 LV= 3                ELSEIF (CP,PRC,EQ,=P'8'),AND,(CLC,X
               =LD'(MAX)',EQ,WORK16)
*MCALL #=   771 LV= 4          ZSTREQU 
*MEXIT #=   771 LV= 4 ZSTREQU
         B     #@IF_78_E
#@IF_78_2                                                DS 0H
         CP    PRC,=P'8'
         BC    15-EQ,#@IF_78_4
         CLC   =LD'(MAX)',WORK16
         BC    15-EQ,#@IF_78_4
*MEXIT #=   770 LV= 3 ELSEIF
*                  ALLOW RC=8 FOR MAX VALUE RETURN FROM FPCONVRT
*MCALL #=   772 LV= 3                ELSE 
*MCALL #=   773 LV= 4          ZSTREQU 
*MEXIT #=   773 LV= 4 ZSTREQU
        B      #@IF_78_E
#@IF_78_4                                                DS 0H
*MEXIT #=   772 LV= 3 ELSE
                   MVC DRC,=X'40202020'
                   ED  DRC,PRC+6
*MCALL #=   774 LV= 3                    WTO MF=(E,WTOPRC)
         LA    1,WTOPRC
         SVC   35
*MEXIT #=   774 LV= 3 WTO
*MCALL #=   775 LV= 3                    ABEND 102
         LA   1,102
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   775 LV= 3 ABEND
*MCALL #=   776 LV= 3                ENDIF 
*MCALL #=   777 LV= 4          ZSTREQU 
*MEXIT #=   777 LV= 4 ZSTREQU
#@IF_78_E                        DS 0H
*MEXIT #=   776 LV= 3 ENDIF
*MCALL #=   778 LV= 3          ENDIF 
*MCALL #=   779 LV= 4          ZSTREQU 
*MEXIT #=   779 LV= 4 ZSTREQU
#@IF_77_2                                                DS 0H
*MEXIT #=   778 LV= 3 ENDIF
         MVC   DTYPE,=CL6'S<D LD'
         MVC   DHEX,=CL32' '
         LA    R3,L'=LD'(MAX)'
*MCALL #=   780 LV= 3          CALL  CVTTOHEX,(WORK16,DHEX,(R3))
*MCALL #=   781 LV= 4          ZCALL CVTTOHEX,(WORK16,DHEX,(R3)),,ID=,LX
               INKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(WORK16,DHEX,(R3))
         ST     R3,8(1)
         LRL    15,=V(CVTTOHEX)
         BALR      14,15
*MEXIT #=   781 LV= 4 ZCALL
*MEXIT #=   780 LV= 3 CALL
*MCALL #=   782 LV= 3          WTO   MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=   782 LV= 3 WTO
         B     EXIT26
         LTORG 
EXIT26      DS 0H
*MEXIT #=   754 LV= 2 TEST1
*MEXIT #=   753 LV= 1 TEST
*MCALL #=   783 LV= 1          RT1   END
         B      RT1_END
*MEXIT #=   783 LV= 1 RT1
         END 
