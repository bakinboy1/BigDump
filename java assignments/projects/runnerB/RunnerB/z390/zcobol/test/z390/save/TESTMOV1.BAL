*    ZCOBOL PGM='zcobol\test\TESTMOV1' VER=V1.5.06 MM/DD/YY  
*    ZCOBOL OPTIONS=() 
         COPY  TESTMOV1_ZC_LABELS.CPY
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
*      * TEST MOVE.
*      ***************************************************************
*      * 01/26/12 DSH RPI 1181 ADD TEST 21
*      ***************************************************************
*        ENVIRONMENT DIVISION.
*        DATA DIVISION.
         PRINT DATA
*        WORKING-STORAGE SECTION.
*        01  ABCDEF PIC X(6) VALUE 'ABCDEF'.
*        01  ABC    PIC X(3) REDEFINES ABCDEF OCCURS 2.
*         77  NF1    COMP PIC S9(9).
*         77  DF1    PIC Z(9).
*         77  DF2    PIC Z(8)9.
*         77  DF3    PIC ZZZ,ZZZ,ZZ9.
*         77  NH1    COMP PIC S9(4).
*         77  DH1    PIC Z(4).
*         77  DH2    PIC Z(3)9.
*         77  NP1    COMP-3 PIC S9.
*         77  NP2    COMP-3 PIC S9(4).
*         77  DP1    PIC Z.
*         77  DP2    PIC Z(3)9.
*         77  DP3    PIC ZZ-99.
*         77  FLD1   PIC XX VALUE  'XY'.
*         77  FLD2   PIC XXX VALUE 'ABC'.
*         77  GOOD   COMP PIC S9(9) VALUE 0..
*        77 SUB1 PIC 9.
*        PROCEDURE DIVISION.
*ZC   PROCEDURE DIVISION
         PRINT LIST,GEN,LISTUSE TURN PRINT LISTING ON FOR USER CODE GEN
TESTMOV1 CSECT                SWITCH TO PROCEDURE CODE AHEAD OF WS
*        MAINLINE.
PG_MAINLINE DS 0H
*            MOVE 0 TO NF1
*ZC     31         MOVE  0,TO,NF1
          MVHI  NF1,0
*      1     MOVE NF1 TO DF1
*ZC     32      1  MOVE  NF1,TO,DF1
         L     0,NF1
         CVD   0,ZCVT_PWORK
         LARL  ZC_R1,=AL1(C' ',C' ',X'20',X'20',X'20',X'20',X'20',X'20'X
               ,X'20',X'20',X'20',0)
         MVC   ZCVT_WORKAREA(11),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(11),8-5+ZCVT_PWORK
         MVC   DF1,ZCVT_WORKAREA+2
*            IF DF1 NOT = '         ' PERFORM BAD ELSE PERFORM GOOD.
*ZC     33         IF    DF1,NOT,=,'         '
         LARL  ZC_R1,=CL10'         '
         CLC   DF1,0(ZC_R1)
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
*            MOVE 1 TO NF1
*ZC     34         MOVE  1,TO,NF1
          MVHI  NF1,1
*      2     MOVE NF1 TO DF1                                           
*ZC     35      2  MOVE  NF1,TO,DF1
         L     0,NF1
         CVD   0,ZCVT_PWORK
         LARL  ZC_R1,=AL1(C' ',C' ',X'20',X'20',X'20',X'20',X'20',X'20'X
               ,X'20',X'20',X'20',0)
         MVC   ZCVT_WORKAREA(11),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(11),8-5+ZCVT_PWORK
         MVC   DF1,ZCVT_WORKAREA+2
*            IF DF1 NOT = '        1' PERFORM BAD ELSE PERFORM GOOD.
*ZC     36         IF    DF1,NOT,=,'        1'
         LARL  ZC_R1,=CL10'        1'
         CLC   DF1,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_2_1
*ZC     36         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     36         ELSE
         J     PG_IF_2_E
PG_IF_2_1    DS    0H  &TYPE
*ZC     36         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_2_E    DS    0H  &TYPE
*            MOVE 0 TO NF1
*ZC     37         MOVE  0,TO,NF1
          MVHI  NF1,0
*      3     MOVE NF1 TO DF2                                           
*ZC     38      3  MOVE  NF1,TO,DF2
         L     0,NF1
         CVD   0,ZCVT_PWORK
         LARL  ZC_R1,=AL1(C' ',C' ',X'20',X'20',X'20',X'20',X'20',X'20'X
               ,X'20',X'21',X'20',0)
         MVC   ZCVT_WORKAREA(11),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(11),8-5+ZCVT_PWORK
         MVC   DF2,ZCVT_WORKAREA+2
*            IF DF2 NOT = '        0' PERFORM BAD ELSE PERFORM GOOD.
*ZC     39         IF    DF2,NOT,=,'        0'
         LARL  ZC_R1,=CL10'        0'
         CLC   DF2,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_3_1
