*    ZCOBOL PGM='zcobol\test\TESTMOV2' VER=V1.5.06 MM/DD/YY  
*    ZCOBOL OPTIONS=() 
         COPY  TESTMOV2_ZC_LABELS.CPY
*        IDENTIFICATION DIVISION.
*        PROGRAM-ID.    TESTMOV1.
         PRINT NOLIST,NOGEN,NOLISTUSE    SET LIST OPTION FOR INTERNAL CX
               ODE
TESTMOV1 CSECT ,                CSECT WITH PROCEDURE CODE AND WS
         USING *,ZC_R15
         STM   14,12,12+4*(14-14)(13)
         CNOP  4,8             FORCE ZC390PVT TO DOUBLEWORD BOUNDARY
         BRAS  ZC_R8,ZC_LOAD
         USING *,ZC_R8            BASE FOR LOAD AND CICS V5 USE
*
*  THESE FIELDS MUST BE KEPT IN SYNC WITH zcobol\ZC390PVT.CPY
*
         DC    CL8'TESTMOV1'    PVTPGM   ZCOBOL PGM NAME
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
*      * TEST MOVE ALIGNMENT  FOR NON FP TYPES
*        ENVIRONMENT DIVISION.
*        DATA DIVISION.
         PRINT DATA
*        WORKING-STORAGE SECTION.
*         01  DF30   PIC ' ZZ9.'.
*         01  DF31   PIC ' ZZ9.9'.
*         01  DF32   PIC ' ZZ9.99'.
*         77  ZF30   PIC S9(3)    VALUE 123.
*         77  ZF31   PIC S9(3)V9  VALUE 123.4.
*         77  ZF32   PIC S9(3)V99 VALUE 123.45.
*         77  PF30   COMP-3 PIC S9(3)    VALUE 123.
*         77  PF31   COMP-3 PIC S9(3)V9  VALUE 123.4.
*         77  PF32   COMP-3 PIC S9(3)V99 VALUE 123.45.
*         77  HF30   COMP   PIC S9(3)    VALUE 123.
*         77  HF31   COMP   PIC S9(3)V9  VALUE 123.4.
*         77  HF32   COMP   PIC S9(2)V99 VALUE 23.45.
*         77  FF30   COMP   PIC S9(6)    VALUE 123.
*         77  FF31   COMP   PIC S9(6)V9  VALUE 123.4.
*         77  FF32   COMP   PIC S9(6)V99 VALUE 123.45.
*         77  GF30   COMP   PIC S9(16)    VALUE 123.
*         77  GF31   COMP   PIC S9(16)V9  VALUE 123.4.
*         77  GF32   COMP   PIC S9(16)V99 VALUE 23.45.
*         77  QF30   COMP   PIC S9(29)    VALUE 123.
*         77  QF31   COMP   PIC S9(29)V9  VALUE 123.4.
*         77  QF32   COMP   PIC S9(29)V99 VALUE 123.45.
*         77  GOOD   COMP PIC S9(9) VALUE 0.
*        PROCEDURE DIVISION.
*ZC   PROCEDURE DIVISION
         PRINT LIST,GEN,LISTUSE TURN PRINT LISTING ON FOR USER CODE GEN
TESTMOV1 CSECT                SWITCH TO PROCEDURE CODE AHEAD OF WS
*        MAINLINE.
PG_MAINLINE DS 0H
*     Z1     MOVE ZF30 TO DF30                                         
*ZC     32     Z1  MOVE  ZF30,TO,DF30
         PACK  ZCVT_PWORK(8),0+ZF30(3) PACK #1 NORMAL
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',0)
         MVC   ZCVT_WORKAREA(7),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(7),8-2+ZCVT_PWORK
         MVC   DF30,ZCVT_WORKAREA+2
*            IF DF30 NOT = ' 123'     PERFORM BAD ELSE PERFORM GOOD.
*ZC     33         IF    DF30,NOT,=,' 123'
         LARL  ZC_R1,=CL4' 123'
         CLC   DF30,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_1_1
*ZC     33         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     33         ELSE
         J     PG_IF_1_E
PG_IF_1_1    DS    0H  &TYPE
*ZC     33         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_1_E    DS    0H  &TYPE
*     Z2     MOVE ZF30 TO DF31                                         
*ZC     34     Z2  MOVE  ZF30,TO,DF31
         PACK  ZCVT_PWORK(8),0+ZF30(3) PACK #1 NORMAL
         SRP   ZCVT_PWORK(8),1,0
         LARL  ZC_R1,=AL1(C' ',X'20',C' ',X'20',X'21',X'20',C'.',X'20')
         MVC   ZCVT_WORKAREA(8),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(8),8-3+ZCVT_PWORK
         MVC   DF31,ZCVT_WORKAREA+2
*            IF DF31 NOT = ' 123.0'   PERFORM BAD ELSE PERFORM GOOD.   
*ZC     35         IF    DF31,NOT,=,' 123.0'
         LARL  ZC_R1,=CL6' 123.0'
         CLC   DF31,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_2_1
*ZC     35         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     35         ELSE
         J     PG_IF_2_E
PG_IF_2_1    DS    0H  &TYPE
*ZC     35         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_2_E    DS    0H  &TYPE
*     Z3     MOVE ZF30 TO DF32                                         
*ZC     36     Z3  MOVE  ZF30,TO,DF32
         PACK  ZCVT_PWORK(8),0+ZF30(3) PACK #1 NORMAL
         SRP   ZCVT_PWORK(8),2,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',X'20',XX
               '20',0)
         MVC   ZCVT_WORKAREA(9),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(9),8-3+ZCVT_PWORK
         MVC   DF32,ZCVT_WORKAREA+2
*            IF DF32 NOT = ' 123.00'  PERFORM BAD ELSE PERFORM GOOD.
*ZC     37         IF    DF32,NOT,=,' 123.00'
         LARL  ZC_R1,=CL8' 123.00'
         CLC   DF32,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_3_1
*ZC     37         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     37         ELSE
         J     PG_IF_3_E
PG_IF_3_1    DS    0H  &TYPE
*ZC     37         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_3_E    DS    0H  &TYPE
*     Z4     MOVE ZF31 TO DF30                                         
*ZC     38     Z4  MOVE  ZF31,TO,DF30
         PACK  ZCVT_PWORK(8),0+ZF31(4) PACK #1 NORMAL
         SRP   ZCVT_PWORK(8),63,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',0)
         MVC   ZCVT_WORKAREA(7),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(7),8-2+ZCVT_PWORK
         MVC   DF30,ZCVT_WORKAREA+2
*            IF DF30 NOT = ' 123'     PERFORM BAD ELSE PERFORM GOOD.
*ZC     39         IF    DF30,NOT,=,' 123'
         LARL  ZC_R1,=CL4' 123'
         CLC   DF30,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_4_1
*ZC     39         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     39         ELSE
         J     PG_IF_4_E
PG_IF_4_1    DS    0H  &TYPE
*ZC     39         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_4_E    DS    0H  &TYPE
*     Z5     MOVE ZF31 TO DF31                                         
*ZC     40     Z5  MOVE  ZF31,TO,DF31
         PACK  ZCVT_PWORK(8),0+ZF31(4) PACK #1 NORMAL
         LARL  ZC_R1,=AL1(C' ',X'20',C' ',X'20',X'21',X'20',C'.',X'20')
         MVC   ZCVT_WORKAREA(8),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(8),8-3+ZCVT_PWORK
         MVC   DF31,ZCVT_WORKAREA+2
