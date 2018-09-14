*    ZCOBOL PGM='zcobol\test\TESTMOV3' VER=V1.5.06 MM/DD/YY  
*    ZCOBOL OPTIONS=() 
         COPY  TESTMOV3_ZC_LABELS.CPY
*        IDENTIFICATION DIVISION.
*        PROGRAM-ID.    TESTMOV3.
         PRINT NOLIST,NOGEN,NOLISTUSE    SET LIST OPTION FOR INTERNAL CX
               ODE
TESTMOV3 CSECT ,                CSECT WITH PROCEDURE CODE AND WS
         USING *,ZC_R15
         STM   14,12,12+4*(14-14)(13)
         CNOP  4,8             FORCE ZC390PVT TO DOUBLEWORD BOUNDARY
         BRAS  ZC_R8,ZC_LOAD
         USING *,ZC_R8            BASE FOR LOAD AND CICS V5 USE
*
*  THESE FIELDS MUST BE KEPT IN SYNC WITH zcobol\ZC390PVT.CPY
*
         DC    CL8'TESTMOV3'    PVTPGM   ZCOBOL PGM NAME
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
*        DATE-WRITTEN.  04/21/12.
*      * TEST MOVE WITH SCALING FOR IMPLIED DECIMAL                    
*        ENVIRONMENT DIVISION.
*        DATA DIVISION.
         PRINT DATA
*        WORKING-STORAGE SECTION.
*        77 EH1 FLOAT-HEX-7       VALUE 1.5.
*        77 DH1 FLOAT-HEX-15      VALUE 1.5.
*        77 LH1 FLOAT-HEX-30      VALUE 1.5.
*        77 EB1 FLOAT-BINARY-7    VALUE 1.5.
*        77 DB1 FLOAT-BINARY-16   VALUE 1.5.
*        77 LB1 FLOAT-BINARY-34   VALUE 1.5.
*        77 ED1 FLOAT-DECIMAL-7   VALUE 1.5.
*        77 DD1 FLOAT-DECIMAL-16  VALUE 1.5.
*        77 LD1 FLOAT-DECIMAL-34  VALUE 1.5.
*        77 H1      COMP PIC S9(3)V9    VALUE 1.5.
*        77 F1      COMP PIC S9(8)V9    VALUE 1.5.
*        77 G1      COMP PIC S9(17)V9   VALUE 1.5.
*        77 Q1      COMP PIC S9(38)V9   VALUE 1.5.
*        77 P1      COMP-3 PIC S9(30)V9 VALUE 1.5.
*        77 Z1             PIC S9(30)V9 VALUE 1.5.
*        77 EH2 FLOAT-HEX-7       VALUE 1.50.
*        77 DH2 FLOAT-HEX-15      VALUE 1.50.
*        77 LH2 FLOAT-HEX-30      VALUE 1.50.
*        77 EB2 FLOAT-BINARY-7    VALUE 1.50.
*        77 DB2 FLOAT-BINARY-16   VALUE 1.50.
*        77 LB2 FLOAT-BINARY-34   VALUE 1.50.
*        77 ED2 FLOAT-DECIMAL-7   VALUE 1.50.
*        77 DD2 FLOAT-DECIMAL-16  VALUE 1.50.
*        77 LD2 FLOAT-DECIMAL-34  VALUE 1.50.
*        77 H2      COMP PIC S9(2)V99         VALUE 1.50.
*        77 F2      COMP PIC S9(6)V999        VALUE 1.50.
*        77 G2      COMP PIC S9(14)V9999      VALUE 1.50.
*        77 Q2      COMP PIC S9(34)V99999     VALUE 1.50.
*        77 P2      COMP-3 PIC S9(25)V999999  VALUE 1.50.
*        77 Z2             PIC S9(24)V9999999 VALUE 1.50.
*        77 GOOD    COMP-3 PIC 9(4)   VALUE 0.
*        77 BAD     COMP-3 PIC 9(4)   VALUE 0.
*        PROCEDURE DIVISION.
*ZC   PROCEDURE DIVISION
         PRINT LIST,GEN,LISTUSE TURN PRINT LISTING ON FOR USER CODE GEN