*ZC     39         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     39         ELSE
         J     PG_IF_3_E
PG_IF_3_1    DS    0H  &TYPE
*ZC     39         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_3_E    DS    0H  &TYPE
*            MOVE 123456789 TO NF1
*ZC     40         MOVE  123456789,TO,NF1
          LARL  ZC_R1,=F'123456789'
          MVC   NF1,0(ZC_R1)
*      4     MOVE NF1 TO DF2                                           
*ZC     41      4  MOVE  NF1,TO,DF2
         L     0,NF1
         CVD   0,ZCVT_PWORK
         LARL  ZC_R1,=AL1(C' ',C' ',X'20',X'20',X'20',X'20',X'20',X'20'X
               ,X'20',X'21',X'20',0)
         MVC   ZCVT_WORKAREA(11),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(11),8-5+ZCVT_PWORK
         MVC   DF2,ZCVT_WORKAREA+2
*            IF DF2 NOT = '123456789' PERFORM BAD ELSE PERFORM GOOD.
*ZC     42         IF    DF2,NOT,=,'123456789'
         LARL  ZC_R1,=CL10'123456789'
         CLC   DF2,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_4_1
*ZC     42         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     42         ELSE
         J     PG_IF_4_E
PG_IF_4_1    DS    0H  &TYPE
*ZC     42         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_4_E    DS    0H  &TYPE
*            MOVE 0 TO NF1
*ZC     43         MOVE  0,TO,NF1
          MVHI  NF1,0
*      5     MOVE NF1 TO DF3                                           
*ZC     44      5  MOVE  NF1,TO,DF3
         L     0,NF1
         CVD   0,ZCVT_PWORK
         LARL  ZC_R1,=AL1(C' ',C' ',X'20',X'20',X'20',C',',X'20',X'20',X
               X'20',C',',X'20',X'21',X'20',0)
         MVC   ZCVT_WORKAREA(13),0(ZC_R1) MOVE MASK FOR ED
         LA    ZC_R1,ZCVT_WORKAREA+1+1
         EDMK  ZCVT_WORKAREA(13),8-5+ZCVT_PWORK
         MVC   DF3,ZCVT_WORKAREA+2
*            IF DF3 NOT = '          0' PERFORM BAD ELSE PERFORM GOOD.
*ZC     45         IF    DF3,NOT,=,'          0'
         LARL  ZC_R1,=CL12'          0'
         CLC   DF3,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_5_1
*ZC     45         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     45         ELSE
         J     PG_IF_5_E
PG_IF_5_1    DS    0H  &TYPE
*ZC     45         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_5_E    DS    0H  &TYPE
*            MOVE 123456789 TO NF1
*ZC     46         MOVE  123456789,TO,NF1
          LARL  ZC_R1,=F'123456789'
          MVC   NF1,0(ZC_R1)
*      6     MOVE NF1 TO DF3                                           
*ZC     47      6  MOVE  NF1,TO,DF3
         L     0,NF1
         CVD   0,ZCVT_PWORK
         LARL  ZC_R1,=AL1(C' ',C' ',X'20',X'20',X'20',C',',X'20',X'20',X
               X'20',C',',X'20',X'21',X'20',0)
         MVC   ZCVT_WORKAREA(13),0(ZC_R1) MOVE MASK FOR ED
         LA    ZC_R1,ZCVT_WORKAREA+1+1
         EDMK  ZCVT_WORKAREA(13),8-5+ZCVT_PWORK
         MVC   DF3,ZCVT_WORKAREA+2
*            IF DF3 NOT = '123,456,789' PERFORM BAD ELSE PERFORM GOOD.
*ZC     48         IF    DF3,NOT,=,'123,456,789'
         LARL  ZC_R1,=CL12'123,456,789'
         CLC   DF3,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_6_1
*ZC     48         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     48         ELSE
         J     PG_IF_6_E
PG_IF_6_1    DS    0H  &TYPE
*ZC     48         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_6_E    DS    0H  &TYPE
*            MOVE 0 TO NH1
*ZC     49         MOVE  0,TO,NH1
          MVHHI NH1,0
*      7     MOVE NH1 TO DH1                                           
*ZC     50      7  MOVE  NH1,TO,DH1
         LH    0,NH1
         CVD   0,ZCVT_PWORK
         LARL  ZC_R1,=AL1(C' ',X'20',X'20',X'20',X'20',X'20')
         MVC   ZCVT_WORKAREA(6),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(6),8-3+ZCVT_PWORK
         MVC   DH1,ZCVT_WORKAREA+2
*            IF DH1 NOT = '    ' PERFORM BAD ELSE PERFORM GOOD.
*ZC     51         IF    DH1,NOT,=,'    '
         LARL  ZC_R1,=CL4'    '
         CLC   DH1,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_7_1
*ZC     51         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     51         ELSE
         J     PG_IF_7_E
