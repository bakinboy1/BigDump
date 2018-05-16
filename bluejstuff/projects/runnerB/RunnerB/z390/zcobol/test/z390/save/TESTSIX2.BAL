*    ZCOBOL PGM='zcobol\test\TESTSIX2' VER=V1.5.06 MM/DD/YY  
*    ZCOBOL OPTIONS=() 
         COPY  TESTSIX2_ZC_LABELS.CPY
*        IDENTIFICATION DIVISION.
*        PROGRAM-ID.    TESTSIX2.
         PRINT NOLIST,NOGEN,NOLISTUSE    SET LIST OPTION FOR INTERNAL CX
               ODE
TESTSIX2 CSECT ,                CSECT WITH PROCEDURE CODE AND WS
         USING *,ZC_R15
         STM   14,12,12+4*(14-14)(13)
         CNOP  4,8             FORCE ZC390PVT TO DOUBLEWORD BOUNDARY
         BRAS  ZC_R8,ZC_LOAD
         USING *,ZC_R8            BASE FOR LOAD AND CICS V5 USE
*
*  THESE FIELDS MUST BE KEPT IN SYNC WITH zcobol\ZC390PVT.CPY
*
         DC    CL8'TESTSIX2'    PVTPGM   ZCOBOL PGM NAME
         DC    CL8'01/02/05'   PVTDATE  ZCOBOL COMPILE DATE
         DC    CL8'22.33'   PVTTIME  ZCOBOL COMPILE TIME
         DC    CL8'V1.5.06'    PVTVER   ZCOBOL COMPILER VERSION
         DC    C'0'     PVTCICS  ZCOBOL EXEC CICS PGM
         DC    C'1'   PVTEXTND ZCOBOL EXTENDED PRECISION
         DC    C'0'    PVTTRUNC ZCOBOL TRUNCATE TO PICTURE
         DC    C'1'      PVTR64   ZCOBOL USE 64 BIT REGISTERS
         DC    H'80' MAX DISPLAY LINE LEN  RPI 1118
         DS    XL10            RESERVED