TESTMOV3 CSECT                SWITCH TO PROCEDURE CODE AHEAD OF WS
*        MAINLINE.
PG_MAINLINE DS 0H
*            DISPLAY 'TESTMOV3 TEST SCALED MOVES'
*ZC     43         DISPLAY 'TESTMOV3 TEST SCALED MOVES'
         BRAS  1,*+(WTO#0177_EOT-*+1)/2*2
         DC    AL2(WTO#0177_EOT-*,0),C'TESTMOV3 TEST SCALED MOVES'
WTO#0177_EOT     EQU *
         SVC   35
*            MOVE EH2 TO EH1 IF EH1 = EH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     44         MOVE  EH2,TO,EH1
         MVC   EH1,EH2  ALIGN LEFT X OTHER
*ZC     44         IF    EH1,=,EH1
         LE    ZC_F0,EH1
         CE    ZC_F0,EH1
         BRC   15-ZC_EQ,PG_IF_1_1
*ZC     44         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     44         ELSE
         J     PG_IF_1_E
PG_IF_1_1    DS    0H  &TYPE
*ZC     44         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_1_E    DS    0H  &TYPE
*            MOVE EH2 TO DH1 IF EH1 = DH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     45         MOVE  EH2,TO,DH1
         LDE   0,EH2
         STD   0,DH1
*ZC     45         IF    EH1,=,DH1
         LDE   ZC_F0,EH1
         CD    ZC_F0,DH1
         BRC   15-ZC_EQ,PG_IF_2_1
*ZC     45         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     45         ELSE
         J     PG_IF_2_E
PG_IF_2_1    DS    0H  &TYPE
*ZC     45         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_2_E    DS    0H  &TYPE
*            MOVE EH2 TO LH1 IF EH1 = LH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     46         MOVE  EH2,TO,LH1
         LE    0,EH2
         LXER  0,0
         STD   0,LH1
         STD   2,8+LH1
*ZC     46         IF    EH1,=,LH1
         LE    ZC_F0,EH1
         LXER  ZC_F0,ZC_F0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_3_1
*ZC     46         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     46         ELSE
         J     PG_IF_3_E
PG_IF_3_1    DS    0H  &TYPE
*ZC     46         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_3_E    DS    0H  &TYPE
*            MOVE EH2 TO EB1 IF EH1 = EB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     47         MOVE  EH2,TO,EB1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         STE   0,EB1
*ZC     47         IF    EH1,=,EB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CEB   ZC_F0,EB1
         BRC   15-ZC_EQ,PG_IF_4_1
*ZC     47         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     47         ELSE
         J     PG_IF_4_E
PG_IF_4_1    DS    0H  &TYPE
*ZC     47         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_4_E    DS    0H  &TYPE
*            MOVE EH2 TO DB1 IF EH1 = DB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     48         MOVE  EH2,TO,DB1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         STD   0,DB1
*ZC     48         IF    EH1,=,DB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CDB   ZC_F0,DB1
         BRC   15-ZC_EQ,PG_IF_5_1
*ZC     48         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     48         ELSE
         J     PG_IF_5_E
PG_IF_5_1    DS    0H  &TYPE
*ZC     48         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_5_E    DS    0H  &TYPE
*            MOVE EH2 TO LB1 IF EH1 = LB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     49         MOVE  EH2,TO,LB1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC     49         IF    EH1,=,LB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_6_1
*ZC     49         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     49         ELSE
         J     PG_IF_6_E
PG_IF_6_1    DS    0H  &TYPE
*ZC     49         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_6_E    DS    0H  &TYPE
*            MOVE EH2 TO ED1 IF EH1 = ED1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     50         MOVE  EH2,TO,ED1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LEDTR ZC_F0,0,ZC_F0,0
         STE   0,ED1
*ZC     50         IF    EH1,=,ED1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_7_1
*ZC     50         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     50         ELSE
         J     PG_IF_7_E
PG_IF_7_1    DS    0H  &TYPE
*ZC     50         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_7_E    DS    0H  &TYPE
*            MOVE EH2 TO DD1 IF EH1 = DD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     51         MOVE  EH2,TO,DD1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         STD   0,DD1
*ZC     51         IF    EH1,=,DD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_8_1
*ZC     51         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     51         ELSE
         J     PG_IF_8_E
PG_IF_8_1    DS    0H  &TYPE
*ZC     51         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_8_E    DS    0H  &TYPE
*            MOVE EH2 TO LD1 IF EH1 = LD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     52         MOVE  EH2,TO,LD1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         STD   0,LD1
         STD   2,8+LD1
*ZC     52         IF    EH1,=,LD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_9_1
*ZC     52         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     52         ELSE
         J     PG_IF_9_E
PG_IF_9_1    DS    0H  &TYPE
*ZC     52         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_9_E    DS    0H  &TYPE
*            MOVE EH2 TO F1  IF EH1 = F1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     53         MOVE  EH2,TO,F1
         LE    0,EH2
         LARL  ZC_R1,=EH'1E1'
         ME    ZC_R0,0(ZC_R1)
         CFER  0,0,0
         ST    0,F1     IGNORE HIGH BITS
*ZC     53         IF    EH1,=,F1
         LE    ZC_F0,EH1
         L     ZC_R1,F1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_10_1
*ZC     53         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     53         ELSE
         J     PG_IF_10_E
PG_IF_10_1   DS    0H  &TYPE
*ZC     53         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_10_E   DS    0H  &TYPE
*            MOVE EH2 TO G1  IF EH1 = G1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     54         MOVE  EH2,TO,G1
         LE    0,EH2
         LARL  ZC_R1,=EH'1E1'
         ME    ZC_R0,0(ZC_R1)
         CGER  0,0,0
         STG   0,G1
*ZC     54         IF    EH1,=,G1
         LE    ZC_F0,EH1
         LG    ZC_R1,G1
         CEGR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_11_1
*ZC     54         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     54         ELSE
         J     PG_IF_11_E
PG_IF_11_1   DS    0H  &TYPE
*ZC     54         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_11_E   DS    0H  &TYPE
*            MOVE EH2 TO H1  IF EH1 = H1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     55         MOVE  EH2,TO,H1
         LE    0,EH2
         LARL  ZC_R1,=EH'1E1'
         ME    ZC_R0,0(ZC_R1)
         CFER  0,0,0
         STH   0,H1
*ZC     55         IF    EH1,=,H1
         LE    ZC_F0,EH1
         LH    ZC_R1,H1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_12_1
*ZC     55         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     55         ELSE
         J     PG_IF_12_E
PG_IF_12_1   DS    0H  &TYPE
*ZC     55         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_12_E   DS    0H  &TYPE
*            MOVE EH2 TO P1  IF EH1 = P1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     56         MOVE  EH2,TO,P1
         LE    0,EH2
         LARL  ZC_R1,=EH'1E1'
         ME    ZC_R0,0(ZC_R1)
         CFER  0,0,0
         CVD   0,ZCVT_PWORK
         ZAP   P1,ZCVT_PWORK
*ZC     56         IF    EH1,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_13_1
*ZC     56         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     56         ELSE
         J     PG_IF_13_E
PG_IF_13_1   DS    0H  &TYPE
*ZC     56         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_13_E   DS    0H  &TYPE
*            MOVE EH2 TO Q1  IF EH1 = Q1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     57         MOVE  EH2,TO,Q1
         LE    ZC_F4,EH2
         LARL  ZC_R1,=EH'1E1'
         ME    ZC_F4,0(ZC_R1)
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,Q1
*ZC     57         IF    EH1,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_14_1
*ZC     57         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     57         ELSE
         J     PG_IF_14_E
PG_IF_14_1   DS    0H  &TYPE
*ZC     57         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_14_E   DS    0H  &TYPE
*            MOVE EH2 TO Z1  IF EH1 = Z1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     58         MOVE  EH2,TO,Z1
         LE    0,EH2
         LARL  ZC_R1,=EH'1E1'
         ME    ZC_F0,0(ZC_R1)
         CFER  0,0,0
         CVD   0,ZCVT_PWORK
         MVI   Z1,C'0'
         MVC    1+Z1(15),Z1
         UNPK  16+Z1(15),0+ZCVT_PWORK(8) UNPK #1 NORMAL
*ZC     58         IF    EH1,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_15_1
*ZC     58         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     58         ELSE
         J     PG_IF_15_E
PG_IF_15_1   DS    0H  &TYPE
*ZC     58         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_15_E   DS    0H  &TYPE
*            MOVE DH2 TO EH1 IF EH1 = EH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     59         MOVE  DH2,TO,EH1
         LD    0,DH2
         LEDR  0,0
         STE   0,EH1
*ZC     59         IF    EH1,=,EH1
         LE    ZC_F0,EH1
         CE    ZC_F0,EH1
         BRC   15-ZC_EQ,PG_IF_16_1
*ZC     59         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     59         ELSE
         J     PG_IF_16_E
PG_IF_16_1   DS    0H  &TYPE
*ZC     59         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_16_E   DS    0H  &TYPE
*            MOVE DH2 TO DH1 IF EH1 = DH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     60         MOVE  DH2,TO,DH1
         MVC   DH1,DH2  ALIGN LEFT X OTHER
*ZC     60         IF    EH1,=,DH1
         LDE   ZC_F0,EH1
         CD    ZC_F0,DH1
         BRC   15-ZC_EQ,PG_IF_17_1
*ZC     60         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     60         ELSE
         J     PG_IF_17_E
PG_IF_17_1   DS    0H  &TYPE
*ZC     60         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_17_E   DS    0H  &TYPE
*            MOVE DH2 TO LH1 IF EH1 = LH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     61         MOVE  DH2,TO,LH1
         LD    0,DH2
         LXDR  0,0
         STD   0,LH1
         STD   2,8+LH1
*ZC     61         IF    EH1,=,LH1
         LE    ZC_F0,EH1
         LXER  ZC_F0,ZC_F0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_18_1
*ZC     61         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     61         ELSE
         J     PG_IF_18_E
PG_IF_18_1   DS    0H  &TYPE
*ZC     61         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_18_E   DS    0H  &TYPE
*            MOVE DH2 TO EB1 IF EH1 = EB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     62         MOVE  DH2,TO,EB1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         STE   0,EB1
*ZC     62         IF    EH1,=,EB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CEB   ZC_F0,EB1
         BRC   15-ZC_EQ,PG_IF_19_1
*ZC     62         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     62         ELSE
         J     PG_IF_19_E
PG_IF_19_1   DS    0H  &TYPE
*ZC     62         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_19_E   DS    0H  &TYPE
*            MOVE DH2 TO DB1 IF EH1 = DB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     63         MOVE  DH2,TO,DB1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         STD   0,DB1
*ZC     63         IF    EH1,=,DB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CDB   ZC_F0,DB1
         BRC   15-ZC_EQ,PG_IF_20_1
*ZC     63         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     63         ELSE
         J     PG_IF_20_E
PG_IF_20_1   DS    0H  &TYPE
*ZC     63         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_20_E   DS    0H  &TYPE
*            MOVE DH2 TO LB1 IF EH1 = LB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     64         MOVE  DH2,TO,LB1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC     64         IF    EH1,=,LB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_21_1
*ZC     64         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     64         ELSE
         J     PG_IF_21_E
PG_IF_21_1   DS    0H  &TYPE
*ZC     64         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_21_E   DS    0H  &TYPE
*            MOVE DH2 TO ED1 IF EH1 = ED1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     65         MOVE  DH2,TO,ED1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LEDTR ZC_F0,0,ZC_F0,0
         STE   0,ED1
*ZC     65         IF    EH1,=,ED1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_22_1
*ZC     65         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     65         ELSE
         J     PG_IF_22_E
PG_IF_22_1   DS    0H  &TYPE
*ZC     65         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_22_E   DS    0H  &TYPE
*            MOVE DH2 TO DD1 IF EH1 = DD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     66         MOVE  DH2,TO,DD1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         STD   0,DD1
*ZC     66         IF    EH1,=,DD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_23_1
*ZC     66         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     66         ELSE
         J     PG_IF_23_E
PG_IF_23_1   DS    0H  &TYPE
*ZC     66         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_23_E   DS    0H  &TYPE
*            MOVE DH2 TO LD1 IF EH1 = LD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     67         MOVE  DH2,TO,LD1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         STD   0,LD1
         STD   2,8+LD1
*ZC     67         IF    EH1,=,LD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_24_1
*ZC     67         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     67         ELSE
         J     PG_IF_24_E
PG_IF_24_1   DS    0H  &TYPE
*ZC     67         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_24_E   DS    0H  &TYPE
*            MOVE DH2 TO F1  IF EH1 = F1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     68         MOVE  DH2,TO,F1
         LD    0,DH2
         LARL  ZC_R1,=DH'1E1'
         MD    ZC_R0,0(ZC_R1)
         CFDR  0,0,0
         ST    0,F1     IGNORE HIGH BITS
*ZC     68         IF    EH1,=,F1
         LE    ZC_F0,EH1
         L     ZC_R1,F1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_25_1
*ZC     68         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     68         ELSE
         J     PG_IF_25_E
PG_IF_25_1   DS    0H  &TYPE
*ZC     68         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_25_E   DS    0H  &TYPE
*            MOVE DH2 TO G1  IF EH1 = G1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     69         MOVE  DH2,TO,G1
         LD    0,DH2
         LARL  ZC_R1,=DH'1E1'
         MD    ZC_R0,0(ZC_R1)
         CGDR  0,0,0
         STG   0,G1
*ZC     69         IF    EH1,=,G1
         LE    ZC_F0,EH1
         LG    ZC_R1,G1
         CEGR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_26_1
*ZC     69         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     69         ELSE
         J     PG_IF_26_E
PG_IF_26_1   DS    0H  &TYPE
*ZC     69         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_26_E   DS    0H  &TYPE
*            MOVE DH2 TO H1  IF EH1 = H1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     70         MOVE  DH2,TO,H1
         LD    0,DH2
         LARL  ZC_R1,=DH'1E1'
         MD    ZC_R0,0(ZC_R1)
         CFDR  0,0,0
         STH   0,H1
*ZC     70         IF    EH1,=,H1
         LE    ZC_F0,EH1
         LH    ZC_R1,H1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_27_1
*ZC     70         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     70         ELSE
         J     PG_IF_27_E
PG_IF_27_1   DS    0H  &TYPE
*ZC     70         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_27_E   DS    0H  &TYPE
*            MOVE DH2 TO P1  IF EH1 = P1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     71         MOVE  DH2,TO,P1
         LD    0,DH2
         LARL  ZC_R1,=DH'1E1'
         MD    ZC_R0,0(ZC_R1)
         CGDR  0,0,0
         CVDG  0,ZCVT_PWORK2
         ZAP   P1,ZCVT_PWORK2
*ZC     71         IF    EH1,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_28_1
*ZC     71         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     71         ELSE
         J     PG_IF_28_E
PG_IF_28_1   DS    0H  &TYPE
*ZC     71         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_28_E   DS    0H  &TYPE
*            MOVE DH2 TO Q1  IF EH1 = Q1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     72         MOVE  DH2,TO,Q1
         LD    ZC_F4,DH2
         LARL  ZC_R1,=DH'1E1'
         MD    ZC_F4,0(ZC_R1)
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,Q1
*ZC     72         IF    EH1,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_29_1
*ZC     72         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     72         ELSE
         J     PG_IF_29_E
PG_IF_29_1   DS    0H  &TYPE
*ZC     72         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_29_E   DS    0H  &TYPE
*            MOVE DH2 TO Z1  IF EH1 = Z1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     73         MOVE  DH2,TO,Z1
         LD    0,DH2
         LARL  ZC_R1,=DH'1E1'
         MD    ZC_F0,0(ZC_R1)
         CGDR  0,0,0
         CVDG  0,ZCVT_PWORK2
         UNPK  0+Z1(15),0+ZCVT_PWORK2(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK2(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK2(2) UNPK #3 FINAL
*ZC     73         IF    EH1,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_30_1
*ZC     73         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     73         ELSE
         J     PG_IF_30_E
PG_IF_30_1   DS    0H  &TYPE
*ZC     73         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_30_E   DS    0H  &TYPE
*            MOVE LH2 TO EH1 IF EH1 = EH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     74         MOVE  LH2,TO,EH1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         STE   0,EH1
*ZC     74         IF    EH1,=,EH1
         LE    ZC_F0,EH1
         CE    ZC_F0,EH1
         BRC   15-ZC_EQ,PG_IF_31_1
*ZC     74         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     74         ELSE
         J     PG_IF_31_E
PG_IF_31_1   DS    0H  &TYPE
*ZC     74         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_31_E   DS    0H  &TYPE
*            MOVE LH2 TO DH1 IF EH1 = DH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     75         MOVE  LH2,TO,DH1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         STD   0,DH1
*ZC     75         IF    EH1,=,DH1
         LDE   ZC_F0,EH1
         CD    ZC_F0,DH1
         BRC   15-ZC_EQ,PG_IF_32_1
*ZC     75         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     75         ELSE
         J     PG_IF_32_E
PG_IF_32_1   DS    0H  &TYPE
*ZC     75         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_32_E   DS    0H  &TYPE
*            MOVE LH2 TO LH1 IF EH1 = LH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     76         MOVE  LH2,TO,LH1
         MVC   LH1,LH2  ALIGN LEFT X OTHER
*ZC     76         IF    EH1,=,LH1
         LE    ZC_F0,EH1
         LXER  ZC_F0,ZC_F0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_33_1
*ZC     76         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     76         ELSE
         J     PG_IF_33_E
PG_IF_33_1   DS    0H  &TYPE
*ZC     76         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_33_E   DS    0H  &TYPE
*            MOVE LH2 TO EB1 IF EH1 = EB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     77         MOVE  LH2,TO,EB1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         STE   0,EB1
*ZC     77         IF    EH1,=,EB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CEB   ZC_F0,EB1
         BRC   15-ZC_EQ,PG_IF_34_1
*ZC     77         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     77         ELSE
         J     PG_IF_34_E
PG_IF_34_1   DS    0H  &TYPE
*ZC     77         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_34_E   DS    0H  &TYPE
*            MOVE LH2 TO DB1 IF EH1 = DB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     78         MOVE  LH2,TO,DB1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         STD   0,DB1
*ZC     78         IF    EH1,=,DB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CDB   ZC_F0,DB1
         BRC   15-ZC_EQ,PG_IF_35_1
*ZC     78         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     78         ELSE
         J     PG_IF_35_E
PG_IF_35_1   DS    0H  &TYPE
*ZC     78         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_35_E   DS    0H  &TYPE
*            MOVE LH2 TO LB1 IF EH1 = LB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     79         MOVE  LH2,TO,LB1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC     79         IF    EH1,=,LB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_36_1
*ZC     79         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     79         ELSE
         J     PG_IF_36_E
PG_IF_36_1   DS    0H  &TYPE
*ZC     79         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_36_E   DS    0H  &TYPE
*            MOVE LH2 TO ED1 IF EH1 = ED1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     80         MOVE  LH2,TO,ED1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LEDTR ZC_F0,0,ZC_F0,0
         STE   0,ED1
*ZC     80         IF    EH1,=,ED1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_37_1
*ZC     80         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     80         ELSE
         J     PG_IF_37_E
PG_IF_37_1   DS    0H  &TYPE
*ZC     80         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_37_E   DS    0H  &TYPE
*            MOVE LH2 TO DD1 IF EH1 = DD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     81         MOVE  LH2,TO,DD1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         STD   0,DD1
*ZC     81         IF    EH1,=,DD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_38_1
*ZC     81         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     81         ELSE
         J     PG_IF_38_E
PG_IF_38_1   DS    0H  &TYPE
*ZC     81         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_38_E   DS    0H  &TYPE
*            MOVE LH2 TO LD1 IF EH1 = LD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     82         MOVE  LH2,TO,LD1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         STD   0,LD1
         STD   2,8+LD1
*ZC     82         IF    EH1,=,LD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_39_1
*ZC     82         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     82         ELSE
         J     PG_IF_39_E
PG_IF_39_1   DS    0H  &TYPE
*ZC     82         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_39_E   DS    0H  &TYPE
*            MOVE LH2 TO F1  IF EH1 = F1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     83         MOVE  LH2,TO,F1
         LD    ZC_F4,LH2
         LD    ZC_R6,8+LH2
         LARL  ZC_R1,=LH'1E1'
         LD    ZC_R3,8(ZC_R1)
         LD    ZC_R1,0(ZC_R1)
         MXR   ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    0,1  IGNORE HIGH 96 BITS
         ST    0,F1     IGNORE HIGH BITS
*ZC     83         IF    EH1,=,F1
         LE    ZC_F0,EH1
         L     ZC_R1,F1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_40_1
*ZC     83         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     83         ELSE
         J     PG_IF_40_E
PG_IF_40_1   DS    0H  &TYPE
*ZC     83         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_40_E   DS    0H  &TYPE
*            MOVE LH2 TO G1  IF EH1 = G1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     84         MOVE  LH2,TO,G1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LARL  ZC_R1,=LH'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXR   ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   0,1  IGNORE HIGH 64 BITS
         STG   0,G1
*ZC     84         IF    EH1,=,G1
         LE    ZC_F0,EH1
         LG    ZC_R1,G1
         CEGR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_41_1
*ZC     84         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     84         ELSE
         J     PG_IF_41_E
PG_IF_41_1   DS    0H  &TYPE
*ZC     84         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_41_E   DS    0H  &TYPE
*            MOVE LH2 TO H1  IF EH1 = H1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     85         MOVE  LH2,TO,H1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LARL  ZC_R1,=LH'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXR   ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    0,1  IGNORE HIGH 112 BITS
         STH   0,H1
*ZC     85         IF    EH1,=,H1
         LE    ZC_F0,EH1
         LH    ZC_R1,H1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_42_1
*ZC     85         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     85         ELSE
         J     PG_IF_42_E
PG_IF_42_1   DS    0H  &TYPE
*ZC     85         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_42_E   DS    0H  &TYPE
*            MOVE LH2 TO P1  IF EH1 = P1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     86         MOVE  LH2,TO,P1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LARL  ZC_R1,=LH'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXR   ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         ZAP   P1,ZCVT_PWORK2
*ZC     86         IF    EH1,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_43_1
*ZC     86         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     86         ELSE
         J     PG_IF_43_E
PG_IF_43_1   DS    0H  &TYPE
*ZC     86         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_43_E   DS    0H  &TYPE
*            MOVE LH2 TO Q1  IF EH1 = Q1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     87         MOVE  LH2,TO,Q1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LARL  ZC_R1,=LH'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXR   ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,Q1
*ZC     87         IF    EH1,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_44_1
*ZC     87         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     87         ELSE
         J     PG_IF_44_E
PG_IF_44_1   DS    0H  &TYPE
*ZC     87         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_44_E   DS    0H  &TYPE
*            MOVE LH2 TO Z1  IF EH1 = Z1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     88         MOVE  LH2,TO,Z1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LARL  ZC_R1,=LH'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXR   ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         UNPK  0+Z1(15),0+ZCVT_PWORK2(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK2(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK2(2) UNPK #3 FINAL
*ZC     88         IF    EH1,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_45_1
*ZC     88         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     88         ELSE
         J     PG_IF_45_E
PG_IF_45_1   DS    0H  &TYPE
*ZC     88         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_45_E   DS    0H  &TYPE
*            MOVE EB2 TO EH1 IF EH1 = EH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     89         MOVE  EB2,TO,EH1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         STE   0,EH1
*ZC     89         IF    EH1,=,EH1
         LE    ZC_F0,EH1
         CE    ZC_F0,EH1
         BRC   15-ZC_EQ,PG_IF_46_1
*ZC     89         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     89         ELSE
         J     PG_IF_46_E
PG_IF_46_1   DS    0H  &TYPE
*ZC     89         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_46_E   DS    0H  &TYPE
*            MOVE EB2 TO DH1 IF EH1 = DH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     90         MOVE  EB2,TO,DH1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         STD   0,DH1
*ZC     90         IF    EH1,=,DH1
         LDE   ZC_F0,EH1
         CD    ZC_F0,DH1
         BRC   15-ZC_EQ,PG_IF_47_1
*ZC     90         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     90         ELSE
         J     PG_IF_47_E
PG_IF_47_1   DS    0H  &TYPE
*ZC     90         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_47_E   DS    0H  &TYPE
*            MOVE EB2 TO LH1 IF EH1 = LH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     91         MOVE  EB2,TO,LH1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         STD   0,LH1
         STD   2,8+LH1
*ZC     91         IF    EH1,=,LH1
         LE    ZC_F0,EH1
         LXER  ZC_F0,ZC_F0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_48_1
*ZC     91         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     91         ELSE
         J     PG_IF_48_E
PG_IF_48_1   DS    0H  &TYPE
*ZC     91         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_48_E   DS    0H  &TYPE
*            MOVE EB2 TO EB1 IF EH1 = EB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     92         MOVE  EB2,TO,EB1
         MVC   EB1,EB2  ALIGN LEFT X OTHER
*ZC     92         IF    EH1,=,EB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CEB   ZC_F0,EB1
         BRC   15-ZC_EQ,PG_IF_49_1
*ZC     92         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     92         ELSE
         J     PG_IF_49_E
PG_IF_49_1   DS    0H  &TYPE
*ZC     92         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_49_E   DS    0H  &TYPE
*            MOVE EB2 TO DB1 IF EH1 = DB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     93         MOVE  EB2,TO,DB1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         STD   0,DB1
*ZC     93         IF    EH1,=,DB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CDB   ZC_F0,DB1
         BRC   15-ZC_EQ,PG_IF_50_1
*ZC     93         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     93         ELSE
         J     PG_IF_50_E
PG_IF_50_1   DS    0H  &TYPE
*ZC     93         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_50_E   DS    0H  &TYPE
*            MOVE EB2 TO LB1 IF EH1 = LB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     94         MOVE  EB2,TO,LB1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC     94         IF    EH1,=,LB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_51_1
*ZC     94         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     94         ELSE
         J     PG_IF_51_E
PG_IF_51_1   DS    0H  &TYPE
*ZC     94         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_51_E   DS    0H  &TYPE
*            MOVE EB2 TO ED1 IF EH1 = ED1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     95         MOVE  EB2,TO,ED1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LEDTR ZC_F0,0,ZC_F0,0
         STE   0,ED1
*ZC     95         IF    EH1,=,ED1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_52_1
*ZC     95         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     95         ELSE
         J     PG_IF_52_E
PG_IF_52_1   DS    0H  &TYPE
*ZC     95         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_52_E   DS    0H  &TYPE
*            MOVE EB2 TO DD1 IF EH1 = DD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     96         MOVE  EB2,TO,DD1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         STD   0,DD1
*ZC     96         IF    EH1,=,DD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_53_1
*ZC     96         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     96         ELSE
         J     PG_IF_53_E
PG_IF_53_1   DS    0H  &TYPE
*ZC     96         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_53_E   DS    0H  &TYPE
*            MOVE EB2 TO LD1 IF EH1 = LD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     97         MOVE  EB2,TO,LD1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         STD   0,LD1
         STD   2,8+LD1
*ZC     97         IF    EH1,=,LD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_54_1
*ZC     97         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     97         ELSE
         J     PG_IF_54_E
PG_IF_54_1   DS    0H  &TYPE
*ZC     97         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_54_E   DS    0H  &TYPE
*            MOVE EB2 TO F1  IF EH1 = F1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     98         MOVE  EB2,TO,F1
         LE    ZC_F4,EB2
         LDEBR ZC_F4,ZC_F4
         LARL  ZC_R1,=DB'1E1'
         MDB   ZC_R4,0(ZC_R1)
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    0,1  IGNORE HIGH BITS
         ST    0,F1     IGNORE HIGH BITS
*ZC     98         IF    EH1,=,F1
         LE    ZC_F0,EH1
         L     ZC_R1,F1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_55_1
*ZC     98         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     98         ELSE
         J     PG_IF_55_E
PG_IF_55_1   DS    0H  &TYPE
*ZC     98         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_55_E   DS    0H  &TYPE
*            MOVE EB2 TO G1  IF EH1 = G1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC     99         MOVE  EB2,TO,G1
         LE    ZC_F4,EB2
         LDEBR ZC_F4,ZC_F4
         LARL  ZC_R1,=DB'1E1'
         MDB   ZC_R4,0(ZC_R1)
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   0,1  IGNORE HIGH 64 BITS
         STG   0,G1
*ZC     99         IF    EH1,=,G1
         LE    ZC_F0,EH1
         LG    ZC_R1,G1
         CEGR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_56_1
*ZC     99         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     99         ELSE
         J     PG_IF_56_E
PG_IF_56_1   DS    0H  &TYPE
*ZC     99         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_56_E   DS    0H  &TYPE
*            MOVE EB2 TO H1  IF EH1 = H1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    100         MOVE  EB2,TO,H1
         LE    4,EB2
         LDEBR ZC_F4,ZC_F4
         LARL  ZC_R1,=DB'1E1'
         MDB   ZC_F4,0(ZC_R1)
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    0,1  IGNORE HIGH BITS
         STH   0,H1
*ZC    100         IF    EH1,=,H1
         LE    ZC_F0,EH1
         LH    ZC_R1,H1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_57_1
*ZC    100         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    100         ELSE
         J     PG_IF_57_E
PG_IF_57_1   DS    0H  &TYPE
*ZC    100         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_57_E   DS    0H  &TYPE
*            MOVE EB2 TO P1  IF EH1 = P1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    101         MOVE  EB2,TO,P1
         LE    ZC_F4,EB2
         LDEBR ZC_F4,ZC_F4
         LARL  ZC_R1,=DB'1E1'
         MDB   ZC_F4,0(ZC_R1)
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         ZAP   P1,ZCVT_PWORK2
*ZC    101         IF    EH1,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_58_1
*ZC    101         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    101         ELSE
         J     PG_IF_58_E
PG_IF_58_1   DS    0H  &TYPE
*ZC    101         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_58_E   DS    0H  &TYPE
*            MOVE EB2 TO Q1  IF EH1 = Q1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    102         MOVE  EB2,TO,Q1
         LE    ZC_F4,EB2
         LDEBR ZC_F4,ZC_F4
         LARL  ZC_R1,=DB'1E1'
         MDB   ZC_F4,0(ZC_R1)
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,Q1
*ZC    102         IF    EH1,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_59_1
*ZC    102         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    102         ELSE
         J     PG_IF_59_E
PG_IF_59_1   DS    0H  &TYPE
*ZC    102         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_59_E   DS    0H  &TYPE
*            MOVE EB2 TO Z1  IF EH1 = Z1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    103         MOVE  EB2,TO,Z1
         LE    ZC_F4,EB2
         LDEBR ZC_F4,ZC_F4
         LARL  ZC_R1,=DB'1E1'
         MDB   ZC_F4,0(ZC_F1)
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         UNPK  0+Z1(15),0+ZCVT_PWORK2(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK2(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK2(2) UNPK #3 FINAL
*ZC    103         IF    EH1,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_60_1
*ZC    103         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    103         ELSE
         J     PG_IF_60_E
PG_IF_60_1   DS    0H  &TYPE
*ZC    103         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_60_E   DS    0H  &TYPE
*            MOVE DB2 TO EH1 IF EH1 = EH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    104         MOVE  DB2,TO,EH1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         STE   0,EH1
*ZC    104         IF    EH1,=,EH1
         LE    ZC_F0,EH1
         CE    ZC_F0,EH1
         BRC   15-ZC_EQ,PG_IF_61_1
*ZC    104         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    104         ELSE
         J     PG_IF_61_E
PG_IF_61_1   DS    0H  &TYPE
*ZC    104         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_61_E   DS    0H  &TYPE
*            MOVE DB2 TO DH1 IF EH1 = DH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    105         MOVE  DB2,TO,DH1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         STD   0,DH1
*ZC    105         IF    EH1,=,DH1
         LDE   ZC_F0,EH1
         CD    ZC_F0,DH1
         BRC   15-ZC_EQ,PG_IF_62_1
*ZC    105         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    105         ELSE
         J     PG_IF_62_E
PG_IF_62_1   DS    0H  &TYPE
*ZC    105         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_62_E   DS    0H  &TYPE
*            MOVE DB2 TO LH1 IF EH1 = LH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    106         MOVE  DB2,TO,LH1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         STD   0,LH1
         STD   2,8+LH1
*ZC    106         IF    EH1,=,LH1
         LE    ZC_F0,EH1
         LXER  ZC_F0,ZC_F0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_63_1
*ZC    106         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    106         ELSE
         J     PG_IF_63_E
PG_IF_63_1   DS    0H  &TYPE
*ZC    106         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_63_E   DS    0H  &TYPE
*            MOVE DB2 TO EB1 IF EH1 = EB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    107         MOVE  DB2,TO,EB1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         STE   0,EB1
*ZC    107         IF    EH1,=,EB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CEB   ZC_F0,EB1
         BRC   15-ZC_EQ,PG_IF_64_1
*ZC    107         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    107         ELSE
         J     PG_IF_64_E
PG_IF_64_1   DS    0H  &TYPE
*ZC    107         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_64_E   DS    0H  &TYPE
*            MOVE DB2 TO DB1 IF EH1 = DB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    108         MOVE  DB2,TO,DB1
         MVC   DB1,DB2  ALIGN LEFT X OTHER
*ZC    108         IF    EH1,=,DB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CDB   ZC_F0,DB1
         BRC   15-ZC_EQ,PG_IF_65_1
*ZC    108         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    108         ELSE
         J     PG_IF_65_E
PG_IF_65_1   DS    0H  &TYPE
*ZC    108         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_65_E   DS    0H  &TYPE
*            MOVE DB2 TO LB1 IF EH1 = LB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    109         MOVE  DB2,TO,LB1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC    109         IF    EH1,=,LB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_66_1
*ZC    109         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    109         ELSE
         J     PG_IF_66_E
PG_IF_66_1   DS    0H  &TYPE
*ZC    109         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_66_E   DS    0H  &TYPE
*            MOVE DB2 TO ED1 IF EH1 = ED1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    110         MOVE  DB2,TO,ED1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LEDTR ZC_F0,0,ZC_F0,0
         STE   0,ED1
*ZC    110         IF    EH1,=,ED1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_67_1
*ZC    110         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    110         ELSE
         J     PG_IF_67_E
PG_IF_67_1   DS    0H  &TYPE
*ZC    110         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_67_E   DS    0H  &TYPE
*            MOVE DB2 TO DD1 IF EH1 = DD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    111         MOVE  DB2,TO,DD1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         STD   0,DD1
*ZC    111         IF    EH1,=,DD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_68_1
*ZC    111         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    111         ELSE
         J     PG_IF_68_E
PG_IF_68_1   DS    0H  &TYPE
*ZC    111         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_68_E   DS    0H  &TYPE
*            MOVE DB2 TO LD1 IF EH1 = LD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    112         MOVE  DB2,TO,LD1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         STD   0,LD1
         STD   2,8+LD1
*ZC    112         IF    EH1,=,LD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_69_1
*ZC    112         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    112         ELSE
         J     PG_IF_69_E
PG_IF_69_1   DS    0H  &TYPE
*ZC    112         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_69_E   DS    0H  &TYPE
*            MOVE DB2 TO F1  IF EH1 = F1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    113         MOVE  DB2,TO,F1
         LD    ZC_F4,DB2
         LARL  ZC_R1,=DB'1E1'
         MDB   ZC_R4,0(ZC_R1)
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    0,1  IGNORE HIGH 96 BITS
         ST    0,F1     IGNORE HIGH BITS
*ZC    113         IF    EH1,=,F1
         LE    ZC_F0,EH1
         L     ZC_R1,F1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_70_1
*ZC    113         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    113         ELSE
         J     PG_IF_70_E
PG_IF_70_1   DS    0H  &TYPE
*ZC    113         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_70_E   DS    0H  &TYPE
*            MOVE DB2 TO G1  IF EH1 = G1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    114         MOVE  DB2,TO,G1
         LD    ZC_F4,DB2
         LARL  ZC_R1,=DB'1E1'
         MDB   ZC_R4,0(ZC_R1)
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   0,1  IGNORE HIGH 64 BITS
         STG   0,G1
*ZC    114         IF    EH1,=,G1
         LE    ZC_F0,EH1
         LG    ZC_R1,G1
         CEGR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_71_1
*ZC    114         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    114         ELSE
         J     PG_IF_71_E
PG_IF_71_1   DS    0H  &TYPE
*ZC    114         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_71_E   DS    0H  &TYPE
*            MOVE DB2 TO H1  IF EH1 = H1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    115         MOVE  DB2,TO,H1
         LD    4,DB2
         LARL  ZC_R1,=DB'1E1'
         MDB   ZC_F4,0(ZC_R1)
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    0,1  IGNORE HIGH 96 BITS
         STH   0,H1
*ZC    115         IF    EH1,=,H1
         LE    ZC_F0,EH1
         LH    ZC_R1,H1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_72_1
*ZC    115         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    115         ELSE
         J     PG_IF_72_E
PG_IF_72_1   DS    0H  &TYPE
*ZC    115         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_72_E   DS    0H  &TYPE
*            MOVE DB2 TO P1  IF EH1 = P1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    116         MOVE  DB2,TO,P1
         LD    ZC_F4,DB2
         LARL  ZC_R1,=DB'1E1'
         MDB   ZC_F4,0(ZC_R1)
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         ZAP   P1,ZCVT_PWORK2
*ZC    116         IF    EH1,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_73_1
*ZC    116         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    116         ELSE
         J     PG_IF_73_E
PG_IF_73_1   DS    0H  &TYPE
*ZC    116         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_73_E   DS    0H  &TYPE
*            MOVE DB2 TO Q1  IF EH1 = Q1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    117         MOVE  DB2,TO,Q1
         LD    ZC_F4,DB2
         LARL  ZC_R1,=DB'1E1'
         MDB   ZC_F4,0(ZC_R1)
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,Q1
*ZC    117         IF    EH1,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_74_1
*ZC    117         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    117         ELSE
         J     PG_IF_74_E
PG_IF_74_1   DS    0H  &TYPE
*ZC    117         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_74_E   DS    0H  &TYPE
*            MOVE DB2 TO Z1  IF EH1 = Z1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    118         MOVE  DB2,TO,Z1
         LD    ZC_F4,DB2
         LARL  ZC_R1,=DB'1E1'
         MDB   ZC_F4,0(ZC_F1)
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         UNPK  0+Z1(15),0+ZCVT_PWORK2(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK2(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK2(2) UNPK #3 FINAL
*ZC    118         IF    EH1,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_75_1
*ZC    118         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    118         ELSE
         J     PG_IF_75_E
PG_IF_75_1   DS    0H  &TYPE
*ZC    118         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_75_E   DS    0H  &TYPE
*            MOVE LB2 TO EH1 IF EH1 = EH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    119         MOVE  LB2,TO,EH1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         STE   0,EH1
*ZC    119         IF    EH1,=,EH1
         LE    ZC_F0,EH1
         CE    ZC_F0,EH1
         BRC   15-ZC_EQ,PG_IF_76_1
*ZC    119         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    119         ELSE
         J     PG_IF_76_E
PG_IF_76_1   DS    0H  &TYPE
*ZC    119         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_76_E   DS    0H  &TYPE
*            MOVE LB2 TO DH1 IF EH1 = DH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    120         MOVE  LB2,TO,DH1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         STD   0,DH1
*ZC    120         IF    EH1,=,DH1
         LDE   ZC_F0,EH1
         CD    ZC_F0,DH1
         BRC   15-ZC_EQ,PG_IF_77_1
*ZC    120         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    120         ELSE
         J     PG_IF_77_E
PG_IF_77_1   DS    0H  &TYPE
*ZC    120         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_77_E   DS    0H  &TYPE
*            MOVE LB2 TO LH1 IF EH1 = LH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    121         MOVE  LB2,TO,LH1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         STD   0,LH1
         STD   2,8+LH1
*ZC    121         IF    EH1,=,LH1
         LE    ZC_F0,EH1
         LXER  ZC_F0,ZC_F0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_78_1
*ZC    121         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    121         ELSE
         J     PG_IF_78_E
PG_IF_78_1   DS    0H  &TYPE
*ZC    121         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_78_E   DS    0H  &TYPE
*            MOVE LB2 TO EB1 IF EH1 = EB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    122         MOVE  LB2,TO,EB1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         STE   0,EB1
*ZC    122         IF    EH1,=,EB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CEB   ZC_F0,EB1
         BRC   15-ZC_EQ,PG_IF_79_1
*ZC    122         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    122         ELSE
         J     PG_IF_79_E
PG_IF_79_1   DS    0H  &TYPE
*ZC    122         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_79_E   DS    0H  &TYPE
*            MOVE LB2 TO DB1 IF EH1 = DB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    123         MOVE  LB2,TO,DB1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         STD   0,DB1
*ZC    123         IF    EH1,=,DB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CDB   ZC_F0,DB1
         BRC   15-ZC_EQ,PG_IF_80_1
*ZC    123         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    123         ELSE
         J     PG_IF_80_E
PG_IF_80_1   DS    0H  &TYPE
*ZC    123         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_80_E   DS    0H  &TYPE
*            MOVE LB2 TO LB1 IF EH1 = LB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    124         MOVE  LB2,TO,LB1
         MVC   LB1,LB2  ALIGN LEFT X OTHER
*ZC    124         IF    EH1,=,LB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_81_1
*ZC    124         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    124         ELSE
         J     PG_IF_81_E
PG_IF_81_1   DS    0H  &TYPE
*ZC    124         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_81_E   DS    0H  &TYPE
*            MOVE LB2 TO ED1 IF EH1 = ED1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    125         MOVE  LB2,TO,ED1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LEDTR ZC_F0,0,ZC_F0,0
         STE   0,ED1
*ZC    125         IF    EH1,=,ED1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_82_1
*ZC    125         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    125         ELSE
         J     PG_IF_82_E
PG_IF_82_1   DS    0H  &TYPE
*ZC    125         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_82_E   DS    0H  &TYPE
*            MOVE LB2 TO DD1 IF EH1 = DD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    126         MOVE  LB2,TO,DD1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         STD   0,DD1
*ZC    126         IF    EH1,=,DD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_83_1
*ZC    126         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    126         ELSE
         J     PG_IF_83_E
PG_IF_83_1   DS    0H  &TYPE
*ZC    126         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_83_E   DS    0H  &TYPE
*            MOVE LB2 TO LD1 IF EH1 = LD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    127         MOVE  LB2,TO,LD1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         STD   0,LD1
         STD   2,8+LD1
*ZC    127         IF    EH1,=,LD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_84_1
*ZC    127         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    127         ELSE
         J     PG_IF_84_E
PG_IF_84_1   DS    0H  &TYPE
*ZC    127         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_84_E   DS    0H  &TYPE
*            MOVE LB2 TO F1  IF EH1 = F1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    128         MOVE  LB2,TO,F1
         LD    ZC_F4,LB2
         LD    ZC_R6,8+LB2
         LARL  ZC_R1,=LB'1E1'
         LD    ZC_R3,8(ZC_R1)
         LD    ZC_R1,0(ZC_R1)
         MXBR  ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    0,1  IGNORE HIGH 96 BITS
         ST    0,F1     IGNORE HIGH BITS
*ZC    128         IF    EH1,=,F1
         LE    ZC_F0,EH1
         L     ZC_R1,F1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_85_1
*ZC    128         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    128         ELSE
         J     PG_IF_85_E
PG_IF_85_1   DS    0H  &TYPE
*ZC    128         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_85_E   DS    0H  &TYPE
*            MOVE LB2 TO G1  IF EH1 = G1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    129         MOVE  LB2,TO,G1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LARL  ZC_R1,=LB'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXBR   ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   0,1  IGNORE HIGH 64 BITS
         STG   0,G1
*ZC    129         IF    EH1,=,G1
         LE    ZC_F0,EH1
         LG    ZC_R1,G1
         CEGR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_86_1
*ZC    129         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    129         ELSE
         J     PG_IF_86_E
PG_IF_86_1   DS    0H  &TYPE
*ZC    129         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_86_E   DS    0H  &TYPE
*            MOVE LB2 TO H1  IF EH1 = H1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    130         MOVE  LB2,TO,H1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LARL  ZC_R1,=LB'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXBR  ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    0,1  IGNORE HIGH 96 BITS
         STH   0,H1
*ZC    130         IF    EH1,=,H1
         LE    ZC_F0,EH1
         LH    ZC_R1,H1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_87_1
*ZC    130         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    130         ELSE
         J     PG_IF_87_E
PG_IF_87_1   DS    0H  &TYPE
*ZC    130         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_87_E   DS    0H  &TYPE
*            MOVE LB2 TO P1  IF EH1 = P1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    131         MOVE  LB2,TO,P1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LARL  ZC_R1,=LB'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXBR  ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         ZAP   P1,ZCVT_PWORK2
*ZC    131         IF    EH1,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_88_1
*ZC    131         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    131         ELSE
         J     PG_IF_88_E
PG_IF_88_1   DS    0H  &TYPE
*ZC    131         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_88_E   DS    0H  &TYPE
*            MOVE LB2 TO Q1  IF EH1 = Q1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    132         MOVE  LB2,TO,Q1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LARL  ZC_R1,=LB'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXBR  ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,Q1
*ZC    132         IF    EH1,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_89_1
*ZC    132         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    132         ELSE
         J     PG_IF_89_E
PG_IF_89_1   DS    0H  &TYPE
*ZC    132         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_89_E   DS    0H  &TYPE
*            MOVE LB2 TO Z1  IF EH1 = Z1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    133         MOVE  LB2,TO,Z1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LARL  ZC_R1,=LB'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXBR  ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         UNPK  0+Z1(15),0+ZCVT_PWORK2(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK2(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK2(2) UNPK #3 FINAL
*ZC    133         IF    EH1,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_90_1
*ZC    133         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    133         ELSE
         J     PG_IF_90_E
PG_IF_90_1   DS    0H  &TYPE
*ZC    133         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_90_E   DS    0H  &TYPE
*            MOVE ED2 TO EH1 IF EH1 = EH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    134         MOVE  ED2,TO,EH1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         STE   0,EH1
*ZC    134         IF    EH1,=,EH1
         LE    ZC_F0,EH1
         CE    ZC_F0,EH1
         BRC   15-ZC_EQ,PG_IF_91_1
*ZC    134         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    134         ELSE
         J     PG_IF_91_E
PG_IF_91_1   DS    0H  &TYPE
*ZC    134         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_91_E   DS    0H  &TYPE
*            MOVE ED2 TO DH1 IF EH1 = DH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    135         MOVE  ED2,TO,DH1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         STD   0,DH1
*ZC    135         IF    EH1,=,DH1
         LDE   ZC_F0,EH1
         CD    ZC_F0,DH1
         BRC   15-ZC_EQ,PG_IF_92_1
*ZC    135         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    135         ELSE
         J     PG_IF_92_E
PG_IF_92_1   DS    0H  &TYPE
*ZC    135         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_92_E   DS    0H  &TYPE
*            MOVE ED2 TO LH1 IF EH1 = LH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    136         MOVE  ED2,TO,LH1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         STD   0,LH1
         STD   2,8+LH1
*ZC    136         IF    EH1,=,LH1
         LE    ZC_F0,EH1
         LXER  ZC_F0,ZC_F0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_93_1
*ZC    136         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    136         ELSE
         J     PG_IF_93_E
PG_IF_93_1   DS    0H  &TYPE
*ZC    136         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_93_E   DS    0H  &TYPE
*            MOVE ED2 TO EB1 IF EH1 = EB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    137         MOVE  ED2,TO,EB1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         STE   0,EB1
*ZC    137         IF    EH1,=,EB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CEB   ZC_F0,EB1
         BRC   15-ZC_EQ,PG_IF_94_1
*ZC    137         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    137         ELSE
         J     PG_IF_94_E
PG_IF_94_1   DS    0H  &TYPE
*ZC    137         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_94_E   DS    0H  &TYPE
*            MOVE ED2 TO DB1 IF EH1 = DB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    138         MOVE  ED2,TO,DB1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         STD   0,DB1
*ZC    138         IF    EH1,=,DB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CDB   ZC_F0,DB1
         BRC   15-ZC_EQ,PG_IF_95_1
*ZC    138         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    138         ELSE
         J     PG_IF_95_E
PG_IF_95_1   DS    0H  &TYPE
*ZC    138         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_95_E   DS    0H  &TYPE
*            MOVE ED2 TO LB1 IF EH1 = LB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    139         MOVE  ED2,TO,LB1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC    139         IF    EH1,=,LB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_96_1
*ZC    139         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    139         ELSE
         J     PG_IF_96_E
PG_IF_96_1   DS    0H  &TYPE
*ZC    139         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_96_E   DS    0H  &TYPE
*            MOVE ED2 TO ED1 IF EH1 = ED1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    140         MOVE  ED2,TO,ED1
         MVC   ED1,ED2  ALIGN LEFT X OTHER
*ZC    140         IF    EH1,=,ED1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_97_1
*ZC    140         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    140         ELSE
         J     PG_IF_97_E
PG_IF_97_1   DS    0H  &TYPE
*ZC    140         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_97_E   DS    0H  &TYPE
*            MOVE ED2 TO DD1 IF EH1 = DD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    141         MOVE  ED2,TO,DD1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         STD   0,DD1
*ZC    141         IF    EH1,=,DD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_98_1
*ZC    141         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    141         ELSE
         J     PG_IF_98_E
PG_IF_98_1   DS    0H  &TYPE
*ZC    141         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_98_E   DS    0H  &TYPE
*            MOVE ED2 TO LD1 IF EH1 = LD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    142         MOVE  ED2,TO,LD1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         STD   0,LD1
         STD   2,8+LD1
*ZC    142         IF    EH1,=,LD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_99_1
*ZC    142         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    142         ELSE
         J     PG_IF_99_E
PG_IF_99_1   DS    0H  &TYPE
*ZC    142         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_99_E   DS    0H  &TYPE
*            MOVE ED2 TO F1  IF EH1 = F1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    143         MOVE  ED2,TO,F1
         LE    ZC_F4,ED2
         LDETR ZC_F4,ZC_F4,0
         LARL  ZC_R1,=DD'1E1'
         LD    ZC_F1,0(ZC_R1)
         MDTR  ZC_R4,ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    0,1  IGNORE HIGH 96 BITS
         ST    0,F1     IGNORE HIGH BITS
*ZC    143         IF    EH1,=,F1
         LE    ZC_F0,EH1
         L     ZC_R1,F1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_100_1
*ZC    143         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    143         ELSE
         J     PG_IF_100_E
PG_IF_100_1  DS    0H  &TYPE
*ZC    143         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_100_E  DS    0H  &TYPE
*            MOVE ED2 TO G1  IF EH1 = G1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    144         MOVE  ED2,TO,G1
         LE    ZC_F4,ED2
         LDETR ZC_F4,ZC_F4,0
         LARL  ZC_R1,=DD'1E1'
         LD    ZC_F1,0(ZC_R1)
         MDTR  ZC_F4,ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   0,1  IGNORE HIGH 64 BITS
         STG   0,G1
*ZC    144         IF    EH1,=,G1
         LE    ZC_F0,EH1
         LG    ZC_R1,G1
         CEGR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_101_1
*ZC    144         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    144         ELSE
         J     PG_IF_101_E
PG_IF_101_1  DS    0H  &TYPE
*ZC    144         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_101_E  DS    0H  &TYPE
*            MOVE ED2 TO H1  IF EH1 = H1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    145         MOVE  ED2,TO,H1
         LE    4,ED2
         LDETR ZC_F4,ZC_F4,0
         LARL  ZC_R1,=DD'1E1'
         LD    ZC_F1,0(ZC_R1)
         MDTR   ZC_F4,ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    0,1  IGNORE HIGH BITS
         STH   0,H1
*ZC    145         IF    EH1,=,H1
         LE    ZC_F0,EH1
         LH    ZC_R1,H1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_102_1
*ZC    145         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    145         ELSE
         J     PG_IF_102_E
PG_IF_102_1  DS    0H  &TYPE
*ZC    145         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_102_E  DS    0H  &TYPE
*            MOVE ED2 TO P1  IF EH1 = P1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    146         MOVE  ED2,TO,P1
         LE    ZC_F4,ED2
         LDETR ZC_F4,ZC_F4,0
         LARL  ZC_R1,=DD'1E1'
         LD    ZC_F1,0(ZC_R1)
         MDTR  ZC_F4,ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         ZAP   P1,ZCVT_PWORK2
*ZC    146         IF    EH1,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_103_1
*ZC    146         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    146         ELSE
         J     PG_IF_103_E
PG_IF_103_1  DS    0H  &TYPE
*ZC    146         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_103_E  DS    0H  &TYPE
*            MOVE ED2 TO Q1  IF EH1 = Q1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    147         MOVE  ED2,TO,Q1
         LE    ZC_F4,ED2
         LDETR ZC_F4,ZC_F4,0
         LARL  ZC_R1,=DD'1E1'
         LD    ZC_F1,0(ZC_R1)
         MDTR  ZC_F4,ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,Q1
*ZC    147         IF    EH1,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_104_1
*ZC    147         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    147         ELSE
         J     PG_IF_104_E
PG_IF_104_1  DS    0H  &TYPE
*ZC    147         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_104_E  DS    0H  &TYPE
*            MOVE ED2 TO Z1  IF EH1 = Z1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    148         MOVE  ED2,TO,Z1
         LE    ZC_F4,ED2
         LDETR ZC_F4,ZC_F4,0
         LARL  ZC_R1,=DD'1E1'
         LD    ZC_F1,0(ZC_R1)
         MDTR  ZC_F4,ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         UNPK  0+Z1(15),0+ZCVT_PWORK2(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK2(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK2(2) UNPK #3 FINAL
*ZC    148         IF    EH1,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_105_1
*ZC    148         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    148         ELSE
         J     PG_IF_105_E
PG_IF_105_1  DS    0H  &TYPE
*ZC    148         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_105_E  DS    0H  &TYPE
*            MOVE DD2 TO EH1 IF EH1 = EH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    149         MOVE  DD2,TO,EH1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         STE   0,EH1
*ZC    149         IF    EH1,=,EH1
         LE    ZC_F0,EH1
         CE    ZC_F0,EH1
         BRC   15-ZC_EQ,PG_IF_106_1
*ZC    149         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    149         ELSE
         J     PG_IF_106_E
PG_IF_106_1  DS    0H  &TYPE
*ZC    149         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_106_E  DS    0H  &TYPE
*            MOVE DD2 TO DH1 IF EH1 = DH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    150         MOVE  DD2,TO,DH1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         STD   0,DH1
*ZC    150         IF    EH1,=,DH1
         LDE   ZC_F0,EH1
         CD    ZC_F0,DH1
         BRC   15-ZC_EQ,PG_IF_107_1
*ZC    150         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    150         ELSE
         J     PG_IF_107_E
PG_IF_107_1  DS    0H  &TYPE
*ZC    150         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_107_E  DS    0H  &TYPE
*            MOVE DD2 TO LH1 IF EH1 = LH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    151         MOVE  DD2,TO,LH1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         STD   0,LH1
         STD   2,8+LH1
*ZC    151         IF    EH1,=,LH1
         LE    ZC_F0,EH1
         LXER  ZC_F0,ZC_F0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_108_1
*ZC    151         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    151         ELSE
         J     PG_IF_108_E
PG_IF_108_1  DS    0H  &TYPE
*ZC    151         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_108_E  DS    0H  &TYPE
*            MOVE DD2 TO EB1 IF EH1 = EB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    152         MOVE  DD2,TO,EB1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         STE   0,EB1
*ZC    152         IF    EH1,=,EB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CEB   ZC_F0,EB1
         BRC   15-ZC_EQ,PG_IF_109_1
*ZC    152         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    152         ELSE
         J     PG_IF_109_E
PG_IF_109_1  DS    0H  &TYPE
*ZC    152         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_109_E  DS    0H  &TYPE
*            MOVE DD2 TO DB1 IF EH1 = DB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    153         MOVE  DD2,TO,DB1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         STD   0,DB1
*ZC    153         IF    EH1,=,DB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CDB   ZC_F0,DB1
         BRC   15-ZC_EQ,PG_IF_110_1
*ZC    153         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    153         ELSE
         J     PG_IF_110_E
PG_IF_110_1  DS    0H  &TYPE
*ZC    153         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_110_E  DS    0H  &TYPE
*            MOVE DD2 TO LB1 IF EH1 = LB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    154         MOVE  DD2,TO,LB1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC    154         IF    EH1,=,LB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_111_1
*ZC    154         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    154         ELSE
         J     PG_IF_111_E
PG_IF_111_1  DS    0H  &TYPE
*ZC    154         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_111_E  DS    0H  &TYPE
*            MOVE DD2 TO ED1 IF EH1 = ED1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    155         MOVE  DD2,TO,ED1
         LD    ZC_F0,DD2
         LEDTR ZC_F0,0,ZC_F0,0
         STE   0,ED1
*ZC    155         IF    EH1,=,ED1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_112_1
*ZC    155         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    155         ELSE
         J     PG_IF_112_E
PG_IF_112_1  DS    0H  &TYPE
*ZC    155         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_112_E  DS    0H  &TYPE
*            MOVE DD2 TO DD1 IF EH1 = DD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    156         MOVE  DD2,TO,DD1
         MVC   DD1,DD2  ALIGN LEFT X OTHER
*ZC    156         IF    EH1,=,DD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_113_1
*ZC    156         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    156         ELSE
         J     PG_IF_113_E
PG_IF_113_1  DS    0H  &TYPE
*ZC    156         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_113_E  DS    0H  &TYPE
*            MOVE DD2 TO LD1 IF EH1 = LD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    157         MOVE  DD2,TO,LD1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         STD   0,LD1
         STD   2,8+LD1
*ZC    157         IF    EH1,=,LD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_114_1
*ZC    157         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    157         ELSE
         J     PG_IF_114_E
PG_IF_114_1  DS    0H  &TYPE
*ZC    157         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_114_E  DS    0H  &TYPE
*            MOVE DD2 TO F1  IF EH1 = F1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    158         MOVE  DD2,TO,F1
         LD    ZC_F4,DD2
         LARL  ZC_R1,=DD'1E1'
         LD    ZC_F1,0(ZC_R1)
         MDTR  ZC_R4,ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    0,1  IGNORE HIGH 96 BITS
         ST    0,F1     IGNORE HIGH BITS
*ZC    158         IF    EH1,=,F1
         LE    ZC_F0,EH1
         L     ZC_R1,F1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_115_1
*ZC    158         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    158         ELSE
         J     PG_IF_115_E
PG_IF_115_1  DS    0H  &TYPE
*ZC    158         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_115_E  DS    0H  &TYPE
*            MOVE DD2 TO G1  IF EH1 = G1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    159         MOVE  DD2,TO,G1
         LD    ZC_F4,DD2
         LARL   ZC_R1,=DD'1E1'
         LD     ZC_F1,0(ZC_R1)
         MDTR   ZC_F4,ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   0,1  IGNORE HIGH 64 BITS
         STG   0,G1
*ZC    159         IF    EH1,=,G1
         LE    ZC_F0,EH1
         LG    ZC_R1,G1
         CEGR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_116_1
*ZC    159         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    159         ELSE
         J     PG_IF_116_E
PG_IF_116_1  DS    0H  &TYPE
*ZC    159         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_116_E  DS    0H  &TYPE
*            MOVE DD2 TO H1  IF EH1 = H1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    160         MOVE  DD2,TO,H1
         LD    4,DD2
         LARL  ZC_R1,=DD'1E1'
         LD    ZC_F1,0(ZC_R1)
         MDTR   ZC_F4,ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    0,1  IGNORE HIGH BITS
         STH   0,H1
*ZC    160         IF    EH1,=,H1
         LE    ZC_F0,EH1
         LH    ZC_R1,H1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_117_1
*ZC    160         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    160         ELSE
         J     PG_IF_117_E
PG_IF_117_1  DS    0H  &TYPE
*ZC    160         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_117_E  DS    0H  &TYPE
*            MOVE DD2 TO P1  IF EH1 = P1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    161         MOVE  DD2,TO,P1
         LD    ZC_F4,DD2
         LARL  ZC_R1,=DD'1E1'
         LD    ZC_F1,0(ZC_R1)
         MDTR  ZC_F4,ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         ZAP   P1,ZCVT_PWORK2
*ZC    161         IF    EH1,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_118_1
*ZC    161         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    161         ELSE
         J     PG_IF_118_E
PG_IF_118_1  DS    0H  &TYPE
*ZC    161         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_118_E  DS    0H  &TYPE
*            MOVE DD2 TO Q1  IF EH1 = Q1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    162         MOVE  DD2,TO,Q1
         LD    ZC_F4,DD2
         LARL  ZC_R1,=DD'1E1'
         LD    ZC_F1,0(ZC_R1)
         MDTR  ZC_F4,ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,Q1
*ZC    162         IF    EH1,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_119_1
*ZC    162         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    162         ELSE
         J     PG_IF_119_E
PG_IF_119_1  DS    0H  &TYPE
*ZC    162         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_119_E  DS    0H  &TYPE
*            MOVE DD2 TO Z1  IF EH1 = Z1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    163         MOVE  DD2,TO,Z1
         LD    ZC_F4,DD2
         LARL  ZC_R1,=DD'1E1'
         LD    ZC_F1,0(ZC_R1)
         MDTR  ZC_F4,ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         UNPK  0+Z1(15),0+ZCVT_PWORK2(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK2(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK2(2) UNPK #3 FINAL
*ZC    163         IF    EH1,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_120_1
*ZC    163         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    163         ELSE
         J     PG_IF_120_E
PG_IF_120_1  DS    0H  &TYPE
*ZC    163         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_120_E  DS    0H  &TYPE
*            MOVE LD2 TO EH1 IF EH1 = EH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    164         MOVE  LD2,TO,EH1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         STE   0,EH1
*ZC    164         IF    EH1,=,EH1
         LE    ZC_F0,EH1
         CE    ZC_F0,EH1
         BRC   15-ZC_EQ,PG_IF_121_1
*ZC    164         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    164         ELSE
         J     PG_IF_121_E
PG_IF_121_1  DS    0H  &TYPE
*ZC    164         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_121_E  DS    0H  &TYPE
*            MOVE LD2 TO DH1 IF EH1 = DH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    165         MOVE  LD2,TO,DH1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         STD   0,DH1
*ZC    165         IF    EH1,=,DH1
         LDE   ZC_F0,EH1
         CD    ZC_F0,DH1
         BRC   15-ZC_EQ,PG_IF_122_1
*ZC    165         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    165         ELSE
         J     PG_IF_122_E
PG_IF_122_1  DS    0H  &TYPE
*ZC    165         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_122_E  DS    0H  &TYPE
*            MOVE LD2 TO LH1 IF EH1 = LH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    166         MOVE  LD2,TO,LH1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         STD   0,LH1
         STD   2,8+LH1
*ZC    166         IF    EH1,=,LH1
         LE    ZC_F0,EH1
         LXER  ZC_F0,ZC_F0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_123_1
*ZC    166         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    166         ELSE
         J     PG_IF_123_E
PG_IF_123_1  DS    0H  &TYPE
*ZC    166         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_123_E  DS    0H  &TYPE
*            MOVE LD2 TO EB1 IF EH1 = EB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    167         MOVE  LD2,TO,EB1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         STE   0,EB1
*ZC    167         IF    EH1,=,EB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CEB   ZC_F0,EB1
         BRC   15-ZC_EQ,PG_IF_124_1
*ZC    167         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    167         ELSE
         J     PG_IF_124_E
PG_IF_124_1  DS    0H  &TYPE
*ZC    167         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_124_E  DS    0H  &TYPE
*            MOVE LD2 TO DB1 IF EH1 = DB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    168         MOVE  LD2,TO,DB1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         STD   0,DB1
*ZC    168         IF    EH1,=,DB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CDB   ZC_F0,DB1
         BRC   15-ZC_EQ,PG_IF_125_1
*ZC    168         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    168         ELSE
         J     PG_IF_125_E
PG_IF_125_1  DS    0H  &TYPE
*ZC    168         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_125_E  DS    0H  &TYPE
*            MOVE LD2 TO LB1 IF EH1 = LB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    169         MOVE  LD2,TO,LB1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC    169         IF    EH1,=,LB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_126_1
*ZC    169         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    169         ELSE
         J     PG_IF_126_E
PG_IF_126_1  DS    0H  &TYPE
*ZC    169         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_126_E  DS    0H  &TYPE
*            MOVE LD2 TO ED1 IF EH1 = ED1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    170         MOVE  LD2,TO,ED1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LEDTR ZC_F0,0,ZC_F0,0
         STE   0,ED1
*ZC    170         IF    EH1,=,ED1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_127_1
*ZC    170         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    170         ELSE
         J     PG_IF_127_E
PG_IF_127_1  DS    0H  &TYPE
*ZC    170         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_127_E  DS    0H  &TYPE
*            MOVE LD2 TO DD1 IF EH1 = DD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    171         MOVE  LD2,TO,DD1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         STD   0,DD1
*ZC    171         IF    EH1,=,DD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_128_1
*ZC    171         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    171         ELSE
         J     PG_IF_128_E
PG_IF_128_1  DS    0H  &TYPE
*ZC    171         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_128_E  DS    0H  &TYPE
*            MOVE LD2 TO LD1 IF EH1 = LD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    172         MOVE  LD2,TO,LD1
         MVC   LD1,16-16+LD2 ALN RIGHT 9ZP
*ZC    172         IF    EH1,=,LD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_129_1
*ZC    172         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    172         ELSE
         J     PG_IF_129_E
PG_IF_129_1  DS    0H  &TYPE
*ZC    172         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_129_E  DS    0H  &TYPE
*            MOVE LD2 TO F1  IF EH1 = F1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    173         MOVE  LD2,TO,F1
         LD    ZC_F4,LD2
         LD    ZC_R6,8+LD2
         LARL  ZC_R1,=LD'1E1'
         LD    ZC_R3,8(ZC_R1)
         LD    ZC_R1,0(ZC_R1)
         MXTR  ZC_F4,ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    0,1  IGNORE HIGH 96 BITS
         ST    0,F1     IGNORE HIGH BITS
*ZC    173         IF    EH1,=,F1
         LE    ZC_F0,EH1
         L     ZC_R1,F1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_130_1
*ZC    173         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    173         ELSE
         J     PG_IF_130_E
PG_IF_130_1  DS    0H  &TYPE
*ZC    173         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_130_E  DS    0H  &TYPE
*            MOVE LD2 TO G1  IF EH1 = G1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    174         MOVE  LD2,TO,G1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LARL  ZC_R1,=LD'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXTR   ZC_F4,ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   0,1  IGNORE HIGH 64 BITS
         STG   0,G1
*ZC    174         IF    EH1,=,G1
         LE    ZC_F0,EH1
         LG    ZC_R1,G1
         CEGR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_131_1
*ZC    174         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    174         ELSE
         J     PG_IF_131_E
PG_IF_131_1  DS    0H  &TYPE
*ZC    174         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_131_E  DS    0H  &TYPE
*            MOVE LD2 TO H1  IF EH1 = H1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    175         MOVE  LD2,TO,H1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LARL  ZC_R1,=LD'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXTR  ZC_F4,ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    0,1  IGNORE HIGH 96 BITS
         STH   0,H1
*ZC    175         IF    EH1,=,H1
         LE    ZC_F0,EH1
         LH    ZC_R1,H1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_132_1
*ZC    175         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    175         ELSE
         J     PG_IF_132_E
PG_IF_132_1  DS    0H  &TYPE
*ZC    175         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_132_E  DS    0H  &TYPE
*            MOVE LD2 TO P1  IF EH1 = P1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    176         MOVE  LD2,TO,P1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LARL  ZC_R1,=LD'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXTR  ZC_F4,ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         ZAP   P1,ZCVT_PWORK2
*ZC    176         IF    EH1,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_133_1
*ZC    176         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    176         ELSE
         J     PG_IF_133_E
PG_IF_133_1  DS    0H  &TYPE
*ZC    176         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_133_E  DS    0H  &TYPE
*            MOVE LD2 TO Q1  IF EH1 = Q1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    177         MOVE  LD2,TO,Q1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LARL  ZC_R1,=LD'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXTR  ZC_F4,ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,Q1
*ZC    177         IF    EH1,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_134_1
*ZC    177         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    177         ELSE
         J     PG_IF_134_E
PG_IF_134_1  DS    0H  &TYPE
*ZC    177         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_134_E  DS    0H  &TYPE
*            MOVE LD2 TO Z1  IF EH1 = Z1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    178         MOVE  LD2,TO,Z1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LARL  ZC_R1,=LD'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXTR  ZC_F4,ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         UNPK  0+Z1(15),0+ZCVT_PWORK2(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK2(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK2(2) UNPK #3 FINAL
*ZC    178         IF    EH1,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_135_1
*ZC    178         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    178         ELSE
         J     PG_IF_135_E
PG_IF_135_1  DS    0H  &TYPE
*ZC    178         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_135_E  DS    0H  &TYPE
*            MOVE F2  TO EH1 IF EH1 = EH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    179         MOVE  F2,TO,EH1
         L     0,F2
         CEFR  0,0
         LARL  ZC_R1,=EH'1E3'
         DE    ZC_R0,0(ZC_R1)
         STE   0,EH1
*ZC    179         IF    EH1,=,EH1
         LE    ZC_F0,EH1
         CE    ZC_F0,EH1
         BRC   15-ZC_EQ,PG_IF_136_1
*ZC    179         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    179         ELSE
         J     PG_IF_136_E
PG_IF_136_1  DS    0H  &TYPE
*ZC    179         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_136_E  DS    0H  &TYPE
*            MOVE F2  TO DH1 IF EH1 = DH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    180         MOVE  F2,TO,DH1
         L     0,F2
         CDFR  0,0
         LARL  ZC_R1,=DH'1E3'
         DD    ZC_R0,0(ZC_R1)
         STD   0,DH1
*ZC    180         IF    EH1,=,DH1
         LDE   ZC_F0,EH1
         CD    ZC_F0,DH1
         BRC   15-ZC_EQ,PG_IF_137_1
*ZC    180         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    180         ELSE
         J     PG_IF_137_E
PG_IF_137_1  DS    0H  &TYPE
*ZC    180         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_137_E  DS    0H  &TYPE
*            MOVE F2  TO LH1 IF EH1 = LH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    181         MOVE  F2,TO,LH1
         L     0,F2
         CXFR  0,0
         LARL  ZC_R1,=LH'1E3'
         LD    ZC_R3,8(ZC_R1)
         LD    ZC_R1,0(ZC_R1)
         DXR   ZC_R0,ZC_R1
         STD   0,LH1
         STD   2,8+LH1
*ZC    181         IF    EH1,=,LH1
         LE    ZC_F0,EH1
         LXER  ZC_F0,ZC_F0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_138_1
*ZC    181         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    181         ELSE
         J     PG_IF_138_E
PG_IF_138_1  DS    0H  &TYPE
*ZC    181         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_138_E  DS    0H  &TYPE
*            MOVE F2  TO EB1 IF EH1 = EB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    182         MOVE  F2,TO,EB1
         L     0,F2
         CEFBR 0,0
         LARL  ZC_R1,=EB'1E3'
         DEB   ZC_R0,0(ZC_R1)
         STE   0,EB1
*ZC    182         IF    EH1,=,EB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CEB   ZC_F0,EB1
         BRC   15-ZC_EQ,PG_IF_139_1
*ZC    182         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    182         ELSE
         J     PG_IF_139_E
PG_IF_139_1  DS    0H  &TYPE
*ZC    182         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_139_E  DS    0H  &TYPE
*            MOVE F2  TO DB1 IF EH1 = DB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    183         MOVE  F2,TO,DB1
         L     0,F2
         CDFBR 0,0
         LARL  ZC_R1,=DB'1E3'
         DDB   ZC_R0,0(ZC_R1)
         STD   0,DB1
*ZC    183         IF    EH1,=,DB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CDB   ZC_F0,DB1
         BRC   15-ZC_EQ,PG_IF_140_1
*ZC    183         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    183         ELSE
         J     PG_IF_140_E
PG_IF_140_1  DS    0H  &TYPE
*ZC    183         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_140_E  DS    0H  &TYPE
*            MOVE F2  TO LB1 IF EH1 = LB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    184         MOVE  F2,TO,LB1
         L     0,F2
         CXFBR ZC_F0,ZC_R0
         LARL  ZC_R1,=LB'1E3'
         LD    ZC_R3,8(ZC_R1)
         LD    ZC_R1,0(ZC_R1)
         DXBR  ZC_R0,ZC_R1
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC    184         IF    EH1,=,LB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_141_1
*ZC    184         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    184         ELSE
         J     PG_IF_141_E
PG_IF_141_1  DS    0H  &TYPE
*ZC    184         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_141_E  DS    0H  &TYPE
*            MOVE F2  TO ED1 IF EH1 = ED1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    185         MOVE  F2,TO,ED1
         LGF   ZC_R0,F2
         CDGTR ZC_F0,ZC_R0
         LARL  ZC_R1,=DD'1E3'
         LD    ZC_F1,0(ZC_R1)
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LEDTR ZC_F0,0,ZC_F0,0
         STE   0,ED1
*ZC    185         IF    EH1,=,ED1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_142_1
*ZC    185         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    185         ELSE
         J     PG_IF_142_E
PG_IF_142_1  DS    0H  &TYPE
*ZC    185         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_142_E  DS    0H  &TYPE
*            MOVE F2  TO DD1 IF EH1 = DD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    186         MOVE  F2,TO,DD1
         LGF   0,F2
         CDGTR ZC_F0,ZC_R0
         LARL  ZC_R1,=DD'1E3'
         LD    ZC_F1,0(ZC_R1)
         DDTR  ZC_F0,ZC_F0,ZC_F1
         STD   0,DD1
*ZC    186         IF    EH1,=,DD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_143_1
*ZC    186         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    186         ELSE
         J     PG_IF_143_E
PG_IF_143_1  DS    0H  &TYPE
*ZC    186         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_143_E  DS    0H  &TYPE
*            MOVE F2  TO LD1 IF EH1 = LD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    187         MOVE  F2,TO,LD1
         LGF   0,F2
         CXGTR ZC_F0,ZC_R0
         LARL  ZC_R1,=LD'1E3'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         DXTR  ZC_F0,ZC_F0,ZC_F1
         STD   0,LD1
         STD   2,8+LD1
*ZC    187         IF    EH1,=,LD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_144_1
*ZC    187         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    187         ELSE
         J     PG_IF_144_E
PG_IF_144_1  DS    0H  &TYPE
*ZC    187         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_144_E  DS    0H  &TYPE
*            MOVE F2  TO F1  IF EH1 = F1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    188         MOVE  F2,TO,F1
         L     0,F2
         LGFR  ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E2'
         DSG   ZC_R0,0(ZC_R2)
         LR    ZC_R0,ZC_R1
         ST    0,F1     IGNORE HIGH BITS
*ZC    188         IF    EH1,=,F1
         LE    ZC_F0,EH1
         L     ZC_R1,F1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_145_1
*ZC    188         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    188         ELSE
         J     PG_IF_145_E
PG_IF_145_1  DS    0H  &TYPE
*ZC    188         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_145_E  DS    0H  &TYPE
*            MOVE F2  TO G1  IF EH1 = G1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    189         MOVE  F2,TO,G1
         LGF   0,F2
         LGR   ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E2'
         DSG   ZC_R0,0(ZC_R2)
         LGR   ZC_R0,ZC_R1
         STG   0,G1
*ZC    189         IF    EH1,=,G1
         LE    ZC_F0,EH1
         LG    ZC_R1,G1
         CEGR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_146_1
*ZC    189         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    189         ELSE
         J     PG_IF_146_E
PG_IF_146_1  DS    0H  &TYPE
*ZC    189         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_146_E  DS    0H  &TYPE
*            MOVE F2  TO H1  IF EH1 = H1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    190         MOVE  F2,TO,H1
         L     0,F2
         LGFR  ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E2'
         DSG   ZC_R0,0(ZC_R2)
         LR    ZC_R0,ZC_R1
         STH   0,H1
*ZC    190         IF    EH1,=,H1
         LE    ZC_F0,EH1
         LH    ZC_R1,H1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_147_1
*ZC    190         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    190         ELSE
         J     PG_IF_147_E
PG_IF_147_1  DS    0H  &TYPE
*ZC    190         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_147_E  DS    0H  &TYPE
*            MOVE F2  TO P1  IF EH1 = P1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    191         MOVE  F2,TO,P1
         L     0,F2
         LGFR  ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E2'
         DSG   ZC_R0,0(ZC_R2)
         LR    ZC_R0,ZC_R1
         CVD   0,ZCVT_PWORK
         ZAP   P1,ZCVT_PWORK
*ZC    191         IF    EH1,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_148_1
*ZC    191         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    191         ELSE
         J     PG_IF_148_E
PG_IF_148_1  DS    0H  &TYPE
*ZC    191         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_148_E  DS    0H  &TYPE
*            MOVE F2  TO Q1  IF EH1 = Q1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    192         MOVE  F2,TO,Q1
         LGF   ZC_R0,F2
         LGR   ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E2'
         DSG   ZC_R0,0(ZC_R2)
         LGR   ZC_R0,ZC_R1
         LGR   ZC_R1,ZC_R0
         SRAG  ZC_R0,ZC_R0,63
         STMG  ZC_R0,ZC_R1,Q1
*ZC    192         IF    EH1,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_149_1
*ZC    192         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    192         ELSE
         J     PG_IF_149_E
PG_IF_149_1  DS    0H  &TYPE
*ZC    192         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_149_E  DS    0H  &TYPE
*            MOVE F2  TO Z1  IF EH1 = Z1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    193         MOVE  F2,TO,Z1
         L     0,F2
         CVD   0,ZCVT_PWORK
         ZAP   ZCVT_PWORK2,ZCVT_PWORK
         SRP   ZCVT_PWORK2,64-2,0
         UNPK  0+Z1(15),0+ZCVT_PWORK2(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK2(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK2(2) UNPK #3 FINAL
*ZC    193         IF    EH1,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_150_1
*ZC    193         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    193         ELSE
         J     PG_IF_150_E
PG_IF_150_1  DS    0H  &TYPE
*ZC    193         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_150_E  DS    0H  &TYPE
*            MOVE G2  TO EH1 IF EH1 = EH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    194         MOVE  G2,TO,EH1
         LG    0,G2
         CEGR  0,0
         LARL  ZC_R1,=EH'1E4'
         DE    ZC_R0,0(ZC_R1)
         STE   0,EH1
*ZC    194         IF    EH1,=,EH1
         LE    ZC_F0,EH1
         CE    ZC_F0,EH1
         BRC   15-ZC_EQ,PG_IF_151_1
*ZC    194         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    194         ELSE
         J     PG_IF_151_E
PG_IF_151_1  DS    0H  &TYPE
*ZC    194         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_151_E  DS    0H  &TYPE
*            MOVE G2  TO DH1 IF EH1 = DH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    195         MOVE  G2,TO,DH1
         LG    0,G2
         CDGR  0,0
         LARL  ZC_R1,=DH'1E4'
         DD    ZC_R0,0(ZC_R1)
         STD   0,DH1
*ZC    195         IF    EH1,=,DH1
         LDE   ZC_F0,EH1
         CD    ZC_F0,DH1
         BRC   15-ZC_EQ,PG_IF_152_1
*ZC    195         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    195         ELSE
         J     PG_IF_152_E
PG_IF_152_1  DS    0H  &TYPE
*ZC    195         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_152_E  DS    0H  &TYPE
*            MOVE G2  TO LH1 IF EH1 = LH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    196         MOVE  G2,TO,LH1
         LG    0,G2
         CXGR  0,0
         LARL  ZC_R1,=LH'1E4'
         LD    ZC_R3,8(ZC_R1)
         LD    ZC_R1,0(ZC_R1)
         DXR   ZC_R0,ZC_R1
         STD   0,LH1
         STD   2,8+LH1
*ZC    196         IF    EH1,=,LH1
         LE    ZC_F0,EH1
         LXER  ZC_F0,ZC_F0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_153_1
*ZC    196         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    196         ELSE
         J     PG_IF_153_E
PG_IF_153_1  DS    0H  &TYPE
*ZC    196         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_153_E  DS    0H  &TYPE
*            MOVE G2  TO EB1 IF EH1 = EB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    197         MOVE  G2,TO,EB1
         LG    0,G2
         CEGBR 0,0
         LARL  ZC_R1,=EB'1E4'
         DEB   ZC_R0,0(ZC_R1)
         STE   0,EB1
*ZC    197         IF    EH1,=,EB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CEB   ZC_F0,EB1
         BRC   15-ZC_EQ,PG_IF_154_1
*ZC    197         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    197         ELSE
         J     PG_IF_154_E
PG_IF_154_1  DS    0H  &TYPE
*ZC    197         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_154_E  DS    0H  &TYPE
*            MOVE G2  TO DB1 IF EH1 = DB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    198         MOVE  G2,TO,DB1
         LG    0,G2
         CDGBR 0,0
         LARL  ZC_R1,=DB'1E4'
         DDB   ZC_R0,0(ZC_R1)
         STD   0,DB1
*ZC    198         IF    EH1,=,DB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CDB   ZC_F0,DB1
         BRC   15-ZC_EQ,PG_IF_155_1
*ZC    198         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    198         ELSE
         J     PG_IF_155_E
PG_IF_155_1  DS    0H  &TYPE
*ZC    198         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_155_E  DS    0H  &TYPE
*            MOVE G2  TO LB1 IF EH1 = LB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    199         MOVE  G2,TO,LB1
         LG    0,G2
         CXGBR ZC_F0,ZC_R0
         LARL  ZC_R1,=LB'1E4'
         LD    ZC_R3,8(ZC_R1)
         LD    ZC_R1,0(ZC_R1)
         DXBR  ZC_R0,ZC_R1
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC    199         IF    EH1,=,LB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_156_1
*ZC    199         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    199         ELSE
         J     PG_IF_156_E
PG_IF_156_1  DS    0H  &TYPE
*ZC    199         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_156_E  DS    0H  &TYPE
*            MOVE G2  TO ED1 IF EH1 = ED1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    200         MOVE  G2,TO,ED1
         LG    0,G2
         CDGTR ZC_F0,ZC_R0
         LARL  ZC_R1,=DD'1E4'
         LD    ZC_F1,0(ZC_R1)
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LEDTR ZC_F0,0,ZC_F0,0
         STE   0,ED1
*ZC    200         IF    EH1,=,ED1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_157_1
*ZC    200         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    200         ELSE
         J     PG_IF_157_E
PG_IF_157_1  DS    0H  &TYPE
*ZC    200         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_157_E  DS    0H  &TYPE
*            MOVE G2  TO DD1 IF EH1 = DD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    201         MOVE  G2,TO,DD1
         LG    0,G2
         CDGTR ZC_F0,ZC_R0
         LARL  ZC_R1,=DD'1E4'
         LD    ZC_F1,0(ZC_R1)
         DDTR  ZC_F0,ZC_F0,ZC_F1
         STD   0,DD1
*ZC    201         IF    EH1,=,DD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_158_1
*ZC    201         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    201         ELSE
         J     PG_IF_158_E
PG_IF_158_1  DS    0H  &TYPE
*ZC    201         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_158_E  DS    0H  &TYPE
*            MOVE G2  TO LD1 IF EH1 = LD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    202         MOVE  G2,TO,LD1
         LG    0,G2
         CXGTR ZC_F0,ZC_R0
         LARL  ZC_R1,=LD'1E4'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         DXTR  ZC_F0,ZC_F0,ZC_F1
         STD   0,LD1
         STD   2,8+LD1
*ZC    202         IF    EH1,=,LD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_159_1
*ZC    202         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    202         ELSE
         J     PG_IF_159_E
PG_IF_159_1  DS    0H  &TYPE
*ZC    202         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_159_E  DS    0H  &TYPE
*            MOVE G2  TO F1  IF EH1 = F1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    203         MOVE  G2,TO,F1
         LG    0,G2
         LGR   ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E3'
         DSG   ZC_R0,0(ZC_R2)
         LGR   ZC_R0,ZC_R1
         ST    0,F1     IGNORE HIGH BITS
*ZC    203         IF    EH1,=,F1
         LE    ZC_F0,EH1
         L     ZC_R1,F1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_160_1
*ZC    203         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    203         ELSE
         J     PG_IF_160_E
PG_IF_160_1  DS    0H  &TYPE
*ZC    203         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_160_E  DS    0H  &TYPE
*            MOVE G2  TO G1  IF EH1 = G1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    204         MOVE  G2,TO,G1
         LG    0,G2
         LGR   ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E3'
         DSG   ZC_R0,0(ZC_R2)
         LGR   ZC_R0,ZC_R1
         STG   0,G1
*ZC    204         IF    EH1,=,G1
         LE    ZC_F0,EH1
         LG    ZC_R1,G1
         CEGR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_161_1
*ZC    204         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    204         ELSE
         J     PG_IF_161_E
PG_IF_161_1  DS    0H  &TYPE
*ZC    204         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_161_E  DS    0H  &TYPE
*            MOVE G2  TO H1  IF EH1 = H1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    205         MOVE  G2,TO,H1
         LG    0,G2
         LGR   ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E3'
         DSG   ZC_R0,0(ZC_R2)
         LGR   ZC_R0,ZC_R1
         STH   0,H1
*ZC    205         IF    EH1,=,H1
         LE    ZC_F0,EH1
         LH    ZC_R1,H1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_162_1
*ZC    205         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    205         ELSE
         J     PG_IF_162_E
PG_IF_162_1  DS    0H  &TYPE
*ZC    205         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_162_E  DS    0H  &TYPE
*            MOVE G2  TO P1  IF EH1 = P1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    206         MOVE  G2,TO,P1
         LG    0,G2
         LGR   ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E3'
         DSG   ZC_R0,0(ZC_R2)
         LGR   ZC_R0,ZC_R1
         CVDG  0,ZCVT_PWORK2
         ZAP   P1,ZCVT_PWORK2
*ZC    206         IF    EH1,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_163_1
*ZC    206         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    206         ELSE
         J     PG_IF_163_E
PG_IF_163_1  DS    0H  &TYPE
*ZC    206         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_163_E  DS    0H  &TYPE
*            MOVE G2  TO Q1  IF EH1 = Q1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    207         MOVE  G2,TO,Q1
         LG    ZC_R0,G2
         LGR   ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E3'
         DSG   ZC_R0,0(ZC_R2)
         LGR   ZC_R0,ZC_R1
         LGR   ZC_R1,ZC_R0
         SRAG  ZC_R0,ZC_R0,63
         STMG  ZC_R0,ZC_R1,Q1
*ZC    207         IF    EH1,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_164_1
*ZC    207         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    207         ELSE
         J     PG_IF_164_E
PG_IF_164_1  DS    0H  &TYPE
*ZC    207         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_164_E  DS    0H  &TYPE
*            MOVE G2  TO Z1  IF EH1 = Z1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    208         MOVE  G2,TO,Z1
         LG    0,G2
         CVDG  0,ZCVT_PWORK2
         SRP   ZCVT_PWORK2,64-3,0
         UNPK  0+Z1(15),0+ZCVT_PWORK2(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK2(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK2(2) UNPK #3 FINAL
*ZC    208         IF    EH1,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_165_1
*ZC    208         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    208         ELSE
         J     PG_IF_165_E
PG_IF_165_1  DS    0H  &TYPE
*ZC    208         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_165_E  DS    0H  &TYPE
*            MOVE H2  TO EH1 IF EH1 = EH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    209         MOVE  H2,TO,EH1
         LH    0,H2
         CEFR  0,0
         LARL  ZC_R1,=EH'1E2'
         DE    ZC_R0,0(ZC_R1)
         STE   0,EH1
*ZC    209         IF    EH1,=,EH1
         LE    ZC_F0,EH1
         CE    ZC_F0,EH1
         BRC   15-ZC_EQ,PG_IF_166_1
*ZC    209         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    209         ELSE
         J     PG_IF_166_E
PG_IF_166_1  DS    0H  &TYPE
*ZC    209         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_166_E  DS    0H  &TYPE
*            MOVE H2  TO DH1 IF EH1 = DH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    210         MOVE  H2,TO,DH1
         LH    0,H2
         CDFR  0,0
         LARL  ZC_R1,=DH'1E2'
         DD    ZC_R0,0(ZC_R1)
         STD   0,DH1
*ZC    210         IF    EH1,=,DH1
         LDE   ZC_F0,EH1
         CD    ZC_F0,DH1
         BRC   15-ZC_EQ,PG_IF_167_1
*ZC    210         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    210         ELSE
         J     PG_IF_167_E
PG_IF_167_1  DS    0H  &TYPE
*ZC    210         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_167_E  DS    0H  &TYPE
*            MOVE H2  TO LH1 IF EH1 = LH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    211         MOVE  H2,TO,LH1
         LH    0,H2
         CXFR  0,0
         LARL  ZC_R1,=LH'1E2'
         LD    ZC_R3,8(ZC_R1)
         LD    ZC_R1,0(ZC_R1)
         DXR   ZC_R0,ZC_R1
         STD   0,LH1
         STD   2,8+LH1
*ZC    211         IF    EH1,=,LH1
         LE    ZC_F0,EH1
         LXER  ZC_F0,ZC_F0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_168_1
*ZC    211         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    211         ELSE
         J     PG_IF_168_E
PG_IF_168_1  DS    0H  &TYPE
*ZC    211         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_168_E  DS    0H  &TYPE
*            MOVE H2  TO EB1 IF EH1 = EB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    212         MOVE  H2,TO,EB1
         LH    0,H2
         CEFBR 0,0
         LARL  ZC_R1,=EB'1E2'
         DEB   ZC_R0,0(ZC_R1)
         STE   0,EB1
*ZC    212         IF    EH1,=,EB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CEB   ZC_F0,EB1
         BRC   15-ZC_EQ,PG_IF_169_1
*ZC    212         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    212         ELSE
         J     PG_IF_169_E
PG_IF_169_1  DS    0H  &TYPE
*ZC    212         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_169_E  DS    0H  &TYPE
*            MOVE H2  TO DB1 IF EH1 = DB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    213         MOVE  H2,TO,DB1
         LH    0,H2
         CDFBR 0,0
         LARL  ZC_R1,=DB'1E2'
         DDB   ZC_R0,0(ZC_R1)
         STD   0,DB1
*ZC    213         IF    EH1,=,DB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CDB   ZC_F0,DB1
         BRC   15-ZC_EQ,PG_IF_170_1
*ZC    213         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    213         ELSE
         J     PG_IF_170_E
PG_IF_170_1  DS    0H  &TYPE
*ZC    213         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_170_E  DS    0H  &TYPE
*            MOVE H2  TO LB1 IF EH1 = LB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    214         MOVE  H2,TO,LB1
         LH    0,H2
         CXFBR ZC_F0,0
         LARL  ZC_R1,=LB'1E2'
         LD    ZC_R3,8(ZC_R1)
         LD    ZC_R1,0(ZC_R1)
         DXBR  ZC_R0,ZC_R1
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC    214         IF    EH1,=,LB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_171_1
*ZC    214         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    214         ELSE
         J     PG_IF_171_E
PG_IF_171_1  DS    0H  &TYPE
*ZC    214         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_171_E  DS    0H  &TYPE
*            MOVE H2  TO ED1 IF EH1 = ED1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    215         MOVE  H2,TO,ED1
         LGH   ZC_R0,H2
         CDGTR ZC_F0,ZC_R0
         LARL  ZC_R1,=DD'1E2'
         LD    ZC_F1,0(ZC_R1)
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LEDTR ZC_F0,0,ZC_F0,0
         STE   0,ED1
*ZC    215         IF    EH1,=,ED1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_172_1
*ZC    215         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    215         ELSE
         J     PG_IF_172_E
PG_IF_172_1  DS    0H  &TYPE
*ZC    215         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_172_E  DS    0H  &TYPE
*            MOVE H2  TO DD1 IF EH1 = DD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    216         MOVE  H2,TO,DD1
         LGH   ZC_R0,H2
         CDGTR ZC_F0,ZC_R0
         LARL  ZC_R1,=DD'1E2'
         LD    ZC_F1,0(ZC_R1)
         DDTR  ZC_F0,ZC_F0,ZC_F1
         STD   0,DD1
*ZC    216         IF    EH1,=,DD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_173_1
*ZC    216         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    216         ELSE
         J     PG_IF_173_E
PG_IF_173_1  DS    0H  &TYPE
*ZC    216         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_173_E  DS    0H  &TYPE
*            MOVE H2  TO LD1 IF EH1 = LD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    217         MOVE  H2,TO,LD1
         LGH   0,H2
         CXGTR ZC_F0,ZC_R0
         LARL  ZC_R1,=LD'1E2'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         DXTR  ZC_F0,ZC_F0,ZC_F1
         STD   0,LD1
         STD   2,8+LD1
*ZC    217         IF    EH1,=,LD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_174_1
*ZC    217         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    217         ELSE
         J     PG_IF_174_E
PG_IF_174_1  DS    0H  &TYPE
*ZC    217         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_174_E  DS    0H  &TYPE
*            MOVE H2  TO F1  IF EH1 = F1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    218         MOVE  H2,TO,F1
         LH    0,H2
         LGFR  ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E1'
         DSG   ZC_R0,0(ZC_R2)
         LR    ZC_R0,ZC_R1
         ST    0,F1     IGNORE HIGH BITS
*ZC    218         IF    EH1,=,F1
         LE    ZC_F0,EH1
         L     ZC_R1,F1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_175_1
*ZC    218         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    218         ELSE
         J     PG_IF_175_E
PG_IF_175_1  DS    0H  &TYPE
*ZC    218         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_175_E  DS    0H  &TYPE
*            MOVE H2  TO G1  IF EH1 = G1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    219         MOVE  H2,TO,G1
         LGH   0,H2
         LGR   ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E1'
         DSG   ZC_R0,0(ZC_R2)
         LGR   ZC_R0,ZC_R1
         STG   0,G1
*ZC    219         IF    EH1,=,G1
         LE    ZC_F0,EH1
         LG    ZC_R1,G1
         CEGR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_176_1
*ZC    219         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    219         ELSE
         J     PG_IF_176_E
PG_IF_176_1  DS    0H  &TYPE
*ZC    219         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_176_E  DS    0H  &TYPE
*            MOVE H2  TO H1  IF EH1 = H1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    220         MOVE  H2,TO,H1
         LH    0,H2
         LGFR  ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E1'
         DSG   ZC_R0,0(ZC_R2)
         LR    ZC_R0,ZC_R1
         STH   0,H1
*ZC    220         IF    EH1,=,H1
         LE    ZC_F0,EH1
         LH    ZC_R1,H1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_177_1
*ZC    220         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    220         ELSE
         J     PG_IF_177_E
PG_IF_177_1  DS    0H  &TYPE
*ZC    220         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_177_E  DS    0H  &TYPE
*            MOVE H2  TO P1  IF EH1 = P1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    221         MOVE  H2,TO,P1
         LH    0,H2
         LGFR  ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E1'
         DSG   ZC_R0,0(ZC_R2)
         LR    ZC_R0,ZC_R1
         CVD   0,ZCVT_PWORK
         ZAP   P1,ZCVT_PWORK
*ZC    221         IF    EH1,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_178_1
*ZC    221         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    221         ELSE
         J     PG_IF_178_E
PG_IF_178_1  DS    0H  &TYPE
*ZC    221         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_178_E  DS    0H  &TYPE
*            MOVE H2  TO Q1  IF EH1 = Q1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    222         MOVE  H2,TO,Q1
         LGH   ZC_R0,H2
         LGR   ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E1'
         DSG   ZC_R0,0(ZC_R2)
         LGR   ZC_R0,ZC_R1
         LGR   ZC_R1,ZC_R0
         SRAG  ZC_R0,ZC_R0,63
         STMG  ZC_R0,ZC_R1,Q1
*ZC    222         IF    EH1,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_179_1
*ZC    222         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    222         ELSE
         J     PG_IF_179_E
PG_IF_179_1  DS    0H  &TYPE
*ZC    222         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_179_E  DS    0H  &TYPE
*            MOVE H2  TO Z1  IF EH1 = Z1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    223         MOVE  H2,TO,Z1
         LH    0,H2
         CVD   0,ZCVT_PWORK
         ZAP   ZCVT_PWORK2,ZCVT_PWORK
         SRP   ZCVT_PWORK2,64-1,0
         UNPK  0+Z1(15),0+ZCVT_PWORK2(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK2(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK2(2) UNPK #3 FINAL
*ZC    223         IF    EH1,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_180_1
*ZC    223         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    223         ELSE
         J     PG_IF_180_E
PG_IF_180_1  DS    0H  &TYPE
*ZC    223         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_180_E  DS    0H  &TYPE
*            MOVE P2  TO EH1 IF EH1 = EH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    224         MOVE  P2,TO,EH1
         ZAP   ZCVT_PWORK,P2
         CVB   0,ZCVT_PWORK
         CEFR  0,0
         LARL  ZC_R1,=EH'1E6'
         DE    ZC_R0,0(ZC_R1)
         STE   0,EH1
*ZC    224         IF    EH1,=,EH1
         LE    ZC_F0,EH1
         CE    ZC_F0,EH1
         BRC   15-ZC_EQ,PG_IF_181_1
*ZC    224         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    224         ELSE
         J     PG_IF_181_E
PG_IF_181_1  DS    0H  &TYPE
*ZC    224         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_181_E  DS    0H  &TYPE
*            MOVE P2  TO DH1 IF EH1 = DH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    225         MOVE  P2,TO,DH1
         ZAP   ZCVT_PWORK1,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0      CVT PL16 TO LD
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=DH'1E6'
         DD    ZC_R0,0(ZC_R1)
         STD   0,DH1
*ZC    225         IF    EH1,=,DH1
         LDE   ZC_F0,EH1
         CD    ZC_F0,DH1
         BRC   15-ZC_EQ,PG_IF_182_1
*ZC    225         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    225         ELSE
         J     PG_IF_182_E
PG_IF_182_1  DS    0H  &TYPE
*ZC    225         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_182_E  DS    0H  &TYPE
*            MOVE P2  TO LH1 IF EH1 = LH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    226         MOVE  P2,TO,LH1
         ZAP   ZCVT_PWORK1,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0      CVT PL16 TO LD
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=LH'1E6'
         LD    ZC_R3,8(ZC_R1)
         LD    ZC_R1,0(ZC_R1)
         DXR   ZC_R0,ZC_R1
         STD   0,LH1
         STD   2,8+LH1
*ZC    226         IF    EH1,=,LH1
         LE    ZC_F0,EH1
         LXER  ZC_F0,ZC_F0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_183_1
*ZC    226         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    226         ELSE
         J     PG_IF_183_E
PG_IF_183_1  DS    0H  &TYPE
*ZC    226         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_183_E  DS    0H  &TYPE
*            MOVE P2  TO EB1 IF EH1 = EB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    227         MOVE  P2,TO,EB1
         ZAP   ZCVT_PWORK1,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=EB'1E6'
         DEB   ZC_R0,0(ZC_R1)
         STE   0,EB1
*ZC    227         IF    EH1,=,EB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CEB   ZC_F0,EB1
         BRC   15-ZC_EQ,PG_IF_184_1
*ZC    227         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    227         ELSE
         J     PG_IF_184_E
PG_IF_184_1  DS    0H  &TYPE
*ZC    227         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_184_E  DS    0H  &TYPE
*            MOVE P2  TO DB1 IF EH1 = DB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    228         MOVE  P2,TO,DB1
         ZAP   ZCVT_PWORK2,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=DB'1E6'
         DDB   ZC_R0,0(ZC_R1)
         STD   0,DB1
*ZC    228         IF    EH1,=,DB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CDB   ZC_F0,DB1
         BRC   15-ZC_EQ,PG_IF_185_1
*ZC    228         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    228         ELSE
         J     PG_IF_185_E
PG_IF_185_1  DS    0H  &TYPE
*ZC    228         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_185_E  DS    0H  &TYPE
*            MOVE P2  TO LB1 IF EH1 = LB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    229         MOVE  P2,TO,LB1
         ZAP   ZCVT_PWORK2,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=LB'1E6'
         LD    ZC_R3,8(ZC_R1)
         LD    ZC_R1,0(ZC_R1)
         DXBR  ZC_R0,ZC_R1
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC    229         IF    EH1,=,LB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_186_1
*ZC    229         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    229         ELSE
         J     PG_IF_186_E
PG_IF_186_1  DS    0H  &TYPE
*ZC    229         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_186_E  DS    0H  &TYPE
*            MOVE P2  TO ED1 IF EH1 = ED1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    230         MOVE  P2,TO,ED1
         ZAP   ZCVT_PWORK2,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=DD'1E6'
         LD    ZC_F1,0(ZC_R1)
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LEDTR ZC_F0,0,ZC_F0,0
         STE   0,ED1
*ZC    230         IF    EH1,=,ED1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_187_1
*ZC    230         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    230         ELSE
         J     PG_IF_187_E
PG_IF_187_1  DS    0H  &TYPE
*ZC    230         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_187_E  DS    0H  &TYPE
*            MOVE P2  TO DD1 IF EH1 = DD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    231         MOVE  P2,TO,DD1
         ZAP   ZCVT_PWORK2,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=DD'1E6'
         LD    ZC_F1,0(ZC_R1)
         DDTR  ZC_F0,ZC_F0,ZC_F1
         STD   0,DD1
*ZC    231         IF    EH1,=,DD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_188_1
*ZC    231         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    231         ELSE
         J     PG_IF_188_E
PG_IF_188_1  DS    0H  &TYPE
*ZC    231         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_188_E  DS    0H  &TYPE
*            MOVE P2  TO LD1 IF EH1 = LD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    232         MOVE  P2,TO,LD1
         ZAP   ZCVT_PWORK2,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F0,ZC_R0
         LARL  ZC_R1,=LD'1E6'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         DXTR  ZC_F0,ZC_F0,ZC_F1
         STD   0,LD1
         STD   2,8+LD1
*ZC    232         IF    EH1,=,LD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_189_1
*ZC    232         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    232         ELSE
         J     PG_IF_189_E
PG_IF_189_1  DS    0H  &TYPE
*ZC    232         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_189_E  DS    0H  &TYPE
*            MOVE P2  TO F1  IF EH1 = F1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    233         MOVE  P2,TO,F1
         ZAP   ZCVT_PWORK,P2(16) RPI 1182 ADD SRC LEN
         CVB   0,ZCVT_PWORK
         LGFR  ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E5'
         DSG   ZC_R0,0(ZC_R2)
         LR    ZC_R0,ZC_R1
         ST    0,F1     IGNORE HIGH BITS
*ZC    233         IF    EH1,=,F1
         LE    ZC_F0,EH1
         L     ZC_R1,F1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_190_1
*ZC    233         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    233         ELSE
         J     PG_IF_190_E
PG_IF_190_1  DS    0H  &TYPE
*ZC    233         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_190_E  DS    0H  &TYPE
*            MOVE P2  TO G1  IF EH1 = G1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    234         MOVE  P2,TO,G1
         ZAP   ZCVT_PWORK1,P2(16) RPI 1182 ADD SRC LEN
         CVBG  0,ZCVT_PWORK1
         LGR   ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E5'
         DSG   ZC_R0,0(ZC_R2)
         LGR   ZC_R0,ZC_R1
         STG   0,G1
*ZC    234         IF    EH1,=,G1
         LE    ZC_F0,EH1
         LG    ZC_R1,G1
         CEGR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_191_1
*ZC    234         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    234         ELSE
         J     PG_IF_191_E
PG_IF_191_1  DS    0H  &TYPE
*ZC    234         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_191_E  DS    0H  &TYPE
*            MOVE P2  TO H1  IF EH1 = H1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    235         MOVE  P2,TO,H1
         ZAP   ZCVT_PWORK,P2(16) RPI 1182 ADD SRC LEN
         CVB   0,ZCVT_PWORK
         LGFR  ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E5'
         DSG   ZC_R0,0(ZC_R2)
         LR    ZC_R0,ZC_R1
         STH   0,H1
*ZC    235         IF    EH1,=,H1
         LE    ZC_F0,EH1
         LH    ZC_R1,H1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_192_1
*ZC    235         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    235         ELSE
         J     PG_IF_192_E
PG_IF_192_1  DS    0H  &TYPE
*ZC    235         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_192_E  DS    0H  &TYPE
*            MOVE P2  TO P1  IF EH1 = P1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    236         MOVE  P2,TO,P1
         ZAP ZCVT_PWORK,P2                  RPI 1178
         SRP ZCVT_PWORK,64-5,0                RPI 1178
         ZAP P1,ZCVT_PWORK                  RPI 1178
*ZC    236         IF    EH1,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_193_1
*ZC    236         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    236         ELSE
         J     PG_IF_193_E
PG_IF_193_1  DS    0H  &TYPE
*ZC    236         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_193_E  DS    0H  &TYPE
*            MOVE P2  TO Q1  IF EH1 = Q1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    237         MOVE  P2,TO,Q1
         ZAP   ZCVT_PWORK2,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LARL  ZC_R2,=FL8'1E5'
         LG    ZC_R3,0(ZC_R2)
         SGR   ZC_R2,ZC_R2
         L     ZC_R15,ZCVT_DIVQ128
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R0,ZC_R2
         LGR   ZC_R1,ZC_R3
         STMG  ZC_R0,ZC_R1,Q1
*ZC    237         IF    EH1,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_194_1
*ZC    237         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    237         ELSE
         J     PG_IF_194_E
PG_IF_194_1  DS    0H  &TYPE
*ZC    237         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_194_E  DS    0H  &TYPE
*            MOVE P2  TO Z1  IF EH1 = Z1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    238         MOVE  P2,TO,Z1
         ZAP   ZCVT_PWORK2,P2(16)
         SRP   ZCVT_PWORK2,64-5,0
         UNPK  0+Z1(15),0+ZCVT_PWORK2(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK2(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK2(2) UNPK #3 FINAL
*ZC    238         IF    EH1,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_195_1
*ZC    238         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    238         ELSE
         J     PG_IF_195_E
PG_IF_195_1  DS    0H  &TYPE
*ZC    238         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_195_E  DS    0H  &TYPE
*            MOVE Q2  TO EH1 IF EH1 = EH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    239         MOVE  Q2,TO,EH1
         LG    ZC_R0,Q2
         LG    ZC_R1,8+Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=EH'1E5'
         DE    ZC_R0,0(ZC_R1)
         STE   0,EH1
*ZC    239         IF    EH1,=,EH1
         LE    ZC_F0,EH1
         CE    ZC_F0,EH1
         BRC   15-ZC_EQ,PG_IF_196_1
*ZC    239         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    239         ELSE
         J     PG_IF_196_E
PG_IF_196_1  DS    0H  &TYPE
*ZC    239         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_196_E  DS    0H  &TYPE
*            MOVE Q2  TO DH1 IF EH1 = DH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    240         MOVE  Q2,TO,DH1
         LG    ZC_R0,Q2
         LG    ZC_R1,8+Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=DH'1E5'
         DD    ZC_R0,0(ZC_R1)
         STD   0,DH1
*ZC    240         IF    EH1,=,DH1
         LDE   ZC_F0,EH1
         CD    ZC_F0,DH1
         BRC   15-ZC_EQ,PG_IF_197_1
*ZC    240         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    240         ELSE
         J     PG_IF_197_E
PG_IF_197_1  DS    0H  &TYPE
*ZC    240         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_197_E  DS    0H  &TYPE
*            MOVE Q2  TO LH1 IF EH1 = LH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    241         MOVE  Q2,TO,LH1
         LG    ZC_R0,Q2
         LG    ZC_R1,8+Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=LH'1E5'
         LD    ZC_R3,8(ZC_R1)
         LD    ZC_R1,0(ZC_R1)
         DXR   ZC_R0,ZC_R1
         STD   0,LH1
         STD   2,8+LH1
*ZC    241         IF    EH1,=,LH1
         LE    ZC_F0,EH1
         LXER  ZC_F0,ZC_F0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_198_1
*ZC    241         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    241         ELSE
         J     PG_IF_198_E
PG_IF_198_1  DS    0H  &TYPE
*ZC    241         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_198_E  DS    0H  &TYPE
*            MOVE Q2  TO EB1 IF EH1 = EB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    242         MOVE  Q2,TO,EB1
         LG    ZC_R0,Q2
         LG    ZC_R1,8+Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=EB'1E5'
         DEB   ZC_R0,0(ZC_R1)
         STE   0,EB1
*ZC    242         IF    EH1,=,EB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CEB   ZC_F0,EB1
         BRC   15-ZC_EQ,PG_IF_199_1
*ZC    242         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    242         ELSE
         J     PG_IF_199_E
PG_IF_199_1  DS    0H  &TYPE
*ZC    242         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_199_E  DS    0H  &TYPE
*            MOVE Q2  TO DB1 IF EH1 = DB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    243         MOVE  Q2,TO,DB1
         LG    ZC_R0,Q2
         LG    ZC_R1,8+Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=DB'1E5'
         DDB   ZC_R0,0(ZC_R1)
         STD   0,DB1
*ZC    243         IF    EH1,=,DB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CDB   ZC_F0,DB1
         BRC   15-ZC_EQ,PG_IF_200_1
*ZC    243         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    243         ELSE
         J     PG_IF_200_E
PG_IF_200_1  DS    0H  &TYPE
*ZC    243         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_200_E  DS    0H  &TYPE
*            MOVE Q2  TO LB1 IF EH1 = LB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    244         MOVE  Q2,TO,LB1
         LG    ZC_R0,Q2
         LG    ZC_R1,8+Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=LB'1E5'
         LD    ZC_R3,8(ZC_R1)
         LD    ZC_R1,0(ZC_R1)
         DXBR  ZC_R0,ZC_R1
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC    244         IF    EH1,=,LB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_201_1
*ZC    244         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    244         ELSE
         J     PG_IF_201_E
PG_IF_201_1  DS    0H  &TYPE
*ZC    244         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_201_E  DS    0H  &TYPE
*            MOVE Q2  TO ED1 IF EH1 = ED1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    245         MOVE  Q2,TO,ED1
         LG    ZC_R0,Q2
         LG    ZC_R1,8+Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=DD'1E5'
         LD    ZC_F1,0(ZC_R1)
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LEDTR ZC_F0,0,ZC_F0,0
         STE   0,ED1
*ZC    245         IF    EH1,=,ED1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_202_1
*ZC    245         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    245         ELSE
         J     PG_IF_202_E
PG_IF_202_1  DS    0H  &TYPE
*ZC    245         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_202_E  DS    0H  &TYPE
*            MOVE Q2  TO DD1 IF EH1 = DD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    246         MOVE  Q2,TO,DD1
         LG    ZC_R0,Q2
         LG    ZC_R1,8+Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=DD'1E5'
         LD    ZC_F1,0(ZC_R1)
         DDTR  ZC_F0,ZC_F0,ZC_F1
         STD   0,DD1
*ZC    246         IF    EH1,=,DD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_203_1
*ZC    246         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    246         ELSE
         J     PG_IF_203_E
PG_IF_203_1  DS    0H  &TYPE
*ZC    246         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_203_E  DS    0H  &TYPE
*            MOVE Q2  TO LD1 IF EH1 = LD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    247         MOVE  Q2,TO,LD1
         LG    ZC_R0,Q2
         LG    ZC_R1,8+Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=LD'1E5'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         DXTR  ZC_F0,ZC_F0,ZC_F1
         STD   0,LD1
         STD   2,8+LD1
*ZC    247         IF    EH1,=,LD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_204_1
*ZC    247         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    247         ELSE
         J     PG_IF_204_E
PG_IF_204_1  DS    0H  &TYPE
*ZC    247         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_204_E  DS    0H  &TYPE
*            MOVE Q2  TO F1  IF EH1 = F1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    248         MOVE  Q2,TO,F1
         L     0,12+Q2 IGNORE HIGH 96 BITS
         LGFR  ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E4'
         DSG   ZC_R0,0(ZC_R2)
         LR    ZC_R0,ZC_R1
         ST    0,F1     IGNORE HIGH BITS
*ZC    248         IF    EH1,=,F1
         LE    ZC_F0,EH1
         L     ZC_R1,F1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_205_1
*ZC    248         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    248         ELSE
         J     PG_IF_205_E
PG_IF_205_1  DS    0H  &TYPE
*ZC    248         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_205_E  DS    0H  &TYPE
*            MOVE Q2  TO G1  IF EH1 = G1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    249         MOVE  Q2,TO,G1
         LG    0,8+Q2    IGNORE HIGH 64 BITS
         LGR   ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E4'
         DSG   ZC_R0,0(ZC_R2)
         LGR   ZC_R0,ZC_R1
         STG   0,G1
*ZC    249         IF    EH1,=,G1
         LE    ZC_F0,EH1
         LG    ZC_R1,G1
         CEGR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_206_1
*ZC    249         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    249         ELSE
         J     PG_IF_206_E
PG_IF_206_1  DS    0H  &TYPE
*ZC    249         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_206_E  DS    0H  &TYPE
*            MOVE Q2  TO H1  IF EH1 = H1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    250         MOVE  Q2,TO,H1
         L     0,12+Q2 IGNORE 112 BITS
         LGFR  ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E4'
         DSG   ZC_R0,0(ZC_R2)
         LR    ZC_R0,ZC_R1
         STH   0,H1
*ZC    250         IF    EH1,=,H1
         LE    ZC_F0,EH1
         LH    ZC_R1,H1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_207_1
*ZC    250         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    250         ELSE
         J     PG_IF_207_E
PG_IF_207_1  DS    0H  &TYPE
*ZC    250         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_207_E  DS    0H  &TYPE
*            MOVE Q2  TO P1  IF EH1 = P1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    251         MOVE  Q2,TO,P1
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
         SRP ZCVT_PWORK2,64-4,0
         ZAP   P1,ZCVT_PWORK2
*ZC    251         IF    EH1,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_208_1
*ZC    251         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    251         ELSE
         J     PG_IF_208_E
PG_IF_208_1  DS    0H  &TYPE
*ZC    251         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_208_E  DS    0H  &TYPE
*            MOVE Q2  TO Q1  IF EH1 = Q1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    252         MOVE  Q2,TO,Q1
         LMG   ZC_R0,ZC_R1,Q2    IGNORE HIGH 64 BITS
         LARL  ZC_R2,=FL8'1E4'
         LG    ZC_R3,0(ZC_R2)
         SGR   ZC_R2,ZC_R2
         L     ZC_R15,ZCVT_DIVQ128
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R0,ZC_R2
         LGR   ZC_R1,ZC_R3
         STMG  ZC_R0,ZC_R1,Q1
*ZC    252         IF    EH1,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_209_1
*ZC    252         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    252         ELSE
         J     PG_IF_209_E
PG_IF_209_1  DS    0H  &TYPE
*ZC    252         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_209_E  DS    0H  &TYPE
*            MOVE Q2  TO Z1  IF EH1 = Z1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    253         MOVE  Q2,TO,Z1
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
         SRP ZCVT_PWORK2,64-4,0                RPI 1178
         UNPK  0+Z1(15),0+ZCVT_PWORK2(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK2(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK2(2) UNPK #3 FINAL
*ZC    253         IF    EH1,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_210_1
*ZC    253         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    253         ELSE
         J     PG_IF_210_E
PG_IF_210_1  DS    0H  &TYPE
*ZC    253         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_210_E  DS    0H  &TYPE
*            MOVE Z2  TO EH1 IF EH1 = EH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    254         MOVE  Z2,TO,EH1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=EH'1E7'
         DE    ZC_R0,0(ZC_R1)
         STE   0,EH1
*ZC    254         IF    EH1,=,EH1
         LE    ZC_F0,EH1
         CE    ZC_F0,EH1
         BRC   15-ZC_EQ,PG_IF_211_1
*ZC    254         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    254         ELSE
         J     PG_IF_211_E
PG_IF_211_1  DS    0H  &TYPE
*ZC    254         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_211_E  DS    0H  &TYPE
*            MOVE Z2  TO DH1 IF EH1 = DH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    255         MOVE  Z2,TO,DH1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=DH'1E7'
         DD    ZC_R0,0(ZC_R1)
         STD   0,DH1
*ZC    255         IF    EH1,=,DH1
         LDE   ZC_F0,EH1
         CD    ZC_F0,DH1
         BRC   15-ZC_EQ,PG_IF_212_1
*ZC    255         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    255         ELSE
         J     PG_IF_212_E
PG_IF_212_1  DS    0H  &TYPE
*ZC    255         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_212_E  DS    0H  &TYPE
*            MOVE Z2  TO LH1 IF EH1 = LH1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    256         MOVE  Z2,TO,LH1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=LH'1E7'
         LD    ZC_R3,8(ZC_R1)
         LD    ZC_R1,0(ZC_R1)
         DXR   ZC_R0,ZC_R1
         STD   0,LH1
         STD   2,8+LH1
*ZC    256         IF    EH1,=,LH1
         LE    ZC_F0,EH1
         LXER  ZC_F0,ZC_F0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_213_1
*ZC    256         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    256         ELSE
         J     PG_IF_213_E
PG_IF_213_1  DS    0H  &TYPE
*ZC    256         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_213_E  DS    0H  &TYPE
*            MOVE Z2  TO EB1 IF EH1 = EB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    257         MOVE  Z2,TO,EB1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=EB'1E7'
         DEB   ZC_R0,0(ZC_R1)
         STE   0,EB1
*ZC    257         IF    EH1,=,EB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CEB   ZC_F0,EB1
         BRC   15-ZC_EQ,PG_IF_214_1
*ZC    257         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    257         ELSE
         J     PG_IF_214_E
PG_IF_214_1  DS    0H  &TYPE
*ZC    257         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_214_E  DS    0H  &TYPE
*            MOVE Z2  TO DB1 IF EH1 = DB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    258         MOVE  Z2,TO,DB1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=DB'1E7'
         DDB   ZC_R0,0(ZC_R1)
         STD   0,DB1
*ZC    258         IF    EH1,=,DB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CDB   ZC_F0,DB1
         BRC   15-ZC_EQ,PG_IF_215_1
*ZC    258         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    258         ELSE
         J     PG_IF_215_E
PG_IF_215_1  DS    0H  &TYPE
*ZC    258         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_215_E  DS    0H  &TYPE
*            MOVE Z2  TO LB1 IF EH1 = LB1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    259         MOVE  Z2,TO,LB1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=LB'1E7'
         LD    ZC_R3,8(ZC_R1)
         LD    ZC_R1,0(ZC_R1)
         DXBR  ZC_R0,ZC_R1
         STD   ZC_F0,LB1
         STD   ZC_F2,8+LB1
*ZC    259         IF    EH1,=,LB1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_216_1
*ZC    259         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    259         ELSE
         J     PG_IF_216_E
PG_IF_216_1  DS    0H  &TYPE
*ZC    259         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_216_E  DS    0H  &TYPE
*            MOVE Z2  TO ED1 IF EH1 = ED1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    260         MOVE  Z2,TO,ED1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=DD'1E7'
         LD    ZC_F1,0(ZC_R1)
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LEDTR ZC_F0,0,ZC_F0,0
         STE   0,ED1
*ZC    260         IF    EH1,=,ED1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_217_1
*ZC    260         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    260         ELSE
         J     PG_IF_217_E
PG_IF_217_1  DS    0H  &TYPE
*ZC    260         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_217_E  DS    0H  &TYPE
*            MOVE Z2  TO DD1 IF EH1 = DD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    261         MOVE  Z2,TO,DD1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=DD'1E7'
         LD    ZC_F1,0(ZC_R1)
         DDTR  ZC_F0,ZC_F0,ZC_F1
         STD   0,DD1
*ZC    261         IF    EH1,=,DD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_218_1
*ZC    261         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    261         ELSE
         J     PG_IF_218_E
PG_IF_218_1  DS    0H  &TYPE
*ZC    261         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_218_E  DS    0H  &TYPE
*            MOVE Z2  TO LD1 IF EH1 = LD1 PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    262         MOVE  Z2,TO,LD1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F0,ZC_R0
         LARL  ZC_R1,=LD'1E7'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         DXTR  ZC_F0,ZC_F0,ZC_F1
         STD   0,LD1
         STD   2,8+LD1
*ZC    262         IF    EH1,=,LD1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_219_1
*ZC    262         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    262         ELSE
         J     PG_IF_219_E
PG_IF_219_1  DS    0H  &TYPE
*ZC    262         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_219_E  DS    0H  &TYPE
*            MOVE Z2  TO F1  IF EH1 = F1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    263         MOVE  Z2,TO,F1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         CVBG  0,ZCVT_PWORK2
         LGR   ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E6'
         DSG   ZC_R0,0(ZC_R2)
         LGR   ZC_R0,ZC_R1
         ST    0,F1     IGNORE HIGH BITS
*ZC    263         IF    EH1,=,F1
         LE    ZC_F0,EH1
         L     ZC_R1,F1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_220_1
*ZC    263         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    263         ELSE
         J     PG_IF_220_E
PG_IF_220_1  DS    0H  &TYPE
*ZC    263         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_220_E  DS    0H  &TYPE
*            MOVE Z2  TO G1  IF EH1 = G1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    264         MOVE  Z2,TO,G1
         PACK  ZCVT_PWORK1(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z2(3)  PACK #3 FINAL
         CVBG  0,ZCVT_PWORK1
         LGR   ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E6'
         DSG   ZC_R0,0(ZC_R2)
         LGR   ZC_R0,ZC_R1
         STG   0,G1
*ZC    264         IF    EH1,=,G1
         LE    ZC_F0,EH1
         LG    ZC_R1,G1
         CEGR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_221_1
*ZC    264         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    264         ELSE
         J     PG_IF_221_E
PG_IF_221_1  DS    0H  &TYPE
*ZC    264         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_221_E  DS    0H  &TYPE
*            MOVE Z2  TO H1  IF EH1 = H1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    265         MOVE  Z2,TO,H1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         CVBG  0,ZCVT_PWORK2
         LGR   ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E6'
         DSG   ZC_R0,0(ZC_R2)
         LGR   ZC_R0,ZC_R1
         STH   0,H1
*ZC    265         IF    EH1,=,H1
         LE    ZC_F0,EH1
         LH    ZC_R1,H1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_222_1
*ZC    265         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    265         ELSE
         J     PG_IF_222_E
PG_IF_222_1  DS    0H  &TYPE
*ZC    265         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_222_E  DS    0H  &TYPE
*            MOVE Z2  TO P1  IF EH1 = P1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    266         MOVE  Z2,TO,P1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         SRP ZCVT_PWORK2(16),64-6,0
         ZAP   P1,ZCVT_PWORK2(16)
*ZC    266         IF    EH1,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_223_1
*ZC    266         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    266         ELSE
         J     PG_IF_223_E
PG_IF_223_1  DS    0H  &TYPE
*ZC    266         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_223_E  DS    0H  &TYPE
*            MOVE Z2  TO Q1  IF EH1 = Q1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    267         MOVE  Z2,TO,Q1
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
         LARL  ZC_R2,=FL8'1E6'
         LG    ZC_R3,0(ZC_R2)
         SGR   ZC_R2,ZC_R2
         L     ZC_R15,ZCVT_DIVQ128
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R0,ZC_R2
         LGR   ZC_R1,ZC_R3
         STMG  ZC_R0,ZC_R1,Q1
*ZC    267         IF    EH1,=,Q1
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_224_1
*ZC    267         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    267         ELSE
         J     PG_IF_224_E
PG_IF_224_1  DS    0H  &TYPE
*ZC    267         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_224_E  DS    0H  &TYPE
*            MOVE Z2  TO Z1  IF EH1 = Z1  PERFORM GOOD ELSE PERFORM BADX
                              .
*ZC    268         MOVE  Z2,TO,Z1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         SRP   ZCVT_PWORK2,64-6,0
         UNPK  0+Z1(15),0+ZCVT_PWORK2(8)     UNPK #1 FULL
         UNPK  14+Z1(15),7+ZCVT_PWORK2(8)     UNPK #2 FULL
         UNPK  28+Z1(3),14+ZCVT_PWORK2(2) UNPK #3 FINAL
*ZC    268         IF    EH1,=,Z1
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH1
         LARL  ZC_R2,=EH'1E1'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_225_1
*ZC    268         PERFORM GOOD
         LARL  ZC_R14,PG_GOOD
         LARL  ZC_R0,PG_GOOD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    268         ELSE
         J     PG_IF_225_E
PG_IF_225_1  DS    0H  &TYPE
*ZC    268         PERFORM BAD
         LARL  ZC_R14,PG_BAD
         LARL  ZC_R0,PG_BAD_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_225_E  DS    0H  &TYPE
*            DISPLAY 'TOTAL GOOD = ' GOOD ' TOTAL BAD = ' BAD
*ZC    269         DISPLAY 'TOTAL GOOD = ',GOOD,' TOTAL BAD = ',BAD
         LA    ZC_R3,ZCVT_WORKAREA  ZC_R3=CVT LIST WORK AREA
         LARL  ZC_R0,=CL14'TOTAL GOOD = ' PAD TO EVEN LEN LIT
         LA    ZC_R1,13
         LA    ZC_R2,C'X'
         STM   ZC_R0,ZC_R2,0(ZC_R3)  SET DISPLAY LIST ENTRY
         LA    ZC_R0,GOOD
         LA    ZC_R1,3  RPI 1182 WAS &SYM_LEN(&FIELD_IX)
         LA    ZC_R2,C'P'
         STM   ZC_R0,ZC_R2,12(ZC_R3)  SET DISPLAY LIST ENTRY
         LARL  ZC_R0,=CL14' TOTAL BAD = ' PAD TO EVEN LEN LIT
         LA    ZC_R1,13
         LA    ZC_R2,C'X'
         STM   ZC_R0,ZC_R2,24(ZC_R3)  SET DISPLAY LIST ENTRY
         LA    ZC_R0,BAD
         LA    ZC_R1,3  RPI 1182 WAS &SYM_LEN(&FIELD_IX)
         LA    ZC_R2,C'P'
         STM   ZC_R0,ZC_R2,36(ZC_R3)  SET DISPLAY LIST ENTRY
         OI    48-4(ZC_R3),X'80' SET VL BIT IN LAST WORD OF PARM LIST
         LR    ZC_R1,ZC_R3
         L     ZC_R15,ZCVT_DISPLAY
         BASR  ZC_R14,ZC_R15
*            STOP RUN.
*ZC    270         STOP  RUN
         LH    ZC_R1,RETURN_CODE      PASS RETURN CODE IN R1
         L     ZC_R15,ZCVT_GOBACK
         BR    ZC_R15
*        GOOD.
PG_MAINLINE_END L ZC_R15,ZCVT_PMCHECK
         BASR  ZC_R14,ZC_R15 CHECK FOR END OF CURRENT PERFORM
PG_GOOD  DS    0H
*            ADD 1 TO GOOD.
*ZC    272         ADD   1,TO,GOOD
         BRAS  ZC_R14,3 SET ZC_R1 TO A(INLINE LIT) AND SKIP OVER IT
         DC    PL2'1'
         AP    GOOD,0(2,ZC_R14)
*        BAD.
PG_GOOD_END L  ZC_R15,ZCVT_PMCHECK
         BASR  ZC_R14,ZC_R15 CHECK FOR END OF CURRENT PERFORM
PG_BAD   DS    0H
*            ADD 1 TO BAD
*ZC    274         ADD   1,TO,BAD
         BRAS  ZC_R14,3 SET ZC_R1 TO A(INLINE LIT) AND SKIP OVER IT
         DC    PL2'1'
         AP    BAD,0(2,ZC_R14)
*            MOVE 16 TO RETURN-CODE
*ZC    275         MOVE  16,TO,RETURN_CODE
          MVHHI RETURN_CODE,16
*            DISPLAY 'BAD'.
*ZC    276         DISPLAY 'BAD'
         BRAS  1,*+(WTO#7057_EOT-*+1)/2*2
         DC    AL2(WTO#7057_EOT-*,0),C'BAD'
WTO#7057_EOT     EQU *
         SVC   35
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
                      
*    01  EH1                            00000058 00000004 1   1        X
                     1.5 
*    01  DH1                            0000005C 00000008 1   2        X
                     1.5 
*    01  LH1                            00000064 00000010 1   3        X
                     1.5 
*    01  EB1                            00000074 00000004 1   4        X
                     1.5 
*    01  DB1                            00000078 00000008 1   5        X
                     1.5 
*    01  LB1                            00000080 00000010 1   6        X
                     1.5 
*    01  ED1                            00000090 00000004 1   7        X
                     1.5 
*    01  DD1                            00000094 00000008 1   8        X
                     1.5 
*    01  LD1                            0000009C 00000010 1   9        X
                     1.5 
*    01  H1                             000000AC 00000002 1   H   9(3)VX
               9     15 
*    01  F1                             000000AE 00000004 1   F   9(8)VX
               9     15 
*    01  G1                             000000B2 00000008 1   G   9(17)X
               V9    15 
*    01  Q1                             000000BA 00000010 1   Q   9(38)X
               V9    15 
*    01  P1                             000000CA 00000010 1   P   9(30)X
               V9    15 
*    01  Z1                             000000DA 0000001F 1   Z   9(30)X
               V9    15 
*    01  EH2                            000000F9 00000004 1   1        X
                     1.50 
*    01  DH2                            000000FD 00000008 1   2        X
                     1.50 
*    01  LH2                            00000105 00000010 1   3        X
                     1.50 
*    01  EB2                            00000115 00000004 1   4        X
                     1.50 
*    01  DB2                            00000119 00000008 1   5        X
                     1.50 
*    01  LB2                            00000121 00000010 1   6        X
                     1.50 
*    01  ED2                            00000131 00000004 1   7        X
                     1.50 
*    01  DD2                            00000135 00000008 1   8        X
                     1.50 
*    01  LD2                            0000013D 00000010 1   9        X
                     1.50 
*    01  H2                             0000014D 00000002 1   H   9(2)VX
               99    150 
*    01  F2                             0000014F 00000004 1   F   9(6)VX
               999   1500 
*    01  G2                             00000153 00000008 1   G   9(14)X
               V9999 15000 
*    01  Q2                             0000015B 00000010 1   Q   9(34)X
               V9999 150000 
*    01  P2                             0000016B 00000010 1   P   9(25)X
               V9999 1500000 
*    01  Z2                             0000017B 0000001F 1   Z   9(24)X
               V9999 15000000 
*    01  GOOD                           0000019A 00000003 1   P   9(4) X
                     0 
*    01  BAD                            0000019D 00000003 1   P   9(4) X
                     0 
*    01  DEBUG_ITEM                     000001A0 00000058 1   X        X
                      
*    02  DEBUG_LINE                     000001A0 00000006 1   X   X(6) X
                      
*    02  FILLER                         000001A6 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_NAME                     000001A7 0000001E 1   X   X(30)X
                      
*    02  FILLER                         000001C5 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_1                    000001C6 00000004 1   Z   9999 X
                      
*    02  FILLER                         000001CA 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_2                    000001CB 00000004 1   Z   9999 X
                      
*    02  FILLER                         000001CF 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_3                    000001D0 00000004 1   Z   9999 X
                      
*    02  FILLER                         000001D4 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_CONTENTS                 000001D5 00000023 1   X   X(35)X
                      
*    01  TRUE                           000001F8 00000001 1   Z   9    X
                     1 
*    01  FALSE                          000001F9 00000001 1   Z   9    X
                     0 
*    01  RETURN_CODE                    000001FA 00000002 1   H   9(4) X
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
EH1      DC EHL4'1.5'
ZC_WS_LOC_7  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DH1      DC DHL8'1.5'
ZC_WS_LOC_8  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
LH1      DC LHL16'1.5'
ZC_WS_LOC_9  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
EB1      DC EBL4'1.5'
ZC_WS_LOC_10 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DB1      DC DBL8'1.5'
ZC_WS_LOC_11 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
LB1      DC LBL16'1.5'
ZC_WS_LOC_12 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ED1      DC EDL4'1.5'
ZC_WS_LOC_13 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DD1      DC DDL8'1.5'
ZC_WS_LOC_14 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
LD1      DC LDL16'1.5'
ZC_WS_LOC_15 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
H1       DC AL2(15)                  RPI 1065
ZC_WS_LOC_16 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
F1       DC AL4(15)                  RPI 1065
ZC_WS_LOC_17 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
G1       DC FL8'15'                  RPI 1065
ZC_WS_LOC_18 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
Q1       DC FL16'15'                 RPI 1065
ZC_WS_LOC_19 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
P1       DC PL16'15'
ZC_WS_LOC_20 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
Z1       DC ZL31'15'
ZC_WS_LOC_21 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
EH2      DC EHL4'1.50'
ZC_WS_LOC_22 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DH2      DC DHL8'1.50'
ZC_WS_LOC_23 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
LH2      DC LHL16'1.50'
ZC_WS_LOC_24 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
EB2      DC EBL4'1.50'
ZC_WS_LOC_25 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DB2      DC DBL8'1.50'
ZC_WS_LOC_26 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
LB2      DC LBL16'1.50'
ZC_WS_LOC_27 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ED2      DC EDL4'1.50'
ZC_WS_LOC_28 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DD2      DC DDL8'1.50'
ZC_WS_LOC_29 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
LD2      DC LDL16'1.50'
ZC_WS_LOC_30 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
H2       DC AL2(150)                  RPI 1065
ZC_WS_LOC_31 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
F2       DC AL4(1500)                  RPI 1065
ZC_WS_LOC_32 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
G2       DC FL8'15000'                  RPI 1065
ZC_WS_LOC_33 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
Q2       DC FL16'150000'                 RPI 1065
ZC_WS_LOC_34 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
P2       DC PL16'1500000'
ZC_WS_LOC_35 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
Z2       DC ZL31'15000000'
ZC_WS_LOC_36 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
GOOD     DC PL3'0'
ZC_WS_LOC_37 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
BAD      DC PL3'0'
ZC_WS_LOC_38 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_ITEM DS 0CL88
ZC_WS_LOC_39 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_LINE DS CL6
ZC_WS_LOC_40 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_41 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_NAME DS CL30
ZC_WS_LOC_42 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_43 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_1 DS ZL4
ZC_WS_LOC_44 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_45 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_2 DS ZL4
ZC_WS_LOC_46 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_47 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_3 DS ZL4
ZC_WS_LOC_48 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_49 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_CONTENTS DS CL35
ZC_WS_LOC_50 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
TRUE     DC CL1'1'
ZC_WS_LOC_51 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
FALSE    DC CL1'0'
ZC_WS_LOC_52 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
RETURN_CODE DC AL2(0)                  RPI 1065
*    ZCOBOL LINKAGE SECTION DATA ITEMS 
*    LVL DATA NAME                      ADDR     LEN      DUP TYP PIC  X
                     VALUE 
ZC_WSLOC LOCTR 
ZC_WSLOC LOCTR 
ZC_WS_DIFF EQU  *-ZC_WS-508  DIFF BETWEEN ALLOC AND CALC WS
ZC_WS_END DS   0D
         MNOTE *,'ZCOBOL TOTAL SYMBOLS                 = 52'
         MNOTE *,'ZCOBOL TOTAL SYMBOL DUPLICATES       = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL MAX DUP CHAIN    = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL LEVEL 88         = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL SET INDEXES      = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL LINKAGE SECTIONS = 0'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE SECTIONS      = 0'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE PARAGRAPHS    = 3'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE PARAGRAPH DUP = 0'
         END 