PG_IF_7_1    DS    0H  &TYPE
*ZC     51         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_7_E    DS    0H  &TYPE
*            MOVE 1 TO NH1
*ZC     52         MOVE  1,TO,NH1
          MVHHI NH1,1
*      8     MOVE NH1 TO DH1                                           
*ZC     53      8  MOVE  NH1,TO,DH1
         LH    0,NH1
         CVD   0,ZCVT_PWORK
         LARL  ZC_R1,=AL1(C' ',X'20',X'20',X'20',X'20',X'20')
         MVC   ZCVT_WORKAREA(6),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(6),8-3+ZCVT_PWORK
         MVC   DH1,ZCVT_WORKAREA+2
*            IF DH1 NOT = '   1' PERFORM BAD ELSE PERFORM GOOD.
*ZC     54         IF    DH1,NOT,=,'   1'
         LARL  ZC_R1,=CL4'   1'
         CLC   DH1,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_8_1
*ZC     54         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     54         ELSE
         J     PG_IF_8_E
PG_IF_8_1    DS    0H  &TYPE
*ZC     54         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_8_E    DS    0H  &TYPE
*            MOVE 0 TO NH1
*ZC     55         MOVE  0,TO,NH1
          MVHHI NH1,0
*      9     MOVE NH1 TO DH2                                           
*ZC     56      9  MOVE  NH1,TO,DH2
         LH    0,NH1
         CVD   0,ZCVT_PWORK
         LARL  ZC_R1,=AL1(C' ',X'20',X'20',X'20',X'21',X'20')
         MVC   ZCVT_WORKAREA(6),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(6),8-3+ZCVT_PWORK
         MVC   DH2,ZCVT_WORKAREA+2
*            IF DH2 NOT = '   0' PERFORM BAD ELSE PERFORM GOOD.
*ZC     57         IF    DH2,NOT,=,'   0'
         LARL  ZC_R1,=CL4'   0'
         CLC   DH2,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_9_1
*ZC     57         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     57         ELSE
         J     PG_IF_9_E
PG_IF_9_1    DS    0H  &TYPE
*ZC     57         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_9_E    DS    0H  &TYPE
*            MOVE 1234 TO NH1
*ZC     58         MOVE  1234,TO,NH1
          MVHHI NH1,1234
*     10     MOVE NH1 TO DH2                                           
*ZC     59     10  MOVE  NH1,TO,DH2
         LH    0,NH1
         CVD   0,ZCVT_PWORK
         LARL  ZC_R1,=AL1(C' ',X'20',X'20',X'20',X'21',X'20')
         MVC   ZCVT_WORKAREA(6),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(6),8-3+ZCVT_PWORK
         MVC   DH2,ZCVT_WORKAREA+2
*            IF DH2 NOT = '1234' PERFORM BAD ELSE PERFORM GOOD.
*ZC     60         IF    DH2,NOT,=,'1234'
         LARL  ZC_R1,=CL4'1234'
         CLC   DH2,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_10_1
*ZC     60         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     60         ELSE
         J     PG_IF_10_E
PG_IF_10_1   DS    0H  &TYPE
*ZC     60         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_10_E   DS    0H  &TYPE
*            MOVE 0 TO NP1
*ZC     61         MOVE  0,TO,NP1
          LARL  ZC_R1,=PL2'0'
          MVC   NP1,1(ZC_R1)
*     11     MOVE NP1 TO DP1
*ZC     62     11  MOVE  NP1,TO,DP1
         LARL  ZC_R1,=AL1(C' ',C' ',X'20',0)
         MVC   ZCVT_WORKAREA(3),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(3),1-1+NP1
         MVC   DP1,ZCVT_WORKAREA+2
*            IF DP1 NOT = ' ' PERFORM BAD ELSE PERFORM GOOD.
*ZC     63         IF    DP1,NOT,=,' '
         CLI   DP1,C' '
         BRC   15-ZC_NE,PG_IF_11_1
*ZC     63         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     63         ELSE
         J     PG_IF_11_E
PG_IF_11_1   DS    0H  &TYPE
*ZC     63         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_11_E   DS    0H  &TYPE
*            MOVE 1 TO NP1
*ZC     64         MOVE  1,TO,NP1
          LARL  ZC_R1,=PL2'1'
          MVC   NP1,1(ZC_R1)
*     12     MOVE NP1 TO DP1                                           
*ZC     65     12  MOVE  NP1,TO,DP1
         LARL  ZC_R1,=AL1(C' ',C' ',X'20',0)
         MVC   ZCVT_WORKAREA(3),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(3),1-1+NP1
         MVC   DP1,ZCVT_WORKAREA+2
*            IF DP1 NOT = '1' PERFORM BAD ELSE PERFORM GOOD.
*ZC     66         IF    DP1,NOT,=,'1'
         CLI   DP1,C'1'
         BRC   15-ZC_NE,PG_IF_12_1
*ZC     66         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     66         ELSE
         J     PG_IF_12_E
