*    ZCOBOL PGM='zcobol\test\TESTDIV1' VER=V1.5.06 MM/DD/YY  
*    ZCOBOL OPTIONS=(FLOAT(DECIMAL)) 
         COPY  TESTDIV1_ZC_LABELS.CPY
*        IDENTIFICATION DIVISION.
*        PROGRAM-ID.    TESTDIV1.
         PRINT NOLIST,NOGEN,NOLISTUSE    SET LIST OPTION FOR INTERNAL CX
               ODE
TESTDIV1 CSECT ,                CSECT WITH PROCEDURE CODE AND WS
         USING *,ZC_R15
         STM   14,12,12+4*(14-14)(13)
         CNOP  4,8             FORCE ZC390PVT TO DOUBLEWORD BOUNDARY
         BRAS  ZC_R8,ZC_LOAD
         USING *,ZC_R8            BASE FOR LOAD AND CICS V5 USE
*
*  THESE FIELDS MUST BE KEPT IN SYNC WITH zcobol\ZC390PVT.CPY
*
         DC    CL8'TESTDIV1'    PVTPGM   ZCOBOL PGM NAME
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
         BRAS  1,*+(WTO#0017_EOT-*+1)/2*2
         DC    AL2(WTO#0017_EOT-*,0),C'ZC390LIB NOT FOUND'
WTO#0017_EOT     EQU *
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
         BRAS  1,*+(WTO#0018_EOT-*+1)/2*2
         DC    AL2(WTO#0018_EOT-*,0),C'ZC390LIB ZCVT VERIFY ERROR'
WTO#0018_EOT     EQU *
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
*        DATE-WRITTEN.  04/25/12.
*      * TEST DIVIDE WITH SCALING FOR IMPLIED DECIMAL                  
*        ENVIRONMENT DIVISION.
*        DATA DIVISION.
         PRINT DATA
*        WORKING-STORAGE SECTION.
*        77 EH1 FLOAT-HEX-7       VALUE 6.0.
*        77 DH1 FLOAT-HEX-15      VALUE 6.0.
*        77 LH1 FLOAT-HEX-30      VALUE 6.0.
*        77 EB1 FLOAT-BINARY-7    VALUE 6.0.
*        77 DB1 FLOAT-BINARY-16   VALUE 6.0.
*        77 LB1 FLOAT-BINARY-34   VALUE 6.0.
*        77 ED1 FLOAT-DECIMAL-7   VALUE 6.0.
*        77 DD1 FLOAT-DECIMAL-16  VALUE 6.0.
*        77 LD1 FLOAT-DECIMAL-34  VALUE 6.0.
*        77 H1      COMP PIC S9(3)V9    VALUE 6.0.
*        77 F1      COMP PIC S9(8)V9    VALUE 6.0.
*        77 G1      COMP PIC S9(17)V9   VALUE 6.0.
*        77 Q1      COMP PIC S9(38)V9   VALUE 6.0.
*        77 P1      COMP-3 PIC S9(30)V9 VALUE 6.0.
*        77 Z1             PIC S9(30)V9 VALUE 6.0.
*        77 EH2 FLOAT-HEX-7       VALUE 2.00.
*        77 DH2 FLOAT-HEX-15      VALUE 2.00.
*        77 LH2 FLOAT-HEX-30      VALUE 2.00.
*        77 EB2 FLOAT-BINARY-7    VALUE 2.00.
*        77 DB2 FLOAT-BINARY-16   VALUE 2.00.
*        77 LB2 FLOAT-BINARY-34   VALUE 2.00.
*        77 ED2 FLOAT-DECIMAL-7   VALUE 2.00.
*        77 DD2 FLOAT-DECIMAL-16  VALUE 2.00.
*        77 LD2 FLOAT-DECIMAL-34  VALUE 2.00.
*        77 H2      COMP PIC S9(2)V99         VALUE 2.00.
*        77 F2      COMP PIC S9(6)V999        VALUE 2.00.
*        77 G2      COMP PIC S9(14)V9999      VALUE 2.00.
*        77 Q2      COMP PIC S9(34)V99999     VALUE 2.00.
*        77 P2      COMP-3 PIC S9(25)V999999  VALUE 2.00.
*        77 Z2             PIC S9(24)V9999999 VALUE 2.00.
*        77 EH3 FLOAT-HEX-7       VALUE 3.00.
*        77 DH3 FLOAT-HEX-15      VALUE 3.00.
*        77 LH3 FLOAT-HEX-30      VALUE 3.00.
*        77 EB3 FLOAT-BINARY-7    VALUE 3.00.
*        77 DB3 FLOAT-BINARY-16   VALUE 3.00.
*        77 LB3 FLOAT-BINARY-34   VALUE 3.00.
*        77 ED3 FLOAT-DECIMAL-7   VALUE 3.00.
*        77 DD3 FLOAT-DECIMAL-16  VALUE 3.00.
*        77 LD3 FLOAT-DECIMAL-34  VALUE 3.00.
*        77 H3      COMP PIC S9(2)V99         VALUE 3.00.
*        77 F3      COMP PIC S9(6)V999        VALUE 3.00.
*        77 G3      COMP PIC S9(14)V9999      VALUE 3.00.
*        77 Q3      COMP PIC S9(34)V99999     VALUE 3.00.
*        77 P3      COMP-3 PIC S9(25)V999999  VALUE 3.00.
*        77 Z3             PIC S9(24)V9999999 VALUE 3.00.
*        77 G    COMP-3 PIC 9(4)   VALUE 0.
*        77 B     COMP-3 PIC 9(4)   VALUE 0.
*        PROCEDURE DIVISION.
*ZC   PROCEDURE DIVISION
         PRINT LIST,GEN,LISTUSE TURN PRINT LISTING ON FOR USER CODE GEN
TESTDIV1 CSECT                SWITCH TO PROCEDURE CODE AHEAD OF WS
*        MAINLINE.
PG_MAINLINE DS 0H
*            DISPLAY 'TESTDIV1 TEST SCALED DIVIDE'
*ZC     58         DISPLAY 'TESTDIV1 TEST SCALED DIVIDE'
         BRAS  1,*+(WTO#0224_EOT-*+1)/2*2
         DC    AL2(WTO#0224_EOT-*,0),C'TESTDIV1 TEST SCALED DIVIDE'
WTO#0224_EOT     EQU *
         SVC   35
*            DIVIDE EH2 INTO EH1 IF EH3 = EH1 PERFORM G ELSE PERFORM B.
*ZC     59         DIVIDE EH2,INTO,EH1
         LE    ZC_F0,EH2
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         DER   0,1
         STE   ZC_F0,EH1
*ZC     59         IF    EH3,=,EH1
         LE    ZC_F0,EH3
         CE    ZC_F0,EH1
         BRC   15-ZC_EQ,PG_IF_1_1
*ZC     59         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     59         ELSE
         J     PG_IF_1_E
PG_IF_1_1    DS    0H  &TYPE
*ZC     59         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_1_E    DS    0H  &TYPE
*            DIVIDE EH2 INTO DH1 IF EH3 = DH1 PERFORM G ELSE PERFORM B.
*ZC     60         DIVIDE EH2,INTO,DH1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DH1
         DDR   0,1
         STD   ZC_F0,DH1
*ZC     60         IF    EH3,=,DH1
         LDE   ZC_F0,EH3
         CD    ZC_F0,DH1
         BRC   15-ZC_EQ,PG_IF_2_1
*ZC     60         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     60         ELSE
         J     PG_IF_2_E
PG_IF_2_1    DS    0H  &TYPE
*ZC     60         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_2_E    DS    0H  &TYPE
*            DIVIDE EH2 INTO LH1 IF EH3 = LH1 PERFORM G ELSE PERFORM B.
*ZC     61         DIVIDE EH2,INTO,LH1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LH1
         LD    ZC_F2,8+LH1
         DXR   ZC_F0,ZC_F1
         STD   ZC_F0,LH1
         STD   ZC_F2,8+LH1
*ZC     61         IF    EH3,=,LH1
         LE    ZC_F0,EH3
         LXER  ZC_F0,ZC_F0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_3_1
*ZC     61         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     61         ELSE
         J     PG_IF_3_E
PG_IF_3_1    DS    0H  &TYPE
*ZC     61         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_3_E    DS    0H  &TYPE
*            DIVIDE EH2 INTO EB1 IF EH3 = EB1 PERFORM G ELSE PERFORM B.
*ZC     62         DIVIDE EH2,INTO,EB1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB1
         DEBR  0,1
         STE   ZC_F0,EB1
*ZC     62         IF    EH3,=,EB1
         LE    ZC_F4,EH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CEB   ZC_F0,EB1
         BRC   15-ZC_EQ,PG_IF_4_1
*ZC     62         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     62         ELSE
         J     PG_IF_4_E
PG_IF_4_1    DS    0H  &TYPE
*ZC     62         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_4_E    DS    0H  &TYPE
*            DIVIDE EH2 INTO DB1 IF EH3 = DB1 PERFORM G ELSE PERFORM B.
*ZC     63         DIVIDE EH2,INTO,DB1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB1
         DDBR  0,1
         STD   ZC_F0,DB1
*ZC     63         IF    EH3,=,DB1
         LE    ZC_F4,EH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CDB   ZC_F0,DB1
         BRC   15-ZC_EQ,PG_IF_5_1
*ZC     63         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     63         ELSE
         J     PG_IF_5_E
PG_IF_5_1    DS    0H  &TYPE
*ZC     63         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_5_E    DS    0H  &TYPE
*            DIVIDE EH2 INTO LB1 IF EH3 = LB1 PERFORM G ELSE PERFORM B.
*ZC     64         DIVIDE EH2,INTO,LB1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB1
         LD    ZC_F2,8+LB1
         DXBR  ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LDR   ZC_F0,ZC_F4
         LDR   ZC_F2,ZC_F6
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC     64         IF    EH3,=,LB1
         LE    ZC_F4,EH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_6_1
*ZC     64         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     64         ELSE
         J     PG_IF_6_E
PG_IF_6_1    DS    0H  &TYPE
*ZC     64         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_6_E    DS    0H  &TYPE
*            DIVIDE EH2 INTO ED1 IF EH3 = ED1 PERFORM G ELSE PERFORM B.
*ZC     65         DIVIDE EH2,INTO,ED1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED1
         LDETR ZC_F0,ZC_F0,0
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_ED,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         STE   ZC_F0,ED1
*ZC     65         IF    EH3,=,ED1
         LE    ZC_F4,EH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_7_1
*ZC     65         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     65         ELSE
         J     PG_IF_7_E
PG_IF_7_1    DS    0H  &TYPE
*ZC     65         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_7_E    DS    0H  &TYPE
*            DIVIDE EH2 INTO DD1 IF EH3 = DD1 PERFORM G ELSE PERFORM B.
*ZC     66         DIVIDE EH2,INTO,DD1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD1
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F0,ZC_F4
         STD   ZC_F0,DD1
*ZC     66         IF    EH3,=,DD1
         LE    ZC_F4,EH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_8_1
*ZC     66         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     66         ELSE
         J     PG_IF_8_E
PG_IF_8_1    DS    0H  &TYPE
*ZC     66         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_8_E    DS    0H  &TYPE
*            DIVIDE EH2 INTO LD1 IF EH3 = LD1 PERFORM G ELSE PERFORM B.
*ZC     67         DIVIDE EH2,INTO,LD1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD1
         LD    ZC_F2,8+LD1
         DXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,LD1
         STD   ZC_F2,8+LD1
*ZC     67         IF    EH3,=,LD1
         LE    ZC_F4,EH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_9_1
*ZC     67         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     67         ELSE
         J     PG_IF_9_E
PG_IF_9_1    DS    0H  &TYPE
*ZC     67         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_9_E    DS    0H  &TYPE
*            DIVIDE EH2 INTO F1  IF EH3 = F1  PERFORM G ELSE PERFORM B.
*ZC     68         DIVIDE EH2,INTO,F1
         MVC   ZCVT_NDDX(4),F1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R1 IGNORE HIGH 96 BITS
         LGF   ZC_R1,ZCVT_NDDX
         DSGR    0,2
         ST    1,F1
*ZC     68         IF    EH3,=,F1
         LE    ZC_F0,EH3
         L     ZC_R1,F1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_10_1
*ZC     68         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     68         ELSE
         J     PG_IF_10_E
PG_IF_10_1   DS    0H  &TYPE
*ZC     68         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_10_E   DS    0H  &TYPE
*            DIVIDE EH2 INTO G1  IF EH3 = G1  PERFORM G ELSE PERFORM B.
*ZC     69         DIVIDE EH2,INTO,G1
         MVC   ZCVT_NDDX(8),G1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
                 LGR ZC_R2,ZC_R1 IGNORE HIGH 64 BITS
         LG    1,ZCVT_NDDX
         DSGR    0,2
         STG   1,G1
*ZC     69         IF    EH3,=,G1
         LE    ZC_F0,EH3
         LG    ZC_R1,G1
         CEGR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_11_1
*ZC     69         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     69         ELSE
         J     PG_IF_11_E
PG_IF_11_1   DS    0H  &TYPE
*ZC     69         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_11_E   DS    0H  &TYPE
*            DIVIDE EH2 INTO H1  IF EH3 = H1  PERFORM G ELSE PERFORM B.
*ZC     70         DIVIDE EH2,INTO,H1
         MVC   ZCVT_NDDX(2),H1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R1 IGNORE HIGH 96
         LGH   ZC_R1,ZCVT_NDDX
         DSGR    0,2
         STH   1,H1
*ZC     70         IF    EH3,=,H1
         LE    ZC_F0,EH3
         LH    ZC_R1,H1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_12_1
*ZC     70         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     70         ELSE
         J     PG_IF_12_E
PG_IF_12_1   DS    0H  &TYPE
*ZC     70         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_12_E   DS    0H  &TYPE
*            DIVIDE EH2 INTO P1  IF EH3 = P1  PERFORM G ELSE PERFORM B.
*ZC     71         DIVIDE EH2,INTO,P1
         ZAP ZCVT_PWORK1(16),P1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG    ZC_R0,ZC_R2,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         ZAP   P1,ZCVT_PWORK4(16)
*ZC     71         IF    EH3,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH3
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_13_1
*ZC     71         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     71         ELSE
         J     PG_IF_13_E
PG_IF_13_1   DS    0H  &TYPE
*ZC     71         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_13_E   DS    0H  &TYPE
*            DIVIDE EH2 INTO Q1  IF EH3 = Q1  PERFORM G ELSE PERFORM B.
*ZC     72         DIVIDE EH2,INTO,Q1
         MVC   ZCVT_NDDX,Q1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R0
         LGR   ZC_R3,ZC_R1
         LMG   ZC_R0,ZC_R1,ZCVT_NDDX
         L     ZC_R15,ZCVT_DIVQ128 DIVIDE SCALED DIVIDEND BY QUOTIENT
         BASR  ZC_R14,ZC_R15
         LTGR  ZC_R0,ZC_R0
         JNM   ZC_LPQR_1
         XG    ZC_R0,ZCVT_HIGH_VALUES
         XG    ZC_R0+1,ZCVT_HIGH_VALUES
         ALGFI ZC_R0+1,1
         ALCG  ZC_R0,ZCVT_ZERO
ZC_LPQR_1            DS 0H
         STMG  ZC_R2,ZC_R3,Q1
*ZC     72         IF    EH3,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH3
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_14_1
*ZC     72         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     72         ELSE
         J     PG_IF_14_E
PG_IF_14_1   DS    0H  &TYPE
*ZC     72         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_14_E   DS    0H  &TYPE
*            DIVIDE EH2 INTO Z1  IF EH3 = Z1  PERFORM G ELSE PERFORM B.
*ZC     73         DIVIDE EH2,INTO,Z1
         PACK  ZCVT_PWORK1(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z1(3)  PACK #3 FINAL
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG    ZC_R0,ZC_R2,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         UNPK  0+Z1(15),0+ZCVT_PWORK4(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK4(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK4(2) UNPK #3 FINAL
*ZC     73         IF    EH3,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH3
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_15_1
*ZC     73         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     73         ELSE
         J     PG_IF_15_E
PG_IF_15_1   DS    0H  &TYPE
*ZC     73         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_15_E   DS    0H  &TYPE
*            PERFORM INIT.
*ZC     74         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            DIVIDE DH2 INTO EH1 IF DH3 = EH1 PERFORM G ELSE PERFORM B.
*ZC     75         DIVIDE DH2,INTO,EH1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         DER   0,1
         STE   ZC_F0,EH1
*ZC     75         IF    DH3,=,EH1
         LD    ZC_F0,DH3
         LDE   ZC_F1,EH1
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_16_1
*ZC     75         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     75         ELSE
         J     PG_IF_16_E
PG_IF_16_1   DS    0H  &TYPE
*ZC     75         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_16_E   DS    0H  &TYPE
*            DIVIDE DH2 INTO DH1 IF DH3 = DH1 PERFORM G ELSE PERFORM B.
*ZC     76         DIVIDE DH2,INTO,DH1
         LD    ZC_F0,DH2
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DH1
         DDR   0,1
         STD   ZC_F0,DH1
*ZC     76         IF    DH3,=,DH1
         LD    ZC_F0,DH3
         CD    ZC_F0,DH1
         BRC   15-ZC_EQ,PG_IF_17_1
*ZC     76         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     76         ELSE
         J     PG_IF_17_E
PG_IF_17_1   DS    0H  &TYPE
*ZC     76         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_17_E   DS    0H  &TYPE
*            DIVIDE DH2 INTO LH1 IF DH3 = LH1 PERFORM G ELSE PERFORM B.
*ZC     77         DIVIDE DH2,INTO,LH1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LH1
         LD    ZC_F2,8+LH1
         DXR   ZC_F0,ZC_F1
         STD   ZC_F0,LH1
         STD   ZC_F2,8+LH1
*ZC     77         IF    DH3,=,LH1
         LD    ZC_F0,DH3
         LXDR  ZC_F0,ZC_F0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_18_1
*ZC     77         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     77         ELSE
         J     PG_IF_18_E
PG_IF_18_1   DS    0H  &TYPE
*ZC     77         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_18_E   DS    0H  &TYPE
*            DIVIDE DH2 INTO EB1 IF DH3 = EB1 PERFORM G ELSE PERFORM B.
*ZC     78         DIVIDE DH2,INTO,EB1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB1
         DEBR  0,1
         STE   ZC_F0,EB1
*ZC     78         IF    DH3,=,EB1
         LE    ZC_F4,EB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DH3
         CDR   ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_19_1
*ZC     78         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     78         ELSE
         J     PG_IF_19_E
PG_IF_19_1   DS    0H  &TYPE
*ZC     78         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_19_E   DS    0H  &TYPE
*            DIVIDE DH2 INTO DB1 IF DH3 = DB1 PERFORM G ELSE PERFORM B.
*ZC     79         DIVIDE DH2,INTO,DB1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB1
         DDBR  0,1
         STD   ZC_F0,DB1
*ZC     79         IF    DH3,=,DB1
         LD    ZC_F4,DH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         CDB   ZC_F0,DB1
         BRC   15-ZC_EQ,PG_IF_20_1
*ZC     79         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     79         ELSE
         J     PG_IF_20_E
PG_IF_20_1   DS    0H  &TYPE
*ZC     79         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_20_E   DS    0H  &TYPE
*            DIVIDE DH2 INTO LB1 IF DH3 = LB1 PERFORM G ELSE PERFORM B.
*ZC     80         DIVIDE DH2,INTO,LB1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB1
         LD    ZC_F2,8+LB1
         DXBR  ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LDR   ZC_F0,ZC_F4
         LDR   ZC_F2,ZC_F6
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC     80         IF    DH3,=,LB1
         LD    ZC_F4,DH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_21_1
*ZC     80         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     80         ELSE
         J     PG_IF_21_E
PG_IF_21_1   DS    0H  &TYPE
*ZC     80         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_21_E   DS    0H  &TYPE
*            DIVIDE DH2 INTO ED1 IF DH3 = ED1 PERFORM G ELSE PERFORM B.
*ZC     81         DIVIDE DH2,INTO,ED1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED1
         LDETR ZC_F0,ZC_F0,0
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_ED,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         STE   ZC_F0,ED1
*ZC     81         IF    DH3,=,ED1
         LE    ZC_F4,ED1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DH3
         CDR   ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_22_1
*ZC     81         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     81         ELSE
         J     PG_IF_22_E
PG_IF_22_1   DS    0H  &TYPE
*ZC     81         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_22_E   DS    0H  &TYPE
*            DIVIDE DH2 INTO DD1 IF DH3 = DD1 PERFORM G ELSE PERFORM B.
*ZC     82         DIVIDE DH2,INTO,DD1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD1
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F0,ZC_F4
         STD   ZC_F0,DD1
*ZC     82         IF    DH3,=,DD1
         LD    ZC_F4,DH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_23_1
*ZC     82         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     82         ELSE
         J     PG_IF_23_E
PG_IF_23_1   DS    0H  &TYPE
*ZC     82         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_23_E   DS    0H  &TYPE
*            DIVIDE DH2 INTO LD1 IF DH3 = LD1 PERFORM G ELSE PERFORM B.
*ZC     83         DIVIDE DH2,INTO,LD1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD1
         LD    ZC_F2,8+LD1
         DXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,LD1
         STD   ZC_F2,8+LD1
*ZC     83         IF    DH3,=,LD1
         LD    ZC_F4,DH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_24_1
*ZC     83         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     83         ELSE
         J     PG_IF_24_E
PG_IF_24_1   DS    0H  &TYPE
*ZC     83         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_24_E   DS    0H  &TYPE
*            DIVIDE DH2 INTO F1  IF DH3 = F1  PERFORM G ELSE PERFORM B.
*ZC     84         DIVIDE DH2,INTO,F1
         MVC   ZCVT_NDDX(4),F1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R1 IGNORE HIGH 96 BITS
         LGF   ZC_R1,ZCVT_NDDX
         DSGR    0,2
         ST    1,F1
*ZC     84         IF    DH3,=,F1
         LD    ZC_F0,DH3
         L     ZC_R1,F1
         CDFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=DH'1E1'
         MD    ZC_R0,0(ZC_R2)
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_25_1
*ZC     84         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     84         ELSE
         J     PG_IF_25_E
PG_IF_25_1   DS    0H  &TYPE
*ZC     84         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_25_E   DS    0H  &TYPE
*            DIVIDE DH2 INTO G1  IF DH3 = G1  PERFORM G ELSE PERFORM B.
*ZC     85         DIVIDE DH2,INTO,G1
         MVC   ZCVT_NDDX(8),G1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
                 LGR ZC_R2,ZC_R1 IGNORE HIGH 64 BITS
         LG    1,ZCVT_NDDX
         DSGR    0,2
         STG   1,G1
*ZC     85         IF    DH3,=,G1
         LD    ZC_F0,DH3
         LG    ZC_R1,G1
         CDGR  ZC_F1,ZC_R1
         LARL  ZC_R2,=DH'1E1'
         MD    ZC_R0,0(ZC_R2)
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_26_1
*ZC     85         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     85         ELSE
         J     PG_IF_26_E
PG_IF_26_1   DS    0H  &TYPE
*ZC     85         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_26_E   DS    0H  &TYPE
*            DIVIDE DH2 INTO H1  IF DH3 = H1  PERFORM G ELSE PERFORM B.
*ZC     86         DIVIDE DH2,INTO,H1
         MVC   ZCVT_NDDX(2),H1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R1 IGNORE HIGH 96
         LGH   ZC_R1,ZCVT_NDDX
         DSGR    0,2
         STH   1,H1
*ZC     86         IF    DH3,=,H1
         LD    ZC_F0,DH3
         LH    ZC_R1,H1
         CDFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=DH'1E1'
         MD    ZC_R0,0(ZC_R2)
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_27_1
*ZC     86         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     86         ELSE
         J     PG_IF_27_E
PG_IF_27_1   DS    0H  &TYPE
*ZC     86         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_27_E   DS    0H  &TYPE
*            DIVIDE DH2 INTO P1  IF DH3 = P1  PERFORM G ELSE PERFORM B.
*ZC     87         DIVIDE DH2,INTO,P1
         ZAP ZCVT_PWORK1(16),P1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG    ZC_R0,ZC_R2,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         ZAP   P1,ZCVT_PWORK4(16)
*ZC     87         IF    DH3,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DH3
         LARL  ZC_R2,=DH'1E1'
         MD    ZC_R0,0(ZC_R2)
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_28_1
*ZC     87         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     87         ELSE
         J     PG_IF_28_E
PG_IF_28_1   DS    0H  &TYPE
*ZC     87         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_28_E   DS    0H  &TYPE
*            DIVIDE DH2 INTO Q1  IF DH3 = Q1  PERFORM G ELSE PERFORM B.
*ZC     88         DIVIDE DH2,INTO,Q1
         MVC   ZCVT_NDDX,Q1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R0
         LGR   ZC_R3,ZC_R1
         LMG   ZC_R0,ZC_R1,ZCVT_NDDX
         L     ZC_R15,ZCVT_DIVQ128 DIVIDE SCALED DIVIDEND BY QUOTIENT
         BASR  ZC_R14,ZC_R15
         LTGR  ZC_R0,ZC_R0
         JNM   ZC_LPQR_2
         XG    ZC_R0,ZCVT_HIGH_VALUES
         XG    ZC_R0+1,ZCVT_HIGH_VALUES
         ALGFI ZC_R0+1,1
         ALCG  ZC_R0,ZCVT_ZERO
ZC_LPQR_2            DS 0H
         STMG  ZC_R2,ZC_R3,Q1
*ZC     88         IF    DH3,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DH3
         LARL  ZC_R2,=DH'1E1'
         MD    ZC_R0,0(ZC_R2)
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_29_1
*ZC     88         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     88         ELSE
         J     PG_IF_29_E
PG_IF_29_1   DS    0H  &TYPE
*ZC     88         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_29_E   DS    0H  &TYPE
*            DIVIDE DH2 INTO Z1  IF DH3 = Z1  PERFORM G ELSE PERFORM B.
*ZC     89         DIVIDE DH2,INTO,Z1
         PACK  ZCVT_PWORK1(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z1(3)  PACK #3 FINAL
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG    ZC_R0,ZC_R2,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         UNPK  0+Z1(15),0+ZCVT_PWORK4(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK4(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK4(2) UNPK #3 FINAL
*ZC     89         IF    DH3,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DH3
         LARL  ZC_R2,=DH'1E1'
         MD    ZC_R0,0(ZC_R2)
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_30_1
*ZC     89         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     89         ELSE
         J     PG_IF_30_E
PG_IF_30_1   DS    0H  &TYPE
*ZC     89         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_30_E   DS    0H  &TYPE
*            PERFORM INIT.
*ZC     90         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            DIVIDE LH2 INTO EH1 IF LH3 = EH1 PERFORM G ELSE PERFORM B.
*ZC     91         DIVIDE LH2,INTO,EH1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         DER   0,1
         STE   ZC_F0,EH1
*ZC     91         IF    LH3,=,EH1
         LD    ZC_F0,LH3
         LD    ZC_F2,8+LH3
         LXE   ZC_F1,EH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_31_1
*ZC     91         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     91         ELSE
         J     PG_IF_31_E
PG_IF_31_1   DS    0H  &TYPE
*ZC     91         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_31_E   DS    0H  &TYPE
*            DIVIDE LH2 INTO DH1 IF LH3 = DH1 PERFORM G ELSE PERFORM B.
*ZC     92         DIVIDE LH2,INTO,DH1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DH1
         DDR   0,1
         STD   ZC_F0,DH1
*ZC     92         IF    LH3,=,DH1
         LD    ZC_F0,LH3
         LD    ZC_F2,8+LH3
         LXD   ZC_F1,DH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_32_1
*ZC     92         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     92         ELSE
         J     PG_IF_32_E
PG_IF_32_1   DS    0H  &TYPE
*ZC     92         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_32_E   DS    0H  &TYPE
*            DIVIDE LH2 INTO LH1 IF LH3 = LH1 PERFORM G ELSE PERFORM B.
*ZC     93         DIVIDE LH2,INTO,LH1
         LD    ZC_F0,LH2
         LD    ZC_F2,8+LH2
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LH1
         LD    ZC_F2,8+LH1
         DXR   ZC_F0,ZC_F1
         STD   ZC_F0,LH1
         STD   ZC_F2,8+LH1
*ZC     93         IF    LH3,=,LH1
         LD    ZC_F0,LH3
         LD    ZC_F2,8+LH3
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_33_1
*ZC     93         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     93         ELSE
         J     PG_IF_33_E
PG_IF_33_1   DS    0H  &TYPE
*ZC     93         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_33_E   DS    0H  &TYPE
*            DIVIDE LH2 INTO EB1 IF LH3 = EB1 PERFORM G ELSE PERFORM B.
*ZC     94         DIVIDE LH2,INTO,EB1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB1
         DEBR  0,1
         STE   ZC_F0,EB1
*ZC     94         IF    LH3,=,EB1
         LE    ZC_F4,EB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LH3
         LD    ZC_F3,8+LH3
         CXR   ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_34_1
*ZC     94         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     94         ELSE
         J     PG_IF_34_E
PG_IF_34_1   DS    0H  &TYPE
*ZC     94         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_34_E   DS    0H  &TYPE
*            DIVIDE LH2 INTO DB1 IF LH3 = DB1 PERFORM G ELSE PERFORM B.
*ZC     95         DIVIDE LH2,INTO,DB1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB1
         DDBR  0,1
         STD   ZC_F0,DB1
*ZC     95         IF    LH3,=,DB1
         LD    ZC_F4,DB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LH3
         LD    ZC_F3,8+LH3
         CXR   ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_35_1
*ZC     95         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     95         ELSE
         J     PG_IF_35_E
PG_IF_35_1   DS    0H  &TYPE
*ZC     95         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_35_E   DS    0H  &TYPE
*            DIVIDE LH2 INTO LB1 IF LH3 = LB1 PERFORM G ELSE PERFORM B.
*ZC     96         DIVIDE LH2,INTO,LB1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB1
         LD    ZC_F2,8+LB1
         DXBR  ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LDR   ZC_F0,ZC_F4
         LDR   ZC_F2,ZC_F6
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC     96         IF    LH3,=,LB1
         LD    ZC_F4,LH3
         LD    ZC_F6,8+LH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_36_1
*ZC     96         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     96         ELSE
         J     PG_IF_36_E
PG_IF_36_1   DS    0H  &TYPE
*ZC     96         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_36_E   DS    0H  &TYPE
*            DIVIDE LH2 INTO ED1 IF LH3 = ED1 PERFORM G ELSE PERFORM B.
*ZC     97         DIVIDE LH2,INTO,ED1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED1
         LDETR ZC_F0,ZC_F0,0
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_ED,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         STE   ZC_F0,ED1
*ZC     97         IF    LH3,=,ED1
         LE    ZC_F4,ED1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LH3
         LD    ZC_F3,8+LH3
         CXR   ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_37_1
*ZC     97         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     97         ELSE
         J     PG_IF_37_E
PG_IF_37_1   DS    0H  &TYPE
*ZC     97         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_37_E   DS    0H  &TYPE
*            DIVIDE LH2 INTO DD1 IF LH3 = DD1 PERFORM G ELSE PERFORM B.
*ZC     98         DIVIDE LH2,INTO,DD1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD1
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F0,ZC_F4
         STD   ZC_F0,DD1
*ZC     98         IF    LH3,=,DD1
         LD    ZC_F4,DD1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LH3
         LD    ZC_F3,8+LH3
         CXR   ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_38_1
*ZC     98         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     98         ELSE
         J     PG_IF_38_E
PG_IF_38_1   DS    0H  &TYPE
*ZC     98         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_38_E   DS    0H  &TYPE
*            DIVIDE LH2 INTO LD1 IF LH3 = LD1 PERFORM G ELSE PERFORM B.
*ZC     99         DIVIDE LH2,INTO,LD1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD1
         LD    ZC_F2,8+LD1
         DXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,LD1
         STD   ZC_F2,8+LD1
*ZC     99         IF    LH3,=,LD1
         LD    ZC_F4,LD1
         LD    ZC_F6,8+LD1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LH3
         LD    ZC_F3,8+LH3
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_39_1
*ZC     99         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     99         ELSE
         J     PG_IF_39_E
PG_IF_39_1   DS    0H  &TYPE
*ZC     99         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_39_E   DS    0H  &TYPE
*            DIVIDE LH2 INTO F1  IF LH3 = F1  PERFORM G ELSE PERFORM B.
*ZC    100         DIVIDE LH2,INTO,F1
         MVC   ZCVT_NDDX(4),F1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R1 IGNORE HIGH 96 BITS
         LGF   ZC_R1,ZCVT_NDDX
         DSGR    0,2
         ST    1,F1
*ZC    100         IF    LH3,=,F1
         LD    ZC_F0,LH3
         LD    ZC_F2,8+LH3
         L     ZC_R1,F1
         CXFR  ZC_F1,ZC_R1
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LH'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXR   ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_40_1
*ZC    100         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    100         ELSE
         J     PG_IF_40_E
PG_IF_40_1   DS    0H  &TYPE
*ZC    100         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_40_E   DS    0H  &TYPE
*            DIVIDE LH2 INTO G1  IF LH3 = G1  PERFORM G ELSE PERFORM B.
*ZC    101         DIVIDE LH2,INTO,G1
         MVC   ZCVT_NDDX(8),G1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
                 LGR ZC_R2,ZC_R1 IGNORE HIGH 64 BITS
         LG    1,ZCVT_NDDX
         DSGR    0,2
         STG   1,G1
*ZC    101         IF    LH3,=,G1
         LD    ZC_F0,LH3
         LD    ZC_F2,8+LH3
         LG    ZC_R1,G1
         CXGR  ZC_F1,ZC_R1
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LH'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXR   ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_41_1
*ZC    101         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    101         ELSE
         J     PG_IF_41_E
PG_IF_41_1   DS    0H  &TYPE
*ZC    101         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_41_E   DS    0H  &TYPE
*            DIVIDE LH2 INTO H1  IF LH3 = H1  PERFORM G ELSE PERFORM B.
*ZC    102         DIVIDE LH2,INTO,H1
         MVC   ZCVT_NDDX(2),H1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R1 IGNORE HIGH 96
         LGH   ZC_R1,ZCVT_NDDX
         DSGR    0,2
         STH   1,H1
*ZC    102         IF    LH3,=,H1
         LD    ZC_F0,LH3
         LD    ZC_F2,8+LH3
         LH    ZC_R1,H1
         CXFR  ZC_F1,ZC_R1
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LH'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXR   ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_42_1
*ZC    102         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    102         ELSE
         J     PG_IF_42_E
PG_IF_42_1   DS    0H  &TYPE
*ZC    102         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_42_E   DS    0H  &TYPE
*            DIVIDE LH2 INTO P1  IF LH3 = P1  PERFORM G ELSE PERFORM B.
*ZC    103         DIVIDE LH2,INTO,P1
         ZAP ZCVT_PWORK1(16),P1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG    ZC_R0,ZC_R2,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         ZAP   P1,ZCVT_PWORK4(16)
*ZC    103         IF    LH3,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LH3
         LD    ZC_F2,8+LH3
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LH'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXR   ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_43_1
*ZC    103         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    103         ELSE
         J     PG_IF_43_E
PG_IF_43_1   DS    0H  &TYPE
*ZC    103         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_43_E   DS    0H  &TYPE
*            DIVIDE LH2 INTO Q1  IF LH3 = Q1  PERFORM G ELSE PERFORM B.
*ZC    104         DIVIDE LH2,INTO,Q1
         MVC   ZCVT_NDDX,Q1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R0
         LGR   ZC_R3,ZC_R1
         LMG   ZC_R0,ZC_R1,ZCVT_NDDX
         L     ZC_R15,ZCVT_DIVQ128 DIVIDE SCALED DIVIDEND BY QUOTIENT
         BASR  ZC_R14,ZC_R15
         LTGR  ZC_R0,ZC_R0
         JNM   ZC_LPQR_3
         XG    ZC_R0,ZCVT_HIGH_VALUES
         XG    ZC_R0+1,ZCVT_HIGH_VALUES
         ALGFI ZC_R0+1,1
         ALCG  ZC_R0,ZCVT_ZERO
ZC_LPQR_3            DS 0H
         STMG  ZC_R2,ZC_R3,Q1
*ZC    104         IF    LH3,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LH3
         LD    ZC_F2,8+LH3
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LH'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXR   ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXR   ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_44_1
*ZC    104         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    104         ELSE
         J     PG_IF_44_E
PG_IF_44_1   DS    0H  &TYPE
*ZC    104         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_44_E   DS    0H  &TYPE
*            DIVIDE LH2 INTO Z1  IF LH3 = Z1  PERFORM G ELSE PERFORM B.
*ZC    105         DIVIDE LH2,INTO,Z1
         PACK  ZCVT_PWORK1(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z1(3)  PACK #3 FINAL
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG    ZC_R0,ZC_R2,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         UNPK  0+Z1(15),0+ZCVT_PWORK4(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK4(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK4(2) UNPK #3 FINAL
*ZC    105         IF    LH3,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LH3
         LD    ZC_F2,8+LH3
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LH'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXR   ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXR   ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_45_1
*ZC    105         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    105         ELSE
         J     PG_IF_45_E
PG_IF_45_1   DS    0H  &TYPE
*ZC    105         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_45_E   DS    0H  &TYPE
*            PERFORM INIT.
*ZC    106         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            DIVIDE EB2 INTO EH1 IF EB3 = EH1 PERFORM G ELSE PERFORM B.
*ZC    107         DIVIDE EB2,INTO,EH1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         DER   0,1
         STE   ZC_F0,EH1
*ZC    107         IF    EB3,=,EH1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB3
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_46_1
*ZC    107         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    107         ELSE
         J     PG_IF_46_E
PG_IF_46_1   DS    0H  &TYPE
*ZC    107         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_46_E   DS    0H  &TYPE
*            DIVIDE EB2 INTO DH1 IF EB3 = DH1 PERFORM G ELSE PERFORM B.
*ZC    108         DIVIDE EB2,INTO,DH1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DH1
         DDR   0,1
         STD   ZC_F0,DH1
*ZC    108         IF    EB3,=,DH1
         LD    ZC_F4,DH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB3
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_47_1
*ZC    108         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    108         ELSE
         J     PG_IF_47_E
PG_IF_47_1   DS    0H  &TYPE
*ZC    108         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_47_E   DS    0H  &TYPE
*            DIVIDE EB2 INTO LH1 IF EB3 = LH1 PERFORM G ELSE PERFORM B.
*ZC    109         DIVIDE EB2,INTO,LH1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LH1
         LD    ZC_F2,8+LH1
         DXR   ZC_F0,ZC_F1
         STD   ZC_F0,LH1
         STD   ZC_F2,8+LH1
*ZC    109         IF    EB3,=,LH1
         LD    ZC_F4,LH1
         LD    ZC_F6,8+LH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB3
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_48_1
*ZC    109         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    109         ELSE
         J     PG_IF_48_E
PG_IF_48_1   DS    0H  &TYPE
*ZC    109         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_48_E   DS    0H  &TYPE
*            DIVIDE EB2 INTO EB1 IF EB3 = EB1 PERFORM G ELSE PERFORM B.
*ZC    110         DIVIDE EB2,INTO,EB1
         LE    ZC_F0,EB2
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB1
         DEBR  0,1
         STE   ZC_F0,EB1
*ZC    110         IF    EB3,=,EB1
         LE    ZC_F0,EB3
         LE    ZC_F1,EB1
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_49_1
*ZC    110         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    110         ELSE
         J     PG_IF_49_E
PG_IF_49_1   DS    0H  &TYPE
*ZC    110         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_49_E   DS    0H  &TYPE
*            DIVIDE EB2 INTO DB1 IF EB3 = DB1 PERFORM G ELSE PERFORM B.
*ZC    111         DIVIDE EB2,INTO,DB1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB1
         DDBR  0,1
         STD   ZC_F0,DB1
*ZC    111         IF    EB3,=,DB1
         LD    ZC_F4,DB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB3
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_50_1
*ZC    111         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    111         ELSE
         J     PG_IF_50_E
PG_IF_50_1   DS    0H  &TYPE
*ZC    111         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_50_E   DS    0H  &TYPE
*            DIVIDE EB2 INTO LB1 IF EB3 = LB1 PERFORM G ELSE PERFORM B.
*ZC    112         DIVIDE EB2,INTO,LB1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB1
         LD    ZC_F2,8+LB1
         DXBR  ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LDR   ZC_F0,ZC_F4
         LDR   ZC_F2,ZC_F6
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC    112         IF    EB3,=,LB1
         LD    ZC_F4,LB1
         LD    ZC_F6,8+LB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB3
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_51_1
*ZC    112         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    112         ELSE
         J     PG_IF_51_E
PG_IF_51_1   DS    0H  &TYPE
*ZC    112         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_51_E   DS    0H  &TYPE
*            DIVIDE EB2 INTO ED1 IF EB3 = ED1 PERFORM G ELSE PERFORM B.
*ZC    113         DIVIDE EB2,INTO,ED1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED1
         LDETR ZC_F0,ZC_F0,0
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_ED,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         STE   ZC_F0,ED1
*ZC    113         IF    EB3,=,ED1
         LE    ZC_F4,ED1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB3
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_52_1
*ZC    113         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    113         ELSE
         J     PG_IF_52_E
PG_IF_52_1   DS    0H  &TYPE
*ZC    113         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_52_E   DS    0H  &TYPE
*            DIVIDE EB2 INTO DD1 IF EB3 = DD1 PERFORM G ELSE PERFORM B.
*ZC    114         DIVIDE EB2,INTO,DD1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD1
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F0,ZC_F4
         STD   ZC_F0,DD1
*ZC    114         IF    EB3,=,DD1
         LD    ZC_F4,DD1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB3
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_53_1
*ZC    114         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    114         ELSE
         J     PG_IF_53_E
PG_IF_53_1   DS    0H  &TYPE
*ZC    114         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_53_E   DS    0H  &TYPE
*            DIVIDE EB2 INTO LD1 IF EB3 = LD1 PERFORM G ELSE PERFORM B.
*ZC    115         DIVIDE EB2,INTO,LD1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD1
         LD    ZC_F2,8+LD1
         DXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,LD1
         STD   ZC_F2,8+LD1
*ZC    115         IF    EB3,=,LD1
         LD    ZC_F4,LD1
         LD    ZC_F6,8+LD1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB3
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_54_1
*ZC    115         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    115         ELSE
         J     PG_IF_54_E
PG_IF_54_1   DS    0H  &TYPE
*ZC    115         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_54_E   DS    0H  &TYPE
*            DIVIDE EB2 INTO F1  IF EB3 = F1  PERFORM G ELSE PERFORM B.
*ZC    116         DIVIDE EB2,INTO,F1
         MVC   ZCVT_NDDX(4),F1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R1 IGNORE HIGH 96 BITS
         LGF   ZC_R1,ZCVT_NDDX
         DSGR    0,2
         ST    1,F1
*ZC    116         IF    EB3,=,F1
         LE    ZC_F0,EB3
         L     ZC_R1,F1
         CEFBR ZC_F1,ZC_F1
         LARL  ZC_R2,=EB'1E1'
         MDEB  ZC_F0,0(ZC_R2)
         LEDBR ZC_F0,ZC_F0
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_55_1
*ZC    116         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    116         ELSE
         J     PG_IF_55_E
PG_IF_55_1   DS    0H  &TYPE
*ZC    116         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_55_E   DS    0H  &TYPE
*            DIVIDE EB2 INTO G1  IF EB3 = G1  PERFORM G ELSE PERFORM B.
*ZC    117         DIVIDE EB2,INTO,G1
         MVC   ZCVT_NDDX(8),G1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
                 LGR ZC_R2,ZC_R1 IGNORE HIGH 64 BITS
         LG    1,ZCVT_NDDX
         DSGR    0,2
         STG   1,G1
*ZC    117         IF    EB3,=,G1
         LE    ZC_F0,EB3
         LG    ZC_R1,G1
         CEGBR ZC_F1,ZC_R1
         LARL  ZC_R2,=EB'1E1'
         MDEB  ZC_F0,0(ZC_R2)
         LEDBR ZC_F0,ZC_F0
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_56_1
*ZC    117         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    117         ELSE
         J     PG_IF_56_E
PG_IF_56_1   DS    0H  &TYPE
*ZC    117         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_56_E   DS    0H  &TYPE
*            DIVIDE EB2 INTO H1  IF EB3 = H1  PERFORM G ELSE PERFORM B.
*ZC    118         DIVIDE EB2,INTO,H1
         MVC   ZCVT_NDDX(2),H1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R1 IGNORE HIGH 96
         LGH   ZC_R1,ZCVT_NDDX
         DSGR    0,2
         STH   1,H1
*ZC    118         IF    EB3,=,H1
         LE    ZC_F0,EB3
         LH    ZC_R1,H1
         CEFBR ZC_F1,ZC_R1
         LARL  ZC_R2,=EB'1E1'
         MDEB  ZC_F0,0(ZC_R2)
         LEDBR ZC_F0,ZC_F0
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_57_1
*ZC    118         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    118         ELSE
         J     PG_IF_57_E
PG_IF_57_1   DS    0H  &TYPE
*ZC    118         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_57_E   DS    0H  &TYPE
*            DIVIDE EB2 INTO P1  IF EB3 = P1  PERFORM G ELSE PERFORM B.
*ZC    119         DIVIDE EB2,INTO,P1
         ZAP ZCVT_PWORK1(16),P1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG    ZC_R0,ZC_R2,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         ZAP   P1,ZCVT_PWORK4(16)
*ZC    119         IF    EB3,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB3
         LARL  ZC_R2,=EB'1E1'
         MDEB  ZC_F0,0(ZC_R2)
         LEDBR ZC_F0,ZC_F0
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_58_1
*ZC    119         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    119         ELSE
         J     PG_IF_58_E
PG_IF_58_1   DS    0H  &TYPE
*ZC    119         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_58_E   DS    0H  &TYPE
*            DIVIDE EB2 INTO Q1  IF EB3 = Q1  PERFORM G ELSE PERFORM B.
*ZC    120         DIVIDE EB2,INTO,Q1
         MVC   ZCVT_NDDX,Q1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R0
         LGR   ZC_R3,ZC_R1
         LMG   ZC_R0,ZC_R1,ZCVT_NDDX
         L     ZC_R15,ZCVT_DIVQ128 DIVIDE SCALED DIVIDEND BY QUOTIENT
         BASR  ZC_R14,ZC_R15
         LTGR  ZC_R0,ZC_R0
         JNM   ZC_LPQR_4
         XG    ZC_R0,ZCVT_HIGH_VALUES
         XG    ZC_R0+1,ZCVT_HIGH_VALUES
         ALGFI ZC_R0+1,1
         ALCG  ZC_R0,ZCVT_ZERO
ZC_LPQR_4            DS 0H
         STMG  ZC_R2,ZC_R3,Q1
*ZC    120         IF    EB3,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB3
         LARL  ZC_R2,=EB'1E1'
         MDEB  ZC_F0,0(ZC_R2)
         LEDBR ZC_F0,ZC_F0
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_59_1
*ZC    120         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    120         ELSE
         J     PG_IF_59_E
PG_IF_59_1   DS    0H  &TYPE
*ZC    120         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_59_E   DS    0H  &TYPE
*            DIVIDE EB2 INTO Z1  IF EB3 = Z1  PERFORM G ELSE PERFORM B.
*ZC    121         DIVIDE EB2,INTO,Z1
         PACK  ZCVT_PWORK1(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z1(3)  PACK #3 FINAL
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG    ZC_R0,ZC_R2,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         UNPK  0+Z1(15),0+ZCVT_PWORK4(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK4(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK4(2) UNPK #3 FINAL
*ZC    121         IF    EB3,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB3
         LARL  ZC_R2,=EB'1E1'
         MDEB  ZC_F0,0(ZC_R2)
         LEDBR ZC_F0,ZC_F0
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_60_1
*ZC    121         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    121         ELSE
         J     PG_IF_60_E
PG_IF_60_1   DS    0H  &TYPE
*ZC    121         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_60_E   DS    0H  &TYPE
*            PERFORM INIT.
*ZC    122         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            DIVIDE DB2 INTO EH1 IF DB3 = EH1 PERFORM G ELSE PERFORM B.
*ZC    123         DIVIDE DB2,INTO,EH1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         DER   0,1
         STE   ZC_F0,EH1
*ZC    123         IF    DB3,=,EH1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB3
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_61_1
*ZC    123         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    123         ELSE
         J     PG_IF_61_E
PG_IF_61_1   DS    0H  &TYPE
*ZC    123         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_61_E   DS    0H  &TYPE
*            DIVIDE DB2 INTO DH1 IF DB3 = DH1 PERFORM G ELSE PERFORM B.
*ZC    124         DIVIDE DB2,INTO,DH1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DH1
         DDR   0,1
         STD   ZC_F0,DH1
*ZC    124         IF    DB3,=,DH1
         LD    ZC_F4,DH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB3
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_62_1
*ZC    124         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    124         ELSE
         J     PG_IF_62_E
PG_IF_62_1   DS    0H  &TYPE
*ZC    124         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_62_E   DS    0H  &TYPE
*            DIVIDE DB2 INTO LH1 IF DB3 = LH1 PERFORM G ELSE PERFORM B.
*ZC    125         DIVIDE DB2,INTO,LH1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LH1
         LD    ZC_F2,8+LH1
         DXR   ZC_F0,ZC_F1
         STD   ZC_F0,LH1
         STD   ZC_F2,8+LH1
*ZC    125         IF    DB3,=,LH1
         LD    ZC_F4,LH1
         LD    ZC_F6,8+LH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB3
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_63_1
*ZC    125         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    125         ELSE
         J     PG_IF_63_E
PG_IF_63_1   DS    0H  &TYPE
*ZC    125         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_63_E   DS    0H  &TYPE
*            DIVIDE DB2 INTO EB1 IF DB3 = EB1 PERFORM G ELSE PERFORM B.
*ZC    126         DIVIDE DB2,INTO,EB1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB1
         DEBR  0,1
         STE   ZC_F0,EB1
*ZC    126         IF    DB3,=,EB1
         LE    ZC_F4,EB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB3
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_64_1
*ZC    126         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    126         ELSE
         J     PG_IF_64_E
PG_IF_64_1   DS    0H  &TYPE
*ZC    126         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_64_E   DS    0H  &TYPE
*            DIVIDE DB2 INTO DB1 IF DB3 = DB1 PERFORM G ELSE PERFORM B.
*ZC    127         DIVIDE DB2,INTO,DB1
         LD    ZC_F0,DB2
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB1
         DDBR  0,1
         STD   ZC_F0,DB1
*ZC    127         IF    DB3,=,DB1
         LD    ZC_F0,DB3
         LD    ZC_F1,DB1
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_65_1
*ZC    127         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    127         ELSE
         J     PG_IF_65_E
PG_IF_65_1   DS    0H  &TYPE
*ZC    127         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_65_E   DS    0H  &TYPE
*            DIVIDE DB2 INTO LB1 IF DB3 = LB1 PERFORM G ELSE PERFORM B.
*ZC    128         DIVIDE DB2,INTO,LB1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB1
         LD    ZC_F2,8+LB1
         DXBR  ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LDR   ZC_F0,ZC_F4
         LDR   ZC_F2,ZC_F6
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC    128         IF    DB3,=,LB1
         LD    ZC_F4,LB1
         LD    ZC_F6,8+LB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB3
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_66_1
*ZC    128         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    128         ELSE
         J     PG_IF_66_E
PG_IF_66_1   DS    0H  &TYPE
*ZC    128         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_66_E   DS    0H  &TYPE
*            DIVIDE DB2 INTO ED1 IF DB3 = ED1 PERFORM G ELSE PERFORM B.
*ZC    129         DIVIDE DB2,INTO,ED1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED1
         LDETR ZC_F0,ZC_F0,0
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_ED,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         STE   ZC_F0,ED1
*ZC    129         IF    DB3,=,ED1
         LE    ZC_F4,ED1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB3
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_67_1
*ZC    129         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    129         ELSE
         J     PG_IF_67_E
PG_IF_67_1   DS    0H  &TYPE
*ZC    129         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_67_E   DS    0H  &TYPE
*            DIVIDE DB2 INTO DD1 IF DB3 = DD1 PERFORM G ELSE PERFORM B.
*ZC    130         DIVIDE DB2,INTO,DD1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD1
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F0,ZC_F4
         STD   ZC_F0,DD1
*ZC    130         IF    DB3,=,DD1
         LD    ZC_F4,DD1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB3
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_68_1
*ZC    130         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    130         ELSE
         J     PG_IF_68_E
PG_IF_68_1   DS    0H  &TYPE
*ZC    130         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_68_E   DS    0H  &TYPE
*            DIVIDE DB2 INTO LD1 IF DB3 = LD1 PERFORM G ELSE PERFORM B.
*ZC    131         DIVIDE DB2,INTO,LD1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD1
         LD    ZC_F2,8+LD1
         DXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,LD1
         STD   ZC_F2,8+LD1
*ZC    131         IF    DB3,=,LD1
         LD    ZC_F4,LD1
         LD    ZC_F6,8+LD1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB3
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_69_1
*ZC    131         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    131         ELSE
         J     PG_IF_69_E
PG_IF_69_1   DS    0H  &TYPE
*ZC    131         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_69_E   DS    0H  &TYPE
*            DIVIDE DB2 INTO F1  IF DB3 = F1  PERFORM G ELSE PERFORM B.
*ZC    132         DIVIDE DB2,INTO,F1
         MVC   ZCVT_NDDX(4),F1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R1 IGNORE HIGH 96 BITS
         LGF   ZC_R1,ZCVT_NDDX
         DSGR    0,2
         ST    1,F1
*ZC    132         IF    DB3,=,F1
         LD    ZC_F0,DB3
         L     ZC_R1,F1
         CDFBR ZC_F1,ZC_R1
         LARL  ZC_R2,=DB'1E1'
         MDB   ZC_R0,0(ZC_R2)
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_70_1
*ZC    132         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    132         ELSE
         J     PG_IF_70_E
PG_IF_70_1   DS    0H  &TYPE
*ZC    132         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_70_E   DS    0H  &TYPE
*            DIVIDE DB2 INTO G1  IF DB3 = G1  PERFORM G ELSE PERFORM B.
*ZC    133         DIVIDE DB2,INTO,G1
         MVC   ZCVT_NDDX(8),G1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
                 LGR ZC_R2,ZC_R1 IGNORE HIGH 64 BITS
         LG    1,ZCVT_NDDX
         DSGR    0,2
         STG   1,G1
*ZC    133         IF    DB3,=,G1
         LD    ZC_F0,DB3
         LG    ZC_R1,G1
         CDGBR ZC_F1,ZC_R1
         LARL  ZC_R2,=DB'1E1'
         MDB   ZC_R0,0(ZC_R2)
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_71_1
*ZC    133         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    133         ELSE
         J     PG_IF_71_E
PG_IF_71_1   DS    0H  &TYPE
*ZC    133         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_71_E   DS    0H  &TYPE
*            DIVIDE DB2 INTO H1  IF DB3 = H1  PERFORM G ELSE PERFORM B.
*ZC    134         DIVIDE DB2,INTO,H1
         MVC   ZCVT_NDDX(2),H1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R1 IGNORE HIGH 96
         LGH   ZC_R1,ZCVT_NDDX
         DSGR    0,2
         STH   1,H1
*ZC    134         IF    DB3,=,H1
         LD    ZC_F0,DB3
         LH    ZC_R1,H1
         CDFBR ZC_F1,ZC_R1
         LARL  ZC_R2,=DB'1E1'
         MDB   ZC_R0,0(ZC_R2)
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_72_1
*ZC    134         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    134         ELSE
         J     PG_IF_72_E
PG_IF_72_1   DS    0H  &TYPE
*ZC    134         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_72_E   DS    0H  &TYPE
*            DIVIDE DB2 INTO P1  IF DB3 = P1  PERFORM G ELSE PERFORM B.
*ZC    135         DIVIDE DB2,INTO,P1
         ZAP ZCVT_PWORK1(16),P1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG    ZC_R0,ZC_R2,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         ZAP   P1,ZCVT_PWORK4(16)
*ZC    135         IF    DB3,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB3
         LARL  ZC_R2,=DB'1E1'
         MDB   ZC_R0,0(ZC_R2)
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_73_1
*ZC    135         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    135         ELSE
         J     PG_IF_73_E
PG_IF_73_1   DS    0H  &TYPE
*ZC    135         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_73_E   DS    0H  &TYPE
*            DIVIDE DB2 INTO Q1  IF DB3 = Q1  PERFORM G ELSE PERFORM B.
*ZC    136         DIVIDE DB2,INTO,Q1
         MVC   ZCVT_NDDX,Q1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R0
         LGR   ZC_R3,ZC_R1
         LMG   ZC_R0,ZC_R1,ZCVT_NDDX
         L     ZC_R15,ZCVT_DIVQ128 DIVIDE SCALED DIVIDEND BY QUOTIENT
         BASR  ZC_R14,ZC_R15
         LTGR  ZC_R0,ZC_R0
         JNM   ZC_LPQR_5
         XG    ZC_R0,ZCVT_HIGH_VALUES
         XG    ZC_R0+1,ZCVT_HIGH_VALUES
         ALGFI ZC_R0+1,1
         ALCG  ZC_R0,ZCVT_ZERO
ZC_LPQR_5            DS 0H
         STMG  ZC_R2,ZC_R3,Q1
*ZC    136         IF    DB3,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB3
         LARL  ZC_R2,=DB'1E1'
         MDB   ZC_R0,0(ZC_R2)
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_74_1
*ZC    136         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    136         ELSE
         J     PG_IF_74_E
PG_IF_74_1   DS    0H  &TYPE
*ZC    136         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_74_E   DS    0H  &TYPE
*            DIVIDE DB2 INTO Z1  IF DB3 = Z1  PERFORM G ELSE PERFORM B.
*ZC    137         DIVIDE DB2,INTO,Z1
         PACK  ZCVT_PWORK1(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z1(3)  PACK #3 FINAL
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG    ZC_R0,ZC_R2,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         UNPK  0+Z1(15),0+ZCVT_PWORK4(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK4(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK4(2) UNPK #3 FINAL
*ZC    137         IF    DB3,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB3
         LARL  ZC_R2,=DB'1E1'
         MDB   ZC_R0,0(ZC_R2)
         CDBR  ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_75_1
*ZC    137         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    137         ELSE
         J     PG_IF_75_E
PG_IF_75_1   DS    0H  &TYPE
*ZC    137         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_75_E   DS    0H  &TYPE
*            PERFORM INIT.
*ZC    138         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            DIVIDE LB2 INTO EH1 IF LB3 = EH1 PERFORM G ELSE PERFORM B.
*ZC    139         DIVIDE LB2,INTO,EH1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         DER   0,1
         STE   ZC_F0,EH1
*ZC    139         IF    LB3,=,EH1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB3
         LD    ZC_F2,8+LB3
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_76_1
*ZC    139         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    139         ELSE
         J     PG_IF_76_E
PG_IF_76_1   DS    0H  &TYPE
*ZC    139         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_76_E   DS    0H  &TYPE
*            DIVIDE LB2 INTO DH1 IF LB3 = DH1 PERFORM G ELSE PERFORM B.
*ZC    140         DIVIDE LB2,INTO,DH1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DH1
         DDR   0,1
         STD   ZC_F0,DH1
*ZC    140         IF    LB3,=,DH1
         LD    ZC_F4,DH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB3
         LD    ZC_F2,8+LB3
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_77_1
*ZC    140         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    140         ELSE
         J     PG_IF_77_E
PG_IF_77_1   DS    0H  &TYPE
*ZC    140         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_77_E   DS    0H  &TYPE
*            DIVIDE LB2 INTO LH1 IF LB3 = LH1 PERFORM G ELSE PERFORM B.
*ZC    141         DIVIDE LB2,INTO,LH1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LH1
         LD    ZC_F2,8+LH1
         DXR   ZC_F0,ZC_F1
         STD   ZC_F0,LH1
         STD   ZC_F2,8+LH1
*ZC    141         IF    LB3,=,LH1
         LD    ZC_F4,LH1
         LD    ZC_F6,8+LH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB3
         LD    ZC_F2,8+LB3
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_78_1
*ZC    141         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    141         ELSE
         J     PG_IF_78_E
PG_IF_78_1   DS    0H  &TYPE
*ZC    141         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_78_E   DS    0H  &TYPE
*            DIVIDE LB2 INTO EB1 IF LB3 = EB1 PERFORM G ELSE PERFORM B.
*ZC    142         DIVIDE LB2,INTO,EB1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB1
         DEBR  0,1
         STE   ZC_F0,EB1
*ZC    142         IF    LB3,=,EB1
         LE    ZC_F4,EB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB3
         LD    ZC_F2,8+LB3
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_79_1
*ZC    142         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    142         ELSE
         J     PG_IF_79_E
PG_IF_79_1   DS    0H  &TYPE
*ZC    142         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_79_E   DS    0H  &TYPE
*            DIVIDE LB2 INTO DB1 IF LB3 = DB1 PERFORM G ELSE PERFORM B.
*ZC    143         DIVIDE LB2,INTO,DB1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB1
         DDBR  0,1
         STD   ZC_F0,DB1
*ZC    143         IF    LB3,=,DB1
         LD    ZC_F4,DB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB3
         LD    ZC_F2,8+LB3
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_80_1
*ZC    143         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    143         ELSE
         J     PG_IF_80_E
PG_IF_80_1   DS    0H  &TYPE
*ZC    143         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_80_E   DS    0H  &TYPE
*            DIVIDE LB2 INTO LB1 IF LB3 = LB1 PERFORM G ELSE PERFORM B.
*ZC    144         DIVIDE LB2,INTO,LB1
         LD    ZC_F0,LB2
         LD    ZC_F2,8+LB2
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB1
         LD    ZC_F2,8+LB1
         DXBR  ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LDR   ZC_F0,ZC_F4
         LDR   ZC_F2,ZC_F6
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC    144         IF    LB3,=,LB1
         LD    ZC_F0,LB1
         LD    ZC_F2,8+LB1
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB3
         LD    ZC_F2,8+LB3
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_81_1
*ZC    144         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    144         ELSE
         J     PG_IF_81_E
PG_IF_81_1   DS    0H  &TYPE
*ZC    144         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_81_E   DS    0H  &TYPE
*            DIVIDE LB2 INTO ED1 IF LB3 = ED1 PERFORM G ELSE PERFORM B.
*ZC    145         DIVIDE LB2,INTO,ED1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED1
         LDETR ZC_F0,ZC_F0,0
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_ED,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         STE   ZC_F0,ED1
*ZC    145         IF    LB3,=,ED1
         LE    ZC_F4,ED1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB3
         LD    ZC_F2,8+LB3
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_82_1
*ZC    145         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    145         ELSE
         J     PG_IF_82_E
PG_IF_82_1   DS    0H  &TYPE
*ZC    145         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_82_E   DS    0H  &TYPE
*            DIVIDE LB2 INTO DD1 IF LB3 = DD1 PERFORM G ELSE PERFORM B.
*ZC    146         DIVIDE LB2,INTO,DD1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD1
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F0,ZC_F4
         STD   ZC_F0,DD1
*ZC    146         IF    LB3,=,DD1
         LD    ZC_F4,DD1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB3
         LD    ZC_F2,8+LB3
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_83_1
*ZC    146         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    146         ELSE
         J     PG_IF_83_E
PG_IF_83_1   DS    0H  &TYPE
*ZC    146         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_83_E   DS    0H  &TYPE
*            DIVIDE LB2 INTO LD1 IF LB3 = LD1 PERFORM G ELSE PERFORM B.
*ZC    147         DIVIDE LB2,INTO,LD1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD1
         LD    ZC_F2,8+LD1
         DXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,LD1
         STD   ZC_F2,8+LD1
*ZC    147         IF    LB3,=,LD1
         LD    ZC_F4,LD1
         LD    ZC_F6,8+LD1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB3
         LD    ZC_F2,8+LB3
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_84_1
*ZC    147         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    147         ELSE
         J     PG_IF_84_E
PG_IF_84_1   DS    0H  &TYPE
*ZC    147         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_84_E   DS    0H  &TYPE
*            DIVIDE LB2 INTO F1  IF LB3 = F1  PERFORM G ELSE PERFORM B.
*ZC    148         DIVIDE LB2,INTO,F1
         MVC   ZCVT_NDDX(4),F1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R1 IGNORE HIGH 96 BITS
         LGF   ZC_R1,ZCVT_NDDX
         DSGR    0,2
         ST    1,F1
*ZC    148         IF    LB3,=,F1
         L     ZC_R1,F1
         CXFBR ZC_F1,ZC_R1
         LD    ZC_F0,LB3
         LD    ZC_F2,8+LB3
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LB'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXBR  ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_85_1
*ZC    148         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    148         ELSE
         J     PG_IF_85_E
PG_IF_85_1   DS    0H  &TYPE
*ZC    148         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_85_E   DS    0H  &TYPE
*            DIVIDE LB2 INTO G1  IF LB3 = G1  PERFORM G ELSE PERFORM B.
*ZC    149         DIVIDE LB2,INTO,G1
         MVC   ZCVT_NDDX(8),G1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
                 LGR ZC_R2,ZC_R1 IGNORE HIGH 64 BITS
         LG    1,ZCVT_NDDX
         DSGR    0,2
         STG   1,G1
*ZC    149         IF    LB3,=,G1
         LG    ZC_R1,G1
         CXGBR ZC_F1,ZC_R1
         LD    ZC_F0,LB3
         LD    ZC_F2,8+LB3
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LB'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXBR  ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_86_1
*ZC    149         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    149         ELSE
         J     PG_IF_86_E
PG_IF_86_1   DS    0H  &TYPE
*ZC    149         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_86_E   DS    0H  &TYPE
*            DIVIDE LB2 INTO H1  IF LB3 = H1  PERFORM G ELSE PERFORM B.
*ZC    150         DIVIDE LB2,INTO,H1
         MVC   ZCVT_NDDX(2),H1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R1 IGNORE HIGH 96
         LGH   ZC_R1,ZCVT_NDDX
         DSGR    0,2
         STH   1,H1
*ZC    150         IF    LB3,=,H1
         LH    ZC_R1,H1
         CXGBR ZC_F1,ZC_R1
         LD    ZC_F0,LB3
         LD    ZC_F2,8+LB3
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LB'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXBR  ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_87_1
*ZC    150         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    150         ELSE
         J     PG_IF_87_E
PG_IF_87_1   DS    0H  &TYPE
*ZC    150         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_87_E   DS    0H  &TYPE
*            DIVIDE LB2 INTO P1  IF LB3 = P1  PERFORM G ELSE PERFORM B.
*ZC    151         DIVIDE LB2,INTO,P1
         ZAP ZCVT_PWORK1(16),P1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG    ZC_R0,ZC_R2,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         ZAP   P1,ZCVT_PWORK4(16)
*ZC    151         IF    LB3,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB3
         LD    ZC_F2,8+LB3
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LB'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXBR  ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_88_1
*ZC    151         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    151         ELSE
         J     PG_IF_88_E
PG_IF_88_1   DS    0H  &TYPE
*ZC    151         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_88_E   DS    0H  &TYPE
*            DIVIDE LB2 INTO Q1  IF LB3 = Q1  PERFORM G ELSE PERFORM B.
*ZC    152         DIVIDE LB2,INTO,Q1
         MVC   ZCVT_NDDX,Q1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R0
         LGR   ZC_R3,ZC_R1
         LMG   ZC_R0,ZC_R1,ZCVT_NDDX
         L     ZC_R15,ZCVT_DIVQ128 DIVIDE SCALED DIVIDEND BY QUOTIENT
         BASR  ZC_R14,ZC_R15
         LTGR  ZC_R0,ZC_R0
         JNM   ZC_LPQR_6
         XG    ZC_R0,ZCVT_HIGH_VALUES
         XG    ZC_R0+1,ZCVT_HIGH_VALUES
         ALGFI ZC_R0+1,1
         ALCG  ZC_R0,ZCVT_ZERO
ZC_LPQR_6            DS 0H
         STMG  ZC_R2,ZC_R3,Q1
*ZC    152         IF    LB3,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB3
         LD    ZC_F2,8+LB3
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LB'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXBR  ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_89_1
*ZC    152         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    152         ELSE
         J     PG_IF_89_E
PG_IF_89_1   DS    0H  &TYPE
*ZC    152         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_89_E   DS    0H  &TYPE
*            DIVIDE LB2 INTO Z1  IF LB3 = Z1  PERFORM G ELSE PERFORM B.
*ZC    153         DIVIDE LB2,INTO,Z1
         PACK  ZCVT_PWORK1(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z1(3)  PACK #3 FINAL
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG    ZC_R0,ZC_R2,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         UNPK  0+Z1(15),0+ZCVT_PWORK4(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK4(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK4(2) UNPK #3 FINAL
*ZC    153         IF    LB3,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB3
         LD    ZC_F2,8+LB3
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LB'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXBR  ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_90_1
*ZC    153         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    153         ELSE
         J     PG_IF_90_E
PG_IF_90_1   DS    0H  &TYPE
*ZC    153         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_90_E   DS    0H  &TYPE
*            PERFORM INIT.
*ZC    154         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            DIVIDE ED2 INTO EH1 IF ED3 = EH1 PERFORM G ELSE PERFORM B.
*ZC    155         DIVIDE ED2,INTO,EH1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         DER   0,1
         STE   ZC_F0,EH1
*ZC    155         IF    ED3,=,EH1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_91_1
*ZC    155         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    155         ELSE
         J     PG_IF_91_E
PG_IF_91_1   DS    0H  &TYPE
*ZC    155         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_91_E   DS    0H  &TYPE
*            DIVIDE ED2 INTO DH1 IF ED3 = DH1 PERFORM G ELSE PERFORM B.
*ZC    156         DIVIDE ED2,INTO,DH1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DH1
         DDR   0,1
         STD   ZC_F0,DH1
*ZC    156         IF    ED3,=,DH1
         LD    ZC_F4,DH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_92_1
*ZC    156         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    156         ELSE
         J     PG_IF_92_E
PG_IF_92_1   DS    0H  &TYPE
*ZC    156         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_92_E   DS    0H  &TYPE
*            DIVIDE ED2 INTO LH1 IF ED3 = LH1 PERFORM G ELSE PERFORM B.
*ZC    157         DIVIDE ED2,INTO,LH1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LH1
         LD    ZC_F2,8+LH1
         DXR   ZC_F0,ZC_F1
         STD   ZC_F0,LH1
         STD   ZC_F2,8+LH1
*ZC    157         IF    ED3,=,LH1
         LD    ZC_F4,LH1
         LD    ZC_F6,8+LH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_93_1
*ZC    157         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    157         ELSE
         J     PG_IF_93_E
PG_IF_93_1   DS    0H  &TYPE
*ZC    157         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_93_E   DS    0H  &TYPE
*            DIVIDE ED2 INTO EB1 IF ED3 = EB1 PERFORM G ELSE PERFORM B.
*ZC    158         DIVIDE ED2,INTO,EB1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB1
         DEBR  0,1
         STE   ZC_F0,EB1
*ZC    158         IF    ED3,=,EB1
         LE    ZC_F4,EB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_94_1
*ZC    158         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    158         ELSE
         J     PG_IF_94_E
PG_IF_94_1   DS    0H  &TYPE
*ZC    158         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_94_E   DS    0H  &TYPE
*            DIVIDE ED2 INTO DB1 IF ED3 = DB1 PERFORM G ELSE PERFORM B.
*ZC    159         DIVIDE ED2,INTO,DB1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB1
         DDBR  0,1
         STD   ZC_F0,DB1
*ZC    159         IF    ED3,=,DB1
         LD    ZC_F4,DB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_95_1
*ZC    159         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    159         ELSE
         J     PG_IF_95_E
PG_IF_95_1   DS    0H  &TYPE
*ZC    159         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_95_E   DS    0H  &TYPE
*            DIVIDE ED2 INTO LB1 IF ED3 = LB1 PERFORM G ELSE PERFORM B.
*ZC    160         DIVIDE ED2,INTO,LB1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB1
         LD    ZC_F2,8+LB1
         DXBR  ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LDR   ZC_F0,ZC_F4
         LDR   ZC_F2,ZC_F6
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC    160         IF    ED3,=,LB1
         LD    ZC_F4,LB1
         LD    ZC_F6,8+LB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_96_1
*ZC    160         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    160         ELSE
         J     PG_IF_96_E
PG_IF_96_1   DS    0H  &TYPE
*ZC    160         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_96_E   DS    0H  &TYPE
*            DIVIDE ED2 INTO ED1 IF ED3 = ED1 PERFORM G ELSE PERFORM B.
*ZC    161         DIVIDE ED2,INTO,ED1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED1
         LDETR ZC_F0,ZC_F0,0
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_ED,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         STE   ZC_F0,ED1
*ZC    161         IF    ED3,=,ED1
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_97_1
*ZC    161         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    161         ELSE
         J     PG_IF_97_E
PG_IF_97_1   DS    0H  &TYPE
*ZC    161         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_97_E   DS    0H  &TYPE
*            DIVIDE ED2 INTO DD1 IF ED3 = DD1 PERFORM G ELSE PERFORM B.
*ZC    162         DIVIDE ED2,INTO,DD1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD1
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F0,ZC_F4
         STD   ZC_F0,DD1
*ZC    162         IF    ED3,=,DD1
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_98_1
*ZC    162         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    162         ELSE
         J     PG_IF_98_E
PG_IF_98_1   DS    0H  &TYPE
*ZC    162         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_98_E   DS    0H  &TYPE
*            DIVIDE ED2 INTO LD1 IF ED3 = LD1 PERFORM G ELSE PERFORM B.
*ZC    163         DIVIDE ED2,INTO,LD1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD1
         LD    ZC_F2,8+LD1
         DXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,LD1
         STD   ZC_F2,8+LD1
*ZC    163         IF    ED3,=,LD1
         LD    ZC_F4,LD1
         LD    ZC_F6,8+LD1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_99_1
*ZC    163         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    163         ELSE
         J     PG_IF_99_E
PG_IF_99_1   DS    0H  &TYPE
*ZC    163         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_99_E   DS    0H  &TYPE
*            DIVIDE ED2 INTO F1  IF ED3 = F1  PERFORM G ELSE PERFORM B.
*ZC    164         DIVIDE ED2,INTO,F1
         MVC   ZCVT_NDDX(4),F1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R1 IGNORE HIGH 96 BITS
         LGF   ZC_R1,ZCVT_NDDX
         DSGR    0,2
         ST    1,F1
*ZC    164         IF    ED3,=,F1
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         L     ZC_R1,F1
         CDFTR ZC_F1,0,ZC_R1,0
         LARL  ZC_R2,=DD'1E1'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_100_1
*ZC    164         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    164         ELSE
         J     PG_IF_100_E
PG_IF_100_1  DS    0H  &TYPE
*ZC    164         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_100_E  DS    0H  &TYPE
*            DIVIDE ED2 INTO G1  IF ED3 = G1  PERFORM G ELSE PERFORM B.
*ZC    165         DIVIDE ED2,INTO,G1
         MVC   ZCVT_NDDX(8),G1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
                 LGR ZC_R2,ZC_R1 IGNORE HIGH 64 BITS
         LG    1,ZCVT_NDDX
         DSGR    0,2
         STG   1,G1
*ZC    165         IF    ED3,=,G1
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         LG    ZC_R1,G1
         CDGTR ZC_F1,ZC_R1
         LARL  ZC_R2,=DD'1E1'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_101_1
*ZC    165         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    165         ELSE
         J     PG_IF_101_E
PG_IF_101_1  DS    0H  &TYPE
*ZC    165         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_101_E  DS    0H  &TYPE
*            DIVIDE ED2 INTO H1  IF ED3 = H1  PERFORM G ELSE PERFORM B.
*ZC    166         DIVIDE ED2,INTO,H1
         MVC   ZCVT_NDDX(2),H1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R1 IGNORE HIGH 96
         LGH   ZC_R1,ZCVT_NDDX
         DSGR    0,2
         STH   1,H1
*ZC    166         IF    ED3,=,H1
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         LH    ZC_R1,H1
         CDFTR ZC_F1,0,ZC_R1,0
         LARL  ZC_R2,=DD'1E1'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_102_1
*ZC    166         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    166         ELSE
         J     PG_IF_102_E
PG_IF_102_1  DS    0H  &TYPE
*ZC    166         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_102_E  DS    0H  &TYPE
*            DIVIDE ED2 INTO P1  IF ED3 = P1  PERFORM G ELSE PERFORM B.
*ZC    167         DIVIDE ED2,INTO,P1
         ZAP ZCVT_PWORK1(16),P1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG    ZC_R0,ZC_R2,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         ZAP   P1,ZCVT_PWORK4(16)
*ZC    167         IF    ED3,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         LARL  ZC_R2,=DD'1E1'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_103_1
*ZC    167         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    167         ELSE
         J     PG_IF_103_E
PG_IF_103_1  DS    0H  &TYPE
*ZC    167         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_103_E  DS    0H  &TYPE
*            DIVIDE ED2 INTO Q1  IF ED3 = Q1  PERFORM G ELSE PERFORM B.
*ZC    168         DIVIDE ED2,INTO,Q1
         MVC   ZCVT_NDDX,Q1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R0
         LGR   ZC_R3,ZC_R1
         LMG   ZC_R0,ZC_R1,ZCVT_NDDX
         L     ZC_R15,ZCVT_DIVQ128 DIVIDE SCALED DIVIDEND BY QUOTIENT
         BASR  ZC_R14,ZC_R15
         LTGR  ZC_R0,ZC_R0
         JNM   ZC_LPQR_7
         XG    ZC_R0,ZCVT_HIGH_VALUES
         XG    ZC_R0+1,ZCVT_HIGH_VALUES
         ALGFI ZC_R0+1,1
         ALCG  ZC_R0,ZCVT_ZERO
ZC_LPQR_7            DS 0H
         STMG  ZC_R2,ZC_R3,Q1
*ZC    168         IF    ED3,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         LARL  ZC_R2,=DD'1E1'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_104_1
*ZC    168         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    168         ELSE
         J     PG_IF_104_E
PG_IF_104_1  DS    0H  &TYPE
*ZC    168         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_104_E  DS    0H  &TYPE
*            DIVIDE ED2 INTO Z1  IF ED3 = Z1  PERFORM G ELSE PERFORM B.
*ZC    169         DIVIDE ED2,INTO,Z1
         PACK  ZCVT_PWORK1(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z1(3)  PACK #3 FINAL
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG    ZC_R0,ZC_R2,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         UNPK  0+Z1(15),0+ZCVT_PWORK4(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK4(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK4(2) UNPK #3 FINAL
*ZC    169         IF    ED3,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         LARL  ZC_R2,=DD'1E1'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_105_1
*ZC    169         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    169         ELSE
         J     PG_IF_105_E
PG_IF_105_1  DS    0H  &TYPE
*ZC    169         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_105_E  DS    0H  &TYPE
*            PERFORM INIT.
*ZC    170         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            DIVIDE DD2 INTO EH1 IF DD3 = EH1 PERFORM G ELSE PERFORM B.
*ZC    171         DIVIDE DD2,INTO,EH1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         DER   0,1
         STE   ZC_F0,EH1
*ZC    171         IF    DD3,=,EH1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD3
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_106_1
*ZC    171         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    171         ELSE
         J     PG_IF_106_E
PG_IF_106_1  DS    0H  &TYPE
*ZC    171         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_106_E  DS    0H  &TYPE
*            DIVIDE DD2 INTO DH1 IF DD3 = DH1 PERFORM G ELSE PERFORM B.
*ZC    172         DIVIDE DD2,INTO,DH1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DH1
         DDR   0,1
         STD   ZC_F0,DH1
*ZC    172         IF    DD3,=,DH1
         LD    ZC_F4,DH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD3
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_107_1
*ZC    172         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    172         ELSE
         J     PG_IF_107_E
PG_IF_107_1  DS    0H  &TYPE
*ZC    172         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_107_E  DS    0H  &TYPE
*            DIVIDE DD2 INTO LH1 IF DD3 = LH1 PERFORM G ELSE PERFORM B.
*ZC    173         DIVIDE DD2,INTO,LH1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LH1
         LD    ZC_F2,8+LH1
         DXR   ZC_F0,ZC_F1
         STD   ZC_F0,LH1
         STD   ZC_F2,8+LH1
*ZC    173         IF    DD3,=,LH1
         LD    ZC_F4,LH1
         LD    ZC_F6,8+LH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD3
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_108_1
*ZC    173         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    173         ELSE
         J     PG_IF_108_E
PG_IF_108_1  DS    0H  &TYPE
*ZC    173         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_108_E  DS    0H  &TYPE
*            DIVIDE DD2 INTO EB1 IF DD3 = EB1 PERFORM G ELSE PERFORM B.
*ZC    174         DIVIDE DD2,INTO,EB1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB1
         DEBR  0,1
         STE   ZC_F0,EB1
*ZC    174         IF    DD3,=,EB1
         LE    ZC_F4,EB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD3
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_109_1
*ZC    174         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    174         ELSE
         J     PG_IF_109_E
PG_IF_109_1  DS    0H  &TYPE
*ZC    174         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_109_E  DS    0H  &TYPE
*            DIVIDE DD2 INTO DB1 IF DD3 = DB1 PERFORM G ELSE PERFORM B.
*ZC    175         DIVIDE DD2,INTO,DB1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB1
         DDBR  0,1
         STD   ZC_F0,DB1
*ZC    175         IF    DD3,=,DB1
         LD    ZC_F4,DB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD3
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_110_1
*ZC    175         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    175         ELSE
         J     PG_IF_110_E
PG_IF_110_1  DS    0H  &TYPE
*ZC    175         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_110_E  DS    0H  &TYPE
*            DIVIDE DD2 INTO LB1 IF DD3 = LB1 PERFORM G ELSE PERFORM B.
*ZC    176         DIVIDE DD2,INTO,LB1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB1
         LD    ZC_F2,8+LB1
         DXBR  ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LDR   ZC_F0,ZC_F4
         LDR   ZC_F2,ZC_F6
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC    176         IF    DD3,=,LB1
         LD    ZC_F4,LB1
         LD    ZC_F6,8+LB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD3
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_111_1
*ZC    176         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    176         ELSE
         J     PG_IF_111_E
PG_IF_111_1  DS    0H  &TYPE
*ZC    176         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_111_E  DS    0H  &TYPE
*            DIVIDE DD2 INTO ED1 IF DD3 = ED1 PERFORM G ELSE PERFORM B.
*ZC    177         DIVIDE DD2,INTO,ED1
         LD    ZC_F0,DD2
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED1
         LDETR ZC_F0,ZC_F0,0
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_ED,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         STE   ZC_F0,ED1
*ZC    177         IF    DD3,=,ED1
         LE    ZC_F4,ED1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD3
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_112_1
*ZC    177         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    177         ELSE
         J     PG_IF_112_E
PG_IF_112_1  DS    0H  &TYPE
*ZC    177         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_112_E  DS    0H  &TYPE
*            DIVIDE DD2 INTO DD1 IF DD3 = DD1 PERFORM G ELSE PERFORM B.
*ZC    178         DIVIDE DD2,INTO,DD1
         LD    ZC_F0,DD2
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD1
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F0,ZC_F4
         STD   ZC_F0,DD1
*ZC    178         IF    DD3,=,DD1
         LD    ZC_F0,DD3
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_113_1
*ZC    178         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    178         ELSE
         J     PG_IF_113_E
PG_IF_113_1  DS    0H  &TYPE
*ZC    178         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_113_E  DS    0H  &TYPE
*            DIVIDE DD2 INTO LD1 IF DD3 = LD1 PERFORM G ELSE PERFORM B.
*ZC    179         DIVIDE DD2,INTO,LD1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD1
         LD    ZC_F2,8+LD1
         DXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,LD1
         STD   ZC_F2,8+LD1
*ZC    179         IF    DD3,=,LD1
         LD    ZC_F4,LD1
         LD    ZC_F6,8+LD1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD3
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_114_1
*ZC    179         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    179         ELSE
         J     PG_IF_114_E
PG_IF_114_1  DS    0H  &TYPE
*ZC    179         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_114_E  DS    0H  &TYPE
*            DIVIDE DD2 INTO F1  IF DD3 = F1  PERFORM G ELSE PERFORM B.
*ZC    180         DIVIDE DD2,INTO,F1
         MVC   ZCVT_NDDX(4),F1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R1 IGNORE HIGH 96 BITS
         LGF   ZC_R1,ZCVT_NDDX
         DSGR    0,2
         ST    1,F1
*ZC    180         IF    DD3,=,F1
         LD    ZC_F0,DD3
         L     ZC_R1,F1
         CDFTR ZC_F1,0,ZC_R1,0
         LARL  ZC_R2,=DD'1E1'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_115_1
*ZC    180         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    180         ELSE
         J     PG_IF_115_E
PG_IF_115_1  DS    0H  &TYPE
*ZC    180         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_115_E  DS    0H  &TYPE
*            DIVIDE DD2 INTO G1  IF DD3 = G1  PERFORM G ELSE PERFORM B.
*ZC    181         DIVIDE DD2,INTO,G1
         MVC   ZCVT_NDDX(8),G1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
                 LGR ZC_R2,ZC_R1 IGNORE HIGH 64 BITS
         LG    1,ZCVT_NDDX
         DSGR    0,2
         STG   1,G1
*ZC    181         IF    DD3,=,G1
         LD    ZC_F0,DD3
         LG    ZC_R1,G1
         CDGTR ZC_F1,ZC_R1
         LARL  ZC_R2,=DD'1E1'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_116_1
*ZC    181         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    181         ELSE
         J     PG_IF_116_E
PG_IF_116_1  DS    0H  &TYPE
*ZC    181         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_116_E  DS    0H  &TYPE
*            DIVIDE DD2 INTO H1  IF DD3 = H1  PERFORM G ELSE PERFORM B.
*ZC    182         DIVIDE DD2,INTO,H1
         MVC   ZCVT_NDDX(2),H1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R1 IGNORE HIGH 96
         LGH   ZC_R1,ZCVT_NDDX
         DSGR    0,2
         STH   1,H1
*ZC    182         IF    DD3,=,H1
         LD    ZC_F0,DD3
         LH    ZC_R1,H1
         CDFTR ZC_F1,0,ZC_R1,0
         LARL  ZC_R2,=DD'1E1'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_117_1
*ZC    182         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    182         ELSE
         J     PG_IF_117_E
PG_IF_117_1  DS    0H  &TYPE
*ZC    182         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_117_E  DS    0H  &TYPE
*            DIVIDE DD2 INTO P1  IF DD3 = P1  PERFORM G ELSE PERFORM B.
*ZC    183         DIVIDE DD2,INTO,P1
         ZAP ZCVT_PWORK1(16),P1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG    ZC_R0,ZC_R2,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         ZAP   P1,ZCVT_PWORK4(16)
*ZC    183         IF    DD3,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD3
         LARL  ZC_R2,=DD'1E1'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_118_1
*ZC    183         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    183         ELSE
         J     PG_IF_118_E
PG_IF_118_1  DS    0H  &TYPE
*ZC    183         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_118_E  DS    0H  &TYPE
*            DIVIDE DD2 INTO Q1  IF DD3 = Q1  PERFORM G ELSE PERFORM B.
*ZC    184         DIVIDE DD2,INTO,Q1
         MVC   ZCVT_NDDX,Q1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R0
         LGR   ZC_R3,ZC_R1
         LMG   ZC_R0,ZC_R1,ZCVT_NDDX
         L     ZC_R15,ZCVT_DIVQ128 DIVIDE SCALED DIVIDEND BY QUOTIENT
         BASR  ZC_R14,ZC_R15
         LTGR  ZC_R0,ZC_R0
         JNM   ZC_LPQR_8
         XG    ZC_R0,ZCVT_HIGH_VALUES
         XG    ZC_R0+1,ZCVT_HIGH_VALUES
         ALGFI ZC_R0+1,1
         ALCG  ZC_R0,ZCVT_ZERO
ZC_LPQR_8            DS 0H
         STMG  ZC_R2,ZC_R3,Q1
*ZC    184         IF    DD3,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD3
         LARL  ZC_R2,=DD'1E1'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_119_1
*ZC    184         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    184         ELSE
         J     PG_IF_119_E
PG_IF_119_1  DS    0H  &TYPE
*ZC    184         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_119_E  DS    0H  &TYPE
*            DIVIDE DD2 INTO Z1  IF DD3 = Z1  PERFORM G ELSE PERFORM B.
*ZC    185         DIVIDE DD2,INTO,Z1
         PACK  ZCVT_PWORK1(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z1(3)  PACK #3 FINAL
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG    ZC_R0,ZC_R2,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         UNPK  0+Z1(15),0+ZCVT_PWORK4(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK4(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK4(2) UNPK #3 FINAL
*ZC    185         IF    DD3,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F0,ZC_R0
         LDXTR ZC_F1,0,ZC_F0,0
         LD    ZC_F0,DD3
         LARL  ZC_R2,=DD'1E1'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_120_1
*ZC    185         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    185         ELSE
         J     PG_IF_120_E
PG_IF_120_1  DS    0H  &TYPE
*ZC    185         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_120_E  DS    0H  &TYPE
*            PERFORM INIT.
*ZC    186         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            DIVIDE LD2 INTO EH1 IF LD3 = EH1 PERFORM G ELSE PERFORM B.
*ZC    187         DIVIDE LD2,INTO,EH1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         DER   0,1
         STE   ZC_F0,EH1
*ZC    187         IF    LD3,=,EH1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD3
         LD    ZC_F2,8+LD3
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_121_1
*ZC    187         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    187         ELSE
         J     PG_IF_121_E
PG_IF_121_1  DS    0H  &TYPE
*ZC    187         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_121_E  DS    0H  &TYPE
*            DIVIDE LD2 INTO DH1 IF LD3 = DH1 PERFORM G ELSE PERFORM B.
*ZC    188         DIVIDE LD2,INTO,DH1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DH1
         DDR   0,1
         STD   ZC_F0,DH1
*ZC    188         IF    LD3,=,DH1
         LD    ZC_F4,DH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD3
         LD    ZC_F2,8+LD3
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_122_1
*ZC    188         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    188         ELSE
         J     PG_IF_122_E
PG_IF_122_1  DS    0H  &TYPE
*ZC    188         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_122_E  DS    0H  &TYPE
*            DIVIDE LD2 INTO LH1 IF LD3 = LH1 PERFORM G ELSE PERFORM B.
*ZC    189         DIVIDE LD2,INTO,LH1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LH1
         LD    ZC_F2,8+LH1
         DXR   ZC_F0,ZC_F1
         STD   ZC_F0,LH1
         STD   ZC_F2,8+LH1
*ZC    189         IF    LD3,=,LH1
         LD    ZC_F4,LH1
         LD    ZC_F6,8+LH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD3
         LD    ZC_F2,8+LD3
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_123_1
*ZC    189         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    189         ELSE
         J     PG_IF_123_E
PG_IF_123_1  DS    0H  &TYPE
*ZC    189         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_123_E  DS    0H  &TYPE
*            DIVIDE LD2 INTO EB1 IF LD3 = EB1 PERFORM G ELSE PERFORM B.
*ZC    190         DIVIDE LD2,INTO,EB1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB1
         DEBR  0,1
         STE   ZC_F0,EB1
*ZC    190         IF    LD3,=,EB1
         LE    ZC_F4,EB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD3
         LD    ZC_F2,8+LD3
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_124_1
*ZC    190         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    190         ELSE
         J     PG_IF_124_E
PG_IF_124_1  DS    0H  &TYPE
*ZC    190         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_124_E  DS    0H  &TYPE
*            DIVIDE LD2 INTO DB1 IF LD3 = DB1 PERFORM G ELSE PERFORM B.
*ZC    191         DIVIDE LD2,INTO,DB1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB1
         DDBR  0,1
         STD   ZC_F0,DB1
*ZC    191         IF    LD3,=,DB1
         LD    ZC_F4,DB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD3
         LD    ZC_F2,8+LD3
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_125_1
*ZC    191         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    191         ELSE
         J     PG_IF_125_E
PG_IF_125_1  DS    0H  &TYPE
*ZC    191         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_125_E  DS    0H  &TYPE
*            DIVIDE LD2 INTO LB1 IF LD3 = LB1 PERFORM G ELSE PERFORM B.
*ZC    192         DIVIDE LD2,INTO,LB1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB1
         LD    ZC_F2,8+LB1
         DXBR  ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LDR   ZC_F0,ZC_F4
         LDR   ZC_F2,ZC_F6
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC    192         IF    LD3,=,LB1
         LD    ZC_F4,LB1
         LD    ZC_F6,8+LB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD3
         LD    ZC_F2,8+LD3
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_126_1
*ZC    192         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    192         ELSE
         J     PG_IF_126_E
PG_IF_126_1  DS    0H  &TYPE
*ZC    192         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_126_E  DS    0H  &TYPE
*            DIVIDE LD2 INTO ED1 IF LD3 = ED1 PERFORM G ELSE PERFORM B.
*ZC    193         DIVIDE LD2,INTO,ED1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED1
         LDETR ZC_F0,ZC_F0,0
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_ED,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         STE   ZC_F0,ED1
*ZC    193         IF    LD3,=,ED1
         LE    ZC_F4,ED1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD3
         LD    ZC_F2,8+LD3
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_127_1
*ZC    193         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    193         ELSE
         J     PG_IF_127_E
PG_IF_127_1  DS    0H  &TYPE
*ZC    193         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_127_E  DS    0H  &TYPE
*            DIVIDE LD2 INTO DD1 IF LD3 = DD1 PERFORM G ELSE PERFORM B.
*ZC    194         DIVIDE LD2,INTO,DD1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD1
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F0,ZC_F4
         STD   ZC_F0,DD1
*ZC    194         IF    LD3,=,DD1
         LD    ZC_F4,DD1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD3
         LD    ZC_F2,8+LD3
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_128_1
*ZC    194         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    194         ELSE
         J     PG_IF_128_E
PG_IF_128_1  DS    0H  &TYPE
*ZC    194         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_128_E  DS    0H  &TYPE
*            DIVIDE LD2 INTO LD1 IF LD3 = LD1 PERFORM G ELSE PERFORM B.
*ZC    195         DIVIDE LD2,INTO,LD1
         LD    ZC_F0,LD2
         LD    ZC_F2,8+LD2
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD1
         LD    ZC_F2,8+LD1
         DXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,LD1
         STD   ZC_F2,8+LD1
*ZC    195         IF    LD3,=,LD1
         LD    ZC_F0,LD3
         LD    ZC_F2,8+LD3
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_129_1
*ZC    195         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    195         ELSE
         J     PG_IF_129_E
PG_IF_129_1  DS    0H  &TYPE
*ZC    195         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_129_E  DS    0H  &TYPE
*            DIVIDE LD2 INTO F1  IF LD3 = F1  PERFORM G ELSE PERFORM B.
*ZC    196         DIVIDE LD2,INTO,F1
         MVC   ZCVT_NDDX(4),F1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R1 IGNORE HIGH 96 BITS
         LGF   ZC_R1,ZCVT_NDDX
         DSGR    0,2
         ST    1,F1
*ZC    196         IF    LD3,=,F1
         LD    ZC_F0,LD3
         LD    ZC_F2,8+LD3
         L     ZC_F1,F1
         CXFTR ZC_F1,0,ZC_R1,0
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LD'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_130_1
*ZC    196         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    196         ELSE
         J     PG_IF_130_E
PG_IF_130_1  DS    0H  &TYPE
*ZC    196         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_130_E  DS    0H  &TYPE
*            DIVIDE LD2 INTO G1  IF LD3 = G1  PERFORM G ELSE PERFORM B.
*ZC    197         DIVIDE LD2,INTO,G1
         MVC   ZCVT_NDDX(8),G1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
                 LGR ZC_R2,ZC_R1 IGNORE HIGH 64 BITS
         LG    1,ZCVT_NDDX
         DSGR    0,2
         STG   1,G1
*ZC    197         IF    LD3,=,G1
         LD    ZC_F0,LD3
         LD    ZC_F2,8+LD3
         LG    ZC_F1,G1
         CXGTR ZC_F1,ZC_R1
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LD'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_131_1
*ZC    197         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    197         ELSE
         J     PG_IF_131_E
PG_IF_131_1  DS    0H  &TYPE
*ZC    197         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_131_E  DS    0H  &TYPE
*            DIVIDE LD2 INTO H1  IF LD3 = H1  PERFORM G ELSE PERFORM B.
*ZC    198         DIVIDE LD2,INTO,H1
         MVC   ZCVT_NDDX(2),H1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R1 IGNORE HIGH 96
         LGH   ZC_R1,ZCVT_NDDX
         DSGR    0,2
         STH   1,H1
*ZC    198         IF    LD3,=,H1
         LD    ZC_F0,LD3
         LD    ZC_F2,8+LD3
         LH    ZC_F1,H1
         CXFTR ZC_F1,0,ZC_R1,0
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LD'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_132_1
*ZC    198         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    198         ELSE
         J     PG_IF_132_E
PG_IF_132_1  DS    0H  &TYPE
*ZC    198         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_132_E  DS    0H  &TYPE
*            DIVIDE LD2 INTO P1  IF LD3 = P1  PERFORM G ELSE PERFORM B.
*ZC    199         DIVIDE LD2,INTO,P1
         ZAP ZCVT_PWORK1(16),P1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG    ZC_R0,ZC_R2,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         ZAP   P1,ZCVT_PWORK4(16)
*ZC    199         IF    LD3,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD3
         LD    ZC_F2,8+LD3
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LD'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXTR  ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_133_1
*ZC    199         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    199         ELSE
         J     PG_IF_133_E
PG_IF_133_1  DS    0H  &TYPE
*ZC    199         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_133_E  DS    0H  &TYPE
*            DIVIDE LD2 INTO Q1  IF LD3 = Q1  PERFORM G ELSE PERFORM B.
*ZC    200         DIVIDE LD2,INTO,Q1
         MVC   ZCVT_NDDX,Q1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R0
         LGR   ZC_R3,ZC_R1
         LMG   ZC_R0,ZC_R1,ZCVT_NDDX
         L     ZC_R15,ZCVT_DIVQ128 DIVIDE SCALED DIVIDEND BY QUOTIENT
         BASR  ZC_R14,ZC_R15
         LTGR  ZC_R0,ZC_R0
         JNM   ZC_LPQR_9
         XG    ZC_R0,ZCVT_HIGH_VALUES
         XG    ZC_R0+1,ZCVT_HIGH_VALUES
         ALGFI ZC_R0+1,1
         ALCG  ZC_R0,ZCVT_ZERO
ZC_LPQR_9            DS 0H
         STMG  ZC_R2,ZC_R3,Q1
*ZC    200         IF    LD3,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD3
         LD    ZC_F2,8+LD3
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LD'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXTR  ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_134_1
*ZC    200         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    200         ELSE
         J     PG_IF_134_E
PG_IF_134_1  DS    0H  &TYPE
*ZC    200         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_134_E  DS    0H  &TYPE
*            DIVIDE LD2 INTO Z1  IF LD3 = Z1  PERFORM G ELSE PERFORM B.
*ZC    201         DIVIDE LD2,INTO,Z1
         PACK  ZCVT_PWORK1(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z1(3)  PACK #3 FINAL
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG    ZC_R0,ZC_R2,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         UNPK  0+Z1(15),0+ZCVT_PWORK4(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK4(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK4(2) UNPK #3 FINAL
*ZC    201         IF    LD3,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         LD    ZC_F0,LD3
         LD    ZC_F2,8+LD3
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LD'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXTR  ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_135_1
*ZC    201         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    201         ELSE
         J     PG_IF_135_E
PG_IF_135_1  DS    0H  &TYPE
*ZC    201         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_135_E  DS    0H  &TYPE
*            PERFORM INIT.
*ZC    202         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            DIVIDE F2  INTO EH1 IF F3  = EH1 PERFORM G ELSE PERFORM B.
*ZC    203         DIVIDE F2,INTO,EH1
         L     ZC_R0,F2
         CEFR  ZC_F0,ZC_R0
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R15,=EH'1E3'
         ME    0,0(ZC_R15)
         DER   0,1
         STE   ZC_F0,EH1
*ZC    203         IF    F3,=,EH1
         L     ZC_R0,F3
         CEFR  ZC_F0,ZC_R0
         LE    ZC_F1,EH1
         LARL  ZC_R2,=EH'1E3'
         ME    ZC_R1,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_136_1
*ZC    203         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    203         ELSE
         J     PG_IF_136_E
PG_IF_136_1  DS    0H  &TYPE
*ZC    203         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_136_E  DS    0H  &TYPE
*            DIVIDE F2  INTO DH1 IF F3  = DH1 PERFORM G ELSE PERFORM B.
*ZC    204         DIVIDE F2,INTO,DH1
         L     ZC_R0,F2
         CDFR  ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DH1
         LARL  ZC_R15,=DH'1E3'
         MD    0,0(ZC_R15)
         DDR   0,1
         STD   ZC_F0,DH1
*ZC    204         IF    F3,=,DH1
         L     ZC_R0,F3
         CDFR  ZC_F0,ZC_R0
         LD    ZC_F1,DH1
         LARL  ZC_R2,=DH'1E3'
         MD    ZC_R1,0(ZC_R2)
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_137_1
*ZC    204         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    204         ELSE
         J     PG_IF_137_E
PG_IF_137_1  DS    0H  &TYPE
*ZC    204         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_137_E  DS    0H  &TYPE
*            DIVIDE F2  INTO LH1 IF F3  = LH1 PERFORM G ELSE PERFORM B.
*ZC    205         DIVIDE F2,INTO,LH1
         L     ZC_R0,F2
         CXFR  ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LH1
         LD    ZC_F2,8+LH1
         LARL  ZC_R15,=LH'1E3'
         LD    ZC_F4,0(ZC_R15)
         LD    ZC_F6,8(ZC_R15)
         MXR   ZC_F0,ZC_F4
         DXR   ZC_F0,ZC_F1
         STD   ZC_F0,LH1
         STD   ZC_F2,8+LH1
*ZC    205         IF    F3,=,LH1
         L     ZC_R0,F3
         CXFR  ZC_F0,ZC_R0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         STD   ZC_F0,ZCVT_PWORK
         STD   ZC_F2,ZCVT_PWORK+8
         LARL  ZC_R2,=LH'1E3'
         LD    ZC_F0,0(ZC_R2)
         LD    ZC_F2,8(ZC_R2)
         MXR   ZC_F1,ZC_F0
         LD    ZC_F0,ZCVT_PWORK
         LD    ZC_F2,ZCVT_PWORK+8
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_138_1
*ZC    205         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    205         ELSE
         J     PG_IF_138_E
PG_IF_138_1  DS    0H  &TYPE
*ZC    205         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_138_E  DS    0H  &TYPE
*            DIVIDE F2  INTO EB1 IF F3  = EB1 PERFORM G ELSE PERFORM B.
*ZC    206         DIVIDE F2,INTO,EB1
         L     ZC_R0,F2
         CEFBR ZC_F0,ZC_R0
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB1
         LARL  ZC_R15,=EB'1E3'
         MEEB  ZC_F0,0(ZC_R15)
         DEBR  0,1
         STE   ZC_F0,EB1
*ZC    206         IF    F3,=,EB1
         L     ZC_R0,F3
         CEFBR ZC_F0,ZC_R0
         LE    ZC_F1,EB1
         LARL  ZC_R2,=EB'1E3'
         MDEB  ZC_F1,0(ZC_R2)
         LEDBR ZC_F1,ZC_F1
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_139_1
*ZC    206         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    206         ELSE
         J     PG_IF_139_E
PG_IF_139_1  DS    0H  &TYPE
*ZC    206         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_139_E  DS    0H  &TYPE
*            DIVIDE F2  INTO DB1 IF F3  = DB1 PERFORM G ELSE PERFORM B.
*ZC    207         DIVIDE F2,INTO,DB1
         L     ZC_R0,F2
         CDFBR ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB1
         LARL  ZC_R15,=DB'1E3'
         MDB   0,0(ZC_R15)
         DDBR  0,1
         STD   ZC_F0,DB1
*ZC    207         IF    F3,=,DB1
         L     ZC_R0,F3
         CDFBR ZC_F0,ZC_R0
         LD    ZC_F1,DB1
         LARL  ZC_R2,=DB'1E3'
         MDB   ZC_R1,0(ZC_R2)
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_140_1
*ZC    207         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    207         ELSE
         J     PG_IF_140_E
PG_IF_140_1  DS    0H  &TYPE
*ZC    207         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_140_E  DS    0H  &TYPE
*            DIVIDE F2  INTO LB1 IF F3  = LB1 PERFORM G ELSE PERFORM B.
*ZC    208         DIVIDE F2,INTO,LB1
         L     ZC_R0,F2
         CXFBR ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB1
         LD    ZC_F2,8+LB1
         LARL  ZC_R15,=LB'1E3'
         LD    ZC_F4,0(ZC_R15)
         LD    ZC_F6,8(ZC_R15)
         MXBR  ZC_F0,ZC_F4
         DXBR  ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LDR   ZC_F0,ZC_F4
         LDR   ZC_F2,ZC_F6
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC    208         IF    F3,=,LB1
         L     ZC_R0,F3
         CXFBR ZC_F0,ZC_R0
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         STD   ZC_F0,ZCVT_PWORK
         STD   ZC_F2,ZCVT_PWORK+8
         LARL  ZC_R2,=LB'1E3'
         LD    ZC_F0,0(ZC_R2)
         LD    ZC_F2,8(ZC_R2)
         MXBR  ZC_F1,ZC_F0
         LD    ZC_F0,ZCVT_PWORK
         LD    ZC_F2,ZCVT_PWORK+8
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_141_1
*ZC    208         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    208         ELSE
         J     PG_IF_141_E
PG_IF_141_1  DS    0H  &TYPE
*ZC    208         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_141_E  DS    0H  &TYPE
*            DIVIDE F2  INTO ED1 IF F3  = ED1 PERFORM G ELSE PERFORM B.
*ZC    209         DIVIDE F2,INTO,ED1
         LGF   ZC_R0,F2
         CDGTR ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED1
         LDETR ZC_F0,ZC_F0,0
         LARL  ZC_R2,=DD'1E3'
         LD    ZC_F4,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F4
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_ED,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         STE   ZC_F0,ED1
*ZC    209         IF    F3,=,ED1
         L     ZC_R0,F3
         CDFTR ZC_F0,0,ZC_R0,0
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         LARL  ZC_R2,=DD'1E3'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F1,ZC_F1,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_142_1
*ZC    209         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    209         ELSE
         J     PG_IF_142_E
PG_IF_142_1  DS    0H  &TYPE
*ZC    209         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_142_E  DS    0H  &TYPE
*            DIVIDE F2  INTO DD1 IF EH3 = DD1 PERFORM G ELSE PERFORM B.
*ZC    210         DIVIDE F2,INTO,DD1
         LGF   ZC_R0,F2
         CDGTR ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD1
         LARL  ZC_R2,=DD'1E3'
         LD    ZC_F4,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F4
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F0,ZC_F4
         STD   ZC_F0,DD1
*ZC    210         IF    EH3,=,DD1
         LE    ZC_F4,EH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_143_1
*ZC    210         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    210         ELSE
         J     PG_IF_143_E
PG_IF_143_1  DS    0H  &TYPE
*ZC    210         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_143_E  DS    0H  &TYPE
*            DIVIDE F2  INTO LD1 IF EH3 = LD1 PERFORM G ELSE PERFORM B.
*ZC    211         DIVIDE F2,INTO,LD1
         LGF   ZC_R0,F2
         CXGTR ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD1
         LD    ZC_F2,8+LD1
         LARL  ZC_R15,=LD'1E3'
         LD    ZC_F4,0(ZC_R15)
         LD    ZC_F6,8(ZC_R15)
         MXTR  ZC_F0,ZC_F0,ZC_F4
         DXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,LD1
         STD   ZC_F2,8+LD1
*ZC    211         IF    EH3,=,LD1
         LE    ZC_F4,EH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_144_1
*ZC    211         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    211         ELSE
         J     PG_IF_144_E
PG_IF_144_1  DS    0H  &TYPE
*ZC    211         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_144_E  DS    0H  &TYPE
*            DIVIDE F2  INTO F1  IF F3  = F1  PERFORM G ELSE PERFORM B.
*ZC    212         DIVIDE F2,INTO,F1
         MVC   ZCVT_NDDX(4),F1
         LGF   ZC_R2,F2
         LGF   ZC_R1,ZCVT_NDDX
         LARL  ZC_R15,=FL8'1E3'
         MSG   1,0(ZC_R15)
         DSGR    0,2
         ST    1,F1
*ZC    212         IF    F3,=,F1
         L     ZC_R0,F3
         L     ZC_R1,F1
         LARL  ZC_R2,=F'1E2'
         MS    ZC_R1,0(ZC_R2)
         CR    ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_145_1
*ZC    212         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    212         ELSE
         J     PG_IF_145_E
PG_IF_145_1  DS    0H  &TYPE
*ZC    212         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_145_E  DS    0H  &TYPE
*            DIVIDE F2  INTO G1  IF F3  = G1  PERFORM G ELSE PERFORM B.
*ZC    213         DIVIDE F2,INTO,G1
         MVC   ZCVT_NDDX(8),G1
         LGF   2,F2
         LG    1,ZCVT_NDDX
         LARL  ZC_R15,=FL8'1E3'
         MSG   1,0(ZC_R15)
         DSGR    0,2
         STG   1,G1
*ZC    213         IF    F3,=,G1
         LGF   ZC_R0,F3
         LG    ZC_R1,G1
         LARL  ZC_R2,=FL8'1E2'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_146_1
*ZC    213         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    213         ELSE
         J     PG_IF_146_E
PG_IF_146_1  DS    0H  &TYPE
*ZC    213         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_146_E  DS    0H  &TYPE
*            DIVIDE F2  INTO H1  IF F3  = H1  PERFORM G ELSE PERFORM B.
*ZC    214         DIVIDE F2,INTO,H1
         MVC   ZCVT_NDDX(2),H1
         LGF   ZC_R2,F2
         LGH   ZC_R1,ZCVT_NDDX
         LARL  ZC_R15,=FL8'1E3'
         MSG   1,0(ZC_R15)
         DSGR    0,2
         STH   1,H1
*ZC    214         IF    F3,=,H1
         L     ZC_R0,F3
         LH    ZC_R1,H1
         LARL  ZC_R2,=F'1E2'
         MS    ZC_R1,0(ZC_R2)
         CR    ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_147_1
*ZC    214         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    214         ELSE
         J     PG_IF_147_E
PG_IF_147_1  DS    0H  &TYPE
*ZC    214         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_147_E  DS    0H  &TYPE
*            DIVIDE F2  INTO P1  IF F3  = P1  PERFORM G ELSE PERFORM B.
*ZC    215         DIVIDE F2,INTO,P1
         ZAP ZCVT_PWORK1(16),P1
         L     0,F2
         CVD   0,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         ZAP   ZCVT_PWORK4,ZCVT_PWORK2(8)
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK4
         CXSTR ZC_F1,ZC_R0
         LARL  ZC_R2,=LD'1E3'
         LD    ZC_F4,0(ZC_R2)
         LD    ZC_F6,8(ZC_R2)
         MXTR  ZC_F0,ZC_F0,ZC_F4
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         ZAP   P1,ZCVT_PWORK4(16)
*ZC    215         IF    F3,=,P1
         LGF   ZC_R0,F3
         ZAP   ZCVT_PWORK2,P1
         CVBG  ZC_R1,ZCVT_PWORK2
         LARL  ZC_R2,=FL8'1E2'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_148_1
*ZC    215         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    215         ELSE
         J     PG_IF_148_E
PG_IF_148_1  DS    0H  &TYPE
*ZC    215         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_148_E  DS    0H  &TYPE
*            DIVIDE F2  INTO Q1  IF F3  = Q1  PERFORM G ELSE PERFORM B.
*ZC    216         DIVIDE F2,INTO,Q1
         MVC   ZCVT_NDDX,Q1
         LGF   ZC_R3,F2
         SGR   ZC_R2,ZC_R2
         LMG   ZC_R0,ZC_R1,ZCVT_NDDX
         STMG  ZC_R2,ZC_R3,ZCVT_WORKAREA
         LARL  ZC_R15,=FL16'1E3'
         LMG   ZC_R2,ZC_R3,0(ZC_R15)
         L     ZC_R15,ZCVT_MPYQ128      MPY DIVIDEND
         BASR  ZC_R14,ZC_R15
         LMG   ZC_R2,ZC_R3,ZCVT_WORKAREA   REST0RE DIVISOR
         L     ZC_R15,ZCVT_DIVQ128 DIVIDE SCALED DIVIDEND BY QUOTIENT
         BASR  ZC_R14,ZC_R15
         LTGR  ZC_R0,ZC_R0
         JNM   ZC_LPQR_10
         XG    ZC_R0,ZCVT_HIGH_VALUES
         XG    ZC_R0+1,ZCVT_HIGH_VALUES
         ALGFI ZC_R0+1,1
         ALCG  ZC_R0,ZCVT_ZERO
ZC_LPQR_10           DS 0H
         STMG  ZC_R2,ZC_R3,Q1
*ZC    216         IF    F3,=,Q1
         LGF   ZC_R1,F3
         LGR   ZC_R0,ZC_R1
         SRAG  ZC_R0,ZC_R0,63  SIGN FILL HIGH 64
         LG    ZC_R2,Q1
         LG    ZC_R3,8+Q1
                  STMG  ZC_R0,ZC_R1,ZCVT_PWORK1
                  LGR   ZC_R0,ZC_R2
                  LGR   ZC_R1,ZC_R3
                  LARL  ZC_R2,=FL8'1E2'
                  LG    ZC_R3,0(ZC_R2)
                  SGR   ZC_R2,ZC_R2
                  L     ZC_R15,ZCVT_MPYQ128
                  BALR  ZC_R14,ZC_R15
                  LGR   ZC_R2,ZC_R0
                  LGR   ZC_R3,ZC_R1
                  LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CGR   ZC_R0,ZC_R2
         JNZ   *+4+4
         CGR   ZC_R0+1,ZC_R2+1
         BRC   15-ZC_EQ,PG_IF_149_1
*ZC    216         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    216         ELSE
         J     PG_IF_149_E
PG_IF_149_1  DS    0H  &TYPE
*ZC    216         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_149_E  DS    0H  &TYPE
*            DIVIDE F2  INTO Z1  IF F3  = Z1  PERFORM G ELSE PERFORM B.
*ZC    217         DIVIDE F2,INTO,Z1
         PACK  ZCVT_PWORK1(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z1(3)  PACK #3 FINAL
         L     0,F2
         CVD   0,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         ZAP   ZCVT_PWORK4,ZCVT_PWORK2(8)
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK4
         CXSTR ZC_F1,ZC_R0
         LARL  ZC_R2,=LD'1E3'
         LD    ZC_F4,0(ZC_R2)
         LD    ZC_F6,8(ZC_R2)
         MXTR  ZC_F0,ZC_F0,ZC_F4
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         UNPK  0+Z1(15),0+ZCVT_PWORK4(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK4(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK4(2) UNPK #3 FINAL
*ZC    217         IF    F3,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R0
         LGR   ZC_R3,ZC_R1
         LGF   ZC_R1,F3
         LGR   ZC_R0,ZC_R1
         SRAG  ZC_R0,ZC_R0,63 SET SIGN FROM R1
                  STMG  ZC_R0,ZC_R1,ZCVT_PWORK1
                  LGR   ZC_R0,ZC_R2
                  LGR   ZC_R1,ZC_R3
                  LARL  ZC_R2,=FL8'1E2'
                  LG    ZC_R3,0(ZC_R2)
                  SGR   ZC_R2,ZC_R2
                  L     ZC_R15,ZCVT_MPYQ128
                  BALR  ZC_R14,ZC_R15
                  LGR   ZC_R2,ZC_R0
                  LGR   ZC_R3,ZC_R1
                  LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CGR   ZC_R0,ZC_R2
         JNZ   *+4+4
         CGR   ZC_R0+1,ZC_R2+1
         BRC   15-ZC_EQ,PG_IF_150_1
*ZC    217         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    217         ELSE
         J     PG_IF_150_E
PG_IF_150_1  DS    0H  &TYPE
*ZC    217         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_150_E  DS    0H  &TYPE
*            PERFORM INIT.
*ZC    218         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            DIVIDE G2  INTO EH1 IF G3  = EH1 PERFORM G ELSE PERFORM B.
*ZC    219         DIVIDE G2,INTO,EH1
         LG    ZC_R0,G2
         CEGR  ZC_F0,ZC_R0
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R15,=EH'1E4'
         ME    0,0(ZC_R15)
         DER   0,1
         STE   ZC_F0,EH1
*ZC    219         IF    G3,=,EH1
         LG    ZC_R0,G3
         CEGR  ZC_F0,ZC_R0
         LE    ZC_F1,EH1
         LARL  ZC_R2,=EH'1E4'
         ME    ZC_R1,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_151_1
*ZC    219         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    219         ELSE
         J     PG_IF_151_E
PG_IF_151_1  DS    0H  &TYPE
*ZC    219         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_151_E  DS    0H  &TYPE
*            DIVIDE G2  INTO DH1 IF G3  = DH1 PERFORM G ELSE PERFORM B.
*ZC    220         DIVIDE G2,INTO,DH1
         LG    ZC_R0,G2
         CDGR  ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DH1
         LARL  ZC_R15,=DH'1E4'
         MD    0,0(ZC_R15)
         DDR   0,1
         STD   ZC_F0,DH1
*ZC    220         IF    G3,=,DH1
         LG    ZC_R0,G3
         CDGR  ZC_F0,ZC_R0
         LD    ZC_F1,DH1
         LARL  ZC_R2,=DH'1E4'
         MD    ZC_R1,0(ZC_R2)
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_152_1
*ZC    220         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    220         ELSE
         J     PG_IF_152_E
PG_IF_152_1  DS    0H  &TYPE
*ZC    220         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_152_E  DS    0H  &TYPE
*            DIVIDE G2  INTO LH1 IF G3  = LH1 PERFORM G ELSE PERFORM B.
*ZC    221         DIVIDE G2,INTO,LH1
         LG    ZC_R0,G2
         CXGR  ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LH1
         LD    ZC_F2,8+LH1
         LARL  ZC_R15,=LH'1E4'
         LD    ZC_F4,0(ZC_R15)
         LD    ZC_F6,8(ZC_R15)
         MXR   ZC_F0,ZC_F4
         DXR   ZC_F0,ZC_F1
         STD   ZC_F0,LH1
         STD   ZC_F2,8+LH1
*ZC    221         IF    G3,=,LH1
         LG    ZC_R0,G3
         CXGR  ZC_F0,ZC_R0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         STD   ZC_F0,ZCVT_PWORK
         STD   ZC_F2,ZCVT_PWORK+8
         LARL  ZC_R2,=LH'1E4'
         LD    ZC_F0,0(ZC_R2)
         LD    ZC_F2,8(ZC_R2)
         MXR   ZC_F1,ZC_F0
         LD    ZC_F0,ZCVT_PWORK
         LD    ZC_F2,ZCVT_PWORK+8
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_153_1
*ZC    221         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    221         ELSE
         J     PG_IF_153_E
PG_IF_153_1  DS    0H  &TYPE
*ZC    221         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_153_E  DS    0H  &TYPE
*            DIVIDE G2  INTO EB1 IF G3  = EB1 PERFORM G ELSE PERFORM B.
*ZC    222         DIVIDE G2,INTO,EB1
         LG    ZC_R0,G2
         CEGBR ZC_F0,ZC_R0
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB1
         LARL  ZC_R15,=EB'1E4'
         MEEB  ZC_F0,0(ZC_R15)
         DEBR  0,1
         STE   ZC_F0,EB1
*ZC    222         IF    G3,=,EB1
         LG    ZC_R0,G3
         CEGBR ZC_F0,ZC_R0
         LE    ZC_F1,EB1
         LARL  ZC_R2,=EB'1E4'
         MDEB  ZC_F1,0(ZC_R2)
         LEDBR ZC_F1,ZC_F1
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_154_1
*ZC    222         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    222         ELSE
         J     PG_IF_154_E
PG_IF_154_1  DS    0H  &TYPE
*ZC    222         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_154_E  DS    0H  &TYPE
*            DIVIDE G2  INTO DB1 IF G3  = DB1 PERFORM G ELSE PERFORM B.
*ZC    223         DIVIDE G2,INTO,DB1
         LG    ZC_R0,G2
         CDGBR ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB1
         LARL  ZC_R15,=DB'1E4'
         MDB   0,0(ZC_R15)
         DDBR  0,1
         STD   ZC_F0,DB1
*ZC    223         IF    G3,=,DB1
         LG    ZC_R0,G3
         CDGBR ZC_F0,ZC_R0
         LD    ZC_F1,DB1
         LARL  ZC_R2,=DB'1E4'
         MDB   ZC_R1,0(ZC_R2)
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_155_1
*ZC    223         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    223         ELSE
         J     PG_IF_155_E
PG_IF_155_1  DS    0H  &TYPE
*ZC    223         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_155_E  DS    0H  &TYPE
*            DIVIDE G2  INTO LB1 IF G3  = LB1 PERFORM G ELSE PERFORM B.
*ZC    224         DIVIDE G2,INTO,LB1
         LG    ZC_R0,G2
         CXGBR ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB1
         LD    ZC_F2,8+LB1
         LARL  ZC_R15,=LB'1E4'
         LD    ZC_F4,0(ZC_R15)
         LD    ZC_F6,8(ZC_R15)
         MXBR  ZC_F0,ZC_F4
         DXBR  ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LDR   ZC_F0,ZC_F4
         LDR   ZC_F2,ZC_F6
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC    224         IF    G3,=,LB1
         LG    ZC_R0,G3
         CXGBR ZC_F0,ZC_R0
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         STD   ZC_F0,ZCVT_PWORK
         STD   ZC_F2,ZCVT_PWORK+8
         LARL  ZC_R2,=LB'1E4'
         LD    ZC_F0,0(ZC_R2)
         LD    ZC_F2,8(ZC_R2)
         MXBR  ZC_F1,ZC_F0
         LD    ZC_F0,ZCVT_PWORK
         LD    ZC_F2,ZCVT_PWORK+8
         CXBR  ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_156_1
*ZC    224         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    224         ELSE
         J     PG_IF_156_E
PG_IF_156_1  DS    0H  &TYPE
*ZC    224         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_156_E  DS    0H  &TYPE
*            DIVIDE G2  INTO ED1 IF G3  = ED1 PERFORM G ELSE PERFORM B.
*ZC    225         DIVIDE G2,INTO,ED1
         LG    ZC_R0,G2
         CDGTR ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED1
         LDETR ZC_F0,ZC_F0,0
         LARL  ZC_R2,=DD'1E4'
         LD    ZC_F4,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F4
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_ED,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         STE   ZC_F0,ED1
*ZC    225         IF    G3,=,ED1
         LG    ZC_R0,G3
         CDGTR ZC_F0,ZC_R0
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         LARL  ZC_R2,=DD'1E4'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F1,ZC_F1,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_157_1
*ZC    225         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    225         ELSE
         J     PG_IF_157_E
PG_IF_157_1  DS    0H  &TYPE
*ZC    225         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_157_E  DS    0H  &TYPE
*            DIVIDE G2  INTO DD1 IF G3  = DD1 PERFORM G ELSE PERFORM B.
*ZC    226         DIVIDE G2,INTO,DD1
         LG    ZC_R0,G2
         CDGTR ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD1
         LARL  ZC_R2,=DD'1E4'
         LD    ZC_F4,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F4
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F0,ZC_F4
         STD   ZC_F0,DD1
*ZC    226         IF    G3,=,DD1
         LG    ZC_R0,G3
         CDGTR ZC_F0,ZC_R0
         LD    ZC_F1,DD1
         LARL  ZC_R2,=DD'1E4'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F1,ZC_F1,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_158_1
*ZC    226         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    226         ELSE
         J     PG_IF_158_E
PG_IF_158_1  DS    0H  &TYPE
*ZC    226         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_158_E  DS    0H  &TYPE
*            DIVIDE G2  INTO LD1 IF G3  = LD1 PERFORM G ELSE PERFORM B.
*ZC    227         DIVIDE G2,INTO,LD1
         LG    ZC_R0,G2
         CXGTR ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD1
         LD    ZC_F2,8+LD1
         LARL  ZC_R15,=LD'1E4'
         LD    ZC_F4,0(ZC_R15)
         LD    ZC_F6,8(ZC_R15)
         MXTR  ZC_F0,ZC_F0,ZC_F4
         DXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,LD1
         STD   ZC_F2,8+LD1
*ZC    227         IF    G3,=,LD1
         LG    ZC_R0,G3
         CXGTR ZC_F0,ZC_R0
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         STD   ZC_F0,ZCVT_PWORK
         STD   ZC_F2,ZCVT_PWORK+8
         LARL  ZC_R2,=LD'1E4'
         LD    ZC_F0,0(ZC_R2)
         LD    ZC_F2,8(ZC_R2)
         MXTR  ZC_F1,ZC_F1,ZC_F0
         LD    ZC_F0,ZCVT_PWORK
         LD    ZC_F2,ZCVT_PWORK+8
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_159_1
*ZC    227         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    227         ELSE
         J     PG_IF_159_E
PG_IF_159_1  DS    0H  &TYPE
*ZC    227         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_159_E  DS    0H  &TYPE
*            DIVIDE G2  INTO F1  IF G3  = F1  PERFORM G ELSE PERFORM B.
*ZC    228         DIVIDE G2,INTO,F1
         MVC   ZCVT_NDDX(4),F1
         LG    ZC_R2,G2    HIGH 32 BITS IGNORED
         LGF   ZC_R1,ZCVT_NDDX
         LARL  ZC_R15,=FL8'1E4'
         MSG   1,0(ZC_R15)
         DSGR    0,2
         ST    1,F1
*ZC    228         IF    G3,=,F1
         LG    ZC_R0,G3
         LGF   ZC_R1,F1
         LARL  ZC_R2,=FL8'1E3'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_160_1
*ZC    228         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    228         ELSE
         J     PG_IF_160_E
PG_IF_160_1  DS    0H  &TYPE
*ZC    228         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_160_E  DS    0H  &TYPE
*            DIVIDE G2  INTO G1  IF G3  = G1  PERFORM G ELSE PERFORM B.
*ZC    229         DIVIDE G2,INTO,G1
         MVC   ZCVT_NDDX(8),G1
         LG    2,G2
         LG    1,ZCVT_NDDX
         LARL  ZC_R15,=FL8'1E4'
         MSG   1,0(ZC_R15)
         DSGR    0,2
         STG   1,G1
*ZC    229         IF    G3,=,G1
         LG    ZC_R0,G3
         LG    ZC_R1,G1
         LARL  ZC_R2,=FL8'1E3'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_161_1
*ZC    229         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    229         ELSE
         J     PG_IF_161_E
PG_IF_161_1  DS    0H  &TYPE
*ZC    229         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_161_E  DS    0H  &TYPE
*            DIVIDE G2  INTO H1  IF G3  = H1  PERFORM G ELSE PERFORM B.
*ZC    230         DIVIDE G2,INTO,H1
         MVC   ZCVT_NDDX(2),H1
         LG    ZC_R2,G2
         LGH   ZC_R1,ZCVT_NDDX
         LARL  ZC_R15,=FL8'1E4'
         MSG   1,0(ZC_R15)
         DSGR    0,2
         STH   1,H1
*ZC    230         IF    G3,=,H1
         LG    ZC_R0,G3
         LGH   ZC_R1,H1
         LARL  ZC_R2,=FL8'1E3'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_162_1
*ZC    230         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    230         ELSE
         J     PG_IF_162_E
PG_IF_162_1  DS    0H  &TYPE
*ZC    230         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_162_E  DS    0H  &TYPE
*            DIVIDE G2  INTO P1  IF G3  = P1  PERFORM G ELSE PERFORM B.
*ZC    231         DIVIDE G2,INTO,P1
         ZAP ZCVT_PWORK1(16),P1
         LG    0,G2
         CVDG  0,ZCVT_PWORK2    IGNORE HIGH 32
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         LARL  ZC_R2,=LD'1E4'
         LD    ZC_F4,0(ZC_R2)
         LD    ZC_F6,8(ZC_R2)
         MXTR  ZC_F0,ZC_F0,ZC_F4
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         ZAP   P1,ZCVT_PWORK4(16)
*ZC    231         IF    G3,=,P1
         LG    ZC_R0,G3
         ZAP   ZCVT_PWORK2,P1
         CVBG  ZC_R1,ZCVT_PWORK2
         LARL  ZC_R2,=FL8'1E3'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_163_1
*ZC    231         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    231         ELSE
         J     PG_IF_163_E
PG_IF_163_1  DS    0H  &TYPE
*ZC    231         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_163_E  DS    0H  &TYPE
*            DIVIDE G2  INTO Q1  IF G3  = Q1  PERFORM G ELSE PERFORM B.
*ZC    232         DIVIDE G2,INTO,Q1
         MVC   ZCVT_NDDX,Q1
         LG    ZC_R3,G2
         SGR   ZC_R2,ZC_R2
         LMG   ZC_R0,ZC_R1,ZCVT_NDDX
         STMG  ZC_R2,ZC_R3,ZCVT_WORKAREA
         LARL  ZC_R15,=FL16'1E4'
         LMG   ZC_R2,ZC_R3,0(ZC_R15)
         L     ZC_R15,ZCVT_MPYQ128      MPY DIVIDEND
         BASR  ZC_R14,ZC_R15
         LMG   ZC_R2,ZC_R3,ZCVT_WORKAREA   REST0RE DIVISOR
         L     ZC_R15,ZCVT_DIVQ128 DIVIDE SCALED DIVIDEND BY QUOTIENT
         BASR  ZC_R14,ZC_R15
         LTGR  ZC_R0,ZC_R0
         JNM   ZC_LPQR_11
         XG    ZC_R0,ZCVT_HIGH_VALUES
         XG    ZC_R0+1,ZCVT_HIGH_VALUES
         ALGFI ZC_R0+1,1
         ALCG  ZC_R0,ZCVT_ZERO
ZC_LPQR_11           DS 0H
         STMG  ZC_R2,ZC_R3,Q1
*ZC    232         IF    G3,=,Q1
         LG    ZC_R1,G3
         LGR   ZC_R0,ZC_R1
         SRAG  ZC_R0,ZC_R0,63  SIGN FILL HIGH 64
         LG    ZC_R2,Q1
         LG    ZC_R3,8+Q1
                  STMG  ZC_R0,ZC_R1,ZCVT_PWORK1
                  LGR   ZC_R0,ZC_R2
                  LGR   ZC_R1,ZC_R3
                  LARL  ZC_R2,=FL8'1E3'
                  LG    ZC_R3,0(ZC_R2)
                  SGR   ZC_R2,ZC_R2
                  L     ZC_R15,ZCVT_MPYQ128
                  BALR  ZC_R14,ZC_R15
                  LGR   ZC_R2,ZC_R0
                  LGR   ZC_R3,ZC_R1
                  LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CGR   ZC_R0,ZC_R2
         JNZ   *+4+4
         CGR   ZC_R0+1,ZC_R2+1
         BRC   15-ZC_EQ,PG_IF_164_1
*ZC    232         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    232         ELSE
         J     PG_IF_164_E
PG_IF_164_1  DS    0H  &TYPE
*ZC    232         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_164_E  DS    0H  &TYPE
*            DIVIDE G2  INTO Z1  IF G3  = Z1  PERFORM G ELSE PERFORM B.
*ZC    233         DIVIDE G2,INTO,Z1
         PACK  ZCVT_PWORK1(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z1(3)  PACK #3 FINAL
         LG    0,G2
         CVDG  0,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         LARL  ZC_R2,=LD'1E4'
         LD    ZC_F4,0(ZC_R2)
         LD    ZC_F6,8(ZC_R2)
         MXTR  ZC_F0,ZC_F0,ZC_F4
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         UNPK  0+Z1(15),0+ZCVT_PWORK4(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK4(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK4(2) UNPK #3 FINAL
*ZC    233         IF    G3,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R0
         LGR   ZC_R3,ZC_R1
         LG    ZC_R1,G3
         LGR   ZC_R0,ZC_R1
         SRAG  ZC_R0,ZC_R0,63
                  STMG  ZC_R0,ZC_R1,ZCVT_PWORK1
                  LGR   ZC_R0,ZC_R2
                  LGR   ZC_R1,ZC_R3
                  LARL  ZC_R2,=FL8'1E3'
                  LG    ZC_R3,0(ZC_R2)
                  SGR   ZC_R2,ZC_R2
                  L     ZC_R15,ZCVT_MPYQ128
                  BALR  ZC_R14,ZC_R15
                  LGR   ZC_R2,ZC_R0
                  LGR   ZC_R3,ZC_R1
                  LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CGR   ZC_R0,ZC_R2
         JNZ   *+4+4
         CGR   ZC_R0+1,ZC_R2+1
         BRC   15-ZC_EQ,PG_IF_165_1
*ZC    233         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    233         ELSE
         J     PG_IF_165_E
PG_IF_165_1  DS    0H  &TYPE
*ZC    233         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_165_E  DS    0H  &TYPE
*            PERFORM INIT.
*ZC    234         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            DIVIDE H2  INTO EH1 IF H3  = EH1 PERFORM G ELSE PERFORM B.
*ZC    235         DIVIDE H2,INTO,EH1
         LH    ZC_R0,H2
         CEFR  ZC_F0,ZC_R0
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R15,=EH'1E2'
         ME    0,0(ZC_R15)
         DER   0,1
         STE   ZC_F0,EH1
*ZC    235         IF    H3,=,EH1
         LH    ZC_R0,H3
         CEFR  ZC_F0,ZC_R0
         LE    ZC_F1,EH1
         LARL  ZC_R2,=EH'1E2'
         ME    ZC_R1,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_166_1
*ZC    235         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    235         ELSE
         J     PG_IF_166_E
PG_IF_166_1  DS    0H  &TYPE
*ZC    235         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_166_E  DS    0H  &TYPE
*            DIVIDE H2  INTO DH1 IF H3  = DH1 PERFORM G ELSE PERFORM B.
*ZC    236         DIVIDE H2,INTO,DH1
         LH    ZC_R0,H2
         CDFR  ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DH1
         LARL  ZC_R15,=DH'1E2'
         MD    0,0(ZC_R15)
         DDR   0,1
         STD   ZC_F0,DH1
*ZC    236         IF    H3,=,DH1
         LH    ZC_R0,H3
         CDFR  ZC_F0,ZC_R0
         LD    ZC_F1,DH1
         LARL  ZC_R2,=DH'1E2'
         MD    ZC_R1,0(ZC_R2)
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_167_1
*ZC    236         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    236         ELSE
         J     PG_IF_167_E
PG_IF_167_1  DS    0H  &TYPE
*ZC    236         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_167_E  DS    0H  &TYPE
*            DIVIDE H2  INTO LH1 IF H3  = LH1 PERFORM G ELSE PERFORM B.
*ZC    237         DIVIDE H2,INTO,LH1
         LH    ZC_R0,H2
         CXFR  ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LH1
         LD    ZC_F2,8+LH1
         LARL  ZC_R15,=LH'1E2'
         LD    ZC_F4,0(ZC_R15)
         LD    ZC_F6,8(ZC_R15)
         MXR   ZC_F0,ZC_F4
         DXR   ZC_F0,ZC_F1
         STD   ZC_F0,LH1
         STD   ZC_F2,8+LH1
*ZC    237         IF    H3,=,LH1
         LH    ZC_R0,H3
         CXFR  ZC_F0,ZC_R0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         STD   ZC_F0,ZCVT_PWORK
         STD   ZC_F2,ZCVT_PWORK+8
         LARL  ZC_R2,=LH'1E2'
         LD    ZC_F0,0(ZC_R2)
         LD    ZC_F2,8(ZC_R2)
         MXR   ZC_F1,ZC_F0
         LD    ZC_F0,ZCVT_PWORK
         LD    ZC_F2,ZCVT_PWORK+8
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_168_1
*ZC    237         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    237         ELSE
         J     PG_IF_168_E
PG_IF_168_1  DS    0H  &TYPE
*ZC    237         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_168_E  DS    0H  &TYPE
*            DIVIDE H2  INTO EB1 IF H3  = EB1 PERFORM G ELSE PERFORM B.
*ZC    238         DIVIDE H2,INTO,EB1
         LH    ZC_R0,H2
         CEFBR ZC_F0,ZC_R0
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB1
         LARL  ZC_R15,=EB'1E2'
         MEEB  ZC_F0,0(ZC_R15)
         DEBR  0,1
         STE   ZC_F0,EB1
*ZC    238         IF    H3,=,EB1
         LH    ZC_R0,H3
         CEFBR ZC_F0,ZC_R0
         LE    ZC_F1,EB1
         LARL  ZC_R2,=EB'1E2'
         MDEB  ZC_F1,0(ZC_R2)
         LEDBR ZC_F1,ZC_F1
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_169_1
*ZC    238         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    238         ELSE
         J     PG_IF_169_E
PG_IF_169_1  DS    0H  &TYPE
*ZC    238         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_169_E  DS    0H  &TYPE
*            DIVIDE H2  INTO DB1 IF H3  = DB1 PERFORM G ELSE PERFORM B.
*ZC    239         DIVIDE H2,INTO,DB1
         LH    ZC_R0,H2
         CDFBR ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB1
         LARL  ZC_R15,=DB'1E2'
         MDB   0,0(ZC_R15)
         DDBR  0,1
         STD   ZC_F0,DB1
*ZC    239         IF    H3,=,DB1
         LH    ZC_R0,H3
         CDFBR ZC_F0,ZC_R0
         LD    ZC_F1,DB1
         LARL  ZC_R2,=DB'1E2'
         MDB   ZC_R1,0(ZC_R2)
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_170_1
*ZC    239         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    239         ELSE
         J     PG_IF_170_E
PG_IF_170_1  DS    0H  &TYPE
*ZC    239         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_170_E  DS    0H  &TYPE
*            DIVIDE H2  INTO LB1 IF H3  = LB1 PERFORM G ELSE PERFORM B.
*ZC    240         DIVIDE H2,INTO,LB1
         LH    ZC_R0,H2
         CXFBR ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB1
         LD    ZC_F2,8+LB1
         LARL  ZC_R15,=LB'1E2'
         LD    ZC_F4,0(ZC_R15)
         LD    ZC_F6,8(ZC_R15)
         MXBR  ZC_F0,ZC_F4
         DXBR  ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LDR   ZC_F0,ZC_F4
         LDR   ZC_F2,ZC_F6
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC    240         IF    H3,=,LB1
         LH    ZC_R0,H3
         CXFBR ZC_F0,ZC_R0
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         STD   ZC_F0,ZCVT_PWORK
         STD   ZC_F2,ZCVT_PWORK+8
         LARL  ZC_R2,=LB'1E2'
         LD    ZC_F0,0(ZC_R2)
         LD    ZC_F2,8(ZC_R2)
         MXBR  ZC_F1,ZC_F0
         LD    ZC_F0,ZCVT_PWORK
         LD    ZC_F2,ZCVT_PWORK+8
         CXBR  ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_171_1
*ZC    240         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    240         ELSE
         J     PG_IF_171_E
PG_IF_171_1  DS    0H  &TYPE
*ZC    240         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_171_E  DS    0H  &TYPE
*            DIVIDE H2  INTO ED1 IF H3  = ED1 PERFORM G ELSE PERFORM B.
*ZC    241         DIVIDE H2,INTO,ED1
         LGH   ZC_R0,H2
         CDGTR ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED1
         LDETR ZC_F0,ZC_F0,0
         LARL  ZC_R2,=DD'1E2'
         LD    ZC_F4,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F4
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_ED,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         STE   ZC_F0,ED1
*ZC    241         IF    H3,=,ED1
         LH    ZC_R0,H3
         CDFTR ZC_F0,0,ZC_R0,0
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         LARL  ZC_R2,=DD'1E2'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F1,ZC_F1,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_172_1
*ZC    241         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    241         ELSE
         J     PG_IF_172_E
PG_IF_172_1  DS    0H  &TYPE
*ZC    241         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_172_E  DS    0H  &TYPE
*            DIVIDE H2  INTO DD1 IF H3  = DD1 PERFORM G ELSE PERFORM B.
*ZC    242         DIVIDE H2,INTO,DD1
         LGH   ZC_R0,H2
         CDGTR ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD1
         LARL  ZC_R2,=DD'1E2'
         LD    ZC_F4,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F4
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F0,ZC_F4
         STD   ZC_F0,DD1
*ZC    242         IF    H3,=,DD1
         LH    ZC_R0,H3
         CDFTR ZC_F0,0,ZC_R0,0
         LD    ZC_F1,DD1
         LARL  ZC_R2,=DD'1E2'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F1,ZC_F1,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_173_1
*ZC    242         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    242         ELSE
         J     PG_IF_173_E
PG_IF_173_1  DS    0H  &TYPE
*ZC    242         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_173_E  DS    0H  &TYPE
*            DIVIDE H2  INTO LD1 IF H3  = LD1 PERFORM G ELSE PERFORM B.
*ZC    243         DIVIDE H2,INTO,LD1
         LGH   ZC_R0,H2
         CXGTR ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD1
         LD    ZC_F2,8+LD1
         LARL  ZC_R15,=LD'1E2'
         LD    ZC_F4,0(ZC_R15)
         LD    ZC_F6,8(ZC_R15)
         MXTR  ZC_F0,ZC_F0,ZC_F4
         DXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,LD1
         STD   ZC_F2,8+LD1
*ZC    243         IF    H3,=,LD1
         LH    ZC_R0,H3
         CXFTR ZC_F0,0,ZC_R0,0
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         STD   ZC_F0,ZCVT_PWORK
         STD   ZC_F2,ZCVT_PWORK+8
         LARL  ZC_R2,=LD'1E2'
         LD    ZC_F0,0(ZC_R2)
         LD    ZC_F2,8(ZC_R2)
         MXTR  ZC_F1,ZC_F1,ZC_F0
         LD    ZC_F0,ZCVT_PWORK
         LD    ZC_F2,ZCVT_PWORK+8
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_174_1
*ZC    243         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    243         ELSE
         J     PG_IF_174_E
PG_IF_174_1  DS    0H  &TYPE
*ZC    243         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_174_E  DS    0H  &TYPE
*            DIVIDE H2  INTO F1  IF H3  = F1  PERFORM G ELSE PERFORM B.
*ZC    244         DIVIDE H2,INTO,F1
         MVC   ZCVT_NDDX(4),F1
         LGH   ZC_R2,H2
         LGF   ZC_R1,ZCVT_NDDX
         LARL  ZC_R15,=FL8'1E2'
         MSG   1,0(ZC_R15)
         DSGR    0,2
         ST    1,F1
*ZC    244         IF    H3,=,F1
         LH    ZC_R0,H3
         L     ZC_R1,F1
         LARL  ZC_R2,=F'1E1'
         MS    ZC_R1,0(ZC_R2)
         CR    ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_175_1
*ZC    244         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    244         ELSE
         J     PG_IF_175_E
PG_IF_175_1  DS    0H  &TYPE
*ZC    244         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_175_E  DS    0H  &TYPE
*            DIVIDE H2  INTO G1  IF H3  = G1  PERFORM G ELSE PERFORM B.
*ZC    245         DIVIDE H2,INTO,G1
         MVC   ZCVT_NDDX(8),G1
         LGH   2,H2
         LG    1,ZCVT_NDDX
         LARL  ZC_R15,=FL8'1E2'
         MSG   1,0(ZC_R15)
         DSGR    0,2
         STG   1,G1
*ZC    245         IF    H3,=,G1
         LGH   ZC_R0,H3
         LG    ZC_R1,G1
         LARL  ZC_R2,=FL8'1E1'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_176_1
*ZC    245         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    245         ELSE
         J     PG_IF_176_E
PG_IF_176_1  DS    0H  &TYPE
*ZC    245         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_176_E  DS    0H  &TYPE
*            DIVIDE H2  INTO H1  IF H3  = H1  PERFORM G ELSE PERFORM B.
*ZC    246         DIVIDE H2,INTO,H1
         MVC   ZCVT_NDDX(2),H1
         LGH   ZC_R2,H2
         LGH   ZC_R1,ZCVT_NDDX
         LARL  ZC_R15,=FL8'1E2'
         MSG   1,0(ZC_R15)
         DSGR    0,2
         STH   1,H1
*ZC    246         IF    H3,=,H1
         LH    ZC_R0,H3
         LH    ZC_R1,H1
         LARL  ZC_R2,=F'1E1'
         MS    ZC_R1,0(ZC_R2)
         CR    ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_177_1
*ZC    246         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    246         ELSE
         J     PG_IF_177_E
PG_IF_177_1  DS    0H  &TYPE
*ZC    246         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_177_E  DS    0H  &TYPE
*            DIVIDE H2  INTO P1  IF H3  = P1  PERFORM G ELSE PERFORM B.
*ZC    247         DIVIDE H2,INTO,P1
         ZAP ZCVT_PWORK1(16),P1
         LH    0,H2
         CVD   0,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         ZAP   ZCVT_PWORK4,ZCVT_PWORK2(8)
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK4
         CXSTR ZC_F1,ZC_R0
         LARL  ZC_R2,=LD'1E2'
         LD    ZC_F4,0(ZC_R2)
         LD    ZC_F6,8(ZC_R2)
         MXTR  ZC_F0,ZC_F0,ZC_F4
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         ZAP   P1,ZCVT_PWORK4(16)
*ZC    247         IF    H3,=,P1
         LGH   ZC_R0,H3
         ZAP   ZCVT_PWORK2,P1
         CVBG  ZC_R1,ZCVT_PWORK2
         LARL  ZC_R2,=FL8'1E1'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_178_1
*ZC    247         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    247         ELSE
         J     PG_IF_178_E
PG_IF_178_1  DS    0H  &TYPE
*ZC    247         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_178_E  DS    0H  &TYPE
*            DIVIDE H2  INTO Q1  IF H3  = Q1  PERFORM G ELSE PERFORM B.
*ZC    248         DIVIDE H2,INTO,Q1
         MVC   ZCVT_NDDX,Q1
         LGH   ZC_R3,H2
         SGR   ZC_R2,ZC_R2
         LMG   ZC_R0,ZC_R1,ZCVT_NDDX
         STMG  ZC_R2,ZC_R3,ZCVT_WORKAREA
         LARL  ZC_R15,=FL16'1E2'
         LMG   ZC_R2,ZC_R3,0(ZC_R15)
         L     ZC_R15,ZCVT_MPYQ128      MPY DIVIDEND
         BASR  ZC_R14,ZC_R15
         LMG   ZC_R2,ZC_R3,ZCVT_WORKAREA   REST0RE DIVISOR
         L     ZC_R15,ZCVT_DIVQ128 DIVIDE SCALED DIVIDEND BY QUOTIENT
         BASR  ZC_R14,ZC_R15
         LTGR  ZC_R0,ZC_R0
         JNM   ZC_LPQR_12
         XG    ZC_R0,ZCVT_HIGH_VALUES
         XG    ZC_R0+1,ZCVT_HIGH_VALUES
         ALGFI ZC_R0+1,1
         ALCG  ZC_R0,ZCVT_ZERO
ZC_LPQR_12           DS 0H
         STMG  ZC_R2,ZC_R3,Q1
*ZC    248         IF    H3,=,Q1
         LGH   ZC_R1,H3
         LGR   ZC_R0,ZC_R1
         SRAG  ZC_R0,ZC_R0,63  SIGN FILL HIGH 64
         LG    ZC_R2,Q1
         LG    ZC_R3,8+Q1
                  STMG  ZC_R0,ZC_R1,ZCVT_PWORK1
                  LGR   ZC_R0,ZC_R2
                  LGR   ZC_R1,ZC_R3
                  LARL  ZC_R2,=FL8'1E1'
                  LG    ZC_R3,0(ZC_R2)
                  SGR   ZC_R2,ZC_R2
                  L     ZC_R15,ZCVT_MPYQ128
                  BALR  ZC_R14,ZC_R15
                  LGR   ZC_R2,ZC_R0
                  LGR   ZC_R3,ZC_R1
                  LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CGR   ZC_R0,ZC_R2
         JNZ   *+4+4
         CGR   ZC_R0+1,ZC_R2+1
         BRC   15-ZC_EQ,PG_IF_179_1
*ZC    248         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    248         ELSE
         J     PG_IF_179_E
PG_IF_179_1  DS    0H  &TYPE
*ZC    248         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_179_E  DS    0H  &TYPE
*            DIVIDE H2  INTO Z1  IF H3  = Z1  PERFORM G ELSE PERFORM B.
*ZC    249         DIVIDE H2,INTO,Z1
         PACK  ZCVT_PWORK1(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z1(3)  PACK #3 FINAL
         LH    0,H2
         CVD   0,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         ZAP   ZCVT_PWORK4,ZCVT_PWORK2(8)
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK4
         CXSTR ZC_F1,ZC_R0
         LARL  ZC_R2,=LD'1E2'
         LD    ZC_F4,0(ZC_R2)
         LD    ZC_F6,8(ZC_R2)
         MXTR  ZC_F0,ZC_F0,ZC_F4
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         UNPK  0+Z1(15),0+ZCVT_PWORK4(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK4(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK4(2) UNPK #3 FINAL
*ZC    249         IF    H3,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R0
         LGR   ZC_R3,ZC_R1
         LGH   ZC_R1,H3
         LGR   ZC_R0,ZC_R1
         SRAG  ZC_R0,ZC_R0,63  SIGN FILL HIGH 64
                  STMG  ZC_R0,ZC_R1,ZCVT_PWORK1
                  LGR   ZC_R0,ZC_R2
                  LGR   ZC_R1,ZC_R3
                  LARL  ZC_R2,=FL8'1E1'
                  LG    ZC_R3,0(ZC_R2)
                  SGR   ZC_R2,ZC_R2
                  L     ZC_R15,ZCVT_MPYQ128
                  BALR  ZC_R14,ZC_R15
                  LGR   ZC_R2,ZC_R0
                  LGR   ZC_R3,ZC_R1
                  LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CGR   ZC_R0,ZC_R2
         JNZ   *+4+4
         CGR   ZC_R0+1,ZC_R2+1
         BRC   15-ZC_EQ,PG_IF_180_1
*ZC    249         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    249         ELSE
         J     PG_IF_180_E
PG_IF_180_1  DS    0H  &TYPE
*ZC    249         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_180_E  DS    0H  &TYPE
*            PERFORM INIT.
*ZC    250         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            DIVIDE P2  INTO EH1 IF P3  = EH1 PERFORM G ELSE PERFORM B.
*ZC    251         DIVIDE P2,INTO,EH1
         ZAP   ZCVT_PWORK2,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R15,=EH'1E6'
         ME    0,0(ZC_R15)
         DER   0,1
         STE   ZC_F0,EH1
*ZC    251         IF    P3,=,EH1
         ZAP   ZCVT_PWORK1,P3
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,EH1
         LARL  ZC_R2,=EH'1E6'
         ME    ZC_R1,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_181_1
*ZC    251         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    251         ELSE
         J     PG_IF_181_E
PG_IF_181_1  DS    0H  &TYPE
*ZC    251         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_181_E  DS    0H  &TYPE
*            DIVIDE P2  INTO DH1 IF P3  = DH1 PERFORM G ELSE PERFORM B.
*ZC    252         DIVIDE P2,INTO,DH1
         ZAP   ZCVT_PWORK2,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DH1
         LARL  ZC_R15,=DH'1E6'
         MD    0,0(ZC_R15)
         DDR   0,1
         STD   ZC_F0,DH1
*ZC    252         IF    P3,=,DH1
         ZAP   ZCVT_PWORK1,P3
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DH1
         LARL  ZC_R2,=DH'1E6'
         MD    ZC_R1,0(ZC_R2)
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_182_1
*ZC    252         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    252         ELSE
         J     PG_IF_182_E
PG_IF_182_1  DS    0H  &TYPE
*ZC    252         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_182_E  DS    0H  &TYPE
*            DIVIDE P2  INTO LH1 IF P3  = LH1 PERFORM G ELSE PERFORM B.
*ZC    253         DIVIDE P2,INTO,LH1
         ZAP   ZCVT_PWORK2,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LH1
         LD    ZC_F2,8+LH1
         LARL  ZC_R15,=LH'1E6'
         LD    ZC_F4,0(ZC_R15)
         LD    ZC_F6,8(ZC_R15)
         MXR   ZC_F0,ZC_F4
         DXR   ZC_F0,ZC_F1
         STD   ZC_F0,LH1
         STD   ZC_F2,8+LH1
*ZC    253         IF    P3,=,LH1
         ZAP   ZCVT_PWORK1,P3
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         STD   ZC_F0,ZCVT_PWORK
         STD   ZC_F2,ZCVT_PWORK+8
         LARL  ZC_R2,=LH'1E6'
         LD    ZC_F0,0(ZC_R2)
         LD    ZC_F2,8(ZC_R2)
         MXR   ZC_F1,ZC_F0
         LD    ZC_F0,ZCVT_PWORK
         LD    ZC_F2,ZCVT_PWORK+8
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_183_1
*ZC    253         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    253         ELSE
         J     PG_IF_183_E
PG_IF_183_1  DS    0H  &TYPE
*ZC    253         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_183_E  DS    0H  &TYPE
*            DIVIDE P2  INTO EB1 IF P3  = EB1 PERFORM G ELSE PERFORM B.
*ZC    254         DIVIDE P2,INTO,EB1
         ZAP   ZCVT_PWORK2,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB1
         LARL  ZC_R15,=EB'1E6'
         MEEB  ZC_F0,0(ZC_R15)
         DEBR  0,1
         STE   ZC_F0,EB1
*ZC    254         IF    P3,=,EB1
         ZAP   ZCVT_PWORK1,P3
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,EB1
         LARL  ZC_R2,=EB'1E6'
         MDEB  ZC_F1,0(ZC_R2)
         LEDBR ZC_F1,ZC_F1
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_184_1
*ZC    254         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    254         ELSE
         J     PG_IF_184_E
PG_IF_184_1  DS    0H  &TYPE
*ZC    254         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_184_E  DS    0H  &TYPE
*            DIVIDE P2  INTO DB1 IF P3  = DB1 PERFORM G ELSE PERFORM B.
*ZC    255         DIVIDE P2,INTO,DB1
         ZAP   ZCVT_PWORK2,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB1
         LARL  ZC_R15,=DB'1E6'
         MDB   0,0(ZC_R15)
         DDBR  0,1
         STD   ZC_F0,DB1
*ZC    255         IF    P3,=,DB1
         ZAP   ZCVT_PWORK1,P3
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DB1
         LARL  ZC_R2,=DB'1E6'
         MDB   ZC_R1,0(ZC_R2)
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_185_1
*ZC    255         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    255         ELSE
         J     PG_IF_185_E
PG_IF_185_1  DS    0H  &TYPE
*ZC    255         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_185_E  DS    0H  &TYPE
*            DIVIDE P2  INTO LB1 IF P3  = LB1 PERFORM G ELSE PERFORM B.
*ZC    256         DIVIDE P2,INTO,LB1
         ZAP   ZCVT_PWORK2,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB1
         LD    ZC_F2,8+LB1
         LARL  ZC_R15,=LB'1E6'
         LD    ZC_F4,0(ZC_R15)
         LD    ZC_F6,8(ZC_R15)
         MXBR  ZC_F0,ZC_F4
         DXBR  ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LDR   ZC_F0,ZC_F4
         LDR   ZC_F2,ZC_F6
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC    256         IF    P3,=,LB1
         ZAP   ZCVT_PWORK1,P3
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         STD   ZC_F0,ZCVT_PWORK
         STD   ZC_F2,ZCVT_PWORK+8
         LARL  ZC_R2,=LB'1E6'
         LD    ZC_F0,0(ZC_R2)
         LD    ZC_F2,8(ZC_R2)
         MXBR  ZC_F1,ZC_F0
         LD    ZC_F0,ZCVT_PWORK
         LD    ZC_F2,ZCVT_PWORK+8
         CXBR  ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_186_1
*ZC    256         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    256         ELSE
         J     PG_IF_186_E
PG_IF_186_1  DS    0H  &TYPE
*ZC    256         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_186_E  DS    0H  &TYPE
*            DIVIDE P2  INTO ED1 IF P3  = ED1 PERFORM G ELSE PERFORM B.
*ZC    257         DIVIDE P2,INTO,ED1
         ZAP   ZCVT_PWORK2,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED1
         LDETR ZC_F0,ZC_F0,0
         LARL  ZC_R2,=DD'1E6'
         LD    ZC_F4,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F4
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_ED,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         STE   ZC_F0,ED1
*ZC    257         IF    P3,=,ED1
         ZAP   ZCVT_PWORK1,P3
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         LARL  ZC_R2,=DD'1E6'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F1,ZC_F1,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_187_1
*ZC    257         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    257         ELSE
         J     PG_IF_187_E
PG_IF_187_1  DS    0H  &TYPE
*ZC    257         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_187_E  DS    0H  &TYPE
*            DIVIDE P2  INTO DD1 IF P3  = DD1 PERFORM G ELSE PERFORM B.
*ZC    258         DIVIDE P2,INTO,DD1
         ZAP   ZCVT_PWORK2,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD1
         LARL  ZC_R2,=DD'1E6'
         LD    ZC_F4,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F4
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F0,ZC_F4
         STD   ZC_F0,DD1
*ZC    258         IF    P3,=,DD1
         ZAP   ZCVT_PWORK1,P3
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         LARL  ZC_R2,=DD'1E6'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F1,ZC_F1,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_188_1
*ZC    258         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    258         ELSE
         J     PG_IF_188_E
PG_IF_188_1  DS    0H  &TYPE
*ZC    258         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_188_E  DS    0H  &TYPE
*            DIVIDE P2  INTO LD1 IF P3  = LD1 PERFORM G ELSE PERFORM B.
*ZC    259         DIVIDE P2,INTO,LD1
         ZAP   ZCVT_PWORK2,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD1
         LD    ZC_F2,8+LD1
         LARL  ZC_R15,=LD'1E6'
         LD    ZC_F4,0(ZC_R15)
         LD    ZC_F6,8(ZC_R15)
         MXTR  ZC_F0,ZC_F0,ZC_F4
         DXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,LD1
         STD   ZC_F2,8+LD1
*ZC    259         IF    P3,=,LD1
         ZAP   ZCVT_PWORK1,P3
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         STD   ZC_F0,ZCVT_PWORK
         STD   ZC_F2,ZCVT_PWORK+8
         LARL  ZC_R2,=LD'1E6'
         LD    ZC_F0,0(ZC_R2)
         LD    ZC_F2,8(ZC_R2)
         MXTR  ZC_F1,ZC_F1,ZC_F0
         LD    ZC_F0,ZCVT_PWORK
         LD    ZC_F2,ZCVT_PWORK+8
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_189_1
*ZC    259         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    259         ELSE
         J     PG_IF_189_E
PG_IF_189_1  DS    0H  &TYPE
*ZC    259         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_189_E  DS    0H  &TYPE
*            DIVIDE P2  INTO F1  IF P3  = F1  PERFORM G ELSE PERFORM B.
*ZC    260         DIVIDE P2,INTO,F1
         MVC   ZCVT_NDDX(4),F1
         ZAP   ZCVT_PWORK1,P2
         CVBG  ZC_R2,ZCVT_PWORK1
         LGF   ZC_R1,ZCVT_NDDX
         LARL  ZC_R15,=FL8'1E6'
         MSG   1,0(ZC_R15)
         DSGR    0,2
         ST    1,F1
*ZC    260         IF    P3,=,F1
         LGF   ZC_R1,F1
         ZAP   ZCVT_PWORK1,P3
         CVBG  ZC_R0,ZCVT_PWORK1
         LARL  ZC_R2,=FL8'1E5'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_190_1
*ZC    260         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    260         ELSE
         J     PG_IF_190_E
PG_IF_190_1  DS    0H  &TYPE
*ZC    260         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_190_E  DS    0H  &TYPE
*            DIVIDE P2  INTO G1  IF P3  = G1  PERFORM G ELSE PERFORM B.
*ZC    261         DIVIDE P2,INTO,G1
         MVC   ZCVT_NDDX(8),G1
         ZAP   ZCVT_PWORK1,P2
         CVBG  2,ZCVT_PWORK1
         LG    1,ZCVT_NDDX
         LARL  ZC_R15,=FL8'1E6'
         MSG   1,0(ZC_R15)
         DSGR    0,2
         STG   1,G1
*ZC    261         IF    P3,=,G1
         LG    ZC_R1,G1
         ZAP   ZCVT_PWORK1,P3
         CVBG  ZC_R0,ZCVT_PWORK1
         LARL  ZC_R2,=FL8'1E5'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_191_1
*ZC    261         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    261         ELSE
         J     PG_IF_191_E
PG_IF_191_1  DS    0H  &TYPE
*ZC    261         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_191_E  DS    0H  &TYPE
*            DIVIDE P2  INTO H1  IF P3  = H1  PERFORM G ELSE PERFORM B.
*ZC    262         DIVIDE P2,INTO,H1
         MVC   ZCVT_NDDX(2),H1
         ZAP   ZCVT_PWORK1,P2
         CVBG  ZC_R2,ZCVT_PWORK1
         LGH   ZC_R1,ZCVT_NDDX
         LARL  ZC_R15,=FL8'1E6'
         MSG   1,0(ZC_R15)
         DSGR    0,2
         STH   1,H1
*ZC    262         IF    P3,=,H1
         LGH   ZC_R1,H1
         ZAP   ZCVT_PWORK1,P3
         CVBG  ZC_R0,ZCVT_PWORK1
         LARL  ZC_R2,=FL8'1E5'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_192_1
*ZC    262         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    262         ELSE
         J     PG_IF_192_E
PG_IF_192_1  DS    0H  &TYPE
*ZC    262         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_192_E  DS    0H  &TYPE
*            DIVIDE P2  INTO P1  IF P3  = P1  PERFORM G ELSE PERFORM B.
*ZC    263         DIVIDE P2,INTO,P1
         ZAP ZCVT_PWORK1(16),P1
         ZAP   ZCVT_PWORK2(16),P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         LARL  ZC_R2,=LD'1E6'
         LD    ZC_F4,0(ZC_R2)
         LD    ZC_F6,8(ZC_R2)
         MXTR  ZC_F0,ZC_F0,ZC_F4
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         ZAP   P1,ZCVT_PWORK4(16)
*ZC    263         IF    P3,=,P1
         ZAP   ZCVT_PWORK1,P3
         CVBG  ZC_R0,ZCVT_PWORK1
         ZAP   ZCVT_PWORK1,P1
         CVBG  ZC_R1,ZCVT_PWORK1
         LARL  ZC_R2,=FL8'1E5'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_193_1
*ZC    263         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    263         ELSE
         J     PG_IF_193_E
PG_IF_193_1  DS    0H  &TYPE
*ZC    263         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_193_E  DS    0H  &TYPE
*            DIVIDE P2  INTO Q1  IF P3  = Q1  PERFORM G ELSE PERFORM B.
*ZC    264         DIVIDE P2,INTO,Q1
         MVC   ZCVT_NDDX,Q1
         ZAP   ZCVT_PWORK2,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R0
         LGR   ZC_R3,ZC_R1
         LMG   ZC_R0,ZC_R1,ZCVT_NDDX
         STMG  ZC_R2,ZC_R3,ZCVT_WORKAREA
         LARL  ZC_R15,=FL16'1E6'
         LMG   ZC_R2,ZC_R3,0(ZC_R15)
         L     ZC_R15,ZCVT_MPYQ128      MPY DIVIDEND
         BASR  ZC_R14,ZC_R15
         LMG   ZC_R2,ZC_R3,ZCVT_WORKAREA   REST0RE DIVISOR
         L     ZC_R15,ZCVT_DIVQ128 DIVIDE SCALED DIVIDEND BY QUOTIENT
         BASR  ZC_R14,ZC_R15
         LTGR  ZC_R0,ZC_R0
         JNM   ZC_LPQR_13
         XG    ZC_R0,ZCVT_HIGH_VALUES
         XG    ZC_R0+1,ZCVT_HIGH_VALUES
         ALGFI ZC_R0+1,1
         ALCG  ZC_R0,ZCVT_ZERO
ZC_LPQR_13           DS 0H
         STMG  ZC_R2,ZC_R3,Q1
*ZC    264         IF    P3,=,Q1
         ZAP   ZCVT_PWORK1,P3
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LG    ZC_R2,Q1
         LG    ZC_R3,8+Q1
                  STMG  ZC_R0,ZC_R1,ZCVT_PWORK1
                  LGR   ZC_R0,ZC_R2
                  LGR   ZC_R1,ZC_R3
                  LARL  ZC_R2,=FL8'1E5'
                  LG    ZC_R3,0(ZC_R2)
                  SGR   ZC_R2,ZC_R2
                  L     ZC_R15,ZCVT_MPYQ128
                  BALR  ZC_R14,ZC_R15
                  LGR   ZC_R2,ZC_R0
                  LGR   ZC_R3,ZC_R1
                  LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CGR   ZC_R0,ZC_R2
         JNZ   *+4+4
         CGR   ZC_R0+1,ZC_R2+1
         BRC   15-ZC_EQ,PG_IF_194_1
*ZC    264         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    264         ELSE
         J     PG_IF_194_E
PG_IF_194_1  DS    0H  &TYPE
*ZC    264         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_194_E  DS    0H  &TYPE
*            DIVIDE P2  INTO Z1  IF P3  = Z1  PERFORM G ELSE PERFORM B.
*ZC    265         DIVIDE P2,INTO,Z1
         PACK  ZCVT_PWORK1(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z1(3)  PACK #3 FINAL
         ZAP    ZCVT_PWORK2(9),P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         ZAP   ZCVT_PWORK4,ZCVT_PWORK2(9)
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK4
         CXSTR ZC_F1,ZC_R0
         LARL  ZC_R2,=LD'1E6'
         LD    ZC_F4,0(ZC_R2)
         LD    ZC_F6,8(ZC_R2)
         MXTR  ZC_F0,ZC_F0,ZC_F4
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         UNPK  0+Z1(15),0+ZCVT_PWORK4(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK4(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK4(2) UNPK #3 FINAL
*ZC    265         IF    P3,=,Z1
         PACK  ZCVT_PWORK1(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z1(3)  PACK #3 FINAL
         CVBG  ZC_R1,ZCVT_PWORK1
         ZAP   ZCVT_PWORK1,P3
         CVBG  ZC_R0,ZCVT_PWORK1
         LARL  ZC_R2,=FL8'1E5'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_195_1
*ZC    265         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    265         ELSE
         J     PG_IF_195_E
PG_IF_195_1  DS    0H  &TYPE
*ZC    265         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_195_E  DS    0H  &TYPE
*            PERFORM INIT.
*ZC    266         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            DIVIDE Q2  INTO EH1 IF Q3  = EH1 PERFORM G ELSE PERFORM B.
*ZC    267         DIVIDE Q2,INTO,EH1
         LMG   ZC_R0,ZC_R1,Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R15,=EH'1E5'
         ME    0,0(ZC_R15)
         DER   0,1
         STE   ZC_F0,EH1
*ZC    267         IF    Q3,=,EH1
         LG    ZC_R0,Q3
         LG    ZC_R1,8+Q3
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,EH1
         LARL  ZC_R2,=EH'1E5'
         ME    ZC_R1,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_196_1
*ZC    267         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    267         ELSE
         J     PG_IF_196_E
PG_IF_196_1  DS    0H  &TYPE
*ZC    267         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_196_E  DS    0H  &TYPE
*            DIVIDE Q2  INTO DH1 IF Q3  = DH1 PERFORM G ELSE PERFORM B.
*ZC    268         DIVIDE Q2,INTO,DH1
         LG    ZC_R0,Q2
         LG    ZC_R1,8+Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DH1
         LARL  ZC_R15,=DH'1E5'
         MD    0,0(ZC_R15)
         DDR   0,1
         STD   ZC_F0,DH1
*ZC    268         IF    Q3,=,DH1
         LG    ZC_R0,Q3
         LG    ZC_R1,8+Q3
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DH1
         LARL  ZC_R2,=DH'1E5'
         MD    ZC_R1,0(ZC_R2)
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_197_1
*ZC    268         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    268         ELSE
         J     PG_IF_197_E
PG_IF_197_1  DS    0H  &TYPE
*ZC    268         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_197_E  DS    0H  &TYPE
*            DIVIDE Q2  INTO LH1 IF Q3  = LH1 PERFORM G ELSE PERFORM B.
*ZC    269         DIVIDE Q2,INTO,LH1
         LMG   ZC_R0,ZC_R1,Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LH1
         LD    ZC_F2,8+LH1
         LARL  ZC_R15,=LH'1E5'
         LD    ZC_F4,0(ZC_R15)
         LD    ZC_F6,8(ZC_R15)
         MXR   ZC_F0,ZC_F4
         DXR   ZC_F0,ZC_F1
         STD   ZC_F0,LH1
         STD   ZC_F2,8+LH1
*ZC    269         IF    Q3,=,LH1
         LG    ZC_R0,Q3
         LG    ZC_R1,8+Q3
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         STD   ZC_F0,ZCVT_PWORK
         STD   ZC_F2,ZCVT_PWORK+8
         LARL  ZC_R2,=LH'1E5'
         LD    ZC_F0,0(ZC_R2)
         LD    ZC_F2,8(ZC_R2)
         MXR   ZC_F1,ZC_F0
         LD    ZC_F0,ZCVT_PWORK
         LD    ZC_F2,ZCVT_PWORK+8
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_198_1
*ZC    269         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    269         ELSE
         J     PG_IF_198_E
PG_IF_198_1  DS    0H  &TYPE
*ZC    269         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_198_E  DS    0H  &TYPE
*            DIVIDE Q2  INTO EB1 IF Q3  = EB1 PERFORM G ELSE PERFORM B.
*ZC    270         DIVIDE Q2,INTO,EB1
         LMG   ZC_R0,ZC_R1,Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB1
         LARL  ZC_R15,=EB'1E5'
         MEEB  ZC_F0,0(ZC_R15)
         DEBR  0,1
         STE   ZC_F0,EB1
*ZC    270         IF    Q3,=,EB1
         LG    ZC_R0,Q3
         LG    ZC_R1,8+Q3
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,EB1
         LARL  ZC_R2,=EB'1E5'
         MDEB  ZC_F1,0(ZC_R2)
         LEDBR ZC_F1,ZC_F1
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_199_1
*ZC    270         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    270         ELSE
         J     PG_IF_199_E
PG_IF_199_1  DS    0H  &TYPE
*ZC    270         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_199_E  DS    0H  &TYPE
*            DIVIDE Q2  INTO DB1 IF Q3  = DB1 PERFORM G ELSE PERFORM B.
*ZC    271         DIVIDE Q2,INTO,DB1
         LMG   ZC_R0,ZC_R1,Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB1
         LARL  ZC_R15,=DB'1E5'
         MDB   0,0(ZC_R15)
         DDBR  0,1
         STD   ZC_F0,DB1
*ZC    271         IF    Q3,=,DB1
         LG    ZC_R0,Q3
         LG    ZC_R1,8+Q3
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DB1
         LARL  ZC_R2,=DB'1E5'
         MDB   ZC_R1,0(ZC_R2)
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_200_1
*ZC    271         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    271         ELSE
         J     PG_IF_200_E
PG_IF_200_1  DS    0H  &TYPE
*ZC    271         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_200_E  DS    0H  &TYPE
*            DIVIDE Q2  INTO LB1 IF Q3  = LB1 PERFORM G ELSE PERFORM B.
*ZC    272         DIVIDE Q2,INTO,LB1
         LMG   ZC_R0,ZC_R1,Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB1
         LD    ZC_F2,8+LB1
         LARL  ZC_R15,=LB'1E5'
         LD    ZC_F4,0(ZC_R15)
         LD    ZC_F6,8(ZC_R15)
         MXBR  ZC_F0,ZC_F4
         DXBR  ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LDR   ZC_F0,ZC_F4
         LDR   ZC_F2,ZC_F6
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC    272         IF    Q3,=,LB1
         LG    ZC_R0,Q3
         LG    ZC_R1,8+Q3
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         STD   ZC_F0,ZCVT_PWORK
         STD   ZC_F2,ZCVT_PWORK+8
         LARL  ZC_R2,=LB'1E5'
         LD    ZC_F0,0(ZC_R2)
         LD    ZC_F2,8(ZC_R2)
         MXBR  ZC_F1,ZC_F0
         LD    ZC_F0,ZCVT_PWORK
         LD    ZC_F2,ZCVT_PWORK+8
         CXBR  ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_201_1
*ZC    272         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    272         ELSE
         J     PG_IF_201_E
PG_IF_201_1  DS    0H  &TYPE
*ZC    272         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_201_E  DS    0H  &TYPE
*            DIVIDE Q2  INTO ED1 IF Q3  = ED1 PERFORM G ELSE PERFORM B.
*ZC    273         DIVIDE Q2,INTO,ED1
         LMG   ZC_R0,ZC_R1,Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED1
         LDETR ZC_F0,ZC_F0,0
         LARL  ZC_R2,=DD'1E5'
         LD    ZC_F4,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F4
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_ED,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         STE   ZC_F0,ED1
*ZC    273         IF    Q3,=,ED1
         LG    ZC_R0,Q3
         LG    ZC_R1,8+Q3
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         LARL  ZC_R2,=DD'1E5'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F1,ZC_F1,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_202_1
*ZC    273         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    273         ELSE
         J     PG_IF_202_E
PG_IF_202_1  DS    0H  &TYPE
*ZC    273         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_202_E  DS    0H  &TYPE
*            DIVIDE Q2  INTO DD1 IF Q3  = DD1 PERFORM G ELSE PERFORM B.
*ZC    274         DIVIDE Q2,INTO,DD1
         LMG   ZC_R0,ZC_R1,Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD1
         LARL  ZC_R2,=DD'1E5'
         LD    ZC_F4,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F4
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F0,ZC_F4
         STD   ZC_F0,DD1
*ZC    274         IF    Q3,=,DD1
         LG    ZC_R0,Q3
         LG    ZC_R1,8+Q3
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         LARL  ZC_R2,=DD'1E5'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F1,ZC_F1,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_203_1
*ZC    274         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    274         ELSE
         J     PG_IF_203_E
PG_IF_203_1  DS    0H  &TYPE
*ZC    274         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_203_E  DS    0H  &TYPE
*            DIVIDE Q2  INTO LD1 IF Q3  = LD1 PERFORM G ELSE PERFORM B.
*ZC    275         DIVIDE Q2,INTO,LD1
         LG    ZC_R0,Q2
         LG    ZC_R1,8+Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD1
         LD    ZC_F2,8+LD1
         LARL  ZC_R15,=LD'1E5'
         LD    ZC_F4,0(ZC_R15)
         LD    ZC_F6,8(ZC_R15)
         MXTR  ZC_F0,ZC_F0,ZC_F4
         DXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,LD1
         STD   ZC_F2,8+LD1
*ZC    275         IF    Q3,=,LD1
         LG    ZC_R0,Q3
         LG    ZC_R1,8+Q3
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         STD   ZC_F0,ZCVT_PWORK
         STD   ZC_F2,ZCVT_PWORK+8
         LARL  ZC_R2,=LD'1E5'
         LD    ZC_F0,0(ZC_R2)
         LD    ZC_F2,8(ZC_R2)
         MXTR  ZC_F1,ZC_F1,ZC_F0
         LD    ZC_F0,ZCVT_PWORK
         LD    ZC_F2,ZCVT_PWORK+8
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_204_1
*ZC    275         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    275         ELSE
         J     PG_IF_204_E
PG_IF_204_1  DS    0H  &TYPE
*ZC    275         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_204_E  DS    0H  &TYPE
*            DIVIDE Q2  INTO F1  IF Q3  = F1  PERFORM G ELSE PERFORM B.
*ZC    276         DIVIDE Q2,INTO,F1
         MVC   ZCVT_NDDX(4),F1
         LG    ZC_R2,8+Q2  IGNORE HIGH 96 BITS
         LGF   ZC_R1,ZCVT_NDDX
         LARL  ZC_R15,=FL8'1E5'
         MSG   1,0(ZC_R15)
         DSGR    0,2
         ST    1,F1
*ZC    276         IF    Q3,=,F1
         LG    ZC_R0,Q3
         LG    ZC_R1,8+Q3
         LGF   ZC_R3,F1
         LGR   ZC_R2,ZC_R3
         SRAG  ZC_R2,ZC_R2,63 SIGN FILL
                  STMG  ZC_R0,ZC_R1,ZCVT_PWORK1
                  LGR   ZC_R0,ZC_R2
                  LGR   ZC_R1,ZC_R3
                  LARL  ZC_R2,=FL8'1E4'
                  LG    ZC_R3,0(ZC_R2)
                  SGR   ZC_R2,ZC_R2
                  L     ZC_R15,ZCVT_MPYQ128
                  BALR  ZC_R14,ZC_R15
                  LGR   ZC_R2,ZC_R0
                  LGR   ZC_R3,ZC_R1
                  LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CGR   ZC_R0,ZC_R2
         JNZ   *+4+4
         CGR   ZC_R0+1,ZC_R2+1
         BRC   15-ZC_EQ,PG_IF_205_1
*ZC    276         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    276         ELSE
         J     PG_IF_205_E
PG_IF_205_1  DS    0H  &TYPE
*ZC    276         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_205_E  DS    0H  &TYPE
*            DIVIDE Q2  INTO G1  IF Q3  = G1  PERFORM G ELSE PERFORM B.
*ZC    277         DIVIDE Q2,INTO,G1
         MVC   ZCVT_NDDX(8),G1
         LG    2,8+Q2  IGNORE HIGH 64 BITS
         LG    1,ZCVT_NDDX
         LARL  ZC_R15,=FL8'1E5'
         MSG   1,0(ZC_R15)
         DSGR    0,2
         STG   1,G1
*ZC    277         IF    Q3,=,G1
         LG    ZC_R0,Q3
         LG    ZC_R1,8+Q3
         LG    ZC_R3,G1
         LGR   ZC_R2,ZC_R3
         SRAG  ZC_R2,ZC_R2,63 SIGN FILL
                  STMG  ZC_R0,ZC_R1,ZCVT_PWORK1
                  LGR   ZC_R0,ZC_R2
                  LGR   ZC_R1,ZC_R3
                  LARL  ZC_R2,=FL8'1E4'
                  LG    ZC_R3,0(ZC_R2)
                  SGR   ZC_R2,ZC_R2
                  L     ZC_R15,ZCVT_MPYQ128
                  BALR  ZC_R14,ZC_R15
                  LGR   ZC_R2,ZC_R0
                  LGR   ZC_R3,ZC_R1
                  LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CGR   ZC_R0,ZC_R2
         JNZ   *+4+4
         CGR   ZC_R0+1,ZC_R2+1
         BRC   15-ZC_EQ,PG_IF_206_1
*ZC    277         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    277         ELSE
         J     PG_IF_206_E
PG_IF_206_1  DS    0H  &TYPE
*ZC    277         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_206_E  DS    0H  &TYPE
*            DIVIDE Q2  INTO H1  IF Q3  = H1  PERFORM G ELSE PERFORM B.
*ZC    278         DIVIDE Q2,INTO,H1
         MVC   ZCVT_NDDX(2),H1
         LG    ZC_R2,8+Q2  IGNORE HIGH 64 BITS
         LGH   ZC_R1,ZCVT_NDDX
         LARL  ZC_R15,=FL8'1E5'
         MSG   1,0(ZC_R15)
         DSGR    0,2
         STH   1,H1
*ZC    278         IF    Q3,=,H1
         LG    ZC_R0,Q3
         LG    ZC_R1,8+Q3
         LGH   ZC_R3,H1
         LGR   ZC_R2,ZC_R3
         SRAG  ZC_R2,ZC_R2,63 SIGN FILL
                  STMG  ZC_R0,ZC_R1,ZCVT_PWORK1
                  LGR   ZC_R0,ZC_R2
                  LGR   ZC_R1,ZC_R3
                  LARL  ZC_R2,=FL8'1E4'
                  LG    ZC_R3,0(ZC_R2)
                  SGR   ZC_R2,ZC_R2
                  L     ZC_R15,ZCVT_MPYQ128
                  BALR  ZC_R14,ZC_R15
                  LGR   ZC_R2,ZC_R0
                  LGR   ZC_R3,ZC_R1
                  LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CGR   ZC_R0,ZC_R2
         JNZ   *+4+4
         CGR   ZC_R0+1,ZC_R2+1
         BRC   15-ZC_EQ,PG_IF_207_1
*ZC    278         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    278         ELSE
         J     PG_IF_207_E
PG_IF_207_1  DS    0H  &TYPE
*ZC    278         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_207_E  DS    0H  &TYPE
*            DIVIDE Q2  INTO P1  IF Q3  = P1  PERFORM G ELSE PERFORM B.
*ZC    279         DIVIDE Q2,INTO,P1
         ZAP ZCVT_PWORK1(16),P1
         LG    ZC_R0,Q2
         LG    ZC_R1,8+Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         LARL  ZC_R2,=LD'1E5'
         LD    ZC_F4,0(ZC_R2)
         LD    ZC_F6,8(ZC_R2)
         MXTR  ZC_F0,ZC_F0,ZC_F4
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         ZAP   P1,ZCVT_PWORK4(16)
*ZC    279         IF    Q3,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R0
         LGR   ZC_R3,ZC_R1
         LMG   ZC_R0,ZC_R1,Q3
                  STMG  ZC_R0,ZC_R1,ZCVT_PWORK1
                  LGR   ZC_R0,ZC_R2
                  LGR   ZC_R1,ZC_R3
                  LARL  ZC_R2,=FL8'1E4'
                  LG    ZC_R3,0(ZC_R2)
                  SGR   ZC_R2,ZC_R2
                  L     ZC_R15,ZCVT_MPYQ128
                  BALR  ZC_R14,ZC_R15
                  LGR   ZC_R2,ZC_R0
                  LGR   ZC_R3,ZC_R1
                  LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CGR   ZC_R0,ZC_R2
         JNZ   *+4+4
         CGR   ZC_R0+1,ZC_R2+1
         BRC   15-ZC_EQ,PG_IF_208_1
*ZC    279         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    279         ELSE
         J     PG_IF_208_E
PG_IF_208_1  DS    0H  &TYPE
*ZC    279         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_208_E  DS    0H  &TYPE
*            DIVIDE Q2  INTO Q1  IF Q3  = Q1  PERFORM G ELSE PERFORM B.
*ZC    280         DIVIDE Q2,INTO,Q1
         MVC   ZCVT_NDDX,Q1
         LMG   ZC_R2,ZC_R3,Q2
         LMG   ZC_R0,ZC_R1,ZCVT_NDDX
         STMG  ZC_R2,ZC_R3,ZCVT_WORKAREA
         LARL  ZC_R15,=FL16'1E5'
         LMG   ZC_R2,ZC_R3,0(ZC_R15)
         L     ZC_R15,ZCVT_MPYQ128      MPY DIVIDEND
         BASR  ZC_R14,ZC_R15
         LMG   ZC_R2,ZC_R3,ZCVT_WORKAREA   REST0RE DIVISOR
         L     ZC_R15,ZCVT_DIVQ128 DIVIDE SCALED DIVIDEND BY QUOTIENT
         BASR  ZC_R14,ZC_R15
         LTGR  ZC_R0,ZC_R0
         JNM   ZC_LPQR_14
         XG    ZC_R0,ZCVT_HIGH_VALUES
         XG    ZC_R0+1,ZCVT_HIGH_VALUES
         ALGFI ZC_R0+1,1
         ALCG  ZC_R0,ZCVT_ZERO
ZC_LPQR_14           DS 0H
         STMG  ZC_R2,ZC_R3,Q1
*ZC    280         IF    Q3,=,Q1
         LMG   ZC_R0,ZC_R1,Q3
         LMG   ZC_R2,ZC_R3,Q1
                  STMG  ZC_R0,ZC_R1,ZCVT_PWORK1
                  LGR   ZC_R0,ZC_R2
                  LGR   ZC_R1,ZC_R3
                  LARL  ZC_R2,=FL8'1E4'
                  LG    ZC_R3,0(ZC_R2)
                  SGR   ZC_R2,ZC_R2
                  L     ZC_R15,ZCVT_MPYQ128
                  BALR  ZC_R14,ZC_R15
                  LGR   ZC_R2,ZC_R0
                  LGR   ZC_R3,ZC_R1
                  LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CGR   ZC_R0,ZC_R2
         JNZ   *+4+4
         CGR   ZC_R0+1,ZC_R2+1
         BRC   15-ZC_EQ,PG_IF_209_1
*ZC    280         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    280         ELSE
         J     PG_IF_209_E
PG_IF_209_1  DS    0H  &TYPE
*ZC    280         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_209_E  DS    0H  &TYPE
*            DIVIDE Q2  INTO Z1  IF Q3  = Z1  PERFORM G ELSE PERFORM B.
*ZC    281         DIVIDE Q2,INTO,Z1
         PACK  ZCVT_PWORK1(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z1(3)  PACK #3 FINAL
         LG    ZC_R0,Q2
         LG    ZC_R1,8+Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         LARL  ZC_R2,=LD'1E5'
         LD    ZC_F4,0(ZC_R2)
         LD    ZC_F6,8(ZC_R2)
         MXTR  ZC_F0,ZC_F0,ZC_F4
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         UNPK  0+Z1(15),0+ZCVT_PWORK4(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK4(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK4(2) UNPK #3 FINAL
*ZC    281         IF    Q3,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R0
         LGR   ZC_R3,ZC_R1
         LMG   ZC_R0,ZC_R1,Q3
                  STMG  ZC_R0,ZC_R1,ZCVT_PWORK1
                  LGR   ZC_R0,ZC_R2
                  LGR   ZC_R1,ZC_R3
                  LARL  ZC_R2,=FL8'1E4'
                  LG    ZC_R3,0(ZC_R2)
                  SGR   ZC_R2,ZC_R2
                  L     ZC_R15,ZCVT_MPYQ128
                  BALR  ZC_R14,ZC_R15
                  LGR   ZC_R2,ZC_R0
                  LGR   ZC_R3,ZC_R1
                  LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CGR   ZC_R0,ZC_R2
         JNZ   *+4+4
         CGR   ZC_R0+1,ZC_R2+1
         BRC   15-ZC_EQ,PG_IF_210_1
*ZC    281         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    281         ELSE
         J     PG_IF_210_E
PG_IF_210_1  DS    0H  &TYPE
*ZC    281         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_210_E  DS    0H  &TYPE
*            PERFORM INIT.
*ZC    282         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            DIVIDE Z2  INTO EH1 IF Z3  = EH1 PERFORM G ELSE PERFORM B.
*ZC    283         DIVIDE Z2,INTO,EH1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R15,=EH'1E7'
         ME    0,0(ZC_R15)
         DER   0,1
         STE   ZC_F0,EH1
*ZC    283         IF    Z3,=,EH1
         PACK  ZCVT_PWORK1(8),0+Z3(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z3(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z3(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,EH1
         LARL  ZC_R2,=EH'1E7'
         ME    ZC_R1,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_211_1
*ZC    283         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    283         ELSE
         J     PG_IF_211_E
PG_IF_211_1  DS    0H  &TYPE
*ZC    283         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_211_E  DS    0H  &TYPE
*            DIVIDE Z2  INTO DH1 IF Z3  = DH1 PERFORM G ELSE PERFORM B.
*ZC    284         DIVIDE Z2,INTO,DH1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DH1
         LARL  ZC_R15,=DH'1E7'
         MD    0,0(ZC_R15)
         DDR   0,1
         STD   ZC_F0,DH1
*ZC    284         IF    Z3,=,DH1
         PACK  ZCVT_PWORK1(8),0+Z3(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z3(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z3(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DH1
         LARL  ZC_R2,=DH'1E7'
         MD    ZC_R1,0(ZC_R2)
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_212_1
*ZC    284         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    284         ELSE
         J     PG_IF_212_E
PG_IF_212_1  DS    0H  &TYPE
*ZC    284         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_212_E  DS    0H  &TYPE
*            DIVIDE Z2  INTO LH1 IF Z3  = LH1 PERFORM G ELSE PERFORM B.
*ZC    285         DIVIDE Z2,INTO,LH1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LH1
         LD    ZC_F2,8+LH1
         LARL  ZC_R15,=LH'1E7'
         LD    ZC_F4,0(ZC_R15)
         LD    ZC_F6,8(ZC_R15)
         MXR   ZC_F0,ZC_F4
         DXR   ZC_F0,ZC_F1
         STD   ZC_F0,LH1
         STD   ZC_F2,8+LH1
*ZC    285         IF    Z3,=,LH1
         PACK  ZCVT_PWORK1(8),0+Z3(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z3(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z3(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         STD   ZC_F0,ZCVT_PWORK
         STD   ZC_F2,ZCVT_PWORK+8
         LARL  ZC_R2,=LH'1E7'
         LD    ZC_F0,0(ZC_R2)
         LD    ZC_F2,8(ZC_R2)
         MXR   ZC_F1,ZC_F0
         LD    ZC_F0,ZCVT_PWORK
         LD    ZC_F2,ZCVT_PWORK+8
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_213_1
*ZC    285         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    285         ELSE
         J     PG_IF_213_E
PG_IF_213_1  DS    0H  &TYPE
*ZC    285         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_213_E  DS    0H  &TYPE
*            DIVIDE Z2  INTO EB1 IF Z3  = EB1 PERFORM G ELSE PERFORM B.
*ZC    286         DIVIDE Z2,INTO,EB1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB1
         LARL  ZC_R15,=EB'1E7'
         MEEB  ZC_F0,0(ZC_R15)
         DEBR  0,1
         STE   ZC_F0,EB1
*ZC    286         IF    Z3,=,EB1
         PACK  ZCVT_PWORK1(8),0+Z3(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z3(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z3(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,EB1
         LARL  ZC_R2,=EB'1E7'
         MDEB  ZC_F1,0(ZC_R2)
         LEDBR ZC_F1,ZC_F1
         CEBR  ZC_F0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_214_1
*ZC    286         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    286         ELSE
         J     PG_IF_214_E
PG_IF_214_1  DS    0H  &TYPE
*ZC    286         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_214_E  DS    0H  &TYPE
*            DIVIDE Z2  INTO DB1 IF Z3  = DB1 PERFORM G ELSE PERFORM B.
*ZC    287         DIVIDE Z2,INTO,DB1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB1
         LARL  ZC_R15,=DB'1E7'
         MDB   0,0(ZC_R15)
         DDBR  0,1
         STD   ZC_F0,DB1
*ZC    287         IF    Z3,=,DB1
         PACK  ZCVT_PWORK1(8),0+Z3(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z3(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z3(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DB1
         LARL  ZC_R2,=DB'1E7'
         MDB   ZC_R1,0(ZC_R2)
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_215_1
*ZC    287         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    287         ELSE
         J     PG_IF_215_E
PG_IF_215_1  DS    0H  &TYPE
*ZC    287         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_215_E  DS    0H  &TYPE
*            DIVIDE Z2  INTO LB1 IF Z3  = LB1 PERFORM G ELSE PERFORM B.
*ZC    288         DIVIDE Z2,INTO,LB1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB1
         LD    ZC_F2,8+LB1
         LARL  ZC_R15,=LB'1E7'
         LD    ZC_F4,0(ZC_R15)
         LD    ZC_F6,8(ZC_R15)
         MXBR  ZC_F0,ZC_F4
         DXBR  ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LDR   ZC_F0,ZC_F4
         LDR   ZC_F2,ZC_F6
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC    288         IF    Z3,=,LB1
         PACK  ZCVT_PWORK1(8),0+Z3(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z3(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z3(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         STD   ZC_F0,ZCVT_PWORK
         STD   ZC_F2,ZCVT_PWORK+8
         LARL  ZC_R2,=LB'1E7'
         LD    ZC_F0,0(ZC_R2)
         LD    ZC_F2,8(ZC_R2)
         MXBR  ZC_F1,ZC_F0
         LD    ZC_F0,ZCVT_PWORK
         LD    ZC_F2,ZCVT_PWORK+8
         CXBR  ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_216_1
*ZC    288         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    288         ELSE
         J     PG_IF_216_E
PG_IF_216_1  DS    0H  &TYPE
*ZC    288         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_216_E  DS    0H  &TYPE
*            DIVIDE Z2  INTO ED1 IF Z3  = ED1 PERFORM G ELSE PERFORM B.
*ZC    289         DIVIDE Z2,INTO,ED1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED1
         LDETR ZC_F0,ZC_F0,0
         LARL  ZC_R2,=DD'1E7'
         LD    ZC_F4,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F4
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_ED,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         STE   ZC_F0,ED1
*ZC    289         IF    Z3,=,ED1
         PACK  ZCVT_PWORK1(8),0+Z3(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z3(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z3(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         LARL  ZC_R2,=DD'1E7'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F1,ZC_F1,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_217_1
*ZC    289         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    289         ELSE
         J     PG_IF_217_E
PG_IF_217_1  DS    0H  &TYPE
*ZC    289         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_217_E  DS    0H  &TYPE
*            DIVIDE Z2  INTO DD1 IF Z3  = DD1 PERFORM G ELSE PERFORM B.
*ZC    290         DIVIDE Z2,INTO,DD1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD1
         LARL  ZC_R2,=DD'1E7'
         LD    ZC_F4,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F4
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F0,ZC_F4
         STD   ZC_F0,DD1
*ZC    290         IF    Z3,=,DD1
         PACK  ZCVT_PWORK1(8),0+Z3(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z3(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z3(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         LARL  ZC_R2,=DD'1E7'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F1,ZC_F1,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_218_1
*ZC    290         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    290         ELSE
         J     PG_IF_218_E
PG_IF_218_1  DS    0H  &TYPE
*ZC    290         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_218_E  DS    0H  &TYPE
*            DIVIDE Z2  INTO LD1 IF Z3  = LD1 PERFORM G ELSE PERFORM B.
*ZC    291         DIVIDE Z2,INTO,LD1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F0,ZC_R0
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LD1
         LD    ZC_F2,8+LD1
         LARL  ZC_R15,=LD'1E7'
         LD    ZC_F4,0(ZC_R15)
         LD    ZC_F6,8(ZC_R15)
         MXTR  ZC_F0,ZC_F0,ZC_F4
         DXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,LD1
         STD   ZC_F2,8+LD1
*ZC    291         IF    Z3,=,LD1
         PACK  ZCVT_PWORK1(8),0+Z3(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z3(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z3(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         STD   ZC_F0,ZCVT_PWORK
         STD   ZC_F2,ZCVT_PWORK+8
         LARL  ZC_R2,=LD'1E7'
         LD    ZC_F0,0(ZC_R2)
         LD    ZC_F2,8(ZC_R2)
         MXTR  ZC_F1,ZC_F1,ZC_F0
         LD    ZC_F0,ZCVT_PWORK
         LD    ZC_F2,ZCVT_PWORK+8
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_219_1
*ZC    291         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    291         ELSE
         J     PG_IF_219_E
PG_IF_219_1  DS    0H  &TYPE
*ZC    291         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_219_E  DS    0H  &TYPE
*            DIVIDE Z2  INTO F1  IF Z3  = F1  PERFORM G ELSE PERFORM B.
*ZC    292         DIVIDE Z2,INTO,F1
         MVC   ZCVT_NDDX(4),F1
         PACK  ZCVT_PWORK1(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z2(3)  PACK #3 FINAL
         CVBG  ZC_R2,ZCVT_PWORK1
         LGF   ZC_R1,ZCVT_NDDX
         LARL  ZC_R15,=FL8'1E7'
         MSG   1,0(ZC_R15)
         DSGR    0,2
         ST    1,F1
*ZC    292         IF    Z3,=,F1
         PACK  ZCVT_PWORK1(8),0+Z3(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z3(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z3(3)  PACK #3 FINAL
         CVBG  ZC_R0,ZCVT_PWORK1
         LGF   ZC_R1,F1
         LARL  ZC_R2,=FL8'1E6'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_220_1
*ZC    292         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    292         ELSE
         J     PG_IF_220_E
PG_IF_220_1  DS    0H  &TYPE
*ZC    292         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_220_E  DS    0H  &TYPE
*            DIVIDE Z2  INTO G1  IF Z3  = G1  PERFORM G ELSE PERFORM B.
*ZC    293         DIVIDE Z2,INTO,G1
         MVC   ZCVT_NDDX(8),G1
         PACK  ZCVT_PWORK1(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z2(3)  PACK #3 FINAL
         CVBG  2,ZCVT_PWORK1
         LG    1,ZCVT_NDDX
         LARL  ZC_R15,=FL8'1E7'
         MSG   1,0(ZC_R15)
         DSGR    0,2
         STG   1,G1
*ZC    293         IF    Z3,=,G1
         PACK  ZCVT_PWORK1(8),0+Z3(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z3(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z3(3)  PACK #3 FINAL
         CVBG  ZC_R0,ZCVT_PWORK1
         LG    ZC_R1,G1
         LARL  ZC_R2,=FL8'1E6'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_221_1
*ZC    293         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    293         ELSE
         J     PG_IF_221_E
PG_IF_221_1  DS    0H  &TYPE
*ZC    293         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_221_E  DS    0H  &TYPE
*            DIVIDE Z2  INTO H1  IF Z3  = H1  PERFORM G ELSE PERFORM B.
*ZC    294         DIVIDE Z2,INTO,H1
         MVC   ZCVT_NDDX(2),H1
         PACK  ZCVT_PWORK1(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z2(3)  PACK #3 FINAL
         CVBG  ZC_R2,ZCVT_PWORK1
         LGH   ZC_R1,ZCVT_NDDX
         LARL  ZC_R15,=FL8'1E7'
         MSG   1,0(ZC_R15)
         DSGR    0,2
         STH   1,H1
*ZC    294         IF    Z3,=,H1
         PACK  ZCVT_PWORK1(8),0+Z3(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z3(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z3(3)  PACK #3 FINAL
         CVBG  ZC_R0,ZCVT_PWORK1
         LGH   ZC_R1,H1
         LARL  ZC_R2,=FL8'1E6'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_222_1
*ZC    294         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    294         ELSE
         J     PG_IF_222_E
PG_IF_222_1  DS    0H  &TYPE
*ZC    294         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_222_E  DS    0H  &TYPE
*            DIVIDE Z2  INTO P1  IF Z3  = P1  PERFORM G ELSE PERFORM B.
*ZC    295         DIVIDE Z2,INTO,P1
         ZAP ZCVT_PWORK1(16),P1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         LARL  ZC_R2,=LD'1E7'
         LD    ZC_F4,0(ZC_R2)
         LD    ZC_F6,8(ZC_R2)
         MXTR  ZC_F0,ZC_F0,ZC_F4
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         ZAP   P1,ZCVT_PWORK4(16)
*ZC    295         IF    Z3,=,P1
         PACK  ZCVT_PWORK1(8),0+Z3(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z3(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z3(3)  PACK #3 FINAL
         CVBG  ZC_R0,ZCVT_PWORK1
         ZAP   ZCVT_PWORK2,P1
         CVBG  ZC_R1,ZCVT_PWORK2
         LARL  ZC_R2,=FL8'1E6'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_223_1
*ZC    295         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    295         ELSE
         J     PG_IF_223_E
PG_IF_223_1  DS    0H  &TYPE
*ZC    295         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_223_E  DS    0H  &TYPE
*            DIVIDE Z2  INTO Q1  IF Z3  = Q1  PERFORM G ELSE PERFORM B.
*ZC    296         DIVIDE Z2,INTO,Q1
         MVC   ZCVT_NDDX,Q1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R2,ZC_R0
         LGR   ZC_R3,ZC_R1
         LMG   ZC_R0,ZC_R1,ZCVT_NDDX
         STMG  ZC_R2,ZC_R3,ZCVT_WORKAREA
         LARL  ZC_R15,=FL16'1E7'
         LMG   ZC_R2,ZC_R3,0(ZC_R15)
         L     ZC_R15,ZCVT_MPYQ128      MPY DIVIDEND
         BASR  ZC_R14,ZC_R15
         LMG   ZC_R2,ZC_R3,ZCVT_WORKAREA   REST0RE DIVISOR
         L     ZC_R15,ZCVT_DIVQ128 DIVIDE SCALED DIVIDEND BY QUOTIENT
         BASR  ZC_R14,ZC_R15
         LTGR  ZC_R0,ZC_R0
         JNM   ZC_LPQR_15
         XG    ZC_R0,ZCVT_HIGH_VALUES
         XG    ZC_R0+1,ZCVT_HIGH_VALUES
         ALGFI ZC_R0+1,1
         ALCG  ZC_R0,ZCVT_ZERO
ZC_LPQR_15           DS 0H
         STMG  ZC_R2,ZC_R3,Q1
*ZC    296         IF    Z3,=,Q1
         PACK  ZCVT_PWORK1(8),0+Z3(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z3(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z3(3)  PACK #3 FINAL
         CVBG  ZC_R1,ZCVT_PWORK1
         LGR   ZC_R0,ZC_R1
         SRAG  ZC_R0,ZC_R0,63 SIGN FILL
         LMG   ZC_R2,ZC_R3,Q1
                  STMG  ZC_R0,ZC_R1,ZCVT_PWORK1
                  LGR   ZC_R0,ZC_R2
                  LGR   ZC_R1,ZC_R3
                  LARL  ZC_R2,=FL8'1E6'
                  LG    ZC_R3,0(ZC_R2)
                  SGR   ZC_R2,ZC_R2
                  L     ZC_R15,ZCVT_MPYQ128
                  BALR  ZC_R14,ZC_R15
                  LGR   ZC_R2,ZC_R0
                  LGR   ZC_R3,ZC_R1
                  LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CGR   ZC_R0,ZC_R2
         JNZ   *+4+4
         CGR   ZC_R0+1,ZC_R2+1
         BRC   15-ZC_EQ,PG_IF_224_1
*ZC    296         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    296         ELSE
         J     PG_IF_224_E
PG_IF_224_1  DS    0H  &TYPE
*ZC    296         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_224_E  DS    0H  &TYPE
*            DIVIDE Z2  INTO Z1  IF Z3  = Z1  PERFORM G ELSE PERFORM B.
*ZC    297         DIVIDE Z2,INTO,Z1
         PACK  ZCVT_PWORK1(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z1(3)  PACK #3 FINAL
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         LARL  ZC_R2,=LD'1E7'
         LD    ZC_F4,0(ZC_R2)
         LD    ZC_F6,8(ZC_R2)
         MXTR  ZC_F0,ZC_F0,ZC_F4
         DXTR  ZC_F0,ZC_F0,ZC_F1
         L     ZC_R15,ZCVT_CVTLDTP
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK4                   PW4=QUOTIENT
         UNPK  0+Z1(15),0+ZCVT_PWORK4(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK4(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK4(2) UNPK #3 FINAL
*ZC    297         IF    Z3,=,Z1
         PACK  ZCVT_PWORK1(8),0+Z3(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z3(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z3(3)  PACK #3 FINAL
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         SRP   ZCVT_PWORK2,6,0
         CP    ZCVT_PWORK1(16),ZCVT_PWORK2 RPI 1215
         BRC   15-ZC_EQ,PG_IF_225_1
*ZC    297         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    297         ELSE
         J     PG_IF_225_E
PG_IF_225_1  DS    0H  &TYPE
*ZC    297         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_225_E  DS    0H  &TYPE
*            DISPLAY 'TOTAL G = ' G ' TOTAL B = ' B
*ZC    298         DISPLAY 'TOTAL G = ',G,' TOTAL B = ',B
         LA    ZC_R3,ZCVT_WORKAREA  ZC_R3=CVT LIST WORK AREA
         LARL  ZC_R0,=CL10'TOTAL G = ' PAD TO EVEN LEN LIT
         LA    ZC_R1,10
         LA    ZC_R2,C'X'
         STM   ZC_R0,ZC_R2,0(ZC_R3)  SET DISPLAY LIST ENTRY
         LA    ZC_R0,G
         LA    ZC_R1,3  RPI 1182 WAS &SYM_LEN(&FIELD_IX)
         LA    ZC_R2,C'P'
         STM   ZC_R0,ZC_R2,12(ZC_R3)  SET DISPLAY LIST ENTRY
         LARL  ZC_R0,=CL12' TOTAL B = ' PAD TO EVEN LEN LIT
         LA    ZC_R1,11
         LA    ZC_R2,C'X'
         STM   ZC_R0,ZC_R2,24(ZC_R3)  SET DISPLAY LIST ENTRY
         LA    ZC_R0,B
         LA    ZC_R1,3  RPI 1182 WAS &SYM_LEN(&FIELD_IX)
         LA    ZC_R2,C'P'
         STM   ZC_R0,ZC_R2,36(ZC_R3)  SET DISPLAY LIST ENTRY
         OI    48-4(ZC_R3),X'80' SET VL BIT IN LAST WORD OF PARM LIST
         LR    ZC_R1,ZC_R3
         L     ZC_R15,ZCVT_DISPLAY
         BASR  ZC_R14,ZC_R15
*            STOP RUN.
*ZC    299         STOP  RUN
         LH    ZC_R1,RETURN_CODE      PASS RETURN CODE IN R1
         L     ZC_R15,ZCVT_GOBACK
         BR    ZC_R15
*        INIT.
PG_MAINLINE_END L ZC_R15,ZCVT_PMCHECK
         BASR  ZC_R14,ZC_R15 CHECK FOR END OF CURRENT PERFORM
PG_INIT  DS    0H
*            DISPLAY 'INIT'
*ZC    301         DISPLAY 'INIT'
         BRAS  1,*+(WTO#7033_EOT-*+1)/2*2
         DC    AL2(WTO#7033_EOT-*,0),C'INIT'
WTO#7033_EOT     EQU *
         SVC   35
*            MOVE 6.0 TO EH1.
*ZC    302         MOVE  6.0,TO,EH1
          LARL  ZC_R1,=EH'6.0'
          MVC   EH1,0(ZC_R1)
*            MOVE 6.0 TO DH1.
*ZC    303         MOVE  6.0,TO,DH1
          LARL  ZC_R1,=DH'6.0'
          MVC   DH1,0(ZC_R1)
*            MOVE 6.0 TO LH1.
*ZC    304         MOVE  6.0,TO,LH1
          LARL  ZC_R1,=LH'6.0'
          MVC   LH1,0(ZC_R1)
*            MOVE 6.0 TO EB1.
*ZC    305         MOVE  6.0,TO,EB1
          LARL  ZC_R1,=EB'6.0'
          MVC   EB1,0(ZC_R1)
*            MOVE 6.0 TO DB1.
*ZC    306         MOVE  6.0,TO,DB1
          LARL  ZC_R1,=DB'6.0'
          MVC   DB1,0(ZC_R1)
*            MOVE 6.0 TO LB1.
*ZC    307         MOVE  6.0,TO,LB1
          LARL  ZC_R1,=LB'6.0'
          MVC   LB1,0(ZC_R1)
*            MOVE 6.0 TO ED1.
*ZC    308         MOVE  6.0,TO,ED1
          LARL  ZC_R1,=ED'6.0'
          MVC   ED1,0(ZC_R1)
*            MOVE 6.0 TO DD1.
*ZC    309         MOVE  6.0,TO,DD1
          LARL  ZC_R1,=DD'6.0'
          MVC   DD1,0(ZC_R1)
*            MOVE 6.0 TO LD1.
*ZC    310         MOVE  6.0,TO,LD1
          LARL  ZC_R1,=LD'6.0'
          MVC   LD1,0(ZC_R1)
*            MOVE 6.0 TO F1.
*ZC    311         MOVE  6.0,TO,F1
          MVHI  F1,60
*            MOVE 6.0 TO G1.
*ZC    312         MOVE  6.0,TO,G1
          MVGHI G1,60
*            MOVE 6.0 TO H1.
*ZC    313         MOVE  6.0,TO,H1
          MVHHI H1,60
*            MOVE 6.0 TO P1.
*ZC    314         MOVE  6.0,TO,P1
          LARL  ZC_R1,=PL16'60'
          MVC   P1,0(ZC_R1)
*            MOVE 6.0 TO Q1.
*ZC    315         MOVE  6.0,TO,Q1
          LARL  ZC_R1,=FL16'60'
          MVC   Q1,0(ZC_R1)
*            MOVE 6.0 TO Z1.
*ZC    316         MOVE  6.0,TO,Z1
          LARL  ZC_R1,=ZL32'60'
          MVC   Z1,1(ZC_R1)
*        G.
PG_INIT_END L  ZC_R15,ZCVT_PMCHECK
         BASR  ZC_R14,ZC_R15 CHECK FOR END OF CURRENT PERFORM
PG_G     DS    0H
*            ADD 1 TO G.
*ZC    318         ADD   1,TO,G
         BRAS  ZC_R14,3 SET ZC_R1 TO A(INLINE LIT) AND SKIP OVER IT
         DC    PL2'1'
         AP    G,0(2,ZC_R14)
*            DISPLAY 'GOOD-TEST'.
*ZC    319         DISPLAY 'GOOD-TEST'
         BRAS  1,*+(WTO#7120_EOT-*+1)/2*2
         DC    AL2(WTO#7120_EOT-*,0),C'GOOD-TEST'
WTO#7120_EOT     EQU *
         SVC   35
*        B.
PG_G_END L     ZC_R15,ZCVT_PMCHECK
         BASR  ZC_R14,ZC_R15 CHECK FOR END OF CURRENT PERFORM
PG_B     DS    0H
*            ADD 1 TO B
*ZC    321         ADD   1,TO,B
         BRAS  ZC_R14,3 SET ZC_R1 TO A(INLINE LIT) AND SKIP OVER IT
         DC    PL2'1'
         AP    B,0(2,ZC_R14)
*            MOVE 16 TO RETURN-CODE..
*ZC    322         MOVE  16,TO,RETURN_CODE
          MVHHI RETURN_CODE,16
*            DISPLAY 'BAD-TEST'.
*      *    STOP RUN.
*ZC    323         DISPLAY 'BAD-TEST'
         BRAS  1,*+(WTO#7137_EOT-*+1)/2*2
         DC    AL2(WTO#7137_EOT-*,0),C'BAD-TEST'
WTO#7137_EOT     EQU *
         SVC   35
PG_B_END L     ZC_R15,ZCVT_PMCHECK
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
                      
*    01  FILLER                         00000058 00000000 1   X        X
                      
*    01  EH1                            00000058 00000004 1   1        X
                     6.0 
*    01  DH1                            0000005C 00000008 1   2        X
                     6.0 
*    01  LH1                            00000064 00000010 1   3        X
                     6.0 
*    01  EB1                            00000074 00000004 1   4        X
                     6.0 
*    01  DB1                            00000078 00000008 1   5        X
                     6.0 
*    01  LB1                            00000080 00000010 1   6        X
                     6.0 
*    01  ED1                            00000090 00000004 1   7        X
                     6.0 
*    01  DD1                            00000094 00000008 1   8        X
                     6.0 
*    01  LD1                            0000009C 00000010 1   9        X
                     6.0 
*    01  H1                             000000AC 00000002 1   H   9(3)VX
               9     60 
*    01  F1                             000000AE 00000004 1   F   9(8)VX
               9     60 
*    01  G1                             000000B2 00000008 1   G   9(17)X
               V9    60 
*    01  Q1                             000000BA 00000010 1   Q   9(38)X
               V9    60 
*    01  P1                             000000CA 00000010 1   P   9(30)X
               V9    60 
*    01  Z1                             000000DA 0000001F 1   Z   9(30)X
               V9    60 
*    01  EH2                            000000F9 00000004 1   1        X
                     2.00 
*    01  DH2                            000000FD 00000008 1   2        X
                     2.00 
*    01  LH2                            00000105 00000010 1   3        X
                     2.00 
*    01  EB2                            00000115 00000004 1   4        X
                     2.00 
*    01  DB2                            00000119 00000008 1   5        X
                     2.00 
*    01  LB2                            00000121 00000010 1   6        X
                     2.00 
*    01  ED2                            00000131 00000004 1   7        X
                     2.00 
*    01  DD2                            00000135 00000008 1   8        X
                     2.00 
*    01  LD2                            0000013D 00000010 1   9        X
                     2.00 
*    01  H2                             0000014D 00000002 1   H   9(2)VX
               99    200 
*    01  F2                             0000014F 00000004 1   F   9(6)VX
               999   2000 
*    01  G2                             00000153 00000008 1   G   9(14)X
               V9999 20000 
*    01  Q2                             0000015B 00000010 1   Q   9(34)X
               V9999 200000 
*    01  P2                             0000016B 00000010 1   P   9(25)X
               V9999 2000000 
*    01  Z2                             0000017B 0000001F 1   Z   9(24)X
               V9999 20000000 
*    01  EH3                            0000019A 00000004 1   1        X
                     3.00 
*    01  DH3                            0000019E 00000008 1   2        X
                     3.00 
*    01  LH3                            000001A6 00000010 1   3        X
                     3.00 
*    01  EB3                            000001B6 00000004 1   4        X
                     3.00 
*    01  DB3                            000001BA 00000008 1   5        X
                     3.00 
*    01  LB3                            000001C2 00000010 1   6        X
                     3.00 
*    01  ED3                            000001D2 00000004 1   7        X
                     3.00 
*    01  DD3                            000001D6 00000008 1   8        X
                     3.00 
*    01  LD3                            000001DE 00000010 1   9        X
                     3.00 
*    01  H3                             000001EE 00000002 1   H   9(2)VX
               99    300 
*    01  F3                             000001F0 00000004 1   F   9(6)VX
               999   3000 
*    01  G3                             000001F4 00000008 1   G   9(14)X
               V9999 30000 
*    01  Q3                             000001FC 00000010 1   Q   9(34)X
               V9999 300000 
*    01  P3                             0000020C 00000010 1   P   9(25)X
               V9999 3000000 
*    01  Z3                             0000021C 0000001F 1   Z   9(24)X
               V9999 30000000 
*    01  G                              0000023B 00000003 1   P   9(4) X
                     0 
*    01  B                              0000023E 00000003 1   P   9(4) X
                     0 
*    01  DEBUG_ITEM                     00000241 00000058 1   X        X
                      
*    02  DEBUG_LINE                     00000241 00000006 1   X   X(6) X
                      
*    02  FILLER                         00000247 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_NAME                     00000248 0000001E 1   X   X(30)X
                      
*    02  FILLER                         00000266 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_1                    00000267 00000004 1   Z   9999 X
                      
*    02  FILLER                         0000026B 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_2                    0000026C 00000004 1   Z   9999 X
                      
*    02  FILLER                         00000270 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_3                    00000271 00000004 1   Z   9999 X
                      
*    02  FILLER                         00000275 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_CONTENTS                 00000276 00000023 1   X   X(35)X
                      
*    01  TRUE                           00000299 00000001 1   Z   9    X
                     1 
*    01  FALSE                          0000029A 00000001 1   Z   9    X
                     0 
*    01  RETURN_CODE                    0000029B 00000002 1   H   9(4) X
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
         DS  0CL0
ZC_WS_LOC_6  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
EH1      DC EHL4'6.0'
ZC_WS_LOC_7  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DH1      DC DHL8'6.0'
ZC_WS_LOC_8  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
LH1      DC LHL16'6.0'
ZC_WS_LOC_9  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
EB1      DC EBL4'6.0'
ZC_WS_LOC_10 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DB1      DC DBL8'6.0'
ZC_WS_LOC_11 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
LB1      DC LBL16'6.0'
ZC_WS_LOC_12 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ED1      DC EDL4'6.0'
ZC_WS_LOC_13 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DD1      DC DDL8'6.0'
ZC_WS_LOC_14 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
LD1      DC LDL16'6.0'
ZC_WS_LOC_15 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
H1       DC AL2(60)                  RPI 1065
ZC_WS_LOC_16 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
F1       DC AL4(60)                  RPI 1065
ZC_WS_LOC_17 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
G1       DC FL8'60'                  RPI 1065
ZC_WS_LOC_18 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
Q1       DC FL16'60'                 RPI 1065
ZC_WS_LOC_19 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
P1       DC PL16'60'
ZC_WS_LOC_20 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
Z1       DC ZL31'60'
ZC_WS_LOC_21 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
EH2      DC EHL4'2.00'
ZC_WS_LOC_22 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DH2      DC DHL8'2.00'
ZC_WS_LOC_23 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
LH2      DC LHL16'2.00'
ZC_WS_LOC_24 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
EB2      DC EBL4'2.00'
ZC_WS_LOC_25 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DB2      DC DBL8'2.00'
ZC_WS_LOC_26 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
LB2      DC LBL16'2.00'
ZC_WS_LOC_27 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ED2      DC EDL4'2.00'
ZC_WS_LOC_28 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DD2      DC DDL8'2.00'
ZC_WS_LOC_29 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
LD2      DC LDL16'2.00'
ZC_WS_LOC_30 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
H2       DC AL2(200)                  RPI 1065
ZC_WS_LOC_31 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
F2       DC AL4(2000)                  RPI 1065
ZC_WS_LOC_32 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
G2       DC FL8'20000'                  RPI 1065
ZC_WS_LOC_33 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
Q2       DC FL16'200000'                 RPI 1065
ZC_WS_LOC_34 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
P2       DC PL16'2000000'
ZC_WS_LOC_35 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
Z2       DC ZL31'20000000'
ZC_WS_LOC_36 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
EH3      DC EHL4'3.00'
ZC_WS_LOC_37 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DH3      DC DHL8'3.00'
ZC_WS_LOC_38 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
LH3      DC LHL16'3.00'
ZC_WS_LOC_39 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
EB3      DC EBL4'3.00'
ZC_WS_LOC_40 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DB3      DC DBL8'3.00'
ZC_WS_LOC_41 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
LB3      DC LBL16'3.00'
ZC_WS_LOC_42 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ED3      DC EDL4'3.00'
ZC_WS_LOC_43 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DD3      DC DDL8'3.00'
ZC_WS_LOC_44 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
LD3      DC LDL16'3.00'
ZC_WS_LOC_45 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
H3       DC AL2(300)                  RPI 1065
ZC_WS_LOC_46 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
F3       DC AL4(3000)                  RPI 1065
ZC_WS_LOC_47 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
G3       DC FL8'30000'                  RPI 1065
ZC_WS_LOC_48 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
Q3       DC FL16'300000'                 RPI 1065
ZC_WS_LOC_49 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
P3       DC PL16'3000000'
ZC_WS_LOC_50 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
Z3       DC ZL31'30000000'
ZC_WS_LOC_51 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
G        DC PL3'0'
ZC_WS_LOC_52 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
B        DC PL3'0'
ZC_WS_LOC_53 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_ITEM DS 0CL88
ZC_WS_LOC_54 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_LINE DS CL6
ZC_WS_LOC_55 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_56 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_NAME DS CL30
ZC_WS_LOC_57 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_58 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_1 DS ZL4
ZC_WS_LOC_59 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_60 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_2 DS ZL4
ZC_WS_LOC_61 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_62 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_3 DS ZL4
ZC_WS_LOC_63 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_64 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_CONTENTS DS CL35
ZC_WS_LOC_65 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
TRUE     DC CL1'1'
ZC_WS_LOC_66 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
FALSE    DC CL1'0'
ZC_WS_LOC_67 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
RETURN_CODE DC AL2(0)                  RPI 1065
*    ZCOBOL LINKAGE SECTION DATA ITEMS 
*    LVL DATA NAME                      ADDR     LEN      DUP TYP PIC  X
                     VALUE 
ZC_WSLOC LOCTR 
ZC_WSLOC LOCTR 
ZC_WS_DIFF EQU  *-ZC_WS-669  DIFF BETWEEN ALLOC AND CALC WS
ZC_WS_END DS   0D
         MNOTE *,'ZCOBOL TOTAL SYMBOLS                 = 67'
         MNOTE *,'ZCOBOL TOTAL SYMBOL DUPLICATES       = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL MAX DUP CHAIN    = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL LEVEL 88         = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL SET INDEXES      = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL LINKAGE SECTIONS = 0'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE SECTIONS      = 0'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE PARAGRAPHS    = 4'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE PARAGRAPH DUP = 0'
         END 
