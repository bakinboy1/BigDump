*    ZCOBOL PGM='ZCOBOL\TEST\TESTSUB2' VER=V1.5.06 MM/DD/YY  
*    ZCOBOL OPTIONS=() 
         COPY  TESTSUB2_ZC_LABELS.CPY
*        IDENTIFICATION DIVISION.
*        PROGRAM-ID.    TESTSUB1.
         PRINT NOLIST,NOGEN,NOLISTUSE    SET LIST OPTION FOR INTERNAL CX
               ODE
TESTSUB1 CSECT ,                CSECT WITH PROCEDURE CODE AND WS
         USING *,ZC_R15
         STM   14,12,12+4*(14-14)(13)
         CNOP  4,8             FORCE ZC390PVT TO DOUBLEWORD BOUNDARY
         BRAS  ZC_R8,ZC_LOAD
         USING *,ZC_R8            BASE FOR LOAD AND CICS V5 USE
*
*  THESE FIELDS MUST BE KEPT IN SYNC WITH zcobol\ZC390PVT.CPY
*
         DC    CL8'TESTSUB1'    PVTPGM   ZCOBOL PGM NAME
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
*      * TEST SUBTRACT WITH SCALING FOR IMPLIED DECIMAL                
*        ENVIRONMENT DIVISION.
*        DATA DIVISION.
         PRINT DATA
*        WORKING-STORAGE SECTION.
*        77 EH1 FLOAT-HEX-7       VALUE 4.0.
*        77 DH1 FLOAT-HEX-15      VALUE 4.0.
*        77 LH1 FLOAT-HEX-30      VALUE 4.0.
*        77 EB1 FLOAT-BINARY-7    VALUE 4.0.
*        77 DB1 FLOAT-BINARY-16   VALUE 4.0.
*        77 LB1 FLOAT-BINARY-34   VALUE 4.0.
*        77 ED1 FLOAT-DECIMAL-7   VALUE 4.0.
*        77 DD1 FLOAT-DECIMAL-16  VALUE 4.0.
*        77 LD1 FLOAT-DECIMAL-34  VALUE 4.0.
*        77 H1      COMP PIC S9(1)V999  VALUE 4.0.
*        77 F1      COMP PIC S9(1)V9(8) VALUE 4.0.
*        77 G1      COMP PIC S9(11)V9(7) VALUE 4.0.
*        77 Q1      COMP PIC S9(33)V9(6)   VALUE 4.0.
*        77 P1      COMP-3 PIC S9(16)V9(5) VALUE 4.0.
*        77 Z1             PIC S9(7)V9(4) VALUE 4.0.
*        77 EH2 FLOAT-HEX-7       VALUE 1.00.
*        77 DH2 FLOAT-HEX-15      VALUE 1.00.
*        77 LH2 FLOAT-HEX-30      VALUE 1.00.
*        77 EB2 FLOAT-BINARY-7    VALUE 1.00.
*        77 DB2 FLOAT-BINARY-16   VALUE 1.00.
*        77 LB2 FLOAT-BINARY-34   VALUE 1.00.
*        77 ED2 FLOAT-DECIMAL-7   VALUE 1.00.
*        77 DD2 FLOAT-DECIMAL-16  VALUE 1.00.
*        77 LD2 FLOAT-DECIMAL-34  VALUE 1.00.
*        77 H2      COMP PIC S9(2)V99         VALUE 1.00.
*        77 F2      COMP PIC S9(6)V999        VALUE 1.00.
*        77 G2      COMP PIC S9(14)V9999      VALUE 1.00.
*        77 Q2      COMP PIC S9(34)V99999     VALUE 1.00.
*        77 P2      COMP-3 PIC S9(25)V999999  VALUE 1.00.
*        77 Z2             PIC S9(24)V9999999 VALUE 1.00.
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
*        77 G     COMP-3 PIC 9(4)   VALUE 0.
*        77 B     COMP-3 PIC 9(4)   VALUE 0.
*        PROCEDURE DIVISION.
*ZC   PROCEDURE DIVISION
         PRINT LIST,GEN,LISTUSE TURN PRINT LISTING ON FOR USER CODE GEN
