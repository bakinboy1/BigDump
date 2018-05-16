         TITLE 'SUPERZAP - Z390 UTILITY TO VER/REP/DUMP ANY FILE'
*********************************************************************
* Copyright 2007 Automated Software Tools Corporation               *
* This source code is part of z390 assembler/emulator package       *
* The z390 package is distributed under GNU general public license  *
* Author - Don Higgins                                              *
* Date   - 04/07/07                                                 *
*********************************************************************
* 04/13/07 INITIAL CODING OF SUPERZAP V1,0
* 07/11/07 RPI 654 REMOVE LOCAL PM, PENTRY, PEXIT AND USE MAC VERSIONS
* 10/01/07 RPI 684 TEST FOR SYSIN DD AND IF NONE, DEFAULT TO CONSOLE.
* 09/27/08 RPI 909 CORRECT DO WHILE= TO INCLUDE IN (...)
*********************************************************************
*
*  SUPERZAP - UPDATE OR DUMP SECTIONS OF ANY FILE
*
*  PARM(CON) - EXEC OPTION TO USE WTO/WTOR CONSOLE VS SYSIN/SYSPRINT
*  MEM(MB)   - SET MEM TO MB REQUIRED TO LOAD FILE (DEFAULT IS 1 MB)
*
* COMMANDS FROM CONSOLE OR SYSIN FILE:
*
*   NAME FILE - LOAD FILE IN MEMORY
*     1. FILE - FILE SPEC WITH OR WITHOUT "..."
*     2. IF LOAD IS SUCCESSFUL, SET BASE TO STARTING ADDRESS
*        (SUPPORTS FILES UP TO 2G IF MEMORY AVAILABLE)
*     3. RESET FILE ERROR IF OK
*
*   VER  OFFSET VALUE - VERIFY FILE CONTENT AT OFFSET
*     1.  VALUE IS HEX OR 'TEXT' WITH '' EMBEDDED QUOTES
*     2.  SET FILE ERROR IF NO MATCH OR NO FILE LOADED
*
*   REP  OFFSET VALUE - REPLACE FILE CONTENT AT OFFSET IF NO ERRORS
*
*   DUMP OFFSET LENGTH - DUMP FILE CONTENT IN HEX AND TEXT
*
*   BASE OFFSET - SET BASE ADDRESS TO HEX OFFSET OR *+HEX OR *-HEX
*     1.  OFFSET IS HEX OFFSET FROM START OR FROM CURRENT BASE
*
*   FIND VALUE - FIND NEXT OCCURANCE OF VALUE AND SET BASE
*
*   ASCII  - SET ASCII TEXT MODE
*
*   EBCDIC - SET EBCDIC TEXT MODE (DEFAULT)
*
*   *      - COMMENT
*
*  EXAMPLES:
*
*    1.  D:\WORK\Z390>EXEC UTIL\SUPERZAP\SUPERZAP PARM(CON)  MEM(1)
*        D:\WORK\Z390>NAME UTIL\SUPERZAP\SUPERZAP.390
*        D:\WORK\Z390>FIND 50
*        D:\WORK\Z390>DUMP * 4 DUMP FIRST LOAD ON CONSOLE AND LOG
*
*    2.  D:\WORK\Z390>SET SYSIN=UTIL\SUPERZAP\ZAPDEMO1.ZAP
*        D:\WORK\Z390>SET SYSPRINT=UTIL\SUPERZAP\ZAPDEMO1.RPT
*        D:\WORK\Z390>EXEC UTIL\SUPERZAP\SUPERZAP MEM(1)
*        ZAPDEMO1.ZAP INPUT FILE CONTAINS:
*            * ZAPDEMO1.ZAP DEMO INPUT FILE
*            * TEST CHANGING AAA TO BBB
*            * RUN AGAIN TO SEE FAILED FIND AND VER DUE TO CHANGE
*            NAME UTIL\SUPERZAP\ZAPDEMO1.ZAP
*            ASCII
*            FIND 'AAA'
*            VER  * 'AAA'
*            REP  * 'BBB'  CHANGE AAA TEXT IN COMMENT TO BBB
*            DUMP * 3      DUMP CHANGED SECTION OF FILE
*********************************************************************
* REGISTER USAGE
*  R0-R6 WORK
*  R7-R8 EXTENDED BASE REGISTERS
*  R9    START OF FILE CONTENT
*  R10   END OF FILE CONTENT + 1
*  R13   CODE BASE AND SAVE AREA
*  R14-R15 WORK
*********************************************************************
*MCALL #=     1 LV= 1 SUPERZAP SUBENTRY BASES=(R13,R7,R8)
SUPERZAP CSECT 
         STM   14,12,12(13)
         BAL   15,104(15)
         DC    18F'0'
         DC    CL8'SUPERZAP'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
         USING SUPERZAP+8,13
         LAY   R7,4096(R13)   RPI 601
         USING SUPERZAP+8+4096,R7
         LAY   R8,4096(R7)   RPI 601
         USING SUPERZAP+8+8192,R8
*MEXIT #=     1 LV= 1 SUBENTRY
         COPY  ASMMSP
         COPY ZSTRMAC  Z390 STRUCTURED PROGRAMMING MACROS
         LR    R2,R1
*MCALL #=     2 LV= 1          PM    CMD_INIT
         MVC   CMD_INIT-2(2),*+10
         B     CMD_INIT
         DC    S(*+2)
*MEXIT #=     2 LV= 1 PM
         LA    R2,=CL80'SUPERZAP V1.1 11/11/07 Z390 FILE UTILITY'
*MCALL #=     3 LV= 1          PM    DISPLAY
         MVC   DISPLAY-2(2),*+10
         B     DISPLAY
         DC    S(*+2)
*MEXIT #=     3 LV= 1 PM
*MCALL #=     4 LV= 1          PM    GET_CMD
         MVC   GET_CMD-2(2),*+10
         B     GET_CMD
         DC    S(*+2)
*MEXIT #=     4 LV= 1 PM
*MCALL #=     5 LV= 1          DO    UNTIL=(CLI,EOF,EQ,TRUE)
*MCALL #=     6 LV= 2          ZSTREQU 
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
*MEXIT #=     6 LV= 2 ZSTREQU
         B     #@DO_1_1
#@DO_1_T                         DS 0H
*MCALL #=     7 LV= 2          IF    CLI,EOF,EQ,TRUE
*MCALL #=     8 LV= 3          ZSTREQU 
*MEXIT #=     8 LV= 3 ZSTREQU
         CLI   EOF,TRUE
         BC    15-EQ,#@IF_1_2
*MEXIT #=     7 LV= 2 IF
               B     #@DO_1_E
*MCALL #=     9 LV= 2          ENDIF 
*MCALL #=    10 LV= 3          ZSTREQU 
*MEXIT #=    10 LV= 3 ZSTREQU
#@IF_1_2                                                 DS 0H
*MEXIT #=     9 LV= 2 ENDIF
#@DO_1_1                         DS 0H
*MEXIT #=     5 LV= 1 DO
*MCALL #=    11 LV= 1                PM   CMD_PROCESS
         MVC   CMD_PROCESS-2(2),*+10
         B     CMD_PROCESS
         DC    S(*+2)
*MEXIT #=    11 LV= 1 PM
*MCALL #=    12 LV= 1                PM   GET_CMD
         MVC   GET_CMD-2(2),*+10
         B     GET_CMD
         DC    S(*+2)
*MEXIT #=    12 LV= 1 PM
*MCALL #=    13 LV= 1          ENDDO 
*MCALL #=    14 LV= 2          DO    END
*MCALL #=    15 LV= 3          ZSTREQU 
*MEXIT #=    15 LV= 3 ZSTREQU
         B     #@DO_1_T
#@DO_1_E                         DS 0H
*MEXIT #=    14 LV= 2 DO
*MEXIT #=    13 LV= 1 ENDDO
*MCALL #=    16 LV= 1          PM    CMD_CLOSE
         MVC   CMD_CLOSE-2(2),*+10
         B     CMD_CLOSE
         DC    S(*+2)
*MEXIT #=    16 LV= 1 PM
*MCALL #=    17 LV= 1          IF    (CP,TOTAL_ERRORS,NE,=P'0')
*MCALL #=    18 LV= 2          ZSTREQU 
*MEXIT #=    18 LV= 2 ZSTREQU
         CP    TOTAL_ERRORS,=P'0'
         BC    15-NE,#@IF_2_2
*MEXIT #=    17 LV= 1 IF
*MCALL #=    19 LV= 1                SUBEXIT RC=4
         LA    15,4
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=    19 LV= 1 SUBEXIT
*MCALL #=    20 LV= 1          ELSE 
*MCALL #=    21 LV= 2          ZSTREQU 
*MEXIT #=    21 LV= 2 ZSTREQU
        B      #@IF_2_E
#@IF_2_2                                                 DS 0H
*MEXIT #=    20 LV= 1 ELSE
*MCALL #=    22 LV= 1                SUBEXIT RC=0
         LA    15,0
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=    22 LV= 1 SUBEXIT
*MCALL #=    23 LV= 1          ENDIF 
*MCALL #=    24 LV= 2          ZSTREQU 
*MEXIT #=    24 LV= 2 ZSTREQU
#@IF_2_E                         DS 0H
*MEXIT #=    23 LV= 1 ENDIF
*MCALL #=    25 LV= 1 CMD_INIT PENTRY 
         DC    0H'0',CL8'CMD_INIT'
         B     *+4
CMD_INIT EQU   *
*MEXIT #=    25 LV= 1 PENTRY
         L     R1,0(R2)
*MCALL #=    26 LV= 1          IF    (CLC,0(2,R1),NE,=H'0') IF THERE PAX
               RM(...)
*MCALL #=    27 LV= 2          ZSTREQU 
*MEXIT #=    27 LV= 2 ZSTREQU
         CLC   0(2,R1),=H'0'
         BC    15-NE,#@IF_3_2
*MEXIT #=    26 LV= 1 IF
               MVI CONSOLE,TRUE
*MCALL #=    28 LV= 1                PEXIT 
         B     CMD_INIT-4
*MEXIT #=    28 LV= 1 PEXIT
*MCALL #=    29 LV= 1          ENDIF 
*MCALL #=    30 LV= 2          ZSTREQU 
*MEXIT #=    30 LV= 2 ZSTREQU
#@IF_3_2                                                 DS 0H
*MEXIT #=    29 LV= 1 ENDIF
*MCALL #=    31 LV= 1          GETENV SYSINDD
         LA    1,SYSINDD
         LA   0,1
         SVC  40 EXTRACT GETENV R0=1, R1=A(NAME) OUTPUT R2=A(VALUE)
*MEXIT #=    31 LV= 1 GETENV
*MCALL #=    32 LV= 1          IF    (LTR,R15,NE,R15)
*MCALL #=    33 LV= 2          ZSTREQU 
*MEXIT #=    33 LV= 2 ZSTREQU
         LTR   R15,R15
         BC    15-NE,#@IF_4_2