ZC_LOAD  DS    0H
         LA    0,=CL8'ZC390LIB'
         SR    15,15 USE DEFAULT SYS390 SEARCH
         SVC   8 LOAD R0=A(NAME) R15=DDNAME/DSNAME ADDR OR 0
         LTR   ZC_R15,ZC_R15
         JZ    ZC_LOAD_OK
         BRAS  1,*+(WTO#0015_EOT-*+1)/2*2
         DC    AL2(WTO#0015_EOT-*,0),C'ZC390LIB NOT FOUND'
WTO#0015_EOT     EQU *
         SVC   35
         LA  ZC_R15,16
         SVC 3      EXIT TO CALLER WITH RC=16
ZC_LOAD_OK DS  0H
         LR    ZC_R9,ZC_R0
         USING ZC390CVT,ZC_R9    R9=CVT
         CLC   ZCVT_ID,=C'ZCVT'              CHECK ZCVT ID AND LENGTH
         JNE   ZC_VER_ERR                    IN ZC390LIB.390 MATCH
         CLC   ZCVT_LEN,=A(ZCVT_END-ZCVT_ID) ZCOBOL PGM COMPILED ID/LEN
         BNE   ZC_VER_ERR
         L     ZC_R15,ZCVT_ZC390NUC
         BASR  ZC_R14,ZC_R15 CALL ZC390NUC TO VERIFY VER, OPTIONS
         J     ZC_VER_OK
ZC_VER_ERR DS 0H
         BRAS  1,*+(WTO#0016_EOT-*+1)/2*2
         DC    AL2(WTO#0016_EOT-*,0),C'ZC390LIB ZCVT VERIFY ERROR'
WTO#0016_EOT     EQU *
         SVC   35
         LA  ZC_R15,16
         SVC 3      EXIT TO CALLER WITH RC=16
         LTORG 
         PUSH  PRINT,NOPRINT
         PRINT OFF,NOPRINT
ZC_R0    EQU   0
ZC_R1    EQU   1
ZC_R2    EQU   2
ZC_R3    EQU   3
ZC_R4    EQU   4
ZC_R5    EQU   5
ZC_R6    EQU   6
ZC_R7    EQU   7
ZC_R8    EQU   8
ZC_R9    EQU   9
ZC_R10   EQU  10
ZC_R11   EQU  11
ZC_R12   EQU  12
ZC_R13   EQU  13
ZC_R14   EQU  14
ZC_R15   EQU  15
ZC_F0    EQU   0
ZC_F1    EQU   1
ZC_F2    EQU   2
ZC_F3    EQU   3
ZC_F4    EQU   4
ZC_F5    EQU   5
ZC_F6    EQU   6
ZC_F7    EQU   7
ZC_F8    EQU   8
ZC_F9    EQU   9
ZC_F10   EQU  10
ZC_F11   EQU  11
ZC_F12   EQU  12
ZC_F13   EQU  13
ZC_F14   EQU  14
ZC_F15   EQU  15
ZC_H     EQU   2   HIGH
ZC_L     EQU   4   LOW
ZC_E     EQU   8   EQUAL
ZC_NH    EQU   13  NOT HIGHT
ZC_NL    EQU   11  NOT LOW
ZC_NE    EQU   7   NOT EQUAL
ZC_O     EQU   1   OVERFLOW
ZC_P     EQU   2   POSITIVE
ZC_M     EQU   4   MINUS
ZC_Z     EQU   8   ZERO
ZC_NP    EQU   13  NOT POSITIVE
ZC_NM    EQU   11  NOT MINUS
ZC_NZ    EQU   7   NOT ZERO
ZC_NO    EQU   14  NOT OVERFLOW
ZC_EQ    EQU   8   EQUAL
ZC_GT    EQU   2   GREATER THAN
ZC_LT    EQU   4   LESS    THAN
ZC_GE    EQU   11  GREATER THAN OR EQUAL
ZC_LE    EQU   13  LESS    THAN OR EQUAL
         POP   PRINT,NOPRINT
PFPO_TEST    EQU  X'80' PFPO TEST IF VALID OPCODE (NOT SUPPORTED YET)
PFPO_RADIX   EQU  1 PFPO OPCODE - CONVERT FROM ONE RADIX TO ANOTHER
PFPO_RND     EQU  0 PFOP ROUNDING OPTION (ONLY DEFAULT ALLOWED)
PFPO_TYPE_EH EQU  0 EH HFP SHORT     32 BITS 7  DIGITS
PFPO_TYPE_DH EQU  1 ED HFP LONG      64 BITS 15 DIGITS
PFPO_TYPE_LH EQU  2 EL HFP EXTENDED 128 BITS 30 DIGITS
PFPO_TYPE_EB EQU  5 EB BFP SHORT     32 BITS 7  DIGITS
PFPO_TYPE_DB EQU  6 DB BFP LONG      64 BITS 16 DIGITS
PFPO_TYPE_LB EQU  7 LB BFP EXTENDED 128 BITS 34 DIGITS
PFPO_TYPE_ED EQU  8 ED DFP SHORT     32 BITS 7  DIGITS
PFPO_TYPE_DD EQU  9 DD DFP LONG      64 BITS 16 DIGITS
PFPO_TYPE_LD EQU 10 LD DFP EXTENDED 128 BITS 34 DIGITS
ZC_VER_OK DS   0H
         L     ZC_R2,24(ZC_R13) SET ZC_R2=PARMLIST ADDRESS AFTER LOAD
         LARL  ZC_R1,ZC_WS     ZC_R2=A(WORKING STORAGE WITH SAVEAREA)
         ST    ZC_R1,8(ZC_R13) FORWARD  SAVE CHAIN
         ST    ZC_R13,4(ZC_R1) BACKWARD SAVE CHAIN
         LR    ZC_R13,ZC_R1    LINK SAVE AREA IN ZC390CVT
         USING ZC_WS,ZC_R13    BASE FOR ZCOBOL WS (SEE GEN_SYM_RX.MAC)
         ST    ZC_R13,ZC_WS_START  SAVE ADDR WS IN WS PREFIX
         LARL  ZC_R0,ZC_WS_END
         SR    ZC_R0,ZC_R13
         ST    ZC_R0,ZC_WS_LEN     SAVE LENGTH OF WS IN WS PREFIX
         DROP  ZC_R15              RPI 1042
ZC_WSLOC LOCTR 
ZC_WS    DS    0D           START WORKING STORAGE
ZC390CVT DSECT 
ZCVT_ID            DC    C'ZCVT'             ZCVT ID  VERIFIED BY ZCOB
ZCVT_LEN           DC    A(ZCVT_END-ZCVT_ID) ZCVT LEN VERIFIED BY ZCOB
ZCVT_VER           DC    CL8'V1.5.06'    ZCVT VER VERIFIED BY ZC390NUC
ZCVT_ZC390NUC  DC V(ZC390NUC)      MODULE  SYSTEM ROUTINE MODULE INIT
ZCVT_CALL           DC V(CALL)       ENTRY R0=A(PGM),R1=A(PARMLIST)
ZCVT_CMP64R32       DC V(CMP64R32)   ENTRY COMPARE R0-1=FLD1 R2-3=FLD2
ZCVT_CVTLBTQ        DC V(CVTLBTQ)    ENTRY CVT LB IN F4-6 TO Q IN R0-1
ZCVT_CVTLDTP        DC V(CVTLDTP)    ENTRY CVT LD IN F0-2 TO PL31 R0-1
ZCVT_CVTQTLB        DC V(CVTQTLB)    ENTRY CVT Q IN R0-1 TO LB IN F4-6
ZCVT_DIV64R32       DC V(DIV64R32)   ENTRY DIVIDE R0-1=N64, R2-3=MAX64
ZCVT_DIVQ128        DC V(DIVQ128)    ENTRY DIVIDE Q128 R0-R1 BY R2-R3
ZCVT_GOBACK         DC V(GOBACK)     ENTRY R1=RC
ZCVT_MPYQ128        DC V(MPYQ128)    ENTRY MULTIPLY Q128 R0-R1 BY R2-R3
ZCVT_OSE64R32       DC V(OSE64R32)   ENTRY ON SIZE ERR R0-1=N, R2-3=MAX
ZCVT_PERFORM        DC V(PERFORM)    ENTRY R14=PGTAR,R0=PGEXT,R1=PMRET
ZCVT_PMCHECK        DC V(PMCHECK)    ENTRY R14=RETURN TO NEXT INSTR.
ZCVT_ROUNDF         DC V(ROUNDF)     ENTRY R0=REM,R1=QUO,R2=DIVISOR
ZCVT_STACKORG       DC V(STACKORG)   ENTRY PERFORM STACK ORIGIN
ZCVT_STACKPTR       DC V(STACKPTR)   ENTRY CUR ENTRY A(PG_END+4,RET)
ZCVT_STACKEND       DC V(STACKEND)   ENTRY PERFORM STACK END
ZCVT_STOPRUN        DC V(STOPRUN)    ENTRY R1=RC
ZCVT_TALPHAX        DC V(TALPHAX)    ENTRY TEST ALPHABETIC X
ZCVT_TNUMP          DC V(TNUMP)      ENTRY TEST NUMERIC P
ZCVT_TNUMX          DC V(TNUMX)      ENTRY TEST NUMERIC X
ZCVT_TNUMZ          DC V(TNUMZ)      ENTRY TEST NUMERIC Z
*
* ADDITIONAL SEPARATE MODULES LINKED WITH Z390NUC IN ZC390LIB.390
*
ZCVT_ABORT     DC V(ABORT)         MODULE  R1=ABORT ERROR MSG #
ZCVT_ABORT_ALTER   EQU    1 ABORT ALTER DUE TO BRC NOT FOUND AT TARGET
ZCVT_ABORT_CALL    EQU    2 ABORT DYNAMIC CALL - PGM NOT FOUND
ZCVT_ABORT_DISPLAY EQU    3 ABORT DISPLAY DUE TO BUFFER EXCEEDED
ZCVT_ABORT_OPEN    EQU    4 ABORT OPEN  INVALID DCB
ZCVT_ABORT_STACK   EQU    6 ABORT PEROFRM STACK OVERFLOW
ZCVT_ABORT_VERSION EQU    7 ABORT ZC390NUC INIT ZCOBOL VERSION ERROR
ZCVT_ABORT_INT128  EQU    8 ABORT INTEGER 128 CONVERSION OVERFLO
ZCVT_ABORT_DIVQ    EQU    9 ABORT DIVIDE Q IF DIVISOR 0 OR > 2**63
ZCVT_ABORT_CICS    EQU   10 ABORT THIS PGM REQUIRES EXEC CICS TRANS MGR
ZCVT_ABORT_ACCEPT  EQU   11 ABORT ACCEPT EOF
ZCVT_ABORT_MAXERR  EQU   11 ABORT MAX ERROR CODE
ZCVT_ACCEPT    DC V(ACCEPT)        MODULE  R1=A(TYPE,FLD_ADD,FLD_LEN)
ZCVT_ACCEPT_DEFAULT EQU   1 INPUT DEFAULT DDNAME=SYSIN
ZCVT_ACCEPT_CONSOLE EQU   2 INPUT VIA WTOR FROM CONSOLE
ZCVT_ACCEPT_DDNAME  EQU   3 INPUT FROM DDNAME WITH DDNAME ADDR IN R3
ZCVT_ACCEPT_DATE    EQU   4 RETURN DAY OF WEEK PIC 9(8) MMDDYYYY
ZCVT_ACCEPT_TIME    EQU   5 RETURN DAY OF WEEK PIC 9(8) HHMMSSTH
ZCVT_ACCEPT_DOW     EQU   6 RETURN DAY OF WEEK PIC 9 1-7
ZCVT_DISPLAY   DC V(DISPLAY)       MODULE  R1=A(ADDR,LEN,TYPE)
ZCVT_INSPECT   DC V(INSPECT)       MODULE  R0=TYPE,R1=PARMLIST
ZCVT_TALLYING      EQU   0 INSPECT TALLYING
ZCVT_REPLACING     EQU   4 INSPECT REPLACING
ZCVT_CONVERTING    EQU   8 INSPECT CONVERTING
*
* SHARED DATA AREAS
*
ZCVT_PVTMAXDL  DS H          MAXIMUM DISPLAY LINE LENGTH  RPI 1118
               DS 0D
ZCVT_ZERO      DC XL16'00'   BINARY ZEROS
ZCVT_HIGH_VALUES DC 0XL16,16X'FF' BINARY FF'S     RPI 1181
ZCVT_PWORK     DS PL8        CVD/CVB WORK
ZCVT_PWORK1    DS PL16       DIV DIVIDEND, CVDG/CVBG WORK
ZCVT_PWORK2    DS PL16       DIV DIVISOR
ZCVT_PWORK3    DS PL16       DIV QUOTIENT
ZCVT_PWORK4    DS PL16       DIV REMAINDER
ZCVT_NDDX      DS XL16       DIV DIVIDEND HOLD AREA
ZCVT_WORKAREA  DS XL256      GEN_INSPECT PARMS, GEN_EDIT WORK, ETC.
*
* END OF ZC390CVT
*
ZCVT_END   EQU   *
ZC390PVT DSECT 
PVTPGM   DS    CL8  ZCOBOL PGM NAME
PVTDATE  DS    CL8  ZCOBOL COMPILE DATE
PVTTIME  DS    CL8  ZCOBOL COMPILE TIME
PVTVER   DS    CL8  ZCOBOL COMPILER VERSION
PVTCICS  DS    C    ZCOBOL EXEC CICS PGM
PVTEXTND DS    C    ZCOBOL EXTENDED PRECISION
PVTTRUNC DS    C    ZCOBOL TRUNCATE TO PICTURE
PVTR64   DS    C    ZCOBOL USE 64 BIT REGISTERS
PVTMAXDL DS    H    ZCOBOL MAX DISPLAY LINE LENGTH
         DS    XL10 RESERVED
ZC_WSLOC LOCTR              CONTINUE WS FOR FD AND DATA
*        AUTHOR.        DON HIGGINS.
*        DATE-WRITTEN.  01/08/09.
*      ***************************************************************
*      * TEST SET AND INDEXES
*      ***************************************************************
*      * 02/24/09 RPI 1002 TEST SET AND INDEX SUPPORT
*      ***************************************************************
*        ENVIRONMENT DIVISION.
*        DATA DIVISION.
         PRINT DATA
*        WORKING-STORAGE SECTION.
*        01  T0.
*            10  T1 OCCURS 2 TIMES.
*                15 T1-ID PIC X.
*                15 T2 OCCURS 3 TIMES.
*                   20 T2-ID PIC X.
*        77  S1 COMP PIC S9(9).
*        77  S2 COMP PIC S9(9).
*        77  NFS2 COMP   PIC S9(9)  OCCURS 2 TIMES.
*        77  NGS2 COMP   PIC S9(18) OCCURS 2 TIMES.
*        77  NHS2 COMP   PIC S9(4)  OCCURS 2 TIMES.
*        77  I    COMP   PIC S99    VALUE 1.
*        77  J    COMP   PIC S99    VALUE 2.
*        77  GOOD COMP-3 PIC S9(9) VALUE 0.
*        01  H1 PIC S9(4) COMP OCCURS 3 TIMES INDEXED BY H1X.
*            88 H1-ZERO VALUE 10.
*        77  H1X-SAVE  INDEX.
*        77  H1X-SAVE2 INDEX.
*        77  SUB PIC S9(9) COMP.
*        PROCEDURE DIVISION.
*ZC   PROCEDURE DIVISION
         PRINT LIST,GEN,LISTUSE TURN PRINT LISTING ON FOR USER CODE GEN
TESTSIX2 CSECT                SWITCH TO PROCEDURE CODE AHEAD OF WS
*        MAINLINE.
PG_MAINLINE DS 0H
*            DISPLAY 'TESTSIX2 STARTING'
*ZC     33         DISPLAY 'TESTSIX2 STARTING'
         BRAS  1,*+(WTO#0141_EOT-*+1)/2*2
         DC    AL2(WTO#0141_EOT-*,0),C'TESTSIX2 STARTING'
WTO#0141_EOT     EQU *
         SVC   35
*            MOVE '1ABC2DEF' TO T0
*ZC     34         MOVE  '1ABC2DEF',TO,T0
         LARL  ZC_R1,=CL8'1ABC2DEF'
          MVC   T0,0(ZC_R1)
*      1     IF T1-ID(1) = '1'   PERFORM GOOD ELSE PERFORM BAD.
*ZC     35      1  IF    T1_ID,'(',1,')',=,'1'
         CLI   T1_ID,C'1'
         BRC   15-ZC_EQ,PG_IF_1_1
*ZC     35      1  PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     35      1  ELSE
         J     PG_IF_1_E
PG_IF_1_1    DS    0H  &TYPE
*ZC     35      1  PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_1_E    DS    0H  &TYPE
*      2     IF T1-ID(2) = '2'   PERFORM GOOD ELSE PERFORM BAD.
*ZC     36      2  IF    T1_ID,'(',2,')',=,'2'
         IILF  ZC_R2,(2-1)*4 (LIT-1)*LEN
         LA    ZC_R2,T1_ID(ZC_R2)
         CLI   0(ZC_R2),C'2'
         BRC   15-ZC_EQ,PG_IF_2_1
*ZC     36      2  PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     36      2  ELSE
         J     PG_IF_2_E
PG_IF_2_1    DS    0H  &TYPE
*ZC     36      2  PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_2_E    DS    0H  &TYPE
*      3     IF T2-ID(1 1) = 'A' PERFORM GOOD ELSE PERFORM BAD.
*ZC     37      3  IF    T2_ID,'(',1,1,')',=,'A'
         LA    ZC_R2,T2_ID
         CLI   0(ZC_R2),C'A'
         BRC   15-ZC_EQ,PG_IF_3_1
*ZC     37      3  PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     37      3  ELSE
         J     PG_IF_3_E
PG_IF_3_1    DS    0H  &TYPE
*ZC     37      3  PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_3_E    DS    0H  &TYPE
*      4     IF T2-ID(2 1) = 'D' PERFORM GOOD ELSE PERFORM BAD.
*ZC     38      4  IF    T2_ID,'(',2,1,')',=,'D'
         LA    ZC_R2,T2_ID
         AFI   ZC_R2,(2-1)*4 (LIT-1)*LEN
         CLI   0(ZC_R2),C'D'
         BRC   15-ZC_EQ,PG_IF_4_1
*ZC     38      4  PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     38      4  ELSE
         J     PG_IF_4_E
PG_IF_4_1    DS    0H  &TYPE
*ZC     38      4  PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_4_E    DS    0H  &TYPE
*      5     IF T2-ID(1 3) = 'C' PERFORM GOOD ELSE PERFORM BAD.
*ZC     39      5  IF    T2_ID,'(',1,3,')',=,'C'
         LA    ZC_R2,T2_ID
         AFI   ZC_R2,(3-1)*1 (LIT-1)*LEN
         CLI   0(ZC_R2),C'C'
         BRC   15-ZC_EQ,PG_IF_5_1
*ZC     39      5  PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     39      5  ELSE
         J     PG_IF_5_E
PG_IF_5_1    DS    0H  &TYPE
*ZC     39      5  PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_5_E    DS    0H  &TYPE
*      6     IF T2-ID(2 3) = 'F' PERFORM GOOD ELSE PERFORM BAD.
*ZC     40      6  IF    T2_ID,'(',2,3,')',=,'F'
         LA    ZC_R2,T2_ID
         AFI   ZC_R2,(2-1)*4 (LIT-1)*LEN
         AFI   ZC_R2,(3-1)*1 (LIT-1)*LEN
         CLI   0(ZC_R2),C'F'
         BRC   15-ZC_EQ,PG_IF_6_1
*ZC     40      6  PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     40      6  ELSE
         J     PG_IF_6_E
PG_IF_6_1    DS    0H  &TYPE
*ZC     40      6  PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_6_E    DS    0H  &TYPE
*            MOVE 1 TO S1 MOVE 3 TO S2
*ZC     41         MOVE  1,TO,S1
          MVHI  S1,1
*ZC     41         MOVE  3,TO,S2
          MVHI  S2,3
*      7     IF T2-ID(S1 S2) = 'C' PERFORM GOOD ELSE PERFORM BAD.
*ZC     42      7  IF    T2_ID,'(',S1,S2,')',=,'C'
         LA    ZC_R2,T2_ID
         IILF  ZC_R15,S1-ZC_WS
         AR    ZC_R15,ZC_R13
         L     ZC_R15,0(ZC_R15)
         BCTR  ZC_R15,0
         MSFI  ZC_R15,4 L'&SYM_NAME(&SIX_OCCUR(&CUR_SIX)) RPI 1161 CORRX
               ECT CONTINUE RPI 1182
         AR    ZC_R2,ZC_R15                         RPI 1182
         IILF  ZC_R15,S2-ZC_WS
         AR    ZC_R15,ZC_R13
         L     ZC_R15,0(ZC_R15)
         BCTR  ZC_R15,0
         MSFI  ZC_R15,1 L'&SYM_NAME(&SIX_OCCUR(&CUR_SIX)) RPI 1161 CORRX
               ECT CONTINUE RPI 1182
         AR    ZC_R2,ZC_R15                         RPI 1182
         CLI   0(ZC_R2),C'C'
         BRC   15-ZC_EQ,PG_IF_7_1
*ZC     42      7  PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     42      7  ELSE
         J     PG_IF_7_E
PG_IF_7_1    DS    0H  &TYPE
*ZC     42      7  PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_7_E    DS    0H  &TYPE
*            PERFORM VARYING S1 FROM 1 BY 1 UNTIL S1 > 2
*ZC     43         PERFORM VARYING,S1,FROM,1,BY,1,UNTIL,S1,>,2
          MVHI  S1,1
         J     PG_PM_15_T
PG_PM_15_A   DS    0H  &TYPE
         ASI   S1,1
PG_PM_15_T   DS    0H  &TYPE
         L     0,S1
         CFI   0,2
         BRC   15-ZC_H,PG_IF_8_1
         J     PG_PM_15_E
PG_IF_8_1    DS    0H  &TYPE
*                PERFORM VARYING S2 FROM 1 BY 1 UNTIL S2 > 3
*ZC     44         PERFORM VARYING,S2,FROM,1,BY,1,UNTIL,S2,>,3
          MVHI  S2,1
         J     PG_PM_16_T
PG_PM_16_A   DS    0H  &TYPE
         ASI   S2,1
PG_PM_16_T   DS    0H  &TYPE
         L     0,S2
         CFI   0,3
         BRC   15-ZC_H,PG_IF_9_1
         J     PG_PM_16_E
PG_IF_9_1    DS    0H  &TYPE
*                   DISPLAY 'T2-ID(' S1 ',' S2 ')=' T2-ID(S1 S2).
*ZC     45         DISPLAY 'T2-ID(',S1,',',S2,')=',T2_ID,'(',S1,S2,')'
         LA    ZC_R3,ZCVT_WORKAREA  ZC_R3=CVT LIST WORK AREA
         LARL  ZC_R0,=CL6'T2-ID(' PAD TO EVEN LEN LIT
         LA    ZC_R1,6
         LA    ZC_R2,C'X'
         STM   ZC_R0,ZC_R2,0(ZC_R3)  SET DISPLAY LIST ENTRY
         LA    ZC_R0,S1
         LA    ZC_R1,4  RPI 1182 WAS &SYM_LEN(&FIELD_IX)
         LA    ZC_R2,C'F'
         STM   ZC_R0,ZC_R2,12(ZC_R3)  SET DISPLAY LIST ENTRY
         LARL  ZC_R0,=CL2',' PAD TO EVEN LEN LIT
         LA    ZC_R1,1
         LA    ZC_R2,C'X'
         STM   ZC_R0,ZC_R2,24(ZC_R3)  SET DISPLAY LIST ENTRY
         LA    ZC_R0,S2
         LA    ZC_R1,4  RPI 1182 WAS &SYM_LEN(&FIELD_IX)
         LA    ZC_R2,C'F'
         STM   ZC_R0,ZC_R2,36(ZC_R3)  SET DISPLAY LIST ENTRY
         LARL  ZC_R0,=CL2')=' PAD TO EVEN LEN LIT
         LA    ZC_R1,2
         LA    ZC_R2,C'X'
         STM   ZC_R0,ZC_R2,48(ZC_R3)  SET DISPLAY LIST ENTRY
         LA    ZC_R2,T2_ID
         IILF  ZC_R15,S1-ZC_WS
         AR    ZC_R15,ZC_R13
         L     ZC_R15,0(ZC_R15)
         BCTR  ZC_R15,0
         MSFI  ZC_R15,4 L'&SYM_NAME(&SIX_OCCUR(&CUR_SIX)) RPI 1161 CORRX
               ECT CONTINUE RPI 1182
         AR    ZC_R2,ZC_R15                         RPI 1182
         IILF  ZC_R15,S2-ZC_WS
         AR    ZC_R15,ZC_R13
         L     ZC_R15,0(ZC_R15)
         BCTR  ZC_R15,0
         MSFI  ZC_R15,1 L'&SYM_NAME(&SIX_OCCUR(&CUR_SIX)) RPI 1161 CORRX
               ECT CONTINUE RPI 1182
         AR    ZC_R2,ZC_R15                         RPI 1182
         LA    ZC_R0,0(ZC_R2)
         LA    ZC_R1,1  RPI 1182 WAS &SYM_LEN(&FIELD_IX)
         LA    ZC_R2,C'X'
         STM   ZC_R0,ZC_R2,60(ZC_R3)  SET DISPLAY LIST ENTRY
         OI    72-4(ZC_R3),X'80' SET VL BIT IN LAST WORD OF PARM LIST
         LR    ZC_R1,ZC_R3
         L     ZC_R15,ZCVT_DISPLAY
         BASR  ZC_R14,ZC_R15
         J     PG_PM_16_A
PG_PM_16_E   DS    0H  &TYPE
         J     PG_PM_15_A
PG_PM_15_E   DS    0H  &TYPE
*            MOVE 1 TO NFS2(I) NFS2(I+1)
*ZC     46         MOVE  1,TO,NFS2,'(',I,')',NFS2,'(',I,+,1,')'
         IILF  ZC_R15,I-ZC_WS
         AR    ZC_R15,ZC_R13
         LH    ZC_R15,0(ZC_R15)
         BCTR  ZC_R15,0
         MSFI  ZC_R15,4 L'&SYM_NAME(&SIX_OCCUR(&CUR_SIX)) RPI 1161 CORRX
               ECT CONTINUE RPI 1182
         LA    ZC_R3,NFS2(ZC_R15)
          MVHI  0(ZC_R3),1
         IILF  ZC_R15,I-ZC_WS
         AR    ZC_R15,ZC_R13
         LH    ZC_R15,0(ZC_R15)
         AHI   ZC_R15,+1-1
         MSFI  ZC_R15,4 L'&SYM_NAME(&SIX_OCCUR(&CUR_SIX)) RPI 1161 CORRX
               ECT CONTINUE RPI 1182
         LA    ZC_R3,NFS2(ZC_R15)
          MVHI  0(ZC_R3),1
*            ADD       NFS2(I) TO NFS2(I+1)
*ZC     47         ADD   NFS2,'(',I,')',TO,NFS2,'(',I,+,1,')'
         IILF  ZC_R15,I-ZC_WS
         AR    ZC_R15,ZC_R13
         LH    ZC_R15,0(ZC_R15)
         BCTR  ZC_R15,0
         MSFI  ZC_R15,4 L'&SYM_NAME(&SIX_OCCUR(&CUR_SIX)) RPI 1161 CORRX
               ECT CONTINUE RPI 1182
         LA    ZC_R1,NFS2(ZC_R15)
         IILF  ZC_R15,I-ZC_WS
         AR    ZC_R15,ZC_R13
         LH    ZC_R15,0(ZC_R15)
         AHI   ZC_R15,+1-1
         MSFI  ZC_R15,4 L'&SYM_NAME(&SIX_OCCUR(&CUR_SIX)) RPI 1161 CORRX
               ECT CONTINUE RPI 1182
         LA    ZC_R2,NFS2(ZC_R15)
         L     ZC_R0,0(ZC_R1)
         A     ZC_R0,0(ZC_R2)
         ST    ZC_R0,0(ZC_R2)
*      8     IF NFS2(I+1) = 2 PERFORM GOOD ELSE PERFORM BAD.
*ZC     48      8  IF    NFS2,'(',I,+,1,')',=,2
         IILF  ZC_R15,I-ZC_WS
         AR    ZC_R15,ZC_R13
         LH    ZC_R15,0(ZC_R15)
         AHI   ZC_R15,+1-1
         MSFI  ZC_R15,4 L'&SYM_NAME(&SIX_OCCUR(&CUR_SIX)) RPI 1161 CORRX
               ECT CONTINUE RPI 1182
         LA    ZC_R2,NFS2(ZC_R15)
         L     0,0(ZC_R2)
         CFI   0,2
         BRC   15-ZC_EQ,PG_IF_10_1
*ZC     48      8  PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     48      8  ELSE
         J     PG_IF_10_E
PG_IF_10_1   DS    0H  &TYPE
*ZC     48      8  PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_10_E   DS    0H  &TYPE
*            ADD  1 TO NFS2(I) NFS2(I+1)
*ZC     49         ADD   1,TO,NFS2,'(',I,')',NFS2,'(',I,+,1,')'
         IILF  ZC_R15,I-ZC_WS
         AR    ZC_R15,ZC_R13
         LH    ZC_R15,0(ZC_R15)
         BCTR  ZC_R15,0
         MSFI  ZC_R15,4 L'&SYM_NAME(&SIX_OCCUR(&CUR_SIX)) RPI 1161 CORRX
               ECT CONTINUE RPI 1182
         LA    ZC_R2,NFS2(ZC_R15)
         ASI   0(ZC_R2),1
         IILF  ZC_R15,I-ZC_WS
         AR    ZC_R15,ZC_R13
         LH    ZC_R15,0(ZC_R15)
         AHI   ZC_R15,+1-1
         MSFI  ZC_R15,4 L'&SYM_NAME(&SIX_OCCUR(&CUR_SIX)) RPI 1161 CORRX
               ECT CONTINUE RPI 1182
         LA    ZC_R2,NFS2(ZC_R15)
         ASI   0(ZC_R2),1
*      9     IF NFS2(I)   = 2 PERFORM GOOD ELSE PERFORM BAD.
*ZC     50      9  IF    NFS2,'(',I,')',=,2
         IILF  ZC_R15,I-ZC_WS
         AR    ZC_R15,ZC_R13
         LH    ZC_R15,0(ZC_R15)
         BCTR  ZC_R15,0
         MSFI  ZC_R15,4 L'&SYM_NAME(&SIX_OCCUR(&CUR_SIX)) RPI 1161 CORRX
               ECT CONTINUE RPI 1182
         LA    ZC_R2,NFS2(ZC_R15)
         L     0,0(ZC_R2)
         CFI   0,2
         BRC   15-ZC_EQ,PG_IF_11_1
*ZC     50      9  PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     50      9  ELSE
         J     PG_IF_11_E
PG_IF_11_1   DS    0H  &TYPE
*ZC     50      9  PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_11_E   DS    0H  &TYPE
*     10     IF NFS2(I+1) = 3 PERFORM GOOD ELSE PERFORM BAD.
*ZC     51     10  IF    NFS2,'(',I,+,1,')',=,3
         IILF  ZC_R15,I-ZC_WS
         AR    ZC_R15,ZC_R13
         LH    ZC_R15,0(ZC_R15)
         AHI   ZC_R15,+1-1
         MSFI  ZC_R15,4 L'&SYM_NAME(&SIX_OCCUR(&CUR_SIX)) RPI 1161 CORRX
               ECT CONTINUE RPI 1182
         LA    ZC_R2,NFS2(ZC_R15)
         L     0,0(ZC_R2)
         CFI   0,3
         BRC   15-ZC_EQ,PG_IF_12_1
*ZC     51     10  PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     51     10  ELSE
         J     PG_IF_12_E
PG_IF_12_1   DS    0H  &TYPE
*      * TEST SET 88 LEVEL
*ZC     51     10  PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_12_E   DS    0H  &TYPE
*     11     SET H1-ZERO(2) TO TRUE
*ZC     53     11  SET   H1_ZERO,'(',2,')',TO,TRUE
         IILF  ZC_R2,(2-1)*2 (LIT-1)*LEN
         LA    ZC_R2,H1(ZC_R2)
          MVHHI 0(ZC_R2),10
*            IF H1-ZERO(2)
*ZC     54         IF    H1_ZERO,'(',2,')'
         IILF  ZC_R2,(2-1)*2 (LIT-1)*LEN
         LA    ZC_R2,H1(ZC_R2)
         LH    0,0(ZC_R2)
         CHI   0,10
         BRC   15-ZC_EQ,PG_IF_13_1
*               PERFORM GOOD ELSE PERFORM BAD.
*ZC     55         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     55         ELSE
         J     PG_IF_13_E
PG_IF_13_1   DS    0H  &TYPE
*      * TEST SET INDEXE-MAME, INDEX DATA FEILD, INT FIELD
*ZC     55         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_13_E   DS    0H  &TYPE
*            SET H1X TO 2
*ZC     57         SET   H1X,TO,2
          LARL  ZC_R1,=A((2-1)*2)
          MVC   H1X,0(ZC_R1)
*            MOVE 10 TO H1(2)
*ZC     58         MOVE  10,TO,H1,'(',2,')'
         IILF  ZC_R3,(2-1)*2 (LIT-1)*LEN
         LA    ZC_R3,H1(ZC_R3)
          MVHHI 0(ZC_R3),10
*     12     IF H1(H1X) = 10
*ZC     59     12  IF    H1,'(',H1X,')',=,10
         IILF  ZC_R15,H1X-ZC_WS
         AR    ZC_R15,ZC_R13
         L     ZC_R15,0(ZC_R15) INDEX OFFSET
         LA    ZC_R2,H1(ZC_R15)
         LH    0,0(ZC_R2)
         CHI   0,10
         BRC   15-ZC_EQ,PG_IF_14_1
*               PERFORM GOOD ELSE PERFORM BAD.
*ZC     60         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     60         ELSE
         J     PG_IF_14_E
PG_IF_14_1   DS    0H  &TYPE
*ZC     60         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_14_E   DS    0H  &TYPE
*            SET H1X UP BY 1
*ZC     61         SET   H1X,UP,BY,1
         L     ZC_R0,H1X
         AFI   ZC_R0,1*2
         ST    ZC_R0,H1X
*            SET SUB TO H1X
*ZC     62         SET   SUB,TO,H1X
         SGR   ZC_R0,ZC_R0
         L     ZC_R1,H1X
         LARL  ZC_R14,=F'2'
         D     ZC_R0,0(ZC_R14)
         AHI   ZC_R1,1
         ST    ZC_R1,SUB
*     13     IF SUB = 3
*ZC     63     13  IF    SUB,=,3
         L     0,SUB
         CFI   0,3
         BRC   15-ZC_EQ,PG_IF_15_1
*               PERFORM GOOD ELSE PERFORM BAD.
*ZC     64         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     64         ELSE
         J     PG_IF_15_E
PG_IF_15_1   DS    0H  &TYPE
*ZC     64         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_15_E   DS    0H  &TYPE
*            SET H1X-SAVE TO H1X
*ZC     65         SET   H1X_SAVE,TO,H1X
         MVC   H1X_SAVE,H1X  ALIGN LEFT X OTHER
*     14     IF H1X-SAVE = H1X
*ZC     66     14  IF    H1X_SAVE,=,H1X
         L     ZC_R0,H1X_SAVE
         L     ZC_R1,H1X
         CR    ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_16_1
*               PERFORM GOOD ELSE PERFORM BAD.
*ZC     67         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     67         ELSE
         J     PG_IF_16_E
PG_IF_16_1   DS    0H  &TYPE
*ZC     67         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_16_E   DS    0H  &TYPE
*            SET H1X-SAVE2 TO H1X-SAVE
*ZC     68         SET   H1X_SAVE2,TO,H1X_SAVE
         MVC   H1X_SAVE2,H1X_SAVE  ALIGN LEFT X OTHER
*     15     IF H1X-SAVE = H1X
*ZC     69     15  IF    H1X_SAVE,=,H1X
         L     ZC_R0,H1X_SAVE
         L     ZC_R1,H1X
         CR    ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_17_1
*               PERFORM GOOD ELSE PERFORM BAD.
*ZC     70         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     70         ELSE
         J     PG_IF_17_E
PG_IF_17_1   DS    0H  &TYPE
*ZC     70         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_17_E   DS    0H  &TYPE
*            MOVE 11 TO H1(3)
*ZC     71         MOVE  11,TO,H1,'(',3,')'
         IILF  ZC_R3,(3-1)*2 (LIT-1)*LEN
         LA    ZC_R3,H1(ZC_R3)
          MVHHI 0(ZC_R3),11
*     16     IF H1(H1X) = 11
*ZC     72     16  IF    H1,'(',H1X,')',=,11
         IILF  ZC_R15,H1X-ZC_WS
         AR    ZC_R15,ZC_R13
         L     ZC_R15,0(ZC_R15) INDEX OFFSET
         LA    ZC_R2,H1(ZC_R15)
         LH    0,0(ZC_R2)
         CHI   0,11
         BRC   15-ZC_EQ,PG_IF_18_1
*               PERFORM GOOD ELSE PERFORM BAD.
*ZC     73         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     73         ELSE
         J     PG_IF_18_E
PG_IF_18_1   DS    0H  &TYPE
*ZC     73         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_18_E   DS    0H  &TYPE
*            SET H1X DOWN BY 1
*ZC     74         SET   H1X,DOWN,BY,1
         L     ZC_R0,H1X
         AFI   ZC_R0,-1*2
         ST    ZC_R0,H1X
*            MOVE 12 TO H1(H1X)
*ZC     75         MOVE  12,TO,H1,'(',H1X,')'
         IILF  ZC_R15,H1X-ZC_WS
         AR    ZC_R15,ZC_R13
         L     ZC_R15,0(ZC_R15) INDEX OFFSET
         LA    ZC_R3,H1(ZC_R15)
          MVHHI 0(ZC_R3),12
*     17     IF H1(2) = 12
*ZC     76     17  IF    H1,'(',2,')',=,12
         IILF  ZC_R2,(2-1)*2 (LIT-1)*LEN
         LA    ZC_R2,H1(ZC_R2)
         LH    0,0(ZC_R2)
         CHI   0,12
         BRC   15-ZC_EQ,PG_IF_19_1
*               PERFORM GOOD ELSE PERFORM BAD.
*ZC     77         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     77         ELSE
         J     PG_IF_19_E
PG_IF_19_1   DS    0H  &TYPE
*ZC     77         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_19_E   DS    0H  &TYPE
*            SET H1X TO H1X-SAVE
*ZC     78         SET   H1X,TO,H1X_SAVE
         MVC   H1X,H1X_SAVE  ALIGN LEFT X OTHER
*            MOVE 11 TO H1(3)
*ZC     79         MOVE  11,TO,H1,'(',3,')'
         IILF  ZC_R3,(3-1)*2 (LIT-1)*LEN
         LA    ZC_R3,H1(ZC_R3)
          MVHHI 0(ZC_R3),11
*     18     IF H1(H1X) = 11
*ZC     80     18  IF    H1,'(',H1X,')',=,11
         IILF  ZC_R15,H1X-ZC_WS
         AR    ZC_R15,ZC_R13
         L     ZC_R15,0(ZC_R15) INDEX OFFSET
         LA    ZC_R2,H1(ZC_R15)
         LH    0,0(ZC_R2)
         CHI   0,11
         BRC   15-ZC_EQ,PG_IF_20_1
*               PERFORM GOOD ELSE PERFORM BAD.
*ZC     81         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     81         ELSE
         J     PG_IF_20_E
PG_IF_20_1   DS    0H  &TYPE
*ZC     81         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_20_E   DS    0H  &TYPE
*            DISPLAY 'TESTSIX2 GOOD TESTS =' GOOD
*ZC     82         DISPLAY 'TESTSIX2 GOOD TESTS =',GOOD
         LA    ZC_R3,ZCVT_WORKAREA  ZC_R3=CVT LIST WORK AREA
         LARL  ZC_R0,=CL22'TESTSIX2 GOOD TESTS =' PAD TO EVEN LEN LIT
         LA    ZC_R1,21
         LA    ZC_R2,C'X'
         STM   ZC_R0,ZC_R2,0(ZC_R3)  SET DISPLAY LIST ENTRY
         LA    ZC_R0,GOOD
         LA    ZC_R1,5  RPI 1182 WAS &SYM_LEN(&FIELD_IX)
         LA    ZC_R2,C'P'
         STM   ZC_R0,ZC_R2,12(ZC_R3)  SET DISPLAY LIST ENTRY
         OI    24-4(ZC_R3),X'80' SET VL BIT IN LAST WORD OF PARM LIST
         LR    ZC_R1,ZC_R3
         L     ZC_R15,ZCVT_DISPLAY
         BASR  ZC_R14,ZC_R15
*            STOP RUN.
*ZC     83         STOP  RUN
         LH    ZC_R1,RETURN_CODE      PASS RETURN CODE IN R1
         L     ZC_R15,ZCVT_GOBACK
         BR    ZC_R15
*        GOOD.
PG_MAINLINE_END L ZC_R15,ZCVT_PMCHECK
         BASR  ZC_R14,ZC_R15 CHECK FOR END OF CURRENT PERFORM
PG_GOOD  DS    0H
*            ADD 1 TO GOOD.
*ZC     85         ADD   1,TO,GOOD
         BRAS  ZC_R14,3 SET ZC_R1 TO A(INLINE LIT) AND SKIP OVER IT
         DC    PL2'1'
         AP    GOOD,0(2,ZC_R14)
*        BAD.
PG_GOOD_END L  ZC_R15,ZCVT_PMCHECK
         BASR  ZC_R14,ZC_R15 CHECK FOR END OF CURRENT PERFORM
PG_BAD   DS    0H
*            MOVE 16 TO RETURN-CODE
*ZC     87         MOVE  16,TO,RETURN_CODE
          MVHHI RETURN_CODE,16
*            STOP RUN.
*ZC     88         STOP  RUN
         LH    ZC_R1,RETURN_CODE      PASS RETURN CODE IN R1
         L     ZC_R15,ZCVT_GOBACK
         BR    ZC_R15
PG_BAD_END L   ZC_R15,ZCVT_PMCHECK
         BASR  ZC_R14,ZC_R15 CHECK FOR END OF CURRENT PERFORM
SN_END_PROCEDURE DS 0H SECTION
*        PROCEDURE END
         LH    ZC_R1,RETURN_CODE
         L     ZC_R15,ZCVT_GOBACK
         BASR  ZC_R14,ZC_R15
         LTORG 
*    ZCOBOL WORKING STORAGE SECTION DATA ITEMS 
*    LVL DATA NAME                      ADDR     LEN      DUP TYP PIC  X
                     VALUE 
*    01  ZC_SAVEAREA                    00000000 00000048 1   X   X(72)X
                      
*    01  ZC_WS_ID                       00000048 00000008 1   X   X(8) X
                     ''WS*WS*WS'' 
*    01  ZC_WS_START                    00000050 00000004 1   A        X
                      
*    01  ZC_WS_LEN                      00000054 00000004 1   F   9(9) X
                      
*    01  FILLER                         00000058 00000008 1   X        X
                      
*    01  T0                             00000058 00000008 1   X        X
                      
*    10  T1                             00000058 00000004 2   X        X
                      
*    15  T1_ID                          00000058 00000001 1   X   X    X
                      
*    15  T2                             00000059 00000001 3   X        X
                      
*    20  T2_ID                          00000059 00000001 1   X   X    X
                      
*    01  S1                             00000060 00000004 1   F   9(9) X
                      
*    01  S2                             00000064 00000004 1   F   9(9) X
                      
*    01  NFS2                           00000068 00000004 2   F   9(9) X
                      
*    01  NGS2                           00000070 00000008 2   G   9(18)X
                      
*    01  NHS2                           00000080 00000002 2   H   9(4) X
                      
*    01  I                              00000084 00000002 1   H   99   X
                     1 
*    01  J                              00000086 00000002 1   H   99   X
                     2 
*    01  GOOD                           00000088 00000005 1   P   9(9) X
                     0 
*    01  H1                             0000008D 00000002 3   H   9(4) X
                      
*    88  H1_ZERO                        00000001 00000000 0            X
                     
*    01  H1X_SAVE                       00000093 00000004 1   I        X
                      
*    01  H1X_SAVE2                      00000097 00000004 1   I        X
                      
*    01  SUB                            0000009B 00000004 1   F   9(9) X
                      
*    01  H1X                            0000009F 00000004 1   I        X
                      
*    01  DEBUG_ITEM                     000000A3 00000058 1   X        X
                      
*    02  DEBUG_LINE                     000000A3 00000006 1   X   X(6) X
                      
*    02  FILLER                         000000A9 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_NAME                     000000AA 0000001E 1   X   X(30)X
                      
*    02  FILLER                         000000C8 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_1                    000000C9 00000004 1   Z   9999 X
                      
*    02  FILLER                         000000CD 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_2                    000000CE 00000004 1   Z   9999 X
                      
*    02  FILLER                         000000D2 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_3                    000000D3 00000004 1   Z   9999 X
                      
*    02  FILLER                         000000D7 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_CONTENTS                 000000D8 00000023 1   X   X(35)X
                      
*    01  TRUE                           000000FB 00000001 1   Z   9    X
                     1 
*    01  FALSE                          000000FC 00000001 1   Z   9    X
                     0 
*    01  RETURN_CODE                    000000FD 00000002 1   H   9(4) X
                     0 
ZC_WSLOC LOCTR 
ZC_WS_LOC_1  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ZC_SAVEAREA DS CL72
ZC_WS_LOC_2  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ZC_WS_ID DC CL8'WS*WS*WS'
ZC_WS_LOC_3  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ZC_WS_START DS AL4
ZC_WS_LOC_4  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ZC_WS_LEN DS FL4
ZC_WS_LOC_5  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DS  0CL8
ZC_WS_LOC_6  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
T0       DS  0CL8
ZC_WS_LOC_7  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
T1       DS  0CL4
ZC_WS_LOC_8  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
T1_ID    DS  CL1
ZC_WS_LOC_9  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
T2       DS  0CL1
ZC_WS_LOC_10 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
T2_ID    DS  CL1
         DS    XL2 PAD FOR MULT OCCURS
         DS    XL4 PAD FOR MULT OCCURS
ZC_WS_LOC_11 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
S1       DS  FL4
ZC_WS_LOC_12 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
S2       DS  FL4
ZC_WS_LOC_13 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
NFS2     DS  2FL4
ZC_WS_LOC_14 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
NGS2     DS  2FL8
ZC_WS_LOC_15 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
NHS2     DS  2HL2
ZC_WS_LOC_16 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
I        DC AL2(1)                  RPI 1065
ZC_WS_LOC_17 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
J        DC AL2(2)                  RPI 1065
ZC_WS_LOC_18 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
GOOD     DC PL5'0'
ZC_WS_LOC_19 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
H1       DS  3HL2
ZC_WS_LOC_21 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
H1X_SAVE DS FL4
ZC_WS_LOC_22 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
H1X_SAVE2 DS FL4
ZC_WS_LOC_23 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
SUB      DS  FL4
ZC_WS_LOC_24 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
H1X      DS FL4
ZC_WS_LOC_25 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_ITEM DS 0CL88
ZC_WS_LOC_26 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_LINE DS CL6
ZC_WS_LOC_27 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_28 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_NAME DS CL30
ZC_WS_LOC_29 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_30 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_1 DS ZL4
ZC_WS_LOC_31 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_32 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_2 DS ZL4
ZC_WS_LOC_33 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_34 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_3 DS ZL4
ZC_WS_LOC_35 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_36 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_CONTENTS DS CL35
ZC_WS_LOC_37 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
TRUE     DC CL1'1'
ZC_WS_LOC_38 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
FALSE    DC CL1'0'
ZC_WS_LOC_39 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
RETURN_CODE DC AL2(0)                  RPI 1065
*    ZCOBOL LINKAGE SECTION DATA ITEMS 
*    LVL DATA NAME                      ADDR     LEN      DUP TYP PIC  X
                     VALUE 
ZC_WSLOC LOCTR 
ZC_WSLOC LOCTR 
ZC_WS_DIFF EQU  *-ZC_WS-255  DIFF BETWEEN ALLOC AND CALC WS
ZC_WS_END DS   0D
         MNOTE *,'ZCOBOL TOTAL SYMBOLS                 = 39'
         MNOTE *,'ZCOBOL TOTAL SYMBOL DUPLICATES       = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL MAX DUP CHAIN    = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL LEVEL 88         = 1'
         MNOTE *,'ZCOBOL TOTAL SYMBOL SET INDEXES      = 1'
         MNOTE *,'ZCOBOL TOTAL SYMBOL LINKAGE SECTIONS = 0'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE SECTIONS      = 0'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE PARAGRAPHS    = 3'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE PARAGRAPH DUP = 0'
         END 