*            IF DF31 NOT = ' 123.4'   PERFORM BAD ELSE PERFORM GOOD.   
*ZC     41         IF    DF31,NOT,=,' 123.4'
         LARL  ZC_R1,=CL6' 123.4'
         CLC   DF31,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_5_1
*ZC     41         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     41         ELSE
         J     PG_IF_5_E
PG_IF_5_1    DS    0H  &TYPE
*ZC     41         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_5_E    DS    0H  &TYPE
*     Z6     MOVE ZF31 TO DF32                                         
*ZC     42     Z6  MOVE  ZF31,TO,DF32
         PACK  ZCVT_PWORK(8),0+ZF31(4) PACK #1 NORMAL
         SRP   ZCVT_PWORK(8),1,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',X'20',XX
               '20',0)
         MVC   ZCVT_WORKAREA(9),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(9),8-3+ZCVT_PWORK
         MVC   DF32,ZCVT_WORKAREA+2
*            IF DF32 NOT = ' 123.40'  PERFORM BAD ELSE PERFORM GOOD.
*ZC     43         IF    DF32,NOT,=,' 123.40'
         LARL  ZC_R1,=CL8' 123.40'
         CLC   DF32,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_6_1
*ZC     43         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     43         ELSE
         J     PG_IF_6_E
PG_IF_6_1    DS    0H  &TYPE
*ZC     43         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_6_E    DS    0H  &TYPE
*     Z7     MOVE ZF32 TO DF30                                         
*ZC     44     Z7  MOVE  ZF32,TO,DF30
         PACK  ZCVT_PWORK(8),0+ZF32(5) PACK #1 NORMAL
         SRP   ZCVT_PWORK(8),62,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',0)
         MVC   ZCVT_WORKAREA(7),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(7),8-2+ZCVT_PWORK
         MVC   DF30,ZCVT_WORKAREA+2
*            IF DF30 NOT = ' 123'     PERFORM BAD ELSE PERFORM GOOD.
*ZC     45         IF    DF30,NOT,=,' 123'
         LARL  ZC_R1,=CL4' 123'
         CLC   DF30,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_7_1
*ZC     45         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     45         ELSE
         J     PG_IF_7_E
PG_IF_7_1    DS    0H  &TYPE
*ZC     45         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_7_E    DS    0H  &TYPE
*     Z8     MOVE ZF32 TO DF31                                         
*ZC     46     Z8  MOVE  ZF32,TO,DF31
         PACK  ZCVT_PWORK(8),0+ZF32(5) PACK #1 NORMAL
         SRP   ZCVT_PWORK(8),63,0
         LARL  ZC_R1,=AL1(C' ',X'20',C' ',X'20',X'21',X'20',C'.',X'20')
         MVC   ZCVT_WORKAREA(8),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(8),8-3+ZCVT_PWORK
         MVC   DF31,ZCVT_WORKAREA+2
*            IF DF31 NOT = ' 123.4'   PERFORM BAD ELSE PERFORM GOOD.   
*ZC     47         IF    DF31,NOT,=,' 123.4'
         LARL  ZC_R1,=CL6' 123.4'
         CLC   DF31,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_8_1
*ZC     47         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     47         ELSE
         J     PG_IF_8_E
PG_IF_8_1    DS    0H  &TYPE
*ZC     47         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_8_E    DS    0H  &TYPE
*     Z9     MOVE ZF32 TO DF32                                         
*ZC     48     Z9  MOVE  ZF32,TO,DF32
         PACK  ZCVT_PWORK(8),0+ZF32(5) PACK #1 NORMAL
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',X'20',XX
               '20',0)
         MVC   ZCVT_WORKAREA(9),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(9),8-3+ZCVT_PWORK
         MVC   DF32,ZCVT_WORKAREA+2
*            IF DF32 NOT = ' 123.45'  PERFORM BAD ELSE PERFORM GOOD.   
*ZC     49         IF    DF32,NOT,=,' 123.45'
         LARL  ZC_R1,=CL8' 123.45'
         CLC   DF32,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_9_1
*ZC     49         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     49         ELSE
         J     PG_IF_9_E
PG_IF_9_1    DS    0H  &TYPE
*ZC     49         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_9_E    DS    0H  &TYPE
*     P1     MOVE PF30 TO DF30                                         
*ZC     50     P1  MOVE  PF30,TO,DF30
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',0)
         MVC   ZCVT_WORKAREA(7),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(7),2-2+PF30
         MVC   DF30,ZCVT_WORKAREA+2
*             IF DF30 NOT = ' 123'     PERFORM BAD ELSE PERFORM GOOD.
*ZC     51         IF    DF30,NOT,=,' 123'
         LARL  ZC_R1,=CL4' 123'
         CLC   DF30,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_10_1
*ZC     51         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     51         ELSE
         J     PG_IF_10_E
PG_IF_10_1   DS    0H  &TYPE
*ZC     51         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_10_E   DS    0H  &TYPE
*     P2     MOVE PF30 TO DF31                                         
*ZC     52     P2  MOVE  PF30,TO,DF31
         ZAP   ZCVT_PWORK(8),PF30(2)
         SRP   ZCVT_PWORK(8),1,0
         LARL  ZC_R1,=AL1(C' ',X'20',C' ',X'20',X'21',X'20',C'.',X'20')
         MVC   ZCVT_WORKAREA(8),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(8),8-3+ZCVT_PWORK
         MVC   DF31,ZCVT_WORKAREA+2
*             IF DF31 NOT = ' 123.0'   PERFORM BAD ELSE PERFORM GOOD.  
*ZC     53         IF    DF31,NOT,=,' 123.0'
         LARL  ZC_R1,=CL6' 123.0'
         CLC   DF31,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_11_1
*ZC     53         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     53         ELSE
         J     PG_IF_11_E
PG_IF_11_1   DS    0H  &TYPE
*ZC     53         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_11_E   DS    0H  &TYPE
*     P3     MOVE PF30 TO DF32                                         
*ZC     54     P3  MOVE  PF30,TO,DF32
         ZAP   ZCVT_PWORK(8),PF30(2)
         SRP   ZCVT_PWORK(8),2,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',X'20',XX
               '20',0)
         MVC   ZCVT_WORKAREA(9),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(9),8-3+ZCVT_PWORK
         MVC   DF32,ZCVT_WORKAREA+2
*             IF DF32 NOT = ' 123.00'  PERFORM BAD ELSE PERFORM GOOD.
*ZC     55         IF    DF32,NOT,=,' 123.00'
         LARL  ZC_R1,=CL8' 123.00'
         CLC   DF32,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_12_1
*ZC     55         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     55         ELSE
         J     PG_IF_12_E
PG_IF_12_1   DS    0H  &TYPE
*ZC     55         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_12_E   DS    0H  &TYPE
*     P4     MOVE PF31 TO DF30                                         
*ZC     56     P4  MOVE  PF31,TO,DF30
         ZAP   ZCVT_PWORK(8),PF31(3)
         SRP   ZCVT_PWORK(8),63,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',0)
         MVC   ZCVT_WORKAREA(7),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(7),8-2+ZCVT_PWORK
         MVC   DF30,ZCVT_WORKAREA+2
*             IF DF30 NOT = ' 123'     PERFORM BAD ELSE PERFORM GOOD.
*ZC     57         IF    DF30,NOT,=,' 123'
         LARL  ZC_R1,=CL4' 123'
         CLC   DF30,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_13_1
*ZC     57         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     57         ELSE
         J     PG_IF_13_E