PG_IF_12_1   DS    0H  &TYPE
*ZC     66         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_12_E   DS    0H  &TYPE
*            MOVE 0 TO NP1
*ZC     67         MOVE  0,TO,NP1
          LARL  ZC_R1,=PL2'0'
          MVC   NP1,1(ZC_R1)
*     13     MOVE NP1 TO DP2                                           
*ZC     68     13  MOVE  NP1,TO,DP2
         LARL  ZC_R1,=AL1(C' ',X'20',X'20',X'20',X'21',X'20')
         MVC   ZCVT_WORKAREA(6),0(ZC_R1) MOVE MASK FOR ED
         ZAP   ZCVT_PWORK1(3),NP1
         ED    ZCVT_WORKAREA(6),ZCVT_PWORK1
         MVC   DP2,ZCVT_WORKAREA+2
*            IF DP2 NOT = '   0' PERFORM BAD ELSE PERFORM GOOD.
*ZC     69         IF    DP2,NOT,=,'   0'
         LARL  ZC_R1,=CL4'   0'
         CLC   DP2,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_13_1
*ZC     69         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     69         ELSE
         J     PG_IF_13_E
PG_IF_13_1   DS    0H  &TYPE
*ZC     69         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_13_E   DS    0H  &TYPE
*            MOVE 0 TO NP2
*ZC     70         MOVE  0,TO,NP2
          LARL  ZC_R1,=PL4'0'
          MVC   NP2,1(ZC_R1)
*     14     MOVE NP2 TO DP2                                           
*ZC     71     14  MOVE  NP2,TO,DP2
         LARL  ZC_R1,=AL1(C' ',X'20',X'20',X'20',X'21',X'20')
         MVC   ZCVT_WORKAREA(6),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(6),3-3+NP2
         MVC   DP2,ZCVT_WORKAREA+2
*            IF DP2 NOT = '   0' PERFORM BAD ELSE PERFORM GOOD.
*ZC     72         IF    DP2,NOT,=,'   0'
         LARL  ZC_R1,=CL4'   0'
         CLC   DP2,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_14_1
*ZC     72         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     72         ELSE
         J     PG_IF_14_E
PG_IF_14_1   DS    0H  &TYPE
*ZC     72         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_14_E   DS    0H  &TYPE
*            MOVE 1234 TO NP2
*ZC     73         MOVE  1234,TO,NP2
          LARL  ZC_R1,=PL4'1234'
          MVC   NP2,1(ZC_R1)
*     15     MOVE NP2 TO DP2                                           
*ZC     74     15  MOVE  NP2,TO,DP2
         LARL  ZC_R1,=AL1(C' ',X'20',X'20',X'20',X'21',X'20')
         MVC   ZCVT_WORKAREA(6),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(6),3-3+NP2
         MVC   DP2,ZCVT_WORKAREA+2
*            IF DP2 NOT = '1234' PERFORM BAD ELSE PERFORM GOOD.
*ZC     75         IF    DP2,NOT,=,'1234'
         LARL  ZC_R1,=CL4'1234'
         CLC   DP2,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_15_1
*ZC     75         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     75         ELSE
         J     PG_IF_15_E
PG_IF_15_1   DS    0H  &TYPE
*ZC     75         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_15_E   DS    0H  &TYPE
*            MOVE 12 TO NP2
*ZC     76         MOVE  12,TO,NP2
          LARL  ZC_R1,=PL4'12'
          MVC   NP2,1(ZC_R1)
*     16     MOVE NP2 TO DP3                                           
*ZC     77     16  MOVE  NP2,TO,DP3
         LARL  ZC_R1,=AL1(C' ',X'20',X'20',X'20',C'-',X'21',X'20',0)
         MVC   ZCVT_WORKAREA(7),0(ZC_R1) MOVE MASK FOR ED
         LA    ZC_R1,ZCVT_WORKAREA+1+1
         EDMK  ZCVT_WORKAREA(7),3-3+NP2
         MVC   DP3,ZCVT_WORKAREA+2
         OI    3+DP3,C'0'
*            IF DP3 NOT = '   12' PERFORM BAD ELSE PERFORM GOOD.
*ZC     78         IF    DP3,NOT,=,'   12'
         LARL  ZC_R1,=CL6'   12'
         CLC   DP3,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_16_1
*ZC     78         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     78         ELSE
         J     PG_IF_16_E
PG_IF_16_1   DS    0H  &TYPE
*ZC     78         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_16_E   DS    0H  &TYPE
*            MOVE 1234 TO NP2
*ZC     79         MOVE  1234,TO,NP2
          LARL  ZC_R1,=PL4'1234'
          MVC   NP2,1(ZC_R1)
*     17     MOVE NP2 TO DP3                                           
*ZC     80     17  MOVE  NP2,TO,DP3
         LARL  ZC_R1,=AL1(C' ',X'20',X'20',X'20',C'-',X'21',X'20',0)
         MVC   ZCVT_WORKAREA(7),0(ZC_R1) MOVE MASK FOR ED
         LA    ZC_R1,ZCVT_WORKAREA+1+1
         EDMK  ZCVT_WORKAREA(7),3-3+NP2
         MVC   DP3,ZCVT_WORKAREA+2
         OI    3+DP3,C'0'