*MEXIT #=    32 LV= 1 IF
*MCALL #=    34 LV= 1                WTO 'SUPERZAP SYSIN NOT FOUND DEFAX
               ULTING TO CONSOLE'
         BRAS  1,*+(WTO#0034_EOT-*+1)/2*2
         DC    AL2(WTO#0034_EOT-*,0),C'SUPERZAP SYSIN NOT FOUND DEFAULTX
               ING TO CONSOLE'
WTO#0034_EOT     EQU *
         SVC   35
*MEXIT #=    34 LV= 1 WTO
               MVI CONSOLE,TRUE
*MCALL #=    35 LV= 1                PEXIT 
         B     CMD_INIT-4
*MEXIT #=    35 LV= 1 PEXIT
*MCALL #=    36 LV= 1          ENDIF 
*MCALL #=    37 LV= 2          ZSTREQU 
*MEXIT #=    37 LV= 2 ZSTREQU
#@IF_4_2                                                 DS 0H
*MEXIT #=    36 LV= 1 ENDIF
*MCALL #=    38 LV= 1          OPEN  (SYSIN,(INPUT),SYSPRINT,(OUTPUT))
*MCALL #=    39 LV= 2          ZOPEN (SYSIN,(INPUT),SYSPRINT,(OUTPUT)),X
               MF=I,MODE=31,TYPE=
                       LA     1,SYSIN
                       LA  0,DCBOFLGS_GM   READ ONLY
                   SVC   19 OPEN R0=TYPE,R1=DCB/ACB
                         LTR   15,15
                         BNZ   Z390_OPEN_EXIT0039 RPI 668
                       LA     1,SYSPRINT
                       LA  0,DCBOFLGS_PM   WRITE ONLY
                   SVC   19 OPEN R0=TYPE,R1=DCB/ACB
                         LTR   15,15
                         BNZ   Z390_OPEN_EXIT0039 RPI 668
Z390_OPEN_EXIT0039    EQU *
*MCALL #=    40 LV= 3          DCBD 
IHADCB   DSECT 
         ORG   IHADCB+X'00'
DCBID    DS    CL4            DCB ID RPI88
         ORG   IHADCB+X'1A'
DCBDSORG DS    X              DATA SET ORGANIZATION
DCBDSORG_PS EQU X'40'           PHYSICAL SEQUENTIAL
DCBDSORG_DA EQU X'20'           DIRECT ACCESS
         ORG   IHADCB+X'1C'
DCBIOBAD DS    A              INPUT/OUTPUT BLOCK (TIOT TABLE INDEX)
         ORG   IHADCB+X'20'
DCBEODA  DS    0A ADDRESS OF END OF FILE EXIT 31 BIT VS 24 RPI 989
DCBEODAD DS    A ADDRESS OF END OF FILE EXIT  31 BIT VS 24
         ORG   IHADCB+X'24'
DCBRECFM DS    X              RECORD FORMAT
DCBRECF      EQU X'80'           FIXED  RPI 989
DCBRECFM_F   EQU X'80'           FIXED
DCBRECFM_FA  EQU X'80'           FIXED
DCBRECFM_FM  EQU X'80'           FIXED
DCBRECFM_V   EQU X'40'           VARIABLE
DCBRECFM_VA  EQU X'40'           VARIABLE
DCBRECFM_VM  EQU X'40'           VARIABLE
DCBRECFM_FB  EQU X'90'           FIXED BLOCKED
DCBRECBR     EQU X'10'           BLOCKED RECORDS RPI 989
DCBRECFM_FBA EQU X'90'           FIXED BLOCKED
DCBRECFM_FBM EQU X'90'           FIXED BLOCKED
DCBRECFM_VB  EQU X'50'           VARIABLE BLOCKED
DCBRECFM_VBA EQU X'50'           VARIABLE BLOCKED
DCBRECFM_VBM EQU X'50'           VARIABLE BLOCKED
DCBRECFM_FT  EQU X'A0'           FIXED ASCII TEXT
DCBRECFM_VT  EQU X'60'           VARIABLE ASCII TEXT
DCBRECU      EQU X'C0'           UNDEFINED RCDS NOT SUPPORTED RPI 989
         ORG   IHADCB+X'28'
DCBDDNAM DS    CL8            DDNAME > ENV VAR > FILE NAME
         ORG   IHADCB+X'30'
DCBOFLGS DS    X              OPEN FLAGS
DCBOFLGS_OPEN EQU X'10'          FILE OPEN (X'80' > X'10' RPI 906)_
DCBOFOPN      EQU X'10'          FILE OPEN RPI 906
DCBOFLGS_GM   EQU X'40'          READ  ALLOWED
DCBOFLGS_PM   EQU X'20'          WRITE ALLOWED
DCBOFLGS_GL   EQU X'40'          READ  ALLOWED
DCBOFLGS_PL   EQU X'20'          WRITE ALLOWED
DCBOFLGS_R    EQU X'40'          READ  ALLOWED
DCBOFLGS_W    EQU X'20'          WRITE ALLOWED
DCBOFLGS_RW   EQU X'60'          READ AND WRITE ALLOWED
         ORG   IHADCB+X'32'
DCBMACRF DS    H              MACRO REFERENCE ACCESS TYPE
DCBMACRF_GM EQU X'5000'         GET MOVE   QSAM
DCBMACRF_PM EQU X'0050'         PUT MOVE   QSAM
DCBMACRF_GL EQU X'4800'         GET LOCATE QSAM    RPI 764
DCBMACRF_PL EQU X'0048'         PUT LOCATE QSAM    RPI 764
DCBMACRF_R  EQU X'2000'         READ  RANDOM BDAM
DCBMACRF_W  EQU X'0020'         WRITE RANDOM BDAM
DCBMACRF_RW EQU X'2020'         READ/WRITE RANDOM BDAM
         ORG   IHADCB+X'38'
DCBSYNAD DS    A              ERROR EXIT
         ORG   IHADCB+X'3C'
DCBBLKSIF DS   F              BLOCK SIZE    RPI 587 32 BIT BLOCK SIZE
         ORG   IHADCB+X'3E'
DCBBLKSI DS    H              BLOCK SIZE    (ALSO UNBLOCKED MAX RECORD)
         ORG   IHADCB+X'50'
DCBLRECLF DS   F              RECORD LENGTH RPI 587 32 BIT RECORD LEN
         ORG   IHADCB+X'52'
DCBLRECL DS    H              RECORD LENGTH (MAY BE ZERO FOR UNBLOCKED)
         ORG   IHADCB+X'58'
DCBREC   DS    A      X'58'   ADDRESS OF USER SUPPLIED RECORD AREA
DCBDSNAM DS    A      X'5C'   ADDRESS OF USER SUPPLIED DSN FILE SPEC
DCBDCBE  DS    A      X'60'   ADDRESS OF DCBE EODAD/SYNAD  RPI 281
DCBIO    DS    F      X'64'   TOTAL DCB IO OPERATIONS SINCE OPEN
DCBLEN   EQU   *-IHADCB
SUPERZAP        CSECT                              RPI 591
*MEXIT #=    40 LV= 3 DCBD
*MEXIT #=    39 LV= 2 ZOPEN
*MEXIT #=    38 LV= 1 OPEN
*MCALL #=    41 LV= 1          PEXIT 
         B     CMD_INIT-4
*MEXIT #=    41 LV= 1 PEXIT
*
* CMD CLOSE - SAVE FILE IF UPDATED AND CLOSE OPEN FILES
*
*MCALL #=    42 LV= 1 CMD_CLOSE PENTRY 
         DC    0H'0',CL8'CMD_CLOSE'
         B     *+4
CMD_CLOSE EQU  *
*MEXIT #=    42 LV= 1 PENTRY
         LA   R2,=CL80'SUPERZAP ENDING'
*MCALL #=    43 LV= 1          PM   DISPLAY
         MVC   DISPLAY-2(2),*+10
         B     DISPLAY
         DC    S(*+2)
*MEXIT #=    43 LV= 1 PM
*MCALL #=    44 LV= 1          IF   (CLI,FILE_UPDATE,EQ,TRUE)
*MCALL #=    45 LV= 2          ZSTREQU 
*MEXIT #=    45 LV= 2 ZSTREQU
         CLI   FILE_UPDATE,TRUE
         BC    15-EQ,#@IF_5_2
*MEXIT #=    44 LV= 1 IF
*MCALL #=    46 LV= 1               PM CMD_UPDATE_FILE
         MVC   CMD_UPDATE_FILE-2(2),*+10
         B     CMD_UPDATE_FILE
         DC    S(*+2)
*MEXIT #=    46 LV= 1 PM
*MCALL #=    47 LV= 1          ENDIF 
*MCALL #=    48 LV= 2          ZSTREQU 
*MEXIT #=    48 LV= 2 ZSTREQU
#@IF_5_2                                                 DS 0H
*MEXIT #=    47 LV= 1 ENDIF
*MCALL #=    49 LV= 1          IF   (CLI,CONSOLE,NE,TRUE)
*MCALL #=    50 LV= 2          ZSTREQU 
*MEXIT #=    50 LV= 2 ZSTREQU
         CLI   CONSOLE,TRUE
         BC    15-NE,#@IF_6_2
*MEXIT #=    49 LV= 1 IF
*MCALL #=    51 LV= 1               CLOSE (SYSIN,,SYSPRINT)
*MCALL #=    52 LV= 2          ZCLOSE (SYSIN,,SYSPRINT),MODE=,MF=I,TYPEX
               =
                       LA     1,SYSIN
                   SVC   20 CLOSE R1=DCB/ACB
                          LTR   15,15
                          BNZ   Z390_CLOSE_EXIT0052 RPI 668
                       LA     1,SYSPRINT
                   SVC   20 CLOSE R1=DCB/ACB
Z390_CLOSE_EXIT0052    EQU *
*MEXIT #=    52 LV= 2 ZCLOSE
*MEXIT #=    51 LV= 1 CLOSE
*MCALL #=    53 LV= 1          ENDIF 
*MCALL #=    54 LV= 2          ZSTREQU 
*MEXIT #=    54 LV= 2 ZSTREQU
#@IF_6_2                                                 DS 0H
*MEXIT #=    53 LV= 1 ENDIF
*MCALL #=    55 LV= 1          PEXIT 
         B     CMD_CLOSE-4
*MEXIT #=    55 LV= 1 PEXIT
*MCALL #=    56 LV= 1 GET_CMD  PENTRY 
         DC    0H'0',CL8'GET_CMD'
         B     *+4
GET_CMD  EQU   *
*MEXIT #=    56 LV= 1 PENTRY
*MCALL #=    57 LV= 1          IF    (CLI,EOF,EQ,TRUE)  SET BY END FROMX
                CONSOLE?
*MCALL #=    58 LV= 2          ZSTREQU 
*MEXIT #=    58 LV= 2 ZSTREQU
         CLI   EOF,TRUE
         BC    15-EQ,#@IF_7_2
*MEXIT #=    57 LV= 1 IF
*MCALL #=    59 LV= 1                PEXIT 
         B     GET_CMD-4
*MEXIT #=    59 LV= 1 PEXIT
*MCALL #=    60 LV= 1          ENDIF 
*MCALL #=    61 LV= 2          ZSTREQU 
*MEXIT #=    61 LV= 2 ZSTREQU
#@IF_7_2                                                 DS 0H
*MEXIT #=    60 LV= 1 ENDIF
*MCALL #=    62 LV= 1          IF    (CLI,LOOP,EQ,TRUE)
*MCALL #=    63 LV= 2          ZSTREQU 
*MEXIT #=    63 LV= 2 ZSTREQU
         CLI   LOOP,TRUE
         BC    15-EQ,#@IF_8_2
*MEXIT #=    62 LV= 1 IF
*MCALL #=    64 LV= 1                IF (CLC,CUR_CMD,LT,NEXT_CMD)
*MCALL #=    65 LV= 2          ZSTREQU 
*MEXIT #=    65 LV= 2 ZSTREQU
         CLC   CUR_CMD,NEXT_CMD
         BC    15-LT,#@IF_9_2
*MEXIT #=    64 LV= 1 IF
                  L   R1,CUR_CMD
                  MVC CMD,0(R1)
                  AHI R1,80
                  ST  R1,CUR_CMD
*MCALL #=    66 LV= 1                   PEXIT 
         B     GET_CMD-4
*MEXIT #=    66 LV= 1 PEXIT
*MCALL #=    67 LV= 1                ELSE 
*MCALL #=    68 LV= 2          ZSTREQU 
*MEXIT #=    68 LV= 2 ZSTREQU
        B      #@IF_9_E
#@IF_9_2                                                 DS 0H
*MEXIT #=    67 LV= 1 ELSE
                  MVI LOOP,FALSE
*MCALL #=    69 LV= 1                ENDIF 
*MCALL #=    70 LV= 2          ZSTREQU 
*MEXIT #=    70 LV= 2 ZSTREQU
#@IF_9_E                         DS 0H
*MEXIT #=    69 LV= 1 ENDIF
*MCALL #=    71 LV= 1          ENDIF 
*MCALL #=    72 LV= 2          ZSTREQU 
*MEXIT #=    72 LV= 2 ZSTREQU
#@IF_8_2                                                 DS 0H
*MEXIT #=    71 LV= 1 ENDIF
*MCALL #=    73 LV= 1          IF    (CLI,CONSOLE,EQ,TRUE)
*MCALL #=    74 LV= 2          ZSTREQU 
*MEXIT #=    74 LV= 2 ZSTREQU
         CLI   CONSOLE,TRUE
         BC    15-EQ,#@IF_10_2
*MEXIT #=    73 LV= 1 IF
               XC   WTORECB,WTORECB
*MCALL #=    75 LV= 1                WTOR 'ENTER SUPERZAP COMMAND OR HEX
               LP',CMD,80,WTORECB
         BAL   1,*+(WTOR#0075_EOT-*+1)/2*2
         DC    AL2(WTOR#0075_EOT-*,0),C'ENTER SUPERZAP COMMAND OR HELP'
WTOR#0075_EOT     EQU *
         LA    0,CMD
         LA    14,80
         LA    15,WTORECB
         SVC   160 WTOR R1=MSG,R0=REPLY,R14=LEN,R15=ECB
*MEXIT #=    75 LV= 1 WTOR
*MCALL #=    76 LV= 1                WAIT ECB=WTORECB
         SR    0,0
         LA    1,WTORECB
         SVC   1 (R0=0,R1=A(ECB) OR (R0=NUM,R1=ECBLIST)
*MEXIT #=    76 LV= 1 WAIT
*MCALL #=    77 LV= 1          ELSE 
*MCALL #=    78 LV= 2          ZSTREQU 
*MEXIT #=    78 LV= 2 ZSTREQU
        B      #@IF_10_E
#@IF_10_2                                                DS 0H
*MEXIT #=    77 LV= 1 ELSE
*MCALL #=    79 LV= 1                GET   SYSIN,CMD
         LA    1,SYSIN
         LA    0,CMD
         SVC  151
*MEXIT #=    79 LV= 1 GET
*MCALL #=    80 LV= 1          ENDIF 
*MCALL #=    81 LV= 2          ZSTREQU 
*MEXIT #=    81 LV= 2 ZSTREQU
#@IF_10_E                        DS 0H
*MEXIT #=    80 LV= 1 ENDIF
*MCALL #=    82 LV= 1          IF    (CLC,NEXT_CMD,GT,=A(CMD_LIST))  ARX
               E WE SAVING FIND CMDS
*MCALL #=    83 LV= 2          ZSTREQU 
*MEXIT #=    83 LV= 2 ZSTREQU
         CLC   NEXT_CMD,=A(CMD_LIST)
         BC    15-GT,#@IF_11_2
*MEXIT #=    82 LV= 1 IF
*MCALL #=    84 LV= 1                IF  (CLC,NEXT_CMD,GE,=A(CMD_LIST_EX
               ND))
*MCALL #=    85 LV= 2          ZSTREQU 
*MEXIT #=    85 LV= 2 ZSTREQU
         CLC   NEXT_CMD,=A(CMD_LIST_END)
         BC    15-GE,#@IF_12_2
*MEXIT #=    84 LV= 1 IF
                   LA  R2,=CL80'LOOP CMD LIST EXCEEDED'
*MCALL #=    86 LV= 1                    PM  DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=    86 LV= 1 PM
*MCALL #=    87 LV= 1                ELSE 
*MCALL #=    88 LV= 2          ZSTREQU 
*MEXIT #=    88 LV= 2 ZSTREQU
        B      #@IF_12_E
#@IF_12_2                                                DS 0H
*MEXIT #=    87 LV= 1 ELSE
                   L   R1,NEXT_CMD
                   MVC 0(80,R1),CMD
                   AHI R1,80
                   ST  R1,NEXT_CMD
*MCALL #=    89 LV= 1                ENDIF 
*MCALL #=    90 LV= 2          ZSTREQU 
*MEXIT #=    90 LV= 2 ZSTREQU
#@IF_12_E                        DS 0H
*MEXIT #=    89 LV= 1 ENDIF
*MCALL #=    91 LV= 1          ENDIF 
*MCALL #=    92 LV= 2          ZSTREQU 
*MEXIT #=    92 LV= 2 ZSTREQU
#@IF_11_2                                                DS 0H
*MEXIT #=    91 LV= 1 ENDIF
*MCALL #=    93 LV= 1          PEXIT 
         B     GET_CMD-4
*MEXIT #=    93 LV= 1 PEXIT
GET_EOF  DS    0H
         MVI   EOF,TRUE
*MCALL #=    94 LV= 1          PEXIT 
         B     GET_CMD-4
*MEXIT #=    94 LV= 1 PEXIT
*MCALL #=    95 LV= 1 CMD_PROCESS  PENTRY 
         DC    0H'0',CL8'CMD_PROCESS'
         B     *+4
CMD_PROCESS EQU *
*MEXIT #=    95 LV= 1 PENTRY
*MCALL #=    96 LV= 1          IF    (CLI,CONSOLE,NE,TRUE)
*MCALL #=    97 LV= 2          ZSTREQU 
*MEXIT #=    97 LV= 2 ZSTREQU
         CLI   CONSOLE,TRUE
         BC    15-NE,#@IF_13_2
*MEXIT #=    96 LV= 1 IF
               LA    R2,CMD
*MCALL #=    98 LV= 1                PM    DISPLAY
         MVC   DISPLAY-2(2),*+10
         B     DISPLAY
         DC    S(*+2)
*MEXIT #=    98 LV= 1 PM
*MCALL #=    99 LV= 1          ENDIF 
*MCALL #=   100 LV= 2          ZSTREQU 
*MEXIT #=   100 LV= 2 ZSTREQU
#@IF_13_2                                                DS 0H
*MEXIT #=    99 LV= 1 ENDIF
         MVI   PARM_ERROR,FALSE
         LA    R2,CMD
*MCALL #=   101 LV= 1          PM    FIND_OP
         MVC   FIND_OP-2(2),*+10
         B     FIND_OP
         DC    S(*+2)
*MEXIT #=   101 LV= 1 PM
*MCALL #=   102 LV= 1          IF    (CLC,OP(5),EQ,=C'ASCII')   SWITCH X
               TO ASCII TEXT MODE
*MCALL #=   103 LV= 2          ZSTREQU 
*MEXIT #=   103 LV= 2 ZSTREQU
         CLC   OP(5),=C'ASCII'
         BC    15-EQ,#@IF_14_2
*MEXIT #=   102 LV= 1 IF
*MCALL #=   104 LV= 1                PM  CMD_ASCII
         MVC   CMD_ASCII-2(2),*+10
         B     CMD_ASCII
         DC    S(*+2)
*MEXIT #=   104 LV= 1 PM
*MCALL #=   105 LV= 1          ELSEIF (CLC,OP(6),EQ,=C'EBCDIC') SWITCH X
               TO EBCDIC TEXT (DEF)
*MCALL #=   106 LV= 2          ZSTREQU 
*MEXIT #=   106 LV= 2 ZSTREQU
         B     #@IF_14_E
#@IF_14_2                                                DS 0H
         CLC   OP(6),=C'EBCDIC'
         BC    15-EQ,#@IF_14_4
*MEXIT #=   105 LV= 1 ELSEIF
*MCALL #=   107 LV= 1                PM  CMD_EBCDIC
         MVC   CMD_EBCDIC-2(2),*+10
         B     CMD_EBCDIC
         DC    S(*+2)
*MEXIT #=   107 LV= 1 PM
*MCALL #=   108 LV= 1          ELSEIF (CLC,OP(4),EQ,=C'NAME')   NAME FIX
               LE-SPEC
*MCALL #=   109 LV= 2          ZSTREQU 
*MEXIT #=   109 LV= 2 ZSTREQU
         B     #@IF_14_E
#@IF_14_4                                                DS 0H
         CLC   OP(4),=C'NAME'
         BC    15-EQ,#@IF_14_6
*MEXIT #=   108 LV= 1 ELSEIF
*MCALL #=   110 LV= 1                PM  CMD_NAME
         MVC   CMD_NAME-2(2),*+10
         B     CMD_NAME
         DC    S(*+2)
*MEXIT #=   110 LV= 1 PM
*MCALL #=   111 LV= 1          ELSEIF (CLC,OP(3),EQ,=C'VER')    VER  HEX
               X-OFFSET VALUE
*MCALL #=   112 LV= 2          ZSTREQU 
*MEXIT #=   112 LV= 2 ZSTREQU
         B     #@IF_14_E
#@IF_14_6                                                DS 0H
         CLC   OP(3),=C'VER'
         BC    15-EQ,#@IF_14_8
*MEXIT #=   111 LV= 1 ELSEIF
*MCALL #=   113 LV= 1                PM  CMD_VERIFY
         MVC   CMD_VERIFY-2(2),*+10
         B     CMD_VERIFY
         DC    S(*+2)
*MEXIT #=   113 LV= 1 PM
*MCALL #=   114 LV= 1          ELSEIF (CLC,OP(3),EQ,=C'REP')    REP  HEX
               X-OFFSET VALUE
*MCALL #=   115 LV= 2          ZSTREQU 
*MEXIT #=   115 LV= 2 ZSTREQU
         B     #@IF_14_E
#@IF_14_8                                                DS 0H
         CLC   OP(3),=C'REP'
         BC    15-EQ,#@IF_14_10
*MEXIT #=   114 LV= 1 ELSEIF
*MCALL #=   116 LV= 1                PM  CMD_REPLACE
         MVC   CMD_REPLACE-2(2),*+10
         B     CMD_REPLACE
         DC    S(*+2)
*MEXIT #=   116 LV= 1 PM
*MCALL #=   117 LV= 1          ELSEIF (CLC,OP(4),EQ,=C'DUMP')   DUMP HEX
               X-OFFSET HEX-LENGTH
*MCALL #=   118 LV= 2          ZSTREQU 
*MEXIT #=   118 LV= 2 ZSTREQU
         B     #@IF_14_E
#@IF_14_10                                               DS 0H
         CLC   OP(4),=C'DUMP'
         BC    15-EQ,#@IF_14_12
*MEXIT #=   117 LV= 1 ELSEIF
*MCALL #=   119 LV= 1                PM  CMD_DUMP
         MVC   CMD_DUMP-2(2),*+10
         B     CMD_DUMP
         DC    S(*+2)
*MEXIT #=   119 LV= 1 PM
*MCALL #=   120 LV= 1          ELSEIF (CLC,OP(4),EQ,=C'FIND')   FIND HEX
               X-LENGTH VALUE
*MCALL #=   121 LV= 2          ZSTREQU 
*MEXIT #=   121 LV= 2 ZSTREQU
         B     #@IF_14_E
#@IF_14_12                                               DS 0H
         CLC   OP(4),=C'FIND'
         BC    15-EQ,#@IF_14_14
*MEXIT #=   120 LV= 1 ELSEIF
*MCALL #=   122 LV= 1                PM  CMD_FIND
         MVC   CMD_FIND-2(2),*+10
         B     CMD_FIND
         DC    S(*+2)
*MEXIT #=   122 LV= 1 PM
*MCALL #=   123 LV= 1          ELSEIF (CLC,OP(4),EQ,=C'BASE')   BASE HEX
               X-OFFSET
*MCALL #=   124 LV= 2          ZSTREQU 
*MEXIT #=   124 LV= 2 ZSTREQU
         B     #@IF_14_E
#@IF_14_14                                               DS 0H
         CLC   OP(4),=C'BASE'
         BC    15-EQ,#@IF_14_16
*MEXIT #=   123 LV= 1 ELSEIF
*MCALL #=   125 LV= 1                PM  CMD_BASE
         MVC   CMD_BASE-2(2),*+10
         B     CMD_BASE
         DC    S(*+2)
*MEXIT #=   125 LV= 1 PM
*MCALL #=   126 LV= 1          ELSEIF (CLC,OP(4),EQ,=C'HELP')   HELP
*MCALL #=   127 LV= 2          ZSTREQU 
*MEXIT #=   127 LV= 2 ZSTREQU
         B     #@IF_14_E
#@IF_14_16                                               DS 0H
         CLC   OP(4),=C'HELP'
         BC    15-EQ,#@IF_14_18
*MEXIT #=   126 LV= 1 ELSEIF
*MCALL #=   128 LV= 1                PM  CMD_HELP
         MVC   CMD_HELP-2(2),*+10
         B     CMD_HELP
         DC    S(*+2)
*MEXIT #=   128 LV= 1 PM
*MCALL #=   129 LV= 1          ELSEIF (CLC,OP(4),EQ,=C'LOOP')   LOOP
*MCALL #=   130 LV= 2          ZSTREQU 
*MEXIT #=   130 LV= 2 ZSTREQU
         B     #@IF_14_E
#@IF_14_18                                               DS 0H
         CLC   OP(4),=C'LOOP'
         BC    15-EQ,#@IF_14_20
*MEXIT #=   129 LV= 1 ELSEIF
*MCALL #=   131 LV= 1                PM  CMD_LOOP
         MVC   CMD_LOOP-2(2),*+10
         B     CMD_LOOP
         DC    S(*+2)
*MEXIT #=   131 LV= 1 PM
*MCALL #=   132 LV= 1          ELSEIF (CLC,OP(3),EQ,=C'END')    END CONX
               SOLE INPUT
*MCALL #=   133 LV= 2          ZSTREQU 
*MEXIT #=   133 LV= 2 ZSTREQU
         B     #@IF_14_E
#@IF_14_20                                               DS 0H
         CLC   OP(3),=C'END'
         BC    15-EQ,#@IF_14_22
*MEXIT #=   132 LV= 1 ELSEIF
               MVI EOF,TRUE
*MCALL #=   134 LV= 1          ELSEIF (CLI,OP,NE,C'*')          * COMMEX
               NT ELSE ERROR
*MCALL #=   135 LV= 2          ZSTREQU 
*MEXIT #=   135 LV= 2 ZSTREQU
         B     #@IF_14_E
#@IF_14_22                                               DS 0H
         CLI   OP,C'*'
         BC    15-NE,#@IF_14_24
*MEXIT #=   134 LV= 1 ELSEIF
               LA  R2,=CL80'UNKNOWN COMMAND'
*MCALL #=   136 LV= 1                PM  DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   136 LV= 1 PM
*MCALL #=   137 LV= 1          ENDIF 
*MCALL #=   138 LV= 2          ZSTREQU 
*MEXIT #=   138 LV= 2 ZSTREQU
#@IF_14_24                                               DS 0H
#@IF_14_E                        DS 0H
*MEXIT #=   137 LV= 1 ENDIF
*MCALL #=   139 LV= 1          PEXIT 
         B     CMD_PROCESS-4
*MEXIT #=   139 LV= 1 PEXIT
*
* SWITCH TO ASCII MODE
*
*MCALL #=   140 LV= 1 CMD_ASCII PENTRY 
         DC    0H'0',CL8'CMD_ASCII'
         B     *+4
CMD_ASCII EQU  *
*MEXIT #=   140 LV= 1 PENTRY
         MVI  EBCDIC_TEXT,FALSE
*MCALL #=   141 LV= 1          PEXIT 
         B     CMD_ASCII-4
*MEXIT #=   141 LV= 1 PEXIT
*
* SWITCH TO EBCDIC MODE
*
*MCALL #=   142 LV= 1 CMD_EBCDIC PENTRY 
         DC    0H'0',CL8'CMD_EBCDIC'
         B     *+4
CMD_EBCDIC EQU *
*MEXIT #=   142 LV= 1 PENTRY
         MVI  EBCDIC_TEXT,TRUE
*MCALL #=   143 LV= 1          PEXIT 
         B     CMD_EBCDIC-4
*MEXIT #=   143 LV= 1 PEXIT
*
* FIND OPERATON, PLACE IN OP, AND SKIP TO NEXT SPACE
*
*MCALL #=   144 LV= 1 FIND_OP  PENTRY 
         DC    0H'0',CL8'FIND_OP'
         B     *+4
FIND_OP  EQU   *
*MEXIT #=   144 LV= 1 PENTRY
         MVC   OP,=CL8' '
*MCALL #=   145 LV= 1          PM    FIND_CHAR
         MVC   FIND_CHAR-2(2),*+10
         B     FIND_CHAR
         DC    S(*+2)
*MEXIT #=   145 LV= 1 PM
         LR    R3,R2
*MCALL #=   146 LV= 1          DO    WHILE=((C,R2,LT,=A(CMD+80)),AND,(CX
               LI,0(R2),NE,C' '))
*MCALL #=   147 LV= 2          ZSTREQU 
*MEXIT #=   147 LV= 2 ZSTREQU
#@DO_2_T                         DS 0H
*MCALL #=   148 LV= 2          IF (C,R2,LT,=A(CMD+80)),AND,(CLI,0(R2),NX
               E,C' ')