PG_IF_13_1   DS    0H  &TYPE
*ZC     57         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_13_E   DS    0H  &TYPE
*     P5     MOVE PF31 TO DF31                                         
*ZC     58     P5  MOVE  PF31,TO,DF31
         LARL  ZC_R1,=AL1(C' ',X'20',C' ',X'20',X'21',X'20',C'.',X'20')
         MVC   ZCVT_WORKAREA(8),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(8),3-3+PF31
         MVC   DF31,ZCVT_WORKAREA+2
*             IF DF31 NOT = ' 123.4'   PERFORM BAD ELSE PERFORM GOOD.  
*ZC     59         IF    DF31,NOT,=,' 123.4'
         LARL  ZC_R1,=CL6' 123.4'
         CLC   DF31,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_14_1
*ZC     59         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     59         ELSE
         J     PG_IF_14_E
PG_IF_14_1   DS    0H  &TYPE
*ZC     59         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_14_E   DS    0H  &TYPE
*     P6     MOVE PF31 TO DF32                                         
*ZC     60     P6  MOVE  PF31,TO,DF32
         ZAP   ZCVT_PWORK(8),PF31(3)
         SRP   ZCVT_PWORK(8),1,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',X'20',XX
               '20',0)
         MVC   ZCVT_WORKAREA(9),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(9),8-3+ZCVT_PWORK
         MVC   DF32,ZCVT_WORKAREA+2
*             IF DF32 NOT = ' 123.40'  PERFORM BAD ELSE PERFORM GOOD.
*ZC     61         IF    DF32,NOT,=,' 123.40'
         LARL  ZC_R1,=CL8' 123.40'
         CLC   DF32,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_15_1
*ZC     61         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     61         ELSE
         J     PG_IF_15_E
PG_IF_15_1   DS    0H  &TYPE
*ZC     61         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_15_E   DS    0H  &TYPE
*     P7     MOVE PF32 TO DF30                                         
*ZC     62     P7  MOVE  PF32,TO,DF30
         ZAP   ZCVT_PWORK(8),PF32(3)
         SRP   ZCVT_PWORK(8),62,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',0)
         MVC   ZCVT_WORKAREA(7),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(7),8-2+ZCVT_PWORK
         MVC   DF30,ZCVT_WORKAREA+2
*             IF DF30 NOT = ' 123'     PERFORM BAD ELSE PERFORM GOOD.
*ZC     63         IF    DF30,NOT,=,' 123'
         LARL  ZC_R1,=CL4' 123'
         CLC   DF30,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_16_1
*ZC     63         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     63         ELSE
         J     PG_IF_16_E
PG_IF_16_1   DS    0H  &TYPE
*ZC     63         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_16_E   DS    0H  &TYPE
*     P8     MOVE PF32 TO DF31                                         
*ZC     64     P8  MOVE  PF32,TO,DF31
         ZAP   ZCVT_PWORK(8),PF32(3)
         SRP   ZCVT_PWORK(8),63,0
         LARL  ZC_R1,=AL1(C' ',X'20',C' ',X'20',X'21',X'20',C'.',X'20')
         MVC   ZCVT_WORKAREA(8),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(8),8-3+ZCVT_PWORK
         MVC   DF31,ZCVT_WORKAREA+2
*             IF DF31 NOT = ' 123.4'   PERFORM BAD ELSE PERFORM GOOD.  
*ZC     65         IF    DF31,NOT,=,' 123.4'
         LARL  ZC_R1,=CL6' 123.4'
         CLC   DF31,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_17_1
*ZC     65         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     65         ELSE
         J     PG_IF_17_E
PG_IF_17_1   DS    0H  &TYPE
*ZC     65         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_17_E   DS    0H  &TYPE
*     P9     MOVE PF32 TO DF32                                         
*ZC     66     P9  MOVE  PF32,TO,DF32
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',X'20',XX
               '20',0)
         MVC   ZCVT_WORKAREA(9),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(9),3-3+PF32
         MVC   DF32,ZCVT_WORKAREA+2
*             IF DF32 NOT = ' 123.45'  PERFORM BAD ELSE PERFORM GOOD.  
*ZC     67         IF    DF32,NOT,=,' 123.45'
         LARL  ZC_R1,=CL8' 123.45'
         CLC   DF32,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_18_1
*ZC     67         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     67         ELSE
         J     PG_IF_18_E
PG_IF_18_1   DS    0H  &TYPE
*ZC     67         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_18_E   DS    0H  &TYPE
*     H1     MOVE HF30 TO DF30                                         
*ZC     68     H1  MOVE  HF30,TO,DF30
         LH    0,HF30
         CVD   0,ZCVT_PWORK
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',0)
         MVC   ZCVT_WORKAREA(7),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(7),8-2+ZCVT_PWORK
         MVC   DF30,ZCVT_WORKAREA+2
*            IF DF30 NOT = ' 123'     PERFORM BAD ELSE PERFORM GOOD.
*ZC     69         IF    DF30,NOT,=,' 123'
         LARL  ZC_R1,=CL4' 123'
         CLC   DF30,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_19_1
*ZC     69         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     69         ELSE
         J     PG_IF_19_E
PG_IF_19_1   DS    0H  &TYPE
*ZC     69         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_19_E   DS    0H  &TYPE
*     H2     MOVE HF30 TO DF31                                         
*ZC     70     H2  MOVE  HF30,TO,DF31
         LH    0,HF30
         CVD   0,ZCVT_PWORK
         SRP   ZCVT_PWORK(8),1,0
         LARL  ZC_R1,=AL1(C' ',X'20',C' ',X'20',X'21',X'20',C'.',X'20')
         MVC   ZCVT_WORKAREA(8),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(8),8-3+ZCVT_PWORK
         MVC   DF31,ZCVT_WORKAREA+2
*            IF DF31 NOT = ' 123.0'   PERFORM BAD ELSE PERFORM GOOD.   
*ZC     71         IF    DF31,NOT,=,' 123.0'
         LARL  ZC_R1,=CL6' 123.0'
         CLC   DF31,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_20_1
*ZC     71         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     71         ELSE
         J     PG_IF_20_E
PG_IF_20_1   DS    0H  &TYPE
*ZC     71         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_20_E   DS    0H  &TYPE
*     H3     MOVE HF30 TO DF32                                         
*ZC     72     H3  MOVE  HF30,TO,DF32
         LH    0,HF30
         CVD   0,ZCVT_PWORK
         SRP   ZCVT_PWORK(8),2,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',X'20',XX
               '20',0)
         MVC   ZCVT_WORKAREA(9),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(9),8-3+ZCVT_PWORK
         MVC   DF32,ZCVT_WORKAREA+2
*            IF DF32 NOT = ' 123.00'  PERFORM BAD ELSE PERFORM GOOD.
*ZC     73         IF    DF32,NOT,=,' 123.00'
         LARL  ZC_R1,=CL8' 123.00'
         CLC   DF32,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_21_1
*ZC     73         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     73         ELSE
         J     PG_IF_21_E
PG_IF_21_1   DS    0H  &TYPE
*ZC     73         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_21_E   DS    0H  &TYPE
*     H4     MOVE HF31 TO DF30                                         
*ZC     74     H4  MOVE  HF31,TO,DF30
         LH    0,HF31
         CVD   0,ZCVT_PWORK
         SRP   ZCVT_PWORK(8),63,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',0)
         MVC   ZCVT_WORKAREA(7),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(7),8-2+ZCVT_PWORK
         MVC   DF30,ZCVT_WORKAREA+2
