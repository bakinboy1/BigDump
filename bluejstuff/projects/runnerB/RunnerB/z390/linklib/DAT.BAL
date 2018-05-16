 TITLE 'DAT - DATE AND TIME SUBROUTINE'
**********************************************************************
*  AUTHOR.    DON HIGGINS.
*  DATE.      04/01/85.
**********************************************************************
* 03/21/08 DSH1 UPGRADE FROM PC/370 TO Z390 AFTER 23 YEARS
*  1.  DISPLAY DATE, TIME OF DAY, INSTRUCTION COUNTER, AND MIPS
*  2.  DISPLAY JDBC TIME-STAMP WITH NANO-SECOND EXTENSION USING TIME TS
*  3.  DISPLAY TOTAL Z390 INSTRUCTIONS EXECUTED USING TIME INS
*  4.  FOR REPEATED CALLS, CALCULATE AND DISPLAY MIP RATE FOR INTERVAL
**********************************************************************
*MCALL #=     1 LV= 1 DAT      SUBENTRY 
DAT      CSECT 
         STM   14,12,12(13)
         BAL   15,104(15)
         DC    18F'0'
         DC    CL8'DAT'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
         USING DAT+8,13
*MEXIT #=     1 LV= 1 SUBENTRY
*MCALL #=     2 LV= 1          TIME  TS,JDBCTS         GET JDBC TIME STX
               AMP WITH NANO-SEC EXT.
         LA    0,9 OBDC TIMESTAMP WITH 9 DIGIT NANOSECONDS
         LA    1,JDBCTS
         SVC   11 TIME AND DATE
*MEXIT #=     2 LV= 1 TIME
         LG    R3,NSPREV         R3 = PREV NS TIME
*MCALL #=     3 LV= 1          TIME  NS,NSTIME         GET TOD IN NANO-X
               SECONDS
         LA    0,8 NANOSECONDS - DOUBLE WORD BIT 63 NANO-SEC COUNTER
         LA    1,NSTIME
         SVC   11 TIME AND DATE
*MEXIT #=     3 LV= 1 TIME
         MVC   NSPREV,NSTIME     SAVE CURR NS TIME
         LG    R4,LASTINS        R4 = PREV INSTR COUNT
*MCALL #=     4 LV= 1          TIME  INS               R1 = CURR INSTR X
               COUNT
         LA    0,16 RPI 825 R1=INSTRUCTION COUNTER
         SVC   11 TIME AND DATE
*MEXIT #=     4 LV= 1 TIME
         STG   R1,LASTINS        SAVE CURR INSTR COUNT
         CVDG  R1,PWORK          CVT 64 BIT COUNT
         MVC   DINS,MASKINS
         ED    DINS,PWORK+10     DISPLAY LOW 11 DIGITS OF COUNT
         LTGR  R3,R3             IS PREV NSTIME ZERO
         BZ    NOMIPS            YES, SKIP MIP CALC
         LG    R0,NSTIME
         SGR   R0,R3
         BZ    NOMIPS            SKIP MIP CALC IF NANO-SEC INT = 0
         STG   R0,NSDIFF         SAVE ELAPSED TIME IN NANO-SECONDS
         LG    R1,LASTINS
         SGR   R1,R4            R1 = INSTR INTERVAL COUNT
         MSG   R1,=FL8'100000'  R1 = INSTR * 100,000
         DSG   R0,NSDIFF        R1 = MIPS * 100
 CVD   R1,PWORK
         MVC   DMIPS,MASKMIPS
         ED    DMIPS,PWORK+5
         B     DISPLAY
NOMIPS   DS    0H
         MVI   DMIPS,C' '
         MVC   DMIPS(L'DMIPS-1),DMIPS
DISPLAY  DS    0H
*MCALL #=     5 LV= 1          WTO   MF=(E,DATMSG)     DISPLAY TS, TOTAX
               L INSTRUCTIONS, MIPS
         LA    1,DATMSG
         SVC   35
*MEXIT #=     5 LV= 1 WTO
*MCALL #=     6 LV= 1          SUBEXIT 
         LA    15,0
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=     6 LV= 1 SUBEXIT
DATMSG   DC    AL2(MSGEND-*,0)
JDBCTS   DC    CL29' ',C' INS='
DINS     DC    C' ZZ,ZZZ,ZZZ,ZZZ',C' MIPS='
DMIPS    DC    C'   0.00'
MSGEND   EQU   *
PWORK    DC    PL16'0'
LASTINS  DC    FL8'0'
MASKINS  DC    C' ',X'2020',3AL1(C',',X'20',X'20',X'20')
MASKMIPS DC    C' ',X'202120',C'.',X'2020'
NSPREV   DC    FL8'0'  PREV NS
NSTIME   DC    FL8'0'  CURR NS
NSDIFF   DC    FL8'0'  NS IN INTERVAL
*MCALL #=     7 LV= 1          EQUREGS 
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
*MEXIT #=     7 LV= 1 EQUREGS
         LTORG 
         END 