*MCALL #=   149 LV= 3          ZSTREQU 
*MEXIT #=   149 LV= 3 ZSTREQU
         C     R2,=A(CMD+80)
         BC    15-LT,#@IF_15_2
         CLI   0(R2),C' '
         BC    15-NE,#@IF_15_2
*MEXIT #=   148 LV= 2 IF
               B   #@DO_2_1
*MCALL #=   150 LV= 2          ENDIF 
*MCALL #=   151 LV= 3          ZSTREQU 
*MEXIT #=   151 LV= 3 ZSTREQU
#@IF_15_2                                                DS 0H
*MEXIT #=   150 LV= 2 ENDIF
         B     #@DO_2_E
#@DO_2_1                         DS 0H
*MEXIT #=   146 LV= 1 DO
               AHI R2,1
*MCALL #=   152 LV= 1          ENDDO 
*MCALL #=   153 LV= 2          DO    END
*MCALL #=   154 LV= 3          ZSTREQU 
*MEXIT #=   154 LV= 3 ZSTREQU
         B     #@DO_2_T
#@DO_2_E                         DS 0H
*MEXIT #=   153 LV= 2 DO
*MEXIT #=   152 LV= 1 ENDDO
         LR    R1,R2
         SR    R1,R3
*MCALL #=   155 LV= 1          IF    (C,R1,LE,=F'8'),AND,(C,R1,GT,=F'0'X
               )
*MCALL #=   156 LV= 2          ZSTREQU 
*MEXIT #=   156 LV= 2 ZSTREQU
         C     R1,=F'8'
         BC    15-LE,#@IF_16_2
         C     R1,=F'0'
         BC    15-GT,#@IF_16_2
*MEXIT #=   155 LV= 1 IF
               AHI R1,-1
               EX  R1,FIND_OP_MVC
*MCALL #=   157 LV= 1          ENDIF 
*MCALL #=   158 LV= 2          ZSTREQU 
*MEXIT #=   158 LV= 2 ZSTREQU
#@IF_16_2                                                DS 0H
*MEXIT #=   157 LV= 1 ENDIF
         OC    OP,=CL8' ' FORCE UPPER CASE OPCODE
*MCALL #=   159 LV= 1          PEXIT 
         B     FIND_OP-4
*MEXIT #=   159 LV= 1 PEXIT
FIND_OP_MVC MVC OP(0),0(R3)
*
* FIND NEXT SPACE CHAR IN CMD AT R2
*
*MCALL #=   160 LV= 1 FIND_SPACE PENTRY 
         DC    0H'0',CL8'FIND_SPACE'
         B     *+4
FIND_SPACE EQU *
*MEXIT #=   160 LV= 1 PENTRY
*MCALL #=   161 LV= 1          DO    WHILE=(CLI,0(R2),NE,C' ')
*MCALL #=   162 LV= 2          ZSTREQU 
*MEXIT #=   162 LV= 2 ZSTREQU
#@DO_3_T                         DS 0H
*MCALL #=   163 LV= 2          IF CLI,0(R2),NE,C' '
*MCALL #=   164 LV= 3          ZSTREQU 
*MEXIT #=   164 LV= 3 ZSTREQU
         CLI   0(R2),C' '
         BC    15-NE,#@IF_17_2
*MEXIT #=   163 LV= 2 IF
               B   #@DO_3_1
*MCALL #=   165 LV= 2          ENDIF 
*MCALL #=   166 LV= 3          ZSTREQU 
*MEXIT #=   166 LV= 3 ZSTREQU
#@IF_17_2                                                DS 0H
*MEXIT #=   165 LV= 2 ENDIF
         B     #@DO_3_E
#@DO_3_1                         DS 0H
*MEXIT #=   161 LV= 1 DO
               AHI  R2,1
*MCALL #=   167 LV= 1          ENDDO 
*MCALL #=   168 LV= 2          DO    END
*MCALL #=   169 LV= 3          ZSTREQU 
*MEXIT #=   169 LV= 3 ZSTREQU
         B     #@DO_3_T
#@DO_3_E                         DS 0H
*MEXIT #=   168 LV= 2 DO
*MEXIT #=   167 LV= 1 ENDDO
*MCALL #=   170 LV= 1          PEXIT 
         B     FIND_SPACE-4
*MEXIT #=   170 LV= 1 PEXIT
*
* FIND NEXT NON SPACE CHAR IN CMD AT R2
*
*MCALL #=   171 LV= 1 FIND_CHAR PENTRY 
         DC    0H'0',CL8'FIND_CHAR'
         B     *+4
FIND_CHAR EQU  *
*MEXIT #=   171 LV= 1 PENTRY
*MCALL #=   172 LV= 1          DO    WHILE=(CLI,0(R2),EQ,C' ')
*MCALL #=   173 LV= 2          ZSTREQU 
*MEXIT #=   173 LV= 2 ZSTREQU
#@DO_4_T                         DS 0H
*MCALL #=   174 LV= 2          IF CLI,0(R2),EQ,C' '
*MCALL #=   175 LV= 3          ZSTREQU 
*MEXIT #=   175 LV= 3 ZSTREQU
         CLI   0(R2),C' '
         BC    15-EQ,#@IF_18_2
*MEXIT #=   174 LV= 2 IF
               B   #@DO_4_1
*MCALL #=   176 LV= 2          ENDIF 
*MCALL #=   177 LV= 3          ZSTREQU 
*MEXIT #=   177 LV= 3 ZSTREQU
#@IF_18_2                                                DS 0H
*MEXIT #=   176 LV= 2 ENDIF
         B     #@DO_4_E
#@DO_4_1                         DS 0H
*MEXIT #=   172 LV= 1 DO
               AHI  R2,1
*MCALL #=   178 LV= 1          ENDDO 
*MCALL #=   179 LV= 2          DO    END
*MCALL #=   180 LV= 3          ZSTREQU 
*MEXIT #=   180 LV= 3 ZSTREQU
         B     #@DO_4_T
#@DO_4_E                         DS 0H
*MEXIT #=   179 LV= 2 DO
*MEXIT #=   178 LV= 1 ENDDO
*MCALL #=   181 LV= 1          PEXIT 
         B     FIND_CHAR-4
*MEXIT #=   181 LV= 1 PEXIT
*
* DUMP OFFSET LENGTH
*
*MCALL #=   182 LV= 1 CMD_DUMP PENTRY 
         DC    0H'0',CL8'CMD_DUMP'
         B     *+4
CMD_DUMP EQU   *
*MEXIT #=   182 LV= 1 PENTRY
*MCALL #=   183 LV= 1          IF    (CLI,FILE_LOADED,NE,TRUE)
*MCALL #=   184 LV= 2          ZSTREQU 
*MEXIT #=   184 LV= 2 ZSTREQU
         CLI   FILE_LOADED,TRUE
         BC    15-NE,#@IF_19_2
*MEXIT #=   183 LV= 1 IF
               LA  R2,=CL80'DUMP SKIPPED DUE TO FILE ERROR'
*MCALL #=   185 LV= 1                PM  DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   185 LV= 1 PM
*MCALL #=   186 LV= 1                PEXIT 
         B     CMD_DUMP-4
*MEXIT #=   186 LV= 1 PEXIT
*MCALL #=   187 LV= 1          ENDIF 
*MCALL #=   188 LV= 2          ZSTREQU 
*MEXIT #=   188 LV= 2 ZSTREQU
#@IF_19_2                                                DS 0H
*MEXIT #=   187 LV= 1 ENDIF
*MCALL #=   189 LV= 1          PM    FIND_CHAR
         MVC   FIND_CHAR-2(2),*+10
         B     FIND_CHAR
         DC    S(*+2)
*MEXIT #=   189 LV= 1 PM
*MCALL #=   190 LV= 1          IF    (C,R2,LT,=A(CMD+80))
*MCALL #=   191 LV= 2          ZSTREQU 
*MEXIT #=   191 LV= 2 ZSTREQU
         C     R2,=A(CMD+80)
         BC    15-LT,#@IF_20_2
*MEXIT #=   190 LV= 1 IF
*MCALL #=   192 LV= 1                PM    GET_OFFSET
         MVC   GET_OFFSET-2(2),*+10
         B     GET_OFFSET
         DC    S(*+2)
*MEXIT #=   192 LV= 1 PM
               ST    R0,OFFSET
*MCALL #=   193 LV= 1                PM    GET_HEX
         MVC   GET_HEX-2(2),*+10
         B     GET_HEX
         DC    S(*+2)
*MEXIT #=   193 LV= 1 PM
               ST    R0,LENGTH
*MCALL #=   194 LV= 1          ELSE 
*MCALL #=   195 LV= 2          ZSTREQU 
*MEXIT #=   195 LV= 2 ZSTREQU
        B      #@IF_20_E
#@IF_20_2                                                DS 0H
*MEXIT #=   194 LV= 1 ELSE
               SR    R0,R0
               ST    R0,OFFSET
               LR    R0,R10
               SR    R0,R9
               ST    R0,LENGTH
*MCALL #=   196 LV= 1          ENDIF 
*MCALL #=   197 LV= 2          ZSTREQU 
*MEXIT #=   197 LV= 2 ZSTREQU
#@IF_20_E                        DS 0H
*MEXIT #=   196 LV= 1 ENDIF
*MCALL #=   198 LV= 1          IF    (CLI,PARM_ERROR,EQ,TRUE)
*MCALL #=   199 LV= 2          ZSTREQU 
*MEXIT #=   199 LV= 2 ZSTREQU
         CLI   PARM_ERROR,TRUE
         BC    15-EQ,#@IF_21_2
*MEXIT #=   198 LV= 1 IF
               LA  R2,=CL80'DUMP SKIPPED DUE TO INVALID PARM'
*MCALL #=   200 LV= 1                PM  DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   200 LV= 1 PM
*MCALL #=   201 LV= 1                PEXIT 
         B     CMD_DUMP-4
*MEXIT #=   201 LV= 1 PEXIT
*MCALL #=   202 LV= 1          ENDIF 
*MCALL #=   203 LV= 2          ZSTREQU 
*MEXIT #=   203 LV= 2 ZSTREQU
#@IF_21_2                                                DS 0H
*MEXIT #=   202 LV= 1 ENDIF
         L     R2,OFFSET
         LA    R3,0(R2,R9)  R1 = BASE + OFFSET
         L     R4,LENGTH
*MCALL #=   204 LV= 1          PM    DUMP_REQ DUMP MEMORY AT R3 FOR LENX
               GTH R4
         MVC   DUMP_REQ-2(2),*+10
         B     DUMP_REQ
         DC    S(*+2)
*MEXIT #=   204 LV= 1 PM
*MCALL #=   205 LV= 1          PEXIT 
         B     CMD_DUMP-4
*MEXIT #=   205 LV= 1 PEXIT
*
* BASE OFFSET OR *-+OFFSET = SET CURRENT BASE AND LOCATION
*
*MCALL #=   206 LV= 1 CMD_BASE PENTRY 
         DC    0H'0',CL8'CMD_BASE'
         B     *+4
CMD_BASE EQU   *
*MEXIT #=   206 LV= 1 PENTRY
*MCALL #=   207 LV= 1          IF    (CLI,FILE_LOADED,NE,TRUE)
*MCALL #=   208 LV= 2          ZSTREQU 
*MEXIT #=   208 LV= 2 ZSTREQU
         CLI   FILE_LOADED,TRUE
         BC    15-NE,#@IF_22_2
*MEXIT #=   207 LV= 1 IF
               LA  R2,=CL80'BASE SKIPPED DUE TO FILE ERROR'
*MCALL #=   209 LV= 1                PM  DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   209 LV= 1 PM
*MCALL #=   210 LV= 1                PEXIT 
         B     CMD_BASE-4
*MEXIT #=   210 LV= 1 PEXIT
*MCALL #=   211 LV= 1          ENDIF 
*MCALL #=   212 LV= 2          ZSTREQU 
*MEXIT #=   212 LV= 2 ZSTREQU
#@IF_22_2                                                DS 0H
*MEXIT #=   211 LV= 1 ENDIF
*MCALL #=   213 LV= 1          PM    GET_OFFSET
         MVC   GET_OFFSET-2(2),*+10
         B     GET_OFFSET
         DC    S(*+2)
*MEXIT #=   213 LV= 1 PM
         ST    R0,BASE
*MCALL #=   214 LV= 1          PEXIT 
         B     CMD_BASE-4
*MEXIT #=   214 LV= 1 PEXIT
*
*
*
*MCALL #=   215 LV= 1 GET_OFFSET PENTRY 
         DC    0H'0',CL8'GET_OFFSET'
         B     *+4