*            IF DF30 NOT = ' 123'     PERFORM BAD ELSE PERFORM GOOD.
*ZC     75         IF    DF30,NOT,=,' 123'
         LARL  ZC_R1,=CL4' 123'
         CLC   DF30,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_22_1
*ZC     75         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     75         ELSE
         J     PG_IF_22_E
PG_IF_22_1   DS    0H  &TYPE
*ZC     75         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_22_E   DS    0H  &TYPE
*     H5     MOVE HF31 TO DF31                                         
*ZC     76     H5  MOVE  HF31,TO,DF31
         LH    0,HF31
         CVD   0,ZCVT_PWORK
         LARL  ZC_R1,=AL1(C' ',X'20',C' ',X'20',X'21',X'20',C'.',X'20')
         MVC   ZCVT_WORKAREA(8),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(8),8-3+ZCVT_PWORK
         MVC   DF31,ZCVT_WORKAREA+2
*            IF DF31 NOT = ' 123.4'   PERFORM BAD ELSE PERFORM GOOD.   
*ZC     77         IF    DF31,NOT,=,' 123.4'
         LARL  ZC_R1,=CL6' 123.4'
         CLC   DF31,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_23_1
*ZC     77         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     77         ELSE
         J     PG_IF_23_E
PG_IF_23_1   DS    0H  &TYPE
*ZC     77         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_23_E   DS    0H  &TYPE
*     H6     MOVE HF31 TO DF32                                         
*ZC     78     H6  MOVE  HF31,TO,DF32
         LH    0,HF31
         CVD   0,ZCVT_PWORK
         SRP   ZCVT_PWORK(8),1,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',X'20',XX
               '20',0)
         MVC   ZCVT_WORKAREA(9),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(9),8-3+ZCVT_PWORK
         MVC   DF32,ZCVT_WORKAREA+2
*            IF DF32 NOT = ' 123.40'  PERFORM BAD ELSE PERFORM GOOD.
*ZC     79         IF    DF32,NOT,=,' 123.40'
         LARL  ZC_R1,=CL8' 123.40'
         CLC   DF32,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_24_1
*ZC     79         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     79         ELSE
         J     PG_IF_24_E
PG_IF_24_1   DS    0H  &TYPE
*ZC     79         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_24_E   DS    0H  &TYPE
*     H7     MOVE HF32 TO DF30                                         
*ZC     80     H7  MOVE  HF32,TO,DF30
         LH    0,HF32
         CVD   0,ZCVT_PWORK
         SRP   ZCVT_PWORK(8),62,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',0)
         MVC   ZCVT_WORKAREA(7),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(7),8-2+ZCVT_PWORK
         MVC   DF30,ZCVT_WORKAREA+2
*            IF DF30 NOT = '  23'     PERFORM BAD ELSE PERFORM GOOD.
*ZC     81         IF    DF30,NOT,=,'  23'
         LARL  ZC_R1,=CL4'  23'
         CLC   DF30,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_25_1
*ZC     81         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     81         ELSE
         J     PG_IF_25_E
PG_IF_25_1   DS    0H  &TYPE
*ZC     81         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_25_E   DS    0H  &TYPE
*     H8     MOVE HF32 TO DF31                                         
*ZC     82     H8  MOVE  HF32,TO,DF31
         LH    0,HF32
         CVD   0,ZCVT_PWORK
         SRP   ZCVT_PWORK(8),63,0
         LARL  ZC_R1,=AL1(C' ',X'20',C' ',X'20',X'21',X'20',C'.',X'20')
         MVC   ZCVT_WORKAREA(8),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(8),8-3+ZCVT_PWORK
         MVC   DF31,ZCVT_WORKAREA+2
*            IF DF31 NOT = '  23.4'   PERFORM BAD ELSE PERFORM GOOD.   
*ZC     83         IF    DF31,NOT,=,'  23.4'
         LARL  ZC_R1,=CL6'  23.4'
         CLC   DF31,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_26_1
*ZC     83         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     83         ELSE
         J     PG_IF_26_E
PG_IF_26_1   DS    0H  &TYPE
*ZC     83         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_26_E   DS    0H  &TYPE
*     H9     MOVE HF32 TO DF32                                         
*ZC     84     H9  MOVE  HF32,TO,DF32
         LH    0,HF32
         CVD   0,ZCVT_PWORK
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',X'20',XX
               '20',0)
         MVC   ZCVT_WORKAREA(9),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(9),8-3+ZCVT_PWORK
         MVC   DF32,ZCVT_WORKAREA+2
*            IF DF32 NOT = '  23.45'  PERFORM BAD ELSE PERFORM GOOD.   
*ZC     85         IF    DF32,NOT,=,'  23.45'
         LARL  ZC_R1,=CL8'  23.45'
         CLC   DF32,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_27_1
*ZC     85         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     85         ELSE
         J     PG_IF_27_E
PG_IF_27_1   DS    0H  &TYPE
*ZC     85         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_27_E   DS    0H  &TYPE
*     F1     MOVE FF30 TO DF30                                         
*ZC     86     F1  MOVE  FF30,TO,DF30
         L     0,FF30
         CVD   0,ZCVT_PWORK
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',0)
         MVC   ZCVT_WORKAREA(7),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(7),8-2+ZCVT_PWORK
         MVC   DF30,ZCVT_WORKAREA+2
*             IF DF30 NOT = ' 123'     PERFORM BAD ELSE PERFORM GOOD.
*ZC     87         IF    DF30,NOT,=,' 123'
         LARL  ZC_R1,=CL4' 123'
         CLC   DF30,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_28_1
*ZC     87         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     87         ELSE
         J     PG_IF_28_E
PG_IF_28_1   DS    0H  &TYPE
*ZC     87         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_28_E   DS    0H  &TYPE
*     F2     MOVE FF30 TO DF31                                         
*ZC     88     F2  MOVE  FF30,TO,DF31
         L     0,FF30
         CVD   0,ZCVT_PWORK
         SRP   ZCVT_PWORK(8),1,0
         LARL  ZC_R1,=AL1(C' ',X'20',C' ',X'20',X'21',X'20',C'.',X'20')
         MVC   ZCVT_WORKAREA(8),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(8),8-3+ZCVT_PWORK
         MVC   DF31,ZCVT_WORKAREA+2
*             IF DF31 NOT = ' 123.0'   PERFORM BAD ELSE PERFORM GOOD.  
*ZC     89         IF    DF31,NOT,=,' 123.0'
         LARL  ZC_R1,=CL6' 123.0'
         CLC   DF31,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_29_1
*ZC     89         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     89         ELSE
         J     PG_IF_29_E
PG_IF_29_1   DS    0H  &TYPE
*ZC     89         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_29_E   DS    0H  &TYPE
*     F3     MOVE FF30 TO DF32                                         
*ZC     90     F3  MOVE  FF30,TO,DF32
         L     0,FF30
         CVD   0,ZCVT_PWORK
         SRP   ZCVT_PWORK(8),2,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',X'20',XX
               '20',0)
         MVC   ZCVT_WORKAREA(9),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(9),8-3+ZCVT_PWORK
         MVC   DF32,ZCVT_WORKAREA+2
*             IF DF32 NOT = ' 123.00'  PERFORM BAD ELSE PERFORM GOOD.
*ZC     91         IF    DF32,NOT,=,' 123.00'
         LARL  ZC_R1,=CL8' 123.00'
         CLC   DF32,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_30_1
*ZC     91         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     91         ELSE
         J     PG_IF_30_E