*            IF DP3 NOT = '12-34' PERFORM BAD ELSE PERFORM GOOD.
*ZC     81         IF    DP3,NOT,=,'12-34'
         LARL  ZC_R1,=CL6'12-34'
         CLC   DP3,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_17_1
*ZC     81         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     81         ELSE
         J     PG_IF_17_E
PG_IF_17_1   DS    0H  &TYPE
*ZC     81         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_17_E   DS    0H  &TYPE
*     18     MOVE ABCDEF(2:1) TO ABCDEF(5:1)
*ZC     82     18  MOVE  ABCDEF,'(',2,:,1,')',TO,ABCDEF,'(',5,:,1,')'
         LA    ZC_R2,ABCDEF
         IILF  ZC_R14,1
         BCTR  ZC_R2,0 BACKUP FOR FULL OFFSET+ADJUSTMENT
         LA    ZC_R3,ABCDEF
         IILF  ZC_R15,1
         BCTR  ZC_R3,0 BACKUP FOR FULL OFFSET+ADJUSTMENT
         LA    ZC_R0,5(ZC_R3)
         LR    ZC_R1,ZC_R15     RPI 1182 RMD VLEN TAR REG
         LA    ZC_R2,2(ZC_R2)
         LR    ZC_R3,ZC_R14     RPI 1182 RMD VLEN SRC REG
         OILH  ZC_R3,X'4000'    RPI 1182 PAD SHORT SRC WITH BLANKS
         MVCL  ZC_R0,ZC_R2
*            IF ABCDEF NOT = 'ABCDBF' PERFORM BAD ELSE PERFORM GOOD.
*ZC     83         IF    ABCDEF,NOT,=,'ABCDBF'
         LARL  ZC_R1,=CL6'ABCDBF'
         CLC   ABCDEF,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_18_1
*ZC     83         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     83         ELSE
         J     PG_IF_18_E
PG_IF_18_1   DS    0H  &TYPE
*ZC     83         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_18_E   DS    0H  &TYPE
*     19     IF ABC(1)(2:1) NOT = ABC(2)(2:1)
*ZC     84     19  IF    ABC,'(',1,')','(',2,:,1,')',NOT,=,ABC,'(',2,')X
               ','(',2,:,1,')'
         LA    ZC_R2,ABC
         BCTR  ZC_R2,0 BACKUP FOR FULL OFFSET+ADJUSTMENT
         IILF  ZC_R3,(2-1)*3 (LIT-1)*LEN
         LA    ZC_R3,ABC(ZC_R3)
         BCTR  ZC_R3,0 BACKUP FOR FULL OFFSET+ADJUSTMENT
         CLC   2(1,ZC_R2),2(ZC_R3)
         BRC   15-ZC_NE,PG_IF_19_1
*                PERFORM BAD ELSE PERFORM GOOD.
*ZC     85         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     85         ELSE
         J     PG_IF_19_E
PG_IF_19_1   DS    0H  &TYPE
*ZC     85         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_19_E   DS    0H  &TYPE
*     20     MOVE ABC(1)(2:2) TO ABC(2)(2:2)
*ZC     86     20  MOVE  ABC,'(',1,')','(',2,:,2,')',TO,ABC,'(',2,')','X
               (',2,:,2,')'
         LA    ZC_R2,ABC
         IILF  ZC_R14,2
         BCTR  ZC_R2,0 BACKUP FOR FULL OFFSET+ADJUSTMENT
         IILF  ZC_R3,(2-1)*3 (LIT-1)*LEN
         LA    ZC_R3,ABC(ZC_R3)
         IILF  ZC_R15,2
         BCTR  ZC_R3,0 BACKUP FOR FULL OFFSET+ADJUSTMENT
         LA    ZC_R0,2(ZC_R3)
         LR    ZC_R1,ZC_R15     RPI 1182 RMD VLEN TAR REG
         LA    ZC_R2,2(ZC_R2)
         LR    ZC_R3,ZC_R14     RPI 1182 RMD VLEN SRC REG
         OILH  ZC_R3,X'4000'    RPI 1182 PAD SHORT SRC WITH BLANKS
         MVCL  ZC_R0,ZC_R2
*            IF ABC(2) NOT = 'DBC' PERFORM BAD ELSE PERFORM GOOD.
*ZC     87         IF    ABC,'(',2,')',NOT,=,'DBC'
         IILF  ZC_R2,(2-1)*3 (LIT-1)*LEN
         LA    ZC_R2,ABC(ZC_R2)
         LARL  ZC_R1,=CL4'DBC'
         CLC   0(3,ZC_R2),0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_20_1
*ZC     87         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     87         ELSE
         J     PG_IF_20_E