GET_OFFSET EQU *
*MEXIT #=   215 LV= 1 PENTRY
*MCALL #=   216 LV= 1          PM    FIND_CHAR
         MVC   FIND_CHAR-2(2),*+10
         B     FIND_CHAR
         DC    S(*+2)
*MEXIT #=   216 LV= 1 PM
*MCALL #=   217 LV= 1          IF    (CLI,0(R2),EQ,C'*')
*MCALL #=   218 LV= 2          ZSTREQU 
*MEXIT #=   218 LV= 2 ZSTREQU
         CLI   0(R2),C'*'
         BC    15-EQ,#@IF_23_2
*MEXIT #=   217 LV= 1 IF
*MCALL #=   219 LV= 1                IF  (CLI,1(R2),EQ,C'+')
*MCALL #=   220 LV= 2          ZSTREQU 
*MEXIT #=   220 LV= 2 ZSTREQU
         CLI   1(R2),C'+'
         BC    15-EQ,#@IF_24_2
*MEXIT #=   219 LV= 1 IF
                   AHI  R2,2
*MCALL #=   221 LV= 1                    PM   GET_HEX
         MVC   GET_HEX-2(2),*+10
         B     GET_HEX
         DC    S(*+2)
*MEXIT #=   221 LV= 1 PM
                   A    R0,BASE
*MCALL #=   222 LV= 1                ELSEIF (CLI,1(R2),EQ,C'-')
*MCALL #=   223 LV= 2          ZSTREQU 
*MEXIT #=   223 LV= 2 ZSTREQU
         B     #@IF_24_E
#@IF_24_2                                                DS 0H
         CLI   1(R2),C'-'
         BC    15-EQ,#@IF_24_4
*MEXIT #=   222 LV= 1 ELSEIF
                   AHI  R2,2
*MCALL #=   224 LV= 1                    PM   GET_HEX
         MVC   GET_HEX-2(2),*+10
         B     GET_HEX
         DC    S(*+2)
*MEXIT #=   224 LV= 1 PM
                   L    R1,BASE
                   SR   R1,R0
                   LR   R0,R1
*MCALL #=   225 LV= 1                ELSE 
*MCALL #=   226 LV= 2          ZSTREQU 
*MEXIT #=   226 LV= 2 ZSTREQU
        B      #@IF_24_E
#@IF_24_4                                                DS 0H
*MEXIT #=   225 LV= 1 ELSE
                   L    R0,BASE
*MCALL #=   227 LV= 1                ENDIF 
*MCALL #=   228 LV= 2          ZSTREQU 
*MEXIT #=   228 LV= 2 ZSTREQU
#@IF_24_E                        DS 0H
*MEXIT #=   227 LV= 1 ENDIF
*MCALL #=   229 LV= 1          ELSE 
*MCALL #=   230 LV= 2          ZSTREQU 
*MEXIT #=   230 LV= 2 ZSTREQU
        B      #@IF_23_E
#@IF_23_2                                                DS 0H
*MEXIT #=   229 LV= 1 ELSE
*MCALL #=   231 LV= 1                PM  GET_HEX
         MVC   GET_HEX-2(2),*+10
         B     GET_HEX
         DC    S(*+2)
*MEXIT #=   231 LV= 1 PM
*MCALL #=   232 LV= 1          ENDIF 
*MCALL #=   233 LV= 2          ZSTREQU 
*MEXIT #=   233 LV= 2 ZSTREQU
#@IF_23_E                        DS 0H
*MEXIT #=   232 LV= 1 ENDIF
         LR    R1,R9
         AR    R1,R0
*MCALL #=   234 LV= 1          IF    (CR,R1,LT,R9),OR,(CR,R1,GE,R10)
*MCALL #=   235 LV= 2          ZSTREQU 
*MEXIT #=   235 LV= 2 ZSTREQU
         CR    R1,R9
         BC    15-LT,#@IF_25_2
         B     #@IF_25_1
#@IF_25_2                                                DS 0H
         CR    R1,R10
         BC    15-GE,#@IF_25_3
#@IF_25_1                               DS 0H
*MEXIT #=   234 LV= 1 IF
               MVI PARM_ERROR,TRUE
               LA  R2,=CL80'OFFSET OUT OF RANGE'
*MCALL #=   236 LV= 1                PM  DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   236 LV= 1 PM
*MCALL #=   237 LV= 1          ENDIF 
*MCALL #=   238 LV= 2          ZSTREQU 
*MEXIT #=   238 LV= 2 ZSTREQU
#@IF_25_3                                                DS 0H
*MEXIT #=   237 LV= 1 ENDIF
         ST    R0,OFFSET
*MCALL #=   239 LV= 1          PM    FIND_SPACE
         MVC   FIND_SPACE-2(2),*+10
         B     FIND_SPACE
         DC    S(*+2)
*MEXIT #=   239 LV= 1 PM
*MCALL #=   240 LV= 1          PEXIT 
         B     GET_OFFSET-4
*MEXIT #=   240 LV= 1 PEXIT
*
* FIND VALUE - SET BASE TO NEXT OCCURANCE OF VALUE STARTING AT BASE+1
*
*MCALL #=   241 LV= 1 CMD_FIND PENTRY 
         DC    0H'0',CL8'CMD_FIND'
         B     *+4
CMD_FIND EQU   *
*MEXIT #=   241 LV= 1 PENTRY
*MCALL #=   242 LV= 1          IF    (CLI,LOOP,NE,TRUE) RESTART SAVING X
               CMDS FOR LOOP
*MCALL #=   243 LV= 2          ZSTREQU 
*MEXIT #=   243 LV= 2 ZSTREQU
         CLI   LOOP,TRUE
         BC    15-NE,#@IF_26_2
*MEXIT #=   242 LV= 1 IF
               MVC CMD_LIST,CMD
               MVC NEXT_CMD,=A(CMD_LIST+80)
*MCALL #=   244 LV= 1          ENDIF 
*MCALL #=   245 LV= 2          ZSTREQU 
*MEXIT #=   245 LV= 2 ZSTREQU
#@IF_26_2                                                DS 0H
*MEXIT #=   244 LV= 1 ENDIF
*MCALL #=   246 LV= 1          IF    (CLI,FILE_LOADED,NE,TRUE)
*MCALL #=   247 LV= 2          ZSTREQU 
*MEXIT #=   247 LV= 2 ZSTREQU
         CLI   FILE_LOADED,TRUE
         BC    15-NE,#@IF_27_2
*MEXIT #=   246 LV= 1 IF
               LA  R2,=CL80'FIND SKIPPED DUE TO FILE ERROR'
*MCALL #=   248 LV= 1                PM  DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   248 LV= 1 PM
*MCALL #=   249 LV= 1                PEXIT 
         B     CMD_FIND-4
*MEXIT #=   249 LV= 1 PEXIT
*MCALL #=   250 LV= 1          ENDIF 
*MCALL #=   251 LV= 2          ZSTREQU 
*MEXIT #=   251 LV= 2 ZSTREQU
#@IF_27_2                                                DS 0H
*MEXIT #=   250 LV= 1 ENDIF
*MCALL #=   252 LV= 1          PM    GET_VALUE
         MVC   GET_VALUE-2(2),*+10
         B     GET_VALUE
         DC    S(*+2)
*MEXIT #=   252 LV= 1 PM
         L     R2,BASE
         AHI   R2,1
         AR    R2,R9
*MCALL #=   253 LV= 1          DO    WHILE=((CLI,PARM_ERROR,NE,TRUE),ANX
               D,(CR,R2,GE,R9),AND,(CR,R2,LT,R10))
*MCALL #=   254 LV= 2          ZSTREQU 
*MEXIT #=   254 LV= 2 ZSTREQU
#@DO_5_T                         DS 0H
*MCALL #=   255 LV= 2          IF (CLI,PARM_ERROR,NE,TRUE),AND,(CR,R2,GX
               E,R9),AND,(CR,R2,LT,R10)
*MCALL #=   256 LV= 3          ZSTREQU 
*MEXIT #=   256 LV= 3 ZSTREQU
         CLI   PARM_ERROR,TRUE
         BC    15-NE,#@IF_28_2
         CR    R2,R9
         BC    15-GE,#@IF_28_2
         CR    R2,R10
         BC    15-LT,#@IF_28_2
*MEXIT #=   255 LV= 2 IF
               B   #@DO_5_1
*MCALL #=   257 LV= 2          ENDIF 
*MCALL #=   258 LV= 3          ZSTREQU 
*MEXIT #=   258 LV= 3 ZSTREQU
#@IF_28_2                                                DS 0H
*MEXIT #=   257 LV= 2 ENDIF
         B     #@DO_5_E
#@DO_5_1                         DS 0H
*MEXIT #=   253 LV= 1 DO
               L   R1,LVALUE
               LA  R0,0(R1,R2) END OF VALUE + 1
               AHI R1,-1
*MCALL #=   259 LV= 1                IF  (CR,R0,LE,R10),AND,(EX,R1,EQ,FX
               IND_CLC)
*MCALL #=   260 LV= 2          ZSTREQU 
*MEXIT #=   260 LV= 2 ZSTREQU
         CR    R0,R10
         BC    15-LE,#@IF_29_2
         EX    R1,FIND_CLC
         BC    15-EQ,#@IF_29_2
*MEXIT #=   259 LV= 1 IF
                   SR  R2,R9
                   ST  R2,BASE
*MCALL #=   261 LV= 1                    PEXIT 
         B     CMD_FIND-4
*MEXIT #=   261 LV= 1 PEXIT
*MCALL #=   262 LV= 1                ELSE 
*MCALL #=   263 LV= 2          ZSTREQU 
*MEXIT #=   263 LV= 2 ZSTREQU
        B      #@IF_29_E
#@IF_29_2                                                DS 0H
*MEXIT #=   262 LV= 1 ELSE
                   AHI R2,1
*MCALL #=   264 LV= 1                ENDIF 
*MCALL #=   265 LV= 2          ZSTREQU 
*MEXIT #=   265 LV= 2 ZSTREQU
#@IF_29_E                        DS 0H
*MEXIT #=   264 LV= 1 ENDIF
*MCALL #=   266 LV= 1          ENDDO 
*MCALL #=   267 LV= 2          DO    END
*MCALL #=   268 LV= 3          ZSTREQU 
*MEXIT #=   268 LV= 3 ZSTREQU
         B     #@DO_5_T
#@DO_5_E                         DS 0H
*MEXIT #=   267 LV= 2 DO
*MEXIT #=   266 LV= 1 ENDDO
         MVI   VER_ERROR,TRUE
         LA    R2,=CL80'FIND VALUE NOT FOUND'
*MCALL #=   269 LV= 1          PM    DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   269 LV= 1 PM
*MCALL #=   270 LV= 1          PEXIT 
         B     CMD_FIND-4
*MEXIT #=   270 LV= 1 PEXIT
FIND_CLC CLC   0(0,R2),VALUE
*
* HELP - LIST SUPERZAP COMMANDS
*
*MCALL #=   271 LV= 1 CMD_HELP PENTRY 
         DC    0H'0',CL8'CMD_HELP'
         B     *+4
CMD_HELP EQU   *
*MEXIT #=   271 LV= 1 PENTRY
  LA   R2,=CL80'SUPERZAP COMMANDS'
*MCALL #=   272 LV= 1   PM   DISPLAY
         MVC   DISPLAY-2(2),*+10
         B     DISPLAY
         DC    S(*+2)
*MEXIT #=   272 LV= 1 PM
  LA   R2,=CL80'  ASCII    (SWITCH TO ASCII TEXT)'
*MCALL #=   273 LV= 1   PM   DISPLAY
         MVC   DISPLAY-2(2),*+10
         B     DISPLAY
         DC    S(*+2)
*MEXIT #=   273 LV= 1 PM
  LA   R2,=CL80'  BASE OFFSET OR *+OFFSET OR *-OFFSET'
*MCALL #=   274 LV= 1   PM   DISPLAY
         MVC   DISPLAY-2(2),*+10
         B     DISPLAY
         DC    S(*+2)
*MEXIT #=   274 LV= 1 PM
  LA   R2,=CL80'  DUMP OFFSET LENGTH (NO OPERANDS DUMPS FILE)'
*MCALL #=   275 LV= 1   PM   DISPLAY
         MVC   DISPLAY-2(2),*+10
         B     DISPLAY
         DC    S(*+2)
*MEXIT #=   275 LV= 1 PM
  LA   R2,=CL80'  EBCDIC   (SWITCH TO EBCDIC TEXT)'
*MCALL #=   276 LV= 1   PM   DISPLAY
         MVC   DISPLAY-2(2),*+10
         B     DISPLAY
         DC    S(*+2)
*MEXIT #=   276 LV= 1 PM
  LA   R2,=CL80'  END      (END CONSOLE INPUT)'
*MCALL #=   277 LV= 1   PM   DISPLAY
         MVC   DISPLAY-2(2),*+10
         B     DISPLAY
         DC    S(*+2)
*MEXIT #=   277 LV= 1 PM
  LA   R2,=CL80'  FIND VALUE (HEX OR ''...'', RESET BASE IF FOUND)'
*MCALL #=   278 LV= 1   PM   DISPLAY
         MVC   DISPLAY-2(2),*+10
         B     DISPLAY
         DC    S(*+2)
*MEXIT #=   278 LV= 1 PM
  LA   R2,=CL80'  LOOP (REPEAT FROM LAST SUCCESSFUL FIND IF NO ERRORS)'
*MCALL #=   279 LV= 1   PM   DISPLAY
         MVC   DISPLAY-2(2),*+10
         B     DISPLAY
         DC    S(*+2)
*MEXIT #=   279 LV= 1 PM
  LA   R2,=CL80'  NAME FILE (USE "..." FOR SPACEY FILES, RESET BASE)'
*MCALL #=   280 LV= 1   PM   DISPLAY
         MVC   DISPLAY-2(2),*+10
         B     DISPLAY
         DC    S(*+2)
*MEXIT #=   280 LV= 1 PM
  LA   R2,=CL80'  REP  OFFSET VALUE (HEX OR ''...'' FOR TEXT)'
*MCALL #=   281 LV= 1   PM   DISPLAY
         MVC   DISPLAY-2(2),*+10
         B     DISPLAY
         DC    S(*+2)
*MEXIT #=   281 LV= 1 PM
  LA   R2,=CL80'  VER  OFFSET VALUE (HEX OR ''...'' FOR TEXT)'
*MCALL #=   282 LV= 1   PM   DISPLAY
         MVC   DISPLAY-2(2),*+10
         B     DISPLAY
         DC    S(*+2)
*MEXIT #=   282 LV= 1 PM
*MCALL #=   283 LV= 1   PEXIT 
         B     CMD_HELP-4
*MEXIT #=   283 LV= 1 PEXIT
*
* LOOP - REPEAT COMMANDS FROM LAST FIND IF NO ERRORS
*
*MCALL #=   284 LV= 1 CMD_LOOP PENTRY 
         DC    0H'0',CL8'CMD_LOOP'
         B     *+4
CMD_LOOP EQU   *
*MEXIT #=   284 LV= 1 PENTRY
*MCALL #=   285 LV= 1          IF    (CLI,FILE_LOADED,EQ,TRUE),AND,(CLIX
               ,VER_ERROR,NE,TRUE),AND,(CLC,NEXT_CMD,GT,=A(CMD_LIST))
*MCALL #=   286 LV= 2          ZSTREQU 
*MEXIT #=   286 LV= 2 ZSTREQU
         CLI   FILE_LOADED,TRUE
         BC    15-EQ,#@IF_30_2
         CLI   VER_ERROR,TRUE
         BC    15-NE,#@IF_30_2
         CLC   NEXT_CMD,=A(CMD_LIST)
         BC    15-GT,#@IF_30_2
*MEXIT #=   285 LV= 1 IF
               MVI LOOP,TRUE
               MVC CUR_CMD,=A(CMD_LIST)
*MCALL #=   287 LV= 1          ELSE 
*MCALL #=   288 LV= 2          ZSTREQU 
*MEXIT #=   288 LV= 2 ZSTREQU
        B      #@IF_30_E
#@IF_30_2                                                DS 0H
*MEXIT #=   287 LV= 1 ELSE
               LA  R2,=CL80'LOOP SKIPPED DUE TO ERROR'
*MCALL #=   289 LV= 1                PM  DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   289 LV= 1 PM
*MCALL #=   290 LV= 1          ENDIF 
*MCALL #=   291 LV= 2          ZSTREQU 
*MEXIT #=   291 LV= 2 ZSTREQU
#@IF_30_E                        DS 0H
*MEXIT #=   290 LV= 1 ENDIF
*MCALL #=   292 LV= 1          PEXIT 
         B     CMD_LOOP-4
*MEXIT #=   292 LV= 1 PEXIT
*
* NAME FILE - LOAD FILE INTO MEMORY AND SET BASE AND MAX LENGTH
*
*MCALL #=   293 LV= 1 CMD_NAME PENTRY 
         DC    0H'0',CL8'CMD_NAME'
         B     *+4
CMD_NAME EQU   *
*MEXIT #=   293 LV= 1 PENTRY
*MCALL #=   294 LV= 1          IF    (CLI,FILE_LOADED,EQ,TRUE)
*MCALL #=   295 LV= 2          ZSTREQU 
*MEXIT #=   295 LV= 2 ZSTREQU
         CLI   FILE_LOADED,TRUE
         BC    15-EQ,#@IF_31_2
*MEXIT #=   294 LV= 1 IF
*MCALL #=   296 LV= 1                IF (CLI,FILE_UPDATE,EQ,TRUE)
*MCALL #=   297 LV= 2          ZSTREQU 
*MEXIT #=   297 LV= 2 ZSTREQU
         CLI   FILE_UPDATE,TRUE
         BC    15-EQ,#@IF_32_2