PG_IF_30_1   DS    0H  &TYPE
*ZC     91         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_30_E   DS    0H  &TYPE
*     F4     MOVE FF31 TO DF30                                         
*ZC     92     F4  MOVE  FF31,TO,DF30
         L     0,FF31
         CVD   0,ZCVT_PWORK
         SRP   ZCVT_PWORK(8),63,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',0)
         MVC   ZCVT_WORKAREA(7),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(7),8-2+ZCVT_PWORK
         MVC   DF30,ZCVT_WORKAREA+2
*             IF DF30 NOT = ' 123'     PERFORM BAD ELSE PERFORM GOOD.
*ZC     93         IF    DF30,NOT,=,' 123'
         LARL  ZC_R1,=CL4' 123'
         CLC   DF30,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_31_1
*ZC     93         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     93         ELSE
         J     PG_IF_31_E
PG_IF_31_1   DS    0H  &TYPE
*ZC     93         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_31_E   DS    0H  &TYPE
*     F5     MOVE FF31 TO DF31                                         
*ZC     94     F5  MOVE  FF31,TO,DF31
         L     0,FF31
         CVD   0,ZCVT_PWORK
         LARL  ZC_R1,=AL1(C' ',X'20',C' ',X'20',X'21',X'20',C'.',X'20')
         MVC   ZCVT_WORKAREA(8),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(8),8-3+ZCVT_PWORK
         MVC   DF31,ZCVT_WORKAREA+2
*             IF DF31 NOT = ' 123.4'   PERFORM BAD ELSE PERFORM GOOD.  
*ZC     95         IF    DF31,NOT,=,' 123.4'
         LARL  ZC_R1,=CL6' 123.4'
         CLC   DF31,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_32_1
*ZC     95         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     95         ELSE
         J     PG_IF_32_E
PG_IF_32_1   DS    0H  &TYPE
*ZC     95         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_32_E   DS    0H  &TYPE
*     F6     MOVE FF31 TO DF32                                         
*ZC     96     F6  MOVE  FF31,TO,DF32
         L     0,FF31
         CVD   0,ZCVT_PWORK
         SRP   ZCVT_PWORK(8),1,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',X'20',XX
               '20',0)
         MVC   ZCVT_WORKAREA(9),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(9),8-3+ZCVT_PWORK
         MVC   DF32,ZCVT_WORKAREA+2
*             IF DF32 NOT = ' 123.40'  PERFORM BAD ELSE PERFORM GOOD.
*ZC     97         IF    DF32,NOT,=,' 123.40'
         LARL  ZC_R1,=CL8' 123.40'
         CLC   DF32,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_33_1
*ZC     97         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     97         ELSE
         J     PG_IF_33_E
PG_IF_33_1   DS    0H  &TYPE
*ZC     97         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_33_E   DS    0H  &TYPE
*     F7     MOVE FF32 TO DF30                                         
*ZC     98     F7  MOVE  FF32,TO,DF30
         L     0,FF32
         CVD   0,ZCVT_PWORK
         SRP   ZCVT_PWORK(8),62,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',0)
         MVC   ZCVT_WORKAREA(7),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(7),8-2+ZCVT_PWORK
         MVC   DF30,ZCVT_WORKAREA+2
*             IF DF30 NOT = ' 123'     PERFORM BAD ELSE PERFORM GOOD.
*ZC     99         IF    DF30,NOT,=,' 123'
         LARL  ZC_R1,=CL4' 123'
         CLC   DF30,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_34_1
*ZC     99         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     99         ELSE
         J     PG_IF_34_E
PG_IF_34_1   DS    0H  &TYPE
*ZC     99         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_34_E   DS    0H  &TYPE
*     F8     MOVE FF32 TO DF31                                         
*ZC    100     F8  MOVE  FF32,TO,DF31
         L     0,FF32
         CVD   0,ZCVT_PWORK
         SRP   ZCVT_PWORK(8),63,0
         LARL  ZC_R1,=AL1(C' ',X'20',C' ',X'20',X'21',X'20',C'.',X'20')
         MVC   ZCVT_WORKAREA(8),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(8),8-3+ZCVT_PWORK
         MVC   DF31,ZCVT_WORKAREA+2
*             IF DF31 NOT = ' 123.4'   PERFORM BAD ELSE PERFORM GOOD.  
*ZC    101         IF    DF31,NOT,=,' 123.4'
         LARL  ZC_R1,=CL6' 123.4'
         CLC   DF31,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_35_1
*ZC    101         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    101         ELSE
         J     PG_IF_35_E
PG_IF_35_1   DS    0H  &TYPE
*ZC    101         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_35_E   DS    0H  &TYPE
*     F9     MOVE FF32 TO DF32                                         
*ZC    102     F9  MOVE  FF32,TO,DF32
         L     0,FF32
         CVD   0,ZCVT_PWORK
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',X'20',XX
               '20',0)
         MVC   ZCVT_WORKAREA(9),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(9),8-3+ZCVT_PWORK
         MVC   DF32,ZCVT_WORKAREA+2
*             IF DF32 NOT = ' 123.45'  PERFORM BAD ELSE PERFORM GOOD.
*ZC    103         IF    DF32,NOT,=,' 123.45'
         LARL  ZC_R1,=CL8' 123.45'
         CLC   DF32,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_36_1
*ZC    103         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    103         ELSE
         J     PG_IF_36_E
PG_IF_36_1   DS    0H  &TYPE
*ZC    103         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_36_E   DS    0H  &TYPE
*     G1     MOVE GF30 TO DF30                                         
*ZC    104     G1  MOVE  GF30,TO,DF30
         LG    0,GF30
         CVDG  0,ZCVT_PWORK2
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',0)
         MVC   ZCVT_WORKAREA(7),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(7),16-2+ZCVT_PWORK2
         MVC   DF30,ZCVT_WORKAREA+2
*            IF DF30 NOT = ' 123'     PERFORM BAD ELSE PERFORM GOOD.
*ZC    105         IF    DF30,NOT,=,' 123'
         LARL  ZC_R1,=CL4' 123'
         CLC   DF30,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_37_1
*ZC    105         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    105         ELSE
         J     PG_IF_37_E
PG_IF_37_1   DS    0H  &TYPE
*ZC    105         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_37_E   DS    0H  &TYPE
*     G2     MOVE GF30 TO DF31                                         
*ZC    106     G2  MOVE  GF30,TO,DF31
         LG    0,GF30
         CVDG  0,ZCVT_PWORK2
         SRP   ZCVT_PWORK2(16),1,0
         LARL  ZC_R1,=AL1(C' ',X'20',C' ',X'20',X'21',X'20',C'.',X'20')
         MVC   ZCVT_WORKAREA(8),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(8),16-3+ZCVT_PWORK2
         MVC   DF31,ZCVT_WORKAREA+2
*            IF DF31 NOT = ' 123.0'   PERFORM BAD ELSE PERFORM GOOD.   
*ZC    107         IF    DF31,NOT,=,' 123.0'
         LARL  ZC_R1,=CL6' 123.0'
         CLC   DF31,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_38_1
*ZC    107         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    107         ELSE
         J     PG_IF_38_E
PG_IF_38_1   DS    0H  &TYPE
*ZC    107         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_38_E   DS    0H  &TYPE
*     G3     MOVE GF30 TO DF32                                         
*ZC    108     G3  MOVE  GF30,TO,DF32
         LG    0,GF30
         CVDG  0,ZCVT_PWORK2
         SRP   ZCVT_PWORK2(16),2,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',X'20',XX
               '20',0)
         MVC   ZCVT_WORKAREA(9),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(9),16-3+ZCVT_PWORK2
         MVC   DF32,ZCVT_WORKAREA+2