PG_IF_20_1   DS    0H  &TYPE
*ZC     87         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_20_E   DS    0H  &TYPE
*     21     MOVE FLD1 TO FLD2(2:2)
*ZC     88     21  MOVE  FLD1,TO,FLD2,'(',2,:,2,')'
         LA    ZC_R3,FLD2
         IILF  ZC_R15,2
         BCTR  ZC_R3,0 BACKUP FOR FULL OFFSET+ADJUSTMENT
         LA    ZC_R0,2(ZC_R3)
         LR    ZC_R1,ZC_R15     RPI 1182 RMD VLEN TAR REG
         LA    ZC_R2,FLD1
         IILF  ZC_R3,2  RPI 1182 LHI TO IILH
         MVCL  ZC_R0,ZC_R2
*            IF FLD2 NOT = 'AXY' PERFORM BAD ELSE PERFORM GOOD.
*ZC     89         IF    FLD2,NOT,=,'AXY'
         LARL  ZC_R1,=CL4'AXY'
         CLC   FLD2,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_21_1
*ZC     89         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     89         ELSE
         J     PG_IF_21_E
PG_IF_21_1   DS    0H  &TYPE
*ZC     89         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_21_E   DS    0H  &TYPE
*     22     MOVE 2 TO SUB1
*ZC     90     22  MOVE  2,TO,SUB1
          MVI   SUB1,C'2'
*            MOVE '12' TO FLD2(SUB1:2)
*ZC     91         MOVE  '12',TO,FLD2,'(',SUB1,:,2,')'
         LA    ZC_R3,FLD2
         IILF  ZC_R15,SUB1-ZC_WS
         AR    ZC_R15,ZC_R13
         PACK  ZCVT_PWORK1(1),0(1,ZC_R15)
         ZAP   ZCVT_PWORK,ZCVT_PWORK1(1)
         CVB   ZC_R15,ZCVT_PWORK
         AR    ZC_R3,ZC_R15
         IILF  ZC_R15,2
         BCTR  ZC_R3,0 BACKUP FOR FULL OFFSET+ADJUSTMENT
         LA    ZC_R0,0(ZC_R3)
         LR    ZC_R1,ZC_R15     RPI 1182 RMD VLEN TAR REG
         LARL  ZC_R2,=CL2'12'
         IILL  ZC_R3,2
         IILH  ZC_R3,X'4000'
         MVCL  ZC_R0,ZC_R2
*            IF FLD2 NOT = 'A12' PERFORM BAD ELSE PERFORM GOOD.
*ZC     92         IF    FLD2,NOT,=,'A12'
         LARL  ZC_R1,=CL4'A12'
         CLC   FLD2,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_22_1
*ZC     92         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     92         ELSE
         J     PG_IF_22_E
PG_IF_22_1   DS    0H  &TYPE
*ZC     92         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_22_E   DS    0H  &TYPE
*     23     MOVE 1 TO SUB1
*ZC     93     23  MOVE  1,TO,SUB1
          MVI   SUB1,C'1'
*             MOVE '12' TO FLD2(SUB1+1:2)
*ZC     94         MOVE  '12',TO,FLD2,'(',SUB1,+,1,:,2,')'
         LA    ZC_R3,FLD2
         IILF  ZC_R15,SUB1-ZC_WS
         AR    ZC_R15,ZC_R13
         PACK  ZCVT_PWORK1(1),0(1,ZC_R15)
         ZAP   ZCVT_PWORK,ZCVT_PWORK1(1)
         CVB   ZC_R15,ZCVT_PWORK
         AR    ZC_R3,ZC_R15
         IILF  ZC_R15,2
         BCTR  ZC_R3,0 BACKUP FOR FULL OFFSET+ADJUSTMENT
         AFI   ZC_R3,1
         LA    ZC_R0,0(ZC_R3)
         LR    ZC_R1,ZC_R15     RPI 1182 RMD VLEN TAR REG
         LARL  ZC_R2,=CL2'12'
         IILL  ZC_R3,2
         IILH  ZC_R3,X'4000'
         MVCL  ZC_R0,ZC_R2
*            IF FLD2 NOT = 'A12' PERFORM BAD ELSE PERFORM GOOD.
*ZC     95         IF    FLD2,NOT,=,'A12'
         LARL  ZC_R1,=CL4'A12'
         CLC   FLD2,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_23_1
*ZC     95         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     95         ELSE
         J     PG_IF_23_E
PG_IF_23_1   DS    0H  &TYPE
*ZC     95         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_23_E   DS    0H  &TYPE
*     24     MOVE 3 TO SUB1
*ZC     96     24  MOVE  3,TO,SUB1
          MVI   SUB1,C'3'