*MEXIT #=   296 LV= 1 IF
*MCALL #=   298 LV= 1                   PM  CMD_UPDATE_FILE
         MVC   CMD_UPDATE_FILE-2(2),*+10
         B     CMD_UPDATE_FILE
         DC    S(*+2)
*MEXIT #=   298 LV= 1 PM
*MCALL #=   299 LV= 1                ENDIF 
*MCALL #=   300 LV= 2          ZSTREQU 
*MEXIT #=   300 LV= 2 ZSTREQU
#@IF_32_2                                                DS 0H
*MEXIT #=   299 LV= 1 ENDIF
*MCALL #=   301 LV= 1                PM CMD_CLOSE
         MVC   CMD_CLOSE-2(2),*+10
         B     CMD_CLOSE
         DC    S(*+2)
*MEXIT #=   301 LV= 1 PM
*MCALL #=   302 LV= 1          ENDIF 
*MCALL #=   303 LV= 2          ZSTREQU 
*MEXIT #=   303 LV= 2 ZSTREQU
#@IF_31_2                                                DS 0H
*MEXIT #=   302 LV= 1 ENDIF
         MVI   FILE_LOADED,FALSE
         MVI   FILE_UPDATE,FALSE
*MCALL #=   304 LV= 1          PM    FIND_CHAR
         MVC   FIND_CHAR-2(2),*+10
         B     FIND_CHAR
         DC    S(*+2)
*MEXIT #=   304 LV= 1 PM
         LR    R3,R2
*MCALL #=   305 LV= 1          IF    (CLI,0(R2),EQ,C'"')  LONG SPACEY NX
               AME
*MCALL #=   306 LV= 2          ZSTREQU 
*MEXIT #=   306 LV= 2 ZSTREQU
         CLI   0(R2),C'"'
         BC    15-EQ,#@IF_33_2
*MEXIT #=   305 LV= 1 IF
               AHI  R2,1
*MCALL #=   307 LV= 1                DO    WHILE=((CLI,0(R2),NE,C'"'),AX
               ND,(CLI,0(R2),NE,C'*'))
*MCALL #=   308 LV= 2          ZSTREQU 
*MEXIT #=   308 LV= 2 ZSTREQU
#@DO_6_T                         DS 0H
*MCALL #=   309 LV= 2          IF (CLI,0(R2),NE,C'"'),AND,(CLI,0(R2),NEX
               ,C'*')
*MCALL #=   310 LV= 3          ZSTREQU 
*MEXIT #=   310 LV= 3 ZSTREQU
         CLI   0(R2),C'"'
         BC    15-NE,#@IF_34_2
         CLI   0(R2),C'*'
         BC    15-NE,#@IF_34_2
*MEXIT #=   309 LV= 2 IF
               B   #@DO_6_1
*MCALL #=   311 LV= 2          ENDIF 
*MCALL #=   312 LV= 3          ZSTREQU 
*MEXIT #=   312 LV= 3 ZSTREQU
#@IF_34_2                                                DS 0H
*MEXIT #=   311 LV= 2 ENDIF
         B     #@DO_6_E
#@DO_6_1                         DS 0H
*MEXIT #=   307 LV= 1 DO
                     AHI  R2,1
*MCALL #=   313 LV= 1                ENDDO 
*MCALL #=   314 LV= 2          DO    END
*MCALL #=   315 LV= 3          ZSTREQU 
*MEXIT #=   315 LV= 3 ZSTREQU
         B     #@DO_6_T
#@DO_6_E                         DS 0H
*MEXIT #=   314 LV= 2 DO
*MEXIT #=   313 LV= 1 ENDDO
*MCALL #=   316 LV= 1          ELSE 
*MCALL #=   317 LV= 2          ZSTREQU 
*MEXIT #=   317 LV= 2 ZSTREQU
        B      #@IF_33_E
#@IF_33_2                                                DS 0H
*MEXIT #=   316 LV= 1 ELSE
*MCALL #=   318 LV= 1                DO    WHILE=((CLI,0(R2),NE,C' '),AX
               ND,(CLI,0(R2),NE,C'*'))   RPI 909 MISSING (
*MCALL #=   319 LV= 2          ZSTREQU 
*MEXIT #=   319 LV= 2 ZSTREQU
#@DO_7_T                         DS 0H
*MCALL #=   320 LV= 2          IF (CLI,0(R2),NE,C' '),AND,(CLI,0(R2),NEX
               ,C'*')
*MCALL #=   321 LV= 3          ZSTREQU 
*MEXIT #=   321 LV= 3 ZSTREQU
         CLI   0(R2),C' '
         BC    15-NE,#@IF_35_2
         CLI   0(R2),C'*'
         BC    15-NE,#@IF_35_2
*MEXIT #=   320 LV= 2 IF
               B   #@DO_7_1
*MCALL #=   322 LV= 2          ENDIF 
*MCALL #=   323 LV= 3          ZSTREQU 
*MEXIT #=   323 LV= 3 ZSTREQU
#@IF_35_2                                                DS 0H
*MEXIT #=   322 LV= 2 ENDIF
         B     #@DO_7_E
#@DO_7_1                         DS 0H
*MEXIT #=   318 LV= 1 DO
                     AHI  R2,1
*MCALL #=   324 LV= 1                ENDDO 
*MCALL #=   325 LV= 2          DO    END
*MCALL #=   326 LV= 3          ZSTREQU 
*MEXIT #=   326 LV= 3 ZSTREQU
         B     #@DO_7_T
#@DO_7_E                         DS 0H
*MEXIT #=   325 LV= 2 DO
*MEXIT #=   324 LV= 1 ENDDO
*MCALL #=   327 LV= 1          ENDIF 
*MCALL #=   328 LV= 2          ZSTREQU 
*MEXIT #=   328 LV= 2 ZSTREQU
#@IF_33_E                        DS 0H
*MEXIT #=   327 LV= 1 ENDIF
         SR    R2,R3
         AHI   R2,-1
         EX    R2,NAME_MVC
*MCALL #=   329 LV= 1          PM    OPEN_SYSUT1
         MVC   OPEN_SYSUT1-2(2),*+10
         B     OPEN_SYSUT1
         DC    S(*+2)
*MEXIT #=   329 LV= 1 PM
*MCALL #=   330 LV= 1          IF    (C,R15,EQ,=F'0')
*MCALL #=   331 LV= 2          ZSTREQU 
*MEXIT #=   331 LV= 2 ZSTREQU
         C     R15,=F'0'
         BC    15-EQ,#@IF_36_2
*MEXIT #=   330 LV= 1 IF
*MCALL #=   332 LV= 1                IF  (CG,R0,GT,=AD(X'7FFFFFFF'))
*MCALL #=   333 LV= 2          ZSTREQU 
*MEXIT #=   333 LV= 2 ZSTREQU
         CG    R0,=AD(X'7FFFFFFF')
         BC    15-GT,#@IF_37_2
*MEXIT #=   332 LV= 1 IF
                   SR  R9,R9
                   SR  R10,R10
                   LA  R2,=CL80'FILE TOO BIG (OVER 2G)'
*MCALL #=   334 LV= 1                    PM  DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   334 LV= 1 PM
*MCALL #=   335 LV= 1                    PEXIT 
         B     CMD_NAME-4
*MEXIT #=   335 LV= 1 PEXIT
*MCALL #=   336 LV= 1                ENDIF 
*MCALL #=   337 LV= 2          ZSTREQU 
*MEXIT #=   337 LV= 2 ZSTREQU
#@IF_37_2                                                DS 0H
*MEXIT #=   336 LV= 1 ENDIF
               ST  R0,FILE_SIZE
               L   R1,FILE_SIZE
*MCALL #=   338 LV= 1                GETMAIN RC,LV=(1)
*MCALL #=   339 LV= 2          ZOPTLR 1,1
*MEXIT #=   339 LV= 2 ZOPTLR
         LA    0,B'11'
         SVC   4 GMAIN R0=(X'02'=31B,X'01'=COND),R1=LEN OUT(R0=L,R1=A)
*MEXIT #=   338 LV= 1 GETMAIN
*MCALL #=   340 LV= 1                IF  (C,R15,NE,=F'0')
*MCALL #=   341 LV= 2          ZSTREQU 
*MEXIT #=   341 LV= 2 ZSTREQU
         C     R15,=F'0'
         BC    15-NE,#@IF_38_2
*MEXIT #=   340 LV= 1 IF
                   SR  R9,R9
                   SR  R10,R10
                   LA  R2,=CL80'FILE TOO BIG FOR AVAILABLE MEMORY'
*MCALL #=   342 LV= 1                    PM  DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   342 LV= 1 PM
*MCALL #=   343 LV= 1                    PEXIT 
         B     CMD_NAME-4
*MEXIT #=   343 LV= 1 PEXIT
*MCALL #=   344 LV= 1                ENDIF 
*MCALL #=   345 LV= 2          ZSTREQU 
*MEXIT #=   345 LV= 2 ZSTREQU
#@IF_38_2                                                DS 0H
*MEXIT #=   344 LV= 1 ENDIF
               LR  R9,R1
               LR  R10,R1
               A   10,FILE_SIZE
               MVC SYSUT1+(DCBLRECLF-IHADCB)(4),FILE_SIZE
*MCALL #=   346 LV= 1                GET SYSUT1,(R9)
         LA    1,SYSUT1
*MCALL #=   347 LV= 2          ZOPTLR 0,R9
         LR    0,R9
*MEXIT #=   347 LV= 2 ZOPTLR
         SVC  151
*MEXIT #=   346 LV= 1 GET
*MCALL #=   348 LV= 1                CLOSE (SYSUT1)
*MCALL #=   349 LV= 2          ZCLOSE (SYSUT1),MODE=,MF=I,TYPE=
                       LA     1,SYSUT1
                   SVC   20 CLOSE R1=DCB/ACB
*MEXIT #=   349 LV= 2 ZCLOSE
*MEXIT #=   348 LV= 1 CLOSE
               MVI FILE_LOADED,TRUE
*MCALL #=   350 LV= 1          ELSE 
*MCALL #=   351 LV= 2          ZSTREQU 
*MEXIT #=   351 LV= 2 ZSTREQU
        B      #@IF_36_E
#@IF_36_2                                                DS 0H
*MEXIT #=   350 LV= 1 ELSE
               SR  R9,R9
               SR  R10,R10
               LA  R2,=CL80'FILE NOT FOUND'
*MCALL #=   352 LV= 1                PM  DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   352 LV= 1 PM
*MCALL #=   353 LV= 1          ENDIF 
*MCALL #=   354 LV= 2          ZSTREQU 
*MEXIT #=   354 LV= 2 ZSTREQU
#@IF_36_E                        DS 0H
*MEXIT #=   353 LV= 1 ENDIF
*MCALL #=   355 LV= 1          PEXIT 
         B     CMD_NAME-4
*MEXIT #=   355 LV= 1 PEXIT
NAME_MVC MVC   FILE_NAME(0),0(R3) MOVE FILE NAME
*
* OPEN SYSUT1 FOR INPUT ELSE RETURN RC=12
*
*MCALL #=   356 LV= 1 OPEN_SYSUT1 PENTRY 
         DC    0H'0',CL8'OPEN_SYSUT1'
         B     *+4
OPEN_SYSUT1 EQU *
*MEXIT #=   356 LV= 1 PENTRY
*MCALL #=   357 LV= 1          OPEN  (SYSUT1,(INPUT))
*MCALL #=   358 LV= 2          ZOPEN (SYSUT1,(INPUT)),MF=I,MODE=31,TYPEX
               =
                       LA     1,SYSUT1
                       LA  0,DCBOFLGS_GM   READ ONLY
                   SVC   19 OPEN R0=TYPE,R1=DCB/ACB
*MCALL #=   359 LV= 3          DCBD 
*MEXIT #=   359 LV= 3 DCBD
*MEXIT #=   358 LV= 2 ZOPEN
*MEXIT #=   357 LV= 1 OPEN
*MCALL #=   360 LV= 1          PEXIT 
         B     OPEN_SYSUT1-4
*MEXIT #=   360 LV= 1 PEXIT
SYSUT1_ERR DS 0H
         LHI   R15,12
*MCALL #=   361 LV= 1          PEXIT 
         B     OPEN_SYSUT1-4
*MEXIT #=   361 LV= 1 PEXIT
*
* UPDATE FILE
*
*MCALL #=   362 LV= 1 CMD_UPDATE_FILE PENTRY 
         DC    0H'0',CL8'CMD_UPDATE_FILE'
         B     *+4
CMD_UPDATE_FILE EQU *
*MEXIT #=   362 LV= 1 PENTRY
*MCALL #=   363 LV= 1          PM    OPEN_SYSUT2
         MVC   OPEN_SYSUT2-2(2),*+10
         B     OPEN_SYSUT2
         DC    S(*+2)
*MEXIT #=   363 LV= 1 PM
*MCALL #=   364 LV= 1          IF    (C,R15,NE,=F'0')
*MCALL #=   365 LV= 2          ZSTREQU 
*MEXIT #=   365 LV= 2 ZSTREQU
         C     R15,=F'0'
         BC    15-NE,#@IF_39_2
*MEXIT #=   364 LV= 1 IF
               LA  R2,=CL80'FILE UPDATE OPEN FOR UPDATE FAILED'
*MCALL #=   366 LV= 1                PM  DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   366 LV= 1 PM
*MCALL #=   367 LV= 1                PEXIT 
         B     CMD_UPDATE_FILE-4
*MEXIT #=   367 LV= 1 PEXIT
*MCALL #=   368 LV= 1          ENDIF 
*MCALL #=   369 LV= 2          ZSTREQU 
*MEXIT #=   369 LV= 2 ZSTREQU
#@IF_39_2                                                DS 0H
*MEXIT #=   368 LV= 1 ENDIF
         MVC SYSUT2+(DCBLRECLF-IHADCB)(4),FILE_SIZE
*MCALL #=   370 LV= 1          PUT SYSUT2,(R9)
         LA    1,SYSUT2
*MCALL #=   371 LV= 2          ZOPTLR 0,R9
         LR    0,R9
*MEXIT #=   371 LV= 2 ZOPTLR
         SVC  152 QSAM PUT R0=REC, R1=DCB
*MEXIT #=   370 LV= 1 PUT
*MCALL #=   372 LV= 1          CLOSE (SYSUT2)
*MCALL #=   373 LV= 2          ZCLOSE (SYSUT2),MODE=,MF=I,TYPE=
                       LA     1,SYSUT2
                   SVC   20 CLOSE R1=DCB/ACB
*MEXIT #=   373 LV= 2 ZCLOSE
*MEXIT #=   372 LV= 1 CLOSE
         MVI FILE_LOADED,FALSE
*MCALL #=   374 LV= 1          PEXIT 
         B     CMD_UPDATE_FILE-4
*MEXIT #=   374 LV= 1 PEXIT
*
* OPEN SYSUT2 FOR INPUT ELSE RETURN RC=12
*
*MCALL #=   375 LV= 1 OPEN_SYSUT2 PENTRY 
         DC    0H'0',CL8'OPEN_SYSUT2'
         B     *+4
OPEN_SYSUT2 EQU *
*MEXIT #=   375 LV= 1 PENTRY
*MCALL #=   376 LV= 1          OPEN  (SYSUT2,(UPDATE))
*MCALL #=   377 LV= 2          ZOPEN (SYSUT2,(UPDATE)),MF=I,MODE=31,TYPX
               E=
                       LA     1,SYSUT2
                       LA  0,DCBOFLGS_RW   READ AND WRITE
                   SVC   19 OPEN R0=TYPE,R1=DCB/ACB
*MCALL #=   378 LV= 3          DCBD 
*MEXIT #=   378 LV= 3 DCBD
*MEXIT #=   377 LV= 2 ZOPEN
*MEXIT #=   376 LV= 1 OPEN
*MCALL #=   379 LV= 1          PEXIT 
         B     OPEN_SYSUT2-4
*MEXIT #=   379 LV= 1 PEXIT
SYSUT2_ERR DS 0H
         LHI   R15,12
*MCALL #=   380 LV= 1          PEXIT 
         B     OPEN_SYSUT2-4
*MEXIT #=   380 LV= 1 PEXIT
*
* REP OFFSET VALUE
*
*MCALL #=   381 LV= 1 CMD_REPLACE PENTRY 
         DC    0H'0',CL8'CMD_REPLACE'
         B     *+4
CMD_REPLACE EQU *
*MEXIT #=   381 LV= 1 PENTRY
*MCALL #=   382 LV= 1          IF    (CLI,FILE_LOADED,NE,TRUE)
*MCALL #=   383 LV= 2          ZSTREQU 
*MEXIT #=   383 LV= 2 ZSTREQU
         CLI   FILE_LOADED,TRUE
         BC    15-NE,#@IF_40_2
*MEXIT #=   382 LV= 1 IF
               LA  R2,=CL80'REPLACE SKIPPED DUE TO FILE ERROR'
*MCALL #=   384 LV= 1                PM  DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   384 LV= 1 PM
*MCALL #=   385 LV= 1                PEXIT 
         B     CMD_REPLACE-4
*MEXIT #=   385 LV= 1 PEXIT
*MCALL #=   386 LV= 1          ENDIF 
*MCALL #=   387 LV= 2          ZSTREQU 
*MEXIT #=   387 LV= 2 ZSTREQU
#@IF_40_2                                                DS 0H
*MEXIT #=   386 LV= 1 ENDIF
*MCALL #=   388 LV= 1          PM    GET_OFFSET
         MVC   GET_OFFSET-2(2),*+10
         B     GET_OFFSET
         DC    S(*+2)