*            IF DF32 NOT = ' 123.00'  PERFORM BAD ELSE PERFORM GOOD.
*ZC    109         IF    DF32,NOT,=,' 123.00'
         LARL  ZC_R1,=CL8' 123.00'
         CLC   DF32,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_39_1
*ZC    109         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    109         ELSE
         J     PG_IF_39_E
PG_IF_39_1   DS    0H  &TYPE
*ZC    109         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_39_E   DS    0H  &TYPE
*     G4     MOVE GF31 TO DF30                                         
*ZC    110     G4  MOVE  GF31,TO,DF30
         LG    0,GF31
         CVDG  0,ZCVT_PWORK2
         SRP   ZCVT_PWORK2(16),63,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',0)
         MVC   ZCVT_WORKAREA(7),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(7),16-2+ZCVT_PWORK2
         MVC   DF30,ZCVT_WORKAREA+2
*            IF DF30 NOT = ' 123'     PERFORM BAD ELSE PERFORM GOOD.
*ZC    111         IF    DF30,NOT,=,' 123'
         LARL  ZC_R1,=CL4' 123'
         CLC   DF30,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_40_1
*ZC    111         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    111         ELSE
         J     PG_IF_40_E
PG_IF_40_1   DS    0H  &TYPE
*ZC    111         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_40_E   DS    0H  &TYPE
*     G5     MOVE GF31 TO DF31                                         
*ZC    112     G5  MOVE  GF31,TO,DF31
         LG    0,GF31
         CVDG  0,ZCVT_PWORK2
         LARL  ZC_R1,=AL1(C' ',X'20',C' ',X'20',X'21',X'20',C'.',X'20')
         MVC   ZCVT_WORKAREA(8),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(8),16-3+ZCVT_PWORK2
         MVC   DF31,ZCVT_WORKAREA+2
*            IF DF31 NOT = ' 123.4'   PERFORM BAD ELSE PERFORM GOOD.   
*ZC    113         IF    DF31,NOT,=,' 123.4'
         LARL  ZC_R1,=CL6' 123.4'
         CLC   DF31,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_41_1
*ZC    113         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    113         ELSE
         J     PG_IF_41_E
PG_IF_41_1   DS    0H  &TYPE
*ZC    113         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_41_E   DS    0H  &TYPE
*     G6     MOVE GF31 TO DF32                                         
*ZC    114     G6  MOVE  GF31,TO,DF32
         LG    0,GF31
         CVDG  0,ZCVT_PWORK2
         SRP   ZCVT_PWORK2(16),1,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',X'20',XX
               '20',0)
         MVC   ZCVT_WORKAREA(9),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(9),16-3+ZCVT_PWORK2
         MVC   DF32,ZCVT_WORKAREA+2
*            IF DF32 NOT = ' 123.40'  PERFORM BAD ELSE PERFORM GOOD.
*ZC    115         IF    DF32,NOT,=,' 123.40'
         LARL  ZC_R1,=CL8' 123.40'
         CLC   DF32,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_42_1
*ZC    115         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    115         ELSE
         J     PG_IF_42_E
PG_IF_42_1   DS    0H  &TYPE
*ZC    115         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_42_E   DS    0H  &TYPE
*     G7     MOVE GF32 TO DF30                                         
*ZC    116     G7  MOVE  GF32,TO,DF30
         LG    0,GF32
         CVDG  0,ZCVT_PWORK2
         SRP   ZCVT_PWORK2(16),62,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',0)
         MVC   ZCVT_WORKAREA(7),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(7),16-2+ZCVT_PWORK2
         MVC   DF30,ZCVT_WORKAREA+2
*            IF DF30 NOT = '  23'     PERFORM BAD ELSE PERFORM GOOD.
*ZC    117         IF    DF30,NOT,=,'  23'
         LARL  ZC_R1,=CL4'  23'
         CLC   DF30,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_43_1
*ZC    117         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    117         ELSE
         J     PG_IF_43_E
PG_IF_43_1   DS    0H  &TYPE
*ZC    117         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_43_E   DS    0H  &TYPE
*     G8     MOVE GF32 TO DF31                                         
*ZC    118     G8  MOVE  GF32,TO,DF31
         LG    0,GF32
         CVDG  0,ZCVT_PWORK2
         SRP   ZCVT_PWORK2(16),63,0
         LARL  ZC_R1,=AL1(C' ',X'20',C' ',X'20',X'21',X'20',C'.',X'20')
         MVC   ZCVT_WORKAREA(8),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(8),16-3+ZCVT_PWORK2
         MVC   DF31,ZCVT_WORKAREA+2
*            IF DF31 NOT = '  23.4'   PERFORM BAD ELSE PERFORM GOOD.   
*ZC    119         IF    DF31,NOT,=,'  23.4'
         LARL  ZC_R1,=CL6'  23.4'
         CLC   DF31,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_44_1
*ZC    119         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    119         ELSE
         J     PG_IF_44_E
PG_IF_44_1   DS    0H  &TYPE
*ZC    119         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_44_E   DS    0H  &TYPE
*     G9     MOVE GF32 TO DF32                                         
*ZC    120     G9  MOVE  GF32,TO,DF32
         LG    0,GF32
         CVDG  0,ZCVT_PWORK2
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',X'20',XX
               '20',0)
         MVC   ZCVT_WORKAREA(9),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(9),16-3+ZCVT_PWORK2
         MVC   DF32,ZCVT_WORKAREA+2
*            IF DF32 NOT = '  23.45'  PERFORM BAD ELSE PERFORM GOOD.   
*ZC    121         IF    DF32,NOT,=,'  23.45'
         LARL  ZC_R1,=CL8'  23.45'
         CLC   DF32,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_45_1
*ZC    121         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    121         ELSE
         J     PG_IF_45_E
PG_IF_45_1   DS    0H  &TYPE
*ZC    121         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_45_E   DS    0H  &TYPE
*     Q1     MOVE QF30 TO DF30                                         
*ZC    122     Q1  MOVE  QF30,TO,DF30
         LG    ZC_R0,QF30
         LG    ZC_R1,8+QF30
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',0)
         MVC   ZCVT_WORKAREA(7),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(7),16-2+ZCVT_PWORK2
         MVC   DF30,ZCVT_WORKAREA+2
*             IF DF30 NOT = ' 123'     PERFORM BAD ELSE PERFORM GOOD.
*ZC    123         IF    DF30,NOT,=,' 123'
         LARL  ZC_R1,=CL4' 123'
         CLC   DF30,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_46_1
*ZC    123         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    123         ELSE
         J     PG_IF_46_E
PG_IF_46_1   DS    0H  &TYPE
*ZC    123         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_46_E   DS    0H  &TYPE
*     Q2     MOVE QF30 TO DF31                                         
*ZC    124     Q2  MOVE  QF30,TO,DF31
         LG    ZC_R0,QF30
         LG    ZC_R1,8+QF30
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         SRP   ZCVT_PWORK2(16),1,0
         LARL  ZC_R1,=AL1(C' ',X'20',C' ',X'20',X'21',X'20',C'.',X'20')
         MVC   ZCVT_WORKAREA(8),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(8),16-3+ZCVT_PWORK2
         MVC   DF31,ZCVT_WORKAREA+2
*             IF DF31 NOT = ' 123.0'   PERFORM BAD ELSE PERFORM GOOD.  
*ZC    125         IF    DF31,NOT,=,' 123.0'
         LARL  ZC_R1,=CL6' 123.0'
         CLC   DF31,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_47_1
*ZC    125         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    125         ELSE
         J     PG_IF_47_E