*             MOVE '12' TO FLD2(SUB1 -1:2)
*ZC     97         MOVE  '12',TO,FLD2,'(',SUB1,-,1,:,2,')'
         LA    ZC_R3,FLD2
         IILF  ZC_R15,SUB1-ZC_WS
         AR    ZC_R15,ZC_R13
         PACK  ZCVT_PWORK1(1),0(1,ZC_R15)
         ZAP   ZCVT_PWORK,ZCVT_PWORK1(1)
         CVB   ZC_R15,ZCVT_PWORK
         AR    ZC_R3,ZC_R15
         IILF  ZC_R15,2
         BCTR  ZC_R3,0 BACKUP FOR FULL OFFSET+ADJUSTMENT
         AFI   ZC_R3,-1
         LA    ZC_R0,0(ZC_R3)
         LR    ZC_R1,ZC_R15     RPI 1182 RMD VLEN TAR REG
         LARL  ZC_R2,=CL2'12'
         IILL  ZC_R3,2
         IILH  ZC_R3,X'4000'
         MVCL  ZC_R0,ZC_R2
*            IF FLD2 NOT = 'A12' PERFORM BAD ELSE PERFORM GOOD.
*ZC     98         IF    FLD2,NOT,=,'A12'
         LARL  ZC_R1,=CL4'A12'
         CLC   FLD2,0(ZC_R1)
         BRC   15-ZC_NE,PG_IF_24_1
*ZC     98         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     98         ELSE
         J     PG_IF_24_E
PG_IF_24_1   DS    0H  &TYPE
*ZC     98         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_24_E   DS    0H  &TYPE
*        WRAP-UP.
PG_MAINLINE_END L ZC_R15,ZCVT_PMCHECK
         BASR  ZC_R14,ZC_R15 CHECK FOR END OF CURRENT PERFORM
PG_WRAP_UP DS  0H
*            DISPLAY 'TESTMOV1 GOOD TESTS =' GOOD
*ZC    100         DISPLAY 'TESTMOV1 GOOD TESTS =',GOOD
         LA    ZC_R3,ZCVT_WORKAREA  ZC_R3=CVT LIST WORK AREA
         LARL  ZC_R0,=CL22'TESTMOV1 GOOD TESTS =' PAD TO EVEN LEN LIT
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
*ZC    101         STOP  RUN
         LH    ZC_R1,RETURN_CODE      PASS RETURN CODE IN R1
         L     ZC_R15,ZCVT_GOBACK
         BR    ZC_R15
*        GOOD.
PG_WRAP_UP_END L ZC_R15,ZCVT_PMCHECK
         BASR  ZC_R14,ZC_R15 CHECK FOR END OF CURRENT PERFORM
PG_GOOD  DS    0H
*            ADD 1 TO GOOD
*ZC    103         ADD   1,TO,GOOD
         ASI   GOOD,1
*        BAD.
PG_GOOD_END L  ZC_R15,ZCVT_PMCHECK
         BASR  ZC_R14,ZC_R15 CHECK FOR END OF CURRENT PERFORM
PG_BAD   DS    0H
*            DISPLAY 'TESTMOV1 GOOD TESTS =' GOOD 'BAD TESTS=1'.
*ZC    105         DISPLAY 'TESTMOV1 GOOD TESTS =',GOOD,'BAD TESTS=1'
         LA    ZC_R3,ZCVT_WORKAREA  ZC_R3=CVT LIST WORK AREA
         LARL  ZC_R0,=CL22'TESTMOV1 GOOD TESTS =' PAD TO EVEN LEN LIT
         LA    ZC_R1,21
         LA    ZC_R2,C'X'
         STM   ZC_R0,ZC_R2,0(ZC_R3)  SET DISPLAY LIST ENTRY
         LA    ZC_R0,GOOD
         LA    ZC_R1,4  RPI 1182 WAS &SYM_LEN(&FIELD_IX)
         LA    ZC_R2,C'F'
         STM   ZC_R0,ZC_R2,12(ZC_R3)  SET DISPLAY LIST ENTRY
         LARL  ZC_R0,=CL12'BAD TESTS=1' PAD TO EVEN LEN LIT
         LA    ZC_R1,11
         LA    ZC_R2,C'X'
         STM   ZC_R0,ZC_R2,24(ZC_R3)  SET DISPLAY LIST ENTRY
         OI    36-4(ZC_R3),X'80' SET VL BIT IN LAST WORD OF PARM LIST
         LR    ZC_R1,ZC_R3
         L     ZC_R15,ZCVT_DISPLAY
         BASR  ZC_R14,ZC_R15
*            MOVE 16 TO RETURN-CODE
*ZC    106         MOVE  16,TO,RETURN_CODE
          MVHHI RETURN_CODE,16
*            STOP RUN.
*ZC    107         STOP  RUN
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
                      
*    01  ABCDEF                         00000058 00000006 1   X   X(6) X
                     ''ABCDEF'' 
*    01  ABC                            00000058 00000003 2   X   X(3) X
                      
*    01  NF1                            0000005E 00000004 1   F   9(9) X
                      
*    01  DF1                            00000062 00000009 1   X   Z(9) X
                      
*    01  DF2                            0000006B 00000009 1   X   Z(8)9X
                      