*MEXIT #=   388 LV= 1 PM
*MCALL #=   389 LV= 1          PM    GET_VALUE
         MVC   GET_VALUE-2(2),*+10
         B     GET_VALUE
         DC    S(*+2)
*MEXIT #=   389 LV= 1 PM
*MCALL #=   390 LV= 1          IF    (CLI,PARM_ERROR,EQ,TRUE)
*MCALL #=   391 LV= 2          ZSTREQU 
*MEXIT #=   391 LV= 2 ZSTREQU
         CLI   PARM_ERROR,TRUE
         BC    15-EQ,#@IF_41_2
*MEXIT #=   390 LV= 1 IF
               LA  R2,=CL80'REPLACE SKIPPED DUE TO PARM ERROR'
*MCALL #=   392 LV= 1                PM  DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   392 LV= 1 PM
*MCALL #=   393 LV= 1                PEXIT 
         B     CMD_REPLACE-4
*MEXIT #=   393 LV= 1 PEXIT
*MCALL #=   394 LV= 1          ENDIF 
*MCALL #=   395 LV= 2          ZSTREQU 
*MEXIT #=   395 LV= 2 ZSTREQU
#@IF_41_2                                                DS 0H
*MEXIT #=   394 LV= 1 ENDIF
*MCALL #=   396 LV= 1          IF    (CLI,VER_ERROR,EQ,TRUE)
*MCALL #=   397 LV= 2          ZSTREQU 
*MEXIT #=   397 LV= 2 ZSTREQU
         CLI   VER_ERROR,TRUE
         BC    15-EQ,#@IF_42_2
*MEXIT #=   396 LV= 1 IF
               LA  R2,=CL80'REPLACE SKIPPED DUE TO VERIFY ERROR'
*MCALL #=   398 LV= 1                PM  DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   398 LV= 1 PM
*MCALL #=   399 LV= 1                PEXIT 
         B     CMD_REPLACE-4
*MEXIT #=   399 LV= 1 PEXIT
*MCALL #=   400 LV= 1          ENDIF 
*MCALL #=   401 LV= 2          ZSTREQU 
*MEXIT #=   401 LV= 2 ZSTREQU
#@IF_42_2                                                DS 0H
*MEXIT #=   400 LV= 1 ENDIF
         L     R2,OFFSET
         LA    R3,0(R2,R9)  R1 = START + OFFSET
         L     R4,LVALUE
         AHI   R4,-1
         EX    R4,REP_MVC
         MVI   FILE_UPDATE,TRUE
*MCALL #=   402 LV= 1          PEXIT 
         B     CMD_REPLACE-4
*MEXIT #=   402 LV= 1 PEXIT
REP_MVC  MVC   0(0,R3),VALUE
*
*  VER OFFSET VALUE
*
*MCALL #=   403 LV= 1 CMD_VERIFY PENTRY 
         DC    0H'0',CL8'CMD_VERIFY'
         B     *+4
CMD_VERIFY EQU *
*MEXIT #=   403 LV= 1 PENTRY
*MCALL #=   404 LV= 1          IF    (CLI,FILE_LOADED,NE,TRUE)
*MCALL #=   405 LV= 2          ZSTREQU 
*MEXIT #=   405 LV= 2 ZSTREQU
         CLI   FILE_LOADED,TRUE
         BC    15-NE,#@IF_43_2
*MEXIT #=   404 LV= 1 IF
               MVI VER_ERROR,TRUE
               LA  R2,=CL80'VERIFY SKIPPED DUE TO FILE ERROR'
*MCALL #=   406 LV= 1                PM  DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   406 LV= 1 PM
*MCALL #=   407 LV= 1                PEXIT 
         B     CMD_VERIFY-4
*MEXIT #=   407 LV= 1 PEXIT
*MCALL #=   408 LV= 1          ENDIF 
*MCALL #=   409 LV= 2          ZSTREQU 
*MEXIT #=   409 LV= 2 ZSTREQU
#@IF_43_2                                                DS 0H
*MEXIT #=   408 LV= 1 ENDIF
*MCALL #=   410 LV= 1          PM    GET_OFFSET
         MVC   GET_OFFSET-2(2),*+10
         B     GET_OFFSET
         DC    S(*+2)
*MEXIT #=   410 LV= 1 PM
*MCALL #=   411 LV= 1          PM    GET_VALUE
         MVC   GET_VALUE-2(2),*+10
         B     GET_VALUE
         DC    S(*+2)
*MEXIT #=   411 LV= 1 PM
*MCALL #=   412 LV= 1          IF    (CLI,PARM_ERROR,EQ,TRUE)
*MCALL #=   413 LV= 2          ZSTREQU 
*MEXIT #=   413 LV= 2 ZSTREQU
         CLI   PARM_ERROR,TRUE
         BC    15-EQ,#@IF_44_2
*MEXIT #=   412 LV= 1 IF
               LA  R2,=CL80'VERIFY SKIPPED DUE INVALID PARMS'
*MCALL #=   414 LV= 1                PM  DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   414 LV= 1 PM
*MCALL #=   415 LV= 1                PEXIT 
         B     CMD_VERIFY-4
*MEXIT #=   415 LV= 1 PEXIT
*MCALL #=   416 LV= 1          ENDIF 
*MCALL #=   417 LV= 2          ZSTREQU 
*MEXIT #=   417 LV= 2 ZSTREQU
#@IF_44_2                                                DS 0H
*MEXIT #=   416 LV= 1 ENDIF
         L     R2,OFFSET
         LA    R3,0(R2,R9)  R1 = START + OFFSET
         L     R4,LVALUE
         AHI   R4,-1
*MCALL #=   418 LV= 1          IF    (EX,R4,NE,VER_CLC)
*MCALL #=   419 LV= 2          ZSTREQU 
*MEXIT #=   419 LV= 2 ZSTREQU
         EX    R4,VER_CLC
         BC    15-NE,#@IF_45_2
*MEXIT #=   418 LV= 1 IF
               MVC  VER_ERROR,TRUE
               LA   R2,=CL80'VERIFY FAILED'
*MCALL #=   420 LV= 1                PM   DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   420 LV= 1 PM
               AHI  R4,1
*MCALL #=   421 LV= 1                PM   DUMP_REQ
         MVC   DUMP_REQ-2(2),*+10
         B     DUMP_REQ
         DC    S(*+2)
*MEXIT #=   421 LV= 1 PM
*MCALL #=   422 LV= 1          ENDIF 
*MCALL #=   423 LV= 2          ZSTREQU 
*MEXIT #=   423 LV= 2 ZSTREQU
#@IF_45_2                                                DS 0H
*MEXIT #=   422 LV= 1 ENDIF
*MCALL #=   424 LV= 1          PEXIT 
         B     CMD_VERIFY-4
*MEXIT #=   424 LV= 1 PEXIT
VER_CLC  CLC   0(0,R3),VALUE
*
*  GET HEX VALUE IN R0
*
*MCALL #=   425 LV= 1 GET_HEX  PENTRY 
         DC    0H'0',CL8'GET_HEX'
         B     *+4
GET_HEX  EQU   *
*MEXIT #=   425 LV= 1 PENTRY
         SR    R3,R3
*MCALL #=   426 LV= 1          PM    FIND_CHAR
         MVC   FIND_CHAR-2(2),*+10
         B     FIND_CHAR
         DC    S(*+2)
*MEXIT #=   426 LV= 1 PM
*MCALL #=   427 LV= 1          DO    WHILE=((CLI,PARM_ERROR,NE,TRUE),ANX
               D,(CLI,0(R2),NE,C' '))
*MCALL #=   428 LV= 2          ZSTREQU 
*MEXIT #=   428 LV= 2 ZSTREQU
#@DO_8_T                         DS 0H
*MCALL #=   429 LV= 2          IF (CLI,PARM_ERROR,NE,TRUE),AND,(CLI,0(RX
               2),NE,C' ')
*MCALL #=   430 LV= 3          ZSTREQU 
*MEXIT #=   430 LV= 3 ZSTREQU
         CLI   PARM_ERROR,TRUE
         BC    15-NE,#@IF_46_2
         CLI   0(R2),C' '
         BC    15-NE,#@IF_46_2
*MEXIT #=   429 LV= 2 IF
               B   #@DO_8_1
*MCALL #=   431 LV= 2          ENDIF 
*MCALL #=   432 LV= 3          ZSTREQU 
*MEXIT #=   432 LV= 3 ZSTREQU
#@IF_46_2                                                DS 0H
*MEXIT #=   431 LV= 2 ENDIF
         B     #@DO_8_E
#@DO_8_1                         DS 0H
*MEXIT #=   427 LV= 1 DO
               MVC HEX_DIGIT,0(R2)
               OI  HEX_DIGIT,C' ' FORCE UPPER CASE
               TR  HEX_DIGIT,HEX_DIGIT_TABLE
*MCALL #=   433 LV= 1                IF  (CLI,HEX_DIGIT,EQ,X'FF')
*MCALL #=   434 LV= 2          ZSTREQU 
*MEXIT #=   434 LV= 2 ZSTREQU
         CLI   HEX_DIGIT,X'FF'
         BC    15-EQ,#@IF_47_2
*MEXIT #=   433 LV= 1 IF
                   LA R2,=CL80'INVALID HEX DIGIT'
*MCALL #=   435 LV= 1                    PM DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   435 LV= 1 PM
                   MVI PARM_ERROR,TRUE
*MCALL #=   436 LV= 1                    PEXIT 
         B     GET_HEX-4
*MEXIT #=   436 LV= 1 PEXIT
*MCALL #=   437 LV= 1                ENDIF 
*MCALL #=   438 LV= 2          ZSTREQU 
*MEXIT #=   438 LV= 2 ZSTREQU
#@IF_47_2                                                DS 0H
*MEXIT #=   437 LV= 1 ENDIF
               SLL R3,4
               AH  R3,HEX_HWORD
               AHI R2,1
*MCALL #=   439 LV= 1          ENDDO 
*MCALL #=   440 LV= 2          DO    END
*MCALL #=   441 LV= 3          ZSTREQU 
*MEXIT #=   441 LV= 3 ZSTREQU
         B     #@DO_8_T
#@DO_8_E                         DS 0H
*MEXIT #=   440 LV= 2 DO
*MEXIT #=   439 LV= 1 ENDDO
         LR    R0,R3
*MCALL #=   442 LV= 1          PEXIT 
         B     GET_HEX-4
*MEXIT #=   442 LV= 1 PEXIT
*
* GET VALUE UP TO 256 CHAR HEX OR 'TEXT'
*
*MCALL #=   443 LV= 1 GET_VALUE PENTRY 
         DC    0H'0',CL8'GET_VALUE'
         B     *+4
GET_VALUE EQU  *
*MEXIT #=   443 LV= 1 PENTRY
*MCALL #=   444 LV= 1          PM    FIND_CHAR
         MVC   FIND_CHAR-2(2),*+10
         B     FIND_CHAR
         DC    S(*+2)
*MEXIT #=   444 LV= 1 PM
*MCALL #=   445 LV= 1          IF    (CLI,0(R2),EQ,C'''')
*MCALL #=   446 LV= 2          ZSTREQU 
*MEXIT #=   446 LV= 2 ZSTREQU
         CLI   0(R2),C''''
         BC    15-EQ,#@IF_48_2
*MEXIT #=   445 LV= 1 IF
*MCALL #=   447 LV= 1                PM  GET_TEXT_VALUE
         MVC   GET_TEXT_VALUE-2(2),*+10
         B     GET_TEXT_VALUE
         DC    S(*+2)
*MEXIT #=   447 LV= 1 PM
*MCALL #=   448 LV= 1          ELSE 
*MCALL #=   449 LV= 2          ZSTREQU 
*MEXIT #=   449 LV= 2 ZSTREQU
        B      #@IF_48_E
#@IF_48_2                                                DS 0H
*MEXIT #=   448 LV= 1 ELSE
*MCALL #=   450 LV= 1                PM  GET_HEX_VALUE
         MVC   GET_HEX_VALUE-2(2),*+10
         B     GET_HEX_VALUE
         DC    S(*+2)
*MEXIT #=   450 LV= 1 PM
*MCALL #=   451 LV= 1          ENDIF 
*MCALL #=   452 LV= 2          ZSTREQU 
*MEXIT #=   452 LV= 2 ZSTREQU
#@IF_48_E                        DS 0H
*MEXIT #=   451 LV= 1 ENDIF
*MCALL #=   453 LV= 1          PEXIT 
         B     GET_VALUE-4
*MEXIT #=   453 LV= 1 PEXIT
*
* GET TEXT VALUE - STORE TEXT IN VALUE FIELD
*
*MCALL #=   454 LV= 1 GET_TEXT_VALUE PENTRY 
         DC    0H'0',CL8'GET_TEXT_VALUE'
         B     *+4
GET_TEXT_VALUE EQU *
*MEXIT #=   454 LV= 1 PENTRY
         AHI   R2,1
         LA    R3,VALUE
         MVI   TEXT_CHAR,TRUE
*MCALL #=   455 LV= 1          DO    WHILE=(CLI,TEXT_CHAR,EQ,TRUE)
*MCALL #=   456 LV= 2          ZSTREQU 
*MEXIT #=   456 LV= 2 ZSTREQU
#@DO_9_T                         DS 0H
*MCALL #=   457 LV= 2          IF CLI,TEXT_CHAR,EQ,TRUE
*MCALL #=   458 LV= 3          ZSTREQU 
*MEXIT #=   458 LV= 3 ZSTREQU
         CLI   TEXT_CHAR,TRUE
         BC    15-EQ,#@IF_49_2
*MEXIT #=   457 LV= 2 IF
               B   #@DO_9_1
*MCALL #=   459 LV= 2          ENDIF 
*MCALL #=   460 LV= 3          ZSTREQU 
*MEXIT #=   460 LV= 3 ZSTREQU
#@IF_49_2                                                DS 0H
*MEXIT #=   459 LV= 2 ENDIF
         B     #@DO_9_E
#@DO_9_1                         DS 0H
*MEXIT #=   455 LV= 1 DO
*MCALL #=   461 LV= 1                IF  (CLI,0(R2),EQ,C'''')
*MCALL #=   462 LV= 2          ZSTREQU 
*MEXIT #=   462 LV= 2 ZSTREQU
         CLI   0(R2),C''''
         BC    15-EQ,#@IF_50_2
*MEXIT #=   461 LV= 1 IF
*MCALL #=   463 LV= 1                    IF (CLI,1(R2),EQ,C'''')
*MCALL #=   464 LV= 2          ZSTREQU 
*MEXIT #=   464 LV= 2 ZSTREQU
         CLI   1(R2),C''''
         BC    15-EQ,#@IF_51_2
*MEXIT #=   463 LV= 1 IF
                      MVI  0(R3),C''''
                      AHI  R3,1
                      AHI  R2,2
*MCALL #=   465 LV= 1                    ELSE 
*MCALL #=   466 LV= 2          ZSTREQU 
*MEXIT #=   466 LV= 2 ZSTREQU
        B      #@IF_51_E
#@IF_51_2                                                DS 0H
*MEXIT #=   465 LV= 1 ELSE
                      MVI  TEXT_CHAR,FALSE
*MCALL #=   467 LV= 1                    ENDIF 
*MCALL #=   468 LV= 2          ZSTREQU 
*MEXIT #=   468 LV= 2 ZSTREQU
#@IF_51_E                        DS 0H
*MEXIT #=   467 LV= 1 ENDIF
*MCALL #=   469 LV= 1                ELSEIF (C,R2,GE,=A(CMD+80))
*MCALL #=   470 LV= 2          ZSTREQU 
*MEXIT #=   470 LV= 2 ZSTREQU
         B     #@IF_50_E
#@IF_50_2                                                DS 0H
         C     R2,=A(CMD+80)
         BC    15-GE,#@IF_50_4
*MEXIT #=   469 LV= 1 ELSEIF
                   LA  R2,=CL80'VALUE TOO LONG'
*MCALL #=   471 LV= 1                    PM  DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   471 LV= 1 PM
                   MVI PARM_ERROR,TRUE
                   MVI TEXT_CHAR,FALSE
*MCALL #=   472 LV= 1                ELSE 
*MCALL #=   473 LV= 2          ZSTREQU 
*MEXIT #=   473 LV= 2 ZSTREQU
        B      #@IF_50_E
#@IF_50_4                                                DS 0H
*MEXIT #=   472 LV= 1 ELSE
                  MVC  0(1,R3),0(R2)
                  AHI  R3,1
                  AHI  R2,1
*MCALL #=   474 LV= 1                ENDIF 
*MCALL #=   475 LV= 2          ZSTREQU 
*MEXIT #=   475 LV= 2 ZSTREQU
#@IF_50_E                        DS 0H
*MEXIT #=   474 LV= 1 ENDIF
*MCALL #=   476 LV= 1          ENDDO 
*MCALL #=   477 LV= 2          DO    END
*MCALL #=   478 LV= 3          ZSTREQU 
*MEXIT #=   478 LV= 3 ZSTREQU
         B     #@DO_9_T
#@DO_9_E                         DS 0H
*MEXIT #=   477 LV= 2 DO
*MEXIT #=   476 LV= 1 ENDDO
         S     R3,=A(VALUE)
         ST    R3,LVALUE
*MCALL #=   479 LV= 1          IF    (CLI,EBCDIC_TEXT,NE,TRUE)
*MCALL #=   480 LV= 2          ZSTREQU 
*MEXIT #=   480 LV= 2 ZSTREQU
         CLI   EBCDIC_TEXT,TRUE
         BC    15-NE,#@IF_52_2
*MEXIT #=   479 LV= 1 IF
               AHI R3,-1
               EX  R3,VALUE_TR