PG_IF_47_1   DS    0H  &TYPE
*ZC    125         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_47_E   DS    0H  &TYPE
*     Q3     MOVE QF30 TO DF32                                         
*ZC    126     Q3  MOVE  QF30,TO,DF32
         LG    ZC_R0,QF30
         LG    ZC_R1,8+QF30
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         SRP   ZCVT_PWORK2(16),2,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',X'20',XX
               '20',0)
         MVC   ZCVT_WORKAREA(9),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(9),16-3+ZCVT_PWORK2
         MVC   DF32,ZCVT_WORKAREA+2
*             IF DF32 NOT = ' 123.00'  PERFORM BAD ELSE PERFORM GOOD.
*ZC    127         IF    DF32,NOT,=,' 123.00'
         LARL  ZC_R1,=CL8' 123.00'
         CLC   DF32,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_48_1
*ZC    127         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    127         ELSE
         J     PG_IF_48_E
PG_IF_48_1   DS    0H  &TYPE
*ZC    127         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_48_E   DS    0H  &TYPE
*     Q4     MOVE QF31 TO DF30                                         
*ZC    128     Q4  MOVE  QF31,TO,DF30
         LG    ZC_R0,QF31
         LG    ZC_R1,8+QF31
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         SRP   ZCVT_PWORK2(16),63,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',0)
         MVC   ZCVT_WORKAREA(7),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(7),16-2+ZCVT_PWORK2
         MVC   DF30,ZCVT_WORKAREA+2
*             IF DF30 NOT = ' 123'     PERFORM BAD ELSE PERFORM GOOD.
*ZC    129         IF    DF30,NOT,=,' 123'
         LARL  ZC_R1,=CL4' 123'
         CLC   DF30,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_49_1
*ZC    129         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    129         ELSE
         J     PG_IF_49_E
PG_IF_49_1   DS    0H  &TYPE
*ZC    129         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_49_E   DS    0H  &TYPE
*     Q5     MOVE QF31 TO DF31                                         
*ZC    130     Q5  MOVE  QF31,TO,DF31
         LG    ZC_R0,QF31
         LG    ZC_R1,8+QF31
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         LARL  ZC_R1,=AL1(C' ',X'20',C' ',X'20',X'21',X'20',C'.',X'20')
         MVC   ZCVT_WORKAREA(8),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(8),16-3+ZCVT_PWORK2
         MVC   DF31,ZCVT_WORKAREA+2
*             IF DF31 NOT = ' 123.4'   PERFORM BAD ELSE PERFORM GOOD.  
*ZC    131         IF    DF31,NOT,=,' 123.4'
         LARL  ZC_R1,=CL6' 123.4'
         CLC   DF31,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_50_1
*ZC    131         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    131         ELSE
         J     PG_IF_50_E
PG_IF_50_1   DS    0H  &TYPE
*ZC    131         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_50_E   DS    0H  &TYPE
*     Q6     MOVE QF31 TO DF32                                         
*ZC    132     Q6  MOVE  QF31,TO,DF32
         LG    ZC_R0,QF31
         LG    ZC_R1,8+QF31
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         SRP   ZCVT_PWORK2(16),1,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',X'20',XX
               '20',0)
         MVC   ZCVT_WORKAREA(9),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(9),16-3+ZCVT_PWORK2
         MVC   DF32,ZCVT_WORKAREA+2
*             IF DF32 NOT = ' 123.40'  PERFORM BAD ELSE PERFORM GOOD.
*ZC    133         IF    DF32,NOT,=,' 123.40'
         LARL  ZC_R1,=CL8' 123.40'
         CLC   DF32,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_51_1
*ZC    133         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    133         ELSE
         J     PG_IF_51_E
PG_IF_51_1   DS    0H  &TYPE
*ZC    133         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_51_E   DS    0H  &TYPE
*     Q7     MOVE QF32 TO DF30                                         
*ZC    134     Q7  MOVE  QF32,TO,DF30
         LG    ZC_R0,QF32
         LG    ZC_R1,8+QF32
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         SRP   ZCVT_PWORK2(16),62,0
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',0)
         MVC   ZCVT_WORKAREA(7),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(7),16-2+ZCVT_PWORK2
         MVC   DF30,ZCVT_WORKAREA+2
*             IF DF30 NOT = ' 123'     PERFORM BAD ELSE PERFORM GOOD.
*ZC    135         IF    DF30,NOT,=,' 123'
         LARL  ZC_R1,=CL4' 123'
         CLC   DF30,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_52_1
*ZC    135         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    135         ELSE
         J     PG_IF_52_E
PG_IF_52_1   DS    0H  &TYPE
*ZC    135         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_52_E   DS    0H  &TYPE
*     Q8     MOVE QF32 TO DF31                                         
*ZC    136     Q8  MOVE  QF32,TO,DF31
         LG    ZC_R0,QF32
         LG    ZC_R1,8+QF32
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         SRP   ZCVT_PWORK2(16),63,0
         LARL  ZC_R1,=AL1(C' ',X'20',C' ',X'20',X'21',X'20',C'.',X'20')
         MVC   ZCVT_WORKAREA(8),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(8),16-3+ZCVT_PWORK2
         MVC   DF31,ZCVT_WORKAREA+2
*             IF DF31 NOT = ' 123.4'   PERFORM BAD ELSE PERFORM GOOD.  
*ZC    137         IF    DF31,NOT,=,' 123.4'
         LARL  ZC_R1,=CL6' 123.4'
         CLC   DF31,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_53_1
*ZC    137         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    137         ELSE
         J     PG_IF_53_E
PG_IF_53_1   DS    0H  &TYPE
*ZC    137         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_53_E   DS    0H  &TYPE
*     Q9     MOVE QF32 TO DF32                                         
*ZC    138     Q9  MOVE  QF32,TO,DF32
         LG    ZC_R0,QF32
         LG    ZC_R1,8+QF32
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         LARL  ZC_R1,=AL1(C' ',C' ',C' ',X'20',X'21',X'20',C'.',X'20',XX
               '20',0)
         MVC   ZCVT_WORKAREA(9),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(9),16-3+ZCVT_PWORK2
         MVC   DF32,ZCVT_WORKAREA+2
*             IF DF32 NOT = ' 123.45'  PERFORM BAD ELSE PERFORM GOOD.
*ZC    139         IF    DF32,NOT,=,' 123.45'
         LARL  ZC_R1,=CL8' 123.45'
         CLC   DF32,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_54_1
*ZC    139         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    139         ELSE
         J     PG_IF_54_E
PG_IF_54_1   DS    0H  &TYPE
*ZC    139         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_54_E   DS    0H  &TYPE
*            DISPLAY 'TESTMOV2 GOOD TESTS =' GOOD
*ZC    140         DISPLAY 'TESTMOV2 GOOD TESTS =',GOOD
         LA    ZC_R3,ZCVT_WORKAREA  ZC_R3=CVT LIST WORK AREA
         LARL  ZC_R0,=CL22'TESTMOV2 GOOD TESTS =' PAD TO EVEN LEN LIT
         LA    ZC_R1,21
         LA    ZC_R2,C'X'
         STM   ZC_R0,ZC_R2,0(ZC_R3)  SET DISPLAY LIST ENTRY
         LA    ZC_R0,GOOD
         LA    ZC_R1,4  RPI 1182 WAS &SYM_LEN(&FIELD_IX)
         LA    ZC_R2,C'F'
         STM   ZC_R0,ZC_R2,12(ZC_R3)  SET DISPLAY LIST ENTRY
         OI    24-4(ZC_R3),X'80' SET VL BIT IN LAST WORD OF PARM LIST
         LR    ZC_R1,ZC_R3
         L     ZC_R15,ZCVT_DISPLAY
         BASR  ZC_R14,ZC_R15