*    01  DF3                            00000074 0000000B 1   X   ZZZ,ZX
               ZZ,ZZ  
*    01  NH1                            0000007F 00000002 1   H   9(4) X
                      
*    01  DH1                            00000081 00000004 1   X   Z(4) X
                      
*    01  DH2                            00000085 00000004 1   X   Z(3)9X
                      
*    01  NP1                            00000089 00000001 1   P   9    X
                      
*    01  NP2                            0000008A 00000003 1   P   9(4) X
                      
*    01  DP1                            0000008D 00000001 1   X   Z    X
                      
*    01  DP2                            0000008E 00000004 1   X   Z(3)9X
                      
*    01  DP3                            00000092 00000005 1   X   ZZ-99X
                      
*    01  FLD1                           00000097 00000002 1   X   XX   X
                     ''XY'' 
*    01  FLD2                           00000099 00000003 1   X   XXX  X
                     ''ABC'' 
*    01  GOOD                           0000009C 00000004 1   F   9(9) X
                     0 
*    01  SUB1                           000000A0 00000001 1   Z   9    X
                      
*    01  DEBUG_ITEM                     000000A1 00000058 1   X        X
                      
*    02  DEBUG_LINE                     000000A1 00000006 1   X   X(6) X
                      
*    02  FILLER                         000000A7 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_NAME                     000000A8 0000001E 1   X   X(30)X
                      
*    02  FILLER                         000000C6 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_1                    000000C7 00000004 1   Z   9999 X
                      
*    02  FILLER                         000000CB 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_2                    000000CC 00000004 1   Z   9999 X
                      
*    02  FILLER                         000000D0 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_3                    000000D1 00000004 1   Z   9999 X
                      
*    02  FILLER                         000000D5 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_CONTENTS                 000000D6 00000023 1   X   X(35)X
                      
*    01  TRUE                           000000F9 00000001 1   Z   9    X
                     1 
*    01  FALSE                          000000FA 00000001 1   Z   9    X
                     0 
*    01  RETURN_CODE                    000000FB 00000002 1   H   9(4) X
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
ABCDEF   DC CL6'ABCDEF'
         ORG   ABCDEF  START REDEFINE
ZC_WS_LOC_7  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ABC      DS  2CL3
ZC_WS_LOC_8  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
NF1      DS  FL4
ZC_WS_LOC_9  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DF1      DS  CL9
ZC_WS_LOC_10 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DF2      DS  CL9
ZC_WS_LOC_11 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DF3      DS  CL11
ZC_WS_LOC_12 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
NH1      DS  HL2
ZC_WS_LOC_13 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DH1      DS  CL4
ZC_WS_LOC_14 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DH2      DS  CL4
ZC_WS_LOC_15 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
NP1      DS  PL1
ZC_WS_LOC_16 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
NP2      DS  PL3
ZC_WS_LOC_17 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DP1      DS  CL1
ZC_WS_LOC_18 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DP2      DS  CL4
ZC_WS_LOC_19 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DP3      DS  CL5
ZC_WS_LOC_20 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
FLD1     DC CL2'XY'
ZC_WS_LOC_21 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
FLD2     DC CL3'ABC'
ZC_WS_LOC_22 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
GOOD     DC AL4(0)                  RPI 1065
ZC_WS_LOC_23 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
SUB1     DS  ZL1
ZC_WS_LOC_24 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_ITEM DS 0CL88
ZC_WS_LOC_25 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_LINE DS CL6
ZC_WS_LOC_26 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_27 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_NAME DS CL30
ZC_WS_LOC_28 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_29 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_1 DS ZL4
ZC_WS_LOC_30 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_31 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_2 DS ZL4
ZC_WS_LOC_32 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_33 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_3 DS ZL4
ZC_WS_LOC_34 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_35 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_CONTENTS DS CL35
ZC_WS_LOC_36 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
TRUE     DC CL1'1'
ZC_WS_LOC_37 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
FALSE    DC CL1'0'
ZC_WS_LOC_38 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
RETURN_CODE DC AL2(0)                  RPI 1065
*    ZCOBOL LINKAGE SECTION DATA ITEMS 
*    LVL DATA NAME                      ADDR     LEN      DUP TYP PIC  X
                     VALUE 
ZC_WSLOC LOCTR 
ZC_WSLOC LOCTR 
ZC_WS_DIFF EQU  *-ZC_WS-253  DIFF BETWEEN ALLOC AND CALC WS
ZC_WS_END DS   0D
         MNOTE *,'ZCOBOL TOTAL SYMBOLS                 = 38'
         MNOTE *,'ZCOBOL TOTAL SYMBOL DUPLICATES       = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL MAX DUP CHAIN    = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL LEVEL 88         = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL SET INDEXES      = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL LINKAGE SECTIONS = 0'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE SECTIONS      = 0'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE PARAGRAPHS    = 4'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE PARAGRAPH DUP = 0'
         END 