TESTSUB1 CSECT                SWITCH TO PROCEDURE CODE AHEAD OF WS
*        MAINLINE.
PG_MAINLINE DS 0H
*            DISPLAY 'TESTSUB1 TEST SCALED SUBTRACT'
*ZC     58         DISPLAY 'TESTSUB1 TEST SCALED SUBTRACT'
         BRAS  1,*+(WTO#0224_EOT-*+1)/2*2
         DC    AL2(WTO#0224_EOT-*,0),C'TESTSUB1 TEST SCALED SUBTRACT'
WTO#0224_EOT     EQU *
         SVC   35
*            PERFORM INIT.
*ZC     59         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            SUBTRACT EH2 FROM EH1 IF EH3 = EH1 PERFORM G ELSE PERFORM X
               B.
*ZC     60         SUBTRACT EH2,FROM,EH1
         LE    ZC_F0,EH2
         LE    ZC_F1,EH1
         SER   ZC_F1,ZC_F0
         STE   ZC_F1,EH1
*ZC     60         IF    EH3,=,EH1
         LE    ZC_F0,EH3
         CE    ZC_F0,EH1
         BRC   15-ZC_EQ,PG_IF_1_1
*ZC     60         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     60         ELSE
         J     PG_IF_1_E
PG_IF_1_1    DS    0H  &TYPE
*ZC     60         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_1_E    DS    0H  &TYPE
*            SUBTRACT EH2 FROM DH1 IF EH3 = DH1 PERFORM G ELSE PERFORM X
               B.
*ZC     61         SUBTRACT EH2,FROM,DH1
         LE    ZC_F0,EH2
         LDER  ZC_F0,ZC_F0
         LD    ZC_F1,DH1
         SDR   ZC_F1,ZC_F0
         STD   ZC_F1,DH1
*ZC     61         IF    EH3,=,DH1
         LDE   ZC_F0,EH3
         CD    ZC_F0,DH1
         BRC   15-ZC_EQ,PG_IF_2_1
*ZC     61         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     61         ELSE
         J     PG_IF_2_E
PG_IF_2_1    DS    0H  &TYPE
*ZC     61         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_2_E    DS    0H  &TYPE
*            SUBTRACT EH2 FROM LH1 IF EH3 = LH1 PERFORM G ELSE PERFORM X
               B.
*ZC     62         SUBTRACT EH2,FROM,LH1
         LE    ZC_F0,EH2
         LXER  ZC_F0,ZC_F0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         SXR   ZC_F1,ZC_F0
         STD   ZC_F1,LH1
         STD   ZC_F3,8+LH1
*ZC     62         IF    EH3,=,LH1
         LE    ZC_F0,EH3
         LXER  ZC_F0,ZC_F0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_3_1
*ZC     62         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     62         ELSE
         J     PG_IF_3_E
PG_IF_3_1    DS    0H  &TYPE
*ZC     62         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_3_E    DS    0H  &TYPE
*            SUBTRACT EH2 FROM EB1 IF EH3 = EB1 PERFORM G ELSE PERFORM X
               B.
*ZC     63         SUBTRACT EH2,FROM,EB1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LEDBR ZC_F0,ZC_F0
         LE    ZC_F1,EB1
         SEBR  ZC_F1,ZC_F0
         STE   ZC_F1,EB1
*ZC     63         IF    EH3,=,EB1
         LE    ZC_F4,EH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CEB   ZC_F0,EB1
         BRC   15-ZC_EQ,PG_IF_4_1
*ZC     63         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     63         ELSE
         J     PG_IF_4_E
PG_IF_4_1    DS    0H  &TYPE
*ZC     63         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_4_E    DS    0H  &TYPE
*            SUBTRACT EH2 FROM DB1 IF EH3 = DB1 PERFORM G ELSE PERFORM X
               B.
*ZC     64         SUBTRACT EH2,FROM,DB1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DB1
         SDBR  ZC_F1,ZC_F0
         STD   ZC_F1,DB1
*ZC     64         IF    EH3,=,DB1
         LE    ZC_F4,EH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         CDB   ZC_F0,DB1
         BRC   15-ZC_EQ,PG_IF_5_1
*ZC     64         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     64         ELSE
         J     PG_IF_5_E
PG_IF_5_1    DS    0H  &TYPE
*ZC     64         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_5_E    DS    0H  &TYPE
*            SUBTRACT EH2 FROM LB1 IF EH3 = LB1 PERFORM G ELSE PERFORM X
               B.
*ZC     65         SUBTRACT EH2,FROM,LB1
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         SXBR  ZC_F1,ZC_F0
         STD   ZC_F1,LB1
         STD   ZC_F3,8+LB1
*ZC     65         IF    EH3,=,LB1
         LE    ZC_F4,EH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_6_1
*ZC     65         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     65         ELSE
         J     PG_IF_6_E
PG_IF_6_1    DS    0H  &TYPE
*ZC     65         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_6_E    DS    0H  &TYPE
*            SUBTRACT EH2 FROM ED1 IF EH3 = ED1 PERFORM G ELSE PERFORM X
               B.
*ZC     66         SUBTRACT EH2,FROM,ED1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         SDTR  ZC_F1,ZC_F1,ZC_F0
         LEDTR ZC_F1,0,ZC_F1,0
         STE   ZC_F1,ED1
*ZC     66         IF    EH3,=,ED1
         LE    ZC_F4,EH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_7_1
*ZC     66         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     66         ELSE
         J     PG_IF_7_E
PG_IF_7_1    DS    0H  &TYPE
*ZC     66         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_7_E    DS    0H  &TYPE
*            SUBTRACT EH2 FROM DD1 IF EH3 = DD1 PERFORM G ELSE PERFORM X
               B.
*ZC     67         SUBTRACT EH2,FROM,DD1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         SDTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,DD1
*ZC     67         IF    EH3,=,DD1
         LE    ZC_F4,EH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_8_1
*ZC     67         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     67         ELSE
         J     PG_IF_8_E
PG_IF_8_1    DS    0H  &TYPE
*ZC     67         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_8_E    DS    0H  &TYPE
*            SUBTRACT EH2 FROM LD1 IF EH3 = LD1 PERFORM G ELSE PERFORM X
               B.
*ZC     68         SUBTRACT EH2,FROM,LD1
         LE    ZC_F4,EH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         SXTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,LD1
         STD   ZC_F3,8+LD1
*ZC     68         IF    EH3,=,LD1
         LE    ZC_F4,EH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_9_1
*ZC     68         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     68         ELSE
         J     PG_IF_9_E
PG_IF_9_1    DS    0H  &TYPE
*ZC     68         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_9_E    DS    0H  &TYPE
*            SUBTRACT EH2 FROM F1  IF EH3 = F1  PERFORM G ELSE PERFORM X
               B.
*ZC     69         SUBTRACT EH2,FROM,F1
         LE    ZC_F0,EH2
         LARL  ZC_R1,=EH'1E8'
         ME    ZC_R0,0(ZC_R1)
         CFER  ZC_R0,0,ZC_F0
         L     ZC_R1,F1
         SR    ZC_R1,ZC_R0
         ST    ZC_R1,F1
*ZC     69         IF    EH3,=,F1
         LE    ZC_F0,EH3
         L     ZC_R1,F1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E8'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_10_1
*ZC     69         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     69         ELSE
         J     PG_IF_10_E
PG_IF_10_1   DS    0H  &TYPE
*ZC     69         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_10_E   DS    0H  &TYPE
*            SUBTRACT EH2 FROM G1  IF EH3 = G1  PERFORM G ELSE PERFORM X
               B.
*ZC     70         SUBTRACT EH2,FROM,G1
         LE    ZC_F0,EH2
         LARL  ZC_R1,=EH'1E7'
         ME    ZC_R0,0(ZC_R1)
         CGER  ZC_R0,0,ZC_F0
         LG    ZC_R1,G1
         SGR   ZC_R1,ZC_R0
         STG   ZC_R1,G1
*ZC     70         IF    EH3,=,G1
         LE    ZC_F0,EH3
         LG    ZC_R1,G1
         CEGR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E7'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_11_1
*ZC     70         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     70         ELSE
         J     PG_IF_11_E
PG_IF_11_1   DS    0H  &TYPE
*ZC     70         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_11_E   DS    0H  &TYPE
*            SUBTRACT EH2 FROM H1  IF EH3 = H1  PERFORM G ELSE PERFORM X
               B.
*ZC     71         SUBTRACT EH2,FROM,H1
         LE    ZC_F0,EH2
         LARL  ZC_R1,=EH'1E3'
         ME    ZC_R0,0(ZC_R1)
         CFER  ZC_R0,0,ZC_F0
         LH    ZC_R1,H1
         SR    ZC_R1,ZC_R0
         STH   ZC_R1,H1
*ZC     71         IF    EH3,=,H1
         LE    ZC_F0,EH3
         LH    ZC_R1,H1
         CEFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=EH'1E3'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_12_1
*ZC     71         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     71         ELSE
         J     PG_IF_12_E
PG_IF_12_1   DS    0H  &TYPE
*ZC     71         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_12_E   DS    0H  &TYPE
*            SUBTRACT EH2 FROM P1  IF EH3 = P1  PERFORM G ELSE PERFORM X
               B.
*ZC     72         SUBTRACT EH2,FROM,P1
         LE    ZC_F0,EH2
         LARL  ZC_R1,=EH'1E5'
         ME    ZC_R0,0(ZC_R1)
         LER   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         SP    P1,ZCVT_PWORK2
*ZC     72         IF    EH3,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH3
         LARL  ZC_R2,=EH'1E5'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_13_1
*ZC     72         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     72         ELSE
         J     PG_IF_13_E
PG_IF_13_1   DS    0H  &TYPE
*ZC     72         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_13_E   DS    0H  &TYPE
*            SUBTRACT EH2 FROM Q1  IF EH3 = Q1  PERFORM G ELSE PERFORM X
               B.
*ZC     73         SUBTRACT EH2,FROM,Q1
         LE    ZC_F0,EH2
         LARL  ZC_R1,=EH'1E6'
         ME    ZC_R0,0(ZC_R1)
         LER   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LMG   ZC_R2,ZC_R3,Q1
         SLGR  ZC_R3,ZC_R1
         SLBGR ZC_R2,ZC_R0
         STMG  ZC_R2,ZC_R3,Q1
*ZC     73         IF    EH3,=,Q1
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
         LARL  ZC_R2,=EH'1E6'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_14_1
*ZC     73         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     73         ELSE
         J     PG_IF_14_E
PG_IF_14_1   DS    0H  &TYPE
*ZC     73         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_14_E   DS    0H  &TYPE
*            SUBTRACT EH2 FROM Z1  IF EH3 = Z1  PERFORM G ELSE PERFORM X
               B.
*ZC     74         SUBTRACT EH2,FROM,Z1
         LE    ZC_F0,EH2
         LARL  ZC_R1,=EH'1E4'
         ME    ZC_R0,0(ZC_R1)
         LER   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         PACK  ZCVT_PWORK1(6),0+Z1(11) PACK #1 NORMAL
         SP    ZCVT_PWORK1(6),ZCVT_PWORK2
         UNPK  0+Z1(11),0+ZCVT_PWORK1(6) UNPK #1 NORMAL
*ZC     74         IF    EH3,=,Z1
         PACK  ZCVT_PWORK2(16),0+Z1(11) PACK #1 NORMAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EH3
         LARL  ZC_R2,=EH'1E4'
         ME    ZC_R0,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_15_1
*ZC     74         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     74         ELSE
         J     PG_IF_15_E
PG_IF_15_1   DS    0H  &TYPE
*ZC     74         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_15_E   DS    0H  &TYPE
*            PERFORM INIT.
*ZC     75         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            SUBTRACT DH2 FROM EH1 IF DH3 = EH1 PERFORM G ELSE PERFORM X
               B.
*ZC     76         SUBTRACT DH2,FROM,EH1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,EH1
         SER   ZC_F1,ZC_F0
         STE   ZC_F1,EH1
*ZC     76         IF    DH3,=,EH1
         LD    ZC_F0,DH3
         LDE   ZC_F1,EH1
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_16_1
*ZC     76         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     76         ELSE
         J     PG_IF_16_E
PG_IF_16_1   DS    0H  &TYPE
*ZC     76         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_16_E   DS    0H  &TYPE
*            SUBTRACT DH2 FROM DH1 IF DH3 = DH1 PERFORM G ELSE PERFORM X
               B.
*ZC     77         SUBTRACT DH2,FROM,DH1
         LD    ZC_F0,DH2
         LD    ZC_F1,DH1
         SDR   ZC_F1,ZC_F0
         STD   ZC_F1,DH1
*ZC     77         IF    DH3,=,DH1
         LD    ZC_F0,DH3
         CD    ZC_F0,DH1
         BRC   15-ZC_EQ,PG_IF_17_1
*ZC     77         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     77         ELSE
         J     PG_IF_17_E
PG_IF_17_1   DS    0H  &TYPE
*ZC     77         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_17_E   DS    0H  &TYPE
*            SUBTRACT DH2 FROM LH1 IF DH3 = LH1 PERFORM G ELSE PERFORM X
               B.
*ZC     78         SUBTRACT DH2,FROM,LH1
         LD    ZC_F0,DH2
         LXDR  ZC_F0,ZC_F0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         SXR   ZC_F1,ZC_F0
         STD   ZC_F1,LH1
         STD   ZC_F3,8+LH1
*ZC     78         IF    DH3,=,LH1
         LD    ZC_F0,DH3
         LXDR  ZC_F0,ZC_F0
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_18_1
*ZC     78         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     78         ELSE
         J     PG_IF_18_E
PG_IF_18_1   DS    0H  &TYPE
*ZC     78         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_18_E   DS    0H  &TYPE
*            SUBTRACT DH2 FROM EB1 IF DH3 = EB1 PERFORM G ELSE PERFORM X
               B.
*ZC     79         SUBTRACT DH2,FROM,EB1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LEDBR ZC_F0,ZC_F0
         LE    ZC_F1,EB1
         SEBR  ZC_F1,ZC_F0
         STE   ZC_F1,EB1
*ZC     79         IF    DH3,=,EB1
         LE    ZC_F4,EB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DH3
         CDR   ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_19_1
*ZC     79         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     79         ELSE
         J     PG_IF_19_E
PG_IF_19_1   DS    0H  &TYPE
*ZC     79         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_19_E   DS    0H  &TYPE
*            SUBTRACT DH2 FROM DB1 IF DH3 = DB1 PERFORM G ELSE PERFORM X
               B.
*ZC     80         SUBTRACT DH2,FROM,DB1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DB1
         SDBR  ZC_F1,ZC_F0
         STD   ZC_F1,DB1
*ZC     80         IF    DH3,=,DB1
         LD    ZC_F4,DH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         CDB   ZC_F0,DB1
         BRC   15-ZC_EQ,PG_IF_20_1
*ZC     80         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     80         ELSE
         J     PG_IF_20_E
PG_IF_20_1   DS    0H  &TYPE
*ZC     80         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_20_E   DS    0H  &TYPE
*            SUBTRACT DH2 FROM LB1 IF DH3 = LB1 PERFORM G ELSE PERFORM X
               B.
*ZC     81         SUBTRACT DH2,FROM,LB1
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         SXBR  ZC_F1,ZC_F0
         STD   ZC_F1,LB1
         STD   ZC_F3,8+LB1
*ZC     81         IF    DH3,=,LB1
         LD    ZC_F4,DH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_21_1
*ZC     81         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     81         ELSE
         J     PG_IF_21_E
PG_IF_21_1   DS    0H  &TYPE
*ZC     81         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_21_E   DS    0H  &TYPE
*            SUBTRACT DH2 FROM ED1 IF DH3 = ED1 PERFORM G ELSE PERFORM X
               B.
*ZC     82         SUBTRACT DH2,FROM,ED1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         SDTR  ZC_F1,ZC_F1,ZC_F0
         LEDTR ZC_F1,0,ZC_F1,0
         STE   ZC_F1,ED1
*ZC     82         IF    DH3,=,ED1
         LE    ZC_F4,ED1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DH3
         CDR   ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_22_1
*ZC     82         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     82         ELSE
         J     PG_IF_22_E
PG_IF_22_1   DS    0H  &TYPE
*ZC     82         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_22_E   DS    0H  &TYPE
*            SUBTRACT DH2 FROM DD1 IF DH3 = DD1 PERFORM G ELSE PERFORM X
               B.
*ZC     83         SUBTRACT DH2,FROM,DD1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         SDTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,DD1
*ZC     83         IF    DH3,=,DD1
         LD    ZC_F4,DH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_23_1
*ZC     83         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     83         ELSE
         J     PG_IF_23_E
PG_IF_23_1   DS    0H  &TYPE
*ZC     83         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_23_E   DS    0H  &TYPE
*            SUBTRACT DH2 FROM LD1 IF DH3 = LD1 PERFORM G ELSE PERFORM X
               B.
*ZC     84         SUBTRACT DH2,FROM,LD1
         LD    ZC_F4,DH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         SXTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,LD1
         STD   ZC_F3,8+LD1
*ZC     84         IF    DH3,=,LD1
         LD    ZC_F4,DH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_24_1
*ZC     84         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     84         ELSE
         J     PG_IF_24_E
PG_IF_24_1   DS    0H  &TYPE
*ZC     84         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_24_E   DS    0H  &TYPE
*            SUBTRACT DH2 FROM F1  IF DH3 = F1  PERFORM G ELSE PERFORM X
               B.
*ZC     85         SUBTRACT DH2,FROM,F1
         LD    ZC_F0,DH2
         LARL  ZC_R1,=DH'1E8'
         MD    ZC_R0,0(ZC_R1)
         CFDR  ZC_R0,0,ZC_F0
         L     ZC_R1,F1
         SR    ZC_R1,ZC_R0
         ST    ZC_R1,F1
*ZC     85         IF    DH3,=,F1
         LD    ZC_F0,DH3
         L     ZC_R1,F1
         CDFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=DH'1E8'
         MD    ZC_R0,0(ZC_R2)
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_25_1
*ZC     85         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     85         ELSE
         J     PG_IF_25_E
PG_IF_25_1   DS    0H  &TYPE
*ZC     85         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_25_E   DS    0H  &TYPE
*            SUBTRACT DH2 FROM G1  IF DH3 = G1  PERFORM G ELSE PERFORM X
               B.
*ZC     86         SUBTRACT DH2,FROM,G1
         LD    ZC_F0,DH2
         LARL  ZC_R1,=DH'1E7'
         MD    ZC_R0,0(ZC_R1)
         CGDR  ZC_R0,0,ZC_F0
         LG    ZC_R1,G1
         SGR   ZC_R1,ZC_R0
         STG   ZC_R1,G1
*ZC     86         IF    DH3,=,G1
         LD    ZC_F0,DH3
         LG    ZC_R1,G1
         CDGR  ZC_F1,ZC_R1
         LARL  ZC_R2,=DH'1E7'
         MD    ZC_R0,0(ZC_R2)
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_26_1
*ZC     86         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     86         ELSE
         J     PG_IF_26_E
PG_IF_26_1   DS    0H  &TYPE
*ZC     86         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_26_E   DS    0H  &TYPE
*            SUBTRACT DH2 FROM H1  IF DH3 = H1  PERFORM G ELSE PERFORM X
               B.
*ZC     87         SUBTRACT DH2,FROM,H1
         LD    ZC_F0,DH2
         LARL  ZC_R1,=DH'1E3'
         MD    ZC_R0,0(ZC_R1)
         CFDR  ZC_R0,0,ZC_F0
         LH    ZC_R1,H1
         SR    ZC_R1,ZC_R0
         STH   ZC_R1,H1
*ZC     87         IF    DH3,=,H1
         LD    ZC_F0,DH3
         LH    ZC_R1,H1
         CDFR  ZC_F1,ZC_R1
         LARL  ZC_R2,=DH'1E3'
         MD    ZC_R0,0(ZC_R2)
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_27_1
*ZC     87         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     87         ELSE
         J     PG_IF_27_E
PG_IF_27_1   DS    0H  &TYPE
*ZC     87         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_27_E   DS    0H  &TYPE
*            SUBTRACT DH2 FROM P1  IF DH3 = P1  PERFORM G ELSE PERFORM X
               B.
*ZC     88         SUBTRACT DH2,FROM,P1
         LD    ZC_F0,DH2
         LARL  ZC_R1,=DH'1E5'
         MD    ZC_R0,0(ZC_R1)
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         SP    P1,ZCVT_PWORK2
*ZC     88         IF    DH3,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DH3
         LARL  ZC_R2,=DH'1E5'
         MD    ZC_R0,0(ZC_R2)
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_28_1
*ZC     88         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     88         ELSE
         J     PG_IF_28_E
PG_IF_28_1   DS    0H  &TYPE
*ZC     88         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_28_E   DS    0H  &TYPE
*            SUBTRACT DH2 FROM Q1  IF DH3 = Q1  PERFORM G ELSE PERFORM X
               B.
*ZC     89         SUBTRACT DH2,FROM,Q1
         LD    ZC_F0,DH2
         LARL  ZC_R1,=DH'1E6'
         MD    ZC_R0,0(ZC_R1)
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LMG   ZC_R2,ZC_R3,Q1
         SLGR  ZC_R3,ZC_R1
         SLBGR ZC_R2,ZC_R0
         STMG  ZC_R2,ZC_R3,Q1
*ZC     89         IF    DH3,=,Q1
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
         LARL  ZC_R2,=DH'1E6'
         MD    ZC_R0,0(ZC_R2)
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_29_1
*ZC     89         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     89         ELSE
         J     PG_IF_29_E
PG_IF_29_1   DS    0H  &TYPE
*ZC     89         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_29_E   DS    0H  &TYPE
*            SUBTRACT DH2 FROM Z1  IF DH3 = Z1  PERFORM G ELSE PERFORM X
               B.
*ZC     90         SUBTRACT DH2,FROM,Z1
         LD    ZC_F0,DH2
         LARL  ZC_R1,=DH'1E4'
         MD    ZC_R0,0(ZC_R1)
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         PACK  ZCVT_PWORK1(6),0+Z1(11) PACK #1 NORMAL
         SP    ZCVT_PWORK1(6),ZCVT_PWORK2
         UNPK  0+Z1(11),0+ZCVT_PWORK1(6) UNPK #1 NORMAL
*ZC     90         IF    DH3,=,Z1
         PACK  ZCVT_PWORK2(16),0+Z1(11) PACK #1 NORMAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DH3
         LARL  ZC_R2,=DH'1E4'
         MD    ZC_R0,0(ZC_R2)
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_30_1
*ZC     90         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     90         ELSE
         J     PG_IF_30_E
PG_IF_30_1   DS    0H  &TYPE
*ZC     90         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_30_E   DS    0H  &TYPE
*            PERFORM INIT.
*ZC     91         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            SUBTRACT LH2 FROM EH1 IF LH3 = EH1 PERFORM G ELSE PERFORM X
               B.
*ZC     92         SUBTRACT LH2,FROM,EH1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,EH1
         SER   ZC_F1,ZC_F0
         STE   ZC_F1,EH1
*ZC     92         IF    LH3,=,EH1
         LD    ZC_F0,LH3
         LD    ZC_F2,8+LH3
         LXE   ZC_F1,EH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_31_1
*ZC     92         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     92         ELSE
         J     PG_IF_31_E
PG_IF_31_1   DS    0H  &TYPE
*ZC     92         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_31_E   DS    0H  &TYPE
*            SUBTRACT LH2 FROM DH1 IF LH3 = DH1 PERFORM G ELSE PERFORM X
               B.
*ZC     93         SUBTRACT LH2,FROM,DH1
         LD    ZC_F0,LH2
         LD    ZC_F2,8+LH2
         LDXR  ZC_F0,ZC_F0
         LD    ZC_F1,DH1
         SDR   ZC_F1,ZC_F0
         STD   ZC_F1,DH1
*ZC     93         IF    LH3,=,DH1
         LD    ZC_F0,LH3
         LD    ZC_F2,8+LH3
         LXD   ZC_F1,DH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_32_1
*ZC     93         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     93         ELSE
         J     PG_IF_32_E
PG_IF_32_1   DS    0H  &TYPE
*ZC     93         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_32_E   DS    0H  &TYPE
*            SUBTRACT LH2 FROM LH1 IF LH3 = LH1 PERFORM G ELSE PERFORM X
               B.
*ZC     94         SUBTRACT LH2,FROM,LH1
         LD    ZC_F0,LH2
         LD    ZC_F2,8+LH2
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         SXR   ZC_F1,ZC_F0
         STD   ZC_F1,LH1
         STD   ZC_F3,8+LH1
*ZC     94         IF    LH3,=,LH1
         LD    ZC_F0,LH3
         LD    ZC_F2,8+LH3
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_33_1
*ZC     94         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     94         ELSE
         J     PG_IF_33_E
PG_IF_33_1   DS    0H  &TYPE
*ZC     94         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_33_E   DS    0H  &TYPE
*            SUBTRACT LH2 FROM EB1 IF LH3 = EB1 PERFORM G ELSE PERFORM X
               B.
*ZC     95         SUBTRACT LH2,FROM,EB1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LEDBR ZC_F0,ZC_F0
         LE    ZC_F1,EB1
         SEBR  ZC_F1,ZC_F0
         STE   ZC_F1,EB1
*ZC     95         IF    LH3,=,EB1
         LE    ZC_F4,EB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LH3
         LD    ZC_F3,8+LH3
         CXR   ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_34_1
*ZC     95         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     95         ELSE
         J     PG_IF_34_E
PG_IF_34_1   DS    0H  &TYPE
*ZC     95         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_34_E   DS    0H  &TYPE
*            SUBTRACT LH2 FROM DB1 IF LH3 = DB1 PERFORM G ELSE PERFORM X
               B.
*ZC     96         SUBTRACT LH2,FROM,DB1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DB1
         SDBR  ZC_F1,ZC_F0
         STD   ZC_F1,DB1
*ZC     96         IF    LH3,=,DB1
         LD    ZC_F4,DB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LH3
         LD    ZC_F3,8+LH3
         CXR   ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_35_1
*ZC     96         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     96         ELSE
         J     PG_IF_35_E
PG_IF_35_1   DS    0H  &TYPE
*ZC     96         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_35_E   DS    0H  &TYPE
*            SUBTRACT LH2 FROM LB1 IF LH3 = LB1 PERFORM G ELSE PERFORM X
               B.
*ZC     97         SUBTRACT LH2,FROM,LB1
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         SXBR  ZC_F1,ZC_F0
         STD   ZC_F1,LB1
         STD   ZC_F3,8+LB1
*ZC     97         IF    LH3,=,LB1
         LD    ZC_F4,LH3
         LD    ZC_F6,8+LH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_36_1
*ZC     97         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     97         ELSE
         J     PG_IF_36_E
PG_IF_36_1   DS    0H  &TYPE
*ZC     97         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_36_E   DS    0H  &TYPE
*            SUBTRACT LH2 FROM ED1 IF LH3 = ED1 PERFORM G ELSE PERFORM X
               B.
*ZC     98         SUBTRACT LH2,FROM,ED1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         SDTR  ZC_F1,ZC_F1,ZC_F0
         LEDTR ZC_F1,0,ZC_F1,0
         STE   ZC_F1,ED1
*ZC     98         IF    LH3,=,ED1
         LE    ZC_F4,ED1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LH3
         LD    ZC_F3,8+LH3
         CXR   ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_37_1
*ZC     98         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     98         ELSE
         J     PG_IF_37_E
PG_IF_37_1   DS    0H  &TYPE
*ZC     98         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_37_E   DS    0H  &TYPE
*            SUBTRACT LH2 FROM DD1 IF LH3 = DD1 PERFORM G ELSE PERFORM X
               B.
*ZC     99         SUBTRACT LH2,FROM,DD1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         SDTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,DD1
*ZC     99         IF    LH3,=,DD1
         LD    ZC_F4,DD1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LH3
         LD    ZC_F3,8+LH3
         CXR   ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_38_1
*ZC     99         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC     99         ELSE
         J     PG_IF_38_E
PG_IF_38_1   DS    0H  &TYPE
*ZC     99         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_38_E   DS    0H  &TYPE
*            SUBTRACT LH2 FROM LD1 IF LH3 = LD1 PERFORM G ELSE PERFORM X
               B.
*ZC    100         SUBTRACT LH2,FROM,LD1
         LD    ZC_F4,LH2
         LD    ZC_F6,8+LH2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         SXTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,LD1
         STD   ZC_F3,8+LD1
*ZC    100         IF    LH3,=,LD1
         LD    ZC_F4,LD1
         LD    ZC_F6,8+LD1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LH3
         LD    ZC_F3,8+LH3
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_39_1
*ZC    100         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    100         ELSE
         J     PG_IF_39_E
PG_IF_39_1   DS    0H  &TYPE
*ZC    100         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_39_E   DS    0H  &TYPE
*            SUBTRACT LH2 FROM F1  IF LH3 = F1  PERFORM G ELSE PERFORM X
               B.
*ZC    101         SUBTRACT LH2,FROM,F1
         LD    ZC_F0,LH2
         LD    ZC_F2,8+LH2
         LARL  ZC_R1,=LH'1E8'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         MXR   ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    ZC_R0,ZC_R1
         L     ZC_R1,F1
         SR    ZC_R1,ZC_R0
         ST    ZC_R1,F1
*ZC    101         IF    LH3,=,F1
         LD    ZC_F0,LH3
         LD    ZC_F2,8+LH3
         L     ZC_R1,F1
         CXFR  ZC_F1,ZC_R1
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LH'1E8'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXR   ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_40_1
*ZC    101         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    101         ELSE
         J     PG_IF_40_E
PG_IF_40_1   DS    0H  &TYPE
*ZC    101         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_40_E   DS    0H  &TYPE
*            SUBTRACT LH2 FROM G1  IF LH3 = G1  PERFORM G ELSE PERFORM X
               B.
*ZC    102         SUBTRACT LH2,FROM,G1
         LD    ZC_F0,LH2
         LD    ZC_F2,8+LH2
         LARL  ZC_R1,=LH'1E7'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         MXR   ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R0,ZC_R1
         LG    ZC_R1,G1
         SGR   ZC_R1,ZC_R0
         STG   ZC_R1,G1
*ZC    102         IF    LH3,=,G1
         LD    ZC_F0,LH3
         LD    ZC_F2,8+LH3
         LG    ZC_R1,G1
         CXGR  ZC_F1,ZC_R1
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LH'1E7'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXR   ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_41_1
*ZC    102         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    102         ELSE
         J     PG_IF_41_E
PG_IF_41_1   DS    0H  &TYPE
*ZC    102         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_41_E   DS    0H  &TYPE
*            SUBTRACT LH2 FROM H1  IF LH3 = H1  PERFORM G ELSE PERFORM X
               B.
*ZC    103         SUBTRACT LH2,FROM,H1
         LD    ZC_F0,LH2
         LD    ZC_R2,8+LH2
         LARL  ZC_R1,=LH'1E3'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         MXR   ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    ZC_R0,ZC_R1
         LH    ZC_R1,H1
         SR    ZC_R1,ZC_R0
         STH   ZC_R1,H1
*ZC    103         IF    LH3,=,H1
         LD    ZC_F0,LH3
         LD    ZC_F2,8+LH3
         LH    ZC_R1,H1
         CXFR  ZC_F1,ZC_R1
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LH'1E3'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXR   ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_42_1
*ZC    103         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    103         ELSE
         J     PG_IF_42_E
PG_IF_42_1   DS    0H  &TYPE
*ZC    103         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_42_E   DS    0H  &TYPE
*            SUBTRACT LH2 FROM P1  IF LH3 = P1  PERFORM G ELSE PERFORM X
               B.
*ZC    104         SUBTRACT LH2,FROM,P1
         LD    ZC_F0,LH2
         LD    ZC_F2,8+LH2
         LARL  ZC_R1,=LH'1E5'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         MXR   ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         SP    P1,ZCVT_PWORK2
*ZC    104         IF    LH3,=,P1
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
         LARL  ZC_R1,=LH'1E5'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXR   ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_43_1
*ZC    104         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    104         ELSE
         J     PG_IF_43_E
PG_IF_43_1   DS    0H  &TYPE
*ZC    104         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_43_E   DS    0H  &TYPE
*            SUBTRACT LH2 FROM Q1  IF LH3 = Q1  PERFORM G ELSE PERFORM X
               B.
*ZC    105         SUBTRACT LH2,FROM,Q1
         LD    ZC_F0,LH2
         LD    ZC_F2,8+LH2
         LARL  ZC_R1,=LH'1E6'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         MXR   ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LMG   ZC_R2,ZC_R3,Q1
         SLGR  ZC_R3,ZC_R1
         SLBGR ZC_R2,ZC_R0
         STMG  ZC_R2,ZC_R3,Q1
*ZC    105         IF    LH3,=,Q1
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
         LARL  ZC_R1,=LH'1E6'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXR   ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXR   ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_44_1
*ZC    105         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    105         ELSE
         J     PG_IF_44_E
PG_IF_44_1   DS    0H  &TYPE
*ZC    105         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_44_E   DS    0H  &TYPE
*            SUBTRACT LH2 FROM Z1  IF LH3 = Z1  PERFORM G ELSE PERFORM X
               B.
*ZC    106         SUBTRACT LH2,FROM,Z1
         LD    ZC_F0,LH2
         LD    ZC_F2,8+LH2
         LARL  ZC_R1,=LH'1E4'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         MXR   ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         PACK  ZCVT_PWORK1(6),0+Z1(11) PACK #1 NORMAL
         SP    ZCVT_PWORK1(6),ZCVT_PWORK2
         UNPK  0+Z1(11),0+ZCVT_PWORK1(6) UNPK #1 NORMAL
*ZC    106         IF    LH3,=,Z1
         PACK  ZCVT_PWORK2(16),0+Z1(11) PACK #1 NORMAL
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
         LARL  ZC_R1,=LH'1E4'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXR   ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXR   ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_45_1
*ZC    106         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    106         ELSE
         J     PG_IF_45_E
PG_IF_45_1   DS    0H  &TYPE
*ZC    106         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_45_E   DS    0H  &TYPE
*            PERFORM INIT.
*ZC    107         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            SUBTRACT EB2 FROM EH1 IF EB3 = EH1 PERFORM G ELSE PERFORM X
               B.
*ZC    108         SUBTRACT EB2,FROM,EH1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,EH1
         SER   ZC_F1,ZC_F0
         STE   ZC_F1,EH1
*ZC    108         IF    EB3,=,EH1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB3
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_46_1
*ZC    108         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    108         ELSE
         J     PG_IF_46_E
PG_IF_46_1   DS    0H  &TYPE
*ZC    108         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_46_E   DS    0H  &TYPE
*            SUBTRACT EB2 FROM DH1 IF EB3 = DH1 PERFORM G ELSE PERFORM X
               B.
*ZC    109         SUBTRACT EB2,FROM,DH1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DH1
         SDR   ZC_F1,ZC_F0
         STD   ZC_F1,DH1
*ZC    109         IF    EB3,=,DH1
         LD    ZC_F4,DH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB3
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_47_1
*ZC    109         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    109         ELSE
         J     PG_IF_47_E
PG_IF_47_1   DS    0H  &TYPE
*ZC    109         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_47_E   DS    0H  &TYPE
*            SUBTRACT EB2 FROM LH1 IF EB3 = LH1 PERFORM G ELSE PERFORM X
               B.
*ZC    110         SUBTRACT EB2,FROM,LH1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         SXR   ZC_F1,ZC_F0
         STD   ZC_F1,LH1
         STD   ZC_F3,8+LH1
*ZC    110         IF    EB3,=,LH1
         LD    ZC_F4,LH1
         LD    ZC_F6,8+LH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB3
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_48_1
*ZC    110         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    110         ELSE
         J     PG_IF_48_E
PG_IF_48_1   DS    0H  &TYPE
*ZC    110         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_48_E   DS    0H  &TYPE
*            SUBTRACT EB2 FROM EB1 IF EB3 = EB1 PERFORM G ELSE PERFORM X
               B.
*ZC    111         SUBTRACT EB2,FROM,EB1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LEDBR ZC_F0,ZC_F0
         LE    ZC_F1,EB1
         SEBR  ZC_F1,ZC_F0
         STE   ZC_F1,EB1
*ZC    111         IF    EB3,=,EB1
         LE    ZC_F0,EB3
         LE    ZC_F1,EB1
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_49_1
*ZC    111         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    111         ELSE
         J     PG_IF_49_E
PG_IF_49_1   DS    0H  &TYPE
*ZC    111         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_49_E   DS    0H  &TYPE
*            SUBTRACT EB2 FROM DB1 IF EB3 = DB1 PERFORM G ELSE PERFORM X
               B.
*ZC    112         SUBTRACT EB2,FROM,DB1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DB1
         SDBR  ZC_F1,ZC_F0
         STD   ZC_F1,DB1
*ZC    112         IF    EB3,=,DB1
         LD    ZC_F4,DB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB3
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_50_1
*ZC    112         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    112         ELSE
         J     PG_IF_50_E
PG_IF_50_1   DS    0H  &TYPE
*ZC    112         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_50_E   DS    0H  &TYPE
*            SUBTRACT EB2 FROM LB1 IF EB3 = LB1 PERFORM G ELSE PERFORM X
               B.
*ZC    113         SUBTRACT EB2,FROM,LB1
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         SXBR  ZC_F1,ZC_F0
         STD   ZC_F1,LB1
         STD   ZC_F3,8+LB1
*ZC    113         IF    EB3,=,LB1
         LD    ZC_F4,LB1
         LD    ZC_F6,8+LB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB3
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_51_1
*ZC    113         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    113         ELSE
         J     PG_IF_51_E
PG_IF_51_1   DS    0H  &TYPE
*ZC    113         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_51_E   DS    0H  &TYPE
*            SUBTRACT EB2 FROM ED1 IF EB3 = ED1 PERFORM G ELSE PERFORM X
               B.
*ZC    114         SUBTRACT EB2,FROM,ED1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         SDTR  ZC_F1,ZC_F1,ZC_F0
         LEDTR ZC_F1,0,ZC_F1,0
         STE   ZC_F1,ED1
*ZC    114         IF    EB3,=,ED1
         LE    ZC_F4,ED1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB3
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_52_1
*ZC    114         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    114         ELSE
         J     PG_IF_52_E
PG_IF_52_1   DS    0H  &TYPE
*ZC    114         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_52_E   DS    0H  &TYPE
*            SUBTRACT EB2 FROM DD1 IF EB3 = DD1 PERFORM G ELSE PERFORM X
               B.
*ZC    115         SUBTRACT EB2,FROM,DD1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         SDTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,DD1
*ZC    115         IF    EB3,=,DD1
         LD    ZC_F4,DD1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB3
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_53_1
*ZC    115         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    115         ELSE
         J     PG_IF_53_E
PG_IF_53_1   DS    0H  &TYPE
*ZC    115         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_53_E   DS    0H  &TYPE
*            SUBTRACT EB2 FROM LD1 IF EB3 = LD1 PERFORM G ELSE PERFORM X
               B.
*ZC    116         SUBTRACT EB2,FROM,LD1
         LE    ZC_F4,EB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         SXTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,LD1
         STD   ZC_F3,8+LD1
*ZC    116         IF    EB3,=,LD1
         LD    ZC_F4,LD1
         LD    ZC_F6,8+LD1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB3
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_54_1
*ZC    116         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    116         ELSE
         J     PG_IF_54_E
PG_IF_54_1   DS    0H  &TYPE
*ZC    116         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_54_E   DS    0H  &TYPE
*            SUBTRACT EB2 FROM F1  IF EB3 = F1  PERFORM G ELSE PERFORM X
               B.
*ZC    117         SUBTRACT EB2,FROM,F1
         LE    ZC_F0,EB2
         LDEBR ZC_F0,ZC_F0
         LARL  ZC_R1,=DB'1E8'
         MDB   ZC_R0,0(ZC_R1)
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    ZC_R0,ZC_R1
         L     ZC_R1,F1
         SR    ZC_R1,ZC_R0
         ST    ZC_R1,F1
*ZC    117         IF    EB3,=,F1
         LE    ZC_F0,EB3
         L     ZC_R1,F1
         CEFBR ZC_F1,ZC_F1
         LARL  ZC_R2,=EB'1E8'
         MDEB  ZC_F0,0(ZC_R2)
         LEDBR ZC_F0,ZC_F0
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_55_1
*ZC    117         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    117         ELSE
         J     PG_IF_55_E
PG_IF_55_1   DS    0H  &TYPE
*ZC    117         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_55_E   DS    0H  &TYPE
*            SUBTRACT EB2 FROM G1  IF EB3 = G1  PERFORM G ELSE PERFORM X
               B.
*ZC    118         SUBTRACT EB2,FROM,G1
         LE    ZC_F0,EB2
         LDEBR ZC_F0,ZC_F0
         LARL  ZC_R1,=DB'1E7'
         MDB   ZC_R0,0(ZC_R1)
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R0,ZC_R1
         LG    ZC_R1,G1
         SGR   ZC_R1,ZC_R0
         STG   ZC_R1,G1
*ZC    118         IF    EB3,=,G1
         LE    ZC_F0,EB3
         LG    ZC_R1,G1
         CEGBR ZC_F1,ZC_R1
         LARL  ZC_R2,=EB'1E7'
         MDEB  ZC_F0,0(ZC_R2)
         LEDBR ZC_F0,ZC_F0
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_56_1
*ZC    118         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    118         ELSE
         J     PG_IF_56_E
PG_IF_56_1   DS    0H  &TYPE
*ZC    118         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_56_E   DS    0H  &TYPE
*            SUBTRACT EB2 FROM H1  IF EB3 = H1  PERFORM G ELSE PERFORM X
               B.
*ZC    119         SUBTRACT EB2,FROM,H1
         LE    ZC_F0,EB2
         LDEBR ZC_F0,ZC_F0
         LARL  ZC_R1,=DB'1E3'
         MDB   ZC_R0,0(ZC_R1)
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    ZC_R0,ZC_R1
         LH    ZC_R1,H1
         SR    ZC_R1,ZC_R0
         STH   ZC_R1,H1
*ZC    119         IF    EB3,=,H1
         LE    ZC_F0,EB3
         LH    ZC_R1,H1
         CEFBR ZC_F1,ZC_R1
         LARL  ZC_R2,=EB'1E3'
         MDEB  ZC_F0,0(ZC_R2)
         LEDBR ZC_F0,ZC_F0
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_57_1
*ZC    119         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    119         ELSE
         J     PG_IF_57_E
PG_IF_57_1   DS    0H  &TYPE
*ZC    119         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_57_E   DS    0H  &TYPE
*            SUBTRACT EB2 FROM P1  IF EB3 = P1  PERFORM G ELSE PERFORM X
               B.
*ZC    120         SUBTRACT EB2,FROM,P1
         LE    ZC_F0,EB2
         LDEBR ZC_F0,ZC_F0
         LARL  ZC_R1,=DB'1E5'
         MDB   ZC_R0,0(ZC_R1)
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         SP    P1,ZCVT_PWORK2
*ZC    120         IF    EB3,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB3
         LARL  ZC_R2,=EB'1E5'
         MDEB  ZC_F0,0(ZC_R2)
         LEDBR ZC_F0,ZC_F0
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_58_1
*ZC    120         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    120         ELSE
         J     PG_IF_58_E
PG_IF_58_1   DS    0H  &TYPE
*ZC    120         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_58_E   DS    0H  &TYPE
*            SUBTRACT EB2 FROM Q1  IF EB3 = Q1  PERFORM G ELSE PERFORM X
               B.
*ZC    121         SUBTRACT EB2,FROM,Q1
         LE    ZC_F0,EB2
         LDEBR ZC_F0,ZC_F0
         LARL  ZC_R1,=DB'1E6'
         MDB   ZC_R0,0(ZC_R1)
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LMG   ZC_R2,ZC_R3,Q1
         SLGR  ZC_R3,ZC_R1
         SLBGR ZC_R2,ZC_R0
         STMG  ZC_R2,ZC_R3,Q1
*ZC    121         IF    EB3,=,Q1
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
         LARL  ZC_R2,=EB'1E6'
         MDEB  ZC_F0,0(ZC_R2)
         LEDBR ZC_F0,ZC_F0
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_59_1
*ZC    121         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    121         ELSE
         J     PG_IF_59_E
PG_IF_59_1   DS    0H  &TYPE
*ZC    121         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_59_E   DS    0H  &TYPE
*            SUBTRACT EB2 FROM Z1  IF EB3 = Z1  PERFORM G ELSE PERFORM X
               B.
*ZC    122         SUBTRACT EB2,FROM,Z1
         LE    ZC_F0,EB2
         LDEBR ZC_F0,ZC_F0
         LARL  ZC_R1,=DB'1E4'
         MDB   ZC_R0,0(ZC_R1)
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         PACK  ZCVT_PWORK1(6),0+Z1(11) PACK #1 NORMAL
         SP    ZCVT_PWORK1(6),ZCVT_PWORK2
         UNPK  0+Z1(11),0+ZCVT_PWORK1(6) UNPK #1 NORMAL
*ZC    122         IF    EB3,=,Z1
         PACK  ZCVT_PWORK2(16),0+Z1(11) PACK #1 NORMAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LER   ZC_F1,ZC_F0
         LE    ZC_F0,EB3
         LARL  ZC_R2,=EB'1E4'
         MDEB  ZC_F0,0(ZC_R2)
         LEDBR ZC_F0,ZC_F0
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_60_1
*ZC    122         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    122         ELSE
         J     PG_IF_60_E
PG_IF_60_1   DS    0H  &TYPE
*ZC    122         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_60_E   DS    0H  &TYPE
*            PERFORM INIT.
*ZC    123         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            SUBTRACT DB2 FROM EH1 IF DB3 = EH1 PERFORM G ELSE PERFORM X
               B.
*ZC    124         SUBTRACT DB2,FROM,EH1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,EH1
         SER   ZC_F1,ZC_F0
         STE   ZC_F1,EH1
*ZC    124         IF    DB3,=,EH1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB3
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_61_1
*ZC    124         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    124         ELSE
         J     PG_IF_61_E
PG_IF_61_1   DS    0H  &TYPE
*ZC    124         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_61_E   DS    0H  &TYPE
*            SUBTRACT DB2 FROM DH1 IF DB3 = DH1 PERFORM G ELSE PERFORM X
               B.
*ZC    125         SUBTRACT DB2,FROM,DH1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DH1
         SDR   ZC_F1,ZC_F0
         STD   ZC_F1,DH1
*ZC    125         IF    DB3,=,DH1
         LD    ZC_F4,DH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB3
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_62_1
*ZC    125         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    125         ELSE
         J     PG_IF_62_E
PG_IF_62_1   DS    0H  &TYPE
*ZC    125         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_62_E   DS    0H  &TYPE
*            SUBTRACT DB2 FROM LH1 IF DB3 = LH1 PERFORM G ELSE PERFORM X
               B.
*ZC    126         SUBTRACT DB2,FROM,LH1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         SXR   ZC_F1,ZC_F0
         STD   ZC_F1,LH1
         STD   ZC_F3,8+LH1
*ZC    126         IF    DB3,=,LH1
         LD    ZC_F4,LH1
         LD    ZC_F6,8+LH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB3
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_63_1
*ZC    126         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    126         ELSE
         J     PG_IF_63_E
PG_IF_63_1   DS    0H  &TYPE
*ZC    126         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_63_E   DS    0H  &TYPE
*            SUBTRACT DB2 FROM EB1 IF DB3 = EB1 PERFORM G ELSE PERFORM X
               B.
*ZC    127         SUBTRACT DB2,FROM,EB1
         LD    ZC_F0,DB2
         LEDBR ZC_F0,ZC_F0
         LE    ZC_F1,EB1
         SEBR  ZC_F1,ZC_F0
         STE   ZC_F1,EB1
*ZC    127         IF    DB3,=,EB1
         LE    ZC_F4,EB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB3
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_64_1
*ZC    127         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    127         ELSE
         J     PG_IF_64_E
PG_IF_64_1   DS    0H  &TYPE
*ZC    127         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_64_E   DS    0H  &TYPE
*            SUBTRACT DB2 FROM DB1 IF DB3 = DB1 PERFORM G ELSE PERFORM X
               B.
*ZC    128         SUBTRACT DB2,FROM,DB1
         LD    ZC_F0,DB2
         LD    ZC_F1,DB1
         SDBR  ZC_F1,ZC_F0
         STD   ZC_F1,DB1
*ZC    128         IF    DB3,=,DB1
         LD    ZC_F0,DB3
         LD    ZC_F1,DB1
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_65_1
*ZC    128         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    128         ELSE
         J     PG_IF_65_E
PG_IF_65_1   DS    0H  &TYPE
*ZC    128         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_65_E   DS    0H  &TYPE
*            SUBTRACT DB2 FROM LB1 IF DB3 = LB1 PERFORM G ELSE PERFORM X
               B.
*ZC    129         SUBTRACT DB2,FROM,LB1
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         SXBR  ZC_F1,ZC_F0
         STD   ZC_F1,LB1
         STD   ZC_F3,8+LB1
*ZC    129         IF    DB3,=,LB1
         LD    ZC_F4,LB1
         LD    ZC_F6,8+LB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB3
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_66_1
*ZC    129         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    129         ELSE
         J     PG_IF_66_E
PG_IF_66_1   DS    0H  &TYPE
*ZC    129         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_66_E   DS    0H  &TYPE
*            SUBTRACT DB2 FROM ED1 IF DB3 = ED1 PERFORM G ELSE PERFORM X
               B.
*ZC    130         SUBTRACT DB2,FROM,ED1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         SDTR  ZC_F1,ZC_F1,ZC_F0
         LEDTR ZC_F1,0,ZC_F1,0
         STE   ZC_F1,ED1
*ZC    130         IF    DB3,=,ED1
         LE    ZC_F4,ED1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB3
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_67_1
*ZC    130         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    130         ELSE
         J     PG_IF_67_E
PG_IF_67_1   DS    0H  &TYPE
*ZC    130         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_67_E   DS    0H  &TYPE
*            SUBTRACT DB2 FROM DD1 IF DB3 = DD1 PERFORM G ELSE PERFORM X
               B.
*ZC    131         SUBTRACT DB2,FROM,DD1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         SDTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,DD1
*ZC    131         IF    DB3,=,DD1
         LD    ZC_F4,DD1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB3
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_68_1
*ZC    131         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    131         ELSE
         J     PG_IF_68_E
PG_IF_68_1   DS    0H  &TYPE
*ZC    131         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_68_E   DS    0H  &TYPE
*            SUBTRACT DB2 FROM LD1 IF DB3 = LD1 PERFORM G ELSE PERFORM X
               B.
*ZC    132         SUBTRACT DB2,FROM,LD1
         LD    ZC_F4,DB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         SXTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,LD1
         STD   ZC_F3,8+LD1
*ZC    132         IF    DB3,=,LD1
         LD    ZC_F4,LD1
         LD    ZC_F6,8+LD1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB3
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_69_1
*ZC    132         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    132         ELSE
         J     PG_IF_69_E
PG_IF_69_1   DS    0H  &TYPE
*ZC    132         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_69_E   DS    0H  &TYPE
*            SUBTRACT DB2 FROM F1  IF DB3 = F1  PERFORM G ELSE PERFORM X
               B.
*ZC    133         SUBTRACT DB2,FROM,F1
         LD    ZC_F0,DB2
         LARL  ZC_R1,=DB'1E8'
         MDB   ZC_R0,0(ZC_R1)
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    ZC_R0,ZC_R1
         L     ZC_R1,F1
         SR    ZC_R1,ZC_R0
         ST    ZC_R1,F1
*ZC    133         IF    DB3,=,F1
         LD    ZC_F0,DB3
         L     ZC_R1,F1
         CDFBR ZC_F1,ZC_R1
         LARL  ZC_R2,=DB'1E8'
         MDB   ZC_R0,0(ZC_R2)
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_70_1
*ZC    133         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    133         ELSE
         J     PG_IF_70_E
PG_IF_70_1   DS    0H  &TYPE
*ZC    133         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_70_E   DS    0H  &TYPE
*            SUBTRACT DB2 FROM G1  IF DB3 = G1  PERFORM G ELSE PERFORM X
               B.
*ZC    134         SUBTRACT DB2,FROM,G1
         LD    ZC_F0,DB2
         LARL  ZC_R1,=DB'1E7'
         MDB   ZC_R0,0(ZC_R1)
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R0,ZC_R1
         LG    ZC_R1,G1
         SGR   ZC_R1,ZC_R0
         STG   ZC_R1,G1
*ZC    134         IF    DB3,=,G1
         LD    ZC_F0,DB3
         LG    ZC_R1,G1
         CDGBR ZC_F1,ZC_R1
         LARL  ZC_R2,=DB'1E7'
         MDB   ZC_R0,0(ZC_R2)
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_71_1
*ZC    134         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    134         ELSE
         J     PG_IF_71_E
PG_IF_71_1   DS    0H  &TYPE
*ZC    134         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_71_E   DS    0H  &TYPE
*            SUBTRACT DB2 FROM H1  IF DB3 = H1  PERFORM G ELSE PERFORM X
               B.
*ZC    135         SUBTRACT DB2,FROM,H1
         LD    ZC_F0,DB2
         LARL  ZC_R1,=DB'1E3'
         MDB   ZC_R0,0(ZC_R1)
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    ZC_R0,ZC_R1
         LH    ZC_R1,H1
         SR    ZC_R1,ZC_R0
         STH   ZC_R1,H1
*ZC    135         IF    DB3,=,H1
         LD    ZC_F0,DB3
         LH    ZC_R1,H1
         CDFBR ZC_F1,ZC_R1
         LARL  ZC_R2,=DB'1E3'
         MDB   ZC_R0,0(ZC_R2)
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_72_1
*ZC    135         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    135         ELSE
         J     PG_IF_72_E
PG_IF_72_1   DS    0H  &TYPE
*ZC    135         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_72_E   DS    0H  &TYPE
*            SUBTRACT DB2 FROM P1  IF DB3 = P1  PERFORM G ELSE PERFORM X
               B.
*ZC    136         SUBTRACT DB2,FROM,P1
         LD    ZC_F0,DB2
         LARL  ZC_R1,=DB'1E5'
         MDB   ZC_R0,0(ZC_R1)
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         SP    P1,ZCVT_PWORK2
*ZC    136         IF    DB3,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB3
         LARL  ZC_R2,=DB'1E5'
         MDB   ZC_R0,0(ZC_R2)
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_73_1
*ZC    136         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    136         ELSE
         J     PG_IF_73_E
PG_IF_73_1   DS    0H  &TYPE
*ZC    136         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_73_E   DS    0H  &TYPE
*            SUBTRACT DB2 FROM Q1  IF DB3 = Q1  PERFORM G ELSE PERFORM X
               B.
*ZC    137         SUBTRACT DB2,FROM,Q1
         LD    ZC_F0,DB2
         LARL  ZC_R1,=DB'1E6'
         MDB   ZC_R0,0(ZC_R1)
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LMG   ZC_R2,ZC_R3,Q1
         SLGR  ZC_R3,ZC_R1
         SLBGR ZC_R2,ZC_R0
         STMG  ZC_R2,ZC_R3,Q1
*ZC    137         IF    DB3,=,Q1
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
         LARL  ZC_R2,=DB'1E6'
         MDB   ZC_R0,0(ZC_R2)
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_74_1
*ZC    137         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    137         ELSE
         J     PG_IF_74_E
PG_IF_74_1   DS    0H  &TYPE
*ZC    137         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_74_E   DS    0H  &TYPE
*            SUBTRACT DB2 FROM Z1  IF DB3 = Z1  PERFORM G ELSE PERFORM X
               B.
*ZC    138         SUBTRACT DB2,FROM,Z1
         LD    ZC_F0,DB2
         LARL  ZC_R1,=DB'1E4'
         MDB   ZC_R0,0(ZC_R1)
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         PACK  ZCVT_PWORK1(6),0+Z1(11) PACK #1 NORMAL
         SP    ZCVT_PWORK1(6),ZCVT_PWORK2
         UNPK  0+Z1(11),0+ZCVT_PWORK1(6) UNPK #1 NORMAL
*ZC    138         IF    DB3,=,Z1
         PACK  ZCVT_PWORK2(16),0+Z1(11) PACK #1 NORMAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DB3
         LARL  ZC_R2,=DB'1E4'
         MDB   ZC_R0,0(ZC_R2)
         CDBR  ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_75_1
*ZC    138         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    138         ELSE
         J     PG_IF_75_E
PG_IF_75_1   DS    0H  &TYPE
*ZC    138         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_75_E   DS    0H  &TYPE
*            PERFORM INIT.
*ZC    139         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            SUBTRACT LB2 FROM EH1 IF LB3 = EH1 PERFORM G ELSE PERFORM X
               B.
*ZC    140         SUBTRACT LB2,FROM,EH1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,EH1
         SER   ZC_F1,ZC_F0
         STE   ZC_F1,EH1
*ZC    140         IF    LB3,=,EH1
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
*ZC    140         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    140         ELSE
         J     PG_IF_76_E
PG_IF_76_1   DS    0H  &TYPE
*ZC    140         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_76_E   DS    0H  &TYPE
*            SUBTRACT LB2 FROM DH1 IF LB3 = DH1 PERFORM G ELSE PERFORM X
               B.
*ZC    141         SUBTRACT LB2,FROM,DH1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DH1
         SDR   ZC_F1,ZC_F0
         STD   ZC_F1,DH1
*ZC    141         IF    LB3,=,DH1
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
*ZC    141         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    141         ELSE
         J     PG_IF_77_E
PG_IF_77_1   DS    0H  &TYPE
*ZC    141         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_77_E   DS    0H  &TYPE
*            SUBTRACT LB2 FROM LH1 IF LB3 = LH1 PERFORM G ELSE PERFORM X
               B.
*ZC    142         SUBTRACT LB2,FROM,LH1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         SXR   ZC_F1,ZC_F0
         STD   ZC_F1,LH1
         STD   ZC_F3,8+LH1
*ZC    142         IF    LB3,=,LH1
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
*ZC    142         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    142         ELSE
         J     PG_IF_78_E
PG_IF_78_1   DS    0H  &TYPE
*ZC    142         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_78_E   DS    0H  &TYPE
*            SUBTRACT LB2 FROM EB1 IF LB3 = EB1 PERFORM G ELSE PERFORM X
               B.
*ZC    143         SUBTRACT LB2,FROM,EB1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LEDBR ZC_F0,ZC_F0
         LE    ZC_F1,EB1
         SEBR  ZC_F1,ZC_F0
         STE   ZC_F1,EB1
*ZC    143         IF    LB3,=,EB1
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
*ZC    143         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    143         ELSE
         J     PG_IF_79_E
PG_IF_79_1   DS    0H  &TYPE
*ZC    143         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_79_E   DS    0H  &TYPE
*            SUBTRACT LB2 FROM DB1 IF LB3 = DB1 PERFORM G ELSE PERFORM X
               B.
*ZC    144         SUBTRACT LB2,FROM,DB1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DB1
         SDBR  ZC_F1,ZC_F0
         STD   ZC_F1,DB1
*ZC    144         IF    LB3,=,DB1
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
*ZC    144         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    144         ELSE
         J     PG_IF_80_E
PG_IF_80_1   DS    0H  &TYPE
*ZC    144         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_80_E   DS    0H  &TYPE
*            SUBTRACT LB2 FROM LB1 IF LB3 = LB1 PERFORM G ELSE PERFORM X
               B.
*ZC    145         SUBTRACT LB2,FROM,LB1
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         LD    ZC_F0,LB2
         LD    ZC_F2,8+LB2
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         SXBR  ZC_F1,ZC_F0
         STD   ZC_F1,LB1
         STD   ZC_F3,8+LB1
*ZC    145         IF    LB3,=,LB1
         LD    ZC_F0,LB1
         LD    ZC_F2,8+LB1
         LDR   ZC_F1,ZC_F0
         LDR   ZC_F3,ZC_F2
         LD    ZC_F0,LB3
         LD    ZC_F2,8+LB3
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_81_1
*ZC    145         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    145         ELSE
         J     PG_IF_81_E
PG_IF_81_1   DS    0H  &TYPE
*ZC    145         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_81_E   DS    0H  &TYPE
*            SUBTRACT LB2 FROM ED1 IF LB3 = ED1 PERFORM G ELSE PERFORM X
               B.
*ZC    146         SUBTRACT LB2,FROM,ED1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         SDTR  ZC_F1,ZC_F1,ZC_F0
         LEDTR ZC_F1,0,ZC_F1,0
         STE   ZC_F1,ED1
*ZC    146         IF    LB3,=,ED1
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
*ZC    146         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    146         ELSE
         J     PG_IF_82_E
PG_IF_82_1   DS    0H  &TYPE
*ZC    146         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_82_E   DS    0H  &TYPE
*            SUBTRACT LB2 FROM DD1 IF LB3 = DD1 PERFORM G ELSE PERFORM X
               B.
*ZC    147         SUBTRACT LB2,FROM,DD1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         SDTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,DD1
*ZC    147         IF    LB3,=,DD1
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
*ZC    147         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    147         ELSE
         J     PG_IF_83_E
PG_IF_83_1   DS    0H  &TYPE
*ZC    147         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_83_E   DS    0H  &TYPE
*            SUBTRACT LB2 FROM LD1 IF LB3 = LD1 PERFORM G ELSE PERFORM X
               B.
*ZC    148         SUBTRACT LB2,FROM,LD1
         LD    ZC_F4,LB2
         LD    ZC_F6,8+LB2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         SXTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,LD1
         STD   ZC_F3,8+LD1
*ZC    148         IF    LB3,=,LD1
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
*ZC    148         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    148         ELSE
         J     PG_IF_84_E
PG_IF_84_1   DS    0H  &TYPE
*ZC    148         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_84_E   DS    0H  &TYPE
*            SUBTRACT LB2 FROM F1  IF LB3 = F1  PERFORM G ELSE PERFORM X
               B.
*ZC    149         SUBTRACT LB2,FROM,F1
         LD    ZC_F0,LB2
         LD    ZC_F2,8+LB2
         LARL  ZC_R1,=LB'1E8'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         MXBR  ZC_R0,ZC_R1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    ZC_R0,ZC_R1
         L     ZC_R1,F1
         SR    ZC_R1,ZC_R0
         ST    ZC_R1,F1
*ZC    149         IF    LB3,=,F1
         L     ZC_R1,F1
         CXFBR ZC_F1,ZC_R1
         LD    ZC_F0,LB3
         LD    ZC_F2,8+LB3
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LB'1E8'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXBR  ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_85_1
*ZC    149         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    149         ELSE
         J     PG_IF_85_E
PG_IF_85_1   DS    0H  &TYPE
*ZC    149         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_85_E   DS    0H  &TYPE
*            SUBTRACT LB2 FROM G1  IF LB3 = G1  PERFORM G ELSE PERFORM X
               B.
*ZC    150         SUBTRACT LB2,FROM,G1
         LD    ZC_F0,LB2
         LD    ZC_F2,8+LB2
         LARL  ZC_R1,=LB'1E7'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         MXBR  ZC_R0,ZC_R1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R0,ZC_R1
         LG    ZC_R1,G1
         SGR   ZC_R1,ZC_R0
         STG   ZC_R1,G1
*ZC    150         IF    LB3,=,G1
         LG    ZC_R1,G1
         CXGBR ZC_F1,ZC_R1
         LD    ZC_F0,LB3
         LD    ZC_F2,8+LB3
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LB'1E7'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXBR  ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_86_1
*ZC    150         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    150         ELSE
         J     PG_IF_86_E
PG_IF_86_1   DS    0H  &TYPE
*ZC    150         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_86_E   DS    0H  &TYPE
*            SUBTRACT LB2 FROM H1  IF LB3 = H1  PERFORM G ELSE PERFORM X
               B.
*ZC    151         SUBTRACT LB2,FROM,H1
         LD    ZC_F0,LB2
         LD    ZC_F2,8+LB2
         LARL  ZC_R1,=LB'1E3'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         MXBR  ZC_R0,ZC_R1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    ZC_R0,ZC_R1
         LH    ZC_R1,H1
         SR    ZC_R1,ZC_R0
         STH   ZC_R1,H1
*ZC    151         IF    LB3,=,H1
         LH    ZC_R1,H1
         CXGBR ZC_F1,ZC_R1
         LD    ZC_F0,LB3
         LD    ZC_F2,8+LB3
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LB'1E3'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXBR  ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_87_1
*ZC    151         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    151         ELSE
         J     PG_IF_87_E
PG_IF_87_1   DS    0H  &TYPE
*ZC    151         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_87_E   DS    0H  &TYPE
*            SUBTRACT LB2 FROM P1  IF LB3 = P1  PERFORM G ELSE PERFORM X
               B.
*ZC    152         SUBTRACT LB2,FROM,P1
         LD    ZC_F0,LB2
         LD    ZC_F2,8+LB2
         LARL  ZC_R1,=LB'1E5'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         MXBR  ZC_R0,ZC_R1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         SP    P1,ZCVT_PWORK2
*ZC    152         IF    LB3,=,P1
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
         LARL  ZC_R1,=LB'1E5'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXBR  ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_88_1
*ZC    152         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    152         ELSE
         J     PG_IF_88_E
PG_IF_88_1   DS    0H  &TYPE
*ZC    152         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_88_E   DS    0H  &TYPE
*            SUBTRACT LB2 FROM Q1  IF LB3 = Q1  PERFORM G ELSE PERFORM X
               B.
*ZC    153         SUBTRACT LB2,FROM,Q1
         LD    ZC_F0,LB2
         LD    ZC_F2,8+LB2
         LARL  ZC_R1,=LB'1E6'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         MXBR  ZC_R0,ZC_R1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LMG   ZC_R2,ZC_R3,Q1
         SLGR  ZC_R3,ZC_R1
         SLBGR ZC_R2,ZC_R0
         STMG  ZC_R2,ZC_R3,Q1
*ZC    153         IF    LB3,=,Q1
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
         LARL  ZC_R1,=LB'1E6'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXBR  ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_89_1
*ZC    153         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    153         ELSE
         J     PG_IF_89_E
PG_IF_89_1   DS    0H  &TYPE
*ZC    153         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_89_E   DS    0H  &TYPE
*            SUBTRACT LB2 FROM Z1  IF LB3 = Z1  PERFORM G ELSE PERFORM X
               B.
*ZC    154         SUBTRACT LB2,FROM,Z1
         LD    ZC_F0,LB2
         LD    ZC_F2,8+LB2
         LARL  ZC_R1,=LB'1E4'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         MXBR  ZC_R0,ZC_R1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         PACK  ZCVT_PWORK1(6),0+Z1(11) PACK #1 NORMAL
         SP    ZCVT_PWORK1(6),ZCVT_PWORK2
         UNPK  0+Z1(11),0+ZCVT_PWORK1(6) UNPK #1 NORMAL
*ZC    154         IF    LB3,=,Z1
         PACK  ZCVT_PWORK2(16),0+Z1(11) PACK #1 NORMAL
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
         LARL  ZC_R1,=LB'1E4'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXBR  ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_90_1
*ZC    154         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    154         ELSE
         J     PG_IF_90_E
PG_IF_90_1   DS    0H  &TYPE
*ZC    154         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_90_E   DS    0H  &TYPE
*            PERFORM INIT.
*ZC    155         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            SUBTRACT ED2 FROM EH1 IF ED3 = EH1 PERFORM G ELSE PERFORM X
               B.
*ZC    156         SUBTRACT ED2,FROM,EH1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,EH1
         SER   ZC_F1,ZC_F0
         STE   ZC_F1,EH1
*ZC    156         IF    ED3,=,EH1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_91_1
*ZC    156         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    156         ELSE
         J     PG_IF_91_E
PG_IF_91_1   DS    0H  &TYPE
*ZC    156         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_91_E   DS    0H  &TYPE
*            SUBTRACT ED2 FROM DH1 IF ED3 = DH1 PERFORM G ELSE PERFORM X
               B.
*ZC    157         SUBTRACT ED2,FROM,DH1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DH1
         SDR   ZC_F1,ZC_F0
         STD   ZC_F1,DH1
*ZC    157         IF    ED3,=,DH1
         LD    ZC_F4,DH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_92_1
*ZC    157         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    157         ELSE
         J     PG_IF_92_E
PG_IF_92_1   DS    0H  &TYPE
*ZC    157         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_92_E   DS    0H  &TYPE
*            SUBTRACT ED2 FROM LH1 IF ED3 = LH1 PERFORM G ELSE PERFORM X
               B.
*ZC    158         SUBTRACT ED2,FROM,LH1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         SXR   ZC_F1,ZC_F0
         STD   ZC_F1,LH1
         STD   ZC_F3,8+LH1
*ZC    158         IF    ED3,=,LH1
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
*ZC    158         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    158         ELSE
         J     PG_IF_93_E
PG_IF_93_1   DS    0H  &TYPE
*ZC    158         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_93_E   DS    0H  &TYPE
*            SUBTRACT ED2 FROM EB1 IF ED3 = EB1 PERFORM G ELSE PERFORM X
               B.
*ZC    159         SUBTRACT ED2,FROM,EB1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LEDBR ZC_F0,ZC_F0
         LE    ZC_F1,EB1
         SEBR  ZC_F1,ZC_F0
         STE   ZC_F1,EB1
*ZC    159         IF    ED3,=,EB1
         LE    ZC_F4,EB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_94_1
*ZC    159         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    159         ELSE
         J     PG_IF_94_E
PG_IF_94_1   DS    0H  &TYPE
*ZC    159         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_94_E   DS    0H  &TYPE
*            SUBTRACT ED2 FROM DB1 IF ED3 = DB1 PERFORM G ELSE PERFORM X
               B.
*ZC    160         SUBTRACT ED2,FROM,DB1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DB1
         SDBR  ZC_F1,ZC_F0
         STD   ZC_F1,DB1
*ZC    160         IF    ED3,=,DB1
         LD    ZC_F4,DB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_95_1
*ZC    160         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    160         ELSE
         J     PG_IF_95_E
PG_IF_95_1   DS    0H  &TYPE
*ZC    160         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_95_E   DS    0H  &TYPE
*            SUBTRACT ED2 FROM LB1 IF ED3 = LB1 PERFORM G ELSE PERFORM X
               B.
*ZC    161         SUBTRACT ED2,FROM,LB1
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         SXBR  ZC_F1,ZC_F0
         STD   ZC_F1,LB1
         STD   ZC_F3,8+LB1
*ZC    161         IF    ED3,=,LB1
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
*ZC    161         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    161         ELSE
         J     PG_IF_96_E
PG_IF_96_1   DS    0H  &TYPE
*ZC    161         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_96_E   DS    0H  &TYPE
*            SUBTRACT ED2 FROM ED1 IF ED3 = ED1 PERFORM G ELSE PERFORM X
               B.
*ZC    162         SUBTRACT ED2,FROM,ED1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         SDTR  ZC_F1,ZC_F1,ZC_F0
         LEDTR ZC_F1,0,ZC_F1,0
         STE   ZC_F1,ED1
*ZC    162         IF    ED3,=,ED1
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_97_1
*ZC    162         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    162         ELSE
         J     PG_IF_97_E
PG_IF_97_1   DS    0H  &TYPE
*ZC    162         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_97_E   DS    0H  &TYPE
*            SUBTRACT ED2 FROM DD1 IF ED3 = DD1 PERFORM G ELSE PERFORM X
               B.
*ZC    163         SUBTRACT ED2,FROM,DD1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         SDTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,DD1
*ZC    163         IF    ED3,=,DD1
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_98_1
*ZC    163         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    163         ELSE
         J     PG_IF_98_E
PG_IF_98_1   DS    0H  &TYPE
*ZC    163         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_98_E   DS    0H  &TYPE
*            SUBTRACT ED2 FROM LD1 IF ED3 = LD1 PERFORM G ELSE PERFORM X
               B.
*ZC    164         SUBTRACT ED2,FROM,LD1
         LE    ZC_F4,ED2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         SXTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,LD1
         STD   ZC_F3,8+LD1
*ZC    164         IF    ED3,=,LD1
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
*ZC    164         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    164         ELSE
         J     PG_IF_99_E
PG_IF_99_1   DS    0H  &TYPE
*ZC    164         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_99_E   DS    0H  &TYPE
*            SUBTRACT ED2 FROM F1  IF ED3 = F1  PERFORM G ELSE PERFORM X
               B.
*ZC    165         SUBTRACT ED2,FROM,F1
         LE    ZC_F0,ED2
         LDETR ZC_F0,ZC_F0,0
         LARL  ZC_R1,=DD'1E8'
         LD    ZC_F1,0(ZC_R1)
         MDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    ZC_R0,ZC_R1
         L     ZC_R1,F1
         SR    ZC_R1,ZC_R0
         ST    ZC_R1,F1
*ZC    165         IF    ED3,=,F1
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         L     ZC_R1,F1
         CDFTR ZC_F1,0,ZC_R1,0
         LARL  ZC_R2,=DD'1E8'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_100_1
*ZC    165         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    165         ELSE
         J     PG_IF_100_E
PG_IF_100_1  DS    0H  &TYPE
*ZC    165         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_100_E  DS    0H  &TYPE
*            SUBTRACT ED2 FROM G1  IF ED3 = G1  PERFORM G ELSE PERFORM X
               B.
*ZC    166         SUBTRACT ED2,FROM,G1
         LE    ZC_F0,ED2
         LDETR ZC_F0,ZC_F0,0
         LARL  ZC_R1,=DD'1E7'
         LD    ZC_F1,0(ZC_R1)
         MDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R0,ZC_R1
         LG    ZC_R1,G1
         SGR   ZC_R1,ZC_R0
         STG   ZC_R1,G1
*ZC    166         IF    ED3,=,G1
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         LG    ZC_R1,G1
         CDGTR ZC_F1,ZC_R1
         LARL  ZC_R2,=DD'1E7'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_101_1
*ZC    166         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    166         ELSE
         J     PG_IF_101_E
PG_IF_101_1  DS    0H  &TYPE
*ZC    166         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_101_E  DS    0H  &TYPE
*            SUBTRACT ED2 FROM H1  IF ED3 = H1  PERFORM G ELSE PERFORM X
               B.
*ZC    167         SUBTRACT ED2,FROM,H1
         LE    ZC_F0,ED2
         LDETR ZC_F0,ZC_F0,0
         LARL  ZC_R1,=DD'1E3'
         LD    ZC_F1,0(ZC_R1)
         MDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    ZC_R0,ZC_R1
         LH    ZC_R1,H1
         SR    ZC_R1,ZC_R0
         STH   ZC_R1,H1
*ZC    167         IF    ED3,=,H1
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         LH    ZC_R1,H1
         CDFTR ZC_F1,0,ZC_R1,0
         LARL  ZC_R2,=DD'1E3'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_102_1
*ZC    167         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    167         ELSE
         J     PG_IF_102_E
PG_IF_102_1  DS    0H  &TYPE
*ZC    167         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_102_E  DS    0H  &TYPE
*            SUBTRACT ED2 FROM P1  IF ED3 = P1  PERFORM G ELSE PERFORM X
               B.
*ZC    168         SUBTRACT ED2,FROM,P1
         LE    ZC_F0,ED2
         LDETR ZC_F0,ZC_F0,0
         LARL  ZC_R1,=DD'1E5'
         LD    ZC_F1,0(ZC_R1)
         MDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         SP    P1,ZCVT_PWORK2
*ZC    168         IF    ED3,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         LARL  ZC_R2,=DD'1E5'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_103_1
*ZC    168         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    168         ELSE
         J     PG_IF_103_E
PG_IF_103_1  DS    0H  &TYPE
*ZC    168         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_103_E  DS    0H  &TYPE
*            SUBTRACT ED2 FROM Q1  IF ED3 = Q1  PERFORM G ELSE PERFORM X
               B.
*ZC    169         SUBTRACT ED2,FROM,Q1
         LE    ZC_F0,ED2
         LDETR ZC_F0,ZC_F0,0
         LARL  ZC_R1,=DD'1E6'
         LD    ZC_F1,0(ZC_R1)
         MDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LMG   ZC_R2,ZC_R3,Q1
         SLGR  ZC_R3,ZC_R1
         SLBGR ZC_R2,ZC_R0
         STMG  ZC_R2,ZC_R3,Q1
*ZC    169         IF    ED3,=,Q1
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
         LARL  ZC_R2,=DD'1E6'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_104_1
*ZC    169         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    169         ELSE
         J     PG_IF_104_E
PG_IF_104_1  DS    0H  &TYPE
*ZC    169         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_104_E  DS    0H  &TYPE
*            SUBTRACT ED2 FROM Z1  IF ED3 = Z1  PERFORM G ELSE PERFORM X
               B.
*ZC    170         SUBTRACT ED2,FROM,Z1
         LE    ZC_F0,ED2
         LDETR ZC_F0,ZC_F0,0
         LARL  ZC_R1,=DD'1E4'
         LD    ZC_F1,0(ZC_R1)
         MDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         PACK  ZCVT_PWORK1(6),0+Z1(11) PACK #1 NORMAL
         SP    ZCVT_PWORK1(6),ZCVT_PWORK2
         UNPK  0+Z1(11),0+ZCVT_PWORK1(6) UNPK #1 NORMAL
*ZC    170         IF    ED3,=,Z1
         PACK  ZCVT_PWORK2(16),0+Z1(11) PACK #1 NORMAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LE    ZC_F0,ED3
         LDETR ZC_F0,ZC_F0,0
         LARL  ZC_R2,=DD'1E4'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_105_1
*ZC    170         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    170         ELSE
         J     PG_IF_105_E
PG_IF_105_1  DS    0H  &TYPE
*ZC    170         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_105_E  DS    0H  &TYPE
*            PERFORM INIT.
*ZC    171         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            SUBTRACT DD2 FROM EH1 IF DD3 = EH1 PERFORM G ELSE PERFORM X
               B.
*ZC    172         SUBTRACT DD2,FROM,EH1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,EH1
         SER   ZC_F1,ZC_F0
         STE   ZC_F1,EH1
*ZC    172         IF    DD3,=,EH1
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD3
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_106_1
*ZC    172         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    172         ELSE
         J     PG_IF_106_E
PG_IF_106_1  DS    0H  &TYPE
*ZC    172         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_106_E  DS    0H  &TYPE
*            SUBTRACT DD2 FROM DH1 IF DD3 = DH1 PERFORM G ELSE PERFORM X
               B.
*ZC    173         SUBTRACT DD2,FROM,DH1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DH1
         SDR   ZC_F1,ZC_F0
         STD   ZC_F1,DH1
*ZC    173         IF    DD3,=,DH1
         LD    ZC_F4,DH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD3
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_107_1
*ZC    173         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    173         ELSE
         J     PG_IF_107_E
PG_IF_107_1  DS    0H  &TYPE
*ZC    173         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_107_E  DS    0H  &TYPE
*            SUBTRACT DD2 FROM LH1 IF DD3 = LH1 PERFORM G ELSE PERFORM X
               B.
*ZC    174         SUBTRACT DD2,FROM,LH1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         SXR   ZC_F1,ZC_F0
         STD   ZC_F1,LH1
         STD   ZC_F3,8+LH1
*ZC    174         IF    DD3,=,LH1
         LD    ZC_F4,LH1
         LD    ZC_F6,8+LH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD3
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_108_1
*ZC    174         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    174         ELSE
         J     PG_IF_108_E
PG_IF_108_1  DS    0H  &TYPE
*ZC    174         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_108_E  DS    0H  &TYPE
*            SUBTRACT DD2 FROM EB1 IF DD3 = EB1 PERFORM G ELSE PERFORM X
               B.
*ZC    175         SUBTRACT DD2,FROM,EB1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LEDBR ZC_F0,ZC_F0
         LE    ZC_F1,EB1
         SEBR  ZC_F1,ZC_F0
         STE   ZC_F1,EB1
*ZC    175         IF    DD3,=,EB1
         LE    ZC_F4,EB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD3
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_109_1
*ZC    175         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    175         ELSE
         J     PG_IF_109_E
PG_IF_109_1  DS    0H  &TYPE
*ZC    175         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_109_E  DS    0H  &TYPE
*            SUBTRACT DD2 FROM DB1 IF DD3 = DB1 PERFORM G ELSE PERFORM X
               B.
*ZC    176         SUBTRACT DD2,FROM,DB1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DB1
         SDBR  ZC_F1,ZC_F0
         STD   ZC_F1,DB1
*ZC    176         IF    DD3,=,DB1
         LD    ZC_F4,DB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD3
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_110_1
*ZC    176         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    176         ELSE
         J     PG_IF_110_E
PG_IF_110_1  DS    0H  &TYPE
*ZC    176         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_110_E  DS    0H  &TYPE
*            SUBTRACT DD2 FROM LB1 IF DD3 = LB1 PERFORM G ELSE PERFORM X
               B.
*ZC    177         SUBTRACT DD2,FROM,LB1
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         SXBR  ZC_F1,ZC_F0
         STD   ZC_F1,LB1
         STD   ZC_F3,8+LB1
*ZC    177         IF    DD3,=,LB1
         LD    ZC_F4,LB1
         LD    ZC_F6,8+LB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD3
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_111_1
*ZC    177         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    177         ELSE
         J     PG_IF_111_E
PG_IF_111_1  DS    0H  &TYPE
*ZC    177         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_111_E  DS    0H  &TYPE
*            SUBTRACT DD2 FROM ED1 IF DD3 = ED1 PERFORM G ELSE PERFORM X
               B.
*ZC    178         SUBTRACT DD2,FROM,ED1
         LD    ZC_F0,DD2
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         SDTR  ZC_F1,ZC_F1,ZC_F0
         LEDTR ZC_F1,0,ZC_F1,0
         STE   ZC_F1,ED1
*ZC    178         IF    DD3,=,ED1
         LE    ZC_F4,ED1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD3
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_112_1
*ZC    178         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    178         ELSE
         J     PG_IF_112_E
PG_IF_112_1  DS    0H  &TYPE
*ZC    178         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_112_E  DS    0H  &TYPE
*            SUBTRACT DD2 FROM DD1 IF DD3 = DD1 PERFORM G ELSE PERFORM X
               B.
*ZC    179         SUBTRACT DD2,FROM,DD1
         LD    ZC_F0,DD2
         LD    ZC_F1,DD1
         SDTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,DD1
*ZC    179         IF    DD3,=,DD1
         LD    ZC_F0,DD3
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_113_1
*ZC    179         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    179         ELSE
         J     PG_IF_113_E
PG_IF_113_1  DS    0H  &TYPE
*ZC    179         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_113_E  DS    0H  &TYPE
*            SUBTRACT DD2 FROM LD1 IF DD3 = LD1 PERFORM G ELSE PERFORM X
               B.
*ZC    180         SUBTRACT DD2,FROM,LD1
         LD    ZC_F4,DD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         SXTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,LD1
         STD   ZC_F3,8+LD1
*ZC    180         IF    DD3,=,LD1
         LD    ZC_F4,LD1
         LD    ZC_F6,8+LD1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD3
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_114_1
*ZC    180         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    180         ELSE
         J     PG_IF_114_E
PG_IF_114_1  DS    0H  &TYPE
*ZC    180         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_114_E  DS    0H  &TYPE
*            SUBTRACT DD2 FROM F1  IF DD3 = F1  PERFORM G ELSE PERFORM X
               B.
*ZC    181         SUBTRACT DD2,FROM,F1
         LD    ZC_F0,DD2
         LARL  ZC_R1,=DD'1E8'
         LD    ZC_F1,0(ZC_R1)
         MDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    ZC_R0,ZC_R1
         L     ZC_R1,F1
         SR    ZC_R1,ZC_R0
         ST    ZC_R1,F1
*ZC    181         IF    DD3,=,F1
         LD    ZC_F0,DD3
         L     ZC_R1,F1
         CDFTR ZC_F1,0,ZC_R1,0
         LARL  ZC_R2,=DD'1E8'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_115_1
*ZC    181         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    181         ELSE
         J     PG_IF_115_E
PG_IF_115_1  DS    0H  &TYPE
*ZC    181         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_115_E  DS    0H  &TYPE
*            SUBTRACT DD2 FROM G1  IF DD3 = G1  PERFORM G ELSE PERFORM X
               B.
*ZC    182         SUBTRACT DD2,FROM,G1
         LD    ZC_F0,DD2
         LARL  ZC_R1,=DD'1E7'
         LD    ZC_F1,0(ZC_R1)
         MDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R0,ZC_R1
         LG    ZC_R1,G1
         SGR   ZC_R1,ZC_R0
         STG   ZC_R1,G1
*ZC    182         IF    DD3,=,G1
         LD    ZC_F0,DD3
         LG    ZC_R1,G1
         CDGTR ZC_F1,ZC_R1
         LARL  ZC_R2,=DD'1E7'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_116_1
*ZC    182         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    182         ELSE
         J     PG_IF_116_E
PG_IF_116_1  DS    0H  &TYPE
*ZC    182         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_116_E  DS    0H  &TYPE
*            SUBTRACT DD2 FROM H1  IF DD3 = H1  PERFORM G ELSE PERFORM X
               B.
*ZC    183         SUBTRACT DD2,FROM,H1
         LD    ZC_F0,DD2
         LARL  ZC_R1,=DD'1E3'
         LD    ZC_F1,0(ZC_R1)
         MDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    ZC_R0,ZC_R1
         LH    ZC_R1,H1
         SR    ZC_R1,ZC_R0
         STH   ZC_R1,H1
*ZC    183         IF    DD3,=,H1
         LD    ZC_F0,DD3
         LH    ZC_R1,H1
         CDFTR ZC_F1,0,ZC_R1,0
         LARL  ZC_R2,=DD'1E3'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_117_1
*ZC    183         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    183         ELSE
         J     PG_IF_117_E
PG_IF_117_1  DS    0H  &TYPE
*ZC    183         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_117_E  DS    0H  &TYPE
*            SUBTRACT DD2 FROM P1  IF DD3 = P1  PERFORM G ELSE PERFORM X
               B.
*ZC    184         SUBTRACT DD2,FROM,P1
         LD    ZC_F0,DD2
         LARL  ZC_R1,=DD'1E5'
         LD    ZC_F1,0(ZC_R1)
         MDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         SP    P1,ZCVT_PWORK2
*ZC    184         IF    DD3,=,P1
         ZAP   ZCVT_PWORK2,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LDR   ZC_F1,ZC_F0
         LD    ZC_F0,DD3
         LARL  ZC_R2,=DD'1E5'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_118_1
*ZC    184         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    184         ELSE
         J     PG_IF_118_E
PG_IF_118_1  DS    0H  &TYPE
*ZC    184         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_118_E  DS    0H  &TYPE
*            SUBTRACT DD2 FROM Q1  IF DD3 = Q1  PERFORM G ELSE PERFORM X
               B.
*ZC    185         SUBTRACT DD2,FROM,Q1
         LD    ZC_F0,DD2
         LARL  ZC_R1,=DD'1E6'
         LD    ZC_F1,0(ZC_R1)
         MDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LMG   ZC_R2,ZC_R3,Q1
         SLGR  ZC_R3,ZC_R1
         SLBGR ZC_R2,ZC_R0
         STMG  ZC_R2,ZC_R3,Q1
*ZC    185         IF    DD3,=,Q1
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
         LARL  ZC_R2,=DD'1E6'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_119_1
*ZC    185         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    185         ELSE
         J     PG_IF_119_E
PG_IF_119_1  DS    0H  &TYPE
*ZC    185         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_119_E  DS    0H  &TYPE
*            SUBTRACT DD2 FROM Z1  IF DD3 = Z1  PERFORM G ELSE PERFORM X
               B.
*ZC    186         SUBTRACT DD2,FROM,Z1
         LD    ZC_F0,DD2
         LARL  ZC_R1,=DD'1E4'
         LD    ZC_F1,0(ZC_R1)
         MDTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         PACK  ZCVT_PWORK1(6),0+Z1(11) PACK #1 NORMAL
         SP    ZCVT_PWORK1(6),ZCVT_PWORK2
         UNPK  0+Z1(11),0+ZCVT_PWORK1(6) UNPK #1 NORMAL
*ZC    186         IF    DD3,=,Z1
         PACK  ZCVT_PWORK2(16),0+Z1(11) PACK #1 NORMAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F0,ZC_R0
         LDXTR ZC_F1,0,ZC_F0,0
         LD    ZC_F0,DD3
         LARL  ZC_R2,=DD'1E4'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F0,ZC_F0,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_120_1
*ZC    186         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    186         ELSE
         J     PG_IF_120_E
PG_IF_120_1  DS    0H  &TYPE
*ZC    186         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_120_E  DS    0H  &TYPE
*            PERFORM INIT.
*ZC    187         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            SUBTRACT LD2 FROM EH1 IF LD3 = EH1 PERFORM G ELSE PERFORM X
               B.
*ZC    188         SUBTRACT LD2,FROM,EH1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,EH1
         SER   ZC_F1,ZC_F0
         STE   ZC_F1,EH1
*ZC    188         IF    LD3,=,EH1
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
*ZC    188         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    188         ELSE
         J     PG_IF_121_E
PG_IF_121_1  DS    0H  &TYPE
*ZC    188         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_121_E  DS    0H  &TYPE
*            SUBTRACT LD2 FROM DH1 IF LD3 = DH1 PERFORM G ELSE PERFORM X
               B.
*ZC    189         SUBTRACT LD2,FROM,DH1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DH1
         SDR   ZC_F1,ZC_F0
         STD   ZC_F1,DH1
*ZC    189         IF    LD3,=,DH1
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
*ZC    189         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    189         ELSE
         J     PG_IF_122_E
PG_IF_122_1  DS    0H  &TYPE
*ZC    189         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_122_E  DS    0H  &TYPE
*            SUBTRACT LD2 FROM LH1 IF LD3 = LH1 PERFORM G ELSE PERFORM X
               B.
*ZC    190         SUBTRACT LD2,FROM,LH1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         SXR   ZC_F1,ZC_F0
         STD   ZC_F1,LH1
         STD   ZC_F3,8+LH1
*ZC    190         IF    LD3,=,LH1
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
*ZC    190         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    190         ELSE
         J     PG_IF_123_E
PG_IF_123_1  DS    0H  &TYPE
*ZC    190         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_123_E  DS    0H  &TYPE
*            SUBTRACT LD2 FROM EB1 IF LD3 = EB1 PERFORM G ELSE PERFORM X
               B.
*ZC    191         SUBTRACT LD2,FROM,EB1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LEDBR ZC_F0,ZC_F0
         LE    ZC_F1,EB1
         SEBR  ZC_F1,ZC_F0
         STE   ZC_F1,EB1
*ZC    191         IF    LD3,=,EB1
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
*ZC    191         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    191         ELSE
         J     PG_IF_124_E
PG_IF_124_1  DS    0H  &TYPE
*ZC    191         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_124_E  DS    0H  &TYPE
*            SUBTRACT LD2 FROM DB1 IF LD3 = DB1 PERFORM G ELSE PERFORM X
               B.
*ZC    192         SUBTRACT LD2,FROM,DB1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DB1
         SDBR  ZC_F1,ZC_F0
         STD   ZC_F1,DB1
*ZC    192         IF    LD3,=,DB1
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
*ZC    192         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    192         ELSE
         J     PG_IF_125_E
PG_IF_125_1  DS    0H  &TYPE
*ZC    192         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_125_E  DS    0H  &TYPE
*            SUBTRACT LD2 FROM LB1 IF LD3 = LB1 PERFORM G ELSE PERFORM X
               B.
*ZC    193         SUBTRACT LD2,FROM,LB1
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         SXBR  ZC_F1,ZC_F0
         STD   ZC_F1,LB1
         STD   ZC_F3,8+LB1
*ZC    193         IF    LD3,=,LB1
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
*ZC    193         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    193         ELSE
         J     PG_IF_126_E
PG_IF_126_1  DS    0H  &TYPE
*ZC    193         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_126_E  DS    0H  &TYPE
*            SUBTRACT LD2 FROM ED1 IF LD3 = ED1 PERFORM G ELSE PERFORM X
               B.
*ZC    194         SUBTRACT LD2,FROM,ED1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         SDTR  ZC_F1,ZC_F1,ZC_F0
         LEDTR ZC_F1,0,ZC_F1,0
         STE   ZC_F1,ED1
*ZC    194         IF    LD3,=,ED1
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
*ZC    194         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    194         ELSE
         J     PG_IF_127_E
PG_IF_127_1  DS    0H  &TYPE
*ZC    194         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_127_E  DS    0H  &TYPE
*            SUBTRACT LD2 FROM DD1 IF LD3 = DD1 PERFORM G ELSE PERFORM X
               B.
*ZC    195         SUBTRACT LD2,FROM,DD1
         LD    ZC_F4,LD2
         LD    ZC_F6,8+LD2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         SDTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,DD1
*ZC    195         IF    LD3,=,DD1
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
*ZC    195         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    195         ELSE
         J     PG_IF_128_E
PG_IF_128_1  DS    0H  &TYPE
*ZC    195         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_128_E  DS    0H  &TYPE
*            SUBTRACT LD2 FROM LD1 IF LD3 = LD1 PERFORM G ELSE PERFORM X
               B.
*ZC    196         SUBTRACT LD2,FROM,LD1
         LD    ZC_F0,LD2
         LD    ZC_F2,8+LD2
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         SXTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,LD1
         STD   ZC_F3,8+LD1
*ZC    196         IF    LD3,=,LD1
         LD    ZC_F0,LD3
         LD    ZC_F2,8+LD3
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_129_1
*ZC    196         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    196         ELSE
         J     PG_IF_129_E
PG_IF_129_1  DS    0H  &TYPE
*ZC    196         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_129_E  DS    0H  &TYPE
*            SUBTRACT LD2 FROM F1  IF LD3 = F1  PERFORM G ELSE PERFORM X
               B.
*ZC    197         SUBTRACT LD2,FROM,F1
         LD    ZC_F0,LD2
         LD    ZC_F2,8+LD2
         LARL  ZC_R1,=LD'1E8'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         MXTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    ZC_R0,ZC_R1
         L     ZC_R1,F1
         SR    ZC_R1,ZC_R0
         ST    ZC_R1,F1
*ZC    197         IF    LD3,=,F1
         LD    ZC_F0,LD3
         LD    ZC_F2,8+LD3
         L     ZC_F1,F1
         CXFTR ZC_F1,0,ZC_R1,0
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LD'1E8'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_130_1
*ZC    197         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    197         ELSE
         J     PG_IF_130_E
PG_IF_130_1  DS    0H  &TYPE
*ZC    197         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_130_E  DS    0H  &TYPE
*            SUBTRACT LD2 FROM G1  IF LD3 = G1  PERFORM G ELSE PERFORM X
               B.
*ZC    198         SUBTRACT LD2,FROM,G1
         LD    ZC_F0,LD2
         LD    ZC_F2,8+LD2
         LARL  ZC_R1,=LD'1E7'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         MXTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R0,ZC_R1
         LG    ZC_R1,G1
         SGR   ZC_R1,ZC_R0
         STG   ZC_R1,G1
*ZC    198         IF    LD3,=,G1
         LD    ZC_F0,LD3
         LD    ZC_F2,8+LD3
         LG    ZC_F1,G1
         CXGTR ZC_F1,ZC_R1
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LD'1E7'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_131_1
*ZC    198         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    198         ELSE
         J     PG_IF_131_E
PG_IF_131_1  DS    0H  &TYPE
*ZC    198         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_131_E  DS    0H  &TYPE
*            SUBTRACT LD2 FROM H1  IF LD3 = H1  PERFORM G ELSE PERFORM X
               B.
*ZC    199         SUBTRACT LD2,FROM,H1
         LD    ZC_F0,LD2
         LD    ZC_F2,8+LD2
         LARL  ZC_R1,=LD'1E3'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         MXTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    ZC_R0,ZC_R1
         LH    ZC_R1,H1
         SR    ZC_R1,ZC_R0
         STH   ZC_R1,H1
*ZC    199         IF    LD3,=,H1
         LD    ZC_F0,LD3
         LD    ZC_F2,8+LD3
         LH    ZC_F1,H1
         CXFTR ZC_F1,0,ZC_R1,0
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LD'1E3'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_132_1
*ZC    199         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    199         ELSE
         J     PG_IF_132_E
PG_IF_132_1  DS    0H  &TYPE
*ZC    199         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_132_E  DS    0H  &TYPE
*            SUBTRACT LD2 FROM P1  IF LD3 = P1  PERFORM G ELSE PERFORM X
               B.
*ZC    200         SUBTRACT LD2,FROM,P1
         LD    ZC_F0,LD2
         LD    ZC_F2,8+LD2
         LARL  ZC_R1,=LD'1E5'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         MXTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         SP    P1,ZCVT_PWORK2
*ZC    200         IF    LD3,=,P1
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
         LARL  ZC_R1,=LD'1E5'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXTR  ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_133_1
*ZC    200         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    200         ELSE
         J     PG_IF_133_E
PG_IF_133_1  DS    0H  &TYPE
*ZC    200         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_133_E  DS    0H  &TYPE
*            SUBTRACT LD2 FROM Q1  IF LD3 = Q1  PERFORM G ELSE PERFORM X
               B.
*ZC    201         SUBTRACT LD2,FROM,Q1
         LD    ZC_F0,LD2
         LD    ZC_F2,8+LD2
         LARL  ZC_R1,=LD'1E6'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         MXTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LMG   ZC_R2,ZC_R3,Q1
         SLGR  ZC_R3,ZC_R1
         SLBGR ZC_R2,ZC_R0
         STMG  ZC_R2,ZC_R3,Q1
*ZC    201         IF    LD3,=,Q1
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
         LARL  ZC_R1,=LD'1E6'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXTR  ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_134_1
*ZC    201         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    201         ELSE
         J     PG_IF_134_E
PG_IF_134_1  DS    0H  &TYPE
*ZC    201         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_134_E  DS    0H  &TYPE
*            SUBTRACT LD2 FROM Z1  IF LD3 = Z1  PERFORM G ELSE PERFORM X
               B.
*ZC    202         SUBTRACT LD2,FROM,Z1
         LD    ZC_F0,LD2
         LD    ZC_F2,8+LD2
         LARL  ZC_R1,=LD'1E4'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         MXTR  ZC_F0,ZC_F0,ZC_F1
         LDR   ZC_F4,ZC_F0
         LDR   ZC_F6,ZC_F2
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         PACK  ZCVT_PWORK1(6),0+Z1(11) PACK #1 NORMAL
         SP    ZCVT_PWORK1(6),ZCVT_PWORK2
         UNPK  0+Z1(11),0+ZCVT_PWORK1(6) UNPK #1 NORMAL
*ZC    202         IF    LD3,=,Z1
         PACK  ZCVT_PWORK2(16),0+Z1(11) PACK #1 NORMAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F1,ZC_R0
         LD    ZC_F0,LD3
         LD    ZC_F2,8+LD3
         STD   ZC_F1,ZCVT_PWORK
         STD   ZC_F3,ZCVT_PWORK+8
         LARL  ZC_R1,=LD'1E4'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_PWORK
         LD    ZC_F3,ZCVT_PWORK+8
         CXTR  ZC_F1,ZC_F0
         BRC   15-ZC_EQ,PG_IF_135_1
*ZC    202         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    202         ELSE
         J     PG_IF_135_E
PG_IF_135_1  DS    0H  &TYPE
*ZC    202         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_135_E  DS    0H  &TYPE
*            PERFORM INIT.
*ZC    203         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            SUBTRACT F2  FROM EH1 IF F3  = EH1 PERFORM G ELSE PERFORM X
               B.
*ZC    204         SUBTRACT F2,FROM,EH1
         L     ZC_R0,F2
         CEFR  ZC_F0,ZC_R0
         LARL  ZC_R1,=EH'1E3'
         DE    ZC_R0,0(ZC_R1)
         LE    ZC_F1,EH1
         SER   ZC_F1,ZC_F0
         STE   ZC_F1,EH1
*ZC    204         IF    F3,=,EH1
         L     ZC_R0,F3
         CEFR  ZC_F0,ZC_R0
         LE    ZC_F1,EH1
         LARL  ZC_R2,=EH'1E3'
         ME    ZC_R1,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_136_1
*ZC    204         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    204         ELSE
         J     PG_IF_136_E
PG_IF_136_1  DS    0H  &TYPE
*ZC    204         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_136_E  DS    0H  &TYPE
*            SUBTRACT F2  FROM DH1 IF F3  = DH1 PERFORM G ELSE PERFORM X
               B.
*ZC    205         SUBTRACT F2,FROM,DH1
         L     ZC_R0,F2
         CDFR  ZC_F0,ZC_R0
         LARL  ZC_R1,=DH'1E3'
         DD    ZC_R0,0(ZC_R1)
         LD    ZC_F1,DH1
         SDR   ZC_F1,ZC_F0
         STD   ZC_F1,DH1
*ZC    205         IF    F3,=,DH1
         L     ZC_R0,F3
         CDFR  ZC_F0,ZC_R0
         LD    ZC_F1,DH1
         LARL  ZC_R2,=DH'1E3'
         MD    ZC_R1,0(ZC_R2)
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_137_1
*ZC    205         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    205         ELSE
         J     PG_IF_137_E
PG_IF_137_1  DS    0H  &TYPE
*ZC    205         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_137_E  DS    0H  &TYPE
*            SUBTRACT F2  FROM LH1 IF F3  = LH1 PERFORM G ELSE PERFORM X
               B.
*ZC    206         SUBTRACT F2,FROM,LH1
         L     ZC_R0,F2
         CXFR  ZC_F0,ZC_R0
         LARL  ZC_R1,=LH'1E3'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXR   ZC_F0,ZC_F1
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         SXR   ZC_F1,ZC_F0
         STD   ZC_F1,LH1
         STD   ZC_F3,8+LH1
*ZC    206         IF    F3,=,LH1
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
*ZC    206         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    206         ELSE
         J     PG_IF_138_E
PG_IF_138_1  DS    0H  &TYPE
*ZC    206         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_138_E  DS    0H  &TYPE
*            SUBTRACT F2  FROM EB1 IF F3  = EB1 PERFORM G ELSE PERFORM X
               B.
*ZC    207         SUBTRACT F2,FROM,EB1
         L     ZC_R0,F2
         CDFBR ZC_F0,ZC_R0
         LARL  ZC_R1,=DB'1E3'
         DDB   ZC_R0,0(ZC_R1)
         LEDBR ZC_F0,ZC_F0
         LE    ZC_F1,EB1
         SEBR  ZC_F1,ZC_F0
         STE   ZC_F1,EB1
*ZC    207         IF    F3,=,EB1
         L     ZC_R0,F3
         CEFBR ZC_F0,ZC_R0
         LE    ZC_F1,EB1
         LARL  ZC_R2,=EB'1E3'
         MDEB  ZC_F1,0(ZC_R2)
         LEDBR ZC_F1,ZC_F1
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_139_1
*ZC    207         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    207         ELSE
         J     PG_IF_139_E
PG_IF_139_1  DS    0H  &TYPE
*ZC    207         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_139_E  DS    0H  &TYPE
*            SUBTRACT F2  FROM DB1 IF F3  = DB1 PERFORM G ELSE PERFORM X
               B.
*ZC    208         SUBTRACT F2,FROM,DB1
         L     ZC_R0,F2
         CDFBR ZC_F0,ZC_R0
         LARL  ZC_R1,=DB'1E3'
         DDB   ZC_R0,0(ZC_R1)
         LD    ZC_F1,DB1
         SDBR  ZC_F1,ZC_F0
         STD   ZC_F1,DB1
*ZC    208         IF    F3,=,DB1
         L     ZC_R0,F3
         CDFBR ZC_F0,ZC_R0
         LD    ZC_F1,DB1
         LARL  ZC_R2,=DB'1E3'
         MDB   ZC_R1,0(ZC_R2)
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_140_1
*ZC    208         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    208         ELSE
         J     PG_IF_140_E
PG_IF_140_1  DS    0H  &TYPE
*ZC    208         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_140_E  DS    0H  &TYPE
*            SUBTRACT F2  FROM LB1 IF F3  = LB1 PERFORM G ELSE PERFORM X
               B.
*ZC    209         SUBTRACT F2,FROM,LB1
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         L     ZC_R0,F2
         CXFBR ZC_F0,ZC_R0
         LARL  ZC_R1,=LB'1E3'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXBR  ZC_R0,ZC_R1
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         SXBR  ZC_F1,ZC_F0
         STD   ZC_F1,LB1
         STD   ZC_F3,8+LB1
*ZC    209         IF    F3,=,LB1
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
*ZC    209         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    209         ELSE
         J     PG_IF_141_E
PG_IF_141_1  DS    0H  &TYPE
*ZC    209         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_141_E  DS    0H  &TYPE
*            SUBTRACT F2  FROM ED1 IF F3  = ED1 PERFORM G ELSE PERFORM X
               B.
*ZC    210         SUBTRACT F2,FROM,ED1
         LGF   ZC_R0,F2
         CDGTR ZC_F0,ZC_R0
         LARL  ZC_R1,=DD'1E3'
         LD    ZC_F1,0(ZC_R1)
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         SDTR  ZC_F1,ZC_F1,ZC_F0
         LEDTR ZC_F1,0,ZC_F1,0
         STE   ZC_F1,ED1
*ZC    210         IF    F3,=,ED1
         L     ZC_R0,F3
         CDFTR ZC_F0,0,ZC_R0,0
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         LARL  ZC_R2,=DD'1E3'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F1,ZC_F1,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_142_1
*ZC    210         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    210         ELSE
         J     PG_IF_142_E
PG_IF_142_1  DS    0H  &TYPE
*ZC    210         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_142_E  DS    0H  &TYPE
*            SUBTRACT F2  FROM DD1 IF EH3 = DD1 PERFORM G ELSE PERFORM X
               B.
*ZC    211         SUBTRACT F2,FROM,DD1
         LGF   ZC_R0,F2
         CDGTR ZC_F0,ZC_R0
         LARL  ZC_R1,=DD'1E3'
         LD    ZC_F1,0(ZC_R1)
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,DD1
         SDTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,DD1
*ZC    211         IF    EH3,=,DD1
         LE    ZC_F4,EH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,DD1
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_143_1
*ZC    211         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    211         ELSE
         J     PG_IF_143_E
PG_IF_143_1  DS    0H  &TYPE
*ZC    211         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_143_E  DS    0H  &TYPE
*            SUBTRACT F2  FROM LD1 IF EH3 = LD1 PERFORM G ELSE PERFORM X
               B.
*ZC    212         SUBTRACT F2,FROM,LD1
         LGF   ZC_R0,F2
         CXGTR ZC_F0,ZC_R0
         LARL  ZC_R1,=LD'1E3'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         SXTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,LD1
         STD   ZC_F3,8+LD1
*ZC    212         IF    EH3,=,LD1
         LE    ZC_F4,EH3
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         CXTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_144_1
*ZC    212         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    212         ELSE
         J     PG_IF_144_E
PG_IF_144_1  DS    0H  &TYPE
*ZC    212         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_144_E  DS    0H  &TYPE
*            SUBTRACT F2  FROM F1  IF F3  = F1  PERFORM G ELSE PERFORM X
               B.
*ZC    213         SUBTRACT F2,FROM,F1
         L     ZC_R0,F2
         LARL  ZC_R1,=F'1E5'
         MS    ZC_R0,0(ZC_R1)
         L     ZC_R1,F1
         SR    ZC_R1,ZC_R0
         ST    ZC_R1,F1
*ZC    213         IF    F3,=,F1
         L     ZC_R0,F3
         L     ZC_R1,F1
         LARL  ZC_R2,=F'1E5'
         MS    ZC_R0,0(ZC_R2)
         CR    ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_145_1
*ZC    213         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    213         ELSE
         J     PG_IF_145_E
PG_IF_145_1  DS    0H  &TYPE
*ZC    213         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_145_E  DS    0H  &TYPE
*            SUBTRACT F2  FROM G1  IF F3  = G1  PERFORM G ELSE PERFORM X
               B.
*ZC    214         SUBTRACT F2,FROM,G1
         LGF   ZC_R0,F2
         LARL  ZC_R1,=FL8'1E4'
         MSG   ZC_R0,0(ZC_R1)
         LG    ZC_R1,G1
         SGR   ZC_R1,ZC_R0
         STG   ZC_R1,G1
*ZC    214         IF    F3,=,G1
         LGF   ZC_R0,F3
         LG    ZC_R1,G1
         LARL  ZC_R2,=FL8'1E4'
         MSG   ZC_R0,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_146_1
*ZC    214         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    214         ELSE
         J     PG_IF_146_E
PG_IF_146_1  DS    0H  &TYPE
*ZC    214         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_146_E  DS    0H  &TYPE
*            SUBTRACT F2  FROM H1  IF F3  = H1  PERFORM G ELSE PERFORM X
               B.
*ZC    215         SUBTRACT F2,FROM,H1
         L     ZC_R0,F2
         LH    ZC_R1,H1
         SR    ZC_R1,ZC_R0
         STH   ZC_R1,H1
*ZC    215         IF    F3,=,H1
         L     ZC_R0,F3
         LH    ZC_R1,H1
         CR    ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_147_1
*ZC    215         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    215         ELSE
         J     PG_IF_147_E
PG_IF_147_1  DS    0H  &TYPE
*ZC    215         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_147_E  DS    0H  &TYPE
*            SUBTRACT F2  FROM P1  IF F3  = P1  PERFORM G ELSE PERFORM X
               B.
*ZC    216         SUBTRACT F2,FROM,P1
         L     ZC_R0,F2
         LARL  ZC_R1,=F'1E2'
         MS    ZC_R0,0(ZC_R1)
         CVD   ZC_R0,ZCVT_PWORK
         SP    P1,ZCVT_PWORK
*ZC    216         IF    F3,=,P1
         LGF   ZC_R0,F3
         ZAP   ZCVT_PWORK2,P1
         CVBG  ZC_R1,ZCVT_PWORK2
         LARL  ZC_R2,=FL8'1E2'
         MSG   ZC_R0,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_148_1
*ZC    216         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    216         ELSE
         J     PG_IF_148_E
PG_IF_148_1  DS    0H  &TYPE
*ZC    216         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_148_E  DS    0H  &TYPE
*            SUBTRACT F2  FROM Q1  IF F3  = Q1  PERFORM G ELSE PERFORM X
               B.
*ZC    217         SUBTRACT F2,FROM,Q1
         LGF   ZC_R0,F2
         LARL  ZC_R1,=FL8'1E3'
         MSG   ZC_R0,0(ZC_R1)
         LGR   ZC_R1,ZC_R0
         SRAG  ZC_R0,ZC_R0,63
         LMG   ZC_R2,ZC_R3,Q1
         SLGR  ZC_R3,ZC_R1
         SLBGR ZC_R2,ZC_R0
         STMG  ZC_R2,ZC_R3,Q1
*ZC    217         IF    F3,=,Q1
         LGF   ZC_R1,F3
         LGR   ZC_R0,ZC_R1
         SRAG  ZC_R0,ZC_R0,63  SIGN FILL HIGH 64
         LG    ZC_R2,Q1
         LG    ZC_R3,8+Q1
                  STMG  ZC_R2,ZC_R3,ZCVT_PWORK1
                  LARL  ZC_R2,=FL8'1E3'
                  LG    ZC_R3,0(ZC_R2)
                  SGR   ZC_R2,ZC_R2
                  L     ZC_R15,ZCVT_MPYQ128
                  BALR  ZC_R14,ZC_R15
                  LMG   ZC_R2,ZC_R3,ZCVT_PWORK1
         CGR   ZC_R0,ZC_R2
         JNZ   *+4+4
         CGR   ZC_R0+1,ZC_R2+1
         BRC   15-ZC_EQ,PG_IF_149_1
*ZC    217         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    217         ELSE
         J     PG_IF_149_E
PG_IF_149_1  DS    0H  &TYPE
*ZC    217         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_149_E  DS    0H  &TYPE
*            SUBTRACT F2  FROM Z1  IF F3  = Z1  PERFORM G ELSE PERFORM X
               B.
*ZC    218         SUBTRACT F2,FROM,Z1
         LGF   ZC_R0,F2
         CVDG  ZC_R0,ZCVT_PWORK2
         SRP   ZCVT_PWORK2,1,0
         PACK  ZCVT_PWORK1(6),0+Z1(11) PACK #1 NORMAL
         SP    ZCVT_PWORK1(6),ZCVT_PWORK2
         UNPK  0+Z1(11),0+ZCVT_PWORK1(6) UNPK #1 NORMAL
*ZC    218         IF    F3,=,Z1
         PACK  ZCVT_PWORK2(16),0+Z1(11) PACK #1 NORMAL
         CVBG  ZC_R1,ZCVT_PWORK2
         LGF   ZC_R0,F3
         LARL  ZC_R2,=FL8'1E1'
         MSG   ZC_R0,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_150_1
*ZC    218         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    218         ELSE
         J     PG_IF_150_E
PG_IF_150_1  DS    0H  &TYPE
*ZC    218         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_150_E  DS    0H  &TYPE
*            PERFORM INIT.
*ZC    219         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            SUBTRACT G2  FROM EH1 IF G3  = EH1 PERFORM G ELSE PERFORM X
               B.
*ZC    220         SUBTRACT G2,FROM,EH1
         LG    ZC_R0,G2
         CEGR  ZC_F0,ZC_R0
         LARL  ZC_R1,=EH'1E4'
         DE    ZC_R0,0(ZC_R1)
         LE    ZC_F1,EH1
         SER   ZC_F1,ZC_F0
         STE   ZC_F1,EH1
*ZC    220         IF    G3,=,EH1
         LG    ZC_R0,G3
         CEGR  ZC_F0,ZC_R0
         LE    ZC_F1,EH1
         LARL  ZC_R2,=EH'1E4'
         ME    ZC_R1,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_151_1
*ZC    220         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    220         ELSE
         J     PG_IF_151_E
PG_IF_151_1  DS    0H  &TYPE
*ZC    220         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_151_E  DS    0H  &TYPE
*            SUBTRACT G2  FROM DH1 IF G3  = DH1 PERFORM G ELSE PERFORM X
               B.
*ZC    221         SUBTRACT G2,FROM,DH1
         LG    ZC_R0,G2
         CDGR  ZC_F0,ZC_R0
         LARL  ZC_R1,=DH'1E4'
         DD    ZC_R0,0(ZC_R1)
         LD    ZC_F1,DH1
         SDR   ZC_F1,ZC_F0
         STD   ZC_F1,DH1
*ZC    221         IF    G3,=,DH1
         LG    ZC_R0,G3
         CDGR  ZC_F0,ZC_R0
         LD    ZC_F1,DH1
         LARL  ZC_R2,=DH'1E4'
         MD    ZC_R1,0(ZC_R2)
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_152_1
*ZC    221         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    221         ELSE
         J     PG_IF_152_E
PG_IF_152_1  DS    0H  &TYPE
*ZC    221         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_152_E  DS    0H  &TYPE
*            SUBTRACT G2  FROM LH1 IF G3  = LH1 PERFORM G ELSE PERFORM X
               B.
*ZC    222         SUBTRACT G2,FROM,LH1
         LG    ZC_R0,G2
         CXGR  ZC_F0,ZC_R0
         LARL  ZC_R1,=LH'1E4'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXR   ZC_F0,ZC_F1
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         SXR   ZC_F1,ZC_F0
         STD   ZC_F1,LH1
         STD   ZC_F3,8+LH1
*ZC    222         IF    G3,=,LH1
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
*ZC    222         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    222         ELSE
         J     PG_IF_153_E
PG_IF_153_1  DS    0H  &TYPE
*ZC    222         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_153_E  DS    0H  &TYPE
*            SUBTRACT G2  FROM EB1 IF G3  = EB1 PERFORM G ELSE PERFORM X
               B.
*ZC    223         SUBTRACT G2,FROM,EB1
         LG    ZC_R0,G2
         CDGBR ZC_F0,ZC_R0
         LARL  ZC_R1,=DB'1E4'
         DDB   ZC_R0,0(ZC_R1)
         LEDBR ZC_F0,ZC_F0
         LE    ZC_F1,EB1
         SEBR  ZC_F1,ZC_F0
         STE   ZC_F1,EB1
*ZC    223         IF    G3,=,EB1
         LG    ZC_R0,G3
         CEGBR ZC_F0,ZC_R0
         LE    ZC_F1,EB1
         LARL  ZC_R2,=EB'1E4'
         MDEB  ZC_F1,0(ZC_R2)
         LEDBR ZC_F1,ZC_F1
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_154_1
*ZC    223         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    223         ELSE
         J     PG_IF_154_E
PG_IF_154_1  DS    0H  &TYPE
*ZC    223         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_154_E  DS    0H  &TYPE
*            SUBTRACT G2  FROM DB1 IF G3  = DB1 PERFORM G ELSE PERFORM X
               B.
*ZC    224         SUBTRACT G2,FROM,DB1
         LG    ZC_R0,G2
         CDGBR ZC_F0,ZC_R0
         LARL  ZC_R1,=DB'1E4'
         DDB   ZC_R0,0(ZC_R1)
         LD    ZC_F1,DB1
         SDBR  ZC_F1,ZC_F0
         STD   ZC_F1,DB1
*ZC    224         IF    G3,=,DB1
         LG    ZC_R0,G3
         CDGBR ZC_F0,ZC_R0
         LD    ZC_F1,DB1
         LARL  ZC_R2,=DB'1E4'
         MDB   ZC_R1,0(ZC_R2)
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_155_1
*ZC    224         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    224         ELSE
         J     PG_IF_155_E
PG_IF_155_1  DS    0H  &TYPE
*ZC    224         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_155_E  DS    0H  &TYPE
*            SUBTRACT G2  FROM LB1 IF G3  = LB1 PERFORM G ELSE PERFORM X
               B.
*ZC    225         SUBTRACT G2,FROM,LB1
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         LG    ZC_R0,G2
         CXGBR ZC_F0,ZC_R0
         LARL  ZC_R1,=LB'1E4'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXBR  ZC_R0,ZC_R1
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         SXBR  ZC_F1,ZC_F0
         STD   ZC_F1,LB1
         STD   ZC_F3,8+LB1
*ZC    225         IF    G3,=,LB1
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
*ZC    225         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    225         ELSE
         J     PG_IF_156_E
PG_IF_156_1  DS    0H  &TYPE
*ZC    225         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_156_E  DS    0H  &TYPE
*            SUBTRACT G2  FROM ED1 IF G3  = ED1 PERFORM G ELSE PERFORM X
               B.
*ZC    226         SUBTRACT G2,FROM,ED1
         LG    ZC_R0,G2
         CDGTR ZC_F0,ZC_R0
         LARL  ZC_R1,=DD'1E4'
         LD    ZC_F1,0(ZC_R1)
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         SDTR  ZC_F1,ZC_F1,ZC_F0
         LEDTR ZC_F1,0,ZC_F1,0
         STE   ZC_F1,ED1
*ZC    226         IF    G3,=,ED1
         LG    ZC_R0,G3
         CDGTR ZC_F0,ZC_R0
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         LARL  ZC_R2,=DD'1E4'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F1,ZC_F1,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_157_1
*ZC    226         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    226         ELSE
         J     PG_IF_157_E
PG_IF_157_1  DS    0H  &TYPE
*ZC    226         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_157_E  DS    0H  &TYPE
*            SUBTRACT G2  FROM DD1 IF G3  = DD1 PERFORM G ELSE PERFORM X
               B.
*ZC    227         SUBTRACT G2,FROM,DD1
         LG    ZC_R0,G2
         CDGTR ZC_F0,ZC_R0
         LARL  ZC_R1,=DD'1E4'
         LD    ZC_F1,0(ZC_R1)
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,DD1
         SDTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,DD1
*ZC    227         IF    G3,=,DD1
         LG    ZC_R0,G3
         CDGTR ZC_F0,ZC_R0
         LD    ZC_F1,DD1
         LARL  ZC_R2,=DD'1E4'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F1,ZC_F1,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_158_1
*ZC    227         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    227         ELSE
         J     PG_IF_158_E
PG_IF_158_1  DS    0H  &TYPE
*ZC    227         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_158_E  DS    0H  &TYPE
*            SUBTRACT G2  FROM LD1 IF G3  = LD1 PERFORM G ELSE PERFORM X
               B.
*ZC    228         SUBTRACT G2,FROM,LD1
         LG    ZC_R0,G2
         CXGTR ZC_F0,ZC_R0
         LARL  ZC_R1,=LD'1E4'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         SXTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,LD1
         STD   ZC_F3,8+LD1
*ZC    228         IF    G3,=,LD1
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
*ZC    228         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    228         ELSE
         J     PG_IF_159_E
PG_IF_159_1  DS    0H  &TYPE
*ZC    228         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_159_E  DS    0H  &TYPE
*            SUBTRACT G2  FROM F1  IF G3  = F1  PERFORM G ELSE PERFORM X
               B.
*ZC    229         SUBTRACT G2,FROM,F1
         LG    ZC_R0,G2
         LARL  ZC_R1,=FL8'1E4'
         MSG   ZC_R0,0(ZC_R1)
         L     ZC_R1,F1
         SR    ZC_R1,ZC_R0
         ST    ZC_R1,F1
*ZC    229         IF    G3,=,F1
         LG    ZC_R0,G3
         LGF   ZC_R1,F1
         LARL  ZC_R2,=FL8'1E4'
         MSG   ZC_R0,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_160_1
*ZC    229         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    229         ELSE
         J     PG_IF_160_E
PG_IF_160_1  DS    0H  &TYPE
*ZC    229         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_160_E  DS    0H  &TYPE
*            SUBTRACT G2  FROM G1  IF G3  = G1  PERFORM G ELSE PERFORM X
               B.
*ZC    230         SUBTRACT G2,FROM,G1
         LG    ZC_R0,G2
         LARL  ZC_R1,=FL8'1E3'
         MSG   ZC_R0,0(ZC_R1)
         LG    ZC_R1,G1
         SGR   ZC_R1,ZC_R0
         STG   ZC_R1,G1
*ZC    230         IF    G3,=,G1
         LG    ZC_R0,G3
         LG    ZC_R1,G1
         LARL  ZC_R2,=FL8'1E3'
         MSG   ZC_R0,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_161_1
*ZC    230         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    230         ELSE
         J     PG_IF_161_E
PG_IF_161_1  DS    0H  &TYPE
*ZC    230         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_161_E  DS    0H  &TYPE
*            SUBTRACT G2  FROM H1  IF G3  = H1  PERFORM G ELSE PERFORM X
               B.
*ZC    231         SUBTRACT G2,FROM,H1
         LG    ZC_R0,G2
         LGR   ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E1'
         DSG   ZC_R0,0(ZC_R2)
         LGR   ZC_R0,ZC_R1
         LH    ZC_R1,H1
         SR    ZC_R1,ZC_R0
         STH   ZC_R1,H1
*ZC    231         IF    G3,=,H1
         LG    ZC_R0,G3
         LGH   ZC_R1,H1
         LARL  ZC_R2,=FL8'1E1'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_162_1
*ZC    231         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    231         ELSE
         J     PG_IF_162_E
PG_IF_162_1  DS    0H  &TYPE
*ZC    231         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_162_E  DS    0H  &TYPE
*            SUBTRACT G2  FROM P1  IF G3  = P1  PERFORM G ELSE PERFORM X
               B.
*ZC    232         SUBTRACT G2,FROM,P1
         LG    ZC_R0,G2
         LARL  ZC_R1,=FL8'1E1'
         MSG   ZC_R0,0(ZC_R1)
         CVDG  ZC_R0,ZCVT_PWORK1
         SP    P1,ZCVT_PWORK1
*ZC    232         IF    G3,=,P1
         LG    ZC_R0,G3
         ZAP   ZCVT_PWORK2,P1
         CVBG  ZC_R1,ZCVT_PWORK2
         LARL  ZC_R2,=FL8'1E1'
         MSG   ZC_R0,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_163_1
*ZC    232         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    232         ELSE
         J     PG_IF_163_E
PG_IF_163_1  DS    0H  &TYPE
*ZC    232         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_163_E  DS    0H  &TYPE
*            SUBTRACT G2  FROM Q1  IF G3  = Q1  PERFORM G ELSE PERFORM X
               B.
*ZC    233         SUBTRACT G2,FROM,Q1
         LG    ZC_R0,G2
         LARL  ZC_R1,=FL8'1E2'
         MSG   ZC_R0,0(ZC_R1)
         LGR   ZC_R1,ZC_R0
         SRAG  ZC_R0,ZC_R0,63
         LMG   ZC_R2,ZC_R3,Q1
         SLGR  ZC_R3,ZC_R1
         SLBGR ZC_R2,ZC_R0
         STMG  ZC_R2,ZC_R3,Q1
*ZC    233         IF    G3,=,Q1
         LG    ZC_R1,G3
         LGR   ZC_R0,ZC_R1
         SRAG  ZC_R0,ZC_R0,63  SIGN FILL HIGH 64
         LG    ZC_R2,Q1
         LG    ZC_R3,8+Q1
                  STMG  ZC_R2,ZC_R3,ZCVT_PWORK1
                  LARL  ZC_R2,=FL8'1E2'
                  LG    ZC_R3,0(ZC_R2)
                  SGR   ZC_R2,ZC_R2
                  L     ZC_R15,ZCVT_MPYQ128
                  BALR  ZC_R14,ZC_R15
                  LMG   ZC_R2,ZC_R3,ZCVT_PWORK1
         CGR   ZC_R0,ZC_R2
         JNZ   *+4+4
         CGR   ZC_R0+1,ZC_R2+1
         BRC   15-ZC_EQ,PG_IF_164_1
*ZC    233         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    233         ELSE
         J     PG_IF_164_E
PG_IF_164_1  DS    0H  &TYPE
*ZC    233         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_164_E  DS    0H  &TYPE
*            SUBTRACT G2  FROM Z1  IF G3  = Z1  PERFORM G ELSE PERFORM X
               B.
*ZC    234         SUBTRACT G2,FROM,Z1
         PACK  ZCVT_PWORK1(6),0+Z1(11) PACK #1 NORMAL
         LG    ZC_R0,G2
         CVDG  ZC_R0,ZCVT_PWORK2
         PACK  ZCVT_PWORK1(6),0+Z1(11) PACK #1 NORMAL
         SP    ZCVT_PWORK1(6),ZCVT_PWORK2
         UNPK  0+Z1(11),0+ZCVT_PWORK1(6) UNPK #1 NORMAL
*ZC    234         IF    G3,=,Z1
         PACK  ZCVT_PWORK2(16),0+Z1(11) PACK #1 NORMAL
         CVBG  ZC_R1,ZCVT_PWORK2
         LG    ZC_R0,G3
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_165_1
*ZC    234         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    234         ELSE
         J     PG_IF_165_E
PG_IF_165_1  DS    0H  &TYPE
*ZC    234         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_165_E  DS    0H  &TYPE
*            PERFORM INIT.
*ZC    235         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            SUBTRACT H2  FROM EH1 IF H3  = EH1 PERFORM G ELSE PERFORM X
               B.
*ZC    236         SUBTRACT H2,FROM,EH1
         LH    ZC_R0,H2
         CEFR  ZC_F0,ZC_R0
         LARL  ZC_R1,=EH'1E2'
         DE    ZC_R0,0(ZC_R1)
         LE    ZC_F1,EH1
         SER   ZC_F1,ZC_F0
         STE   ZC_F1,EH1
*ZC    236         IF    H3,=,EH1
         LH    ZC_R0,H3
         CEFR  ZC_F0,ZC_R0
         LE    ZC_F1,EH1
         LARL  ZC_R2,=EH'1E2'
         ME    ZC_R1,0(ZC_R2)
         CER   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_166_1
*ZC    236         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    236         ELSE
         J     PG_IF_166_E
PG_IF_166_1  DS    0H  &TYPE
*ZC    236         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_166_E  DS    0H  &TYPE
*            SUBTRACT H2  FROM DH1 IF H3  = DH1 PERFORM G ELSE PERFORM X
               B.
*ZC    237         SUBTRACT H2,FROM,DH1
         LH    ZC_R0,H2
         CDFR  ZC_F0,ZC_R0
         LARL  ZC_R1,=DH'1E2'
         DD    ZC_R0,0(ZC_R1)
         LD    ZC_F1,DH1
         SDR   ZC_F1,ZC_F0
         STD   ZC_F1,DH1
*ZC    237         IF    H3,=,DH1
         LH    ZC_R0,H3
         CDFR  ZC_F0,ZC_R0
         LD    ZC_F1,DH1
         LARL  ZC_R2,=DH'1E2'
         MD    ZC_R1,0(ZC_R2)
         CDR   ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_167_1
*ZC    237         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    237         ELSE
         J     PG_IF_167_E
PG_IF_167_1  DS    0H  &TYPE
*ZC    237         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_167_E  DS    0H  &TYPE
*            SUBTRACT H2  FROM LH1 IF H3  = LH1 PERFORM G ELSE PERFORM X
               B.
*ZC    238         SUBTRACT H2,FROM,LH1
         LH    ZC_R0,H2
         CXFR  ZC_F0,ZC_R0
         LARL  ZC_R1,=LH'1E2'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXR   ZC_F0,ZC_F1
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         SXR   ZC_F1,ZC_F0
         STD   ZC_F1,LH1
         STD   ZC_F3,8+LH1
*ZC    238         IF    H3,=,LH1
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
*ZC    238         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    238         ELSE
         J     PG_IF_168_E
PG_IF_168_1  DS    0H  &TYPE
*ZC    238         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_168_E  DS    0H  &TYPE
*            SUBTRACT H2  FROM EB1 IF H3  = EB1 PERFORM G ELSE PERFORM X
               B.
*ZC    239         SUBTRACT H2,FROM,EB1
         LH    ZC_R0,H2
         CDFBR ZC_F0,ZC_R0
         LARL  ZC_R1,=DB'1E2'
         DDB   ZC_R0,0(ZC_R1)
         LEDBR ZC_F0,ZC_F0
         LE    ZC_F1,EB1
         SEBR  ZC_F1,ZC_F0
         STE   ZC_F1,EB1
*ZC    239         IF    H3,=,EB1
         LH    ZC_R0,H3
         CEFBR ZC_F0,ZC_R0
         LE    ZC_F1,EB1
         LARL  ZC_R2,=EB'1E2'
         MDEB  ZC_F1,0(ZC_R2)
         LEDBR ZC_F1,ZC_F1
         CEBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_169_1
*ZC    239         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    239         ELSE
         J     PG_IF_169_E
PG_IF_169_1  DS    0H  &TYPE
*ZC    239         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_169_E  DS    0H  &TYPE
*            SUBTRACT H2  FROM DB1 IF H3  = DB1 PERFORM G ELSE PERFORM X
               B.
*ZC    240         SUBTRACT H2,FROM,DB1
         LH    ZC_R0,H2
         CDFBR ZC_F0,ZC_R0
         LARL  ZC_R1,=DB'1E2'
         DDB   ZC_R0,0(ZC_R1)
         LD    ZC_F1,DB1
         SDBR  ZC_F1,ZC_F0
         STD   ZC_F1,DB1
*ZC    240         IF    H3,=,DB1
         LH    ZC_R0,H3
         CDFBR ZC_F0,ZC_R0
         LD    ZC_F1,DB1
         LARL  ZC_R2,=DB'1E2'
         MDB   ZC_R1,0(ZC_R2)
         CDBR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_170_1
*ZC    240         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    240         ELSE
         J     PG_IF_170_E
PG_IF_170_1  DS    0H  &TYPE
*ZC    240         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_170_E  DS    0H  &TYPE
*            SUBTRACT H2  FROM LB1 IF H3  = LB1 PERFORM G ELSE PERFORM X
               B.
*ZC    241         SUBTRACT H2,FROM,LB1
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         LH    ZC_R0,H2
         CXFBR ZC_F0,ZC_R0
         LARL  ZC_R1,=LB'1E2'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXBR  ZC_R0,ZC_R1
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         SXBR  ZC_F1,ZC_F0
         STD   ZC_F1,LB1
         STD   ZC_F3,8+LB1
*ZC    241         IF    H3,=,LB1
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
*ZC    241         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    241         ELSE
         J     PG_IF_171_E
PG_IF_171_1  DS    0H  &TYPE
*ZC    241         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_171_E  DS    0H  &TYPE
*            SUBTRACT H2  FROM ED1 IF H3  = ED1 PERFORM G ELSE PERFORM X
               B.
*ZC    242         SUBTRACT H2,FROM,ED1
         LGH   ZC_R0,H2
         CDGTR ZC_F0,ZC_R0
         LARL  ZC_R1,=DD'1E2'
         LD    ZC_F1,0(ZC_R1)
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         SDTR  ZC_F1,ZC_F1,ZC_F0
         LEDTR ZC_F1,0,ZC_F1,0
         STE   ZC_F1,ED1
*ZC    242         IF    H3,=,ED1
         LH    ZC_R0,H3
         CDFTR ZC_F0,0,ZC_R0,0
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         LARL  ZC_R2,=DD'1E2'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F1,ZC_F1,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_172_1
*ZC    242         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    242         ELSE
         J     PG_IF_172_E
PG_IF_172_1  DS    0H  &TYPE
*ZC    242         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_172_E  DS    0H  &TYPE
*            SUBTRACT H2  FROM DD1 IF H3  = DD1 PERFORM G ELSE PERFORM X
               B.
*ZC    243         SUBTRACT H2,FROM,DD1
         LGH   ZC_R0,H2
         CDGTR ZC_F0,ZC_R0
         LARL  ZC_R1,=DD'1E2'
         LD    ZC_F1,0(ZC_R1)
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,DD1
         SDTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,DD1
*ZC    243         IF    H3,=,DD1
         LH    ZC_R0,H3
         CDFTR ZC_F0,0,ZC_R0,0
         LD    ZC_F1,DD1
         LARL  ZC_R2,=DD'1E2'
         LD    ZC_F2,0(ZC_R2)
         MDTR  ZC_F1,ZC_F1,ZC_F2
         CDTR  ZC_F0,ZC_F1
         BRC   15-ZC_EQ,PG_IF_173_1
*ZC    243         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    243         ELSE
         J     PG_IF_173_E
PG_IF_173_1  DS    0H  &TYPE
*ZC    243         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_173_E  DS    0H  &TYPE
*            SUBTRACT H2  FROM LD1 IF H3  = LD1 PERFORM G ELSE PERFORM X
               B.
*ZC    244         SUBTRACT H2,FROM,LD1
         LGH   ZC_R0,H2
         CXGTR ZC_F0,ZC_R0
         LARL  ZC_R1,=LD'1E2'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         SXTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,LD1
         STD   ZC_F3,8+LD1
*ZC    244         IF    H3,=,LD1
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
*ZC    244         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    244         ELSE
         J     PG_IF_174_E
PG_IF_174_1  DS    0H  &TYPE
*ZC    244         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_174_E  DS    0H  &TYPE
*            SUBTRACT H2  FROM F1  IF H3  = F1  PERFORM G ELSE PERFORM X
               B.
*ZC    245         SUBTRACT H2,FROM,F1
         LH    ZC_R0,H2
         LARL  ZC_R1,=F'1E6'
         MS    ZC_R0,0(ZC_R1)
         L     ZC_R1,F1
         SR    ZC_R1,ZC_R0
         ST    ZC_R1,F1
*ZC    245         IF    H3,=,F1
         LH    ZC_R0,H3
         L     ZC_R1,F1
         LARL  ZC_R2,=F'1E6'
         MS    ZC_R0,0(ZC_R2)
         CR    ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_175_1
*ZC    245         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    245         ELSE
         J     PG_IF_175_E
PG_IF_175_1  DS    0H  &TYPE
*ZC    245         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_175_E  DS    0H  &TYPE
*            SUBTRACT H2  FROM G1  IF H3  = G1  PERFORM G ELSE PERFORM X
               B.
*ZC    246         SUBTRACT H2,FROM,G1
         LGH   ZC_R0,H2
         LARL  ZC_R1,=FL8'1E5'
         MSG   ZC_R0,0(ZC_R1)
         LG    ZC_R1,G1
         SGR   ZC_R1,ZC_R0
         STG   ZC_R1,G1
*ZC    246         IF    H3,=,G1
         LGH   ZC_R0,H3
         LG    ZC_R1,G1
         LARL  ZC_R2,=FL8'1E5'
         MSG   ZC_R0,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_176_1
*ZC    246         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    246         ELSE
         J     PG_IF_176_E
PG_IF_176_1  DS    0H  &TYPE
*ZC    246         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_176_E  DS    0H  &TYPE
*            SUBTRACT H2  FROM H1  IF H3  = H1  PERFORM G ELSE PERFORM X
               B.
*ZC    247         SUBTRACT H2,FROM,H1
         LH    ZC_R0,H2
         LARL  ZC_R1,=F'1E1'
         MS    ZC_R0,0(ZC_R1)
         LH    ZC_R1,H1
         SR    ZC_R1,ZC_R0
         STH   ZC_R1,H1
*ZC    247         IF    H3,=,H1
         LH    ZC_R0,H3
         LH    ZC_R1,H1
         LARL  ZC_R2,=F'1E1'
         MS    ZC_R0,0(ZC_R2)
         CR    ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_177_1
*ZC    247         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    247         ELSE
         J     PG_IF_177_E
PG_IF_177_1  DS    0H  &TYPE
*ZC    247         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_177_E  DS    0H  &TYPE
*            SUBTRACT H2  FROM P1  IF H3  = P1  PERFORM G ELSE PERFORM X
               B.
*ZC    248         SUBTRACT H2,FROM,P1
         LH    ZC_R0,H2
         LARL  ZC_R1,=F'1E3'
         MS    ZC_R0,0(ZC_R1)
         CVD   ZC_R0,ZCVT_PWORK
         SP    P1,ZCVT_PWORK
*ZC    248         IF    H3,=,P1
         LGH   ZC_R0,H3
         ZAP   ZCVT_PWORK2,P1
         CVBG  ZC_R1,ZCVT_PWORK2
         LARL  ZC_R2,=FL8'1E3'
         MSG   ZC_R0,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_178_1
*ZC    248         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    248         ELSE
         J     PG_IF_178_E
PG_IF_178_1  DS    0H  &TYPE
*ZC    248         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_178_E  DS    0H  &TYPE
*            SUBTRACT H2  FROM Q1  IF H3  = Q1  PERFORM G ELSE PERFORM X
               B.
*ZC    249         SUBTRACT H2,FROM,Q1
         LGH   ZC_R0,H2
         LARL  ZC_R1,=FL8'1E4'
         MSG   ZC_R0,0(ZC_R1)
         LGR   ZC_R1,ZC_R0
         SRAG  ZC_R0,ZC_R0,63
         LMG   ZC_R2,ZC_R3,Q1
         SLGR  ZC_R3,ZC_R1
         SLBGR ZC_R2,ZC_R0
         STMG  ZC_R2,ZC_R3,Q1
*ZC    249         IF    H3,=,Q1
         LGH   ZC_R1,H3
         LGR   ZC_R0,ZC_R1
         SRAG  ZC_R0,ZC_R0,63  SIGN FILL HIGH 64
         LG    ZC_R2,Q1
         LG    ZC_R3,8+Q1
                  STMG  ZC_R2,ZC_R3,ZCVT_PWORK1
                  LARL  ZC_R2,=FL8'1E4'
                  LG    ZC_R3,0(ZC_R2)
                  SGR   ZC_R2,ZC_R2
                  L     ZC_R15,ZCVT_MPYQ128
                  BALR  ZC_R14,ZC_R15
                  LMG   ZC_R2,ZC_R3,ZCVT_PWORK1
         CGR   ZC_R0,ZC_R2
         JNZ   *+4+4
         CGR   ZC_R0+1,ZC_R2+1
         BRC   15-ZC_EQ,PG_IF_179_1
*ZC    249         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    249         ELSE
         J     PG_IF_179_E
PG_IF_179_1  DS    0H  &TYPE
*ZC    249         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_179_E  DS    0H  &TYPE
*            SUBTRACT H2  FROM Z1  IF H3  = Z1  PERFORM G ELSE PERFORM X
               B.
*ZC    250         SUBTRACT H2,FROM,Z1
         LGH   ZC_R0,H2
         CVDG  ZC_R0,ZCVT_PWORK2
         SRP   ZCVT_PWORK2,2,0
         PACK  ZCVT_PWORK1(6),0+Z1(11) PACK #1 NORMAL
         SP    ZCVT_PWORK1(6),ZCVT_PWORK2
         UNPK  0+Z1(11),0+ZCVT_PWORK1(6) UNPK #1 NORMAL
*ZC    250         IF    H3,=,Z1
         PACK  ZCVT_PWORK2(16),0+Z1(11) PACK #1 NORMAL
         CVBG  ZC_R1,ZCVT_PWORK2
         LGH   ZC_R0,H3
         LARL  ZC_R2,=FL8'1E2'
         MSG   ZC_R0,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_180_1
*ZC    250         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    250         ELSE
         J     PG_IF_180_E
PG_IF_180_1  DS    0H  &TYPE
*ZC    250         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_180_E  DS    0H  &TYPE
*            PERFORM INIT.
*ZC    251         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            SUBTRACT P2  FROM EH1 IF P3  = EH1 PERFORM G ELSE PERFORM X
               B.
*ZC    252         SUBTRACT P2,FROM,EH1
         ZAP   ZCVT_PWORK1,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=EH'1E6'
         DE    ZC_R0,0(ZC_R1)
         LE    ZC_F1,EH1
         SER   ZC_F1,ZC_F0
         STE   ZC_F1,EH1
*ZC    252         IF    P3,=,EH1
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
*ZC    252         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    252         ELSE
         J     PG_IF_181_E
PG_IF_181_1  DS    0H  &TYPE
*ZC    252         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_181_E  DS    0H  &TYPE
*            SUBTRACT P2  FROM DH1 IF P3  = DH1 PERFORM G ELSE PERFORM X
               B.
*ZC    253         SUBTRACT P2,FROM,DH1
         ZAP   ZCVT_PWORK1,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=DH'1E6'
         DD    ZC_R0,0(ZC_R1)
         LD    ZC_F1,DH1
         SDR   ZC_F1,ZC_F0
         STD   ZC_F1,DH1
*ZC    253         IF    P3,=,DH1
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
*ZC    253         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    253         ELSE
         J     PG_IF_182_E
PG_IF_182_1  DS    0H  &TYPE
*ZC    253         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_182_E  DS    0H  &TYPE
*            SUBTRACT P2  FROM LH1 IF P3  = LH1 PERFORM G ELSE PERFORM X
               B.
*ZC    254         SUBTRACT P2,FROM,LH1
         ZAP   ZCVT_PWORK1,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=LH'1E6'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXR   ZC_F0,ZC_F1
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         SXR   ZC_F1,ZC_F0
         STD   ZC_F1,LH1
         STD   ZC_F3,8+LH1
*ZC    254         IF    P3,=,LH1
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
*ZC    254         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    254         ELSE
         J     PG_IF_183_E
PG_IF_183_1  DS    0H  &TYPE
*ZC    254         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_183_E  DS    0H  &TYPE
*            SUBTRACT P2  FROM EB1 IF P3  = EB1 PERFORM G ELSE PERFORM X
               B.
*ZC    255         SUBTRACT P2,FROM,EB1
         ZAP   ZCVT_PWORK1,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=DB'1E6'
         DDB   ZC_R0,0(ZC_R1)
         LEDBR ZC_F0,ZC_F0
         LE    ZC_F1,EB1
         SEBR  ZC_F1,ZC_F0
         STE   ZC_F1,EB1
*ZC    255         IF    P3,=,EB1
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
*ZC    255         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    255         ELSE
         J     PG_IF_184_E
PG_IF_184_1  DS    0H  &TYPE
*ZC    255         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_184_E  DS    0H  &TYPE
*            SUBTRACT P2  FROM DB1 IF P3  = DB1 PERFORM G ELSE PERFORM X
               B.
*ZC    256         SUBTRACT P2,FROM,DB1
         ZAP   ZCVT_PWORK1,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=DB'1E6'
         DDB   ZC_R0,0(ZC_R1)
         LD    ZC_F1,DB1
         SDBR  ZC_F1,ZC_F0
         STD   ZC_F1,DB1
*ZC    256         IF    P3,=,DB1
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
*ZC    256         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    256         ELSE
         J     PG_IF_185_E
PG_IF_185_1  DS    0H  &TYPE
*ZC    256         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_185_E  DS    0H  &TYPE
*            SUBTRACT P2  FROM LB1 IF P3  = LB1 PERFORM G ELSE PERFORM X
               B.
*ZC    257         SUBTRACT P2,FROM,LB1
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         ZAP   ZCVT_PWORK1,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=LB'1E6'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXBR  ZC_R0,ZC_R1
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         SXBR  ZC_F1,ZC_F0
         STD   ZC_F1,LB1
         STD   ZC_F3,8+LB1
*ZC    257         IF    P3,=,LB1
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
*ZC    257         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    257         ELSE
         J     PG_IF_186_E
PG_IF_186_1  DS    0H  &TYPE
*ZC    257         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_186_E  DS    0H  &TYPE
*            SUBTRACT P2  FROM ED1 IF P3  = ED1 PERFORM G ELSE PERFORM X
               B.
*ZC    258         SUBTRACT P2,FROM,ED1
         ZAP   ZCVT_PWORK1,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=DD'1E6'
         LD    ZC_F1,0(ZC_R1)
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         SDTR  ZC_F1,ZC_F1,ZC_F0
         LEDTR ZC_F1,0,ZC_F1,0
         STE   ZC_F1,ED1
*ZC    258         IF    P3,=,ED1
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
*ZC    258         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    258         ELSE
         J     PG_IF_187_E
PG_IF_187_1  DS    0H  &TYPE
*ZC    258         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_187_E  DS    0H  &TYPE
*            SUBTRACT P2  FROM DD1 IF P3  = DD1 PERFORM G ELSE PERFORM X
               B.
*ZC    259         SUBTRACT P2,FROM,DD1
         ZAP   ZCVT_PWORK1,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=DD'1E6'
         LD    ZC_F1,0(ZC_R1)
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,DD1
         SDTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,DD1
*ZC    259         IF    P3,=,DD1
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
*ZC    259         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    259         ELSE
         J     PG_IF_188_E
PG_IF_188_1  DS    0H  &TYPE
*ZC    259         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_188_E  DS    0H  &TYPE
*            SUBTRACT P2  FROM LD1 IF P3  = LD1 PERFORM G ELSE PERFORM X
               B.
*ZC    260         SUBTRACT P2,FROM,LD1
         ZAP   ZCVT_PWORK1,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LARL  ZC_R1,=LD'1E6'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         SXTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,LD1
         STD   ZC_F3,8+LD1
*ZC    260         IF    P3,=,LD1
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
*ZC    260         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    260         ELSE
         J     PG_IF_189_E
PG_IF_189_1  DS    0H  &TYPE
*ZC    260         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_189_E  DS    0H  &TYPE
*            SUBTRACT P2  FROM F1  IF P3  = F1  PERFORM G ELSE PERFORM X
               B.
*ZC    261         SUBTRACT P2,FROM,F1
         ZAP   ZCVT_PWORK1,P2
         SRP ZCVT_PWORK1,2,0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    ZC_R0,ZC_R1
         L     ZC_R1,F1
         SR    ZC_R1,ZC_R0
         ST    ZC_R1,F1
*ZC    261         IF    P3,=,F1
         LGF   ZC_R1,F1
         ZAP   ZCVT_PWORK1,P3
         CVBG  ZC_R0,ZCVT_PWORK1
         LARL  ZC_R2,=FL8'1E2'
         MSG   ZC_R0,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_190_1
*ZC    261         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    261         ELSE
         J     PG_IF_190_E
PG_IF_190_1  DS    0H  &TYPE
*ZC    261         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_190_E  DS    0H  &TYPE
*            SUBTRACT P2  FROM G1  IF P3  = G1  PERFORM G ELSE PERFORM X
               B.
*ZC    262         SUBTRACT P2,FROM,G1
         ZAP   ZCVT_PWORK1,P2
         SRP ZCVT_PWORK1,1,0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R0,ZC_R1
         LG    ZC_R1,G1
         SGR   ZC_R1,ZC_R0
         STG   ZC_R1,G1
*ZC    262         IF    P3,=,G1
         LG    ZC_R1,G1
         ZAP   ZCVT_PWORK1,P3
         CVBG  ZC_R0,ZCVT_PWORK1
         LARL  ZC_R2,=FL8'1E1'
         MSG   ZC_R0,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_191_1
*ZC    262         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    262         ELSE
         J     PG_IF_191_E
PG_IF_191_1  DS    0H  &TYPE
*ZC    262         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_191_E  DS    0H  &TYPE
*            SUBTRACT P2  FROM H1  IF P3  = H1  PERFORM G ELSE PERFORM X
               B.
*ZC    263         SUBTRACT P2,FROM,H1
         ZAP   ZCVT_PWORK1,P2
         SRP ZCVT_PWORK1,64-3,0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    ZC_R0,ZC_R1
         LH    ZC_R1,H1
         SR    ZC_R1,ZC_R0
         STH   ZC_R1,H1
*ZC    263         IF    P3,=,H1
         LGH   ZC_R1,H1
         ZAP   ZCVT_PWORK1,P3
         CVBG  ZC_R0,ZCVT_PWORK1
         LARL  ZC_R2,=FL8'1E3'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_192_1
*ZC    263         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    263         ELSE
         J     PG_IF_192_E
PG_IF_192_1  DS    0H  &TYPE
*ZC    263         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_192_E  DS    0H  &TYPE
*            SUBTRACT P2  FROM P1  IF P3  = P1  PERFORM G ELSE PERFORM X
               B.
*ZC    264         SUBTRACT P2,FROM,P1
         ZAP   ZCVT_PWORK2,P2
         SRP ZCVT_PWORK2,64-1,0
         SP    P1,ZCVT_PWORK2
*ZC    264         IF    P3,=,P1
         ZAP   ZCVT_PWORK1,P3
         CVBG  ZC_R0,ZCVT_PWORK1
         ZAP   ZCVT_PWORK1,P1
         CVBG  ZC_R1,ZCVT_PWORK1
         LARL  ZC_R2,=FL8'1E1'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_193_1
*ZC    264         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    264         ELSE
         J     PG_IF_193_E
PG_IF_193_1  DS    0H  &TYPE
*ZC    264         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_193_E  DS    0H  &TYPE
*            SUBTRACT P2  FROM Q1  IF P3  = Q1  PERFORM G ELSE PERFORM X
               B.
*ZC    265         SUBTRACT P2,FROM,Q1
         ZAP   ZCVT_PWORK2,P2
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LMG   ZC_R2,ZC_R3,Q1
         SLGR  ZC_R3,ZC_R1
         SLBGR ZC_R2,ZC_R0
         STMG  ZC_R2,ZC_R3,Q1
*ZC    265         IF    P3,=,Q1
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
         CGR   ZC_R0,ZC_R2
         JNZ   *+4+4
         CGR   ZC_R0+1,ZC_R2+1
         BRC   15-ZC_EQ,PG_IF_194_1
*ZC    265         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    265         ELSE
         J     PG_IF_194_E
PG_IF_194_1  DS    0H  &TYPE
*ZC    265         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_194_E  DS    0H  &TYPE
*            SUBTRACT P2  FROM Z1  IF P3  = Z1  PERFORM G ELSE PERFORM X
               B.
*ZC    266         SUBTRACT P2,FROM,Z1
         ZAP   ZCVT_PWORK2,P2
         SRP   ZCVT_PWORK2,64-2,0
         PACK  ZCVT_PWORK1(6),0+Z1(11) PACK #1 NORMAL
         SP    ZCVT_PWORK1(6),ZCVT_PWORK2
         UNPK  0+Z1(11),0+ZCVT_PWORK1(6) UNPK #1 NORMAL
*ZC    266         IF    P3,=,Z1
         PACK  ZCVT_PWORK1(16),0+Z1(11) PACK #1 NORMAL
         CVBG  ZC_R1,ZCVT_PWORK1
         ZAP   ZCVT_PWORK1,P3
         CVBG  ZC_R0,ZCVT_PWORK1
         LARL  ZC_R2,=FL8'1E2'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_195_1
*ZC    266         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    266         ELSE
         J     PG_IF_195_E
PG_IF_195_1  DS    0H  &TYPE
*ZC    266         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_195_E  DS    0H  &TYPE
*            PERFORM INIT.
*ZC    267         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            SUBTRACT Q2  FROM EH1 IF Q3  = EH1 PERFORM G ELSE PERFORM X
               B.
*ZC    268         SUBTRACT Q2,FROM,EH1
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
         LE    ZC_F1,EH1
         SER   ZC_F1,ZC_F0
         STE   ZC_F1,EH1
*ZC    268         IF    Q3,=,EH1
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
*ZC    268         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    268         ELSE
         J     PG_IF_196_E
PG_IF_196_1  DS    0H  &TYPE
*ZC    268         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_196_E  DS    0H  &TYPE
*            SUBTRACT Q2  FROM DH1 IF Q3  = DH1 PERFORM G ELSE PERFORM X
               B.
*ZC    269         SUBTRACT Q2,FROM,DH1
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
         LD    ZC_F1,DH1
         SDR   ZC_F1,ZC_F0
         STD   ZC_F1,DH1
*ZC    269         IF    Q3,=,DH1
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
*ZC    269         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    269         ELSE
         J     PG_IF_197_E
PG_IF_197_1  DS    0H  &TYPE
*ZC    269         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_197_E  DS    0H  &TYPE
*            SUBTRACT Q2  FROM LH1 IF Q3  = LH1 PERFORM G ELSE PERFORM X
               B.
*ZC    270         SUBTRACT Q2,FROM,LH1
         LG    ZC_R0,Q2
         LG    ZC_R1,8+Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=LH'1E5'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXR   ZC_F0,ZC_F1
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         SXR   ZC_F1,ZC_F0
         STD   ZC_F1,LH1
         STD   ZC_F3,8+LH1
*ZC    270         IF    Q3,=,LH1
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
*ZC    270         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    270         ELSE
         J     PG_IF_198_E
PG_IF_198_1  DS    0H  &TYPE
*ZC    270         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_198_E  DS    0H  &TYPE
*            SUBTRACT Q2  FROM EB1 IF Q3  = EB1 PERFORM G ELSE PERFORM X
               B.
*ZC    271         SUBTRACT Q2,FROM,EB1
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
         LEDBR ZC_F0,ZC_F0
         LE    ZC_F1,EB1
         SEBR  ZC_F1,ZC_F0
         STE   ZC_F1,EB1
*ZC    271         IF    Q3,=,EB1
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
*ZC    271         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    271         ELSE
         J     PG_IF_199_E
PG_IF_199_1  DS    0H  &TYPE
*ZC    271         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_199_E  DS    0H  &TYPE
*            SUBTRACT Q2  FROM DB1 IF Q3  = DB1 PERFORM G ELSE PERFORM X
               B.
*ZC    272         SUBTRACT Q2,FROM,DB1
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
         LD    ZC_F1,DB1
         SDBR  ZC_F1,ZC_F0
         STD   ZC_F1,DB1
*ZC    272         IF    Q3,=,DB1
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
*ZC    272         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    272         ELSE
         J     PG_IF_200_E
PG_IF_200_1  DS    0H  &TYPE
*ZC    272         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_200_E  DS    0H  &TYPE
*            SUBTRACT Q2  FROM LB1 IF Q3  = LB1 PERFORM G ELSE PERFORM X
               B.
*ZC    273         SUBTRACT Q2,FROM,LB1
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         LG    ZC_R0,Q2
         LG    ZC_R1,8+Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=LB'1E5'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXBR  ZC_R0,ZC_R1
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         SXBR  ZC_F1,ZC_F0
         STD   ZC_F1,LB1
         STD   ZC_F3,8+LB1
*ZC    273         IF    Q3,=,LB1
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
*ZC    273         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    273         ELSE
         J     PG_IF_201_E
PG_IF_201_1  DS    0H  &TYPE
*ZC    273         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_201_E  DS    0H  &TYPE
*            SUBTRACT Q2  FROM ED1 IF Q3  = ED1 PERFORM G ELSE PERFORM X
               B.
*ZC    274         SUBTRACT Q2,FROM,ED1
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
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         SDTR  ZC_F1,ZC_F1,ZC_F0
         LEDTR ZC_F1,0,ZC_F1,0
         STE   ZC_F1,ED1
*ZC    274         IF    Q3,=,ED1
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
*ZC    274         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    274         ELSE
         J     PG_IF_202_E
PG_IF_202_1  DS    0H  &TYPE
*ZC    274         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_202_E  DS    0H  &TYPE
*            SUBTRACT Q2  FROM DD1 IF Q3  = DD1 PERFORM G ELSE PERFORM X
               B.
*ZC    275         SUBTRACT Q2,FROM,DD1
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
         LD    ZC_F1,DD1
         SDTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,DD1
*ZC    275         IF    Q3,=,DD1
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
*ZC    275         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    275         ELSE
         J     PG_IF_203_E
PG_IF_203_1  DS    0H  &TYPE
*ZC    275         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_203_E  DS    0H  &TYPE
*            SUBTRACT Q2  FROM LD1 IF Q3  = LD1 PERFORM G ELSE PERFORM X
               B.
*ZC    276         SUBTRACT Q2,FROM,LD1
         LG    ZC_R0,Q2
         LG    ZC_R1,8+Q2
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=LD'1E5'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         SXTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,LD1
         STD   ZC_F3,8+LD1
*ZC    276         IF    Q3,=,LD1
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
*ZC    276         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    276         ELSE
         J     PG_IF_204_E
PG_IF_204_1  DS    0H  &TYPE
*ZC    276         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_204_E  DS    0H  &TYPE
*            SUBTRACT Q2  FROM F1  IF Q3  = F1  PERFORM G ELSE PERFORM X
               B.
*ZC    277         SUBTRACT Q2,FROM,F1
         LG    ZC_R0,8+Q2
         LARL  ZC_R1,=FL8'1E3'
         MSG   ZC_R0,0(ZC_R1)
         L     ZC_R1,F1
         SR    ZC_R1,ZC_R0
         ST    ZC_R1,F1
*ZC    277         IF    Q3,=,F1
         LG    ZC_R0,Q3
         LG    ZC_R1,8+Q3
         LGF   ZC_R3,F1
         LGR   ZC_R2,ZC_R3
         SRAG  ZC_R2,ZC_R2,63 SIGN FILL
                  STMG  ZC_R2,ZC_R3,ZCVT_PWORK1
                  LARL  ZC_R2,=FL8'1E3'
                  LG    ZC_R3,0(ZC_R2)
                  SGR   ZC_R2,ZC_R2
                  L     ZC_R15,ZCVT_MPYQ128
                  BALR  ZC_R14,ZC_R15
                  LMG   ZC_R2,ZC_R3,ZCVT_PWORK1
         CGR   ZC_R0,ZC_R2
         JNZ   *+4+4
         CGR   ZC_R0+1,ZC_R2+1
         BRC   15-ZC_EQ,PG_IF_205_1
*ZC    277         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    277         ELSE
         J     PG_IF_205_E
PG_IF_205_1  DS    0H  &TYPE
*ZC    277         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_205_E  DS    0H  &TYPE
*            SUBTRACT Q2  FROM G1  IF Q3  = G1  PERFORM G ELSE PERFORM X
               B.
*ZC    278         SUBTRACT Q2,FROM,G1
         LG    ZC_R0,8+Q2 IGNORE HIGH 64 BITS
         LARL  ZC_R1,=FL8'1E2'
         MSG   ZC_R0,0(ZC_R1)
         LG    ZC_R1,G1
         SGR   ZC_R1,ZC_R0
         STG   ZC_R1,G1
*ZC    278         IF    Q3,=,G1
         LG    ZC_R0,Q3
         LG    ZC_R1,8+Q3
         LG    ZC_R3,G1
         LGR   ZC_R2,ZC_R3
         SRAG  ZC_R2,ZC_R2,63 SIGN FILL
                  STMG  ZC_R2,ZC_R3,ZCVT_PWORK1
                  LARL  ZC_R2,=FL8'1E2'
                  LG    ZC_R3,0(ZC_R2)
                  SGR   ZC_R2,ZC_R2
                  L     ZC_R15,ZCVT_MPYQ128
                  BALR  ZC_R14,ZC_R15
                  LMG   ZC_R2,ZC_R3,ZCVT_PWORK1
         CGR   ZC_R0,ZC_R2
         JNZ   *+4+4
         CGR   ZC_R0+1,ZC_R2+1
         BRC   15-ZC_EQ,PG_IF_206_1
*ZC    278         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    278         ELSE
         J     PG_IF_206_E
PG_IF_206_1  DS    0H  &TYPE
*ZC    278         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_206_E  DS    0H  &TYPE
*            SUBTRACT Q2  FROM H1  IF Q3  = H1  PERFORM G ELSE PERFORM X
               B.
*ZC    279         SUBTRACT Q2,FROM,H1
         LG    ZC_R0,8+Q2
         LGR   ZC_R1,ZC_R0
         LARL  ZC_R2,=FL8'1E2'
         DSG   ZC_R0,0(ZC_R2)
         LGR   ZC_R0,ZC_R1
         LR    ZC_R0,ZC_R1
         LH    ZC_R1,H1
         SR    ZC_R1,ZC_R0
         STH   ZC_R1,H1
*ZC    279         IF    Q3,=,H1
         LG    ZC_R0,Q3
         LG    ZC_R1,8+Q3
         LGH   ZC_R3,H1
         LGR   ZC_R2,ZC_R3
         SRAG  ZC_R2,ZC_R2,63 SIGN FILL
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
         BRC   15-ZC_EQ,PG_IF_207_1
*ZC    279         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    279         ELSE
         J     PG_IF_207_E
PG_IF_207_1  DS    0H  &TYPE
*ZC    279         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_207_E  DS    0H  &TYPE
*            SUBTRACT Q2  FROM P1  IF Q3  = P1  PERFORM G ELSE PERFORM X
               B.
*ZC    280         SUBTRACT Q2,FROM,P1
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
         SP    P1,ZCVT_PWORK2
*ZC    280         IF    Q3,=,P1
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
         CGR   ZC_R0,ZC_R2
         JNZ   *+4+4
         CGR   ZC_R0+1,ZC_R2+1
         BRC   15-ZC_EQ,PG_IF_208_1
*ZC    280         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    280         ELSE
         J     PG_IF_208_E
PG_IF_208_1  DS    0H  &TYPE
*ZC    280         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_208_E  DS    0H  &TYPE
*            SUBTRACT Q2  FROM Q1  IF Q3  = Q1  PERFORM G ELSE PERFORM X
               B.
*ZC    281         SUBTRACT Q2,FROM,Q1
         LMG   ZC_R0,ZC_R1,Q2
         LARL  ZC_R2,=FL8'1E1'
         LG    ZC_R3,0(ZC_R2)
         SGR   ZC_R2,ZC_R2
         L     ZC_R15,ZCVT_MPYQ128
         BASR  ZC_R14,ZC_R15
         LMG   ZC_R2,ZC_R3,Q1
         SLGR  ZC_R3,ZC_R1
         SLBGR ZC_R2,ZC_R0
         STMG  ZC_R2,ZC_R3,Q1
*ZC    281         IF    Q3,=,Q1
         LMG   ZC_R0,ZC_R1,Q3
         LMG   ZC_R2,ZC_R3,Q1
                  STMG  ZC_R2,ZC_R3,ZCVT_PWORK1
                  LARL  ZC_R2,=FL8'1E1'
                  LG    ZC_R3,0(ZC_R2)
                  SGR   ZC_R2,ZC_R2
                  L     ZC_R15,ZCVT_MPYQ128
                  BALR  ZC_R14,ZC_R15
                  LMG   ZC_R2,ZC_R3,ZCVT_PWORK1
         CGR   ZC_R0,ZC_R2
         JNZ   *+4+4
         CGR   ZC_R0+1,ZC_R2+1
         BRC   15-ZC_EQ,PG_IF_209_1
*ZC    281         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    281         ELSE
         J     PG_IF_209_E
PG_IF_209_1  DS    0H  &TYPE
*ZC    281         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_209_E  DS    0H  &TYPE
*            SUBTRACT Q2  FROM Z1  IF Q3  = Z1  PERFORM G ELSE PERFORM X
               B.
*ZC    282         SUBTRACT Q2,FROM,Z1
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
         SRP   ZCVT_PWORK2,64-1,0
         PACK  ZCVT_PWORK1(6),0+Z1(11) PACK #1 NORMAL
         SP    ZCVT_PWORK1(6),ZCVT_PWORK2
         UNPK  0+Z1(11),0+ZCVT_PWORK1(6) UNPK #1 NORMAL
*ZC    282         IF    Q3,=,Z1
         PACK  ZCVT_PWORK2(16),0+Z1(11) PACK #1 NORMAL
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
         BRC   15-ZC_EQ,PG_IF_210_1
*ZC    282         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    282         ELSE
         J     PG_IF_210_E
PG_IF_210_1  DS    0H  &TYPE
*ZC    282         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_210_E  DS    0H  &TYPE
*            PERFORM INIT.
*ZC    283         PERFORM INIT
         LARL  ZC_R14,PG_INIT
         LARL  ZC_R0,PG_INIT_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*            SUBTRACT Z2  FROM EH1 IF Z3  = EH1 PERFORM G ELSE PERFORM X
               B.
*ZC    284         SUBTRACT Z2,FROM,EH1
         PACK  ZCVT_PWORK1(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_EH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=EH'1E7'
         DE    ZC_R0,0(ZC_R1)
         LE    ZC_F1,EH1
         SER   ZC_F1,ZC_F0
         STE   ZC_F1,EH1
*ZC    284         IF    Z3,=,EH1
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
*ZC    284         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    284         ELSE
         J     PG_IF_211_E
PG_IF_211_1  DS    0H  &TYPE
*ZC    284         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_211_E  DS    0H  &TYPE
*            SUBTRACT Z2  FROM DH1 IF Z3  = DH1 PERFORM G ELSE PERFORM X
               B.
*ZC    285         SUBTRACT Z2,FROM,DH1
         PACK  ZCVT_PWORK1(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=DH'1E7'
         DD    ZC_R0,0(ZC_R1)
         LD    ZC_F1,DH1
         SDR   ZC_F1,ZC_F0
         STD   ZC_F1,DH1
*ZC    285         IF    Z3,=,DH1
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
*ZC    285         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    285         ELSE
         J     PG_IF_212_E
PG_IF_212_1  DS    0H  &TYPE
*ZC    285         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_212_E  DS    0H  &TYPE
*            SUBTRACT Z2  FROM LH1 IF Z3  = LH1 PERFORM G ELSE PERFORM X
               B.
*ZC    286         SUBTRACT Z2,FROM,LH1
         PACK  ZCVT_PWORK1(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LH,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=LH'1E7'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXR   ZC_F0,ZC_F1
         LD    ZC_F1,LH1
         LD    ZC_F3,8+LH1
         SXR   ZC_F1,ZC_F0
         STD   ZC_F1,LH1
         STD   ZC_F3,8+LH1
*ZC    286         IF    Z3,=,LH1
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
*ZC    286         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    286         ELSE
         J     PG_IF_213_E
PG_IF_213_1  DS    0H  &TYPE
*ZC    286         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_213_E  DS    0H  &TYPE
*            SUBTRACT Z2  FROM EB1 IF Z3  = EB1 PERFORM G ELSE PERFORM X
               B.
*ZC    287         SUBTRACT Z2,FROM,EB1
         PACK  ZCVT_PWORK1(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=DB'1E7'
         DDB   ZC_R0,0(ZC_R1)
         LEDBR ZC_F0,ZC_F0
         LE    ZC_F1,EB1
         SEBR  ZC_F1,ZC_F0
         STE   ZC_F1,EB1
*ZC    287         IF    Z3,=,EB1
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
*ZC    287         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    287         ELSE
         J     PG_IF_214_E
PG_IF_214_1  DS    0H  &TYPE
*ZC    287         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_214_E  DS    0H  &TYPE
*            SUBTRACT Z2  FROM DB1 IF Z3  = DB1 PERFORM G ELSE PERFORM X
               B.
*ZC    288         SUBTRACT Z2,FROM,DB1
         PACK  ZCVT_PWORK1(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=DB'1E7'
         DDB   ZC_R0,0(ZC_R1)
         LD    ZC_F1,DB1
         SDBR  ZC_F1,ZC_F0
         STD   ZC_F1,DB1
*ZC    288         IF    Z3,=,DB1
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
*ZC    288         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    288         ELSE
         J     PG_IF_215_E
PG_IF_215_1  DS    0H  &TYPE
*ZC    288         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_215_E  DS    0H  &TYPE
*            SUBTRACT Z2  FROM LB1 IF Z3  = LB1 PERFORM G ELSE PERFORM X
               B.
*ZC    289         SUBTRACT Z2,FROM,LB1
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         PACK  ZCVT_PWORK1(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=LB'1E7'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXBR  ZC_R0,ZC_R1
         LD    ZC_F1,LB1
         LD    ZC_F3,8+LB1
         SXBR  ZC_F1,ZC_F0
         STD   ZC_F1,LB1
         STD   ZC_F3,8+LB1
*ZC    289         IF    Z3,=,LB1
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
*ZC    289         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    289         ELSE
         J     PG_IF_216_E
PG_IF_216_1  DS    0H  &TYPE
*ZC    289         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_216_E  DS    0H  &TYPE
*            SUBTRACT Z2  FROM ED1 IF Z3  = ED1 PERFORM G ELSE PERFORM X
               B.
*ZC    290         SUBTRACT Z2,FROM,ED1
         PACK  ZCVT_PWORK1(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=DD'1E7'
         LD    ZC_F1,0(ZC_R1)
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LE    ZC_F1,ED1
         LDETR ZC_F1,ZC_F1,0
         SDTR  ZC_F1,ZC_F1,ZC_F0
         LEDTR ZC_F1,0,ZC_F1,0
         STE   ZC_F1,ED1
*ZC    290         IF    Z3,=,ED1
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
*ZC    290         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    290         ELSE
         J     PG_IF_217_E
PG_IF_217_1  DS    0H  &TYPE
*ZC    290         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_217_E  DS    0H  &TYPE
*            SUBTRACT Z2  FROM DD1 IF Z3  = DD1 PERFORM G ELSE PERFORM X
               B.
*ZC    291         SUBTRACT Z2,FROM,DD1
         PACK  ZCVT_PWORK1(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_DD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=DD'1E7'
         LD    ZC_F1,0(ZC_R1)
         DDTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,DD1
         SDTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,DD1
*ZC    291         IF    Z3,=,DD1
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
*ZC    291         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    291         ELSE
         J     PG_IF_218_E
PG_IF_218_1  DS    0H  &TYPE
*ZC    291         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_218_E  DS    0H  &TYPE
*            SUBTRACT Z2  FROM LD1 IF Z3  = LD1 PERFORM G ELSE PERFORM X
               B.
*ZC    292         SUBTRACT Z2,FROM,LD1
         PACK  ZCVT_PWORK1(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LARL  ZC_R1,=LD'1E7'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,LD1
         LD    ZC_F3,8+LD1
         SXTR  ZC_F1,ZC_F1,ZC_F0
         STD   ZC_F1,LD1
         STD   ZC_F3,8+LD1
*ZC    292         IF    Z3,=,LD1
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
*ZC    292         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    292         ELSE
         J     PG_IF_219_E
PG_IF_219_1  DS    0H  &TYPE
*ZC    292         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_219_E  DS    0H  &TYPE
*            SUBTRACT Z2  FROM F1  IF Z3  = F1  PERFORM G ELSE PERFORM X
               B.
*ZC    293         SUBTRACT Z2,FROM,F1
         PACK  ZCVT_PWORK1(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z2(3)  PACK #3 FINAL
         SRP ZCVT_PWORK1,1,0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    ZC_R0,ZC_R1
         L     ZC_R1,F1
         SR    ZC_R1,ZC_R0
         ST    ZC_R1,F1
*ZC    293         IF    Z3,=,F1
         PACK  ZCVT_PWORK1(8),0+Z3(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z3(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z3(3)  PACK #3 FINAL
         CVBG  ZC_R0,ZCVT_PWORK1
         LGF   ZC_R1,F1
         LARL  ZC_R2,=FL8'1E1'
         MSG   ZC_R0,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_220_1
*ZC    293         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    293         ELSE
         J     PG_IF_220_E
PG_IF_220_1  DS    0H  &TYPE
*ZC    293         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_220_E  DS    0H  &TYPE
*            SUBTRACT Z2  FROM G1  IF Z3  = G1  PERFORM G ELSE PERFORM X
               B.
*ZC    294         SUBTRACT Z2,FROM,G1
         PACK  ZCVT_PWORK1(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z2(3)  PACK #3 FINAL
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LGR   ZC_R0,ZC_R1
         LG    ZC_R1,G1
         SGR   ZC_R1,ZC_R0
         STG   ZC_R1,G1
*ZC    294         IF    Z3,=,G1
         PACK  ZCVT_PWORK1(8),0+Z3(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z3(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z3(3)  PACK #3 FINAL
         CVBG  ZC_R0,ZCVT_PWORK1
         LG    ZC_R1,G1
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_221_1
*ZC    294         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    294         ELSE
         J     PG_IF_221_E
PG_IF_221_1  DS    0H  &TYPE
*ZC    294         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_221_E  DS    0H  &TYPE
*            SUBTRACT Z2  FROM H1  IF Z3  = H1  PERFORM G ELSE PERFORM X
               B.
*ZC    295         SUBTRACT Z2,FROM,H1
         PACK  ZCVT_PWORK1(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z2(3)  PACK #3 FINAL
         SRP ZCVT_PWORK1,64-4,0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LR    ZC_R0,ZC_R1
         LH    ZC_R1,H1
         SR    ZC_R1,ZC_R0
         STH   ZC_R1,H1
*ZC    295         IF    Z3,=,H1
         PACK  ZCVT_PWORK1(8),0+Z3(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z3(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z3(3)  PACK #3 FINAL
         CVBG  ZC_R0,ZCVT_PWORK1
         LGH   ZC_R1,H1
         LARL  ZC_R2,=FL8'1E4'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_222_1
*ZC    295         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    295         ELSE
         J     PG_IF_222_E
PG_IF_222_1  DS    0H  &TYPE
*ZC    295         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_222_E  DS    0H  &TYPE
*            SUBTRACT Z2  FROM P1  IF Z3  = P1  PERFORM G ELSE PERFORM X
               B.
*ZC    296         SUBTRACT Z2,FROM,P1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
        SRP ZCVT_PWORK2,64-2,0
        SP    P1,ZCVT_PWORK2
*ZC    296         IF    Z3,=,P1
         PACK  ZCVT_PWORK1(8),0+Z3(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z3(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z3(3)  PACK #3 FINAL
         CVBG  ZC_R0,ZCVT_PWORK1
         ZAP   ZCVT_PWORK2,P1
         CVBG  ZC_R1,ZCVT_PWORK2
         LARL  ZC_R2,=FL8'1E2'
         MSG   ZC_R1,0(ZC_R2)
         CGR   ZC_R0,ZC_R1
         BRC   15-ZC_EQ,PG_IF_223_1
*ZC    296         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    296         ELSE
         J     PG_IF_223_E
PG_IF_223_1  DS    0H  &TYPE
*ZC    296         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_223_E  DS    0H  &TYPE
*            SUBTRACT Z2  FROM Q1  IF Z3  = Q1  PERFORM G ELSE PERFORM X
               B.
*ZC    297         SUBTRACT Z2,FROM,Q1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         SRP ZCVT_PWORK2,64-1,0
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK2
         CXSTR ZC_F4,ZC_R0
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LB,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLBTQ CVT LB IN F0-F2 TO Q IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         LMG   ZC_R2,ZC_R3,Q1
         SLGR  ZC_R3,ZC_R1
         SLBGR ZC_R2,ZC_R0
         STMG  ZC_R2,ZC_R3,Q1
*ZC    297         IF    Z3,=,Q1
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
         BRC   15-ZC_EQ,PG_IF_224_1
*ZC    297         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    297         ELSE
         J     PG_IF_224_E
PG_IF_224_1  DS    0H  &TYPE
*ZC    297         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_224_E  DS    0H  &TYPE
*            SUBTRACT Z2  FROM Z1  IF Z3  = Z1  PERFORM G ELSE PERFORM X
               B.
*ZC    298         SUBTRACT Z2,FROM,Z1
         PACK  ZCVT_PWORK2(8),0+Z2(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z2(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z2(3)  PACK #3 FINAL
         SRP   ZCVT_PWORK2,64-3,0
         PACK  ZCVT_PWORK1(6),0+Z1(11) PACK #1 NORMAL
         SP    ZCVT_PWORK1(6),ZCVT_PWORK2
         UNPK  0+Z1(11),0+ZCVT_PWORK1(6) UNPK #1 NORMAL
*ZC    298         IF    Z3,=,Z1
         PACK  ZCVT_PWORK1(8),0+Z3(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK1(8),14+Z3(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK1(2),28+Z3(3)  PACK #3 FINAL
         PACK  ZCVT_PWORK2(16),0+Z1(11) PACK #1 NORMAL
         SRP   ZCVT_PWORK2,3,0
         CP    ZCVT_PWORK1(16),ZCVT_PWORK2 RPI 1215
         BRC   15-ZC_EQ,PG_IF_225_1
*ZC    298         PERFORM G
         LARL  ZC_R14,PG_G
         LARL  ZC_R0,PG_G_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
*ZC    298         ELSE
         J     PG_IF_225_E
PG_IF_225_1  DS    0H  &TYPE
*ZC    298         PERFORM B
         LARL  ZC_R14,PG_B
         LARL  ZC_R0,PG_B_END+6
         L     ZC_R15,ZCVT_PERFORM
         BASR  ZC_R1,ZC_R15
PG_IF_225_E  DS    0H  &TYPE
*            DISPLAY 'TOTAL G = ' G ' TOTAL B = ' B
*ZC    299         DISPLAY 'TOTAL G = ',G,' TOTAL B = ',B
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
*ZC    300         STOP  RUN
         LH    ZC_R1,RETURN_CODE      PASS RETURN CODE IN R1
         L     ZC_R15,ZCVT_GOBACK
         BR    ZC_R15
*        INIT.
PG_MAINLINE_END L ZC_R15,ZCVT_PMCHECK
         BASR  ZC_R14,ZC_R15 CHECK FOR END OF CURRENT PERFORM
PG_INIT  DS    0H
*            DISPLAY 'INIT'
*ZC    302         DISPLAY 'INIT'
         BRAS  1,*+(WTO#6966_EOT-*+1)/2*2
         DC    AL2(WTO#6966_EOT-*,0),C'INIT'
WTO#6966_EOT     EQU *
         SVC   35
*            MOVE 4.0 TO EH1.
*ZC    303         MOVE  4.0,TO,EH1
          LARL  ZC_R1,=EH'4.0'
          MVC   EH1,0(ZC_R1)
*            MOVE 4.0 TO DH1.
*ZC    304         MOVE  4.0,TO,DH1
          LARL  ZC_R1,=DH'4.0'
          MVC   DH1,0(ZC_R1)
*            MOVE 4.0 TO LH1.
*ZC    305         MOVE  4.0,TO,LH1
          LARL  ZC_R1,=LH'4.0'
          MVC   LH1,0(ZC_R1)
*            MOVE 4.0 TO EB1.
*ZC    306         MOVE  4.0,TO,EB1
          LARL  ZC_R1,=EB'4.0'
          MVC   EB1,0(ZC_R1)
*            MOVE 4.0 TO DB1.
*ZC    307         MOVE  4.0,TO,DB1
          LARL  ZC_R1,=DB'4.0'
          MVC   DB1,0(ZC_R1)
*            MOVE 4.0 TO LB1.
*ZC    308         MOVE  4.0,TO,LB1
          LARL  ZC_R1,=LB'4.0'
          MVC   LB1,0(ZC_R1)
*            MOVE 4.0 TO ED1.
*ZC    309         MOVE  4.0,TO,ED1
          LARL  ZC_R1,=ED'4.0'
          MVC   ED1,0(ZC_R1)
*            MOVE 4.0 TO DD1.
*ZC    310         MOVE  4.0,TO,DD1
          LARL  ZC_R1,=DD'4.0'
          MVC   DD1,0(ZC_R1)
*            MOVE 4.0 TO LD1.
*ZC    311         MOVE  4.0,TO,LD1
          LARL  ZC_R1,=LD'4.0'
          MVC   LD1,0(ZC_R1)
*            MOVE 4.0 TO F1.
*ZC    312         MOVE  4.0,TO,F1
          LARL  ZC_R1,=F'400000000'
          MVC   F1,0(ZC_R1)
*            MOVE 4.0 TO G1.
*ZC    313         MOVE  4.0,TO,G1
          LARL  ZC_R1,=FL8'40000000'
          MVC   G1,0(ZC_R1)
*            MOVE 4.0 TO H1.
*ZC    314         MOVE  4.0,TO,H1
          MVHHI H1,4000
*            MOVE 4.0 TO P1.
*ZC    315         MOVE  4.0,TO,P1
          LARL  ZC_R1,=PL12'400000'
          MVC   P1,1(ZC_R1)
*            MOVE 4.0 TO Q1.
*ZC    316         MOVE  4.0,TO,Q1
          LARL  ZC_R1,=FL16'4000000'
          MVC   Q1,0(ZC_R1)
*            MOVE 4.0 TO Z1.
*ZC    317         MOVE  4.0,TO,Z1
          LARL  ZC_R1,=ZL12'40000'
          MVC   Z1,1(ZC_R1)
*        G.
PG_INIT_END L  ZC_R15,ZCVT_PMCHECK
         BASR  ZC_R14,ZC_R15 CHECK FOR END OF CURRENT PERFORM
PG_G     DS    0H
*            ADD 1 TO G.
*ZC    319         ADD   1,TO,G
         BRAS  ZC_R14,3 SET ZC_R1 TO A(INLINE LIT) AND SKIP OVER IT
         DC    PL2'1'
         AP    G,0(2,ZC_R14)
*            DISPLAY 'GOOD-TEST'.
*ZC    320         DISPLAY 'GOOD-TEST'
         BRAS  1,*+(WTO#7053_EOT-*+1)/2*2
         DC    AL2(WTO#7053_EOT-*,0),C'GOOD-TEST'
WTO#7053_EOT     EQU *
         SVC   35
*        B.
PG_G_END L     ZC_R15,ZCVT_PMCHECK
         BASR  ZC_R14,ZC_R15 CHECK FOR END OF CURRENT PERFORM
PG_B     DS    0H
*            ADD 1 TO B
*ZC    322         ADD   1,TO,B
         BRAS  ZC_R14,3 SET ZC_R1 TO A(INLINE LIT) AND SKIP OVER IT
         DC    PL2'1'
         AP    B,0(2,ZC_R14)
*            MOVE 16 TO RETURN-CODE..
*ZC    323         MOVE  16,TO,RETURN_CODE
          MVHHI RETURN_CODE,16
*            DISPLAY 'BAD-TEST'.
*      *    STOP RUN.
*ZC    324         DISPLAY 'BAD-TEST'
         BRAS  1,*+(WTO#7070_EOT-*+1)/2*2
         DC    AL2(WTO#7070_EOT-*,0),C'BAD-TEST'
WTO#7070_EOT     EQU *
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
                     4.0 
*    01  DH1                            0000005C 00000008 1   2        X
                     4.0 
*    01  LH1                            00000064 00000010 1   3        X
                     4.0 
*    01  EB1                            00000074 00000004 1   4        X
                     4.0 
*    01  DB1                            00000078 00000008 1   5        X
                     4.0 
*    01  LB1                            00000080 00000010 1   6        X
                     4.0 
*    01  ED1                            00000090 00000004 1   7        X
                     4.0 
*    01  DD1                            00000094 00000008 1   8        X
                     4.0 
*    01  LD1                            0000009C 00000010 1   9        X
                     4.0 
*    01  H1                             000000AC 00000002 1   H   9(1)VX
               999   4000 
*    01  F1                             000000AE 00000004 1   F   9(1)VX
               9(8)  400000000 
*    01  G1                             000000B2 00000008 1   G   9(11)X
               V9(7) 40000000 
*    01  Q1                             000000BA 00000010 1   Q   9(33)X
               V9(6) 4000000 
*    01  P1                             000000CA 0000000B 1   P   9(16)X
               V9(5) 400000 
*    01  Z1                             000000D5 0000000B 1   Z   9(7)VX
               9(4)  40000 
*    01  EH2                            000000E0 00000004 1   1        X
                     1.00 
*    01  DH2                            000000E4 00000008 1   2        X
                     1.00 
*    01  LH2                            000000EC 00000010 1   3        X
                     1.00 
*    01  EB2                            000000FC 00000004 1   4        X
                     1.00 
*    01  DB2                            00000100 00000008 1   5        X
                     1.00 
*    01  LB2                            00000108 00000010 1   6        X
                     1.00 
*    01  ED2                            00000118 00000004 1   7        X
                     1.00 
*    01  DD2                            0000011C 00000008 1   8        X
                     1.00 
*    01  LD2                            00000124 00000010 1   9        X
                     1.00 
*    01  H2                             00000134 00000002 1   H   9(2)VX
               99    100 
*    01  F2                             00000136 00000004 1   F   9(6)VX
               999   1000 
*    01  G2                             0000013A 00000008 1   G   9(14)X
               V9999 10000 
*    01  Q2                             00000142 00000010 1   Q   9(34)X
               V9999 100000 
*    01  P2                             00000152 00000010 1   P   9(25)X
               V9999 1000000 
*    01  Z2                             00000162 0000001F 1   Z   9(24)X
               V9999 10000000 
*    01  EH3                            00000181 00000004 1   1        X
                     3.00 
*    01  DH3                            00000185 00000008 1   2        X
                     3.00 
*    01  LH3                            0000018D 00000010 1   3        X
                     3.00 
*    01  EB3                            0000019D 00000004 1   4        X
                     3.00 
*    01  DB3                            000001A1 00000008 1   5        X
                     3.00 
*    01  LB3                            000001A9 00000010 1   6        X
                     3.00 
*    01  ED3                            000001B9 00000004 1   7        X
                     3.00 
*    01  DD3                            000001BD 00000008 1   8        X
                     3.00 
*    01  LD3                            000001C5 00000010 1   9        X
                     3.00 
*    01  H3                             000001D5 00000002 1   H   9(2)VX
               99    300 
*    01  F3                             000001D7 00000004 1   F   9(6)VX
               999   3000 
*    01  G3                             000001DB 00000008 1   G   9(14)X
               V9999 30000 
*    01  Q3                             000001E3 00000010 1   Q   9(34)X
               V9999 300000 
*    01  P3                             000001F3 00000010 1   P   9(25)X
               V9999 3000000 
*    01  Z3                             00000203 0000001F 1   Z   9(24)X
               V9999 30000000 
*    01  G                              00000222 00000003 1   P   9(4) X
                     0 
*    01  B                              00000225 00000003 1   P   9(4) X
                     0 
*    01  DEBUG_ITEM                     00000228 00000058 1   X        X
                      
*    02  DEBUG_LINE                     00000228 00000006 1   X   X(6) X
                      
*    02  FILLER                         0000022E 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_NAME                     0000022F 0000001E 1   X   X(30)X
                      
*    02  FILLER                         0000024D 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_1                    0000024E 00000004 1   Z   9999 X
                      
*    02  FILLER                         00000252 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_2                    00000253 00000004 1   Z   9999 X
                      
*    02  FILLER                         00000257 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_3                    00000258 00000004 1   Z   9999 X
                      
*    02  FILLER                         0000025C 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_CONTENTS                 0000025D 00000023 1   X   X(35)X
                      
*    01  TRUE                           00000280 00000001 1   Z   9    X
                     1 
*    01  FALSE                          00000281 00000001 1   Z   9    X
                     0 
*    01  RETURN_CODE                    00000282 00000002 1   H   9(4) X
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
EH1      DC EHL4'4.0'
ZC_WS_LOC_7  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DH1      DC DHL8'4.0'
ZC_WS_LOC_8  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
LH1      DC LHL16'4.0'
ZC_WS_LOC_9  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
EB1      DC EBL4'4.0'
ZC_WS_LOC_10 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DB1      DC DBL8'4.0'
ZC_WS_LOC_11 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
LB1      DC LBL16'4.0'
ZC_WS_LOC_12 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ED1      DC EDL4'4.0'
ZC_WS_LOC_13 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DD1      DC DDL8'4.0'
ZC_WS_LOC_14 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
LD1      DC LDL16'4.0'
ZC_WS_LOC_15 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
H1       DC AL2(4000)                  RPI 1065
ZC_WS_LOC_16 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
F1       DC AL4(400000000)                  RPI 1065
ZC_WS_LOC_17 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
G1       DC FL8'40000000'                  RPI 1065
ZC_WS_LOC_18 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
Q1       DC FL16'4000000'                 RPI 1065
ZC_WS_LOC_19 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
P1       DC PL11'400000'
ZC_WS_LOC_20 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
Z1       DC ZL11'40000'
ZC_WS_LOC_21 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
EH2      DC EHL4'1.00'
ZC_WS_LOC_22 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DH2      DC DHL8'1.00'
ZC_WS_LOC_23 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
LH2      DC LHL16'1.00'
ZC_WS_LOC_24 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
EB2      DC EBL4'1.00'
ZC_WS_LOC_25 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DB2      DC DBL8'1.00'
ZC_WS_LOC_26 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
LB2      DC LBL16'1.00'
ZC_WS_LOC_27 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ED2      DC EDL4'1.00'
ZC_WS_LOC_28 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DD2      DC DDL8'1.00'
ZC_WS_LOC_29 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
LD2      DC LDL16'1.00'
ZC_WS_LOC_30 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
H2       DC AL2(100)                  RPI 1065
ZC_WS_LOC_31 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
F2       DC AL4(1000)                  RPI 1065
ZC_WS_LOC_32 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
G2       DC FL8'10000'                  RPI 1065
ZC_WS_LOC_33 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
Q2       DC FL16'100000'                 RPI 1065
ZC_WS_LOC_34 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
P2       DC PL16'1000000'
ZC_WS_LOC_35 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
Z2       DC ZL31'10000000'
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
ZC_WS_DIFF EQU  *-ZC_WS-644  DIFF BETWEEN ALLOC AND CALC WS
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
