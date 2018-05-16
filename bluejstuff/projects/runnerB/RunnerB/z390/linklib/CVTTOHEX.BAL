*********************************************************************
* Copyright 2006 Automated Software Tools Corporation               *
* This source code is part of z390 assembler/emulator package       *
* The z390 package is distributed under GNU general public license  *
* Author - Don Higgins                                              *
* Date   - 07/20/06                                                 *
*********************************************************************
* 07/20/06 RPI 374 - add CVTTOHEX for use in TESTFPC1
* 05/07/07 RPI 609 - fix DC CL9
* 08/12/07 RPI 674 - use single TROT to replace UNPK and TR loop
*********************************************************************
*
*  CALL CVTTOHEX,(IN,OUT,INLEN)
*
*    IN    - ADDR INPUT BYTES
*    OUT   - ADDR OUTPUT HEX EBCDIC BYTES
*    INLEN - COUNT OF BYTES TO CONVERT
*********************************************************************
         COPY  ASMMSP       STRUCTURED PROGRAM MACROS AND EQUS
         COPY ZSTRMAC  Z390 STRUCTURED PROGRAMMING MACROS
*MCALL #=     1 LV= 1 CVTTOHEX SUBENTRY 
CVTTOHEX CSECT 
         STM   14,12,12(13)
         BAL   15,104(15)
         DC    18F'0'
         DC    CL8'CVTTOHEX'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
         USING CVTTOHEX+8,13
*MEXIT #=     1 LV= 1 SUBENTRY
         LM    R3,R5,0(R1)  R3=IN, R4=OUT, R5=LENGTH OF INPUT
         LA    R1,TROTTAB 512 BYTE HEX TRANSLATE TABLE FOR TROT
         TROT  R4,R3,1 TRANS ONE TO TWO FROM (R3) TO (R4) NO TESTING
*MCALL #=     2 LV= 1          SUBEXIT 
         LA    15,0
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=     2 LV= 1 SUBEXIT
         PRINT DATA
TROTTAB  EQU   *
         DC    C'000102030405060708090A0B0C0D0E0F'
         DC    C'101112131415161718191A1B1C1D1E1F'
         DC    C'202122232425262728292A2B2C2D2E2F'
         DC    C'303132333435363738393A3B3C3D3E3F'
         DC    C'404142434445464748494A4B4C4D4E4F'
         DC    C'505152535455565758595A5B5C5D5E5F'
         DC    C'606162636465666768696A6B6C6D6E6F'
         DC    C'707172737475767778797A7B7C7D7E7F'
         DC    C'808182838485868788898A8B8C8D8E8F'
         DC    C'909192939495969798999A9B9C9D9E9F'
         DC    C'A0A1A2A3A4A5A6A7A8A9AAABACADAEAF'
         DC    C'B0B1B2B3B4B5B6B7B8B9BABBBCBDBEBF'
         DC    C'C0C1C2C3C4C5C6C7C8C9CACBCCCDCECF'
         DC    C'D0D1D2D3D4D5D6D7D8D9DADBDCDDDEDF'
         DC    C'E0E1E2E3E4E5E6E7E8E9EAEBECEDEEEF'
         DC    C'F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF'
         LTORG 
*MCALL #=     3 LV= 1          EQUREGS 
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
*MEXIT #=     3 LV= 1 EQUREGS
         END 