*MCALL #=   481 LV= 1          ENDIF 
*MCALL #=   482 LV= 2          ZSTREQU 
*MEXIT #=   482 LV= 2 ZSTREQU
#@IF_52_2                                                DS 0H
*MEXIT #=   481 LV= 1 ENDIF
*MCALL #=   483 LV= 1          PEXIT 
         B     GET_TEXT_VALUE-4
*MEXIT #=   483 LV= 1 PEXIT
VALUE_TR TR    VALUE(0),EBCDIC_TO_ASCII
*
* GET HEX VALUE - STORE UP TO 256 HEX BYTES IN VALUE AND SET LVALUE
*
*MCALL #=   484 LV= 1 GET_HEX_VALUE PENTRY 
         DC    0H'0',CL8'GET_HEX_VALUE'
         B     *+4
GET_HEX_VALUE EQU *
*MEXIT #=   484 LV= 1 PENTRY
*MCALL #=   485 LV= 1          PM    FIND_CHAR
         MVC   FIND_CHAR-2(2),*+10
         B     FIND_CHAR
         DC    S(*+2)
*MEXIT #=   485 LV= 1 PM
         LA    R3,VALUE
*MCALL #=   486 LV= 1          DO    WHILE=(CLI,0(R2),NE,C' ')
*MCALL #=   487 LV= 2          ZSTREQU 
*MEXIT #=   487 LV= 2 ZSTREQU
#@DO_10_T                        DS 0H
*MCALL #=   488 LV= 2          IF CLI,0(R2),NE,C' '
*MCALL #=   489 LV= 3          ZSTREQU 
*MEXIT #=   489 LV= 3 ZSTREQU
         CLI   0(R2),C' '
         BC    15-NE,#@IF_53_2
*MEXIT #=   488 LV= 2 IF
               B   #@DO_10_1
*MCALL #=   490 LV= 2          ENDIF 
*MCALL #=   491 LV= 3          ZSTREQU 
*MEXIT #=   491 LV= 3 ZSTREQU
#@IF_53_2                                                DS 0H
*MEXIT #=   490 LV= 2 ENDIF
         B     #@DO_10_E
#@DO_10_1                        DS 0H
*MEXIT #=   486 LV= 1 DO
*MCALL #=   492 LV= 1                IF  (C,R2,GE,=A(CMD+79)))
*MCALL #=   493 LV= 2          ZSTREQU 
*MEXIT #=   493 LV= 2 ZSTREQU
         C     R2,=A(CMD+79)
         BC    15-GE,#@IF_54_2
*MEXIT #=   492 LV= 1 IF
                   LA  R2,=CL80'HEX VALUE TOO LONG'
*MCALL #=   494 LV= 1                    PM  DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   494 LV= 1 PM
                   MVI PARM_ERROR,TRUE
*MCALL #=   495 LV= 1                    PEXIT 
         B     GET_HEX_VALUE-4
*MEXIT #=   495 LV= 1 PEXIT
*MCALL #=   496 LV= 1                ENDIF 
*MCALL #=   497 LV= 2          ZSTREQU 
*MEXIT #=   497 LV= 2 ZSTREQU
#@IF_54_2                                                DS 0H
*MEXIT #=   496 LV= 1 ENDIF
               MVC HEX_DIGIT,0(R2)
               TR  HEX_DIGIT,HEX_DIGIT_TABLE
*MCALL #=   498 LV= 1                IF  (CLI,HEX_DIGIT,EQ,X'FF')
*MCALL #=   499 LV= 2          ZSTREQU 
*MEXIT #=   499 LV= 2 ZSTREQU
         CLI   HEX_DIGIT,X'FF'
         BC    15-EQ,#@IF_55_2
*MEXIT #=   498 LV= 1 IF
                   LA R2,=CL80'INVALID HEX DIGIT'
*MCALL #=   500 LV= 1                    PM DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   500 LV= 1 PM
                   MVI PARM_ERROR,TRUE
*MCALL #=   501 LV= 1                    PEXIT 
         B     GET_HEX_VALUE-4
*MEXIT #=   501 LV= 1 PEXIT
*MCALL #=   502 LV= 1                ENDIF 
*MCALL #=   503 LV= 2          ZSTREQU 
*MEXIT #=   503 LV= 2 ZSTREQU
#@IF_55_2                                                DS 0H
*MEXIT #=   502 LV= 1 ENDIF
               IC  R0,HEX_DIGIT
               SLL R0,4
               AHI R2,1
               MVC HEX_DIGIT,0(R2)
               TR  HEX_DIGIT,HEX_DIGIT_TABLE
*MCALL #=   504 LV= 1                IF  (CLI,HEX_DIGIT,EQ,X'FF')
*MCALL #=   505 LV= 2          ZSTREQU 
*MEXIT #=   505 LV= 2 ZSTREQU
         CLI   HEX_DIGIT,X'FF'
         BC    15-EQ,#@IF_56_2
*MEXIT #=   504 LV= 1 IF
                   LA R2,=CL80'INVALID HEX DIGIT'
*MCALL #=   506 LV= 1                    PM DISPLAY_ERROR
         MVC   DISPLAY_ERROR-2(2),*+10
         B     DISPLAY_ERROR
         DC    S(*+2)
*MEXIT #=   506 LV= 1 PM
                   MVI PARM_ERROR,TRUE
*MCALL #=   507 LV= 1                    PEXIT 
         B     GET_HEX_VALUE-4
*MEXIT #=   507 LV= 1 PEXIT
*MCALL #=   508 LV= 1                ENDIF 
*MCALL #=   509 LV= 2          ZSTREQU 
*MEXIT #=   509 LV= 2 ZSTREQU
#@IF_56_2                                                DS 0H
*MEXIT #=   508 LV= 1 ENDIF
               STC R0,HEX_HWORD
               OC  HEX_DIGIT,HEX_HWORD
               MVC 0(1,R3),HEX_DIGIT
               AHI R3,1
               AHI R2,1
*MCALL #=   510 LV= 1          ENDDO 
*MCALL #=   511 LV= 2          DO    END
*MCALL #=   512 LV= 3          ZSTREQU 
*MEXIT #=   512 LV= 3 ZSTREQU
         B     #@DO_10_T
#@DO_10_E                        DS 0H
*MEXIT #=   511 LV= 2 DO
*MEXIT #=   510 LV= 1 ENDDO
         S     R3,=A(VALUE)
         ST    R3,LVALUE
*MCALL #=   513 LV= 1          PEXIT 
         B     GET_HEX_VALUE-4
*MEXIT #=   513 LV= 1 PEXIT
*
* DUMP MEMORY AT R3 FOR R4 VIA DISPLAY
*
*MCALL #=   514 LV= 1 DUMP_REQ PENTRY 
         DC    0H'0',CL8'DUMP_REQ'
         B     *+4
DUMP_REQ EQU   *
*MEXIT #=   514 LV= 1 PENTRY
         MVI   DUMP_FIRST,TRUE
*MCALL #=   515 LV= 1          DO    WHILE=(C,R4,GT,=F'0')
*MCALL #=   516 LV= 2          ZSTREQU 
*MEXIT #=   516 LV= 2 ZSTREQU
#@DO_11_T                        DS 0H
*MCALL #=   517 LV= 2          IF C,R4,GT,=F'0'
*MCALL #=   518 LV= 3          ZSTREQU 
*MEXIT #=   518 LV= 3 ZSTREQU
         C     R4,=F'0'
         BC    15-GT,#@IF_57_2
*MEXIT #=   517 LV= 2 IF
               B   #@DO_11_1
*MCALL #=   519 LV= 2          ENDIF 
*MCALL #=   520 LV= 3          ZSTREQU 
*MEXIT #=   520 LV= 3 ZSTREQU
#@IF_57_2                                                DS 0H
*MEXIT #=   519 LV= 2 ENDIF
         B     #@DO_11_E
#@DO_11_1                        DS 0H
*MEXIT #=   515 LV= 1 DO
*MCALL #=   521 LV= 1                IF (C,R4,GT,=F'16')
*MCALL #=   522 LV= 2          ZSTREQU 
*MEXIT #=   522 LV= 2 ZSTREQU
         C     R4,=F'16'
         BC    15-GT,#@IF_58_2
*MEXIT #=   521 LV= 1 IF
                  LA  R5,16
*MCALL #=   523 LV= 1                ELSE 
*MCALL #=   524 LV= 2          ZSTREQU 
*MEXIT #=   524 LV= 2 ZSTREQU
        B      #@IF_58_E
#@IF_58_2                                                DS 0H
*MEXIT #=   523 LV= 1 ELSE
                  LR  R5,R4
*MCALL #=   525 LV= 1                ENDIF 
*MCALL #=   526 LV= 2          ZSTREQU 
*MEXIT #=   526 LV= 2 ZSTREQU
#@IF_58_E                        DS 0H
*MEXIT #=   525 LV= 1 ENDIF
               SR   R4,R5
               MVC  DUMP_MEM,=XL16'00'
               AHI  R5,-1
               EX   R5,DUMP_MVC_MEM
               AHI  R5,1
*MCALL #=   527 LV= 1                IF   (CLI,DUMP_FIRST,EQ,TRUE),OR,(X
               CLC,DUMP_MEM,NE,LAST_MEM),OR,(C,R4,EQ,=F'0')            X
                     PRINT LAST  LINE
*MCALL #=   528 LV= 2          ZSTREQU 
*MEXIT #=   528 LV= 2 ZSTREQU
         CLI   DUMP_FIRST,TRUE
         BC    15-EQ,#@IF_59_2
         B     #@IF_59_1
#@IF_59_2                                                DS 0H
         CLC   DUMP_MEM,LAST_MEM
         BC    15-NE,#@IF_59_3
         B     #@IF_59_1
#@IF_59_3                                                DS 0H
         C     R4,=F'0'
         BC    15-EQ,#@IF_59_4
#@IF_59_1                               DS 0H
*MEXIT #=   527 LV= 1 IF
*MCALL #=   529 LV= 1                     IF (CLI,DUMP_SKIP,EQ,TRUE)
*MCALL #=   530 LV= 2          ZSTREQU 
*MEXIT #=   530 LV= 2 ZSTREQU
         CLI   DUMP_SKIP,TRUE
         BC    15-EQ,#@IF_60_2
*MEXIT #=   529 LV= 1 IF
                       MVI DUMP_SKIP,FALSE
                       LA  R2,=CL80'........'
*MCALL #=   531 LV= 1                        PM  DISPLAY
         MVC   DISPLAY-2(2),*+10
         B     DISPLAY
         DC    S(*+2)
*MEXIT #=   531 LV= 1 PM
*MCALL #=   532 LV= 1                     ENDIF 
*MCALL #=   533 LV= 2          ZSTREQU 
*MEXIT #=   533 LV= 2 ZSTREQU
#@IF_60_2                                                DS 0H
*MEXIT #=   532 LV= 1 ENDIF
                    MVI  DUMP_FIRST,FALSE
                    MVC  LAST_MEM,DUMP_MEM
                    LR   R0,R3
                    SR   R0,R9
                    ST   R0,DUMP_HEX
                    UNPK DUMP_ADDR(9),DUMP_HEX(5)
                    TR   DUMP_ADDR,HEX_TAB-240
                    MVI  DUMP_ADDR+8,C' '
                    UNPK DUMP_HEX(9),DUMP_MEM(5)
                    UNPK DUMP_HEX+8(9),DUMP_MEM+4(5)
                    UNPK DUMP_HEX+16(9),DUMP_MEM+8(5)
                    UNPK DUMP_HEX+24(9),DUMP_MEM+12(5)
                    TR   DUMP_HEX,HEX_TAB-240
                    MVI  DUMP_HEX+32,C'*'
*MCALL #=   534 LV= 1                     IF   (CLI,EBCDIC_TEXT,NE,TRUEX
               )
*MCALL #=   535 LV= 2          ZSTREQU 
*MEXIT #=   535 LV= 2 ZSTREQU
         CLI   EBCDIC_TEXT,TRUE
         BC    15-NE,#@IF_61_2
*MEXIT #=   534 LV= 1 IF
                         TR  DUMP_MEM,ASCII_TO_EBCDIC
*MCALL #=   536 LV= 1                     ENDIF 
*MCALL #=   537 LV= 2          ZSTREQU 
*MEXIT #=   537 LV= 2 ZSTREQU
#@IF_61_2                                                DS 0H
*MEXIT #=   536 LV= 1 ENDIF
                    TR    DUMP_MEM,EBCDIC_PRINT
*MCALL #=   538 LV= 1                     IF    (CHI,R5,LT,16)  BLANK OX
               UT SHORT LINE
*MCALL #=   539 LV= 2          ZSTREQU 
*MEXIT #=   539 LV= 2 ZSTREQU
         CHI   R5,16
         BC    15-LT,#@IF_62_2
*MEXIT #=   538 LV= 1 IF
                          LA  R2,0(R5,R5)
                          LA  R2,DUMP_HEX(R2)  OFFSET TO END
                          LHI R1,15
                          SR  R1,R5
                          LA  R14,1(R1,R1)     LENGTH OF BLANKS-1
                          EX  R14,DUMP_MVC_HEX_BLANKS
                          LA  R2,DUMP_MEM(R5)
                          EX  R1,DUMP_MVC_TEXT_BLANKS
*MCALL #=   540 LV= 1                     ENDIF 
*MCALL #=   541 LV= 2          ZSTREQU 
*MEXIT #=   541 LV= 2 ZSTREQU
#@IF_62_2                                                DS 0H
*MEXIT #=   540 LV= 1 ENDIF
                    LA    R2,DUMP_LINE
*MCALL #=   542 LV= 1                     PM    DISPLAY
         MVC   DISPLAY-2(2),*+10
         B     DISPLAY
         DC    S(*+2)
*MEXIT #=   542 LV= 1 PM
*MCALL #=   543 LV= 1                ELSE 
*MCALL #=   544 LV= 2          ZSTREQU 
*MEXIT #=   544 LV= 2 ZSTREQU
        B      #@IF_59_E
#@IF_59_4                                                DS 0H
*MEXIT #=   543 LV= 1 ELSE
                    MVI   DUMP_SKIP,TRUE
*MCALL #=   545 LV= 1                ENDIF 
*MCALL #=   546 LV= 2          ZSTREQU 
*MEXIT #=   546 LV= 2 ZSTREQU
#@IF_59_E                        DS 0H
*MEXIT #=   545 LV= 1 ENDIF
               AR   R3,R5
*MCALL #=   547 LV= 1          ENDDO 
*MCALL #=   548 LV= 2          DO    END
*MCALL #=   549 LV= 3          ZSTREQU 
*MEXIT #=   549 LV= 3 ZSTREQU
         B     #@DO_11_T
#@DO_11_E                        DS 0H
*MEXIT #=   548 LV= 2 DO
*MEXIT #=   547 LV= 1 ENDDO
*MCALL #=   550 LV= 1          PEXIT 
         B     DUMP_REQ-4
*MEXIT #=   550 LV= 1 PEXIT
DUMP_MVC_MEM         MVC  DUMP_MEM(0),0(R3)  MOVE MEM TO DUMP TEXT
DUMP_MVC_HEX_BLANKS  MVC  0(0,R2),=CL32' '   CLEAR HEX  BEYOND END
DUMP_MVC_TEXT_BLANKS MVC 0(0,R2),=CL16' '    CLEAR TEXT BEYOND END
*
* DISPLAY ERROR 80 CHAR AT R2 ON CONSOLE OR SYSPRINT
*
*MCALL #=   551 LV= 1 DISPLAY_ERROR PENTRY 
         DC    0H'0',CL8'DISPLAY_ERROR'
         B     *+4
DISPLAY_ERROR EQU *
*MEXIT #=   551 LV= 1 PENTRY
         MVI  VER_ERROR,TRUE      FORCE VERIFY ERROR
         AP   TOTAL_ERRORS,=P'1'
*MCALL #=   552 LV= 1          PM   DISPLAY
         MVC   DISPLAY-2(2),*+10
         B     DISPLAY
         DC    S(*+2)
*MEXIT #=   552 LV= 1 PM
*MCALL #=   553 LV= 1          PEXIT 
         B     DISPLAY_ERROR-4
*MEXIT #=   553 LV= 1 PEXIT
*
* DISPLAY 80 CHAR AT R2 ON CONSOLE OR SYSPRINT
*
*MCALL #=   554 LV= 1 DISPLAY  PENTRY 
         DC    0H'0',CL8'DISPLAY'
         B     *+4
DISPLAY  EQU   *
*MEXIT #=   554 LV= 1 PENTRY
         MVC  DISPLAY_TEXT,0(R2)
*MCALL #=   555 LV= 1          WTO MF=(E,DISPLAY_WTO)
         LA    1,DISPLAY_WTO
         SVC   35
*MEXIT #=   555 LV= 1 WTO
*MCALL #=   556 LV= 1          IF    (CLI,CONSOLE,NE,TRUE)
*MCALL #=   557 LV= 2          ZSTREQU 
*MEXIT #=   557 LV= 2 ZSTREQU
         CLI   CONSOLE,TRUE
         BC    15-NE,#@IF_63_2
*MEXIT #=   556 LV= 1 IF
*MCALL #=   558 LV= 1                PUT SYSPRINT,(R2)
         LA    1,SYSPRINT
*MCALL #=   559 LV= 2          ZOPTLR 0,R2
         LR    0,R2
*MEXIT #=   559 LV= 2 ZOPTLR
         SVC  152 QSAM PUT R0=REC, R1=DCB
*MEXIT #=   558 LV= 1 PUT
*MCALL #=   560 LV= 1          ENDIF 
*MCALL #=   561 LV= 2          ZSTREQU 
*MEXIT #=   561 LV= 2 ZSTREQU
#@IF_63_2                                                DS 0H
*MEXIT #=   560 LV= 1 ENDIF
*MCALL #=   562 LV= 1          PEXIT 
         B     DISPLAY-4
