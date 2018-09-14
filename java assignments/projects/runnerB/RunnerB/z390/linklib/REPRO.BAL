*********************************************************************
* Copyright 2007 Automated Software Tools Corporation               *
* This source code is part of z390 assembler/emulator package       *
* The z390 package is distributed under GNU general public license  *
* Author - Don Higgins                                              *
* Date   - 07/25/07                                                 *
*********************************************************************
* 07/25/07 INITIAL CODING OF REPRO UTILITY TO COPY INFILE TO OUTFILE
* 08/30/07 RPI 688 CORRECT OUTFILEQ SYNAD ADDRESS FOR ERRORS
*          CORRECT VAR LENGTH QSAM OUTPUT PREFIX  GENERATION
* 09/07/07 RPI 681 CONVERT VCDT TO VSAM CATALOG WITH VCLR/VAIX ENTRIES
* 09/15/07 RPI 696 VERIFY LOADED FILE IS VCDT BEFORE ASSUMING VSAM
* 09/17/07 RPI 697 SUPPORT OPTIONAL OVERRIDE OF QSAM FILE RECFM IN
*          BRACKETS AFTER FILE NAME ON INFILE OR OUTFILE.
*          ALSO DISPLAY INFILE AND OUTFILE INFO AT STARTUP
* 09/19/07 RPI 697 CORRECT EOF TEST WITH SHOWCB RC=0 CHANGE
* 09/22/07 RPI 701 CHANGE DEFAULT TO REPLACE EXISTING VSAM FILES
*          DURING LOADING UNLESS [DISP=MOD] IS CODED FOLLOWING
*          CATALOG.ENTRY ON OUTFILE.
* 10/25/07 RPI 724 SUPPORT NEW EF, EV, RF, AND RV SEQ UNLOAD
*          FORMATS TO HANDLE ALL VSAM FILE RCDS TO 2 GB.
*          SUPPORT STD F, FB, FT, V, VB, VT FORMAT OVERRIDES.
*          RRDS KEY,KGE WILL GET NEXT
*          BUFFER TO REDUCE I/O'S AND IMPROVE PERFORMANCE.
* 11/03/09 RPI 865 ADD SUPPORT TO CREATE AIX BY SETTING INFILE TO
*          BASE CLUSTER AND OUTFILE TO AIX NAME IN CATALOG.
* 10/13/10 RPI 1130 REMOVE SNAP ID=123
* 10/16/10 RPI 1130 USE BASE CLUSTER PATH FOR AIX
* 10/18/10 RPI 1130 CORRECT AIX BUFFER TO PREVENT OVERLAY, FIX LRECL
*********************************************************************
*
*  REPRO WILL LOAD OR UNLOAD VSAM FILE FROM/TO QSAM FILE
*
*    INFILE  = QSAM OR VSAM INPUT FILE
*    OUTFILE = VSAM OR QSAM OUTPUT FILE
*
*    1.  VSAM FILE MUST SPECIFY VCDT CATALOG WITH ENTRY SUFFIX.
*    2.  QSAM FILE MAY HAVE OVERIDE RECFM USING SUFFIX OF THE FORM
*        [RECFM=FT|FB|VT|VB]. THE DEFAULT IF F OR V BASED ON VSAM.
*    3.  QSAM OVERRIDE MUST BE CONSISTENT WITH VSAM RECORD FORMAT F/V
*
*    EXAMPLE:
*       SET INFILE=ESF1.TF1[RECFM=FT]  INPUT TEXT QSAM FILE
*       SET OUTFILE=TESTCAT.ESF1       OUTPUT ESF1.VES FIXED ESDS VSAM
*       EXEC REPRO
*
* REGISTER USAGE
*   R3  = RECORD PREFIX (QSAM VAR RECORD WITH 4 BYTE PREFIX)
*   R4  = RECORD AREA   (VSAM FIXED OR VAR LEN RECORD)
*   R5  = QSAM INFILE/OUTFILE DCB
*   R6  = VSAM INFILE/OUTFILE ACB
*   R7  = VSAM VCLR CATALOG ENTRY
*   R8  = VSAM/QSAM TEST DDNAME
*   R9  = QSAM DSNAME WITH OPTIONAL OVERRIDE [RECFM=XX]
*   R9  = BUFFER AVAILABLE LENGTH FOR MVCL TO/FROM AFTER INIT_BUFF
*   R10 = BUFFER POINTER
*   R11 = BUFFER MOVE LENGTH
*   R12 = BASE
*   R13 = BASE
*********************************************************************
*MCALL #=     1 LV= 1 REPRO    SUBENTRY BASES=(R13,R12)
REPRO    CSECT 
         STM   14,12,12(13)
         BAL   15,104(15)
         DC    18F'0'
         DC    CL8'REPRO'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
         USING REPRO+8,13
         LAY   R12,4096(R13)   RPI 601
         USING REPRO+8+4096,R12
*MEXIT #=     1 LV= 1 SUBENTRY
         COPY  ASMMSP
         COPY ZSTRMAC  Z390 STRUCTURED PROGRAMMING MACROS
*MCALL #=     2 LV= 1          WTO   'REPRO z390 VSAM UTILITY V1.2'
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'REPRO z390 VSAM UTILITY V1.2'
WTO#0002_EOT     EQU *
         SVC   35
*MEXIT #=     2 LV= 1 WTO
*MCALL #=     3 LV= 1          PM    INIT    SET FILE AND RECORD TYPE IX
               NFO
         MVC   INIT-2(2),*+10
         B     INIT
         DC    S(*+2)
*MEXIT #=     3 LV= 1 PM
LOOP     EQU   *
*MCALL #=     4 LV= 1          PM    GET
         MVC   GET-2(2),*+10
         B     GET
         DC    S(*+2)
*MEXIT #=     4 LV= 1 PM
*MCALL #=     5 LV= 1          IF    (CLI,BUILDAIX,EQ,TRUE)
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
         CLI   BUILDAIX,TRUE
         BC    15-EQ,#@IF_1_2
*MEXIT #=     5 LV= 1 IF
*MCALL #=     7 LV= 1                PM    PUT_AIX_SORT_REC
         MVC   PUT_AIX_SORT_REC-2(2),*+10
         B     PUT_AIX_SORT_REC
         DC    S(*+2)
*MEXIT #=     7 LV= 1 PM
*MCALL #=     8 LV= 1          ELSE 
*MCALL #=     9 LV= 2          ZSTREQU 
*MEXIT #=     9 LV= 2 ZSTREQU
        B      #@IF_1_E
#@IF_1_2                                                 DS 0H
*MEXIT #=     8 LV= 1 ELSE
*MCALL #=    10 LV= 1                PM    PUT
         MVC   PUT-2(2),*+10
         B     PUT
         DC    S(*+2)
*MEXIT #=    10 LV= 1 PM
*MCALL #=    11 LV= 1          ENDIF 
*MCALL #=    12 LV= 2          ZSTREQU 
*MEXIT #=    12 LV= 2 ZSTREQU
#@IF_1_E                         DS 0H
*MEXIT #=    11 LV= 1 ENDIF
         B     LOOP
EOF      EQU   *
*MCALL #=    13 LV= 1          IF    (CLI,BUILDAIX,EQ,TRUE)
*MCALL #=    14 LV= 2          ZSTREQU 
*MEXIT #=    14 LV= 2 ZSTREQU
         CLI   BUILDAIX,TRUE
         BC    15-EQ,#@IF_2_2
*MEXIT #=    13 LV= 1 IF
*MCALL #=    15 LV= 1                PM GET_AIX_SORT_REC
         MVC   GET_AIX_SORT_REC-2(2),*+10
         B     GET_AIX_SORT_REC
         DC    S(*+2)
*MEXIT #=    15 LV= 1 PM
*MCALL #=    16 LV= 1                DO WHILE=(CLI,AIX_EOF,NE,TRUE)
*MCALL #=    17 LV= 2          ZSTREQU 
*MEXIT #=    17 LV= 2 ZSTREQU
#@DO_1_T                         DS 0H
*MCALL #=    18 LV= 2          IF CLI,AIX_EOF,NE,TRUE
*MCALL #=    19 LV= 3          ZSTREQU 
*MEXIT #=    19 LV= 3 ZSTREQU
         CLI   AIX_EOF,TRUE
         BC    15-NE,#@IF_3_2
*MEXIT #=    18 LV= 2 IF
               B   #@DO_1_1
*MCALL #=    20 LV= 2          ENDIF 
*MCALL #=    21 LV= 3          ZSTREQU 
*MEXIT #=    21 LV= 3 ZSTREQU
#@IF_3_2                                                 DS 0H
*MEXIT #=    20 LV= 2 ENDIF
         B     #@DO_1_E
#@DO_1_1                         DS 0H
*MEXIT #=    16 LV= 1 DO
*MCALL #=    22 LV= 1                   PM PUT
         MVC   PUT-2(2),*+10
         B     PUT
         DC    S(*+2)
*MEXIT #=    22 LV= 1 PM
*MCALL #=    23 LV= 1                   PM GET_AIX_SORT_REC
         MVC   GET_AIX_SORT_REC-2(2),*+10
         B     GET_AIX_SORT_REC
         DC    S(*+2)
*MEXIT #=    23 LV= 1 PM
*MCALL #=    24 LV= 1                ENDDO 
*MCALL #=    25 LV= 2          DO    END
*MCALL #=    26 LV= 3          ZSTREQU 
*MEXIT #=    26 LV= 3 ZSTREQU
         B     #@DO_1_T
#@DO_1_E                         DS 0H
*MEXIT #=    25 LV= 2 DO
*MEXIT #=    24 LV= 1 ENDDO
*MCALL #=    27 LV= 1          ENDIF 
*MCALL #=    28 LV= 2          ZSTREQU 
*MEXIT #=    28 LV= 2 ZSTREQU
#@IF_2_2                                                 DS 0H
*MEXIT #=    27 LV= 1 ENDIF
         MVC   DTOTREC,=X'4020202020202020'
         ED    DTOTREC,PTOTREC
*MCALL #=    29 LV= 1          WTO   MF=(E,WTO_TOTREC)
         LA    1,WTO_TOTREC
         SVC   35
*MEXIT #=    29 LV= 1 WTO
*MCALL #=    30 LV= 1          PM    CLOSE
         MVC   CLOSE-2(2),*+10
         B     CLOSE
         DC    S(*+2)
