*    ZCOBOL PGM='zcobol\test\TESTPIC1' VER=V1.5.06 MM/DD/YY  
*    ZCOBOL OPTIONS=() 
         COPY  TESTPIC1_ZC_LABELS.CPY
*        IDENTIFICATION DIVISION.
*        PROGRAM-ID. COMPTYPE.
         PRINT NOLIST,NOGEN,NOLISTUSE    SET LIST OPTION FOR INTERNAL CX
               ODE
COMPTYPE CSECT ,                CSECT WITH PROCEDURE CODE AND WS
         USING *,ZC_R15
         STM   14,12,12+4*(14-14)(13)
         CNOP  4,8             FORCE ZC390PVT TO DOUBLEWORD BOUNDARY
         BRAS  ZC_R8,ZC_LOAD
         USING *,ZC_R8            BASE FOR LOAD AND CICS V5 USE
*
*  THESE FIELDS MUST BE KEPT IN SYNC WITH zcobol\ZC390PVT.CPY
*
         DC    CL8'COMPTYPE'    PVTPGM   ZCOBOL PGM NAME
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
         BRAS  1,*+(WTO#0009_EOT-*+1)/2*2
         DC    AL2(WTO#0009_EOT-*,0),C'ZC390LIB NOT FOUND'
WTO#0009_EOT     EQU *
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
         BRAS  1,*+(WTO#0010_EOT-*+1)/2*2
         DC    AL2(WTO#0010_EOT-*,0),C'ZC390LIB ZCVT VERIFY ERROR'
WTO#0010_EOT     EQU *
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
*        DATA DIVISION.
         PRINT DATA
*        WORKING-STORAGE SECTION.
****************************************************************
*
****************************************************************
*        01  Z-cobol-data-Types-comp-unsigned.
*          03 comp-9-00
*             pic  9(00) comp
*                        value x'FF00'.
*          03 comp-9-01
*             pic  9(01) comp
*                        value x'FF01'.
*          03 comp-9-02
*             pic  9(02) comp
*                        value x'FF02'.
*          03 comp-9-03
*             pic  9(03) comp
*                        value x'FF03'.
*          03 comp-9-04
*             pic  9(04) comp
*                        value x'FF04'.
*          03 comp-9-05
*             pic  9(05) comp
*                        value x'FF05'.
*          03 comp-9-06
*             pic  9(06) comp
*                        value x'FF06'.
*          03 comp-9-07
*             pic  9(07) comp
*                        value x'FF07'.
*          03 comp-9-08
*             pic  9(08) comp
*                        value x'FF08'.
*          03 comp-9-09
*             pic  9(09) comp
*                        value x'FF000009'.
*          03 comp-9-10
*             pic  9(10) comp
*                        value x'FF0000000000000A'.
*          03 comp-9-11
*             pic  9(11) comp
*                        value x'FF0000000000000B'.
*          03 comp-9-12
*             pic  9(12) comp
*                        value x'FF0000000000000C'.
*          03 comp-9-13
*             pic  9(13) comp
*                        value x'FF0000000000000D'.
*          03 comp-9-14
*             pic  9(14) comp
*                        value x'FF0000000000000E'.
*          03 comp-9-15
*             pic  9(15) comp
*                        value x'FF0000000000000F'.
*          03 comp-9-16
*             pic  9(16) comp
*                        value x'FF00000000000010'.
*          03 comp-9-17
*             pic  9(17) comp
*                        value x'FF00000000000011'.
*          03 comp-9-18
*             pic  9(18) comp
*                        value x'FF00000000000012'.
*          03 comp-9-19
*             pic  9(19) comp
*                        value x'FF000000000000000000000000000013'.
*          03 comp-9-20
*             pic  9(20) comp
*                        value x'FF000000000000000000000000000014'.
*          03 comp-9-21
*             pic  9(21) comp
*                        value x'FF000000000000000000000000000015'.
*          03 comp-9-22
*             pic  9(22) comp
*                        value x'FF000000000000000000000000000016'.
*          03 comp-9-23
*             pic  9(23) comp
*                        value x'FF000000000000000000000000000017'.
*          03 comp-9-24
*             pic  9(24) comp
*                        value x'FF000000000000000000000000000018'.
*          03 comp-9-25
*             pic  9(25) comp
*                        value x'FF000000000000000000000000000019'.
*          03 comp-9-26
*             pic  9(26) comp
*                        value x'FF00000000000000000000000000001A'.
*          03 comp-9-27
*             pic  9(27) comp
*                        value x'FF00000000000000000000000000001B'.
*          03 comp-9-28
*             pic  9(28) comp
*                        value x'FF00000000000000000000000000001C'.
*          03 comp-9-29
*             pic  9(29) comp
*                        value x'FF00000000000000000000000000001D'.
*          03 comp-9-30
*             pic  9(30) comp
*                        value x'FF00000000000000000000000000001E'.
*          03 comp-9-31
*             pic  9(31) comp
*                        value x'FF00000000000000000000000000001F'.
*          03 comp-9-32
*             pic  9(32) comp
*                        value x'FF000000000000000000000000000020'.
*          03 comp-9-33
*             pic  9(33) comp
*                        value x'FF000000000000000000000000000021'.
*          03 comp-9-34
*             pic  9(34) comp
*                        value x'FF000000000000000000000000000022'.
*          03 comp-9-35
*             pic  9(35) comp
*                        value x'FF000000000000000000000000000023'.
*          03 comp-9-36
*             pic  9(36) comp
*                        value x'FF000000000000000000000000000024'.
*          03 comp-9-37
*             pic  9(37) comp
*                        value x'FF000000000000000000000000000025'.
*          03 comp-9-38
*             pic  9(38) comp
*                        value x'FF000000000000000000000000000026'.
*          03 comp-9-39
*             pic  9(39) comp
*                        value x'FF000000000000000000000000000027'.
*
*        01  Z-cobol-data-Types-comp-Signed.
*      ***************************************************************
*          03 comp-S9-00
*              pic S9(00) comp
*                         value x'8000'.
*          03 comp-S9-01
*              pic S9(01) comp
*                         value x'8001'.
*          03 comp-S9-02
*              pic S9(02) comp
*                         value x'8002'.
*          03 comp-S9-03
*              pic S9(03) comp
*                         value x'8003'.
*          03 comp-S9-04
*              pic S9(04) comp
*                         value x'8004'.
*          03 comp-S9-05
*              pic S9(05) comp
*                         value x'8005'.
*          03 comp-S9-06
*              pic S9(06) comp
*                         value x'8006'.
*          03 comp-S9-07
*              pic S9(07) comp
*                         value x'8007'.
*          03 comp-S9-08
*              pic S9(08) comp
*                         value x'8008'.
*          03 comp-S9-09
*              pic S9(09) comp
*                         value x'80000009'.
*          03 comp-S9-10
*              pic S9(10) comp
*                         value x'800000000000000A'.
*          03 comp-S9-11
*              pic S9(11) comp
*                         value x'800000000000000B'.
*          03 comp-S9-12
*              pic S9(12) comp
*                         value x'800000000000000C'.
*          03 comp-S9-13
*              pic S9(13) comp
*                         value x'800000000000000D'.
*          03 comp-S9-14
*              pic S9(14) comp
*                         value x'800000000000000E'.
*          03 comp-S9-15
*              pic S9(15) comp
*                         value x'800000000000000F'.
*          03 comp-S9-16
*              pic S9(16) comp
*                         value x'8000000000000010'.
*          03 comp-S9-17
*              pic S9(17) comp
*                         value x'8000000000000011'.
*          03 comp-S9-18
*              pic S9(18) comp
*                         value x'8000000000000012'.
*          03 comp-S9-19
*              pic S9(19) comp
*                         value x'80000000000000000000000000000013'.
*          03 comp-S9-20
*              pic S9(20) comp
*                         value x'80000000000000000000000000000014'.
*          03 comp-S9-21
*              pic S9(21) comp
*                         value x'80000000000000000000000000000015'.
*          03 comp-S9-22
*              pic S9(22) comp
*                         value x'80000000000000000000000000000016'.
*          03 comp-S9-23
*              pic S9(23) comp
*                         value x'80000000000000000000000000000017'.
*          03 comp-S9-24
*              pic S9(24) comp
*                         value x'80000000000000000000000000000018'.
*          03 comp-S9-25
*              pic S9(25) comp
*                         value x'80000000000000000000000000000019'.
*          03 comp-S9-26
*              pic S9(26) comp
*                         value x'8000000000000000000000000000001A'.
*          03 comp-S9-27
*              pic S9(27) comp
*                         value x'8000000000000000000000000000001B'.
*          03 comp-S9-28
*              pic S9(28) comp
*                         value x'8000000000000000000000000000001C'.
*          03 comp-S9-29
*              pic S9(29) comp
*                         value x'8000000000000000000000000000001D'.
*          03 comp-S9-30
*              pic S9(30) comp
*                         value x'8000000000000000000000000000001E'.
*          03 comp-S9-31
*              pic S9(31) comp
*                         value x'8000000000000000000000000000001F'.
*          03 comp-S9-32
*              pic S9(32) comp
*                         value x'80000000000000000000000000000020'.
*          03 comp-S9-33
*              pic S9(33) comp
*                         value x'80000000000000000000000000000021'.
*          03 comp-S9-34
*              pic S9(34) comp
*                         value x'80000000000000000000000000000022'.
*          03 comp-S9-35
*              pic S9(35) comp
*                         value x'80000000000000000000000000000023'.
*          03 comp-S9-36
*              pic S9(36) comp
*                         value x'80000000000000000000000000000024'.
*          03 comp-S9-37
*              pic S9(37) comp
*                         value x'80000000000000000000000000000025'.
*          03 comp-S9-38
*              pic S9(38) comp
*                         value x'80000000000000000000000000000026'.
*          03 comp-S9-39
*              pic S9(39) comp
*                         value x'80000000000000000000000000000027'.
*      ***************************************************************
*        PROCEDURE DIVISION.
*ZC   PROCEDURE DIVISION
         PRINT LIST,GEN,LISTUSE TURN PRINT LISTING ON FOR USER CODE GEN
COMPTYPE CSECT                SWITCH TO PROCEDURE CODE AHEAD OF WS
*         Display 'Computational Data Types'.
*ZC   DISPLAY 'Computational Data Types'
         BRAS  1,*+(WTO#0317_EOT-*+1)/2*2
         DC    AL2(WTO#0317_EOT-*,0),C'Computational Data Types'
WTO#0317_EOT     EQU *
         SVC   35
*ZC   STOP  RUN
         LH    ZC_R1,RETURN_CODE      PASS RETURN CODE IN R1
         L     ZC_R15,ZCVT_GOBACK
         BR    ZC_R15
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
                      
*    01  FILLER                         00000058 000001B8 1   X        X
                      
*    01  Z_COBOL_DATA_TYPES_COMP_UNSIGNED 00000058 000001B8 1   X      X
                        
*    03  COMP_9_00                      00000058 00000004 1   F   9(00)X
                     X''FF00'' 
*    03  COMP_9_01                      0000005C 00000002 1   H   9(01)X
                     X''FF01'' 
*    03  COMP_9_02                      0000005E 00000002 1   H   9(02)X
                     X''FF02'' 
*    03  COMP_9_03                      00000060 00000002 1   H   9(03)X
                     X''FF03'' 
*    03  COMP_9_04                      00000062 00000002 1   H   9(04)X
                     X''FF04'' 
*    03  COMP_9_05                      00000064 00000004 1   F   9(05)X
                     X''FF05'' 
*    03  COMP_9_06                      00000068 00000004 1   F   9(06)X
                     X''FF06'' 
*    03  COMP_9_07                      0000006C 00000004 1   F   9(07)X
                     X''FF07'' 
*    03  COMP_9_08                      00000070 00000004 1   F   9(08)X
                     X''FF08'' 
*    03  COMP_9_09                      00000074 00000004 1   F   9(09)X
                     X''FF000009'' 
*    03  COMP_9_10                      00000078 00000008 1   G   9(10)X
                     X''FF0000000000000A'' 
*    03  COMP_9_11                      00000080 00000008 1   G   9(11)X
                     X''FF0000000000000B'' 
*    03  COMP_9_12                      00000088 00000008 1   G   9(12)X
                     X''FF0000000000000C'' 
*    03  COMP_9_13                      00000090 00000008 1   G   9(13)X
                     X''FF0000000000000D'' 
*    03  COMP_9_14                      00000098 00000008 1   G   9(14)X
                     X''FF0000000000000E'' 
*    03  COMP_9_15                      000000A0 00000008 1   G   9(15)X
                     X''FF0000000000000F'' 
*    03  COMP_9_16                      000000A8 00000008 1   G   9(16)X
                     X''FF00000000000010'' 
*    03  COMP_9_17                      000000B0 00000008 1   G   9(17)X
                     X''FF00000000000011'' 
*    03  COMP_9_18                      000000B8 00000008 1   G   9(18)X
                     X''FF00000000000012'' 
*    03  COMP_9_19                      000000C0 00000010 1   Q   9(19)X
                     X''FF000000000000000000000000000013'' 
*    03  COMP_9_20                      000000D0 00000010 1   Q   9(20)X
                     X''FF000000000000000000000000000014'' 
*    03  COMP_9_21                      000000E0 00000010 1   Q   9(21)X
                     X''FF000000000000000000000000000015'' 
*    03  COMP_9_22                      000000F0 00000010 1   Q   9(22)X
                     X''FF000000000000000000000000000016'' 
*    03  COMP_9_23                      00000100 00000010 1   Q   9(23)X
                     X''FF000000000000000000000000000017'' 
*    03  COMP_9_24                      00000110 00000010 1   Q   9(24)X
                     X''FF000000000000000000000000000018'' 
*    03  COMP_9_25                      00000120 00000010 1   Q   9(25)X
                     X''FF000000000000000000000000000019'' 
*    03  COMP_9_26                      00000130 00000010 1   Q   9(26)X
                     X''FF00000000000000000000000000001A'' 
*    03  COMP_9_27                      00000140 00000010 1   Q   9(27)X
                     X''FF00000000000000000000000000001B'' 
*    03  COMP_9_28                      00000150 00000010 1   Q   9(28)X
                     X''FF00000000000000000000000000001C'' 
*    03  COMP_9_29                      00000160 00000010 1   Q   9(29)X
                     X''FF00000000000000000000000000001D'' 
*    03  COMP_9_30                      00000170 00000010 1   Q   9(30)X
                     X''FF00000000000000000000000000001E'' 
*    03  COMP_9_31                      00000180 00000010 1   Q   9(31)X
                     X''FF00000000000000000000000000001F'' 
*    03  COMP_9_32                      00000190 00000010 1   Q   9(32)X
                     X''FF000000000000000000000000000020'' 
*    03  COMP_9_33                      000001A0 00000010 1   Q   9(33)X
                     X''FF000000000000000000000000000021'' 
*    03  COMP_9_34                      000001B0 00000010 1   Q   9(34)X
                     X''FF000000000000000000000000000022'' 
*    03  COMP_9_35                      000001C0 00000010 1   Q   9(35)X
                     X''FF000000000000000000000000000023'' 
*    03  COMP_9_36                      000001D0 00000010 1   Q   9(36)X
                     X''FF000000000000000000000000000024'' 
*    03  COMP_9_37                      000001E0 00000010 1   Q   9(37)X
                     X''FF000000000000000000000000000025'' 
*    03  COMP_9_38                      000001F0 00000010 1   Q   9(38)X
                     X''FF000000000000000000000000000026'' 
*    03  COMP_9_39                      00000200 00000010 1   Q   9(39)X
                     X''FF000000000000000000000000000027'' 
*    01  Z_COBOL_DATA_TYPES_COMP_SIGNED 00000210 000001B8 1   X        X
                      
*    03  COMP_S9_00                     00000210 00000004 1   F   9(00)X
                     X''8000'' 
*    03  COMP_S9_01                     00000214 00000002 1   H   9(01)X
                     X''8001'' 
*    03  COMP_S9_02                     00000216 00000002 1   H   9(02)X
                     X''8002'' 
*    03  COMP_S9_03                     00000218 00000002 1   H   9(03)X
                     X''8003'' 
*    03  COMP_S9_04                     0000021A 00000002 1   H   9(04)X
                     X''8004'' 
*    03  COMP_S9_05                     0000021C 00000004 1   F   9(05)X
                     X''8005'' 
*    03  COMP_S9_06                     00000220 00000004 1   F   9(06)X
                     X''8006'' 
*    03  COMP_S9_07                     00000224 00000004 1   F   9(07)X
                     X''8007'' 
*    03  COMP_S9_08                     00000228 00000004 1   F   9(08)X
                     X''8008'' 
*    03  COMP_S9_09                     0000022C 00000004 1   F   9(09)X
                     X''80000009'' 
*    03  COMP_S9_10                     00000230 00000008 1   G   9(10)X
                     X''800000000000000A'' 
*    03  COMP_S9_11                     00000238 00000008 1   G   9(11)X
                     X''800000000000000B'' 
*    03  COMP_S9_12                     00000240 00000008 1   G   9(12)X
                     X''800000000000000C'' 
*    03  COMP_S9_13                     00000248 00000008 1   G   9(13)X
                     X''800000000000000D'' 
*    03  COMP_S9_14                     00000250 00000008 1   G   9(14)X
                     X''800000000000000E'' 
*    03  COMP_S9_15                     00000258 00000008 1   G   9(15)X
                     X''800000000000000F'' 
*    03  COMP_S9_16                     00000260 00000008 1   G   9(16)X
                     X''8000000000000010'' 
*    03  COMP_S9_17                     00000268 00000008 1   G   9(17)X
                     X''8000000000000011'' 
*    03  COMP_S9_18                     00000270 00000008 1   G   9(18)X
                     X''8000000000000012'' 
*    03  COMP_S9_19                     00000278 00000010 1   Q   9(19)X
                     X''80000000000000000000000000000013'' 
*    03  COMP_S9_20                     00000288 00000010 1   Q   9(20)X
                     X''80000000000000000000000000000014'' 
*    03  COMP_S9_21                     00000298 00000010 1   Q   9(21)X
                     X''80000000000000000000000000000015'' 
*    03  COMP_S9_22                     000002A8 00000010 1   Q   9(22)X
                     X''80000000000000000000000000000016'' 
*    03  COMP_S9_23                     000002B8 00000010 1   Q   9(23)X
                     X''80000000000000000000000000000017'' 
*    03  COMP_S9_24                     000002C8 00000010 1   Q   9(24)X
                     X''80000000000000000000000000000018'' 
*    03  COMP_S9_25                     000002D8 00000010 1   Q   9(25)X
                     X''80000000000000000000000000000019'' 
*    03  COMP_S9_26                     000002E8 00000010 1   Q   9(26)X
                     X''8000000000000000000000000000001A'' 
*    03  COMP_S9_27                     000002F8 00000010 1   Q   9(27)X
                     X''8000000000000000000000000000001B'' 
*    03  COMP_S9_28                     00000308 00000010 1   Q   9(28)X
                     X''8000000000000000000000000000001C'' 
*    03  COMP_S9_29                     00000318 00000010 1   Q   9(29)X
                     X''8000000000000000000000000000001D'' 
*    03  COMP_S9_30                     00000328 00000010 1   Q   9(30)X
                     X''8000000000000000000000000000001E'' 
*    03  COMP_S9_31                     00000338 00000010 1   Q   9(31)X
                     X''8000000000000000000000000000001F'' 
*    03  COMP_S9_32                     00000348 00000010 1   Q   9(32)X
                     X''80000000000000000000000000000020'' 
*    03  COMP_S9_33                     00000358 00000010 1   Q   9(33)X
                     X''80000000000000000000000000000021'' 
*    03  COMP_S9_34                     00000368 00000010 1   Q   9(34)X
                     X''80000000000000000000000000000022'' 
*    03  COMP_S9_35                     00000378 00000010 1   Q   9(35)X
                     X''80000000000000000000000000000023'' 
*    03  COMP_S9_36                     00000388 00000010 1   Q   9(36)X
                     X''80000000000000000000000000000024'' 
*    03  COMP_S9_37                     00000398 00000010 1   Q   9(37)X
                     X''80000000000000000000000000000025'' 
*    03  COMP_S9_38                     000003A8 00000010 1   Q   9(38)X
                     X''80000000000000000000000000000026'' 
*    03  COMP_S9_39                     000003B8 00000010 1   Q   9(39)X
                     X''80000000000000000000000000000027'' 
*    01  DEBUG_ITEM                     000003C8 00000058 1   X        X
                      
*    02  DEBUG_LINE                     000003C8 00000006 1   X   X(6) X
                      
*    02  FILLER                         000003CE 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_NAME                     000003CF 0000001E 1   X   X(30)X
                      
*    02  FILLER                         000003ED 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_1                    000003EE 00000004 1   Z   9999 X
                      
*    02  FILLER                         000003F2 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_2                    000003F3 00000004 1   Z   9999 X
                      
*    02  FILLER                         000003F7 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_3                    000003F8 00000004 1   Z   9999 X
                      
*    02  FILLER                         000003FC 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_CONTENTS                 000003FD 00000023 1   X   X(35)X
                      
*    01  TRUE                           00000420 00000001 1   Z   9    X
                     1 
*    01  FALSE                          00000421 00000001 1   Z   9    X
                     0 
*    01  RETURN_CODE                    00000422 00000002 1   H   9(4) X
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
         DS  0CL440
ZC_WS_LOC_6  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
Z_COBOL_DATA_TYPES_COMP_UNSIGNED DS 0CL440
ZC_WS_LOC_7  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_00 DC AL4(X'FF00')                  RPI 1065
ZC_WS_LOC_8  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_01 DC AL2(X'FF01')                  RPI 1065
ZC_WS_LOC_9  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_02 DC AL2(X'FF02')                  RPI 1065
ZC_WS_LOC_10 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_03 DC AL2(X'FF03')                  RPI 1065
ZC_WS_LOC_11 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_04 DC AL2(X'FF04')                  RPI 1065
ZC_WS_LOC_12 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_05 DC AL4(X'FF05')                  RPI 1065
ZC_WS_LOC_13 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_06 DC AL4(X'FF06')                  RPI 1065
ZC_WS_LOC_14 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_07 DC AL4(X'FF07')                  RPI 1065
ZC_WS_LOC_15 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_08 DC AL4(X'FF08')                  RPI 1065
ZC_WS_LOC_16 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_09 DC AL4(X'FF000009')                  RPI 1065
ZC_WS_LOC_17 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_10 DC XL8'FF0000000000000A'                        RPI 1065
ZC_WS_LOC_18 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_11 DC XL8'FF0000000000000B'                        RPI 1065
ZC_WS_LOC_19 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_12 DC XL8'FF0000000000000C'                        RPI 1065
ZC_WS_LOC_20 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_13 DC XL8'FF0000000000000D'                        RPI 1065
ZC_WS_LOC_21 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_14 DC XL8'FF0000000000000E'                        RPI 1065
ZC_WS_LOC_22 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_15 DC XL8'FF0000000000000F'                        RPI 1065
ZC_WS_LOC_23 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_16 DC XL8'FF00000000000010'                        RPI 1065
ZC_WS_LOC_24 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_17 DC XL8'FF00000000000011'                        RPI 1065
ZC_WS_LOC_25 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_18 DC XL8'FF00000000000012'                        RPI 1065
ZC_WS_LOC_26 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_19 DC XL16'FF000000000000000000000000000013'                    X
                  RPI 1065
ZC_WS_LOC_27 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_20 DC XL16'FF000000000000000000000000000014'                    X
                  RPI 1065
ZC_WS_LOC_28 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_21 DC XL16'FF000000000000000000000000000015'                    X
                  RPI 1065
ZC_WS_LOC_29 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_22 DC XL16'FF000000000000000000000000000016'                    X
                  RPI 1065
ZC_WS_LOC_30 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_23 DC XL16'FF000000000000000000000000000017'                    X
                  RPI 1065
ZC_WS_LOC_31 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_24 DC XL16'FF000000000000000000000000000018'                    X
                  RPI 1065
ZC_WS_LOC_32 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_25 DC XL16'FF000000000000000000000000000019'                    X
                  RPI 1065
ZC_WS_LOC_33 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_26 DC XL16'FF00000000000000000000000000001A'                    X
                  RPI 1065
ZC_WS_LOC_34 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_27 DC XL16'FF00000000000000000000000000001B'                    X
                  RPI 1065
ZC_WS_LOC_35 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_28 DC XL16'FF00000000000000000000000000001C'                    X
                  RPI 1065
ZC_WS_LOC_36 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_29 DC XL16'FF00000000000000000000000000001D'                    X
                  RPI 1065
ZC_WS_LOC_37 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_30 DC XL16'FF00000000000000000000000000001E'                    X
                  RPI 1065
ZC_WS_LOC_38 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_31 DC XL16'FF00000000000000000000000000001F'                    X
                  RPI 1065
ZC_WS_LOC_39 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_32 DC XL16'FF000000000000000000000000000020'                    X
                  RPI 1065
ZC_WS_LOC_40 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_33 DC XL16'FF000000000000000000000000000021'                    X
                  RPI 1065
ZC_WS_LOC_41 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_34 DC XL16'FF000000000000000000000000000022'                    X
                  RPI 1065
ZC_WS_LOC_42 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_35 DC XL16'FF000000000000000000000000000023'                    X
                  RPI 1065
ZC_WS_LOC_43 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_36 DC XL16'FF000000000000000000000000000024'                    X
                  RPI 1065
ZC_WS_LOC_44 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_37 DC XL16'FF000000000000000000000000000025'                    X
                  RPI 1065
ZC_WS_LOC_45 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_38 DC XL16'FF000000000000000000000000000026'                    X
                  RPI 1065
ZC_WS_LOC_46 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_9_39 DC XL16'FF000000000000000000000000000027'                    X
                  RPI 1065
ZC_WS_LOC_47 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
Z_COBOL_DATA_TYPES_COMP_SIGNED DS 0CL440
ZC_WS_LOC_48 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_00 DC AL4(X'8000')                  RPI 1065
ZC_WS_LOC_49 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_01 DC AL2(X'8001')                  RPI 1065
ZC_WS_LOC_50 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_02 DC AL2(X'8002')                  RPI 1065
ZC_WS_LOC_51 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_03 DC AL2(X'8003')                  RPI 1065
ZC_WS_LOC_52 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_04 DC AL2(X'8004')                  RPI 1065
ZC_WS_LOC_53 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_05 DC AL4(X'8005')                  RPI 1065
ZC_WS_LOC_54 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_06 DC AL4(X'8006')                  RPI 1065
ZC_WS_LOC_55 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_07 DC AL4(X'8007')                  RPI 1065
ZC_WS_LOC_56 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_08 DC AL4(X'8008')                  RPI 1065
ZC_WS_LOC_57 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_09 DC AL4(X'80000009')                  RPI 1065
ZC_WS_LOC_58 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_10 DC XL8'800000000000000A'                        RPI 1065
ZC_WS_LOC_59 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_11 DC XL8'800000000000000B'                        RPI 1065
ZC_WS_LOC_60 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_12 DC XL8'800000000000000C'                        RPI 1065
ZC_WS_LOC_61 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_13 DC XL8'800000000000000D'                        RPI 1065
ZC_WS_LOC_62 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_14 DC XL8'800000000000000E'                        RPI 1065
ZC_WS_LOC_63 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_15 DC XL8'800000000000000F'                        RPI 1065
ZC_WS_LOC_64 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_16 DC XL8'8000000000000010'                        RPI 1065
ZC_WS_LOC_65 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_17 DC XL8'8000000000000011'                        RPI 1065
ZC_WS_LOC_66 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_18 DC XL8'8000000000000012'                        RPI 1065
ZC_WS_LOC_67 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_19 DC XL16'80000000000000000000000000000013'                   X
                   RPI 1065
ZC_WS_LOC_68 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_20 DC XL16'80000000000000000000000000000014'                   X
                   RPI 1065
ZC_WS_LOC_69 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_21 DC XL16'80000000000000000000000000000015'                   X
                   RPI 1065
ZC_WS_LOC_70 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_22 DC XL16'80000000000000000000000000000016'                   X
                   RPI 1065
ZC_WS_LOC_71 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_23 DC XL16'80000000000000000000000000000017'                   X
                   RPI 1065
ZC_WS_LOC_72 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_24 DC XL16'80000000000000000000000000000018'                   X
                   RPI 1065
ZC_WS_LOC_73 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_25 DC XL16'80000000000000000000000000000019'                   X
                   RPI 1065
ZC_WS_LOC_74 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_26 DC XL16'8000000000000000000000000000001A'                   X
                   RPI 1065
ZC_WS_LOC_75 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_27 DC XL16'8000000000000000000000000000001B'                   X
                   RPI 1065
ZC_WS_LOC_76 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_28 DC XL16'8000000000000000000000000000001C'                   X
                   RPI 1065
ZC_WS_LOC_77 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_29 DC XL16'8000000000000000000000000000001D'                   X
                   RPI 1065
ZC_WS_LOC_78 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_30 DC XL16'8000000000000000000000000000001E'                   X
                   RPI 1065
ZC_WS_LOC_79 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_31 DC XL16'8000000000000000000000000000001F'                   X
                   RPI 1065
ZC_WS_LOC_80 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_32 DC XL16'80000000000000000000000000000020'                   X
                   RPI 1065
ZC_WS_LOC_81 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_33 DC XL16'80000000000000000000000000000021'                   X
                   RPI 1065
ZC_WS_LOC_82 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_34 DC XL16'80000000000000000000000000000022'                   X
                   RPI 1065
ZC_WS_LOC_83 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_35 DC XL16'80000000000000000000000000000023'                   X
                   RPI 1065
ZC_WS_LOC_84 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_36 DC XL16'80000000000000000000000000000024'                   X
                   RPI 1065
ZC_WS_LOC_85 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_37 DC XL16'80000000000000000000000000000025'                   X
                   RPI 1065
ZC_WS_LOC_86 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_38 DC XL16'80000000000000000000000000000026'                   X
                   RPI 1065
ZC_WS_LOC_87 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
COMP_S9_39 DC XL16'80000000000000000000000000000027'                   X
                   RPI 1065
ZC_WS_LOC_88 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_ITEM DS 0CL88
ZC_WS_LOC_89 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_LINE DS CL6
ZC_WS_LOC_90 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_91 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_NAME DS CL30
ZC_WS_LOC_92 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_93 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_1 DS ZL4
ZC_WS_LOC_94 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_95 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_2 DS ZL4
ZC_WS_LOC_96 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_97 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_3 DS ZL4
ZC_WS_LOC_98 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_99 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_CONTENTS DS CL35
ZC_WS_LOC_100 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
TRUE     DC CL1'1'
ZC_WS_LOC_101 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
FALSE    DC CL1'0'
ZC_WS_LOC_102 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
RETURN_CODE DC AL2(0)                  RPI 1065
*    ZCOBOL LINKAGE SECTION DATA ITEMS 
*    LVL DATA NAME                      ADDR     LEN      DUP TYP PIC  X
                     VALUE 
ZC_WSLOC LOCTR 
ZC_WSLOC LOCTR 
ZC_WS_DIFF EQU  *-ZC_WS-1060  DIFF BETWEEN ALLOC AND CALC WS
ZC_WS_END DS   0D
         MNOTE *,'ZCOBOL TOTAL SYMBOLS                 = 102'
         MNOTE *,'ZCOBOL TOTAL SYMBOL DUPLICATES       = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL MAX DUP CHAIN    = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL LEVEL 88         = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL SET INDEXES      = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL LINKAGE SECTIONS = 0'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE SECTIONS      = 0'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE PARAGRAPHS    = 0'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE PARAGRAPH DUP = 0'
         END 