*MEXIT #=   562 LV= 1 PEXIT
SYSIN_ERR DS 0H
*MCALL #=   563 LV= 1          WTO   'I/O ERROR ON SYSIN - ABORTING'
         BRAS  1,*+(WTO#0563_EOT-*+1)/2*2
         DC    AL2(WTO#0563_EOT-*,0),C'I/O ERROR ON SYSIN - ABORTING'
WTO#0563_EOT     EQU *
         SVC   35
*MEXIT #=   563 LV= 1 WTO
*MCALL #=   564 LV= 1          ABEND 111
         LA   1,111
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   564 LV= 1 ABEND
SYSPRINT_ERR DS 0H
*MCALL #=   565 LV= 1          WTO   'I/O ERROR ON SYSPRINT - ABORTING'
         BRAS  1,*+(WTO#0565_EOT-*+1)/2*2
         DC    AL2(WTO#0565_EOT-*,0),C'I/O ERROR ON SYSPRINT - ABORTINGX
               '
WTO#0565_EOT     EQU *
         SVC   35
*MEXIT #=   565 LV= 1 WTO
*MCALL #=   566 LV= 1          ABEND 222
         LA   1,222
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   566 LV= 1 ABEND
*
* SHARED DATA AREAS
*
SHARED_DATA DS 0D
         LTORG 
*MCALL #=   567 LV= 1          EQUREGS 
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
*MEXIT #=   567 LV= 1 EQUREGS
CONSOLE      DC AL1(FALSE) USE WTO/WTOR TO CONSOLE IF PARM(CON)
EOF          DC AL1(FALSE) END OF SYSIN INPUT
EBCDIC_TEXT  DC AL1(TRUE)  EBCDIC TEXT MODE VS ASCII
FILE_LOADED  DC AL1(FALSE) FILE LOADED  IN MEMORY
FILE_UPDATE  DC AL1(FALSE) FILE UPDATED IN MEMORY
FILE_ERROR   DC AL1(TRUE)  FILE ERROR (RESET AT EACH NAME FILE)
PARM_ERROR   DC AL1(FALSE) PARM ERROR ON COMMAND
VER_ERROR    DC AL1(FALSE) VERIFY ERROR
TEXT_CHAR    DC AL1(TRUE)  FIND END OF TEXT
LOOP         DC AL1(FALSE) REPEAT CMDS FROM LAST FIND IF OK
TOTAL_ERRORS DC   PL4'0'
FALSE    EQU   0
TRUE     EQU   1
SYSINDD  DC    C'SYSIN',X'00'
*MCALL #=   568 LV= 1 SYSIN    DCB   DSORG=PS,MACRF=GM,RECFM=FT,BLKSIZEX
               =80,EODAD=GET_EOF,DDNAME=SYSIN,SYNAD=SYSIN_ERR
SYSIN    DS    0D             RPI 915
         DC    XL(DCBLEN)'00' RPI 946
         ORG   SYSIN+DCBID-IHADCB        RPI88
         DC    C'DCBV1001'            RPI88
         ORG   SYSIN+DCBDSORG-IHADCB
         DC    AL1(DCBDSORG_PS) DCBDSORG
         ORG   SYSIN+DCBEODAD-IHADCB
         DC    A(GET_EOF) DCBEODAD
         ORG   SYSIN+DCBRECFM-IHADCB
         DC    AL1(DCBRECFM_FT) DCBRECFM
         ORG   SYSIN+DCBDDNAM-IHADCB
         DC    CL8'SYSIN' DCBDDNAM
         ORG   SYSIN+DCBOFLGS-IHADCB
         DC    AL1(0) DCBOFLGS RPI 668 ZERO (SET AT OPEN)
         ORG   SYSIN+DCBMACRF-IHADCB
         DC    AL2(DCBMACRF_GM) DCBMACRF
         ORG   SYSIN+DCBSYNAD-IHADCB
         DC    A(SYSIN_ERR) DCBSYNAD DCBSYNAD
         ORG   SYSIN+DCBBLKSIF-IHADCB    RPI 587
         DC    F'80' DCBBLKSIF  RPI 587
         ORG   SYSIN+DCBLRECLF-IHADCB    RPI 587
         DC    F'0' DCBLRECLF    RPI 587
         ORG   SYSIN+DCBREC-IHADCB
         DC    A(0) DCBREC
         ORG   SYSIN+DCBDSNAM-IHADCB
         DC    A(0) DCBDSNAM
         ORG   SYSIN+DCBDCBE-IHADCB   RPI 281
         DC    A(0) DCBDCBE
         ORG   SYSIN+DCBIO-IHADCB     RPI 907
         DC    A(0)     DCBIO      RPI 907 TOTAL IO COUNT SINCE OPEN
         ORG   SYSIN+DCBLEN
*MCALL #=   569 LV= 2          DCBD 
*MEXIT #=   569 LV= 2 DCBD
*MEXIT #=   568 LV= 1 DCB
*MCALL #=   570 LV= 1 SYSPRINT DCB   DSORG=PS,MACRF=PM,RECFM=FT,BLKSIZEX
               =80,DDNAME=SYSPRINT,SYNAD=SYSPRINT_ERR
SYSPRINT DS    0D             RPI 915
         DC    XL(DCBLEN)'00' RPI 946
         ORG   SYSPRINT+DCBID-IHADCB        RPI88
         DC    C'DCBV1001'            RPI88
         ORG   SYSPRINT+DCBDSORG-IHADCB
         DC    AL1(DCBDSORG_PS) DCBDSORG
         ORG   SYSPRINT+DCBEODAD-IHADCB
         DC    A(0) DCBEODAD
         ORG   SYSPRINT+DCBRECFM-IHADCB
         DC    AL1(DCBRECFM_FT) DCBRECFM
         ORG   SYSPRINT+DCBDDNAM-IHADCB
         DC    CL8'SYSPRINT' DCBDDNAM
         ORG   SYSPRINT+DCBOFLGS-IHADCB
         DC    AL1(0) DCBOFLGS RPI 668 ZERO (SET AT OPEN)
         ORG   SYSPRINT+DCBMACRF-IHADCB
         DC    AL2(DCBMACRF_PM) DCBMACRF
         ORG   SYSPRINT+DCBSYNAD-IHADCB
         DC    A(SYSPRINT_ERR) DCBSYNAD DCBSYNAD
         ORG   SYSPRINT+DCBBLKSIF-IHADCB    RPI 587
         DC    F'80' DCBBLKSIF  RPI 587
         ORG   SYSPRINT+DCBLRECLF-IHADCB    RPI 587
         DC    F'0' DCBLRECLF    RPI 587
         ORG   SYSPRINT+DCBREC-IHADCB
         DC    A(0) DCBREC
         ORG   SYSPRINT+DCBDSNAM-IHADCB
         DC    A(0) DCBDSNAM
         ORG   SYSPRINT+DCBDCBE-IHADCB   RPI 281
         DC    A(0) DCBDCBE
         ORG   SYSPRINT+DCBIO-IHADCB     RPI 907
         DC    A(0)     DCBIO      RPI 907 TOTAL IO COUNT SINCE OPEN
         ORG   SYSPRINT+DCBLEN
*MCALL #=   571 LV= 2          DCBD 
*MEXIT #=   571 LV= 2 DCBD
*MEXIT #=   570 LV= 1 DCB
*MCALL #=   572 LV= 1 SYSUT1   DCB   DSORG=PS,MACRF=GM,RECFM=F,LRECL=0,X
               BLKSIZE=0,DSNAME=FILE_NAME,SYNAD=SYSUT1_ERR
SYSUT1   DS    0D             RPI 915
         DC    XL(DCBLEN)'00' RPI 946
         ORG   SYSUT1+DCBID-IHADCB        RPI88
         DC    C'DCBV1001'            RPI88
         ORG   SYSUT1+DCBDSORG-IHADCB
         DC    AL1(DCBDSORG_PS) DCBDSORG
         ORG   SYSUT1+DCBEODAD-IHADCB
         DC    A(0) DCBEODAD
         ORG   SYSUT1+DCBRECFM-IHADCB
         DC    AL1(DCBRECFM_F) DCBRECFM
         ORG   SYSUT1+DCBDDNAM-IHADCB
         DC    CL8'SYSUT1' DCBDDNAME
         ORG   SYSUT1+DCBOFLGS-IHADCB
         DC    AL1(0) DCBOFLGS RPI 668 ZERO (SET AT OPEN)
         ORG   SYSUT1+DCBMACRF-IHADCB
         DC    AL2(DCBMACRF_GM) DCBMACRF
         ORG   SYSUT1+DCBSYNAD-IHADCB
         DC    A(SYSUT1_ERR) DCBSYNAD DCBSYNAD
         ORG   SYSUT1+DCBBLKSIF-IHADCB    RPI 587
         DC    F'0' DCBBLKSIF  RPI 587
         ORG   SYSUT1+DCBLRECLF-IHADCB    RPI 587
         DC    F'0' DCBLRECLF    RPI 587
         ORG   SYSUT1+DCBREC-IHADCB
         DC    A(0) DCBREC
         ORG   SYSUT1+DCBDSNAM-IHADCB
         DC    A(FILE_NAME) DCBDSNAM
         ORG   SYSUT1+DCBDCBE-IHADCB   RPI 281
         DC    A(0) DCBDCBE
         ORG   SYSUT1+DCBIO-IHADCB     RPI 907
         DC    A(0)     DCBIO      RPI 907 TOTAL IO COUNT SINCE OPEN
         ORG   SYSUT1+DCBLEN
*MCALL #=   573 LV= 2          DCBD 
*MEXIT #=   573 LV= 2 DCBD
*MEXIT #=   572 LV= 1 DCB
*MCALL #=   574 LV= 1 SYSUT2   DCB   DSORG=PS,MACRF=RW,RECFM=F,LRECL=0,X
               BLKSIZE=0,DSNAME=FILE_NAME,SYNAD=SYSUT2_ERR
SYSUT2   DS    0D             RPI 915
         DC    XL(DCBLEN)'00' RPI 946
         ORG   SYSUT2+DCBID-IHADCB        RPI88
         DC    C'DCBV1001'            RPI88
         ORG   SYSUT2+DCBDSORG-IHADCB
         DC    AL1(DCBDSORG_PS) DCBDSORG
         ORG   SYSUT2+DCBEODAD-IHADCB
         DC    A(0) DCBEODAD
         ORG   SYSUT2+DCBRECFM-IHADCB
         DC    AL1(DCBRECFM_F) DCBRECFM
         ORG   SYSUT2+DCBDDNAM-IHADCB
         DC    CL8'SYSUT2' DCBDDNAME
         ORG   SYSUT2+DCBOFLGS-IHADCB
         DC    AL1(0) DCBOFLGS RPI 668 ZERO (SET AT OPEN)
         ORG   SYSUT2+DCBMACRF-IHADCB
         DC    AL2(DCBMACRF_RW) DCBMACRF
         ORG   SYSUT2+DCBSYNAD-IHADCB
         DC    A(SYSUT2_ERR) DCBSYNAD DCBSYNAD
         ORG   SYSUT2+DCBBLKSIF-IHADCB    RPI 587
         DC    F'0' DCBBLKSIF  RPI 587
         ORG   SYSUT2+DCBLRECLF-IHADCB    RPI 587
         DC    F'0' DCBLRECLF    RPI 587
         ORG   SYSUT2+DCBREC-IHADCB
         DC    A(0) DCBREC
         ORG   SYSUT2+DCBDSNAM-IHADCB
         DC    A(FILE_NAME) DCBDSNAM
         ORG   SYSUT2+DCBDCBE-IHADCB   RPI 281
         DC    A(0) DCBDCBE
         ORG   SYSUT2+DCBIO-IHADCB     RPI 907
         DC    A(0)     DCBIO      RPI 907 TOTAL IO COUNT SINCE OPEN
         ORG   SYSUT2+DCBLEN
*MCALL #=   575 LV= 2          DCBD 
*MEXIT #=   575 LV= 2 DCBD
*MEXIT #=   574 LV= 1 DCB
WTORECB  DC    F'0'
CMD      DC    CL80' ',C'*'
CUR_CMD  DC   A(CMD_LIST)
NEXT_CMD DC   A(CMD_LIST)
OP       DC   CL8' '
LENGTH   DC   A(0)
BASE     DC   A(0)
OFFSET   DC   A(0)
VALUE    DC   XL256'00'
LVALUE   DC   A(0)
DUMP_FIRST DC  AL1(TRUE)   PRINT FIRST LINE OF DUMP
DUMP_SKIP  DC  AL1(FALSE)  SKIP 1 OR MORE DUP LINES BEFORE LAST
DUMP_LINE EQU *
DUMP_ADDR DC  CL8' ',C' *'
DUMP_HEX DC  CL32' ',C'* *'
DUMP_MEM DC  XL16'00',C'*'
         DC  (DUMP_LINE+80-*)C' '
LAST_MEM DC  CL16' '
HEX_TAB  DC  C'0123456789ABCDEF'
HEX_HWORD DC H'0'
HEX_DIGIT EQU HEX_HWORD+1,1
HEX_DIGIT_TABLE DC XL256'FF'
         ORG  HEX_DIGIT_TABLE+C'0'
         DC   X'00010203040506070809'
         ORG  HEX_DIGIT_TABLE+C'A'
         DC   X'0A0B0C0D0E0F'
         ORG 
DISPLAY_WTO     DC  AL2(DISPLAY_WTO_END-*,0)
DISPLAY_TEXT    DC  CL80' '
DISPLAY_WTO_END EQU *
FILE_SIZE  DC  F'0'
FILE_NAME  DC  CL256' ',C'"'''
ASCII_TO_EBCDIC EQU *
           DC X'00010203372D2E2F1605250B0C0D0E0F' 00 ................
           DC X'101112003C3D322618193F2722003500' 10 ................
           DC X'405A7F7B5B6C507D4D5D5C4E6B604B61' 20  !"#$%&'()*+,-./
           DC X'F0F1F2F3F4F5F6F7F8F97A5E4C7E6E6F' 30 0123456789:;<=>?
           DC X'7CC1C2C3C4C5C6C7C8C9D1D2D3D4D5D6' 40 @ABCDEFGHIJKLMNO
           DC X'D7D8D9E2E3E4E5E6E7E8E9ADE0BD5F6D' 50 PQRSTUVWXYZ.\.._
           DC X'79818283848586878889919293949596' 60 `abcdefghijklmno
           DC X'979899A2A3A4A5A6A7A8A98B4F9BA107' 70 pqrstuvwxyz.|.~.
           DC X'00010203372D2E2F1605250B0C0D0E0F' 80 ................
           DC X'101112003C3D322618193F2722003500' 90 ................
           DC X'405A7F7B5B6C507D4D5D5C4E6B604B61' A0  !"#$%&'()*+,-./
           DC X'F0F1F2F3F4F5F6F7F8F97A5E4C7E6E6F' B0 0123456789:;<=>?
           DC X'7CC1C2C3C4C5C6C7C8C9D1D2D3D4D5D6' C0 @ABCDEFGHIJKLMNO
           DC X'D7D8D9E2E3E4E5E6E7E8E9ADE0BD5F6D' D0 PQRSTUVWXYZ.\.._
           DC X'79818283848586878889919293949596' E0 `abcdefghijklmno
           DC X'979899A2A3A4A5A6A7A8A98B4F9BA107' F0 pqrstuvwxyz.|.~.
EBCDIC_TO_ASCII EQU    *
           DC X'000102030009007F0000000B0C0D0E0F' 00 ................
           DC X'10111200000008001819000000000000' 10 ................
           DC X'00001C00000A171B0000000000050607' 20 ................
           DC X'00001600001E0004000000001415001A' 30 ................
           DC X'20000000000000000000002E3C282B7C' 40  ...........<(+|
           DC X'2600000000000000000021242A293B5E' 50 &.........!$*);^
           DC X'2D2F0000000000000000002C255F3E3F' 60 -/.........,%_>?
           DC X'000000000000000000603A2340273D22' 70 .........`:#@'="
           DC X'00616263646566676869007B00000000' 80 .abcdefghi.{....
           DC X'006A6B6C6D6E6F707172007D00000000' 90 .jklmnopqr.}....
           DC X'007E737475767778797A0000005B0000' A0 .~stuvwxyz...[..
           DC X'000000000000000000000000005D0000' B0 .............]..
           DC X'00414243444546474849000000000000' C0 .ABCDEFGHI......
           DC X'004A4B4C4D4E4F505152000000000000' D0 .JKLMNOPQR......
           DC X'5C00535455565758595A000000000000' E0 \.STUVWXYZ......
           DC X'30313233343536373839000000000000' F0 0123456789..
EBCDIC_PRINT EQU *
           DC C'................'   //00
           DC C'................'   //10
           DC C'................'   //20
           DC C'................'   //30
           DC C' ...........<(+|'   //40
           DC C'&&.........!$*);.'  //50 WITH &&
           DC C'-/.........,%_>?'   //60
           DC C'.........`:#@''="'  //70 WITH ''
           DC C'.abcdefghi......'   //80
           DC C'.jklmnopqr......'   //90
           DC C'.~stuvwxyz......'   //A0
           DC C'^.........[]....'   //B0
           DC C'{ABCDEFGHI......'   //C0
           DC C'}JKLMNOPQR......'   //D0
           DC C'\.STUVWXYZ......'   //E0
           DC C'0123456789......'   //F0
CMD_LIST DC   100CL80' ' SAVE CMDS FOLLOWING FIND FOR LOOP
CMD_LIST_END EQU *
*MCALL #=   576 LV= 1          DCBD 
*MEXIT #=   576 LV= 1 DCBD
         END 