*MEXIT #=    30 LV= 1 PM
*MCALL #=    31 LV= 1          WTO   'REPRO ENDED OK'
         BRAS  1,*+(WTO#0031_EOT-*+1)/2*2
         DC    AL2(WTO#0031_EOT-*,0),C'REPRO ENDED OK'
WTO#0031_EOT     EQU *
         SVC   35
*MEXIT #=    31 LV= 1 WTO
*MCALL #=    32 LV= 1          SUBEXIT 
         LA    15,0
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=    32 LV= 1 SUBEXIT
*
* INIT - SET INFILE AND OUTFILE TYPES AND SET RECORD AREA
*
* FILE TYPE IS VSAM IF DD FILE NAME UP TO . IS 390 LOADABLE
* VCDT CATALOG ELSE IT IS ASSUMED QSAM.  WHEN ACB IS OPENED THE NAME
* FOLLOWING PERIOD IN DDNAME FILE SPEC PROVIDES CATALOG ENTRY
* NAME BASE CLUSTER.
*
*MCALL #=    33 LV= 1 INIT     PENTRY 
         DC    0H'0',CL8'INIT'
         B     *+4
INIT     EQU   *
*MEXIT #=    33 LV= 1 PENTRY
*MCALL #=    34 LV= 1          GETENV INFILEDD
         LA    1,INFILEDD
         LA   0,1
         SVC  40 EXTRACT GETENV R0=1, R1=A(NAME) OUTPUT R2=A(VALUE)
*MEXIT #=    34 LV= 1 GETENV
*MCALL #=    35 LV= 1          IF    (LTR,R15,NE,R15)
*MCALL #=    36 LV= 2          ZSTREQU 
*MEXIT #=    36 LV= 2 ZSTREQU
         LTR   R15,R15
         BC    15-NE,#@IF_4_2
*MEXIT #=    35 LV= 1 IF
*MCALL #=    37 LV= 1                WTO 'REPRO INFILE DDNAME NOT FOUNDX
               '
         BRAS  1,*+(WTO#0037_EOT-*+1)/2*2
         DC    AL2(WTO#0037_EOT-*,0),C'REPRO INFILE DDNAME NOT FOUND'
WTO#0037_EOT     EQU *
         SVC   35
*MEXIT #=    37 LV= 1 WTO
*MCALL #=    38 LV= 1                SUBEXIT RC=15
         LA    15,15
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=    38 LV= 1 SUBEXIT
*MCALL #=    39 LV= 1          ENDIF 
*MCALL #=    40 LV= 2          ZSTREQU 
*MEXIT #=    40 LV= 2 ZSTREQU
#@IF_4_2                                                 DS 0H
*MEXIT #=    39 LV= 1 ENDIF
*MCALL #=    41 LV= 1          PM    LOAD_CATALOG
         MVC   LOAD_CATALOG-2(2),*+10
         B     LOAD_CATALOG
         DC    S(*+2)
*MEXIT #=    41 LV= 1 PM
*MCALL #=    42 LV= 1          IF    (LTR,R15,EQ,R15)
*MCALL #=    43 LV= 2          ZSTREQU 
*MEXIT #=    43 LV= 2 ZSTREQU
         LTR   R15,R15
         BC    15-EQ,#@IF_5_2
*MEXIT #=    42 LV= 1 IF
               MVI  INFILET,C'V'
*MCALL #=    44 LV= 1          ELSE 
*MCALL #=    45 LV= 2          ZSTREQU 
*MEXIT #=    45 LV= 2 ZSTREQU
        B      #@IF_5_E
#@IF_5_2                                                 DS 0H
*MEXIT #=    44 LV= 1 ELSE
               MVI  INFILET,C'Q'
*MCALL #=    46 LV= 1          ENDIF 
*MCALL #=    47 LV= 2          ZSTREQU 
*MEXIT #=    47 LV= 2 ZSTREQU
#@IF_5_E                         DS 0H
*MEXIT #=    46 LV= 1 ENDIF
*MCALL #=    48 LV= 1          GETENV OUTFILEDD
         LA    1,OUTFILEDD
         LA   0,1
         SVC  40 EXTRACT GETENV R0=1, R1=A(NAME) OUTPUT R2=A(VALUE)
*MEXIT #=    48 LV= 1 GETENV
*MCALL #=    49 LV= 1          IF    (LTR,R15,NE,R15)
*MCALL #=    50 LV= 2          ZSTREQU 
*MEXIT #=    50 LV= 2 ZSTREQU
         LTR   R15,R15
         BC    15-NE,#@IF_6_2
*MEXIT #=    49 LV= 1 IF
*MCALL #=    51 LV= 1                WTO 'REPRO OUTFILE DDNAME NOT FOUNX
               D'
         BRAS  1,*+(WTO#0051_EOT-*+1)/2*2
         DC    AL2(WTO#0051_EOT-*,0),C'REPRO OUTFILE DDNAME NOT FOUND'
WTO#0051_EOT     EQU *
         SVC   35
*MEXIT #=    51 LV= 1 WTO
*MCALL #=    52 LV= 1                SUBEXIT RC=15
         LA    15,15
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=    52 LV= 1 SUBEXIT
*MCALL #=    53 LV= 1          ENDIF 
*MCALL #=    54 LV= 2          ZSTREQU 
*MEXIT #=    54 LV= 2 ZSTREQU
#@IF_6_2                                                 DS 0H
*MEXIT #=    53 LV= 1 ENDIF
*MCALL #=    55 LV= 1          PM    LOAD_CATALOG
         MVC   LOAD_CATALOG-2(2),*+10
         B     LOAD_CATALOG
         DC    S(*+2)
*MEXIT #=    55 LV= 1 PM
*MCALL #=    56 LV= 1          IF    (CLI,INFILET,EQ,C'Q')
*MCALL #=    57 LV= 2          ZSTREQU 
*MEXIT #=    57 LV= 2 ZSTREQU
         CLI   INFILET,C'Q'
         BC    15-EQ,#@IF_7_2
*MEXIT #=    56 LV= 1 IF
*MCALL #=    58 LV= 1                IF    (LTR,R15,EQ,R15)
*MCALL #=    59 LV= 2          ZSTREQU 
*MEXIT #=    59 LV= 2 ZSTREQU
         LTR   R15,R15
         BC    15-EQ,#@IF_8_2
*MEXIT #=    58 LV= 1 IF
                     MVI  OUTFILET,C'V'
*MCALL #=    60 LV= 1                      PM   INIT_LOAD
         MVC   INIT_LOAD-2(2),*+10
         B     INIT_LOAD
         DC    S(*+2)
*MEXIT #=    60 LV= 1 PM
*MCALL #=    61 LV= 1                ELSE 
*MCALL #=    62 LV= 2          ZSTREQU 
*MEXIT #=    62 LV= 2 ZSTREQU
        B      #@IF_8_E
#@IF_8_2                                                 DS 0H
*MEXIT #=    61 LV= 1 ELSE
*MCALL #=    63 LV= 1                      WTO 'REPRO NO CATALOG FOUND X
               FOR INFILE OR OUTFILE'
         BRAS  1,*+(WTO#0063_EOT-*+1)/2*2
         DC    AL2(WTO#0063_EOT-*,0),C'REPRO NO CATALOG FOUND FOR INFILX
               E OR OUTFILE'
WTO#0063_EOT     EQU *
         SVC   35
*MEXIT #=    63 LV= 1 WTO
*MCALL #=    64 LV= 1                      SUBEXIT RC=16
         LA    15,16
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=    64 LV= 1 SUBEXIT
*MCALL #=    65 LV= 1                ENDIF 
*MCALL #=    66 LV= 2          ZSTREQU 
*MEXIT #=    66 LV= 2 ZSTREQU
#@IF_8_E                         DS 0H
*MEXIT #=    65 LV= 1 ENDIF
*MCALL #=    67 LV= 1          ELSE 
*MCALL #=    68 LV= 2          ZSTREQU 
*MEXIT #=    68 LV= 2 ZSTREQU
        B      #@IF_7_E
#@IF_7_2                                                 DS 0H
*MEXIT #=    67 LV= 1 ELSE
               MVI   OUTFILET,C'Q'
*MCALL #=    69 LV= 1                IF    (LTR,R15,EQ,R15)
*MCALL #=    70 LV= 2          ZSTREQU 
*MEXIT #=    70 LV= 2 ZSTREQU
         LTR   R15,R15
         BC    15-EQ,#@IF_9_2
*MEXIT #=    69 LV= 1 IF
*MCALL #=    71 LV= 1                      PM    INIT_BUILD_AIX
         MVC   INIT_BUILD_AIX-2(2),*+10
         B     INIT_BUILD_AIX
         DC    S(*+2)
*MEXIT #=    71 LV= 1 PM
*MCALL #=    72 LV= 1                ELSE 
*MCALL #=    73 LV= 2          ZSTREQU 
*MEXIT #=    73 LV= 2 ZSTREQU
        B      #@IF_9_E
#@IF_9_2                                                 DS 0H
*MEXIT #=    72 LV= 1 ELSE
*MCALL #=    74 LV= 1                      PM    INIT_UNLOAD
         MVC   INIT_UNLOAD-2(2),*+10
         B     INIT_UNLOAD
         DC    S(*+2)
*MEXIT #=    74 LV= 1 PM
*MCALL #=    75 LV= 1                ENDIF 
*MCALL #=    76 LV= 2          ZSTREQU 
*MEXIT #=    76 LV= 2 ZSTREQU
#@IF_9_E                         DS 0H
*MEXIT #=    75 LV= 1 ENDIF
*MCALL #=    77 LV= 1          ENDIF 
*MCALL #=    78 LV= 2          ZSTREQU 
*MEXIT #=    78 LV= 2 ZSTREQU
#@IF_7_E                         DS 0H
*MEXIT #=    77 LV= 1 ENDIF
*MCALL #=    79 LV= 1          SNAP  ID=1,TEXT='REPRO FILES OPENED',PDAX
               TA=DCB
         IILL  0,1                  RPI158
         IILH 0,2048               RPI158
         LA    1,=CL60'REPRO FILES OPENED'
         SVC   51  SNAP DUMP R0=FLAGS,ID,R1=A(TEXT),R14-15=A(LOW,HIGH)
*MEXIT #=    79 LV= 1 SNAP
*MCALL #=    80 LV= 1          PEXIT 
         B     INIT-4
*MEXIT #=    80 LV= 1 PEXIT
*
* ATTEMPT TO LOAD VSAM CATALOG FROM FILE SPEC AT R1
* AND SET R15 0 IF SUCCESSFUL
*
*MCALL #=    81 LV= 1 LOAD_CATALOG PENTRY 
         DC    0H'0',CL8'LOAD_CATALOG'
         B     *+4
LOAD_CATALOG EQU *
*MEXIT #=    81 LV= 1 PENTRY
         LR    R8,R1   R8=A(FILE SPEC)
         ST    R8,VCATFSA
*MCALL #=    82 LV= 1          IF    (TRT,0(256,R8),NE,FIND_PER_BRK_NULX
               L) FIND .|[|NULL
*MCALL #=    83 LV= 2          ZSTREQU 
*MEXIT #=    83 LV= 2 ZSTREQU
         TRT   0(256,R8),FIND_PER_BRK_NULL
         BC    15-NE,#@IF_10_2
*MEXIT #=    82 LV= 1 IF
               STC  R2,PER_BRK_CHAR
               ST   R1,PER_BRK_ADDR
               LR   R15,R1
               SR   R15,R8
               BCTR R15,0
               EX   R15,VCATMVC         MOVE FILE SPEC WO PER/BRK
               LA   R15,VCATDSN+1(R15)
               MVC  0(5,R15),VCAT390    APPEND .390
*MCALL #=    84 LV= 1                LOAD DSNAME=VCATDSN      TRY LOADIX
               NG CATALOG
         SR    0,0
         LA    15,VCATDSN
         SVC   8 LOAD R0=A(NAME) R15=DDNAME/DSNAME ADDR OR 0
*MEXIT #=    84 LV= 1 LOAD
*MCALL #=    85 LV= 1                IF   (LTR,R15,EQ,R15)
*MCALL #=    86 LV= 2          ZSTREQU 
*MEXIT #=    86 LV= 2 ZSTREQU
         LTR   R15,R15
         BC    15-EQ,#@IF_11_2
*MEXIT #=    85 LV= 1 IF
                    LR   R1,R0
                    ST   R1,VCDT_ADDR
                    USING IHAVCDT,R1
*MCALL #=    87 LV= 1                     IF   (CLC,VCDTID,EQ,=C'VCDT')X
                 RPI 696
*MCALL #=    88 LV= 2          ZSTREQU 
*MEXIT #=    88 LV= 2 ZSTREQU
         CLC   VCDTID,=C'VCDT'
         BC    15-EQ,#@IF_12_2
*MEXIT #=    87 LV= 1 IF
                         SR   R15,R15 ASSUME VSAM IF CAT LOADED
*MCALL #=    89 LV= 1                     ELSE 
*MCALL #=    90 LV= 2          ZSTREQU 
*MEXIT #=    90 LV= 2 ZSTREQU
        B      #@IF_12_E
#@IF_12_2                                                DS 0H
*MEXIT #=    89 LV= 1 ELSE
*MCALL #=    91 LV= 1                          PM   CHECK_QSAM_OVERRIDE
         MVC   CHECK_QSAM_OVERRIDE-2(2),*+10
         B     CHECK_QSAM_OVERRIDE
         DC    S(*+2)
*MEXIT #=    91 LV= 1 PM
*MCALL #=    92 LV= 1                          DELETE DSNAME=VCATDSN
*MCALL #=    93 LV= 2         ZDELETE DE=,EP=,EPLOC=,DDNAME=,DSNAME=VCAX
               TDSN,MF=I,RELATED=
         SR    0,0
         LA    15,VCATDSN
         SVC   9 DELETE R0=A(NAME) R15=DSNAME/DDNAME ADDR OR 0
*MEXIT #=    93 LV= 2 ZDELETE
*MEXIT #=    92 LV= 1 DELETE
                         LA   R15,4 CATALOG NOT FOUND SO ASSUME QSAM
*MCALL #=    94 LV= 1                     ENDIF 
*MCALL #=    95 LV= 2          ZSTREQU 
*MEXIT #=    95 LV= 2 ZSTREQU
#@IF_12_E                        DS 0H
*MEXIT #=    94 LV= 1 ENDIF
*MCALL #=    96 LV= 1                ELSE 
*MCALL #=    97 LV= 2          ZSTREQU 
*MEXIT #=    97 LV= 2 ZSTREQU
        B      #@IF_11_E
#@IF_11_2                                                DS 0H
*MEXIT #=    96 LV= 1 ELSE
*MCALL #=    98 LV= 1                     PM   CHECK_QSAM_OVERRIDE
         MVC   CHECK_QSAM_OVERRIDE-2(2),*+10
         B     CHECK_QSAM_OVERRIDE
         DC    S(*+2)
*MEXIT #=    98 LV= 1 PM
                    LA   R15,4  NOT LOADED SO ASSUME QSAM
*MCALL #=    99 LV= 1                ENDIF 
*MCALL #=   100 LV= 2          ZSTREQU 
*MEXIT #=   100 LV= 2 ZSTREQU
#@IF_11_E                        DS 0H
*MEXIT #=    99 LV= 1 ENDIF
*MCALL #=   101 LV= 1          ELSE 
*MCALL #=   102 LV= 2          ZSTREQU 
*MEXIT #=   102 LV= 2 ZSTREQU
        B      #@IF_10_E
#@IF_10_2                                                DS 0H
*MEXIT #=   101 LV= 1 ELSE
               MVI  R15,4   ASSUME QSAM IF NO PERIOD/NULL
*MCALL #=   103 LV= 1          ENDIF 
*MCALL #=   104 LV= 2          ZSTREQU 
*MEXIT #=   104 LV= 2 ZSTREQU
#@IF_10_E                        DS 0H
*MEXIT #=   103 LV= 1 ENDIF
*MCALL #=   105 LV= 1          PEXIT 
         B     LOAD_CATALOG-4
*MEXIT #=   105 LV= 1 PEXIT
         DROP  R1
VCATMVC  MVC   VCATDSN(0),0(R8)  MOVE VSAM CATALOG DSN
*
* CHECK QSAM OVERRIDE
*
*MCALL #=   106 LV= 1 CHECK_QSAM_OVERRIDE PENTRY 
         DC    0H'0',CL8'CHECK_QSAM_OVERRIDE'
         B     *+4
CHECK_QSAM_OVERRIDE EQU *
*MEXIT #=   106 LV= 1 PENTRY
         LR   R9,R8  SAVE QSAM DSNAME
*MCALL #=   107 LV= 1          IF   (CLI,PER_BRK_CHAR,EQ,C'.')
*MCALL #=   108 LV= 2          ZSTREQU 
*MEXIT #=   108 LV= 2 ZSTREQU
         CLI   PER_BRK_CHAR,C'.'
         BC    15-EQ,#@IF_13_2
*MEXIT #=   107 LV= 1 IF
              L  R1,PER_BRK_ADDR
*MCALL #=   109 LV= 1               IF (TRT,1(255,R1),NE,FIND_PER_BRK_NX
               ULL)
*MCALL #=   110 LV= 2          ZSTREQU 
*MEXIT #=   110 LV= 2 ZSTREQU
         TRT   1(255,R1),FIND_PER_BRK_NULL
         BC    15-NE,#@IF_14_2
*MEXIT #=   109 LV= 1 IF
*MCALL #=   111 LV= 1                  IF (CLI,0(R1),EQ,C'[')
*MCALL #=   112 LV= 2          ZSTREQU 
*MEXIT #=   112 LV= 2 ZSTREQU
         CLI   0(R1),C'['
         BC    15-EQ,#@IF_15_2
*MEXIT #=   111 LV= 1 IF
                    ST R1,PER_BRK_ADDR
*MCALL #=   113 LV= 1                     PM SET_QFILE_RECFM
         MVC   SET_QFILE_RECFM-2(2),*+10
         B     SET_QFILE_RECFM
         DC    S(*+2)
*MEXIT #=   113 LV= 1 PM
*MCALL #=   114 LV= 1                  ENDIF 
*MCALL #=   115 LV= 2          ZSTREQU 
*MEXIT #=   115 LV= 2 ZSTREQU
#@IF_15_2                                                DS 0H
*MEXIT #=   114 LV= 1 ENDIF
*MCALL #=   116 LV= 1               ENDIF 
*MCALL #=   117 LV= 2          ZSTREQU 
*MEXIT #=   117 LV= 2 ZSTREQU
#@IF_14_2                                                DS 0H
*MEXIT #=   116 LV= 1 ENDIF
*MCALL #=   118 LV= 1          ELSE 
*MCALL #=   119 LV= 2          ZSTREQU 
*MEXIT #=   119 LV= 2 ZSTREQU
        B      #@IF_13_E
#@IF_13_2                                                DS 0H
*MEXIT #=   118 LV= 1 ELSE
*MCALL #=   120 LV= 1               IF   (CLI,PER_BRK_CHAR,EQ,C'[')
*MCALL #=   121 LV= 2          ZSTREQU 
*MEXIT #=   121 LV= 2 ZSTREQU
         CLI   PER_BRK_CHAR,C'['
         BC    15-EQ,#@IF_16_2
*MEXIT #=   120 LV= 1 IF
*MCALL #=   122 LV= 1                     PM SET_QFILE_RECFM
         MVC   SET_QFILE_RECFM-2(2),*+10
         B     SET_QFILE_RECFM
         DC    S(*+2)
*MEXIT #=   122 LV= 1 PM
*MCALL #=   123 LV= 1               ENDIF 
*MCALL #=   124 LV= 2          ZSTREQU 
*MEXIT #=   124 LV= 2 ZSTREQU
#@IF_16_2                                                DS 0H
*MEXIT #=   123 LV= 1 ENDIF
*MCALL #=   125 LV= 1          ENDIF 
*MCALL #=   126 LV= 2          ZSTREQU 
*MEXIT #=   126 LV= 2 ZSTREQU
#@IF_13_E                        DS 0H
*MEXIT #=   125 LV= 1 ENDIF
*MCALL #=   127 LV= 1          PEXIT 
         B     CHECK_QSAM_OVERRIDE-4
*MEXIT #=   127 LV= 1 PEXIT
*
* SET QFILE RECFM OVERRIDE
*
*MCALL #=   128 LV= 1 SET_QFILE_RECFM PENTRY 
         DC    0H'0',CL8'SET_QFILE_RECFM'
         B     *+4
SET_QFILE_RECFM EQU *
*MEXIT #=   128 LV= 1 PENTRY
         L     R1,PER_BRK_ADDR
         MVI   0(R1),X'00' TERMAINATE QSAM DSNAME FOR OPEN
*MCALL #=   129 LV= 1          IF  (CLC,1(6,R1),NE,=C'RECFM=')
*MCALL #=   130 LV= 2          ZSTREQU 
*MEXIT #=   130 LV= 2 ZSTREQU
         CLC   1(6,R1),=C'RECFM='
         BC    15-NE,#@IF_17_2
*MEXIT #=   129 LV= 1 IF
*MCALL #=   131 LV= 1              WTO 'REPRO INVALID QSAM FILE OVERRIDX
               E [RECFM=FT|FB|VT|VB]'
         BRAS  1,*+(WTO#0131_EOT-*+1)/2*2
         DC    AL2(WTO#0131_EOT-*,0),C'REPRO INVALID QSAM FILE OVERRIDEX
                [RECFM=FT|FB|VT|VB]'
WTO#0131_EOT     EQU *
         SVC   35
*MEXIT #=   131 LV= 1 WTO
*MCALL #=   132 LV= 1          ELSEIF (CLC,7(2,R1),EQ,=C'VB')
*MCALL #=   133 LV= 2          ZSTREQU 
*MEXIT #=   133 LV= 2 ZSTREQU
         B     #@IF_17_E
#@IF_17_2                                                DS 0H
         CLC   7(2,R1),=C'VB'
         BC    15-EQ,#@IF_17_4
*MEXIT #=   132 LV= 1 ELSEIF
             MVC RECFM_OVF,=C'VB'
             MVI VL32,FALSE
*MCALL #=   134 LV= 1          ELSEIF (CLC,7(2,R1),EQ,=C'VT')
*MCALL #=   135 LV= 2          ZSTREQU 
*MEXIT #=   135 LV= 2 ZSTREQU
         B     #@IF_17_E
#@IF_17_4                                                DS 0H
         CLC   7(2,R1),=C'VT'
         BC    15-EQ,#@IF_17_6
*MEXIT #=   134 LV= 1 ELSEIF
             MVC RECFM_OVF,=C'VT'
             MVI VL32,FALSE
*MCALL #=   136 LV= 1          ELSEIF (CLC,7(2,R1),EQ,=C'FB')
*MCALL #=   137 LV= 2          ZSTREQU 
*MEXIT #=   137 LV= 2 ZSTREQU
         B     #@IF_17_E
#@IF_17_6                                                DS 0H
         CLC   7(2,R1),=C'FB'
         BC    15-EQ,#@IF_17_8
*MEXIT #=   136 LV= 1 ELSEIF
             MVC RECFM_OVF,=C'FB'
*MCALL #=   138 LV= 1          ELSEIF (CLC,7(2,R1),EQ,=C'FT')
*MCALL #=   139 LV= 2          ZSTREQU 
*MEXIT #=   139 LV= 2 ZSTREQU
         B     #@IF_17_E
#@IF_17_8                                                DS 0H
         CLC   7(2,R1),=C'FT'
         BC    15-EQ,#@IF_17_10
*MEXIT #=   138 LV= 1 ELSEIF
             MVC RECFM_OVF,=C'FT'
*MCALL #=   140 LV= 1          ELSEIF (CLC,7(1,R1),EQ,=C'F')
*MCALL #=   141 LV= 2          ZSTREQU 
*MEXIT #=   141 LV= 2 ZSTREQU
         B     #@IF_17_E
#@IF_17_10                                               DS 0H
         CLC   7(1,R1),=C'F'
         BC    15-EQ,#@IF_17_12
*MEXIT #=   140 LV= 1 ELSEIF
             MVC RECFM_OVF,=C'F '
*MCALL #=   142 LV= 1          ELSEIF (CLC,7(1,R1),EQ,=C'V')
*MCALL #=   143 LV= 2          ZSTREQU 
*MEXIT #=   143 LV= 2 ZSTREQU
         B     #@IF_17_E
#@IF_17_12                                               DS 0H
         CLC   7(1,R1),=C'V'
         BC    15-EQ,#@IF_17_14
*MEXIT #=   142 LV= 1 ELSEIF
             MVC RECFM_OVF,=C'V '
             MVI VL32,FALSE
*MCALL #=   144 LV= 1          ELSE 
*MCALL #=   145 LV= 2          ZSTREQU 
*MEXIT #=   145 LV= 2 ZSTREQU
        B      #@IF_17_E
#@IF_17_14                                               DS 0H
*MEXIT #=   144 LV= 1 ELSE
*MCALL #=   146 LV= 1              WTO 'REPRO INVALID QSAM OVERRIDE [REX
               CFM=FT|FB|VT|VB]'
         BRAS  1,*+(WTO#0146_EOT-*+1)/2*2
         DC    AL2(WTO#0146_EOT-*,0),C'REPRO INVALID QSAM OVERRIDE [RECX
               FM=FT|FB|VT|VB]'
WTO#0146_EOT     EQU *
         SVC   35
*MEXIT #=   146 LV= 1 WTO
*MCALL #=   147 LV= 1              SUBEXIT RC=16
         LA    15,16
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=   147 LV= 1 SUBEXIT
*MCALL #=   148 LV= 1          ENDIF 
*MCALL #=   149 LV= 2          ZSTREQU 
*MEXIT #=   149 LV= 2 ZSTREQU
#@IF_17_E                        DS 0H
*MEXIT #=   148 LV= 1 ENDIF
*MCALL #=   150 LV= 1          PEXIT 
         B     SET_QFILE_RECFM-4
*MEXIT #=   150 LV= 1 PEXIT
*
* LOAD - OPEN INFILE QSAM AND OUTFILE VSAM
*
*MCALL #=   151 LV= 1 INIT_LOAD PENTRY 
         DC    0H'0',CL8'INIT_LOAD'
         B     *+4
INIT_LOAD EQU  *
*MEXIT #=   151 LV= 1 PENTRY
*MCALL #=   152 LV= 1          WTO   'REPRO LOADING VSAM FROM QSAM INFIX
               LE'
         BRAS  1,*+(WTO#0152_EOT-*+1)/2*2
         DC    AL2(WTO#0152_EOT-*,0),C'REPRO LOADING VSAM FROM QSAM INFX
               ILE'
WTO#0152_EOT     EQU *
         SVC   35
*MEXIT #=   152 LV= 1 WTO
*MCALL #=   153 LV= 1          PM    CHECK_VSAM_OVERRIDE
         MVC   CHECK_VSAM_OVERRIDE-2(2),*+10
         B     CHECK_VSAM_OVERRIDE
         DC    S(*+2)
*MEXIT #=   153 LV= 1 PM
*MCALL #=   154 LV= 1          IF    (CLI,MOD,EQ,TRUE)
*MCALL #=   155 LV= 2          ZSTREQU 
*MEXIT #=   155 LV= 2 ZSTREQU
         CLI   MOD,TRUE
         BC    15-EQ,#@IF_18_2
*MEXIT #=   154 LV= 1 IF
*MCALL #=   156 LV= 1                WTO 'REPRO OPENING VSAM OUTFILE FOX
               R MOD VS RELOAD'
         BRAS  1,*+(WTO#0156_EOT-*+1)/2*2
         DC    AL2(WTO#0156_EOT-*,0),C'REPRO OPENING VSAM OUTFILE FOR MX
               OD VS RELOAD'
WTO#0156_EOT     EQU *
         SVC   35
*MEXIT #=   156 LV= 1 WTO
*MCALL #=   157 LV= 1                OPEN  (OUTFILEV,(UPDATE))
*MCALL #=   158 LV= 2          ZOPEN (OUTFILEV,(UPDATE)),MF=I,MODE=31,TX
               YPE=
                       LA     1,OUTFILEV
                       LA  0,DCBOFLGS_RW   READ AND WRITE
                   SVC   19 OPEN R0=TYPE,R1=DCB/ACB
*MCALL #=   159 LV= 3          DCBD 
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
REPRO           CSECT                              RPI 591
*MEXIT #=   159 LV= 3 DCBD
*MEXIT #=   158 LV= 2 ZOPEN
*MEXIT #=   157 LV= 1 OPEN
*MCALL #=   160 LV= 1          ELSE 
*MCALL #=   161 LV= 2          ZSTREQU 
*MEXIT #=   161 LV= 2 ZSTREQU
        B      #@IF_18_E
#@IF_18_2                                                DS 0H
*MEXIT #=   160 LV= 1 ELSE
*MCALL #=   162 LV= 1                WTO 'REPRO OPENING VSAM OUTFILE FOX
               R RELOAD VS MOD'
         BRAS  1,*+(WTO#0162_EOT-*+1)/2*2
         DC    AL2(WTO#0162_EOT-*,0),C'REPRO OPENING VSAM OUTFILE FOR RX
               ELOAD VS MOD'
WTO#0162_EOT     EQU *
         SVC   35
*MEXIT #=   162 LV= 1 WTO
*MCALL #=   163 LV= 1                OPEN  (OUTFILEV,(OUTPUT))
*MCALL #=   164 LV= 2          ZOPEN (OUTFILEV,(OUTPUT)),MF=I,MODE=31,TX
               YPE=
                       LA     1,OUTFILEV
                       LA  0,DCBOFLGS_PM   WRITE ONLY
                   SVC   19 OPEN R0=TYPE,R1=DCB/ACB
*MCALL #=   165 LV= 3          DCBD 
*MEXIT #=   165 LV= 3 DCBD
*MEXIT #=   164 LV= 2 ZOPEN
*MEXIT #=   163 LV= 1 OPEN
*MCALL #=   166 LV= 1          ENDIF 
*MCALL #=   167 LV= 2          ZSTREQU 
*MEXIT #=   167 LV= 2 ZSTREQU
#@IF_18_E                        DS 0H
*MEXIT #=   166 LV= 1 ENDIF
*MCALL #=   168 LV= 1          IF    (LTR,R15,NE,R15)
*MCALL #=   169 LV= 2          ZSTREQU 
*MEXIT #=   169 LV= 2 ZSTREQU
         LTR   R15,R15
         BC    15-NE,#@IF_19_2
*MEXIT #=   168 LV= 1 IF
*MCALL #=   170 LV= 1                WTO 'REPRO OPEN FOR OUTFILE VSAM CX
               ATALOG ENTRY FAILED'
         BRAS  1,*+(WTO#0170_EOT-*+1)/2*2
         DC    AL2(WTO#0170_EOT-*,0),C'REPRO OPEN FOR OUTFILE VSAM CATAX
               LOG ENTRY FAILED'
WTO#0170_EOT     EQU *
         SVC   35
*MEXIT #=   170 LV= 1 WTO
*MCALL #=   171 LV= 1                SUBEXIT RC=16
         LA    15,16
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=   171 LV= 1 SUBEXIT
*MCALL #=   172 LV= 1          ENDIF 
*MCALL #=   173 LV= 2          ZSTREQU 
*MEXIT #=   173 LV= 2 ZSTREQU
#@IF_19_2                                                DS 0H
*MEXIT #=   172 LV= 1 ENDIF
         LA  R5,INFILEQ
         LA  R6,OUTFILEV
*MCALL #=   174 LV= 1          PM  INIT_QSAM
         MVC   INIT_QSAM-2(2),*+10
         B     INIT_QSAM
         DC    S(*+2)
*MEXIT #=   174 LV= 1 PM
*MCALL #=   175 LV= 1          OPEN (INFILEQ,(INPUT))
*MCALL #=   176 LV= 2          ZOPEN (INFILEQ,(INPUT)),MF=I,MODE=31,TYPX
               E=
                       LA     1,INFILEQ
                       LA  0,DCBOFLGS_GM   READ ONLY
                   SVC   19 OPEN R0=TYPE,R1=DCB/ACB
*MCALL #=   177 LV= 3          DCBD 
*MEXIT #=   177 LV= 3 DCBD
*MEXIT #=   176 LV= 2 ZOPEN
*MEXIT #=   175 LV= 1 OPEN
*MCALL #=   178 LV= 1          IF   (LTR,R15,NE,R15)
*MCALL #=   179 LV= 2          ZSTREQU 
*MEXIT #=   179 LV= 2 ZSTREQU
         LTR   R15,R15
         BC    15-NE,#@IF_20_2
*MEXIT #=   178 LV= 1 IF
*MCALL #=   180 LV= 1               WTO 'REPRO OPEN FOR INFILE QSAM FILX
               E FAILED'
         BRAS  1,*+(WTO#0180_EOT-*+1)/2*2
         DC    AL2(WTO#0180_EOT-*,0),C'REPRO OPEN FOR INFILE QSAM FILE X
               FAILED'
WTO#0180_EOT     EQU *
         SVC   35
*MEXIT #=   180 LV= 1 WTO
*MCALL #=   181 LV= 1               SUBEXIT RC=16
         LA    15,16
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=   181 LV= 1 SUBEXIT
*MCALL #=   182 LV= 1          ENDIF 
*MCALL #=   183 LV= 2          ZSTREQU 
*MEXIT #=   183 LV= 2 ZSTREQU
#@IF_20_2                                                DS 0H
*MEXIT #=   182 LV= 1 ENDIF
         STG  R0,INFILEQL
         MVC  INFILEQ+DCBSYNAD-IHADCB(4),=A(ERR11)
*MCALL #=   184 LV= 1          PEXIT 
         B     INIT_LOAD-4
*MEXIT #=   184 LV= 1 PEXIT
*
* UNLOAD - OPEN INFILE VSAM AND OUTFILE QSAM
*
*MCALL #=   185 LV= 1 INIT_UNLOAD PENTRY 
         DC    0H'0',CL8'INIT_UNLOAD'
         B     *+4
INIT_UNLOAD EQU *
*MEXIT #=   185 LV= 1 PENTRY
*MCALL #=   186 LV= 1          WTO   'REPRO UNLOADING VSAM INFILE TO QSX
               AM OUTFILE'
         BRAS  1,*+(WTO#0186_EOT-*+1)/2*2
         DC    AL2(WTO#0186_EOT-*,0),C'REPRO UNLOADING VSAM INFILE TO QX
               SAM OUTFILE'
WTO#0186_EOT     EQU *
         SVC   35
*MEXIT #=   186 LV= 1 WTO
*MCALL #=   187 LV= 1          OPEN  (INFILEV,(INPUT))
*MCALL #=   188 LV= 2          ZOPEN (INFILEV,(INPUT)),MF=I,MODE=31,TYPX
               E=
                       LA     1,INFILEV
                       LA  0,DCBOFLGS_GM   READ ONLY
                   SVC   19 OPEN R0=TYPE,R1=DCB/ACB
*MCALL #=   189 LV= 3          DCBD 
*MEXIT #=   189 LV= 3 DCBD
*MEXIT #=   188 LV= 2 ZOPEN
*MEXIT #=   187 LV= 1 OPEN
*MCALL #=   190 LV= 1          IF    (LTR,R15,NE,R15)
*MCALL #=   191 LV= 2          ZSTREQU 
*MEXIT #=   191 LV= 2 ZSTREQU
         LTR   R15,R15
         BC    15-NE,#@IF_21_2
*MEXIT #=   190 LV= 1 IF
*MCALL #=   192 LV= 1                WTO 'REPRO OPEN FOR INFILE VSAM CAX
               TALOG ENTRY FAILED'
         BRAS  1,*+(WTO#0192_EOT-*+1)/2*2
         DC    AL2(WTO#0192_EOT-*,0),C'REPRO OPEN FOR INFILE VSAM CATALX
               OG ENTRY FAILED'
WTO#0192_EOT     EQU *
         SVC   35
*MEXIT #=   192 LV= 1 WTO
*MCALL #=   193 LV= 1                SUBEXIT RC=16
         LA    15,16
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=   193 LV= 1 SUBEXIT
*MCALL #=   194 LV= 1          ENDIF 
*MCALL #=   195 LV= 2          ZSTREQU 
*MEXIT #=   195 LV= 2 ZSTREQU
#@IF_21_2                                                DS 0H
*MEXIT #=   194 LV= 1 ENDIF
         LA  R5,OUTFILEQ
         LA  R6,INFILEV
*MCALL #=   196 LV= 1          PM  INIT_QSAM
         MVC   INIT_QSAM-2(2),*+10
         B     INIT_QSAM
         DC    S(*+2)
*MEXIT #=   196 LV= 1 PM
*MCALL #=   197 LV= 1          OPEN (OUTFILEQ,(OUTPUT))
*MCALL #=   198 LV= 2          ZOPEN (OUTFILEQ,(OUTPUT)),MF=I,MODE=31,TX
               YPE=
                       LA     1,OUTFILEQ
                       LA  0,DCBOFLGS_PM   WRITE ONLY
                   SVC   19 OPEN R0=TYPE,R1=DCB/ACB
*MCALL #=   199 LV= 3          DCBD 
*MEXIT #=   199 LV= 3 DCBD
*MEXIT #=   198 LV= 2 ZOPEN
*MEXIT #=   197 LV= 1 OPEN
*MCALL #=   200 LV= 1          IF   (LTR,R15,NE,R15)
*MCALL #=   201 LV= 2          ZSTREQU 
*MEXIT #=   201 LV= 2 ZSTREQU
         LTR   R15,R15
         BC    15-NE,#@IF_22_2
*MEXIT #=   200 LV= 1 IF
*MCALL #=   202 LV= 1               WTO 'REPRO OPEN FOR OUTFILE QSAM FIX
               LE FAILED'
         BRAS  1,*+(WTO#0202_EOT-*+1)/2*2
         DC    AL2(WTO#0202_EOT-*,0),C'REPRO OPEN FOR OUTFILE QSAM FILEX
                FAILED'
WTO#0202_EOT     EQU *
         SVC   35
*MEXIT #=   202 LV= 1 WTO
*MCALL #=   203 LV= 1               SUBEXIT RC=16
         LA    15,16
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=   203 LV= 1 SUBEXIT
*MCALL #=   204 LV= 1          ENDIF 
*MCALL #=   205 LV= 2          ZSTREQU 
*MEXIT #=   205 LV= 2 ZSTREQU
#@IF_22_2                                                DS 0H
*MEXIT #=   204 LV= 1 ENDIF
         MVC  OUTFILEQ+DCBSYNAD-IHADCB(4),=A(ERR13)
*MCALL #=   206 LV= 1          PEXIT 
         B     INIT_UNLOAD-4
*MEXIT #=   206 LV= 1 PEXIT
*
* BUILD_AIX - OPEN INFILE VSAM AND OUTFILE QSAM
*
*MCALL #=   207 LV= 1 INIT_BUILD_AIX PENTRY 
         DC    0H'0',CL8'INIT_BUILD_AIX'
         B     *+4
INIT_BUILD_AIX EQU *
*MEXIT #=   207 LV= 1 PENTRY
         L     R1,PER_BRK_ADDR
         AHI   R1,1
         LA    R2,VAIX_NAME
*MCALL #=   208 LV= 1          DO    WHILE=(CLI,0(R1),GT,C' ')
*MCALL #=   209 LV= 2          ZSTREQU 
*MEXIT #=   209 LV= 2 ZSTREQU
#@DO_2_T                         DS 0H
*MCALL #=   210 LV= 2          IF CLI,0(R1),GT,C' '
*MCALL #=   211 LV= 3          ZSTREQU 
*MEXIT #=   211 LV= 3 ZSTREQU
         CLI   0(R1),C' '
         BC    15-GT,#@IF_23_2
*MEXIT #=   210 LV= 2 IF
               B   #@DO_2_1
*MCALL #=   212 LV= 2          ENDIF 
*MCALL #=   213 LV= 3          ZSTREQU 
*MEXIT #=   213 LV= 3 ZSTREQU
#@IF_23_2                                                DS 0H
*MEXIT #=   212 LV= 2 ENDIF
         B     #@DO_2_E
#@DO_2_1                         DS 0H
*MEXIT #=   208 LV= 1 DO
               MVC  0(1,R2),0(R1)
               AHI  R1,1
               AHI  R2,1
*MCALL #=   214 LV= 1          ENDDO 
*MCALL #=   215 LV= 2          DO    END
*MCALL #=   216 LV= 3          ZSTREQU 
*MEXIT #=   216 LV= 3 ZSTREQU
         B     #@DO_2_T
#@DO_2_E                         DS 0H
*MEXIT #=   215 LV= 2 DO
*MEXIT #=   214 LV= 1 ENDDO
         L     R1,VCDT_ADDR
         USING IHAVCDT,R1
         L     R2,VCDTAIXA
         USING IHAVAIX,R2
         L     R3,VCDTAIXT
         SR    R4,R4
*MCALL #=   217 LV= 1          DO    WHILE=(LTR,R3,NZ,R3)
*MCALL #=   218 LV= 2          ZSTREQU 
*MEXIT #=   218 LV= 2 ZSTREQU
#@DO_3_T                         DS 0H
*MCALL #=   219 LV= 2          IF LTR,R3,NZ,R3
*MCALL #=   220 LV= 3          ZSTREQU 
*MEXIT #=   220 LV= 3 ZSTREQU
         LTR   R3,R3
         BC    15-NZ,#@IF_24_2
*MEXIT #=   219 LV= 2 IF
               B   #@DO_3_1
*MCALL #=   221 LV= 2          ENDIF 
*MCALL #=   222 LV= 3          ZSTREQU 
*MEXIT #=   222 LV= 3 ZSTREQU
#@IF_24_2                                                DS 0H
*MEXIT #=   221 LV= 2 ENDIF
         B     #@DO_3_E
#@DO_3_1                         DS 0H
*MEXIT #=   217 LV= 1 DO
*MCALL #=   223 LV= 1                IF (CLC,VAIX_NAME,EQ,VAIXNAME)
*MCALL #=   224 LV= 2          ZSTREQU 
*MEXIT #=   224 LV= 2 ZSTREQU
         CLC   VAIX_NAME,VAIXNAME
         BC    15-EQ,#@IF_25_2
*MEXIT #=   223 LV= 1 IF
                  LR  R4,R2        SET R4 TO AIX ENTRY IF FOUND
*MCALL #=   225 LV= 1                ENDIF 
*MCALL #=   226 LV= 2          ZSTREQU 
*MEXIT #=   226 LV= 2 ZSTREQU
#@IF_25_2                                                DS 0H
*MEXIT #=   225 LV= 1 ENDIF
               AHI R2,VAIXLEN
               BCTR R3,0
*MCALL #=   227 LV= 1          ENDDO 
*MCALL #=   228 LV= 2          DO    END
*MCALL #=   229 LV= 3          ZSTREQU 
*MEXIT #=   229 LV= 3 ZSTREQU
         B     #@DO_3_T
#@DO_3_E                         DS 0H
*MEXIT #=   228 LV= 2 DO
*MEXIT #=   227 LV= 1 ENDDO
*MCALL #=   230 LV= 1          IF    (LTR,R4,Z,R4)
*MCALL #=   231 LV= 2          ZSTREQU 
*MEXIT #=   231 LV= 2 ZSTREQU
         LTR   R4,R4
         BC    15-Z,#@IF_26_2
*MEXIT #=   230 LV= 1 IF
*MCALL #=   232 LV= 1                WTO 'VSAM ALTERNATE INDEX NOT FOUNX
               D IN CATALOG'
         BRAS  1,*+(WTO#0232_EOT-*+1)/2*2
         DC    AL2(WTO#0232_EOT-*,0),C'VSAM ALTERNATE INDEX NOT FOUND IX
               N CATALOG'
WTO#0232_EOT     EQU *
         SVC   35
*MEXIT #=   232 LV= 1 WTO
*MCALL #=   233 LV= 1                SUBEXIT RC=16
         LA    15,16
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=   233 LV= 1 SUBEXIT
*MCALL #=   234 LV= 1          ENDIF 
*MCALL #=   235 LV= 2          ZSTREQU 
*MEXIT #=   235 LV= 2 ZSTREQU
#@IF_26_2                                                DS 0H
*MEXIT #=   234 LV= 1 ENDIF
         DROP  R2
         ST    R4,VAIX_ADDR  SAVE VAIX FOR USE IN BUILDING RECORDS
         USING IHAVAIX,R4
         LA    R1,OUTFILEQ
         USING IHADCB,R1
         L     R0,VAIXKLEN   RPI 865 WAS LH
         ST    R0,VAIX_KLEN
         AHI   R0,8
         STH   R0,DCBLRECL
         MVI   BUILDAIX,TRUE
*MCALL #=   236 LV= 1          WTO   'REPRO BUILD AIX FROM VSAM INFILE X
               TO QSAM OUTFILE'
         BRAS  1,*+(WTO#0236_EOT-*+1)/2*2
         DC    AL2(WTO#0236_EOT-*,0),C'REPRO BUILD AIX FROM VSAM INFILEX
                TO QSAM OUTFILE'
WTO#0236_EOT     EQU *
         SVC   35
*MEXIT #=   236 LV= 1 WTO
         DROP  R4,R1
*MCALL #=   237 LV= 1          OPEN  (INFILEV,(INPUT))
*MCALL #=   238 LV= 2          ZOPEN (INFILEV,(INPUT)),MF=I,MODE=31,TYPX
               E=
                       LA     1,INFILEV
                       LA  0,DCBOFLGS_GM   READ ONLY
                   SVC   19 OPEN R0=TYPE,R1=DCB/ACB
*MCALL #=   239 LV= 3          DCBD 
*MEXIT #=   239 LV= 3 DCBD
*MEXIT #=   238 LV= 2 ZOPEN
*MEXIT #=   237 LV= 1 OPEN
*MCALL #=   240 LV= 1          IF    (LTR,R15,NE,R15)
*MCALL #=   241 LV= 2          ZSTREQU 
*MEXIT #=   241 LV= 2 ZSTREQU
         LTR   R15,R15
         BC    15-NE,#@IF_27_2
*MEXIT #=   240 LV= 1 IF
*MCALL #=   242 LV= 1                WTO 'REPRO OPEN FOR INFILE VSAM CAX
               TALOG ENTRY FAILED'
         BRAS  1,*+(WTO#0242_EOT-*+1)/2*2
         DC    AL2(WTO#0242_EOT-*,0),C'REPRO OPEN FOR INFILE VSAM CATALX
               OG ENTRY FAILED'
WTO#0242_EOT     EQU *
         SVC   35
*MEXIT #=   242 LV= 1 WTO
*MCALL #=   243 LV= 1                SUBEXIT RC=16
         LA    15,16
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=   243 LV= 1 SUBEXIT
*MCALL #=   244 LV= 1          ENDIF 
*MCALL #=   245 LV= 2          ZSTREQU 
*MEXIT #=   245 LV= 2 ZSTREQU
#@IF_27_2                                                DS 0H
*MEXIT #=   244 LV= 1 ENDIF
         LA  R5,OUTFILEQ
         LA  R6,INFILEV
*MCALL #=   246 LV= 1          PM  INIT_QSAM_AIX
         MVC   INIT_QSAM_AIX-2(2),*+10
         B     INIT_QSAM_AIX
         DC    S(*+2)
*MEXIT #=   246 LV= 1 PM
*MCALL #=   247 LV= 1          OPEN (OUTFILEQ,(OUTPUT))
*MCALL #=   248 LV= 2          ZOPEN (OUTFILEQ,(OUTPUT)),MF=I,MODE=31,TX
               YPE=
                       LA     1,OUTFILEQ
                       LA  0,DCBOFLGS_PM   WRITE ONLY
                   SVC   19 OPEN R0=TYPE,R1=DCB/ACB
*MCALL #=   249 LV= 3          DCBD 
*MEXIT #=   249 LV= 3 DCBD
*MEXIT #=   248 LV= 2 ZOPEN
*MEXIT #=   247 LV= 1 OPEN
*MCALL #=   250 LV= 1          IF   (LTR,R15,NE,R15)
*MCALL #=   251 LV= 2          ZSTREQU 
*MEXIT #=   251 LV= 2 ZSTREQU
         LTR   R15,R15
         BC    15-NE,#@IF_28_2
*MEXIT #=   250 LV= 1 IF
*MCALL #=   252 LV= 1               WTO 'REPRO OPEN FOR OUTFILE QSAM FIX
               LE FAILED'
         BRAS  1,*+(WTO#0252_EOT-*+1)/2*2
         DC    AL2(WTO#0252_EOT-*,0),C'REPRO OPEN FOR OUTFILE QSAM FILEX
                FAILED'
WTO#0252_EOT     EQU *
         SVC   35
*MEXIT #=   252 LV= 1 WTO
*MCALL #=   253 LV= 1               SUBEXIT RC=16
         LA    15,16
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=   253 LV= 1 SUBEXIT
*MCALL #=   254 LV= 1          ENDIF 
*MCALL #=   255 LV= 2          ZSTREQU 
*MEXIT #=   255 LV= 2 ZSTREQU
#@IF_28_2                                                DS 0H
*MEXIT #=   254 LV= 1 ENDIF
         MVC  OUTFILEQ+DCBSYNAD-IHADCB(4),=A(ERR13)
*MCALL #=   256 LV= 1          PEXIT 
         B     INIT_BUILD_AIX-4
*MEXIT #=   256 LV= 1 PEXIT
*
* CHECK_VSAM_OVERRIDE - CHECK FOR [DISP=MOD] FOLLOWING CATALOG.ENTRY
* ON OUTFILE AND USE OPEN (OUTFILE,(UPDATE)) VS (OUTFILE,(OUTPUT))
*
*MCALL #=   257 LV= 1 CHECK_VSAM_OVERRIDE PENTRY 
         DC    0H'0',CL8'CHECK_VSAM_OVERRIDE'
         B     *+4
CHECK_VSAM_OVERRIDE EQU *
*MEXIT #=   257 LV= 1 PENTRY
         MVI   FIND_PER,X'00' TURN OFF PERIOD SEARCH
*MCALL #=   258 LV= 1          IF    (TRT,0(256,R8),NE,FIND_PER_BRK_NULX
               L) FIND BRK/NULL
*MCALL #=   259 LV= 2          ZSTREQU 
*MEXIT #=   259 LV= 2 ZSTREQU
         TRT   0(256,R8),FIND_PER_BRK_NULL
         BC    15-NE,#@IF_29_2
*MEXIT #=   258 LV= 1 IF
*MCALL #=   260 LV= 1                IF (CLI,0(R1),EQ,C'[')
*MCALL #=   261 LV= 2          ZSTREQU 
*MEXIT #=   261 LV= 2 ZSTREQU
         CLI   0(R1),C'['
         BC    15-EQ,#@IF_30_2
*MEXIT #=   260 LV= 1 IF
*MCALL #=   262 LV= 1                   IF (CLC,0(10,R1),EQ,=C'[DISP=MOX
               D]')
*MCALL #=   263 LV= 2          ZSTREQU 
*MEXIT #=   263 LV= 2 ZSTREQU
         CLC   0(10,R1),=C'[DISP=MOD]'
         BC    15-EQ,#@IF_31_2
*MEXIT #=   262 LV= 1 IF
                     MVI MOD,TRUE
*MCALL #=   264 LV= 1                   ENDIF 
*MCALL #=   265 LV= 2          ZSTREQU 
*MEXIT #=   265 LV= 2 ZSTREQU
#@IF_31_2                                                DS 0H
*MEXIT #=   264 LV= 1 ENDIF
                  MVI 0(R1),0 TERMINATE OUTFILE SPEC AT BRK
                  ST  R8,OUTFILEV+ACBDSNAM-IHAACB USE UPDATED DSN
*MCALL #=   266 LV= 1                ENDIF 
*MCALL #=   267 LV= 2          ZSTREQU 
*MEXIT #=   267 LV= 2 ZSTREQU
#@IF_30_2                                                DS 0H
*MEXIT #=   266 LV= 1 ENDIF
*MCALL #=   268 LV= 1          ENDIF 
*MCALL #=   269 LV= 2          ZSTREQU 
*MEXIT #=   269 LV= 2 ZSTREQU
#@IF_29_2                                                DS 0H
*MEXIT #=   268 LV= 1 ENDIF
*MCALL #=   270 LV= 1          PEXIT 
         B     CHECK_VSAM_OVERRIDE-4
*MEXIT #=   270 LV= 1 PEXIT
*
* INIT_QSAM - SET QSAM RECFM, LRECL, BLKSIZE CONSISTENT WITH VSAM
*             AND ANY QSAM [RECFM=XX] OVERRIDE OPTION
*
*   R5 = QSAM DCB
*   R6 = VSAM ACB
*
*MCALL #=   271 LV= 1 INIT_QSAM PENTRY 
         DC    0H'0',CL8'INIT_QSAM'
         B     *+4
INIT_QSAM EQU  *
*MEXIT #=   271 LV= 1 PENTRY
         USING IHADCB,R5  QSAM DCB IN/OUT FILE
         ST    R9,DCBDSNAM SET DSNAME WITHOUT OPTIONAL OVERRIDE
         USING IHAACB,R6  VSAM ACB IN/OUT FILE
         L     R7,ACBVCLRA R15= VCLR BASE CLUSTER    RPI 681
         USING IHAVCLR,R7                            RPI 681
*MCALL #=   272 LV= 1          IF    (TM,VCLRFLG1,O,VCLRRRDS)  RPI 724
*MCALL #=   273 LV= 2          ZSTREQU 
*MEXIT #=   273 LV= 2 ZSTREQU
         TM    VCLRFLG1,VCLRRRDS
         BC    15-O,#@IF_32_2
*MEXIT #=   272 LV= 1 IF
               MVI   RR,TRUE
*MCALL #=   274 LV= 1          ENDIF 
*MCALL #=   275 LV= 2          ZSTREQU 
*MEXIT #=   275 LV= 2 ZSTREQU
#@IF_32_2                                                DS 0H
*MEXIT #=   274 LV= 1 ENDIF
*MCALL #=   276 LV= 1          IF    (TM,VCLRFLG1,O,VCLRVREC)  RPI 688 X
                   RPI 681
*MCALL #=   277 LV= 2          ZSTREQU 
*MEXIT #=   277 LV= 2 ZSTREQU
         TM    VCLRFLG1,VCLRVREC
         BC    15-O,#@IF_33_2
*MEXIT #=   276 LV= 1 IF
*MCALL #=   278 LV= 1                PM    SET_VREC_RECFM
         MVC   SET_VREC_RECFM-2(2),*+10
         B     SET_VREC_RECFM
         DC    S(*+2)
*MEXIT #=   278 LV= 1 PM
               L     R2,VCLRLREC                     RPI 681
               AHI   R2,4         LENGTH OF MAX RECORD + 4
*MCALL #=   279 LV= 1                IF    (CLC,RECFM_OVF,EQ,=C'RV')
*MCALL #=   280 LV= 2          ZSTREQU 
*MEXIT #=   280 LV= 2 ZSTREQU
         CLC   RECFM_OVF,=C'RV'
         BC    15-EQ,#@IF_34_2
*MEXIT #=   279 LV= 1 IF
                     AHI   R2,4    ADD 4 BYTE FOR LLLL,RRN PFX
*MCALL #=   281 LV= 1                ENDIF 
*MCALL #=   282 LV= 2          ZSTREQU 
*MEXIT #=   282 LV= 2 ZSTREQU
#@IF_34_2                                                DS 0H
*MEXIT #=   281 LV= 1 ENDIF
               ST    R2,DCBBLKSIF  VB BLKSI
*MCALL #=   283 LV= 1                GETMAIN RU,LV=(R2)
*MCALL #=   284 LV= 2          ZOPTLR 1,R2
         LR    1,R2
*MEXIT #=   284 LV= 2 ZOPTLR
         LA    0,B'10'
         SVC   4 GMAIN R0=(X'02'=31B,X'01'=COND),R1=LEN OUT(R0=L,R1=A)
*MEXIT #=   283 LV= 1 GETMAIN
               LR    R3,R1         R3=A(VSAM RECORD LENGTH IN PFX)
*MCALL #=   285 LV= 1                IF    (CLC,RECFM_OVF,EQ,=C'RV')
*MCALL #=   286 LV= 2          ZSTREQU 
*MEXIT #=   286 LV= 2 ZSTREQU
         CLC   RECFM_OVF,=C'RV'
         BC    15-EQ,#@IF_35_2
*MEXIT #=   285 LV= 1 IF
                     LA    R4,8(R3)      R4=A(VSAM LOGICAL)
*MCALL #=   287 LV= 1                ELSE 
*MCALL #=   288 LV= 2          ZSTREQU 
*MEXIT #=   288 LV= 2 ZSTREQU
        B      #@IF_35_E
#@IF_35_2                                                DS 0H
*MEXIT #=   287 LV= 1 ELSE
                     LA    R4,4(R3)      R4=A(VSAM LOGICAL)
*MCALL #=   289 LV= 1                ENDIF 
*MCALL #=   290 LV= 2          ZSTREQU 
*MEXIT #=   290 LV= 2 ZSTREQU
#@IF_35_E                        DS 0H
*MEXIT #=   289 LV= 1 ENDIF
*MCALL #=   291 LV= 1          ELSE 
*MCALL #=   292 LV= 2          ZSTREQU 
*MEXIT #=   292 LV= 2 ZSTREQU
        B      #@IF_33_E
#@IF_33_2                                                DS 0H
*MEXIT #=   291 LV= 1 ELSE
*MCALL #=   293 LV= 1                PM    SET_FIXED_RECFM
         MVC   SET_FIXED_RECFM-2(2),*+10
         B     SET_FIXED_RECFM
         DC    S(*+2)
*MEXIT #=   293 LV= 1 PM
               L     R2,VCLRLREC                RPI 681
*MCALL #=   294 LV= 1                MODCB RPL=INFILER,RECLEN=(R2)    RX
               PI 688
*MCALL #=   295 LV= 2          ZMODCB INFILER,RPLLREC-IHARPL,(R2),4
         ST    R2,INFILER+RPLLREC-IHARPL
*MEXIT #=   295 LV= 2 ZMODCB
         SR    15,15
*MEXIT #=   294 LV= 1 MODCB
*MCALL #=   296 LV= 1                MODCB RPL=OUTFILER,RECLEN=(R2)   RX
               PI 688
*MCALL #=   297 LV= 2          ZMODCB OUTFILER,RPLLREC-IHARPL,(R2),4
         ST    R2,OUTFILER+RPLLREC-IHARPL
*MEXIT #=   297 LV= 2 ZMODCB
         SR    15,15
*MEXIT #=   296 LV= 1 MODCB
*MCALL #=   298 LV= 1                IF    (CLC,RECFM_OVF,EQ,=C'RF')
*MCALL #=   299 LV= 2          ZSTREQU 
*MEXIT #=   299 LV= 2 ZSTREQU
         CLC   RECFM_OVF,=C'RF'
         BC    15-EQ,#@IF_36_2
*MEXIT #=   298 LV= 1 IF
                     AHI   R2,4   ADD RRN PFX
*MCALL #=   300 LV= 1                ENDIF 
*MCALL #=   301 LV= 2          ZSTREQU 
*MEXIT #=   301 LV= 2 ZSTREQU
#@IF_36_2                                                DS 0H
*MEXIT #=   300 LV= 1 ENDIF
               ST    R2,DCBBLKSIF
               ST    R2,DCBLRECLF
*MCALL #=   302 LV= 1                GETMAIN RU,LV=(R2)
*MCALL #=   303 LV= 2          ZOPTLR 1,R2
         LR    1,R2
*MEXIT #=   303 LV= 2 ZOPTLR
         LA    0,B'10'
         SVC   4 GMAIN R0=(X'02'=31B,X'01'=COND),R1=LEN OUT(R0=L,R1=A)
*MEXIT #=   302 LV= 1 GETMAIN
               LR    R3,R1         R3=A(VSAM RECORD PFX IF ANY)
*MCALL #=   304 LV= 1                IF    (CLC,RECFM_OVF,EQ,=C'RF')
*MCALL #=   305 LV= 2          ZSTREQU 
*MEXIT #=   305 LV= 2 ZSTREQU
         CLC   RECFM_OVF,=C'RF'
         BC    15-EQ,#@IF_37_2
*MEXIT #=   304 LV= 1 IF
                     LA    R4,4(R3)   R4=A(VSAM LOCICAL REC)
*MCALL #=   306 LV= 1                ELSE 
*MCALL #=   307 LV= 2          ZSTREQU 
*MEXIT #=   307 LV= 2 ZSTREQU
        B      #@IF_37_E
#@IF_37_2                                                DS 0H
*MEXIT #=   306 LV= 1 ELSE
                     LR    R4,R1      R4=A(VSAM LOGICAL REC)
*MCALL #=   308 LV= 1                ENDIF 
*MCALL #=   309 LV= 2          ZSTREQU 
*MEXIT #=   309 LV= 2 ZSTREQU
#@IF_37_E                        DS 0H
*MEXIT #=   308 LV= 1 ENDIF
*MCALL #=   310 LV= 1          ENDIF 
*MCALL #=   311 LV= 2          ZSTREQU 
*MEXIT #=   311 LV= 2 ZSTREQU
#@IF_33_E                        DS 0H
*MEXIT #=   310 LV= 1 ENDIF
         CVD   R2,PWORK
         MVC   DLRECL,=X'4020202020202020'
         ED    DLRECL,PWORK+4
*MCALL #=   312 LV= 1          WTO   MF=(E,WTO_RECFM)
         LA    1,WTO_RECFM
         SVC   35
*MEXIT #=   312 LV= 1 WTO
*MCALL #=   313 LV= 1          MODCB RPL=INFILER,AREA=(R4)    RPI 688
*MCALL #=   314 LV= 2          ZMODCB INFILER,RPLAREA-IHARPL,(R4),4
         ST    R4,INFILER+RPLAREA-IHARPL
*MEXIT #=   314 LV= 2 ZMODCB
         SR    15,15
*MEXIT #=   313 LV= 1 MODCB
*MCALL #=   315 LV= 1          MODCB RPL=OUTFILER,AREA=(R4)   RPI 688
*MCALL #=   316 LV= 2          ZMODCB OUTFILER,RPLAREA-IHARPL,(R4),4
         ST    R4,OUTFILER+RPLAREA-IHARPL
*MEXIT #=   316 LV= 2 ZMODCB
         SR    15,15
*MEXIT #=   315 LV= 1 MODCB
*MCALL #=   317 LV= 1          PEXIT 
         B     INIT_QSAM-4
*MEXIT #=   317 LV= 1 PEXIT
*
* INIT_QSAM_AIX - SET QSAM RECFM=F,LRECL=KEY+8,DSNAME FROM VAIXVXNA
*
*MCALL #=   318 LV= 1 INIT_QSAM_AIX PENTRY 
         DC    0H'0',CL8'INIT_QSAM_AIX'
         B     *+4
INIT_QSAM_AIX EQU *
*MEXIT #=   318 LV= 1 PENTRY
         USING IHADCB,R5  QSAM DCB IN/OUT FILE
         USING IHAACB,R6  VSAM ACB IN/OUT FILE
         L     R7,ACBVCLRA R15= VCLR BASE CLUSTER    RPI 681
         USING IHAVCLR,R7                            RPI 681
         L     R2,VCLRLREC                RPI 681
*MCALL #=   319 LV= 1          MODCB RPL=INFILER,RECLEN=(R2)    RPI 688
*MCALL #=   320 LV= 2          ZMODCB INFILER,RPLLREC-IHARPL,(R2),4
         ST    R2,INFILER+RPLLREC-IHARPL
*MEXIT #=   320 LV= 2 ZMODCB
         SR    15,15
*MEXIT #=   319 LV= 1 MODCB
         ST    R2,VSAM_LRECL
         L     R1,VAIX_ADDR
         USING IHAVAIX,R1
         L     R2,VCATFSA
         ST    R2,DCBDSNAM SET DSNAME FOR AIX
         L     R3,PER_BRK_ADDR
*MCALL #=   321 LV= 1          DO    WHILE=(CLR,R2,LT,R3)
*MCALL #=   322 LV= 2          ZSTREQU 
*MEXIT #=   322 LV= 2 ZSTREQU
#@DO_4_T                         DS 0H
*MCALL #=   323 LV= 2          IF CLR,R2,LT,R3
*MCALL #=   324 LV= 3          ZSTREQU 
*MEXIT #=   324 LV= 3 ZSTREQU
         CLR   R2,R3
         BC    15-LT,#@IF_38_2
*MEXIT #=   323 LV= 2 IF
               B   #@DO_4_1
*MCALL #=   325 LV= 2          ENDIF 
*MCALL #=   326 LV= 3          ZSTREQU 
*MEXIT #=   326 LV= 3 ZSTREQU
#@IF_38_2                                                DS 0H
*MEXIT #=   325 LV= 2 ENDIF
         B     #@DO_4_E
#@DO_4_1                         DS 0H
*MEXIT #=   321 LV= 1 DO
*MCALL #=   327 LV= 1                IF (CLI,0(R3),EQ,C'/'),OR,(CLI,0(RX
               3),EQ,C'\'),OR,(CLI,0(R3),EQ,C':')
*MCALL #=   328 LV= 2          ZSTREQU 
*MEXIT #=   328 LV= 2 ZSTREQU
         CLI   0(R3),C'/'
         BC    15-EQ,#@IF_39_2
         B     #@IF_39_1
#@IF_39_2                                                DS 0H
         CLI   0(R3),C'\'
         BC    15-EQ,#@IF_39_3
         B     #@IF_39_1
#@IF_39_3                                                DS 0H
         CLI   0(R3),C':'
         BC    15-EQ,#@IF_39_4
#@IF_39_1                               DS 0H
*MEXIT #=   327 LV= 1 IF
                  AHI R3,1
                  LR R2,R3
*MCALL #=   329 LV= 1                ELSE 
*MCALL #=   330 LV= 2          ZSTREQU 
*MEXIT #=   330 LV= 2 ZSTREQU
        B      #@IF_39_E
#@IF_39_4                                                DS 0H
*MEXIT #=   329 LV= 1 ELSE
                  AHI R3,-1
*MCALL #=   331 LV= 1                ENDIF 
*MCALL #=   332 LV= 2          ZSTREQU 
*MEXIT #=   332 LV= 2 ZSTREQU
#@IF_39_E                        DS 0H
*MEXIT #=   331 LV= 1 ENDIF
*MCALL #=   333 LV= 1          ENDDO 
*MCALL #=   334 LV= 2          DO    END
*MCALL #=   335 LV= 3          ZSTREQU 
*MEXIT #=   335 LV= 3 ZSTREQU
         B     #@DO_4_T
#@DO_4_E                         DS 0H
*MEXIT #=   334 LV= 2 DO
*MEXIT #=   333 LV= 1 ENDDO
         L     R2,VAIXVXNA
*MCALL #=   336 LV= 1          DO    WHILE=(CLI,0(R2),GT,C' ')
*MCALL #=   337 LV= 2          ZSTREQU 
*MEXIT #=   337 LV= 2 ZSTREQU
#@DO_5_T                         DS 0H
*MCALL #=   338 LV= 2          IF CLI,0(R2),GT,C' '
*MCALL #=   339 LV= 3          ZSTREQU 
*MEXIT #=   339 LV= 3 ZSTREQU
         CLI   0(R2),C' '
         BC    15-GT,#@IF_40_2
*MEXIT #=   338 LV= 2 IF
               B   #@DO_5_1
*MCALL #=   340 LV= 2          ENDIF 
*MCALL #=   341 LV= 3          ZSTREQU 
*MEXIT #=   341 LV= 3 ZSTREQU
#@IF_40_2                                                DS 0H
*MEXIT #=   340 LV= 2 ENDIF
         B     #@DO_5_E
#@DO_5_1                         DS 0H
*MEXIT #=   336 LV= 1 DO
               MVC  0(1,R3),0(R2)
               AHI  R3,1
               AHI  R2,1
*MCALL #=   342 LV= 1          ENDDO 
*MCALL #=   343 LV= 2          DO    END
*MCALL #=   344 LV= 3          ZSTREQU 
*MEXIT #=   344 LV= 3 ZSTREQU
         B     #@DO_5_T
#@DO_5_E                         DS 0H
*MEXIT #=   343 LV= 2 DO
*MEXIT #=   342 LV= 1 ENDDO
         MVI   0(R3),X'00'
         L     R2,VAIXKLEN                RPI 865 AIX KEY LENGTH
         AHI   R2,8                       RPI 865 XRBA LENGTH
         DROP  R1
*MCALL #=   345 LV= 1          PM    SET_FIXED_RECFM
         MVC   SET_FIXED_RECFM-2(2),*+10
         B     SET_FIXED_RECFM
         DC    S(*+2)
*MEXIT #=   345 LV= 1 PM
         ST    R2,VAIX_LRECL              RPI 865 XRBA+KEY
         ST    R2,DCBBLKSIF
         ST    R2,DCBLRECLF
         A     R2,VSAM_LRECL
*MCALL #=   346 LV= 1          GETMAIN RU,LV=(R2)
*MCALL #=   347 LV= 2          ZOPTLR 1,R2
         LR    1,R2
*MEXIT #=   347 LV= 2 ZOPTLR
         LA    0,B'10'
         SVC   4 GMAIN R0=(X'02'=31B,X'01'=COND),R1=LEN OUT(R0=L,R1=A)
*MEXIT #=   346 LV= 1 GETMAIN
         ST    R1,VSAM_AREA
         LR    R0,R1
         A     R0,VSAM_LRECL
         ST    R0,VAIX_AREA
         LR    R3,R1         R3=A(VSAM RECORD PFX IF ANY)
*MCALL #=   348 LV= 1          IF    (CLC,RECFM_OVF,EQ,=C'RF')
*MCALL #=   349 LV= 2          ZSTREQU 
*MEXIT #=   349 LV= 2 ZSTREQU
         CLC   RECFM_OVF,=C'RF'
         BC    15-EQ,#@IF_41_2
*MEXIT #=   348 LV= 1 IF
               LA    R4,4(R3)   R4=A(VSAM LOCICAL REC)
*MCALL #=   350 LV= 1          ELSE 
*MCALL #=   351 LV= 2          ZSTREQU 
*MEXIT #=   351 LV= 2 ZSTREQU
        B      #@IF_41_E
#@IF_41_2                                                DS 0H
*MEXIT #=   350 LV= 1 ELSE
               LR    R4,R1      R4=A(VSAM LOGICAL REC)
*MCALL #=   352 LV= 1          ENDIF 
*MCALL #=   353 LV= 2          ZSTREQU 
*MEXIT #=   353 LV= 2 ZSTREQU
#@IF_41_E                        DS 0H
*MEXIT #=   352 LV= 1 ENDIF
         L     R2,VAIX_LRECL
         CVD   R2,PWORK
         MVC   DLRECL,=X'4020202020202020'
         ED    DLRECL,PWORK+4
*MCALL #=   354 LV= 1          WTO   MF=(E,WTO_RECFM)
         LA    1,WTO_RECFM
         SVC   35
*MEXIT #=   354 LV= 1 WTO
*MCALL #=   355 LV= 1          MODCB RPL=INFILER,AREA=(R4)    RPI 688
*MCALL #=   356 LV= 2          ZMODCB INFILER,RPLAREA-IHARPL,(R4),4
         ST    R4,INFILER+RPLAREA-IHARPL
*MEXIT #=   356 LV= 2 ZMODCB
         SR    15,15
*MEXIT #=   355 LV= 1 MODCB
         L     R1,VAIX_AREA
*MCALL #=   357 LV= 1          MODCB RPL=OUTFILER,AREA=(R1)   RPI 865
*MCALL #=   358 LV= 2          ZMODCB OUTFILER,RPLAREA-IHARPL,(R1),4
         ST    R1,OUTFILER+RPLAREA-IHARPL
*MEXIT #=   358 LV= 2 ZMODCB
         SR    15,15
*MEXIT #=   357 LV= 1 MODCB
         L     R14,VAIX_LRECL
         L     R15,VAIX_KLEN
*          RPI 865 FIELDS REQ OFFSET+1, ADD XRBA TO MAINT ORIG SEQ
*MCALL #=   359 LV= 1          ZSORT ISORT,LRECL=(R14),FIELDS=(9,(R15),X
               BI,A,1,8,BI,A)
         DS    0H
         CNOP  0,4
         LA    0,1   ISORT
         BAS   1,*+4+8+(8+4)*2
         DC    A((R14)) ZSORT LRECL
         DC    A(0) ZSORT MEMORY AVAILABLE
         DC    A(9-1) ZSORT KEY OFFSET
         DC    A((R15)) ZSORT KEY LENGTH
         DC    AL2(2) ZSORT KEY TYPE BI UNSIGNED BINARY
         DC    AL2(1) ZSORT KEY ASCENDING
         DC    A(1-1) ZSORT KEY OFFSET
         DC    A(8) ZSORT KEY LENGTH
         DC    AL2(2) ZSORT KEY TYPE BI UNSIGNED BINARY
         DC    AL2(1) ZSORT KEY ASCENDING
         ORG   *-4
         DC    X'80' OVERLAY VL BIT FOR END OF LIST
         ORG 
         ST    R14,0(1)
         ST    R15,8+4(1)   STORE AIX KEY LEN REG
         SVC   X'A1' ZSORT R0=1-ISORT,2-PUT,3=GET R15= 4 AT EOF
*MEXIT #=   359 LV= 1 ZSORT
*MCALL #=   360 LV= 1          PEXIT 
         B     INIT_QSAM_AIX-4
*MEXIT #=   360 LV= 1 PEXIT
*
* SET FIXED QSAM RECORD FORMAT AND DISPLAY IT
*
*MCALL #=   361 LV= 1 SET_FIXED_RECFM PENTRY 
         DC    0H'0',CL8'SET_FIXED_RECFM'
         B     *+4
SET_FIXED_RECFM EQU *
*MEXIT #=   361 LV= 1 PENTRY
*MCALL #=   362 LV= 1          IF    (CLC,RECFM_OVF,EQ,=C'XX')
*MCALL #=   363 LV= 2          ZSTREQU 
*MEXIT #=   363 LV= 2 ZSTREQU
         CLC   RECFM_OVF,=C'XX'
         BC    15-EQ,#@IF_42_2
*MEXIT #=   362 LV= 1 IF
*MCALL #=   364 LV= 1                IF    (CLI,RR,EQ,TRUE)
*MCALL #=   365 LV= 2          ZSTREQU 
*MEXIT #=   365 LV= 2 ZSTREQU
         CLI   RR,TRUE
         BC    15-EQ,#@IF_43_2
*MEXIT #=   364 LV= 1 IF
                     MVC   RECFM_OVF,=C'RF' RRDS WITH RRN PFX
*MCALL #=   366 LV= 1                ELSE 
*MCALL #=   367 LV= 2          ZSTREQU 
*MEXIT #=   367 LV= 2 ZSTREQU
        B      #@IF_43_E
#@IF_43_2                                                DS 0H
*MEXIT #=   366 LV= 1 ELSE
                     MVC   RECFM_OVF,=C'EF' ESDS SEQ RCDS
*MCALL #=   368 LV= 1                ENDIF 
*MCALL #=   369 LV= 2          ZSTREQU 
*MEXIT #=   369 LV= 2 ZSTREQU
#@IF_43_E                        DS 0H
*MEXIT #=   368 LV= 1 ENDIF
*MCALL #=   370 LV= 1                PM    INIT_BUFF
         MVC   INIT_BUFF-2(2),*+10
         B     INIT_BUFF
         DC    S(*+2)
*MEXIT #=   370 LV= 1 PM
*MCALL #=   371 LV= 1          ELSEIF (CLC,RECFM_OVF,EQ,=C'FT')
*MCALL #=   372 LV= 2          ZSTREQU 
*MEXIT #=   372 LV= 2 ZSTREQU
         B     #@IF_42_E
#@IF_42_2                                                DS 0H
         CLC   RECFM_OVF,=C'FT'
         BC    15-EQ,#@IF_42_4
*MEXIT #=   371 LV= 1 ELSEIF
               MVI DCBRECFM,DCBRECFM_FT
*MCALL #=   373 LV= 1          ELSEIF (CLC,RECFM_OVF,EQ,=C'FB')
*MCALL #=   374 LV= 2          ZSTREQU 
*MEXIT #=   374 LV= 2 ZSTREQU
         B     #@IF_42_E
#@IF_42_4                                                DS 0H
         CLC   RECFM_OVF,=C'FB'
         BC    15-EQ,#@IF_42_6
*MEXIT #=   373 LV= 1 ELSEIF
               MVI DCBRECFM,DCBRECFM_FB
*MCALL #=   375 LV= 1          ELSEIF (CLC,RECFM_OVF(1),EQ,=C'F')
*MCALL #=   376 LV= 2          ZSTREQU 
*MEXIT #=   376 LV= 2 ZSTREQU
         B     #@IF_42_E
#@IF_42_6                                                DS 0H
         CLC   RECFM_OVF(1),=C'F'
         BC    15-EQ,#@IF_42_8
*MEXIT #=   375 LV= 1 ELSEIF
               MVC   RECFM_OVF,=C'F '
               MVI   DCBRECFM,DCBRECFM_F
*MCALL #=   377 LV= 1          ELSE 
*MCALL #=   378 LV= 2          ZSTREQU 
*MEXIT #=   378 LV= 2 ZSTREQU
        B      #@IF_42_E
#@IF_42_8                                                DS 0H
*MEXIT #=   377 LV= 1 ELSE
*MCALL #=   379 LV= 1                WTO 'REPRO INVALID FIXED QSAM [RECX
               FM=FT|FB]'
         BRAS  1,*+(WTO#0379_EOT-*+1)/2*2
         DC    AL2(WTO#0379_EOT-*,0),C'REPRO INVALID FIXED QSAM [RECFM=X
               FT|FB]'
WTO#0379_EOT     EQU *
         SVC   35
*MEXIT #=   379 LV= 1 WTO
*MCALL #=   380 LV= 1                SUBEXIT RC=16
         LA    15,16
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=   380 LV= 1 SUBEXIT
*MCALL #=   381 LV= 1          ENDIF 
*MCALL #=   382 LV= 2          ZSTREQU 
*MEXIT #=   382 LV= 2 ZSTREQU
#@IF_42_E                        DS 0H
*MEXIT #=   381 LV= 1 ENDIF
*MCALL #=   383 LV= 1          PEXIT 
         B     SET_FIXED_RECFM-4
*MEXIT #=   383 LV= 1 PEXIT
*
* SET VARIABLE QSAM RECORD FORMAT AND DISPLAY IT
*
*MCALL #=   384 LV= 1 SET_VREC_RECFM PENTRY 
         DC    0H'0',CL8'SET_VREC_RECFM'
         B     *+4
SET_VREC_RECFM EQU *
*MEXIT #=   384 LV= 1 PENTRY
         MVI   VAR,TRUE            VARIABLE LENGTH
         MVI   VL32,FALSE         ASSUME QSAM VL16 BIT LENGTH
*MCALL #=   385 LV= 1          IF    (CLC,RECFM_OVF,EQ,=C'XX')
*MCALL #=   386 LV= 2          ZSTREQU 
*MEXIT #=   386 LV= 2 ZSTREQU
         CLC   RECFM_OVF,=C'XX'
         BC    15-EQ,#@IF_44_2
*MEXIT #=   385 LV= 1 IF
               MVI   VL32,TRUE          ASSUME ES VL32 USING QSAM F
*MCALL #=   387 LV= 1                IF    (CLI,RR,EQ,TRUE)
*MCALL #=   388 LV= 2          ZSTREQU 
*MEXIT #=   388 LV= 2 ZSTREQU
         CLI   RR,TRUE
         BC    15-EQ,#@IF_45_2
*MEXIT #=   387 LV= 1 IF
                     MVC   RECFM_OVF,=C'RV' RRDS WITH LLLL,RRN PFX REC
*MCALL #=   389 LV= 1                ELSE 
*MCALL #=   390 LV= 2          ZSTREQU 
*MEXIT #=   390 LV= 2 ZSTREQU
        B      #@IF_45_E
#@IF_45_2                                                DS 0H
*MEXIT #=   389 LV= 1 ELSE
                     MVC   RECFM_OVF,=C'EV' ESDS WITH LLLL FPX REC
*MCALL #=   391 LV= 1                ENDIF 
*MCALL #=   392 LV= 2          ZSTREQU 
*MEXIT #=   392 LV= 2 ZSTREQU
#@IF_45_E                        DS 0H
*MEXIT #=   391 LV= 1 ENDIF
*MCALL #=   393 LV= 1                PM  INIT_BUFF
         MVC   INIT_BUFF-2(2),*+10
         B     INIT_BUFF
         DC    S(*+2)
*MEXIT #=   393 LV= 1 PM
*MCALL #=   394 LV= 1          ELSEIF (CLC,RECFM_OVF,EQ,=C'VT')
*MCALL #=   395 LV= 2          ZSTREQU 
*MEXIT #=   395 LV= 2 ZSTREQU
         B     #@IF_44_E
#@IF_44_2                                                DS 0H
         CLC   RECFM_OVF,=C'VT'
         BC    15-EQ,#@IF_44_4
*MEXIT #=   394 LV= 1 ELSEIF
               MVI DCBRECFM,DCBRECFM_VT
*MCALL #=   396 LV= 1          ELSEIF (CLC,RECFM_OVF,EQ,=C'VB')
*MCALL #=   397 LV= 2          ZSTREQU 
*MEXIT #=   397 LV= 2 ZSTREQU
         B     #@IF_44_E
#@IF_44_4                                                DS 0H
         CLC   RECFM_OVF,=C'VB'
         BC    15-EQ,#@IF_44_6
*MEXIT #=   396 LV= 1 ELSEIF
               MVI DCBRECFM,DCBRECFM_VB
*MCALL #=   398 LV= 1          ELSEIF (CLC,RECFM_OVF(1),EQ,=C'V')
*MCALL #=   399 LV= 2          ZSTREQU 
*MEXIT #=   399 LV= 2 ZSTREQU
         B     #@IF_44_E
#@IF_44_6                                                DS 0H
         CLC   RECFM_OVF(1),=C'V'
         BC    15-EQ,#@IF_44_8
*MEXIT #=   398 LV= 1 ELSEIF
               MVI   DCBRECFM,DCBRECFM_V
*MCALL #=   400 LV= 1          ELSE 
*MCALL #=   401 LV= 2          ZSTREQU 
*MEXIT #=   401 LV= 2 ZSTREQU
        B      #@IF_44_E
#@IF_44_8                                                DS 0H
*MEXIT #=   400 LV= 1 ELSE
*MCALL #=   402 LV= 1                WTO 'REPRO INVALID VARIABLE QSAM [X
               RECFM=VT|VB]'
         BRAS  1,*+(WTO#0402_EOT-*+1)/2*2
         DC    AL2(WTO#0402_EOT-*,0),C'REPRO INVALID VARIABLE QSAM [RECX
               FM=VT|VB]'
WTO#0402_EOT     EQU *
         SVC   35
*MEXIT #=   402 LV= 1 WTO
*MCALL #=   403 LV= 1                SUBEXIT RC=16
         LA    15,16
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=   403 LV= 1 SUBEXIT
*MCALL #=   404 LV= 1          ENDIF 
*MCALL #=   405 LV= 2          ZSTREQU 
*MEXIT #=   405 LV= 2 ZSTREQU
#@IF_44_E                        DS 0H
*MEXIT #=   404 LV= 1 ENDIF
*MCALL #=   406 LV= 1          PEXIT 
         B     SET_VREC_RECFM-4
*MEXIT #=   406 LV= 1 PEXIT
*
* INIT BUFF FOR EF, EV, RF, RF FORMAT SEQUENTIAL FILE BUFFERING
*
*MCALL #=   407 LV= 1 INIT_BUFF PENTRY 
         DC    0H'0',CL8'INIT_BUFF'
         B     *+4
INIT_BUFF EQU  *
*MEXIT #=   407 LV= 1 PENTRY
         MVI   BUFF,TRUE
         MVI   DCBRECFM,DCBRECFM_F  USE FIXED 32 BIT QSAM I/O
*MCALL #=   408 LV= 1          IF    (CLI,BUILDAIX,EQ,TRUE)   RPI 1130
*MCALL #=   409 LV= 2          ZSTREQU 
*MEXIT #=   409 LV= 2 ZSTREQU
         CLI   BUILDAIX,TRUE
         BC    15-EQ,#@IF_46_2
*MEXIT #=   408 LV= 1 IF
               L     R9,VAIX_LRECL
               MVC   RECFM_OVF,=C'AI'
*MCALL #=   410 LV= 1          ELSE 
*MCALL #=   411 LV= 2          ZSTREQU 
*MEXIT #=   411 LV= 2 ZSTREQU
        B      #@IF_46_E
#@IF_46_2                                                DS 0H
*MEXIT #=   410 LV= 1 ELSE
               L     R9,VCLRLREC
*MCALL #=   412 LV= 1          ENDIF 
*MCALL #=   413 LV= 2          ZSTREQU 
*MEXIT #=   413 LV= 2 ZSTREQU
#@IF_46_E                        DS 0H
*MEXIT #=   412 LV= 1 ENDIF
         AHI   R9,8
*MCALL #=   414 LV= 1          IF    (C,R9,LT,LBUFF)
*MCALL #=   415 LV= 2          ZSTREQU 
*MEXIT #=   415 LV= 2 ZSTREQU
         C     R9,LBUFF
         BC    15-LT,#@IF_47_2
*MEXIT #=   414 LV= 1 IF
               L  R9,LBUFF     SET LBUFF
*MCALL #=   416 LV= 1          ENDIF 
*MCALL #=   417 LV= 2          ZSTREQU 
*MEXIT #=   417 LV= 2 ZSTREQU
#@IF_47_2                                                DS 0H
*MEXIT #=   416 LV= 1 ENDIF
         ST    R9,LBUFF        R11=BUFFER LENGTH
*MCALL #=   418 LV= 1          GETMAIN R,LV=(R9)
*MCALL #=   419 LV= 2          ZOPTLR 1,R9
         LR    1,R9
*MEXIT #=   419 LV= 2 ZOPTLR
         LA    0,B'00'
         SVC   4 GMAIN R0=(X'02'=31B,X'01'=COND),R1=LEN OUT(R0=L,R1=A)
*MEXIT #=   418 LV= 1 GETMAIN
         ST    R1,ABUFF
*MCALL #=   420 LV= 1          IF    (CLI,INFILET,EQ,C'Q')
*MCALL #=   421 LV= 2          ZSTREQU 
*MEXIT #=   421 LV= 2 ZSTREQU
         CLI   INFILET,C'Q'
         BC    15-EQ,#@IF_48_2
*MEXIT #=   420 LV= 1 IF
               SR    R9,R9    R11=REMAINING DATA 0 (FORCE READ)
*MCALL #=   422 LV= 1          ELSE 
*MCALL #=   423 LV= 2          ZSTREQU 
*MEXIT #=   423 LV= 2 ZSTREQU
        B      #@IF_48_E
#@IF_48_2                                                DS 0H
*MEXIT #=   422 LV= 1 ELSE
               L     R10,ABUFF  R10=NEXT OUTPUT RCD IN BUFF
               L     R9,LBUFF  R9=REMAINING BUFF LENGTH
*MCALL #=   424 LV= 1          ENDIF 
*MCALL #=   425 LV= 2          ZSTREQU 
*MEXIT #=   425 LV= 2 ZSTREQU
#@IF_48_E                        DS 0H
*MEXIT #=   424 LV= 1 ENDIF
*MCALL #=   426 LV= 1          PEXIT 
         B     INIT_BUFF-4
*MEXIT #=   426 LV= 1 PEXIT
*
* CLOSE FILES
*
*MCALL #=   427 LV= 1 CLOSE    PENTRY 
         DC    0H'0',CL8'CLOSE'
         B     *+4
CLOSE    EQU   *
*MEXIT #=   427 LV= 1 PENTRY
*MCALL #=   428 LV= 1          IF    (CLI,INFILET,EQ,C'Q')
*MCALL #=   429 LV= 2          ZSTREQU 
*MEXIT #=   429 LV= 2 ZSTREQU
         CLI   INFILET,C'Q'
         BC    15-EQ,#@IF_49_2
*MEXIT #=   428 LV= 1 IF
               MVC  INFILEQ+DCBSYNAD-IHADCB(4),=A(ERR41)
*MCALL #=   430 LV= 1                CLOSE INFILEQ
*MCALL #=   431 LV= 2          ZCLOSE INFILEQ,MODE=,MF=I,TYPE=
                       LA     1,INFILEQ
                   SVC   20 CLOSE R1=DCB/ACB
*MEXIT #=   431 LV= 2 ZCLOSE
*MEXIT #=   430 LV= 1 CLOSE
*MCALL #=   432 LV= 1                CLOSE OUTFILEV
*MCALL #=   433 LV= 2          ZCLOSE OUTFILEV,MODE=,MF=I,TYPE=
                       LA     1,OUTFILEV
                   SVC   20 CLOSE R1=DCB/ACB
*MEXIT #=   433 LV= 2 ZCLOSE
*MEXIT #=   432 LV= 1 CLOSE
*MCALL #=   434 LV= 1                IF  (LTR,R15,NE,R15)
*MCALL #=   435 LV= 2          ZSTREQU 
*MEXIT #=   435 LV= 2 ZSTREQU
         LTR   R15,R15
         BC    15-NE,#@IF_50_2
*MEXIT #=   434 LV= 1 IF
                   B  ERR44
*MCALL #=   436 LV= 1                ENDIF 
*MCALL #=   437 LV= 2          ZSTREQU 
*MEXIT #=   437 LV= 2 ZSTREQU
#@IF_50_2                                                DS 0H
*MEXIT #=   436 LV= 1 ENDIF
*MCALL #=   438 LV= 1          ELSE 
*MCALL #=   439 LV= 2          ZSTREQU 
*MEXIT #=   439 LV= 2 ZSTREQU
        B      #@IF_49_E
#@IF_49_2                                                DS 0H
*MEXIT #=   438 LV= 1 ELSE
*MCALL #=   440 LV= 1                CLOSE INFILEV
*MCALL #=   441 LV= 2          ZCLOSE INFILEV,MODE=,MF=I,TYPE=
                       LA     1,INFILEV
                   SVC   20 CLOSE R1=DCB/ACB
*MEXIT #=   441 LV= 2 ZCLOSE
*MEXIT #=   440 LV= 1 CLOSE
*MCALL #=   442 LV= 1                IF  (LTR,R15,NE,R15)
*MCALL #=   443 LV= 2          ZSTREQU 
*MEXIT #=   443 LV= 2 ZSTREQU
         LTR   R15,R15
         BC    15-NE,#@IF_51_2
*MEXIT #=   442 LV= 1 IF
                   B  ERR42
*MCALL #=   444 LV= 1                ENDIF 
*MCALL #=   445 LV= 2          ZSTREQU 
*MEXIT #=   445 LV= 2 ZSTREQU
#@IF_51_2                                                DS 0H
*MEXIT #=   444 LV= 1 ENDIF
*MCALL #=   446 LV= 1                IF    (CLI,BUFF,EQ,TRUE),AND,(CHI,X
               R9,GT,0)
*MCALL #=   447 LV= 2          ZSTREQU 
*MEXIT #=   447 LV= 2 ZSTREQU
         CLI   BUFF,TRUE
         BC    15-EQ,#@IF_52_2
         CHI   R9,0
         BC    15-GT,#@IF_52_2
*MEXIT #=   446 LV= 1 IF
*MCALL #=   448 LV= 1                      PM WRITE_BUFF  FLUSH BUFFER
         MVC   WRITE_BUFF-2(2),*+10
         B     WRITE_BUFF
         DC    S(*+2)
*MEXIT #=   448 LV= 1 PM
*MCALL #=   449 LV= 1                ENDIF 
*MCALL #=   450 LV= 2          ZSTREQU 
*MEXIT #=   450 LV= 2 ZSTREQU
#@IF_52_2                                                DS 0H
*MEXIT #=   449 LV= 1 ENDIF
               MVC  OUTFILEQ+DCBSYNAD-IHADCB(4),=A(ERR43) RPI 688
*MCALL #=   451 LV= 1                CLOSE OUTFILEQ
*MCALL #=   452 LV= 2          ZCLOSE OUTFILEQ,MODE=,MF=I,TYPE=
                       LA     1,OUTFILEQ
                   SVC   20 CLOSE R1=DCB/ACB
*MEXIT #=   452 LV= 2 ZCLOSE
*MEXIT #=   451 LV= 1 CLOSE
*MCALL #=   453 LV= 1          ENDIF 
*MCALL #=   454 LV= 2          ZSTREQU 
*MEXIT #=   454 LV= 2 ZSTREQU
#@IF_49_E                        DS 0H
*MEXIT #=   453 LV= 1 ENDIF
*MCALL #=   455 LV= 1          PEXIT 
         B     CLOSE-4
*MEXIT #=   455 LV= 1 PEXIT
*
* GET RECORD FROM INFILE QSAM OR VSAM FILE
*
*MCALL #=   456 LV= 1 GET      PENTRY 
         DC    0H'0',CL8'GET'
         B     *+4
GET      EQU   *
*MEXIT #=   456 LV= 1 PENTRY
*MCALL #=   457 LV= 1          IF    (CLI,INFILET,EQ,C'Q')
*MCALL #=   458 LV= 2          ZSTREQU 
*MEXIT #=   458 LV= 2 ZSTREQU
         CLI   INFILET,C'Q'
         BC    15-EQ,#@IF_53_2
*MEXIT #=   457 LV= 1 IF
*
*              GET SEQ RECORD
*
               MVC  INFILEQ+DCBSYNAD-IHADCB(4),=A(ERR21)
*MCALL #=   459 LV= 1                IF   (CLI,BUFF,EQ,TRUE)
*MCALL #=   460 LV= 2          ZSTREQU 
*MEXIT #=   460 LV= 2 ZSTREQU
         CLI   BUFF,TRUE
         BC    15-EQ,#@IF_54_2
*MEXIT #=   459 LV= 1 IF
*MCALL #=   461 LV= 1                     PM   GET_BUFF      USE BUFF FX
               OR EF,EV,RF,RV
         MVC   GET_BUFF-2(2),*+10
         B     GET_BUFF
         DC    S(*+2)
*MEXIT #=   461 LV= 1 PM
*MCALL #=   462 LV= 1                ELSE 
*MCALL #=   463 LV= 2          ZSTREQU 
*MEXIT #=   463 LV= 2 ZSTREQU
        B      #@IF_54_E
#@IF_54_2                                                DS 0H
*MEXIT #=   462 LV= 1 ELSE
*MCALL #=   464 LV= 1                     GET  INFILEQ,(R3)  USE STD QSX
               AM V/VB FORMAT
         LA    1,INFILEQ
*MCALL #=   465 LV= 2          ZOPTLR 0,R3
         LR    0,R3
*MEXIT #=   465 LV= 2 ZOPTLR
         SVC  151
*MEXIT #=   464 LV= 1 GET
*MCALL #=   466 LV= 1                ENDIF 
*MCALL #=   467 LV= 2          ZSTREQU 
*MEXIT #=   467 LV= 2 ZSTREQU
#@IF_54_E                        DS 0H
*MEXIT #=   466 LV= 1 ENDIF
*MCALL #=   468 LV= 1          ELSE 
*MCALL #=   469 LV= 2          ZSTREQU 
*MEXIT #=   469 LV= 2 ZSTREQU
        B      #@IF_53_E
#@IF_53_2                                                DS 0H
*MEXIT #=   468 LV= 1 ELSE
*
*              GET VSAM RECORD
*
*MCALL #=   470 LV= 1                GET  RPL=INFILER
         LA    1,INFILER
         LA    0,RPLOPGET
         SVC   121 VSAM GET R0=1 R1=A(RPL)
*MEXIT #=   470 LV= 1 GET
*MCALL #=   471 LV= 1                IF  (CH,R15,EQ,=H'8')   CHECK RC
*MCALL #=   472 LV= 2          ZSTREQU 
*MEXIT #=   472 LV= 2 ZSTREQU
         CH    R15,=H'8'
         BC    15-EQ,#@IF_55_2
*MEXIT #=   471 LV= 1 IF
*MCALL #=   473 LV= 1                    SHOWCB RPL=INFILER,AREA=FDBK,LX
               ENGTH=1,FIELDS=(FDBK)
*MCALL #=   474 LV= 2          ZSHOWCB INFILER,RPLFEEDB-IHARPL+3,FDBK,0X
               ,1
         IC    0,INFILER+RPLFEEDB-IHARPL+3
         STC   0,FDBK+0
*MEXIT #=   474 LV= 2 ZSHOWCB
         SR    15,15 RC=0
*MEXIT #=   473 LV= 1 SHOWCB
*MCALL #=   475 LV= 1                    IF (CLI,FDBK,EQ,4)
*MCALL #=   476 LV= 2          ZSTREQU 
*MEXIT #=   476 LV= 2 ZSTREQU
         CLI   FDBK,4
         BC    15-EQ,#@IF_56_2
*MEXIT #=   475 LV= 1 IF
                      B  EOF
*MCALL #=   477 LV= 1                    ENDIF 
*MCALL #=   478 LV= 2          ZSTREQU 
*MEXIT #=   478 LV= 2 ZSTREQU
#@IF_56_2                                                DS 0H
*MEXIT #=   477 LV= 1 ENDIF
*MCALL #=   479 LV= 1                ENDIF 
*MCALL #=   480 LV= 2          ZSTREQU 
*MEXIT #=   480 LV= 2 ZSTREQU
#@IF_55_2                                                DS 0H
*MEXIT #=   479 LV= 1 ENDIF
*MCALL #=   481 LV= 1                IF  (LTR,R15,NE,R15)
*MCALL #=   482 LV= 2          ZSTREQU 
*MEXIT #=   482 LV= 2 ZSTREQU
         LTR   R15,R15
         BC    15-NE,#@IF_57_2
*MEXIT #=   481 LV= 1 IF
                   B  ERR22
*MCALL #=   483 LV= 1                ENDIF 
*MCALL #=   484 LV= 2          ZSTREQU 
*MEXIT #=   484 LV= 2 ZSTREQU
#@IF_57_2                                                DS 0H
*MEXIT #=   483 LV= 1 ENDIF
*              RPI 865 MOVE FROM IN FRONT OF GET
*MCALL #=   485 LV= 1                SHOWCB RPL=INFILER,AREA=VAIX_XRBA,X
               LENGTH=8,FIELDS=(XRBA)
*MCALL #=   486 LV= 2          ZSHOWCB INFILER,RPLLXRBA-IHARPL,VAIX_XRBX
               A,0,8    RPI 702
         LG    0,INFILER+RPLLXRBA-IHARPL
         STG   0,VAIX_XRBA+0
*MEXIT #=   486 LV= 2 ZSHOWCB
         SR    15,15 RC=0
*MEXIT #=   485 LV= 1 SHOWCB
               AP   PTOTREC,=P'1'
*MCALL #=   487 LV= 1          ENDIF 
*MCALL #=   488 LV= 2          ZSTREQU 
*MEXIT #=   488 LV= 2 ZSTREQU
#@IF_53_E                        DS 0H
*MEXIT #=   487 LV= 1 ENDIF
*MCALL #=   489 LV= 1          PEXIT 
         B     GET-4
*MEXIT #=   489 LV= 1 PEXIT
*
* PUT_AIX_SORT_REC
*
*MCALL #=   490 LV= 1 PUT_AIX_SORT_REC PENTRY 
         DC    0H'0',CL8'PUT_AIX_SORT_REC'
         B     *+4
PUT_AIX_SORT_REC EQU *
*MEXIT #=   490 LV= 1 PENTRY
*MCALL #=   491 LV= 1          IF   (CLI,VAR,EQ,TRUE)
*MCALL #=   492 LV= 2          ZSTREQU 
*MEXIT #=   492 LV= 2 ZSTREQU
         CLI   VAR,TRUE
         BC    15-EQ,#@IF_58_2
*MEXIT #=   491 LV= 1 IF
*MCALL #=   493 LV= 1               IF   (CLI,RR,EQ,TRUE)
*MCALL #=   494 LV= 2          ZSTREQU 
*MEXIT #=   494 LV= 2 ZSTREQU
         CLI   RR,TRUE
         BC    15-EQ,#@IF_59_2
*MEXIT #=   493 LV= 1 IF
*MCALL #=   495 LV= 1                    IF   (CLC,RECFM_OVF,EQ,=C'RV')
*MCALL #=   496 LV= 2          ZSTREQU 
*MEXIT #=   496 LV= 2 ZSTREQU
         CLC   RECFM_OVF,=C'RV'
         BC    15-EQ,#@IF_60_2
*MEXIT #=   495 LV= 1 IF
                        LA   R0,8(R3)    START OF REC
*MCALL #=   497 LV= 1                    ELSE 
*MCALL #=   498 LV= 2          ZSTREQU 
*MEXIT #=   498 LV= 2 ZSTREQU
        B      #@IF_60_E
#@IF_60_2                                                DS 0H
*MEXIT #=   497 LV= 1 ELSE
                        LA   R0,4(R3)    START OF REC
*MCALL #=   499 LV= 1                    ENDIF 
*MCALL #=   500 LV= 2          ZSTREQU 
*MEXIT #=   500 LV= 2 ZSTREQU
#@IF_60_E                        DS 0H
*MEXIT #=   499 LV= 1 ENDIF
*MCALL #=   501 LV= 1               ELSE 
*MCALL #=   502 LV= 2          ZSTREQU 
*MEXIT #=   502 LV= 2 ZSTREQU
        B      #@IF_59_E
#@IF_59_2                                                DS 0H
*MEXIT #=   501 LV= 1 ELSE
                   LA   R0,4(R3)    START OF REC
*MCALL #=   503 LV= 1               ENDIF 
*MCALL #=   504 LV= 2          ZSTREQU 
*MEXIT #=   504 LV= 2 ZSTREQU
#@IF_59_E                        DS 0H
*MEXIT #=   503 LV= 1 ENDIF
*MCALL #=   505 LV= 1          ELSE 
*MCALL #=   506 LV= 2          ZSTREQU 
*MEXIT #=   506 LV= 2 ZSTREQU
        B      #@IF_58_E
#@IF_58_2                                                DS 0H
*MEXIT #=   505 LV= 1 ELSE
*MCALL #=   507 LV= 1               IF  (CLC,RECFM_OVF,EQ,=C'RF')
*MCALL #=   508 LV= 2          ZSTREQU 
*MEXIT #=   508 LV= 2 ZSTREQU
         CLC   RECFM_OVF,=C'RF'
         BC    15-EQ,#@IF_61_2
*MEXIT #=   507 LV= 1 IF
                  LA   R0,4(R3)    R0=START OF REC
*MCALL #=   509 LV= 1               ELSE 
*MCALL #=   510 LV= 2          ZSTREQU 
*MEXIT #=   510 LV= 2 ZSTREQU
        B      #@IF_61_E
#@IF_61_2                                                DS 0H
*MEXIT #=   509 LV= 1 ELSE
                  LA   R0,0(R3)    R0=START OF REC
*MCALL #=   511 LV= 1               ENDIF 
*MCALL #=   512 LV= 2          ZSTREQU 
*MEXIT #=   512 LV= 2 ZSTREQU
#@IF_61_E                        DS 0H
*MEXIT #=   511 LV= 1 ENDIF
*MCALL #=   513 LV= 1          ENDIF 
*MCALL #=   514 LV= 2          ZSTREQU 
*MEXIT #=   514 LV= 2 ZSTREQU
#@IF_58_E                        DS 0H
*MEXIT #=   513 LV= 1 ENDIF
         L     R2,VAIX_ADDR
         USING IHAVAIX,R2
         A    R0,VAIXKOFF          R0=START OF  AIX KEY
         L    R1,VAIXKLEN          R1=LENGTH OF AIX KEY
         L    R14,VAIX_AREA
         MVC  0(8,R14),VAIX_XRBA   MOVE AIX XRBA TO AIX REC
         AHI  R14,8
         LR   R15,R1
         MVCL R14,R0               MOVE AIX KEY  TO AIX REC
         L    R14,VAIX_AREA        RPI 1130
*MCALL #=   515 LV= 1          ZSORT PUT,REC=(R14)       SENT AIX REC TX
               O ZSORT
         DS    0H
         LR    1,R14
         LA    0,2   PUT
         SVC   X'A1' ZSORT R0=1-ISORT,2-PUT,3=GET R15= 4 AT EOF
*MEXIT #=   515 LV= 1 ZSORT
         DROP  R2
*MCALL #=   516 LV= 1          PEXIT 
         B     PUT_AIX_SORT_REC-4
*MEXIT #=   516 LV= 1 PEXIT
*
* GET_AIX_SORT_REC
*
*MCALL #=   517 LV= 1 GET_AIX_SORT_REC PENTRY 
         DC    0H'0',CL8'GET_AIX_SORT_REC'
         B     *+4
GET_AIX_SORT_REC EQU *
*MEXIT #=   517 LV= 1 PENTRY
*MCALL #=   518 LV= 1          ZSORT GET,REC=(R3)        GET SORTED AIXX
                REC FROM ZSORT
         DS    0H
         LR    1,R3
         LA    0,3   GET
         SVC   X'A1' ZSORT R0=1-ISORT,2-PUT,3=GET R15= 4 AT EOF
*MEXIT #=   518 LV= 1 ZSORT
*MCALL #=   519 LV= 1          IF    (CHI,R15,NE,0)
*MCALL #=   520 LV= 2          ZSTREQU 
*MEXIT #=   520 LV= 2 ZSTREQU
         CHI   R15,0
         BC    15-NE,#@IF_62_2
*MEXIT #=   519 LV= 1 IF
               MVI AIX_EOF,TRUE
*MCALL #=   521 LV= 1          ENDIF 
*MCALL #=   522 LV= 2          ZSTREQU 
*MEXIT #=   522 LV= 2 ZSTREQU
#@IF_62_2                                                DS 0H
*MEXIT #=   521 LV= 1 ENDIF
*MCALL #=   523 LV= 1          PEXIT 
         B     GET_AIX_SORT_REC-4
*MEXIT #=   523 LV= 1 PEXIT
*
* PUT RECORD TO OUTFILE QSAM OR VSAM FILE
*
*MCALL #=   524 LV= 1 PUT      PENTRY 
         DC    0H'0',CL8'PUT'
         B     *+4
PUT      EQU   *
*MEXIT #=   524 LV= 1 PENTRY
*MCALL #=   525 LV= 1          IF    (CLI,OUTFILET,EQ,C'Q')  PUT TO QSAX
               M DCB
*MCALL #=   526 LV= 2          ZSTREQU 
*MEXIT #=   526 LV= 2 ZSTREQU
         CLI   OUTFILET,C'Q'
         BC    15-EQ,#@IF_63_2
*MEXIT #=   525 LV= 1 IF
*
*              PUT SEQ RECORD
*
               MVC  OUTFILEQ+DCBSYNAD-IHADCB(4),=A(ERR31)   RPI 688
*MCALL #=   527 LV= 1                SHOWCB RPL=INFILER,AREA=VLEN,LENGTX
               H=4,FIELDS=(RECLEN)
*MCALL #=   528 LV= 2          ZSHOWCB INFILER,RPLLREC-IHARPL,VLEN,0,4
         L     0,INFILER+RPLLREC-IHARPL
         ST    0,VLEN+0
*MEXIT #=   528 LV= 2 ZSHOWCB
         SR    15,15 RC=0
*MEXIT #=   527 LV= 1 SHOWCB
               L    R2,VLEN
*MCALL #=   529 LV= 1                IF   (CLI,VAR,EQ,TRUE)
*MCALL #=   530 LV= 2          ZSTREQU 
*MEXIT #=   530 LV= 2 ZSTREQU
         CLI   VAR,TRUE
         BC    15-EQ,#@IF_64_2
*MEXIT #=   529 LV= 1 IF
*MCALL #=   531 LV= 1                     IF   (CLI,RR,EQ,TRUE)
*MCALL #=   532 LV= 2          ZSTREQU 
*MEXIT #=   532 LV= 2 ZSTREQU
         CLI   RR,TRUE
         BC    15-EQ,#@IF_65_2
*MEXIT #=   531 LV= 1 IF
*MCALL #=   533 LV= 1                          IF   (CLC,RECFM_OVF,EQ,=X
               C'RV')
*MCALL #=   534 LV= 2          ZSTREQU 
*MEXIT #=   534 LV= 2 ZSTREQU
         CLC   RECFM_OVF,=C'RV'
         BC    15-EQ,#@IF_66_2
*MEXIT #=   533 LV= 1 IF
                              AHI  R2,8      ADD 8 BYTE PREFIX RRN,LEN
                              ST   R2,0(R3)    SET LLLL FULL WORD LEN
                              MVC  4(4,R3),KEY SET RRV  FULL WORD RRN
                              ST   R2,OUTFILEQ+DCBLRECLF-IHADCB
*MCALL #=   535 LV= 1                          ELSE 
*MCALL #=   536 LV= 2          ZSTREQU 
*MEXIT #=   536 LV= 2 ZSTREQU
        B      #@IF_66_E
#@IF_66_2                                                DS 0H
*MEXIT #=   535 LV= 1 ELSE
                              AHI  R2,4
*MCALL #=   537 LV= 1                               IF   (CH,R2,LE,=H'3X
               2760')
*MCALL #=   538 LV= 2          ZSTREQU 
*MEXIT #=   538 LV= 2 ZSTREQU
         CH    R2,=H'32760'
         BC    15-LE,#@IF_67_2
*MEXIT #=   537 LV= 1 IF
                                   SLL  R2,16
                                   ST   R2,0(R3) SET LL00 LENGTH
*MCALL #=   539 LV= 1                               ELSE 
*MCALL #=   540 LV= 2          ZSTREQU 
*MEXIT #=   540 LV= 2 ZSTREQU
        B      #@IF_67_E
#@IF_67_2                                                DS 0H
*MEXIT #=   539 LV= 1 ELSE
                                   B    ERR31
*MCALL #=   541 LV= 1                               ENDIF 
*MCALL #=   542 LV= 2          ZSTREQU 
*MEXIT #=   542 LV= 2 ZSTREQU
#@IF_67_E                        DS 0H
*MEXIT #=   541 LV= 1 ENDIF
*MCALL #=   543 LV= 1                          ENDIF 
*MCALL #=   544 LV= 2          ZSTREQU 
*MEXIT #=   544 LV= 2 ZSTREQU
#@IF_66_E                        DS 0H
*MEXIT #=   543 LV= 1 ENDIF
*MCALL #=   545 LV= 1                     ELSE 
*MCALL #=   546 LV= 2          ZSTREQU 
*MEXIT #=   546 LV= 2 ZSTREQU
        B      #@IF_65_E
#@IF_65_2                                                DS 0H
*MEXIT #=   545 LV= 1 ELSE
*MCALL #=   547 LV= 1                          IF   (CLI,VL32,EQ,TRUE)
*MCALL #=   548 LV= 2          ZSTREQU 
*MEXIT #=   548 LV= 2 ZSTREQU
         CLI   VL32,TRUE
         BC    15-EQ,#@IF_68_2
*MEXIT #=   547 LV= 1 IF
                              AHI  R2,4
                              ST   R2,0(R3)    SET LLLL FULL WORD LEN
                              ST   R2,OUTFILEQ+DCBLRECLF-IHADCB
*MCALL #=   549 LV= 1                          ELSE 
*MCALL #=   550 LV= 2          ZSTREQU 
*MEXIT #=   550 LV= 2 ZSTREQU
        B      #@IF_68_E
#@IF_68_2                                                DS 0H
*MEXIT #=   549 LV= 1 ELSE
                              AHI  R2,4
*MCALL #=   551 LV= 1                               IF   (CH,R2,LE,=H'3X
               2760')
*MCALL #=   552 LV= 2          ZSTREQU 
*MEXIT #=   552 LV= 2 ZSTREQU
         CH    R2,=H'32760'
         BC    15-LE,#@IF_69_2
*MEXIT #=   551 LV= 1 IF
                                   SLL  R2,16
                                   ST   R2,0(R3) SET LL00 LENGTH
*MCALL #=   553 LV= 1                               ELSE 
*MCALL #=   554 LV= 2          ZSTREQU 
*MEXIT #=   554 LV= 2 ZSTREQU
        B      #@IF_69_E
#@IF_69_2                                                DS 0H
*MEXIT #=   553 LV= 1 ELSE
                                   B    ERR31
*MCALL #=   555 LV= 1                               ENDIF 
*MCALL #=   556 LV= 2          ZSTREQU 
*MEXIT #=   556 LV= 2 ZSTREQU
#@IF_69_E                        DS 0H
*MEXIT #=   555 LV= 1 ENDIF
*MCALL #=   557 LV= 1                          ENDIF 
*MCALL #=   558 LV= 2          ZSTREQU 
*MEXIT #=   558 LV= 2 ZSTREQU
#@IF_68_E                        DS 0H
*MEXIT #=   557 LV= 1 ENDIF
*MCALL #=   559 LV= 1                     ENDIF 
*MCALL #=   560 LV= 2          ZSTREQU 
*MEXIT #=   560 LV= 2 ZSTREQU
#@IF_65_E                        DS 0H
*MEXIT #=   559 LV= 1 ENDIF
*MCALL #=   561 LV= 1                ELSE 
*MCALL #=   562 LV= 2          ZSTREQU 
*MEXIT #=   562 LV= 2 ZSTREQU
        B      #@IF_64_E
#@IF_64_2                                                DS 0H
*MEXIT #=   561 LV= 1 ELSE
*MCALL #=   563 LV= 1                     IF  (CLC,RECFM_OVF,EQ,=C'RF')
*MCALL #=   564 LV= 2          ZSTREQU 
*MEXIT #=   564 LV= 2 ZSTREQU
         CLC   RECFM_OVF,=C'RF'
         BC    15-EQ,#@IF_70_2
*MEXIT #=   563 LV= 1 IF
                        MVC  0(4,R3),KEY
*MCALL #=   565 LV= 1                     ENDIF 
*MCALL #=   566 LV= 2          ZSTREQU 
*MEXIT #=   566 LV= 2 ZSTREQU
#@IF_70_2                                                DS 0H
*MEXIT #=   565 LV= 1 ENDIF
*MCALL #=   567 LV= 1                ENDIF 
*MCALL #=   568 LV= 2          ZSTREQU 
*MEXIT #=   568 LV= 2 ZSTREQU
#@IF_64_E                        DS 0H
*MEXIT #=   567 LV= 1 ENDIF
*MCALL #=   569 LV= 1                IF   (CLI,BUFF,EQ,TRUE)
*MCALL #=   570 LV= 2          ZSTREQU 
*MEXIT #=   570 LV= 2 ZSTREQU
         CLI   BUFF,TRUE
         BC    15-EQ,#@IF_71_2
*MEXIT #=   569 LV= 1 IF
*MCALL #=   571 LV= 1                     PM   PUT_BUFF
         MVC   PUT_BUFF-2(2),*+10
         B     PUT_BUFF
         DC    S(*+2)
*MEXIT #=   571 LV= 1 PM
*MCALL #=   572 LV= 1                ELSE 
*MCALL #=   573 LV= 2          ZSTREQU 
*MEXIT #=   573 LV= 2 ZSTREQU
        B      #@IF_71_E
#@IF_71_2                                                DS 0H
*MEXIT #=   572 LV= 1 ELSE
*MCALL #=   574 LV= 1                     PUT  OUTFILEQ,(R3)
         LA    1,OUTFILEQ
*MCALL #=   575 LV= 2          ZOPTLR 0,R3
         LR    0,R3
*MEXIT #=   575 LV= 2 ZOPTLR
         SVC  152 QSAM PUT R0=REC, R1=DCB
*MEXIT #=   574 LV= 1 PUT
*MCALL #=   576 LV= 1                ENDIF 
*MCALL #=   577 LV= 2          ZSTREQU 
*MEXIT #=   577 LV= 2 ZSTREQU
#@IF_71_E                        DS 0H
*MEXIT #=   576 LV= 1 ENDIF
*MCALL #=   578 LV= 1          ELSE 
*MCALL #=   579 LV= 2          ZSTREQU 
*MEXIT #=   579 LV= 2 ZSTREQU
        B      #@IF_63_E
#@IF_63_2                                                DS 0H
*MEXIT #=   578 LV= 1 ELSE
*
*              PUT VSAM RECORD
*
               AP   PTOTREC,=P'1'
*MCALL #=   580 LV= 1                IF   (CLI,VAR,EQ,TRUE)
*MCALL #=   581 LV= 2          ZSTREQU 
*MEXIT #=   581 LV= 2 ZSTREQU
         CLI   VAR,TRUE
         BC    15-EQ,#@IF_72_2
*MEXIT #=   580 LV= 1 IF
*MCALL #=   582 LV= 1                     IF    (CLI,RR,EQ,TRUE)
*MCALL #=   583 LV= 2          ZSTREQU 
*MEXIT #=   583 LV= 2 ZSTREQU
         CLI   RR,TRUE
         BC    15-EQ,#@IF_73_2
*MEXIT #=   582 LV= 1 IF
*MCALL #=   584 LV= 1                           IF    (CLC,RECFM_OVF,EQX
               ,=C'RV'
*MCALL #=   585 LV= 2          ZSTREQU 
*MEXIT #=   585 LV= 2 ZSTREQU
         CLC   RECFM_OVF,=C'RV'
         BC    15-EQ,#@IF_74_2
*MEXIT #=   584 LV= 1 IF
                                MVC   KEY,4(R3) SET RRN
                                L     R0,0(R3)  GET LENGTH
                                AHI   R0,-8
*MCALL #=   586 LV= 1                           ELSE 
*MCALL #=   587 LV= 2          ZSTREQU 
*MEXIT #=   587 LV= 2 ZSTREQU
        B      #@IF_74_E
#@IF_74_2                                                DS 0H
*MEXIT #=   586 LV= 1 ELSE
                                L     R0,KEY
                                AHI   R0,1
                                ST    R0,KEY
                                L     R0,0(R3)  GET LENGTH
                                SRL   R0,16
                                AHI   R0,-4
*MCALL #=   588 LV= 1                           ENDIF 
*MCALL #=   589 LV= 2          ZSTREQU 
*MEXIT #=   589 LV= 2 ZSTREQU
#@IF_74_E                        DS 0H
*MEXIT #=   588 LV= 1 ENDIF
*MCALL #=   590 LV= 1                     ELSE 
*MCALL #=   591 LV= 2          ZSTREQU 
*MEXIT #=   591 LV= 2 ZSTREQU
        B      #@IF_73_E
#@IF_73_2                                                DS 0H
*MEXIT #=   590 LV= 1 ELSE
*MCALL #=   592 LV= 1                           IF    (CLI,VL32,EQ,TRUEX
               )
*MCALL #=   593 LV= 2          ZSTREQU 
*MEXIT #=   593 LV= 2 ZSTREQU
         CLI   VL32,TRUE
         BC    15-EQ,#@IF_75_2
*MEXIT #=   592 LV= 1 IF
                                L     R0,0(R3)
*MCALL #=   594 LV= 1                           ELSE 
*MCALL #=   595 LV= 2          ZSTREQU 
*MEXIT #=   595 LV= 2 ZSTREQU
        B      #@IF_75_E
#@IF_75_2                                                DS 0H
*MEXIT #=   594 LV= 1 ELSE
                                LH    R0,0(R3)
*MCALL #=   596 LV= 1                           ENDIF 
*MCALL #=   597 LV= 2          ZSTREQU 
*MEXIT #=   597 LV= 2 ZSTREQU
#@IF_75_E                        DS 0H
*MEXIT #=   596 LV= 1 ENDIF
                          AHI   R0,-4
*MCALL #=   598 LV= 1                     ENDIF 
*MCALL #=   599 LV= 2          ZSTREQU 
*MEXIT #=   599 LV= 2 ZSTREQU
#@IF_73_E                        DS 0H
*MEXIT #=   598 LV= 1 ENDIF
*MCALL #=   600 LV= 1                     MODCB RPL=OUTFILER,RECLEN=(R0X
               )   RPI 688
*MCALL #=   601 LV= 2          ZMODCB OUTFILER,RPLLREC-IHARPL,(R0),4
         ST    R0,OUTFILER+RPLLREC-IHARPL
*MEXIT #=   601 LV= 2 ZMODCB
         SR    15,15
*MEXIT #=   600 LV= 1 MODCB
*MCALL #=   602 LV= 1                ELSE 
*MCALL #=   603 LV= 2          ZSTREQU 
*MEXIT #=   603 LV= 2 ZSTREQU
        B      #@IF_72_E
#@IF_72_2                                                DS 0H
*MEXIT #=   602 LV= 1 ELSE
*MCALL #=   604 LV= 1                     IF  (CLC,RECFM_OVF,EQ,=C'RF')
*MCALL #=   605 LV= 2          ZSTREQU 
*MEXIT #=   605 LV= 2 ZSTREQU
         CLC   RECFM_OVF,=C'RF'
         BC    15-EQ,#@IF_76_2
*MEXIT #=   604 LV= 1 IF
                        MVC  KEY,0(R3)
*MCALL #=   606 LV= 1                     ELSE 
*MCALL #=   607 LV= 2          ZSTREQU 
*MEXIT #=   607 LV= 2 ZSTREQU
        B      #@IF_76_E
#@IF_76_2                                                DS 0H
*MEXIT #=   606 LV= 1 ELSE
                        L     R0,KEY
                        AHI   R0,1
                        ST    R0,KEY
*MCALL #=   608 LV= 1                     ENDIF 
*MCALL #=   609 LV= 2          ZSTREQU 
*MEXIT #=   609 LV= 2 ZSTREQU
#@IF_76_E                        DS 0H
*MEXIT #=   608 LV= 1 ENDIF
*MCALL #=   610 LV= 1                ENDIF 
*MCALL #=   611 LV= 2          ZSTREQU 
*MEXIT #=   611 LV= 2 ZSTREQU
#@IF_72_E                        DS 0H
*MEXIT #=   610 LV= 1 ENDIF
*MCALL #=   612 LV= 1                PUT  RPL=OUTFILER
         LA    1,OUTFILER
         LA    0,RPLOPPUT
         SVC   121 VSAM PUT R0=2 R1=A(RPL)
*MEXIT #=   612 LV= 1 PUT
*MCALL #=   613 LV= 1                IF  (LTR,R15,NE,R15)
*MCALL #=   614 LV= 2          ZSTREQU 
*MEXIT #=   614 LV= 2 ZSTREQU
         LTR   R15,R15
         BC    15-NE,#@IF_77_2
*MEXIT #=   613 LV= 1 IF
                   B  ERR32
*MCALL #=   615 LV= 1                ENDIF 
*MCALL #=   616 LV= 2          ZSTREQU 
*MEXIT #=   616 LV= 2 ZSTREQU
#@IF_77_2                                                DS 0H
*MEXIT #=   615 LV= 1 ENDIF
*MCALL #=   617 LV= 1          ENDIF 
*MCALL #=   618 LV= 2          ZSTREQU 
*MEXIT #=   618 LV= 2 ZSTREQU
#@IF_63_E                        DS 0H
*MEXIT #=   617 LV= 1 ENDIF
*MCALL #=   619 LV= 1          PEXIT 
         B     PUT-4
*MEXIT #=   619 LV= 1 PEXIT
*
*  GET NEXT SEQ EF, EV, RF, OR RV RECORD FROM BUFFER FOR INFILEQ
*  AND MOVE IT TO (R3)
*
*MCALL #=   620 LV= 1 GET_BUFF PENTRY 
         DC    0H'0',CL8'GET_BUFF'
         B     *+4
GET_BUFF EQU   *
*MEXIT #=   620 LV= 1 PENTRY
*MCALL #=   621 LV= 1          IF    (CLI,VAR,EQ,TRUE)
*MCALL #=   622 LV= 2          ZSTREQU 
*MEXIT #=   622 LV= 2 ZSTREQU
         CLI   VAR,TRUE
         BC    15-EQ,#@IF_78_2
*MEXIT #=   621 LV= 1 IF
*MCALL #=   623 LV= 1                IF  (CHI,R9,LT,4)
*MCALL #=   624 LV= 2          ZSTREQU 
*MEXIT #=   624 LV= 2 ZSTREQU
         CHI   R9,4
         BC    15-LT,#@IF_79_2
*MEXIT #=   623 LV= 1 IF
*MCALL #=   625 LV= 1                    PM  READ_BUFF
         MVC   READ_BUFF-2(2),*+10
         B     READ_BUFF
         DC    S(*+2)
*MEXIT #=   625 LV= 1 PM
*MCALL #=   626 LV= 1                ENDIF 
*MCALL #=   627 LV= 2          ZSTREQU 
*MEXIT #=   627 LV= 2 ZSTREQU
#@IF_79_2                                                DS 0H
*MEXIT #=   626 LV= 1 ENDIF
               L   R2,0(R10)     R2=VAR LEN
*MCALL #=   628 LV= 1          ELSE 
*MCALL #=   629 LV= 2          ZSTREQU 
*MEXIT #=   629 LV= 2 ZSTREQU
        B      #@IF_78_E
#@IF_78_2                                                DS 0H
*MEXIT #=   628 LV= 1 ELSE
               L   R2,INFILEQ+DCBLRECLF-IHADCB R9=FIXED LEN
*MCALL #=   630 LV= 1          ENDIF 
*MCALL #=   631 LV= 2          ZSTREQU 
*MEXIT #=   631 LV= 2 ZSTREQU
#@IF_78_E                        DS 0H
*MEXIT #=   630 LV= 1 ENDIF
*MCALL #=   632 LV= 1          IF    (CR,R2,GT,R9)
*MCALL #=   633 LV= 2          ZSTREQU 
*MEXIT #=   633 LV= 2 ZSTREQU
         CR    R2,R9
         BC    15-GT,#@IF_80_2
*MEXIT #=   632 LV= 1 IF
*MCALL #=   634 LV= 1                PM  READ_BUFF
         MVC   READ_BUFF-2(2),*+10
         B     READ_BUFF
         DC    S(*+2)
*MEXIT #=   634 LV= 1 PM
*MCALL #=   635 LV= 1          ENDIF 
*MCALL #=   636 LV= 2          ZSTREQU 
*MEXIT #=   636 LV= 2 ZSTREQU
#@IF_80_2                                                DS 0H
*MEXIT #=   635 LV= 1 ENDIF
*MCALL #=   637 LV= 1          IF    (SR,R9,M,R2)
*MCALL #=   638 LV= 2          ZSTREQU 
*MEXIT #=   638 LV= 2 ZSTREQU
         SR    R9,R2
         BC    15-M,#@IF_81_2
*MEXIT #=   637 LV= 1 IF
               B   ERR21       BUFF RESIDNUAL NEG ERROR
*MCALL #=   639 LV= 1          ENDIF 
*MCALL #=   640 LV= 2          ZSTREQU 
*MEXIT #=   640 LV= 2 ZSTREQU
#@IF_81_2                                                DS 0H
*MEXIT #=   639 LV= 1 ENDIF
         LR    R0,R3
         LR    R1,R2
         LR    R11,R1
         MVCL  R0,R10
*MCALL #=   641 LV= 1          PEXIT 
         B     GET_BUFF-4
*MEXIT #=   641 LV= 1 PEXIT
*
*  READ_BUFF - MOVE RESIDUAL TO FRONT OF BUFFER AND THEN FILL BUFFER
*
*MCALL #=   642 LV= 1 READ_BUFF PENTRY 
         DC    0H'0',CL8'READ_BUFF'
         B     *+4
READ_BUFF EQU  *
*MEXIT #=   642 LV= 1 PENTRY
         L    R0,ABUFF
         LR   R1,R9
         LR   R11,R1
         MVCL R0,R10         MOVE ANY RESIDUAL IN BUFFER TO FRONT
         LR   R10,R0         END OF RESIDUAL IN BUFFER
         LG   R0,INFILEQL    64 BIT LENGTH OF QFILE REMAINING
*MCALL #=   643 LV= 1          IF   (LTGR,R0,EQ,R0)  IS IT EOF
*MCALL #=   644 LV= 2          ZSTREQU 
*MEXIT #=   644 LV= 2 ZSTREQU
         LTGR  R0,R0
         BC    15-EQ,#@IF_82_2
*MEXIT #=   643 LV= 1 IF
*MCALL #=   645 LV= 1               IF  (C,R10,EQ,ABUFF)
*MCALL #=   646 LV= 2          ZSTREQU 
*MEXIT #=   646 LV= 2 ZSTREQU
         C     R10,ABUFF
         BC    15-EQ,#@IF_83_2
*MEXIT #=   645 LV= 1 IF
                  B   EOF
*MCALL #=   647 LV= 1               ELSE 
*MCALL #=   648 LV= 2          ZSTREQU 
*MEXIT #=   648 LV= 2 ZSTREQU
        B      #@IF_83_E
#@IF_83_2                                                DS 0H
*MEXIT #=   647 LV= 1 ELSE
                  B   ERR21    EOF WITH RESIDUAL ERROR
*MCALL #=   649 LV= 1               ENDIF 
*MCALL #=   650 LV= 2          ZSTREQU 
*MEXIT #=   650 LV= 2 ZSTREQU
#@IF_83_E                        DS 0H
*MEXIT #=   649 LV= 1 ENDIF
*MCALL #=   651 LV= 1          ENDIF 
*MCALL #=   652 LV= 2          ZSTREQU 
*MEXIT #=   652 LV= 2 ZSTREQU
#@IF_82_2                                                DS 0H
*MEXIT #=   651 LV= 1 ENDIF
         SGR  R1,R1
         L    R1,LBUFF
         SR   R1,R9         RG1=LENGTH OF READ TO FILL BUFFER
*MCALL #=   653 LV= 1          IF   (CGR,R0,LT,R1)
*MCALL #=   654 LV= 2          ZSTREQU 
*MEXIT #=   654 LV= 2 ZSTREQU
         CGR   R0,R1
         BC    15-LT,#@IF_84_2
*MEXIT #=   653 LV= 1 IF
              LR   R1,R0
              SGR  R0,R0
*MCALL #=   655 LV= 1          ELSE 
*MCALL #=   656 LV= 2          ZSTREQU 
*MEXIT #=   656 LV= 2 ZSTREQU
        B      #@IF_84_E
#@IF_84_2                                                DS 0H
*MEXIT #=   655 LV= 1 ELSE
              SGR  R0,R1
*MCALL #=   657 LV= 1          ENDIF 
*MCALL #=   658 LV= 2          ZSTREQU 
*MEXIT #=   658 LV= 2 ZSTREQU
#@IF_84_E                        DS 0H
*MEXIT #=   657 LV= 1 ENDIF
         STG  R0,INFILEQL    UPDATE REMAINING FILE LENGTH
         AR   R9,R1         R11=LENGTH OF DATA IN BUFFER
         ST   R1,INFILEQ+DCBLRECLF-IHADCB  SET BUFF LRECL
*MCALL #=   659 LV= 1          GET  INFILEQ,(R10) FILL BUFF BEYOND RESIX
               DUAL
         LA    1,INFILEQ
*MCALL #=   660 LV= 2          ZOPTLR 0,R10
         LR    0,R10
*MEXIT #=   660 LV= 2 ZOPTLR
         SVC  151
*MEXIT #=   659 LV= 1 GET
         ST   R2,INFILEQ+DCBLRECLF-IHADCB  RESET CUR LRECL
         L    R10,ABUFF     RESET TO START OF BUFF
*MCALL #=   661 LV= 1          PEXIT 
         B     READ_BUFF-4
*MEXIT #=   661 LV= 1 PEXIT
*
*  PUT NEXT SEQ EF, EV, RF, OR RV RECORD TO BUFFER FOR OUTFILEQ
*  FROM (R3) FOR LENGTH OF DCBLRECLF
*
*MCALL #=   662 LV= 1 PUT_BUFF PENTRY 
         DC    0H'0',CL8'PUT_BUFF'
         B     *+4
PUT_BUFF EQU   *
*MEXIT #=   662 LV= 1 PENTRY
         L     R2,OUTFILEQ+DCBLRECLF-IHADCB   R1=LENGTH
*MCALL #=   663 LV= 1          IF    (CR,R2,GT,R9)  FLUSH BUFFER IF RCDX
                DOESN'T FIT
*MCALL #=   664 LV= 2          ZSTREQU 
*MEXIT #=   664 LV= 2 ZSTREQU
         CR    R2,R9
         BC    15-GT,#@IF_85_2
*MEXIT #=   663 LV= 1 IF
*MCALL #=   665 LV= 1                PM   WRITE_BUFF
         MVC   WRITE_BUFF-2(2),*+10
         B     WRITE_BUFF
         DC    S(*+2)
*MEXIT #=   665 LV= 1 PM
               L     R10,ABUFF      RESET BUFF PTR
               L     R9,LBUFF      RESET BUFF REMAINING
*MCALL #=   666 LV= 1          ENDIF 
*MCALL #=   667 LV= 2          ZSTREQU 
*MEXIT #=   667 LV= 2 ZSTREQU
#@IF_85_2                                                DS 0H
*MEXIT #=   666 LV= 1 ENDIF
         SR    R9,R2         REDUCE REMAINING BUFF AVAIL
         LR    R0,R3
         LR    R1,R2
         LR    R11,R1
         MVCL  R10,R0         ADD RECORD TO BUFFER
*MCALL #=   668 LV= 1          PEXIT 
         B     PUT_BUFF-4
*MEXIT #=   668 LV= 1 PEXIT
*
* WRITE DATA IN BUFFER
*
*MCALL #=   669 LV= 1 WRITE_BUFF PENTRY 
         DC    0H'0',CL8'WRITE_BUFF'
         B     *+4
WRITE_BUFF EQU *
*MEXIT #=   669 LV= 1 PENTRY
         L     R0,ABUFF        R0=A(BUFF)
         LR    R1,R10
         SR    R1,R0           R1=LENGTH OF RCDS IN BUFF
         ST    R1,OUTFILEQ+DCBLRECLF-IHADCB  SET BUFF LRECL
*MCALL #=   670 LV= 1          PUT   OUTFILEQ,(0)    WRITE BUFFER
         LA    1,OUTFILEQ
*MCALL #=   671 LV= 2          ZOPTLR 0,0
*MEXIT #=   671 LV= 2 ZOPTLR
         SVC  152 QSAM PUT R0=REC, R1=DCB
*MEXIT #=   670 LV= 1 PUT
         ST    R2,OUTFILEQ+DCBLRECLF-IHADCB  RESTORE CUR LRECL
*MCALL #=   672 LV= 1          PEXIT 
         B     WRITE_BUFF-4
*MEXIT #=   672 LV= 1 PEXIT
*
* ABORT ERROR ROUTINES
*
*MCALL #=   673 LV= 1 ERR11    WTO   'REPRO OPEN INFILE QSAM FAILED'
ERR11    DS    0H
         BRAS  1,*+(WTO#0673_EOT-*+1)/2*2
         DC    AL2(WTO#0673_EOT-*,0),C'REPRO OPEN INFILE QSAM FAILED'
WTO#0673_EOT     EQU *
         SVC   35
*MEXIT #=   673 LV= 1 WTO
*MCALL #=   674 LV= 1          ABEND 11,DUMP
         LA   1,11
         OILH 1,X'8000'
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   674 LV= 1 ABEND
*MCALL #=   675 LV= 1 ERR12    WTO   'REPRO OPEN INFILE VSAM FAILED'
ERR12    DS    0H
         BRAS  1,*+(WTO#0675_EOT-*+1)/2*2
         DC    AL2(WTO#0675_EOT-*,0),C'REPRO OPEN INFILE VSAM FAILED'
WTO#0675_EOT     EQU *
         SVC   35
*MEXIT #=   675 LV= 1 WTO
*MCALL #=   676 LV= 1          ABEND 12,DUMP
         LA   1,12
         OILH 1,X'8000'
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   676 LV= 1 ABEND
*MCALL #=   677 LV= 1 ERR13    WTO   'REPRO OPEN OUTFILE QSAM FAILED'
ERR13    DS    0H
         BRAS  1,*+(WTO#0677_EOT-*+1)/2*2
         DC    AL2(WTO#0677_EOT-*,0),C'REPRO OPEN OUTFILE QSAM FAILED'
WTO#0677_EOT     EQU *
         SVC   35
*MEXIT #=   677 LV= 1 WTO
*MCALL #=   678 LV= 1          ABEND 13,DUMP
         LA   1,13
         OILH 1,X'8000'
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   678 LV= 1 ABEND
*MCALL #=   679 LV= 1 ERR14    WTO   'REPRO OPEN OUTFILE VSAM FAILED'
ERR14    DS    0H
         BRAS  1,*+(WTO#0679_EOT-*+1)/2*2
         DC    AL2(WTO#0679_EOT-*,0),C'REPRO OPEN OUTFILE VSAM FAILED'
WTO#0679_EOT     EQU *
         SVC   35
*MEXIT #=   679 LV= 1 WTO
*MCALL #=   680 LV= 1          ABEND 14,DUMP
         LA   1,14
         OILH 1,X'8000'
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   680 LV= 1 ABEND
*MCALL #=   681 LV= 1 ERR21    WTO   'REPRO GET INFILE QSAM FAILED'
ERR21    DS    0H
         BRAS  1,*+(WTO#0681_EOT-*+1)/2*2
         DC    AL2(WTO#0681_EOT-*,0),C'REPRO GET INFILE QSAM FAILED'
WTO#0681_EOT     EQU *
         SVC   35
*MEXIT #=   681 LV= 1 WTO
*MCALL #=   682 LV= 1          ABEND 21,DUMP
         LA   1,21
         OILH 1,X'8000'
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   682 LV= 1 ABEND
*MCALL #=   683 LV= 1 ERR22    WTO   'REPRO GET INFILE VSAM FAILED'
ERR22    DS    0H
         BRAS  1,*+(WTO#0683_EOT-*+1)/2*2
         DC    AL2(WTO#0683_EOT-*,0),C'REPRO GET INFILE VSAM FAILED'
WTO#0683_EOT     EQU *
         SVC   35
*MEXIT #=   683 LV= 1 WTO
*MCALL #=   684 LV= 1          ABEND 22,DUMP
         LA   1,22
         OILH 1,X'8000'
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   684 LV= 1 ABEND
*MCALL #=   685 LV= 1 ERR31    WTO   'REPRO PUT OUTFILE QSAM FAILED'
ERR31    DS    0H
         BRAS  1,*+(WTO#0685_EOT-*+1)/2*2
         DC    AL2(WTO#0685_EOT-*,0),C'REPRO PUT OUTFILE QSAM FAILED'
WTO#0685_EOT     EQU *
         SVC   35
*MEXIT #=   685 LV= 1 WTO
*MCALL #=   686 LV= 1          ABEND 31,DUMP
         LA   1,31
         OILH 1,X'8000'
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   686 LV= 1 ABEND
*MCALL #=   687 LV= 1 ERR32    WTO   'REPRO PUT OUTFILE VSAM FAILED'
ERR32    DS    0H
         BRAS  1,*+(WTO#0687_EOT-*+1)/2*2
         DC    AL2(WTO#0687_EOT-*,0),C'REPRO PUT OUTFILE VSAM FAILED'
WTO#0687_EOT     EQU *
         SVC   35
*MEXIT #=   687 LV= 1 WTO
*MCALL #=   688 LV= 1          ABEND 32,DUMP
         LA   1,32
         OILH 1,X'8000'
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   688 LV= 1 ABEND
*MCALL #=   689 LV= 1 ERR41    WTO   'REPRO CLOSE INFILE QSAM FAILED'
ERR41    DS    0H
         BRAS  1,*+(WTO#0689_EOT-*+1)/2*2
         DC    AL2(WTO#0689_EOT-*,0),C'REPRO CLOSE INFILE QSAM FAILED'
WTO#0689_EOT     EQU *
         SVC   35
*MEXIT #=   689 LV= 1 WTO
*MCALL #=   690 LV= 1          ABEND 41,DUMP
         LA   1,41
         OILH 1,X'8000'
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   690 LV= 1 ABEND
*MCALL #=   691 LV= 1 ERR42    WTO   'REPRO CLOSE INFILE VSAM FAILED'
ERR42    DS    0H
         BRAS  1,*+(WTO#0691_EOT-*+1)/2*2
         DC    AL2(WTO#0691_EOT-*,0),C'REPRO CLOSE INFILE VSAM FAILED'
WTO#0691_EOT     EQU *
         SVC   35
*MEXIT #=   691 LV= 1 WTO
*MCALL #=   692 LV= 1          ABEND 42,DUMP
         LA   1,42
         OILH 1,X'8000'
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   692 LV= 1 ABEND
*MCALL #=   693 LV= 1 ERR43    WTO   'REPRO CLOSE OUTFILE QSAM FAILED'
ERR43    DS    0H
         BRAS  1,*+(WTO#0693_EOT-*+1)/2*2
         DC    AL2(WTO#0693_EOT-*,0),C'REPRO CLOSE OUTFILE QSAM FAILED'
WTO#0693_EOT     EQU *
         SVC   35
*MEXIT #=   693 LV= 1 WTO
*MCALL #=   694 LV= 1          ABEND 43,DUMP
         LA   1,43
         OILH 1,X'8000'
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   694 LV= 1 ABEND
*MCALL #=   695 LV= 1 ERR44    WTO   'REPRO CLOSE OUTFILE VSAM FAILED'
ERR44    DS    0H
         BRAS  1,*+(WTO#0695_EOT-*+1)/2*2
         DC    AL2(WTO#0695_EOT-*,0),C'REPRO CLOSE OUTFILE VSAM FAILED'
WTO#0695_EOT     EQU *
         SVC   35
*MEXIT #=   695 LV= 1 WTO
*MCALL #=   696 LV= 1          ABEND 44,DUMP
         LA   1,44
         OILH 1,X'8000'
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   696 LV= 1 ABEND
*MCALL #=   697 LV= 1 ERR51    WTO   'REPRO RECORD LENGTH TOO LARGE FORX
                QSAM'
ERR51    DS    0H
         BRAS  1,*+(WTO#0697_EOT-*+1)/2*2
         DC    AL2(WTO#0697_EOT-*,0),C'REPRO RECORD LENGTH TOO LARGE FOX
               R QSAM'
WTO#0697_EOT     EQU *
         SVC   35
*MEXIT #=   697 LV= 1 WTO
*MCALL #=   698 LV= 1          ABEND 51,DUMP
         LA   1,51
         OILH 1,X'8000'
         SVC  13 ABEND R1=COMP CODE AND HIGH BIT = DUMP PGM STORAGE
*MEXIT #=   698 LV= 1 ABEND
*
* QSAM DCB AND VSAM ACB CB'S
*
*MCALL #=   699 LV= 1 INFILEQ  DCB   DDNAME=INFILE,RECFM=F,LRECL=0,MACRX
               F=GM,EODAD=EOF
INFILEQ  DS    0D             RPI 915
         DC    XL(DCBLEN)'00' RPI 946
         ORG   INFILEQ+DCBID-IHADCB        RPI88
         DC    C'DCBV1001'            RPI88
         ORG   INFILEQ+DCBDSORG-IHADCB
         DC    AL1(DCBDSORG_PS) DCBDSORG
         ORG   INFILEQ+DCBEODAD-IHADCB
         DC    A(EOF) DCBEODAD
         ORG   INFILEQ+DCBRECFM-IHADCB
         DC    AL1(DCBRECFM_F) DCBRECFM
         ORG   INFILEQ+DCBDDNAM-IHADCB
         DC    CL8'INFILE' DCBDDNAM
         ORG   INFILEQ+DCBOFLGS-IHADCB
         DC    AL1(0) DCBOFLGS RPI 668 ZERO (SET AT OPEN)
         ORG   INFILEQ+DCBMACRF-IHADCB
         DC    AL2(DCBMACRF_GM) DCBMACRF
         ORG   INFILEQ+DCBSYNAD-IHADCB
         DC    A(0) DCBSYNAD DCBSYNAD
         ORG   INFILEQ+DCBBLKSIF-IHADCB    RPI 587
         DC    F'0' DCBBLKSIF  RPI 587
         ORG   INFILEQ+DCBLRECLF-IHADCB    RPI 587
         DC    F'0' DCBLRECLF    RPI 587
         ORG   INFILEQ+DCBREC-IHADCB
         DC    A(0) DCBREC
         ORG   INFILEQ+DCBDSNAM-IHADCB
         DC    A(0) DCBDSNAM
         ORG   INFILEQ+DCBDCBE-IHADCB   RPI 281
         DC    A(0) DCBDCBE
         ORG   INFILEQ+DCBIO-IHADCB     RPI 907
         DC    A(0)     DCBIO      RPI 907 TOTAL IO COUNT SINCE OPEN
         ORG   INFILEQ+DCBLEN
*MCALL #=   700 LV= 2          DCBD 
*MEXIT #=   700 LV= 2 DCBD
*MEXIT #=   699 LV= 1 DCB
*MCALL #=   701 LV= 1 INFILEV  ACB   DDNAME=INFILE,MACRF=(SEQ,IN)
INFILEV  DS    0D
         DC    X'A0'                    ACBID    VSAM VS VTAM
         DC    X'11'                    ACBSTYPE 11-1F VSAM 20-2F VTAM
         DC    AL2(ACBEND-IHAACB)       ACBLEN   ACB LENGTH
         DC    A(0)                     ACBAMBL  ACCESS METHOD PARMS
         DC    A(0)                     ACBIFR   VTAM INTERFACE ROUTINE
*MCALL #=   702 LV= 2          ZGENMACF MACRF=(SEQ,IN)
*MEXIT #=   702 LV= 2 ZGENMACF
         DC    B'10010100' ACBMACF1
         DC    B'00000000' ACBMACF2
         DC    B'00000000' ACBMACF3
         DC    B'00000000' ACBMACF4
         DC    X'00'                    ACBOFLAGS OPEN FLAGS
         DC    XL3'00'                  ALIGNMENT
         DC    CL8'INFILE'
*
* ACB Z390 EXTENSIONS
*
         DC    A(0)               ACBDSNAM  DSNAME FOR VCDT.390
         DC    CL8'INFILEV'                  ACBVCLRN  ACB LABEL DEF VCX
               LR
         DC    A(0)                     ACBVCLRA  ADDR OF VCLR ENTRY
         DC    A(0)                     ACBVAIXA  ADDR OF VAIX PTH ENT
         DC    F'0'                     ACBDCBN   NUMBER OF DCBS OPEN
         DC    A(0)                     ACBDCBA   ADDR OF DCB TABLE
         DC    F'0'                     ACBOPENC  UNIQUE ACB OPEN COUNT
*MCALL #=   703 LV= 2          ACBD 
IHAACB   DSECT 
ACBID    DS    X              X'A0'  = VSAM VS VTAM
ACBSTYPE DS    X              X'11-1F' = VSAM SUBTYPES
ACBLEN   DS    H              LENGTH OF ACB
ACBAMBL  DS    A              AMB LIST POINTER
ACBIFR   DS    A              VTAM INTERFACE ROUTINE (O FOR VSAM)
ACBMACRF DS    F              MACRO ACCESS TYPE FLAGS
         ORG   *-4
ACBMACR1 DS    X              MACRF FLAGS BYTE 1
ACBMACR1_KEY    EQU X'80' KEY ACCESS TO KS OR RR
ACBMACR1_ADR    EQU X'40' RBA ADDRESS ACCESS TO KS OR ES
ACBMACR1_CNV    EQU X'20' CONTROL INTERAL ACCESS(NOT SUPPORTED)
ACBMACR1_SEQ    EQU X'10' SEQUENTIAL ACCESS TO KS, ES, RR
ACBMACR1_DIR    EQU X'08' DIRECT     ACCESS TO KS, ES, RR
ACBMACR1_IN     EQU X'04' INPUT ONLY FROM KS, ES, RR
ACBMACR1_OUT    EQU X'02' OUTPUT ADD, UPDATE, DELETE KS,ES,RR
ACBMACR1_UBF    EQU X'01' USER BUFFER MGT - USE AREA   (IGNORED)
ACBMACR2 DS    X              MACRF FLAGS BYTE 2
ACBMACR2_SKP    EQU X'80' SKIP SEQUENTIAL ACCESS TO KS, RR
ACBMACR2_NLOGON EQU X'40' NO LOGON REQUIRED - ALWAYS   (IGNORED)
ACBMACR2_RST    EQU X'20' DATA SET REUSABLE - ALWAYS   (IGNORED)
ACBMACR2_DSN    EQU X'10' SUBTASK SHARING BASED ON DSN (IGNORED)
ACBMACR2_AIX    EQU X'08' PROCESS ALT. INDEX VS BASE   (IGNORED)
ACBMACR2_LSR    EQU X'04' LOCAL SHARED RESOURCES       (IGNORED)
ACBMACR2_GSR    EQU X'02' GLOBAL SHARED RESOURCES      (IGNORED)
ACBMACR2_ICI    EQU X'01' IMPROVE CONTROL INT. PROC.   (IGNORED)
ACBMACR3 DS    X              MACRF FLAGS BYTE 3
ACBMACR3_DFR    EQU X'80' DEFERR PUT'S UNTIL WRTBFR    (IGNORED)
ACBMACR3_SIS    EQU X'40' SEQUENTIAL INSERT STRATEGY   (IGNORED)
ACBMACR3_CFX    EQU X'20' FIX CBS AND BUFFERS          (IGNORED)
ACBMACR4 DS    X              MACRF FLAGS BYTE 4
ACBOFLGS DS    X              OPEN FLAGS
ACBOPEN  EQU   X'80'          ACB IS OPEN
ACBGET   EQU   X'40'          GET ALLOWED
ACBPUT   EQU   X'20'          PUT ALLOWED
ACBAIXP  EQU   X'10'          USE PATH AIX KEY VERSUS PRIMARY KEY
ACBAIXU  EQU   X'08'          UPGRADE AIX INDEXES (SEE VPTH OPTION)
         DS    XL3            ALIGNMENT
ACBDDNAM DS    CL8            DDNAME > ENV VAR > VCDT_NAME[.VCLR/VPTH]
*
* ACB Z390 EXTENSIONS
*
ACBDSNAM DS    A              ADDRESS OF USER SUPPLIED VCDT[.VCLR/VPTH]
ACBVCLRN DS    CL8            VCLR NAME LABEL (CAT.VCLR MAY OVERRIDE)
ACBVCLRA DS    A              ADDRESS VCLR CLUSTER ENTRY IN VCDT CAT
ACBVAIXA DS    A              ADDRESS VAIX FOR ALTERNATE PATH  ACCESS
ACBDCBT  DS    F              TOTAL DCBS FOR VES,VX0, AND VXN UGRADES
ACBDCBA  DS    A              ADDR OF DYN ALLOC DCB TABLE
ACBOPENC DS    F              UNIQUE ACB OPEN COUNT FOR RPL RESET
ACBEND   EQU  *
REPRO           CSECT 
*MEXIT #=   703 LV= 2 ACBD
*MCALL #=   704 LV= 2          DCBD 
*MEXIT #=   704 LV= 2 DCBD
*MEXIT #=   701 LV= 1 ACB
*MCALL #=   705 LV= 1 INFILER  RPL   ACB=INFILEV,OPTCD=(SEQ),ARG=KEY
INFILER  DS    0D
*MCALL #=   706 LV= 2          ZGENOPTD OPTCD=(SEQ)
*MEXIT #=   706 LV= 2 ZGENOPTD
         DC    AL1(0)             RPLTYPE   RPL ID
         DC    AL1(10)            RPLSTYPE  RPL TYPE VSAM
         DC    AL1(RPLEND-IHARPL) RPLLEN    RPL LENGTH
         DC    X'00'              (ALIGN)
         DC    A(0)            RPLECB    ECB (POSTED IF PRESENT)
         DC    XL4'00'            RPLFEEDBK RPL FEEDBACK CODES
         DC    A(0)         RPLKEYLEN KEY LENGTH
         DC    A(INFILEV)            RPLACB    ACB
         DC    A(0)           RPLAREA   AREA
         DC    A(KEY)            RPLARG    ARG (KS KEY, RR NUM)
         DC    B'0010000000000000' RPLOPT OPTION BYTES 1+2
         DC    X'0000'            (ALIGN)
         DC    A(0)         RPLNEXT   NEXT RPL
         DC    A(0)         RPLRECL   RECORD LENGTH FOR PUT
         DC    XL8'00'            RPLLXRBA  LAST RCD VES/VX0 XRBA
         DC    XL8'00'            RPLCXRBA  CURR POS VES/VX0 XRBA
         DC    A(0)               RPLOPENC  UNIQUE ACB OPEN COUNT
         DC    A(0)        RPLAREAL  AREA LENGTH
         DC    F'0'               RPLFLAG   UPD GETOK,GETNF FLAGS ETC
         DC    XL8'00'            RPLKSIT   CURRENT KSIT XRBA
         DC    XL8'00'            RPLKSIR   CURRENT KSIR XRBA
*MCALL #=   707 LV= 2          RPLD 
IHARPL   DSECT 
RPLID    DS   X   RPL ID
RPLSTYPE DS   X   RPL TYPE VSAM
RPLLEN   DS   X   RPL LENGTH
         DS   X   (ALIGN)
RPLECB   DS   F   ECB ADDRESS (POSTED IF PRESENT)
RPLFEEDB DS   XL4 RPL FEEDBACK CODES (PDF,RC,COMP,REASON CODE)
RPLLKEY  DS   A   KEY LENGTH
RPLACB   DS   A   ACB
RPLAREA  DS   A   AREA
RPLARG   DS   A   ARG (KSDS KEY, RRDS REC NUMBER, OR RBA/XRBA)
RPLOPTCD DS   0H  OPTION BYTES 1 AND 2
RPLOPT1  DS   X   OPTION BYTE 1
RPLOPT1_LOC   EQU X'80' - leave record from GET in I/O buffer (IG)
RPLOPT1_DIR   EQU X'40' - direct access to RRDS, KSDS, or ESDS
RPLOPT1_SEQ   EQU X'20' - Sequential access to RRDS, KSDS, or ESDS
RPLOPT1_SKP   EQU X'10' - Skip sequential access.
RPLOPT1_ASY   EQU X'08' - Asynchronous access (ignored)
RPLOPT1_KGE   EQU X'04' - key GE, for RRDS rel rcd > max returns EOD
RPLOPT1_GEN   EQU X'02' - A generic key provided with RPLKEYL length
RPLOPT1_XRBA  EQU X'01' - for ADR, use 8 vs 4 byte RBA in ARG field
RPLOPT2  DS   X   OPTION BYTE 2
RPLOPT2_KEY   EQU X'80' - rel rcd RRDS access or key KSDS access
RPLOPT2_ADR   EQU X'40' - addressed access to KSDS or ESDS by RBA
RPLOPT2_CNV   EQU X'20' - control intervAL access (not supported)
RPLOPT2_BWD   EQU X'10' - proceed backward for KEY, SEQ, DIR
RPLOPT2_LRD   EQU X'08' - locate last record in the data set
RPLOPT2_WAITX EQU X'04' - if SYN and UPAD, take UPAD exit vs WAIT
RPLOPT2_UPD   EQU X'02' - rcds may be updated or deleted after GET
RPLOPT2_NSP   EQU X'01' - For DIR, remember position for seq access
         DS   H   (ALIGN)
RPLNEXT  DS   A   NEXT RPL
RPLLREC  DS   A   RECORD LENGTH FOR GET/PUT VAR LENGTH RECORDS
RPLLXRBA DS   XL8 XRBA OF LAST REC VES (ESDS,RRDS) OR VX0 (KSDS,VRRDS)
RPLCXRBA DS   XL8 XRBA OF CURR POS VES (ESDS,RRDS) OR VX0 (KSDS,VRRDS)
RPLOPENC DS   F   UNIQUE ACB OPEN COUNT TO DETECT RPL REPOSITION REQ'D
RPLLAREA DS   F   AREA LENGTH
RPLFLAG  DS   0F  RPL FLAG BITS FOR UPD GET ETC.
RPLFLAG1 DS   X
RPLF1GOK EQU  X'80' PREV GET SUCCESSFUL
RPLF1GNF EQU  X'40' PREV GET RECORD NOT FOUND
RPLFLAG2 DS   X
RPLFLAG3 DS   X
RPLFLAG4 DS   X
RPLKSIT  DS   XL8 XRBA OF KSIT KSDS INSERT TOP OF TREE CONTROL BLOCK
RPLKSIR  DS   XL8 XBRA OF KSIR KSDS INSERT CUR RECORD  CONTROL BLOCK
RPLEND   EQU *
*
* VSAM RPL SVC 97 AND OPEN/CLOSE ACB OPCODES IN R0
*
RPLOPGET  EQU  1 GET
RPLOPPUT  EQU  2 PUT
RPLOPERA  EQU  3 ERASE
RPLOPPNT  EQU  4 POINT
REPRO          CSECT 
*MEXIT #=   707 LV= 2 RPLD
*MEXIT #=   705 LV= 1 RPL
*MCALL #=   708 LV= 1 OUTFILEQ DCB   DDNAME=OUTFILE,RECFM=F,LRECL=0,MACX
               RF=PM
OUTFILEQ DS    0D             RPI 915
         DC    XL(DCBLEN)'00' RPI 946
         ORG   OUTFILEQ+DCBID-IHADCB        RPI88
         DC    C'DCBV1001'            RPI88
         ORG   OUTFILEQ+DCBDSORG-IHADCB
         DC    AL1(DCBDSORG_PS) DCBDSORG
         ORG   OUTFILEQ+DCBEODAD-IHADCB
         DC    A(0) DCBEODAD
         ORG   OUTFILEQ+DCBRECFM-IHADCB
         DC    AL1(DCBRECFM_F) DCBRECFM
         ORG   OUTFILEQ+DCBDDNAM-IHADCB
         DC    CL8'OUTFILE' DCBDDNAM
         ORG   OUTFILEQ+DCBOFLGS-IHADCB
         DC    AL1(0) DCBOFLGS RPI 668 ZERO (SET AT OPEN)
         ORG   OUTFILEQ+DCBMACRF-IHADCB
         DC    AL2(DCBMACRF_PM) DCBMACRF
         ORG   OUTFILEQ+DCBSYNAD-IHADCB
         DC    A(0) DCBSYNAD DCBSYNAD
         ORG   OUTFILEQ+DCBBLKSIF-IHADCB    RPI 587
         DC    F'0' DCBBLKSIF  RPI 587
         ORG   OUTFILEQ+DCBLRECLF-IHADCB    RPI 587
         DC    F'0' DCBLRECLF    RPI 587
         ORG   OUTFILEQ+DCBREC-IHADCB
         DC    A(0) DCBREC
         ORG   OUTFILEQ+DCBDSNAM-IHADCB
         DC    A(0) DCBDSNAM
         ORG   OUTFILEQ+DCBDCBE-IHADCB   RPI 281
         DC    A(0) DCBDCBE
         ORG   OUTFILEQ+DCBIO-IHADCB     RPI 907
         DC    A(0)     DCBIO      RPI 907 TOTAL IO COUNT SINCE OPEN
         ORG   OUTFILEQ+DCBLEN
*MCALL #=   709 LV= 2          DCBD 
*MEXIT #=   709 LV= 2 DCBD
*MEXIT #=   708 LV= 1 DCB
*MCALL #=   710 LV= 1 OUTFILEV ACB   DDNAME=OUTFILE,MACRF=(SEQ,OUT)
OUTFILEV DS    0D
         DC    X'A0'                    ACBID    VSAM VS VTAM
         DC    X'11'                    ACBSTYPE 11-1F VSAM 20-2F VTAM
         DC    AL2(ACBEND-IHAACB)       ACBLEN   ACB LENGTH
         DC    A(0)                     ACBAMBL  ACCESS METHOD PARMS
         DC    A(0)                     ACBIFR   VTAM INTERFACE ROUTINE
*MCALL #=   711 LV= 2          ZGENMACF MACRF=(SEQ,OUT)
*MEXIT #=   711 LV= 2 ZGENMACF
         DC    B'10010010' ACBMACF1
         DC    B'00000000' ACBMACF2
         DC    B'00000000' ACBMACF3
         DC    B'00000000' ACBMACF4
         DC    X'00'                    ACBOFLAGS OPEN FLAGS
         DC    XL3'00'                  ALIGNMENT
         DC    CL8'OUTFILE'
*
* ACB Z390 EXTENSIONS
*
         DC    A(0)               ACBDSNAM  DSNAME FOR VCDT.390
         DC    CL8'OUTFILEV'                  ACBVCLRN  ACB LABEL DEF VX
               CLR
         DC    A(0)                     ACBVCLRA  ADDR OF VCLR ENTRY
         DC    A(0)                     ACBVAIXA  ADDR OF VAIX PTH ENT
         DC    F'0'                     ACBDCBN   NUMBER OF DCBS OPEN
         DC    A(0)                     ACBDCBA   ADDR OF DCB TABLE
         DC    F'0'                     ACBOPENC  UNIQUE ACB OPEN COUNT
*MCALL #=   712 LV= 2          ACBD 
*MEXIT #=   712 LV= 2 ACBD
*MCALL #=   713 LV= 2          DCBD 
*MEXIT #=   713 LV= 2 DCBD
*MEXIT #=   710 LV= 1 ACB
*MCALL #=   714 LV= 1 OUTFILER RPL   ACB=OUTFILEV,OPTCD=(SEQ),ARG=KEY
OUTFILER DS    0D
*MCALL #=   715 LV= 2          ZGENOPTD OPTCD=(SEQ)
*MEXIT #=   715 LV= 2 ZGENOPTD
         DC    AL1(0)             RPLTYPE   RPL ID
         DC    AL1(10)            RPLSTYPE  RPL TYPE VSAM
         DC    AL1(RPLEND-IHARPL) RPLLEN    RPL LENGTH
         DC    X'00'              (ALIGN)
         DC    A(0)            RPLECB    ECB (POSTED IF PRESENT)
         DC    XL4'00'            RPLFEEDBK RPL FEEDBACK CODES
         DC    A(0)         RPLKEYLEN KEY LENGTH
         DC    A(OUTFILEV)            RPLACB    ACB
         DC    A(0)           RPLAREA   AREA
         DC    A(KEY)            RPLARG    ARG (KS KEY, RR NUM)
         DC    B'0010000000000000' RPLOPT OPTION BYTES 1+2
         DC    X'0000'            (ALIGN)
         DC    A(0)         RPLNEXT   NEXT RPL
         DC    A(0)         RPLRECL   RECORD LENGTH FOR PUT
         DC    XL8'00'            RPLLXRBA  LAST RCD VES/VX0 XRBA
         DC    XL8'00'            RPLCXRBA  CURR POS VES/VX0 XRBA
         DC    A(0)               RPLOPENC  UNIQUE ACB OPEN COUNT
         DC    A(0)        RPLAREAL  AREA LENGTH
         DC    F'0'               RPLFLAG   UPD GETOK,GETNF FLAGS ETC
         DC    XL8'00'            RPLKSIT   CURRENT KSIT XRBA
         DC    XL8'00'            RPLKSIR   CURRENT KSIR XRBA
*MCALL #=   716 LV= 2          RPLD 
*MEXIT #=   716 LV= 2 RPLD
*MEXIT #=   714 LV= 1 RPL
*
* LOGICAL SWITCHES
*
MOD      DC    AL1(FALSE) ADD VSAM RECORDS IF [DISP=MOD] ON OUTFILE
VAR      DC    AL1(FALSE) VARIABLE LENGTH RECORDS
RR       DC    AL1(FALSE) RELATIVE RECORD FILE
VL32     DC    AL1(TRUE)  VARIABLE LENGTH RECRODS WITH 32 BIT LENGTHS
BUFF     DC    AL1(FALSE) USE BUFFER FOR EF, EV, RF, RV SEQ FORMATS
BUILDAIX DC    AL1(FALSE) CREATE ALATERNATE INDEX FROM BASE CLUSER
AIX_EOF  DC    AL1(FALSE) END OF AIX SORT INPUT RPI 865
TRUE     EQU   1
FALSE    EQU   0
*
* WORK AREAS
*
INFILEQL DC    D'0'  64 BIT LENGTH OF INFILEQ
ABUFF    DC    A(0) ADDRESS AND LENGTH OF BUFFER
LBUFF    DC    F'500000' 500K BUFFER OR MAX RCD+8
KEY      DC    F'0'  RRN FOR RRVS/VRRDS
PWORK    DC    D'0'
PTOTREC  DC    PL4'0'
WTO_RECFM DC    AL2(WTO_RECFM_END-*,0)
         DC    C'REPRO RECFM='
RECFM_OVF DC   C'XX'
         DC    C' LRECL ='
DLRECL   DC    C' 1234567'
WTO_RECFM_END EQU *
WTO_TOTREC DC  AL2(WTO_TOTREC_END-*,0)
         DC    C' REPRO TOTAL RECORDS ='
DTOTREC  DC    C' 1234567'
WTO_TOTREC_END   EQU   *
INFILET  DC    C'Q' QSAM OR VSAM
OUTFILET DC    C'Q' QSAM OR VSAM
INFILEDD DC    C'INFILE',X'00'
OUTFILEDD DC   C'OUTFILE',X'00'
FDBK     DS    X  RPL REASON CODE
VLEN     DC    F'0'
VCATFSA  DC    A(0)
VCATDSN  DC    CL256' '
VCAT390  DC    C'.390',X'00'
PER_BRK_CHAR DC C'X'  PERIOD, BRACKET, OR NULL TERM CHAR
PER_BRK_ADDR DC A(0)  ADDR OF TERM CHAR
FIND_PER_BRK_NULL DC 256X'00'
         ORG   FIND_PER_BRK_NULL+X'00'
         DC    X'FF' STOP ON SOURCE NULL
         ORG   FIND_PER_BRK_NULL+C'.'
FIND_PER DC    C'.' STOP ON SOURCE PERIOD
         ORG   FIND_PER_BRK_NULL+C'['
         DC    C'[' STOP ON SOURCE BRACKET
         ORG 
VCDT_ADDR DC   A(0) ADDR OF VCAM CATALOG TABEL (IHAVCDT)
VAIX_ADDR DC   A(0) AIX ENTRY IN VSAM CATALOG  (IHAVAIX)
VAIX_NAME DC   CL8' ' NAME OF AIX TO FIND IN CATALOG RPI 865
VAIX_LRECL DC  F'0'   XRBA + AIX KEY LENGTH
VAIX_KLEN  DC  F'0'   AIX KEY LENGTH
VAIX_XRBA  DC  XL8'0' AIX  XRBA OF PRIMARY RECORD
VAIX_AREA  DC  A(0)   AIX  RECORD AREA
VSAM_LRECL DC  F'0'   VSAM LRECL
VSAM_AREA  DC  A(0)   VSAM RECORD AREA
         LTORG 
*MCALL #=   717 LV= 1          EQUREGS 
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
*MEXIT #=   717 LV= 1 EQUREGS
*MCALL #=   718 LV= 1          VCDTD 
*
* IHAVCDT VSAM CATALOG DEFINITION TABLE(vcdt) DSECT
*
IHAVCDT  DSECT 
VCDTID   DS    CL4   C'VCDT' ID
VCDTNAME DS    CL8   NAME OF VSAM CATALOG
VCDTCLRT DS    F     TOTAL CLR BASE CLUSTERS
VCDTCLRA DS    A     ADDR  CLR BASE CLUSTER TABLE
VCDTAIXT DS    F     TOTAL AIX ALTERNATE INDEXES
VCDTAIXA DS    A     ADDR  AIX ALTERNATE INDEXES
VCDTPTHT DS    F     TOTAL PTH PATHS
VCDTPTHA DS    A     ADDR  PTH PATH TABLE
VCDTDCBA DS    A     ADDR  MODEL DCB FOR VES/VX0/VXN ACCESS
*
* IHAVCLR VSAM BASE CLUSTER DSECT
*
IHAVCLR  DSECT 
VCLRID   DS    CL4   ID C'VCLR'
VCLRNAME DS    CL8   NAME OF BASE CLUSTER
VCLRTYPE DS    CL4   TYPE OF BASE CLUSTER (ESDS/RRDS/KSDS/LDS)
VCLRFLAG DS    0F    OPTION FLAGS
VCLRFLG1 DS    X     VCDT OPTION BYTE 1
VCLRVREC EQU   X'80' RECFM=V VARIABLE LENGTH VS FIXED
VCLRRUSE EQU   X'40' REUSE OPTION RESETS EOF TO 0 AT ACB OPEN
VCLRKSDS EQU   X'08' KSDS KEY SEQUENCED (DEF) VIA VXN INDEXES
VCLRRRDS EQU   X'04' RRDS RELATIVE RECORD     VIA VX0 INDEX
VCLRESDS EQU   X'02' ESDS ENTRY SEQUENCED     VIA VX0 INDEX
VCLRLDS  EQU   X'01' LDS  LINEAR CI SEQUENCE  VIA VX0 INDEX
VCLRFLG2 DS    X     VCDT OPTION BYTE 2
VCLRFLG3 DS    X     VCDT OPTION BYTE 3
VCLRFLG4 DS    X     VCDT OPTION BYTE 4
VCLRLAVG DS    F     AVG RECORD LENGTH FOR VREC
VCLRLREC DS    F     MAX RECORD LENGTH (EXCLUDES 4 BYTE VREC LENGTH)
VCLRKLEN DS    F     KSDS PRIMARY KEY LENGTH
VCLRKOFF DS    F     KSDS PRIMARY KEY OFFSET
VCLRVESA DS    A     ADDR CLR VES DATA  OPTIONAL DSNAME (NAME.VES)
VCLRVX0A DS    A     ADDR CLR VX0 INDEX OPTIONAL DSNAME (NAME.VX0)
VCLRAIXN DS    F     NUMBER OF AIX'S WITH UPGRADE FOR THIS CLUSTER
VCLRAIXA DS    A     ADDR AIX UPGRADE TABLE OF VAIX ADDRESSES
VCLRCI   DS    A     OPTIONAL CI SIZE TO SUPPORT LINEAR ACCESS
VCLRLEN  EQU   *-IHAVCLR
*
* IHAVAIX ALTERNATE INDEX DSECT
*
IHAVAIX  DSECT 
VAIXID   DS    CL4   ID C'VAIX'
VAIXNAME DS    CL8   NAME OF ALTERNATE INDEX
VAIXRELN DS    CL8   NAME OF RELATED VCLR BASE CLUSTER
VAIXFLAG DS    0F    OPTION FLAGS
VAIXFLG1 DS    X     OPTION BYTE 1
VAIXRUSE EQU   X'80' REUSE OPTION RESETS EOF TO 0 AT ACB OPEN
VAIXUKEY EQU   X'40' INFORCE UNIQUE KSDS KEYS
VAIXUAIX EQU   X'20' UPGRADE AIX ON BASE CLUSTER CHANGES
VAIXFLG2 DS    X     OPTION BYTE 2
VAIXFLG3 DS    X     OPTION BYTE 3
VAIXFLG4 DS    X     OPTION BYTE 4
VAIXKLEN DS    F     KSDS AIX KEY LENGTH
VAIXKOFF DS    F     KSDS AIX KEY OFFSET
VAIXVXNA DS    A     ADDR AIX VXN OPTIONAL DSNAME (DEF. NAME.VXN)
VAIXRELA DS    A     ADDR RELATED VCLR BASE CLUSTER
VAIXLEN  EQU   *-IHAVAIX
*
* IHAVPTH PATH DSECT
*
IHAVPTH  DSECT 
VPTHID   DS    CL4 ID C'VPTH'
VPTHNAME DS    CL8 NAME OF PATH
VPTHENTN DS    CL8   NAME OF BASE CLUSTER OR ALTERNATE INDEX ENTRY
VPTHFLAG DS    0F    OPTION FLAGS
VPTHFLG1 DS    X     OPTION BYTE 1
VPTHAIXP EQU   X'80' ENTRY IS AIX PATH VS ALIAS CLUSTER NAME
VPTHAIXU EQU   X'40' UPDATE ALL UPGRADE AIX'S ON BASE CLUSTER CHANGES
VPTHFLG2 DS    X     OPTION BYTE 2
VPTHFLG3 DS    X     OPTION BYTE 3
VPTHFLG4 DS    X     OPTION BYTE 4
VPTHENTA DS    A     ADDR OF ENTRY VAIX OR VCLR CATALOG ENTRY
VPTHLEN  EQU   *-IHAVPTH
REPRO           CSECT 
*MEXIT #=   718 LV= 1 VCDTD
         END 