*            STOP RUN.
*ZC    141         STOP  RUN
         LH    ZC_R1,RETURN_CODE      PASS RETURN CODE IN R1
         L     ZC_R15,ZCVT_GOBACK
         BR    ZC_R15
*        GOOD.
PG_MAINLINE_END L ZC_R15,ZCVT_PMCHECK
         BASR  ZC_R14,ZC_R15 CHECK FOR END OF CURRENT PERFORM
PG_GOOD  DS    0H
*            ADD 1 TO GOOD
*ZC    143         ADD   1,TO,GOOD
         ASI   GOOD,1
*        BAD.
PG_GOOD_END L  ZC_R15,ZCVT_PMCHECK
         BASR  ZC_R14,ZC_R15 CHECK FOR END OF CURRENT PERFORM
PG_BAD   DS    0H
*            MOVE 16 TO RETURN-CODE
*ZC    145         MOVE  16,TO,RETURN_CODE
          MVHHI RETURN_CODE,16
*            STOP RUN.
*ZC    146         STOP  RUN
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
                      
*    01  FILLER                         00000058 00000000 1   X        X
                      
*    01  DF30                           00000058 00000004 1   X    ZZ9.X
                      
*    01  DF31                           0000005C 00000006 1   X    ZZ9.X
               9      
*    01  DF32                           00000062 00000007 1   X    ZZ9.X
               99     
*    01  ZF30                           00000069 00000003 1   Z   9(3) X
                     123 
*    01  ZF31                           0000006C 00000004 1   Z   9(3)VX
               9     1234 
*    01  ZF32                           00000070 00000005 1   Z   9(3)VX
               99    12345 
*    01  PF30                           00000075 00000002 1   P   9(3) X
                     123 
*    01  PF31                           00000077 00000003 1   P   9(3)VX
               9     1234 
*    01  PF32                           0000007A 00000003 1   P   9(3)VX
               99    12345 
*    01  HF30                           0000007D 00000002 1   H   9(3) X
                     123 
*    01  HF31                           0000007F 00000002 1   H   9(3)VX
               9     1234 
*    01  HF32                           00000081 00000002 1   H   9(2)VX
               99    2345 
*    01  FF30                           00000083 00000004 1   F   9(6) X
                     123 
*    01  FF31                           00000087 00000004 1   F   9(6)VX
               9     1234 
*    01  FF32                           0000008B 00000004 1   F   9(6)VX
               99    12345 
*    01  GF30                           0000008F 00000008 1   G   9(16)X
                     123 
*    01  GF31                           00000097 00000008 1   G   9(16)X
               V9    1234 
*    01  GF32                           0000009F 00000008 1   G   9(16)X
               V99   2345 
*    01  QF30                           000000A7 00000010 1   Q   9(29)X
                     123 
*    01  QF31                           000000B7 00000010 1   Q   9(29)X
               V9    1234 
*    01  QF32                           000000C7 00000010 1   Q   9(29)X
               V99   12345 
*    01  GOOD                           000000D7 00000004 1   F   9(9) X
                     0 
*    01  DEBUG_ITEM                     000000DB 00000058 1   X        X
                      
*    02  DEBUG_LINE                     000000DB 00000006 1   X   X(6) X
                      
*    02  FILLER                         000000E1 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_NAME                     000000E2 0000001E 1   X   X(30)X
                      
*    02  FILLER                         00000100 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_1                    00000101 00000004 1   Z   9999 X
                      
*    02  FILLER                         00000105 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_2                    00000106 00000004 1   Z   9999 X
                      
*    02  FILLER                         0000010A 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_3                    0000010B 00000004 1   Z   9999 X
                      
*    02  FILLER                         0000010F 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_CONTENTS                 00000110 00000023 1   X   X(35)X
                      
*    01  TRUE                           00000133 00000001 1   Z   9    X
                     1 
*    01  FALSE                          00000134 00000001 1   Z   9    X
                     0 
*    01  RETURN_CODE                    00000135 00000002 1   H   9(4) X
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
DF30     DS  CL4
ZC_WS_LOC_7  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DF31     DS  CL6
ZC_WS_LOC_8  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DF32     DS  CL7
ZC_WS_LOC_9  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ZF30     DC ZL3'123'
ZC_WS_LOC_10 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ZF31     DC ZL4'1234'
ZC_WS_LOC_11 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ZF32     DC ZL5'12345'
ZC_WS_LOC_12 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
PF30     DC PL2'123'
ZC_WS_LOC_13 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
PF31     DC PL3'1234'
ZC_WS_LOC_14 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
PF32     DC PL3'12345'
ZC_WS_LOC_15 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
HF30     DC AL2(123)                  RPI 1065
ZC_WS_LOC_16 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
HF31     DC AL2(1234)                  RPI 1065
ZC_WS_LOC_17 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
HF32     DC AL2(2345)                  RPI 1065
ZC_WS_LOC_18 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
FF30     DC AL4(123)                  RPI 1065
ZC_WS_LOC_19 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
FF31     DC AL4(1234)                  RPI 1065
ZC_WS_LOC_20 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
FF32     DC AL4(12345)                  RPI 1065
ZC_WS_LOC_21 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
GF30     DC FL8'123'                  RPI 1065
ZC_WS_LOC_22 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
GF31     DC FL8'1234'                  RPI 1065
ZC_WS_LOC_23 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
GF32     DC FL8'2345'                  RPI 1065
ZC_WS_LOC_24 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
QF30     DC FL16'123'                 RPI 1065
ZC_WS_LOC_25 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
QF31     DC FL16'1234'                 RPI 1065
ZC_WS_LOC_26 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
QF32     DC FL16'12345'                 RPI 1065
ZC_WS_LOC_27 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
GOOD     DC AL4(0)                  RPI 1065
ZC_WS_LOC_28 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_ITEM DS 0CL88
ZC_WS_LOC_29 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_LINE DS CL6
ZC_WS_LOC_30 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_31 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_NAME DS CL30
ZC_WS_LOC_32 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_33 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_1 DS ZL4
ZC_WS_LOC_34 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_35 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_2 DS ZL4
ZC_WS_LOC_36 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_37 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_3 DS ZL4
ZC_WS_LOC_38 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_39 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_CONTENTS DS CL35
ZC_WS_LOC_40 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
TRUE     DC CL1'1'
ZC_WS_LOC_41 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
FALSE    DC CL1'0'
ZC_WS_LOC_42 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
RETURN_CODE DC AL2(0)                  RPI 1065
*    ZCOBOL LINKAGE SECTION DATA ITEMS 
*    LVL DATA NAME                      ADDR     LEN      DUP TYP PIC  X
                     VALUE 
ZC_WSLOC LOCTR 
ZC_WSLOC LOCTR 
ZC_WS_DIFF EQU  *-ZC_WS-311  DIFF BETWEEN ALLOC AND CALC WS
ZC_WS_END DS   0D
         MNOTE *,'ZCOBOL TOTAL SYMBOLS                 = 42'
         MNOTE *,'ZCOBOL TOTAL SYMBOL DUPLICATES       = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL MAX DUP CHAIN    = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL LEVEL 88         = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL SET INDEXES      = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL LINKAGE SECTIONS = 0'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE SECTIONS      = 0'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE PARAGRAPHS    = 3'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE PARAGRAPH DUP = 0'
         END 
