*MCALL #=     1 LV= 1          ARCHLVL 
         MNOTE 'ARCHLVL=7 ARCHSFX=G'
*MEXIT #=     1 LV= 1 ARCHLVL
*MCALL #=     2 LV= 1 fpconvrt FPCONVRT Type=Rsect,ArchLvl=7,Linkage=OSX
               ,Regs=GR
***********************************************************************
*        FPCON - Floating Point Conversion Request Block              *
*                                                                     *
*        For conversion from a string to a floating point value:      *
*        * ValueE, ValueD or ValueL will contain the result,          *
*          depending on the ValueLen. The result will be usable       *
*          only if the return code is less than 12.                   *
*        * StringAddr and StringSize must contain the address         *
*          and length of the string to be converted.                  *
*        * ValueLen must be set.                                      *
*        * If Base, Zero, Exponent, ExpAlt and Decimal                *
*          are not set, defaults will be provided.                    *
*                                                                     *
*        For conversion from a floating point value to a string:      *
*        * ValueE, ValueD or ValueL must contain the value to         *
*          be converted, depending on the ValueLen.                   *
*        * StringAddr and StringSize must contain the address         *
*          and length of the buffer to be used for the result.        *
*          StringLen will be set to the actual length of the          *
*          result if the return code is less than 8.                  *
*        * ValueLen must be set.                                      *
*        * If Base, Zero, Exponent, Decimal, Plus and Minus           *
*          are not set, defaults will be provided.                    *
*        * MaxDigits must be from 0 to 34.  If zero, a default        *
*          will be computed from the base and length.                 *
*        * MaxLeading must be non-negative.  Maximum leading          *
*          digits when using exponential notation.                    *
*        * MinDecimal must be -1 or greater. Minimum digits after     *
*          the decimal point. (-1: remove decimal point if no         *
*          non-zero decimal digits). Cannot be 0 or -1 if             *
*          MaxLeading is zero.                                        *
*        * MaxDecimal must be non-negative.  If positive, maximum     *
*          decimal digits (including leading zeros) without using     *
*          exponential notation.                                      *
*        * MinExpon must be 0-4.  If 0, exponent will be supressed    *
*          if zero.                                                   *
*        * If ValuePlus is not set, leading plus sign will be         *
*          supressed.                                                 *
*        * If ExponPlus is not set, leading exponent plus sign        *
*          will be supressed.                                         *
*                                                                     *
***********************************************************************
Fpcon        DSECT ,           Floating Point Conversion Request Block
FpconSave       DS 18FD           Save area used by FPCONVRT
FpconValueE     DS 0E              Short floating point value
FpconValueD     DS 0D              Long floating point value
FpconValueL     DS L               Extended floating point value
FpconStringAddr DS AD             Address of string buffer
FpconReturnCode DS F               Return code (output)
FpconRetOk     EQU 0                   Success
FpconRetUndFlo EQU 4                   String value is too small
FpconRetDenorm EQU 4                   FP value is denormalized
FpconRetOvrFlo EQU 8                   String value is too big
FpconRetInf    EQU 8                   IEEE FP value is an infinity
FpconRetNan    EQU 12                  IEEE FP value is a NAN
FpconRetBadStr EQU 12                  Invalid floating point string
FpconRetBadPrm EQU 16                  Invalid parameters
FpconStringSize DS H               Size of string buffer
FpconStringLen  DS H               Length of string (output)
*                                  Offset to bad character (RetBadStr)
FpconMaxDigits  DS H               Maximum non-zero digits generated
FpconMaxLeading DS H               Maximum digits before decimal point
FpconMinDecimal DS H               Minimum digits after decimal point
FpconMaxDecimal DS H               Maximum digits after decimal point
FpconMinExpon   DS H               Minimum exponent digits
FpconGenDigits  DS 0H              (Set/used by FPCONVERT)
FpconExponent10 DS H               Base 10 exponent (output)
FpconValueLen   DS FL1             Length of floating point value (in)
FpconValueLenE EQU 4                   Short
FpconValueLenD EQU 8                   Long
FpconValueLenL EQU 16                  Extended
FpconBase       DS FL1             Base of floating point value (in)
FpconBase2     EQU 2                   Binary IEEE-754 (default)
FpconBase10    EQU 10                  Decimal (IEEE-754r)
FpconBase16    EQU 16                  Hexadecimal S/360
FpconFlags      DS X               Flags (in)
FpconToValue   EQU X'40'               Convert string to value
*                                      (otherwise convert to string)
FpconValuePlus EQU X'20'               If leading mantissa plus sign
FpconExponPlus EQU X'10'               If leading exponent plus sign
FpconZeroPlus  EQU X'08'               If zero is always positive
FpconZeroSign  EQU X'04'               If zero can be negative
FpconFixedDec  EQU X'02'               Round decimals to fit
FpconRetDigits EQU X'01'               Return digits only (ecvt/fcvt)
FpconZero       DS C               ASCII or EBCDIC '0' character
FpconPlus       DS C               ASCII or EBCDIC '+' character
FpconMinus      DS C               ASCII or EBCDIC '-' character
FpconDecimal    DS C               ASCII or EBCDIC decimal point char.
FpconExponent   DS C               Exponent character
FpconExpAlt     DS C               Alternate exponent character
FpconBlank      DS C               (Set/used by FPCONVRT)
FpconNine       DS C               (Set/used by FPCONVRT)
FpconFive       DS C               (Set/used by FPCONVRT)
                DS 0d              Align to doubleword
FpconWork       DS XL2096          Internal work area
FpconEnd        DS 0d              End of request block
FpconLength    EQU *-Fpcon          length of request block
***********************************************************************
         PUSH  Print,NoPrint
         PRINT Off,NoPrint
         Macro
         BCTGR &R1,&R2
         aif   ('&R1' eq '0' or '&R1' eq 'R0').badr1
         aif   ('&R2' ne '0').badr2
         LAY   &R1,-1(,&R1)
         mexit
.badr1   Mnote 12,'First operand must not be register 0'
         mexit
.badr2   Mnote 12,'Second operand must be 0'
         Mend
         Macro
         AGHI  &R1,&V
         aif   ('&R1' eq '0' or '&R1' eq 'R0').badr1
         LAY   &R1,&V.(,&R1)
         mexit
.badr1   Mnote 12,'First operand must not be register 0'
         Mend
         POP   Print,NoPrint
FPCONVRT TITLE 'Floating Point Conversion - Module Entry'
         PRINT On,Gen,Data,Uhead
         ACONTROL Flag(0,Align,Cont,NoImplen,Page0,Substr)
FPCONVRT Rsect ,
FPCONVRT RMODE Any
FPCONVRT AMODE 64 - s/b Any64 but the z/OS binder does not like it.
FPCONVRT ALIAS C'fpconvrt'
         STMG  R14,R12,8(R13)      Save caller's registers
         LG    R1,0(,R1)           Get FPCON address
         LARL  R12,Static          Get static storage address
         STG   R13,128(,R1)        Save caller's save area address
         STG   R1,136(,R13)        Set forward chain
         MVC   4(4,R1),=C'F4SA'-Static(R12) Indicate format-4 save area
         LA    R13,0(,R1)          Get FPCON address
         XC    FpconWork-Fpcon(14*4,R1),FpconWork-Fpcon(R1)
         LMH   R14,R11,FpconWork-Fpcon(R1) Clear upper register halves
         USING (Fpcon,FpconEnd+1),R13
         USING (Static,StaticEnd),R12
         SPACE 1
         XC    FpconReturnCode,FpconReturnCode Hope all is OK
         LG    R1,FpconStringAddr  Get entire string address
         LA    R0,0(,R1)           Remove non-address bits
         CGIJE   R0,0,ReturnBadParm Null string address: branch
         CLGRJNE   R0,R1,ReturnBadParm Non-address bits: branch
         LH    R0,FpconStringSize  Get string length
         CIJNH R0,0,ReturnBadParm      bad: branch
         CLI   FpconValueLen,FpconValueLenE Valid length code?
         JE    Enter000                yes: branch
         CLI   FpconValueLen,FpconValueLenD
         JE    Enter000                yes: branch
         CLI   FpconValueLen,FpconValueLenL
         JNE   ReturnBadParm           no: branch
Enter000 DC    0h'0'
         CLI   FpconBase,FpconBase2 Valid base?
         JE    Enter005                yes: branch
         CLI   FpconBase,FpconBase10   *
         JE    Enter005                yes: branch
         CLI   FpconBase,FpconBase16   *
         JE    Enter005                yes: branch
         CLI   FpconBase,0             *
         JNE   ReturnBadParm           no: branch
         MVI   FpconBase,FpconBase2 Set default base
Enter005 DC    0h'0'
         SPACE 1
         LA    R1,ASCII            Assume ASCII
         USING (Charset,CharsetEnd),R1
         CLC   FpconZero,CsZero    Is character set ASCII?
         JE    Enter010
         LA    R1,EBCDIC           Assume EBCDIC
         CLC   FpconZero,CsZero    Is character set EBCDIC?
         JE    Enter010
         CLI   FpconZero,0         Default character set?
         JNE   ReturnBadParm           invalid: branch
         MVC   FpconZero,CsZero    Default is EBCDIC
         SPACE 1
Enter010 DC    0h'0'
         MVC   FpconFive,CsZero    Compute '5' character
         OI    FpconFive,5              *
         MVC   FpconNine,CsZero    Compute '9' character
         OI    FpconNine,9              *
         MVC   FpconBlank,CsBlank  Remember blank character
         CLC   FpconPlus,CsBlank   Plus symbol set?
         JH    Enter020                yes: branch
         MVC   FpconPlus,CsPlus    Set default plus symbol
Enter020 DC    0h'0'
         CLC   FpconMinus,CsBlank  Minus symbol set?
         JH    Enter030                yes: branch
         MVC   FpconMinus,CsMinus  Set default minus symbol
Enter030 DC    0h'0'
         CLC   FpconDecimal,CsBlank Decimal point symbol set?
         JH    Enter040                yes: branch
         MVC   FpconDecimal,CsDecimal Set default decimal point symbol
Enter040 DC    0h'0'
         CLC   FpconExponent,CsBlank Exponent character set?
         JH    Enter050                yes: branch
         MVC   FpconExponent,CsExponent Set default exponent character
Enter050 DC    0h'0'
         CLC   FpconExpAlt,CsBlank Alternate exponent character set?
         JH    Enter070                yes: branch
         CLC   FpconExponent,CsExponent Default exponent set?
         JNE   Enter060                no: branch
         MVC   FpconExpAlt,CsExpAlt Set default alternate to lowercase
         J     Enter070
Enter060 DC    0h'0'
         MVC   FpconExpAlt,FpconExponent Set alternate same as normal
Enter070 DC    0h'0'
         DROP  R1
         TM    FpconFlags,FpconToValue Convert string to value?
         JNZ   ToValue                 yes: branch
         SPACE 1
         LH    R0,FpconMaxDigits   Get maximum digits
         CIJH  R0,34,ReturnBadParm     invalid: branch
         LTR   R0,R0                   *
         JP    Enter120                valid: branch
         JM    ReturnBadParm           bad: branch
         SPACE 1
         CLI   FpconBase,FpconBase10 Decimal value?
         JE    Enter105                yes: branch
         LHI   R0,15               Get default for long (bin and hex)
         CLI   FpconValueLen,FpconValueLenD Long value?
         JE    Enter120                yes: branch
         CLI   FpconBase,FpconBase2 Binary value?
         JE    Enter110                yes: branch
         LHI   R0,6                Get default for short hex
         CLI   FpconValueLen,FpconValueLenE Short value?
         JE    Enter120                yes: branch
         LHI   R0,32               Get default for extended hex
         J     Enter120
Enter105 DC    0h'0'
         LHI   R0,16               Get default for long decimal
         CLI   FpconValueLen,FpconValueLenD Long value?
         JE    Enter120                yes: branch
Enter110 DC    0h'0'
         LHI   R0,7                Get default for short binary/decimal
         CLI   FpconValueLen,FpconValueLenE Short value?
         JE    Enter120                yes: branch
         LHI   R0,34               Get default for ext. binary/decimal
Enter120 DC    0h'0'
         STH   R0,FpconGenDigits   Return maximum digits
         SPACE 1
         LH    R1,FpconMaxDecimal  Get maximum decimal digits
         CIJL  R1,0,ReturnBadParm      bad: branch
         CRJH  R0,R1,Enter130      Get greater of the
         LR    R0,R1                   two values in R0
Enter130 DC    0h'0'
         LH    R1,FpconMaxLeading  Get maximum leading digits
         CIJL  R1,0,ReturnBadParm      bad: branch
         LH    R2,FpconMinDecimal  Get minimum decimal digits
         CHI   R2,-1                   *
         JL    ReturnBadParm           bad: branch
         JE    Enter140                -1: branch
         AR    R1,R2               Get leading + trailing
Enter140 DC    0h'0'
         CRJH  R0,R1,Enter150      Get string size
         LR    R0,R1                   *
Enter150 DC    0h'0'                   *
         LHI   R1,1                Get extra bytes needed
         TM    FpconFlags,FpconRetDigits Format result?
         JNZ   Enter155                no: branch
         LHI   R1,8                    *
Enter155 DC    0h'0'                   *
         AR    R0,R1               Add extra bytes needed
         CH    R0,FpconStringSize  Buffer big enough?
         JH    ReturnBadParm           no: branch
         SPACE 1
         CIJH  R2,0,Enter160       Min. decimal digits positive: branch
         LH    R0,FpconMaxLeading  Is maximum leading digits zero?
         CIJNH R0,0,ReturnBadParm      yes: branch
         SPACE 1
Enter160 DC    0h'0'
         TM    FpconFlags,FpconFixedDec Fixed length decimal?
         JZ    Enter180                no: branch
         LH    R0,FpconMaxDecimal  Get maximum decimal digits
         CIJE  R0,0,Enter170           zero: branch
         CH    R0,FpconMinDecimal  Maximum same as minimum?
         JE    Enter180                yes: branch
         J     ReturnBadParm           no: branch
Enter170 DC    0h'0'
         LH    R0,FpconMinDecimal  Minimum decimal digits 0 or -1?
         CIJH  R0,0,ReturnBadParm      no: branch
         LH    R0,FpconMaxLeading  Maximum leading digits is zero?
         CIJNH R0,0,ReturnBadParm      yes: branch
         SPACE 1
Enter180 DC    0h'0'
         LH    R0,FpconMinExpon    Get minimum exponent digits
         CIJL  R0,0,ReturnBadParm      bad: branch
         CIJH  R0,4,ReturnBadParm      bad: branch
         SPACE 1
         J     ToString            Go to "ToString"
         TITLE 'Floating Point Conversion - Module Exit'
ReturnOverFlow DC 0h'0'            String value is too big
         LGHI   R15,FpconRetOvrFlo
         J     ReturnSet
         SPACE 1
ReturnInfinity DC 0h'0'            IEEE FP value is an infinity
         LGHI   R15,FpconRetInf
         J     ReturnSet
         SPACE 1
ReturnNan DC 0h'0'                 IEEE FP value is a Not-A-Number
         LGHI   R15,FpconRetNan
         J     ReturnSet
         SPACE 1
ReturnBadString DC 0h'0'           Input string value is bad
         SLG   R1,FpconStringAddr  Compute offset to bad character
         STH   R1,FpconStringLen   Return offset
         LGHI   R15,FpconRetBadStr
         J     ReturnSet
         SPACE 1
ReturnBadParm DC 0h'0'             Parameter is bad
         LGHI   R15,FpconRetBadPrm
         SPACE 1
ReturnSet DC   0h'0'
         ST    R15,FpconReturnCode Set return code
         J     Return
         SPACE 1
ReturnOk DC    0h'0'
         LGF   R15,FpconReturnCode Get return code
Return   DC    0h'0'
         LG    R13,128(,R13)       Get caller's save area address
         LG    R14,8(,R13)         Get return address to caller
         LMG   R0,R12,24(R13)      Restore caller's registers
         BR    R14                 Return to caller
         SPACE 1
         DC    0d'0'
Static   LOCTR 
         TITLE 'Convert From Floating Point Value To String'
ToString LOCTR ,
         CLI   FpconBase,FpconBase10 Decimal floating point?
         JE    ToString0600            yes: branch
         CLI   FpconBase,FpconBase2 Binary floating point?
         JE    ToString0100            yes: branch
         IC    R0,FpconValueE      Get the base-16 exponent
         NILF  R0,127                  *
         AHI   R0,-64                  *
         LA    R11,FpconWork       Get address of work area
         CLI   FpconValueLen,FpconValueLenE Short value?
         JE    ToString0010            yes: branch
         CLI   FpconValueLen,FpconValueLenD Long value?
         JE    ToString0030            yes: branch
         MVC   0(7,R11),FpconValueL+1 Get extended mantissa
         MVC   7(7,R11),FpconValueL+9  *
         LA    R14,14(,R11)        Get end of mantissa
         TM    FpconValueL,1       Need to shift mantissa?
         JZ    ToString0050            no: branch
         MVI   15(R11),0           Shift mantissa 4 bits right
         MVC   16(14,R11),0(R11)       *
         MVO   0(15,R11),16(14,R11)    *
         AHI   R0,1                Increment exponent
         LA    R14,15(,R11)        Get end of mantissa
         J     ToString0050
ToString0010 DC 0h'0'
         TM    FpconValueE,1       Need to shift mantissa?
         JNZ   ToString0020            yes: branch
         MVC   0(3,R11),FpconValueE+1 Get short mantissa
         LA    R14,3(,R11)         Get end of mantissa
         J     ToString0050
ToString0020 DC 0h'0'
         MVI   3(R11),0            Get short mantissa
         MVO   0(4,R11),FpconValueE+1(3) shifted 4 bits right
         AHI   R0,1                Increment exponent
         LA    R14,4(,R11)         Get end of mantissa
         J     ToString0050
ToString0030 DC 0h'0'
         TM    FpconValueD,1       Need to shift mantissa?
         JNZ   ToString0040            yes: branch
         MVC   0(7,R11),FpconValueD+1 Get long mantissa
         LA    R14,7(,R11)         Get end of mantissa
         J     ToString0050
ToString0040 DC 0h'0'
         MVI   7(R11),0            Get long mantissa
         MVO   0(8,R11),FpconValueD+1(7) shifted 4 bits right
         AHI   R0,1                Increment exponent
         LA    R14,8(,R11)         Get end of mantissa
* Note: base-16 exponent in R0 should be even at this point
ToString0050 DC 0h'0'              Find last non-zero digit
         CLGRJNH   R14,R11,ToStringZero all zero: branch
*MCALL #=     3 LV= 2          BCTGR   R14,0                 *
         LAY   R14,-1(,R14)
*MEXIT #=     3 LV= 2 BCTGR
         CLI   0(R14),0                *
         JE    ToString0050            *
         LA    R14,1(,R14)             *
         SRA   R0,1                Set exponent for base 256
         TM    FpconValueE+1,X'F0' Denormalized?
         JNZ   ToString0200            no: branch
         MVI   FpconReturnCode+3,FpconRetDenorm yes: set return code
         CLI   0(R11),0            First digit all zero?
         JNE   ToString0200            no: branch
ToString0060 DC 0h'0'              Find first non-zero digit
         LA    R11,1(,R11)             *
         AHI   R0,-1                   *
         CLI   0(R11),0                *
         JE    ToString0060            *
         J     ToString0200            found: branch
         SPACE 1
***********************************************************************
*        Convert binary value to base-256                             *
***********************************************************************
ToString0100 DC 0h'0'
         LA    R11,FpconWork       Get start of number
         LH    R1,FpconValueL      Get exponent bytes
         CLI   FpconValueLen,FpconValueLenE Short value?
         JE    ToString0110            yes: branch
         CLI   FpconValueLen,FpconValueLenD Long value?
         JE    ToString0120            yes: branch
         LHI   R0,32767            Get exponent mask
         LHI   R2,16383            Get exponent bias
         LHI   R3,8                Get added fraction bits
         NR    R0,R1               Extract biased exponent
         MVI   0(R11),0            Clear high digit
         MVC   1(14,R11),FpconValueL+2 Get the mantissa
         LA    R14,15(,R11)        Get end of mantissa
         CIJE  R0,0,ToString0130   Biased exponent is zero: branch
         SR    R0,R2               Compute unbiased exponent
         CRJH  R0,R2,ToStringNanBin Invalid exponent: branch
         MVI   0(R11),1            Set normalized mantissa
         J     ToString0150        Go handle normalized number
         SPACE 1
ToString0110 DC 0h'0'
         LHI   R0,255              Get exponent mask
         LHI   R2,127              Get exponent bias
         LHI   R3,1                Get added fraction bits
         SRL   R1,7                Extract biased exponent
         NR    R0,R1                   *
         MVC   0(3,R11),FpconValueE+1 Get the normalized mantissa
         NI    0(R11),X'7F'        Clear high digit
         LA    R14,3(,R11)         Get end of mantissa
         CIJE  R0,0,ToString0130   Biased exponent is zero: branch
         SR    R0,R2               Compute unbiased exponent
         CRJH  R0,R2,ToStringNanBin Invalid exponent: branch
         OI    0(R11),X'80'        Set normalized mantissa
         J     ToString0150        Go handle normalized number
         SPACE 1
ToString0120 DC 0h'0'
         LHI   R0,2047             Get exponent mask
         LHI   R2,1023             Get exponent bias
         LHI   R3,4                Get added fraction bits
         SRL   R1,4                Extract biased exponent
         NR    R0,R1                   *
         MVC   0(7,R11),FpconValueD+1 Get the normalized mantissa
         NI    0(R11),X'0F'        Clear high digit
         LA    R14,7(,R11)         Get end of mantissa
         CIJE  R0,0,ToString0130   Biased exponent is zero: branch
         SR    R0,R2               Compute unbiased exponent
         CRJH  R0,R2,ToStringNanBin Invalid exponent: branch
         OI    0(R11),X'10'        Set normalized mantissa
         J     ToString0150        Go handle normalized number
         SPACE 1
ToString0130 DC 0h'0'              Denormal or zero:
         CLI   0(R11),0            Find first non-zero digit
         JNE   ToString0140            found: branch
         AHI   R3,-8                   *
         LA    R11,1(,R11)             *
         CLGRJL   R11,R14,ToString0130 *
         J     ToStringZero            all zero: branch
ToString0140 DC 0h'0'
         MVI   FpconReturnCode+3,FpconRetDenorm Indicate denormalized
         LHI   R0,1                Compute unbiased exponent
         SR    R0,R2                   *
ToString0150 DC 0h'0'
         AR    R0,R3               Compute actual base-2 exponent
         LHI   R1,7                Compute bits to shift right
         NR    R1,R0                   to get base-256 exponent
         JZ    ToString0190            none: branch
         LCR   R1,R1                   *
         AHI   R1,8                    *
         AR    R0,R1               Update exponent
         SPACE 1
         SR    R2,R2               Shift the value right
         LGR   R3,R11                  *
ToString0160 DC 0h'0'                  *
         LLC   R4,0(,R3)               *
         OR    R4,R2                   *
         LR    R2,R4                   *
         SRL   R4,0(R1)                *
         STC   R4,0(,R3)               *
         SLL   R2,8                    *
         LA    R3,1(,R3)               *
         CLGRJL   R3,R14,ToString0160  *
         SRL   R2,0(R1)                *
         STC   R2,0(,R14)              *
         LA    R14,1(,R14)             *
         CLI   0(R11),0            High digit now zero?
         JNE   ToString0190            no: branch
         MVC   0(16,R11),1(R11)    Move number back 1 byte
*MCALL #=     4 LV= 2          BCTGR   R14,0                 *
         LAY   R14,-1(,R14)
*MEXIT #=     4 LV= 2 BCTGR
         AHI   R0,-8               Adjust exponent
         SPACE 1
ToString0190 DC 0h'0'
         SRA   R0,3                Convert base-2 to base-256
         SPACE 1
***********************************************************************
*        Convert base-256 value to "GenDigits" decimal digits.        *
*        R0:  base-256 exponent (range 2048 to -2061)                 *
*        R11: address of start of number                              *
*             Number is base-256 with implied decimal point           *
*             just before the digit at R11.                           *
*        R14: address of end of number (no more than 15 from start)   *
***********************************************************************
ToString0200 DC 0h'0'
         LTGFR   R3,R0             Greater than 1?
         JNP   ToString0300            no: branch
         ALGR   R3,R11             Decimal point within number?
         LGR   R1,R3                   *
         SGR   R3,R14                  *
         JNP   ToString0210            yes: branch
         LGR   R2,R14              Clear number to zeros
         SR    R5,R5                   out to decimal point
         MVCL  R2,R4                   *
         LGR   R14,R2                  *
         SPACE 1
***********************************************************************
*        Divide integer part of number by 10 until it is 0,           *
*        extracting each remainder as a result digit.                 *
*        R1:  address of decimal point                                *
*        R11: address of start of number                              *
*             Number is base-256 with implied decimal point           *
*             just before the digit at R11.                           *
*        R14: address of end of number (no more than 2048 from start) *
***********************************************************************
ToString0210 DC 0h'0'
         SR    R8,R8               Base-10 exponent
         LA    R7,FpconWork+2056   Convert the integer part to decimal
         LA    R6,FpconWork+2056+35    with the digits reversed
ToString0220 DC 0h'0'                  starting at FpconWork+2056
         AHI   R8,1                    up to 36 decimal digits
         LGR   R2,R11                  *
         SR    R5,R5                   *
ToString0230 DC 0h'0'                  *
         SLL   R5,8                    *
         IC    R5,0(,R2)               *
         SR    R4,R4                   *
         D     R4,=F'10'               *
         STC   R5,0(,R2)               *
         LR    R5,R4                   *
         LA    R2,1(,R2)               *
         CLGRJL   R2,R1,ToString0230   *
         CLGRJNH   R7,R6,ToString0240  *
         MVC   FpconWork+2056(35),FpconWork+2057
         LR    R7,R6                   *
ToString0240 DC 0h'0'                  *
         STC   R5,0(,R7)               *
         OC    0(1,R7),FpconZero       *
         LA    R7,1(,R7)               *
         CLI   0(R11),0                *
         JNE   ToString0220            *
         LA    R11,1(,R11)             *
         CLGRJL   R11,R1,ToString0220  *
         SPACE 1
***********************************************************************
*        Copy the decimal digits (up to GenDigits+1) into the         *
*        string, putting them back into the correct order.            *
*        R1:  address of decimal point                                *
*        R7:  address past high-order decimal digit                   *
*        R8:  base-10 exponent                                        *
*        R11: address of decimal point                                *
*        R14: address of end of number                                *
***********************************************************************
         LA    R6,FpconWork+2056   Reverse the digits into the string
         LG    R2,FpconStringAddr      *
         LHI   R3,1                    *
         AH    R3,FpconGenDigits       *
ToString0250 DC 0h'0'                  *
*MCALL #=     5 LV= 2          BCTGR   R7,0                  *
         LAY   R7,-1(,R7)
*MEXIT #=     5 LV= 2 BCTGR
         CLGRJL   R7,R6,ToString0500   have all of them: branch
         MVC   0(1,R2),0(R7)           *
         LA    R2,1(,R2)               *
         BRCT  R3,ToString0250         *
         J     ToString1000            have enough digits: branch
         SPACE 1
***********************************************************************
*        Determine the exponent of a number less than 1 by            *
*        multiplying by 10 until it is greater than 1.                *
*        R0:  base-256 exponent (range 0 to -2061)                    *
*        R11: address of start of number                              *
*             Number is base-256 with implied decimal point           *
*             just before the digit at R11.                           *
*        R14: address of end of number (no more than 15 from start)   *
***********************************************************************
ToString0300 DC 0h'0'
         LHI   R8,1                Initialize base-10 exponent
*MCALL #=     6 LV= 2          BCTGR   R14,0             Point to last X
               digit
         LAY   R14,-1(,R14)
*MEXIT #=     6 LV= 2 BCTGR
         SR    R3,R3               Clear carry register
         LGR   R5,R11              Get address of first non-zero
         LCR   R1,R0               Is decimal position at number?
         JNP   ToString0310            yes: branch
         MVC   FpconWork+2064(16),0(R11) Move number to end
         SLGR   R14,R11                of work area
         LA    R11,FpconWork+2064  Set R11 to decimal point position
         LA    R14,FpconWork+2064(R14) and R14 to last digit
         LA    R5,FpconWork+2064       and R5 to first non-zero
         AGFR   R11,R0                 *
         LGR   R0,R11              Clear digits between
         MVCL  R0,R2                   decimal point and number
ToString0310 DC 0h'0'              Until carry:
         LGR   R2,R14                  *
         AHI   R8,-1                   decrement base-10 exponent
ToString0320 DC 0h'0'                  multiply the number by 10
         LLC   R4,0(,R2)               *
         MHI   R4,10                   *
         AR    R4,R3                   *
         STC   R4,0(,R2)               *
         LR    R3,R4                   *
*MCALL #=     7 LV= 2          BCTGR   R2,0                  *
         LAY   R2,-1(,R2)
*MEXIT #=     7 LV= 2 BCTGR
         SRL   R3,8                    *
         CLGRJNL   R2,R5,ToString0320  *
         CLI   0(R14),0                If last digit
         JNE   ToString0330            is now zero,
*MCALL #=     8 LV= 2          BCTGR   R14,0                 decrement X
               R14
         LAY   R14,-1(,R14)
*MEXIT #=     8 LV= 2 BCTGR
ToString0330 DC 0h'0'                  *
         CIJE  R3,0,ToString0310       no carry: branch
         CLGRJNH   R5,R11,ToString0340 carry from decimal point: branch
*MCALL #=     9 LV= 2          BCTGR   R5,0                  point to nX
               ew high non-zero
         LAY   R5,-1(,R5)
*MEXIT #=     9 LV= 2 BCTGR
         STC   R3,0(,R5)               set new high non-zero digit
         SR    R3,R3                   clear carry
         J     ToString0310            and go do another multiply
ToString0340 DC 0h'0'
         LA    R14,1(,R14)         Reset R14 to end of number
         LG    R2,FpconStringAddr  Put the carry digit into
         STC   R3,0(,R2)               the string
         OC    0(1,R2),FpconZero       *
         LA    R2,1(,R2)               *
         LH    R3,FpconGenDigits   Get number of digits needed
         SPACE 1
***********************************************************************
*        Extract the rest of the needed fraction digits needed        *
*        by multiplying the number by 10 and extracting the carry.    *
*        R2:  address of where to put next digit                      *
*        R3:  number of digits needed                                 *
*        R8:  base-10 exponent                                        *
*        R11: address of start of number                              *
*             Number is base-256 with implied decimal point           *
*             just before the digit at R11.                           *
*        R14: address of end of number                                *
***********************************************************************
ToString0500 DC 0h'0'
         CLGRJNL   R11,R14,ToString1000 No fraction left: branch
*MCALL #=    10 LV= 2          BCTGR   R14,0             Set R14 to addX
               ress of last digit
         LAY   R14,-1(,R14)
*MEXIT #=    10 LV= 2 BCTGR
         LGFR   R0,R3              Don't need to use more than
         SRL   R0,1                    R3/2 digits of the fraction
         ALGR   R0,R11                 *
         CLGRJL   R14,R0,ToString0520  *
         LGR   R14,R0                  *
ToString0510 DC 0h'0'              Find last non-zero digit
         CLI   0(R14),0                *
         JNE   ToString0520            *
         CLGRJNH   R14,R11,ToString1000
         BRCTG   R14,ToString0510      *
ToString0520 DC 0h'0'              For each needed digit:
         SR    R0,R0                   *
         LGR   R1,R14                  *
ToString0530 DC 0h'0'                  multiply the number by 10
         LLC   R4,0(,R1)               *
         MHI   R4,10                   *
         ALR   R4,R0                   *
         STC   R4,0(,R1)               *
         LR    R0,R4                   *
*MCALL #=    11 LV= 2          BCTGR   R1,0                  *
         LAY   R1,-1(,R1)
*MEXIT #=    11 LV= 2 BCTGR
         SRL   R0,8                    *
         CLGRJNL   R1,R11,ToString0530 *
         STC   R0,0(,R2)               extract carry as
         OC    0(1,R2),FpconZero       next decimal digit
         LA    R2,1(,R2)               *
         CLI   0(R14),0                If last digit
         JNE   ToString0540            is now zero,
*MCALL #=    12 LV= 2          BCTGR   R14,0                 decrement X
               R14
         LAY   R14,-1(,R14)
*MEXIT #=    12 LV= 2 BCTGR
         CLGRJH   R11,R14,ToString1000 no more fraction: branch
ToString0540 DC 0h'0'                  *
         BRCT  R3,ToString0520         go get next digit
         J     ToString1000
         SPACE 1
***********************************************************************
*        Extract the digits of a decimal floating point number        *
*        to the string buffer.                                        *
***********************************************************************
ToString0600 DC 0h'0'
         TM    FpconValueE,B'01111000' NAN or INF?
         JO    ToStringNanDec          yes: branch
         LG    R2,FpconStringAddr  Get address of string buffer
         CLI   FpconValueLen,FpconValueLenL Extended value?
         JE    ToString0620            yes: branch
         STD   FPR0,FpconWork      Save FPR0
         LD    FPR0,FpconValueD    Get short/long value
         CLI   FpconValueLen,FpconValueLenD Long value?
         JE    ToString0610            yes: branch
         LDETR FPR0,FPR0,0         Convert short to long
ToString0610 DC 0h'0'
         ESDTR R15,FPR0            Get number of significant digits
         CIJE  R15,0,ToStringZeroR0       No significant digits: branch
         EEDTR R8,FPR0             Get biased exponent
         CUDTR R0,FPR0             Convert digits to packed
         LD    FPR0,FpconWork      Restore FPR0
         AHI   R8,-398             Compute unbiased exponent
         AR    R8,R15                  *
         STG   R0,FpconWork+16     Save packed digits
         SGR   R0,R0               Clear R0
         UNPK  FpconWork(15),FpconWork+16(8) Convert digits
         UNPK  FpconWork+14(3),FpconWork+16+7(2) to EBCDIC
         LA    R14,FpconWork+16    Get address past last digit
         J     ToString0640
ToString0620 DC 0h'0'
         STD   FPR0,FpconWork      Save FPR0
         STD   FPR2,FpconWork+8     and FPR2
         LD    FPR0,FpconValueL    Get extended value
         LD    FPR2,FpconValueL+8      *
         ESXTR R15,FPR0            Get number of significant digits
         CIJE  R15,0,ToStringZeroR2       No significant digits: branch
         EEXTR R8,FPR0             Get biased exponent
         CUXTR R0,FPR0             Convert low-order digits to packed
         STMG  R0,R1,FpconWork+40  Save low-order packed digits
         SGR   R0,R0               Clear R0
         SGR   R1,R1                 and R1
         CIJNH R15,32,ToString0630 Non-zero high-order digits: branch
         SRXT  FPR0,FPR0,32        Convert high-order digits
         CUXTR R0,FPR0                 to packed
ToString0630 DC 0h'0'
         STC   R1,FpconWork+39     Save high-order packed digits
         LD    FPR0,FpconWork      Restore FPR0
         LD    FPR2,FpconWork+8        and FPR2
         AHI   R8,-6176            Compute unbiased exponent
         AR    R8,R15                  *
         UNPK  FpconWork(15),FpconWork+39(8) Convert digits
         UNPK  FpconWork+14(15),FpconWork+39+7(8) to EBCDIC
         UNPK  FpconWork+28(7),FpconWork+39+14(4)
         LA    R14,FpconWork+34    Get address past last digit
ToString0640 DC 0h'0'
         LR    R3,R15              Copy significant digits
         SGR   R14,R15                 to string buffer
         MVCL  R2,R14                  *
         CLI   FpconZero,C'0'      EBCDIC?
         JE    ToString1000            yes: branch
         LGR   R15,R2              Convert digits to ASCII
         LG    R14,FpconStringAddr     *
         SGR   R15,R14                 *
ToString0650 DC 0h'0'                  *
         NI    0(R14),X'0F'            *
         OC    0(1,R14),FpconZero      *
         LA    R14,1(,R14)             *
         BRCT  R15,ToString0650        *
         J     ToString1000
ToStringZeroR2 DC 0h'0'
         LD    FPR2,FpconWork+8    Restore FPR2
ToStringZeroR0 DC 0h'0'
         LD    FPR0,FpconWork      Restore FPR0
         J     ToStringZero
         SPACE 1
***********************************************************************
*        The significant decimal character digits are now in          *
*        the string buffer (up to GenDigits+1) with the implied       *
*        decimal point before the first digit.                        *
*        R2:  address after last digit in buffer                      *
*        R8:  base-10 exponent                                        *
***********************************************************************
ToString1000 DC 0h'0'
         LG    R3,FpconStringAddr  Get buffer address
         LGR   R4,R2               Compute number of digits in buffer
         SLGR   R4,R3                  *
         LGH   R1,FpconGenDigits   Get number of digits wanted
***********************************************************************
*        R1:  maximum digits needed                                   *
*        R2:  address after last digit in buffer                      *
*        R3:  address of string buffer                                *
*        R4:  number of digits in buffer                              *
*        R8:  base-10 exponent                                        *
***********************************************************************
         TM    FpconFlags,FpconFixedDec Decimal truncation wanted?
         JZ    ToString1020            no: branch
         LR    R0,R4               Compute number of decimal digits
         SR    R0,R8                   *
         CH    R0,FpconMaxDecimal  Too many decimal digits?
         JNH   ToString1020            no: branch
         LGH   R1,FpconMaxDecimal  Compute number of digits to keep
         AGFR   R1,R8                  *
         JP    ToString1020            at least 1: branch
         LGR   R2,R3                   (get string buffer address)
         JM    ToString1010            less than 0: branch
         CLC   FpconFive,0(R3)     Round to 1 in last position?
         JNH   ToString1040            yes: branch
ToString1010 DC 0h'0'
         MVC   0(1,R2),FpconZero   Set number to 0
         LH    R8,FpconMaxLeading  Leading digits wanted?
         CIJE  R8,0,ToString1100       no: branch (.0)
         LHI   R8,1                Set exponent to 1 (0.)
         J     ToString1100
         SPACE 1
ToString1020 DC 0h'0'
         CRJNH R4,R1,ToString1050  Not more digits than needed: branch
         LA    R2,0(R1,R3)         Get address of rounding digit
         CLC   FpconFive,0(R2)     Need to round up?
         JNH   ToString1030            yes: branch
         MVI   0(R2),0             Truncate number here
         J     ToString1050
ToString1030 DC 0h'0'              Increment the number
         MVI   0(R2),0                 *
         CLGRJNH   R2,R3,ToString1040  overflow: branch
*MCALL #=    13 LV= 2          BCTGR   R2,0                  *
         LAY   R2,-1(,R2)
*MEXIT #=    13 LV= 2 BCTGR
         LLC   R1,0(,R2)               *
         AHI   R1,1                    *
         STC   R1,0(,R2)               *
         CLC   FpconNine,0(R2)         *
         JL    ToString1030            *
         LA    R2,1(,R2)           Get end of number address
         J     ToString1050
ToString1040 DC 0h'0'
         MVI   0(R2),1             Set number to 1.0
         OC    0(1,R2),FpconZero       *
         AHI   R8,1                Increment exponent
         J     ToString1100
         SPACE 1
ToString1050 DC 0h'0'
*MCALL #=    14 LV= 2          BCTGR   R2,0              Get address ofX
                last digit
         LAY   R2,-1(,R2)
*MEXIT #=    14 LV= 2 BCTGR
         CLI   FpconBase,FpconBase10 Decimal floating point?
         JE    ToString1100            yes: branch
ToString1060 DC 0h'0'              Remove all trailing zeros
         CLGRJNH   R2,R3,ToString1100  from number
         TM    0(R2),15                *
         JNZ   ToString1100            *
         MVI   0(R2),0                 *
         BRCTG   R2,ToString1060       *
         SPACE 1
***********************************************************************
*        The significant decimal character digits (rounded if needed) *
*        are in the string buffer (up to GenDigits) with the implied  *
*        decimal point before the first digit.  The number is ready   *
*        to be formatted.                                             *
*        R2:  address of last digit in buffer                         *
*        R3:  address of string buffer                                *
*        R8:  base-10 exponent                                        *
***********************************************************************
ToString1100 DC 0h'0'
         TM    FpconFlags,FpconRetDigits Format result?
         JNZ   ToStringRetDigits       no: branch
         SLGR   R2,R3              Compute digits-1
         LA    R4,FpconWork        Copy digits from string buffer
         EXRL  R2,MVC_R4_R3            to work area
         EXRL  R2,XC_R3_R3             and clear buffer
         TM    FpconValueE,X'80'   Is value negative?
         JNZ   ToString1110            yes: branch
         TM    FpconFlags,FpconValuePlus Plus sign wanted?
         JZ    ToString1120            no: branch
         MVC   0(1,R3),FpconPlus   Set plus sign
         LA    R3,1(,R3)               *
         J     ToString1120
ToString1110 DC 0h'0'
         MVC   0(1,R3),FpconMinus  Set minus sign
         LA    R3,1(,R3)               *
***********************************************************************
*        R2:  number of available digits - 1                          *
*        R3:  address of string buffer past sign (if any)             *
*        R4:  address of digits in FpconWork                          *
*        R8:  base-10 exponent                                        *
***********************************************************************
ToString1120 DC 0h'0'
         CIJNH R8,0,ToString1200   Number not at least 1.0: branch
         LH    R0,FpconMaxLeading  Get number of leading digits wanted
         CIJNH R0,1,ToString1300   .99999 or 9.9999 format: branch
         CRJH  R8,R0,ToString1300  Number won't fit: branch
         SPACE 1
***********************************************************************
*        Format number as 999999.999999                               *
***********************************************************************
         EXRL  R2,MVC_R3_R4        Move digits to string
         AGFR   R3,R8              Point to decimal point position
         SR    R2,R8               Any digits after decimal?
         JNM   ToString1150            yes: branch
         AHI   R2,1                Any trailing zeros in integer?
         JZ    ToString1140            no: branch
         AGFR   R3,R2              Point to first zero
         LCR   R2,R2               Fill integer part with zeros
ToString1130 DC 0h'0'                  *
         MVC   0(1,R3),FpconZero       *
         LA    R3,1(,R3)               *
         BRCT  R2,ToString1130         *
ToString1140 DC 0h'0'
         LH    R0,FpconMinDecimal  Get trailing decimal positions
         LTR   R0,R0               Decimal point wanted?
         JM    ToString1190            no: branch
         MVC   0(1,R3),FpconDecimal Set decimal point
         LA    R3,1(,R3)               *
         JP    ToString1160        Go fill decimal zeros
         J     ToString1190        No zeros needed: branch
         SPACE 1
ToString1150 DC 0h'0'
         AGFR   R4,R8              Point to first decimal digit
         MVC   0(1,R3),FpconDecimal Set decimal point
         LA    R3,1(,R3)               *
         EXRL  R2,MVC_R3_R4        Move decimal digits to string
         AHI   R2,1                    *
         ALGFR   R3,R2                 *
         LH    R0,FpconMinDecimal  Get trailing decimal positions
         SR    R0,R2               Any more decimal zeros needed?
         JNP   ToString1190            no: branch
ToString1160 DC 0h'0'              Fill minimum decimal digits
         MVC   0(1,R3),FpconZero       with zeros
         LA    R3,1(,R3)               *
         BRCT  R0,ToString1160         *
         SPACE 1
ToString1190 DC 0h'0'
         SR    R8,R8               Don't need exponent now
         J     ToString1500
         SPACE 1
***********************************************************************
*        Number is less than 1.0                                      *
***********************************************************************
ToString1200 DC 0h'0'
         LH    R0,FpconMaxDecimal  Get maximum decimal digits
         CIJE  R0,0,ToString1300       zero: branch
         LHI   R1,1                Will the number fit?
         AR    R1,R2                   *
         SR    R1,R8                   *
         CRJH  R1,R0,ToString1300      no: branch
***********************************************************************
*        Format as .00009999 or 0.00009999                            *
***********************************************************************
         LH    R0,FpconMaxLeading  .99999 format?
         CIJE  R0,0,ToString1210       yes: branch
         MVC   0(1,R3),FpconZero   Set leading zero
         LA    R3,1(,R3)               *
ToString1210 DC 0h'0'
         MVC   0(1,R3),FpconDecimal Set decimal point
         LA    R3,1(,R3)               *
         LH    R0,FpconMinDecimal  Get minimum decimal positions
         LCR   R8,R8               Get number of leading zeros
         JZ    ToString1230            none: branch
ToString1220 DC 0h'0'              Set leading zeros
         BCTR  R0,0                    *
         MVC   0(1,R3),FpconZero       *
         LA    R3,1(,R3)               *
         BRCT  R8,ToString1220         *
ToString1230 DC 0h'0'
         EXRL  R2,MVC_R3_R4        Move the digits
         AHI   R2,1                    *
         ALGFR   R3,R2                 *
         SR    R0,R2               Compute trailing zeros needed
         JP    ToString1400            some needed: branch
         J     ToString1500        No zeros needed: branch
         SPACE 1
***********************************************************************
*        Format number as 9.9999999                                   *
***********************************************************************
ToString1300 DC 0h'0'
         LH    R0,FpconMaxLeading  .99999 format?
         CIJNH R0,0,ToString1350       yes: branch
         BCTR  R8,0                Decrement exponent
         MVC   0(1,R3),0(R4)       Set units digit
         LA    R3,1(,R3)               *
         CIJH  R2,0,ToString1310   Any decimal digits: branch
         LH    R0,FpconMinDecimal  Get trailing decimal positions
         LTR   R0,R0               Decimal point wanted?
         JM    ToString1500            no: branch
         MVC   0(1,R3),FpconDecimal Set decimal point
         LA    R3,1(,R3)               *
         JP    ToString1400        Go fill decimal zeros
         J     ToString1500        No zeros needed: branch
         SPACE 1
ToString1310 DC 0h'0'
         LA    R4,1(,R4)           Point to first decimal digit
         BCTR  R2,0                Set length for move
         SPACE 1
***********************************************************************
*        Format number as .99999999                                   *
***********************************************************************
ToString1350 DC 0h'0'
         MVC   0(1,R3),FpconDecimal Set decimal point
         LA    R3,1(,R3)               *
         EXRL  R2,MVC_R3_R4            *
         AHI   R2,1                    *
         ALGFR   R3,R2                 *
         LH    R0,FpconMinDecimal  Get trailing decimal positions
         SR    R0,R2               Any more decimal zeros needed?
         JNP   ToString1500            no: branch
         SPACE 1
ToString1400 DC 0h'0'              Fill minimum decimal digits
         MVC   0(1,R3),FpconZero       with zeros
         LA    R3,1(,R3)               *
         BRCT  R0,ToString1400         *
         SPACE 1
***********************************************************************
*        Add exponent to string                                       *
*        R3:  address of next character in string buffer              *
*        R8:  base-10 exponent                                        *
***********************************************************************
ToString1500 DC 0h'0'
         STH   R8,FpconExponent10  Return exponent
         LH    R0,FpconMinExpon    Get minimum exponent digits
         CIJNE R8,0,ToString1510   Nonzero exponent: branch
         CIJNH R0,0,ToString1590   No exponent required: branch
ToString1510 DC 0h'0'
         MVC   0(1,R3),FpconExponent Set exponent indicator
         LA    R3,1(,R3)               *
         CIJL  R8,0,ToString1520   Negative exponent: branch
         TM    FpconFlags,FpconExponPlus Exponent sign required?
         JZ    ToString1530            no: branch
         MVC   0(1,R3),FpconPlus   Set exponent sign
         LA    R3,1(,R3)               *
         J     ToString1530
ToString1520 DC 0h'0'
         LCR   R8,R8               Get positive exponent value
         MVC   0(1,R3),FpconMinus  Set exponent sign
         LA    R3,1(,R3)               *
ToString1530 DC 0h'0'              Determine minimum number of
         LHI   R1,1                    exponent digits needed
         CIJL  R8,10,ToString1540      *
         LHI   R1,2                    *
         CIJL  R8,100,ToString1540     *
         LHI   R1,3                    *
         CHI   R8,1000                 *
         JL    ToString1540            *
         LHI   R1,4                    *
ToString1540 DC 0h'0'
         CRJH  R1,R0,ToString1550  Determine exponent digits
         LR    R1,R0                   to generate in R1
ToString1550 DC 0h'0'
         CVD   R8,FpconWork        Convert exponent to decimal
         UNPK  FpconWork(5),FpconWork+5(3)
         LA    R4,FpconWork+5      Copy to string buffer
         SLGFR   R4,R1                 *
ToString1560 DC 0h'0'                  *
         MVC   0(1,R3),0(R4)           *
         MVZ   0(1,R3),FpconZero       *
         LA    R4,1(,R4)               *
         LA    R3,1(,R3)               *
         BRCT  R1,ToString1560         *
         SPACE 1
ToString1590 DC 0h'0'
         SLG   R3,FpconStringAddr  Compute string length
         STH   R3,FpconStringLen       *
         J     ReturnOk            We are done
         SPACE 1
***********************************************************************
*        Floating point value is zero                                 *
***********************************************************************
ToStringZero DC 0h'0'
         TM    FpconFlags,FpconRetDigits Format result?
         JNZ   ToStringRetDigitsZero   no: branch
         XC    FpconExponent10,FpconExponent10 Return exponent as 0
         LG    R2,FpconStringAddr  Get output string address
         TM    FpconFlags,FpconZeroPlus Zero always positive?
         JNZ   ToStringZero010         yes: branch
         TM    FpconFlags,FpconZeroSign Zero sign wanted?
         JZ    ToStringZero040         no: branch
         TM    FpconValueE,X'80'   Negative zero?
         JNZ   ToStringZero020         yes: branch
ToStringZero010 DC 0h'0'
         MVC   0(1,R2),FpconPlus   Set plus sign
         J     ToStringZero030
ToStringZero020 DC 0h'0'
         MVC   0(1,R2),FpconMinus  Set minus sign
ToStringZero030 DC 0h'0'
         LA    R2,1(,R2)           Skip the sign
ToStringZero040 DC 0h'0'
         LH    R0,FpconMaxLeading  Leading digits wanted?
         CIJNH R0,0,ToStringZero050    no: branch
         MVC   0(1,R2),FpconZero   Set leading zero
         LA    R2,1(,R2)               *
         LH    R0,FpconMinDecimal  Decimal point wanted?
         LTR   R0,R0                   *
         JM    ToStringZero070         no: branch
         MVC   0(1,R2),FpconDecimal Set decimal point
         LA    R2,1(,R2)               *
         JNZ   ToStringZero060     Minimum decimal digits: branch
         J     ToStringZero070     No decimal digits: branch
ToStringZero050 DC 0h'0'
         MVC   0(1,R2),FpconDecimal Set the decimal point
         LA    R2,1(,R2)               *
         LH    R0,FpconMinDecimal  Fill decimal digits with zeros
ToStringZero060 DC 0h'0'               *
         MVC   0(1,R2),FpconZero       *
         LA    R2,1(,R2)               *
         BRCT  R0,ToStringZero060      *
ToStringZero070 DC 0h'0'
         LH    R0,FpconMinExpon    Exponent required?
         CIJE  R0,0,ToStringZero090    no: branch
         MVC   0(1,R2),FpconExponent Set exponent indicator
         LA    R2,1(,R2)               *
         TM    FpconFlags,FpconExponPlus Exponent sign required?
         JZ    ToStringZero080         no: branch
         MVC   0(1,R2),FpconPlus   Set exponent sign
         LA    R2,1(,R2)               *
ToStringZero080 DC 0h'0'           Fill exponent with zeros
         MVC   0(1,R2),FpconZero       *
         LA    R2,1(,R2)               *
         BRCT  R0,ToStringZero080      *
ToStringZero090 DC 0h'0'
         SLG   R2,FpconStringAddr  Compute string length
         STH   R2,FpconStringLen       *
         J     ReturnOk            We are done
         SPACE 1
***********************************************************************
*        RetDigits - return digits without formatting (ecvt/fcvt)     *
*        R2:  address of last digit in buffer                         *
*        R3:  address of string buffer                                *
*        R8:  base-10 exponent                                        *
***********************************************************************
ToStringRetDigitsZero DC 0h'0'
         LG    R3,FpconStringAddr  Get string address
         LHI   R8,1                Set exponent to 1 (same as glibc)
         LGR   R2,R3               Get last digit address
         MVC   0(1,R3),FpconZero   Set only digit to zero
ToStringRetDigits DC 0h'0'
         LA    R2,1(,R2)           Get address of end of string
         SLGR   R2,R3              Compute string length
         STH   R8,FpconExponent10  Return exponent
         STH   R2,FpconStringLen   Return number of digits
         J     ReturnOk            We are done
         SPACE 1
***********************************************************************
*        Binary floating point value is Not-A-Number                  *
*        R11: address of start of mantissa                            *
*        R14: address of end of number                                *
***********************************************************************
ToStringNanBin DC 0h'0'
         SR    R14,R11             Compute length of mantissa
ToStringNanBin010 DC 0h'0'
         CLI   0(R11),0            Mantissa is all zero?
         JNE   ReturnNan               no: branch
         LA    R11,1(,R11)             *
         BRCT  R14,ToStringNanBin010   *
         J     ReturnInfinity          yes: branch
         SPACE 1
***********************************************************************
*        Decimal floating point value is Not-A-Number                 *
*        R8: combination field value                                  *
***********************************************************************
ToStringNanDec DC 0h'0'
         TM    FpconValueE,B'00000100' Infinity?
         JZ    ReturnInfinity          yes: branch
         J     ReturnNan               no: return
         SPACE 1
         TITLE 'Convert From String To Floating Point Value'
ToValue  LOCTR ,
         SPACE 1
         LG    R1,FpconStringAddr  Get string address
         LGH   R0,FpconStringSize  Get string length
         ALGR   R0,R1              Get end of string address
         SPACE 1
         XC    FpconValueL,FpconValueL Clear value
         SPACE 1
ToValue0010 DC 0h'0'               Skip any leading blanks
         CLC   FpconBlank,0(R1)        *
         JL    ToValue0020             start found: branch
         JH    ReturnBadString         bad character: branch
         LA    R1,1(,R1)               *
         CLGRJL   R1,R0,ToValue0010    *
         J     ReturnBadString         empty string: branch
         SPACE 1
***********************************************************************
*        Convert string mantissa to binary value in FpconWork         *
*                                                                     *
*        R0: address of end of string                                 *
*        R1: address of first non-blank in string                     *
*        When complete, the mantissa in the string (the part of the   *
*        number before the exponent) will be converted to a binary    *
*        value of up to 16 bytes.  This is long enough to allow       *
*        the exponent to be applied without loss of precision.        *
*        Any mantissa digits after the 38 (or 39th) place will be     *
*        ignored (after rounding).  The actual maximum mantissa       *
*        is 250*256**15-1, or about 3.323E38.                         *
*                                                                     *
*        For conversion to a decimal floating point value, the digit  *
*        characters are converted to byte values 0-9 in FpconWork.    *
*                                                                     *
***********************************************************************
BinDigitsToString EQU 16
ToValue0020 DC 0h'0'
         SR    R2,R2               Indicate no digits yet
         SR    R3,R3               Indicate no decimal point yet
         SR    R4,R4               Indicate no decimal digits yet
         SGR   R5,R5               Indicate no number yet
         SR    R7,R7               Indicate no truncation yet
         XC    FpconWork(BinDigitsToString),FpconWork
         SPACE 1
         CLI   FpconBase,FpconBase10 Decimal floating point?
         JNE   ToValue0025             no: branch
         LHI   R7,16               Maximum digits for long
         CLI   FpconValueLen,FpconValueLenD Long value?
         JE    ToValue0025             yes: branch
         LHI   R7,7                Maximum digits for short
         CLI   FpconValueLen,FpconValueLenE Short value?
         JE    ToValue0025             yes: branch
         LHI   R7,34               Maximum digits for extended
         SPACE 1
***********************************************************************
*        R0: address of end of string                                 *
*        R1: address of first non-blank in string                     *
*        R2: 0/1 if any digits in number (used for syntax checking)   *
*        R3: 0/1 if decimal point seen                                *
*        R4: power of 10 to adjust exponent                           *
*        R5: number of bytes of FpconWork used for number             *
*        R7: 0/1 if number truncated (hexadecimal or binary)          *
*            maximum digits to convert or -1=truncated (decimal)      *
***********************************************************************
ToValue0025 DC 0h'0'
         CLC   FpconPlus,0(R1)     Leading plus sign?
         JE    ToValue0030             yes: branch
         CLC   FpconMinus,0(R1)    Leading minus sign?
         JNE   ToValue0040             no: branch
         MVI   FpconValueL,X'80'   Indicate value is negative
ToValue0030 DC 0h'0'
         LA    R1,1(,R1)           Skip leading sign
         CLGRJNL   R1,R0,ReturnBadString No more characters: branch
         SPACE 1
ToValue0040 DC 0h'0'               Skip any leading zeros
         CLC   FpconZero,0(R1)         *
         JNE   ToValue0050             non-zero found: branch
         LHI   R2,1                    indicate digit seen
         LA    R1,1(,R1)               *
         CLGRJL   R1,R0,ToValue0040    *
         J     ToValue0200             all zero: branch
         SPACE 1
ToValue0050 DC 0h'0'               Convert the digits to binary:
         CLC   FpconDecimal,0(R1)      decimal point?
         JNE   ToValue0060                 no: branch
         CIJNE R3,0,ReturnBadString    decimal point seen: branch
         LHI   R3,1                    indicate decimal point seen
         J     ToValue0190             done with character
ToValue0060 DC 0h'0'                   *
         CLC   FpconZero,0(R1)         valid digit?
         JH    ToValue0200                 no: branch
         CLC   FpconNine,0(R1)             *
         JL    ToValue0200                 no: branch
         IC    R8,0(,R1)               get the new decimal digit
         NILF  R8,15                       *
         LHI   R2,1                    indicate digit seen
         CLI   FpconBase,FpconBase10   decimal floating point?
         JE    ToValue0130                 yes: branch
         CLI   FpconWork,24            enough digits seen?
         JNH   ToValue0090                 no: branch
         CIJNE R3,0,ToValue0070        decimal point seen: branch
         AHI   R4,1                    increment exponent
ToValue0070 DC 0h'0'                       *
         CIJNE R7,0,ToValue0190        already truncated: branch
         LHI   R7,1                    indicate truncation
         CLC   FpconFive,0(R1)         need to round up number?
         JNL   ToValue0190                 no: branch
         SR    R11,R11                 increment the value
         LA    R14,FpconWork+BinDigitsToString end of binary number
ToValue0080 DC 0h'0'                       *
*MCALL #=    15 LV= 2          BCTGR   R14,0                     get thX
               e binary digit
         LAY   R14,-1(,R14)
*MEXIT #=    15 LV= 2 BCTGR
         IC    R11,0(,R14)                     *
         AHI   R11,1                       increment it
         STC   R11,0(,R14)                 save new digit value
         SRA   R11,8                       any carry?
         JNZ   ToValue0080                     yes: branch
         J     ToValue0190             done with character
ToValue0090 DC 0h'0'                   *
         CIJE  R3,0,ToValue0100        decimal point not seen: branch
         AHI   R4,-1                   decrement exponent
ToValue0100 DC 0h'0'                   *
         CIJNE R5,0,ToValue0110        prior non-zero digits: branch
         CIJE  R8,0,ToValue0190        another zero: branch
         STC   R8,FpconWork+BinDigitsToString-1 set the first digit
         LHI   R5,1                    set length of binary number
         J     ToValue0190             done with character
ToValue0110 DC 0h'0'                   *
         LA    R14,FpconWork+BinDigitsToString end of binary number
         LR    R7,R5                   For each binary digit:
         SR    R11,R11                     *
ToValue0120 DC 0h'0'                       *
*MCALL #=    16 LV= 2          BCTGR   R14,0                     get thX
               e binary digit
         LAY   R14,-1(,R14)
*MEXIT #=    16 LV= 2 BCTGR
         IC    R11,0(,R14)                     *
         MHI   R11,10                      times 10
         AR    R11,R8                      plus the carry
         STC   R11,0(,R14)                 save new digit value
         SRL   R11,8                       get the carry
         LR    R8,R11                          *
         BRCT  R7,ToValue0120              Go do next digit
         CIJE  R8,0,ToValue0190        No carry from high pos.: branch
*MCALL #=    17 LV= 2          BCTGR   R14,0                 Save the cX
               arry value
         LAY   R14,-1(,R14)
*MEXIT #=    17 LV= 2 BCTGR
         STC   R8,0(,R14)                  *
         AHI   R5,1                    Increment binary number length
         J     ToValue0190             Go get the next character
         SPACE 1
ToValue0130 DC 0h'0'                   Decimal floating point:
         CRJL  R5,R7,ToValue0170       not enough digits seen: branch
         CIJNE R3,0,ToValue0140        decimal point seen: branch
         AHI   R4,1                    increment exponent
ToValue0140 DC 0h'0'                   *
         CIJL  R7,0,ToValue0190        already truncated: branch
         CLC   FpconFive,0(R1)         need to round up number?
         JH    ToValue0160                 no: branch
         LA    R14,FpconWork-1(R5)     address of end of number
         LA    R7,FpconWork            address of start of number
         SR    R15,R15                 increment the value
ToValue0150 DC 0h'0'                       *
         IC    R15,0(,R14)                 get the digit
         AHI   R15,1                       increment it
         STC   R15,0(,R14)                 save new digit value
         CIJNH R15,9,ToValue0160           no carry: branch
         MVI   0(R14),0                    reset digit to zero
*MCALL #=    18 LV= 2          BCTGR   R14,0                     last dX
               igit
         LAY   R14,-1(,R14)
*MEXIT #=    18 LV= 2 BCTGR
         CLGRJNH   R7,R14,ToValue0150      no overflow: branch
         MVI   FpconWork,1             set to 100000...
         AHI   R4,1                    increment exponent
ToValue0160 DC 0h'0'                   *
         LHI   R7,-1                   indicate truncation
         J     ToValue0190             done with character
ToValue0170 DC 0h'0'                   *
         LA    R14,FpconWork(R5)       get address of output digit
         CIJE  R3,0,ToValue0180        no decimal point seen: branch
         AHI   R4,-1                   decrement exponent
ToValue0180 DC 0h'0'                   *
         STC   R8,0(,R14)              save the digit
         AHI   R5,1                    increment number of digits
         SPACE 1
ToValue0190 DC 0h'0'
         LA    R1,1(,R1)               point to next character
         CLGRJL   R1,R0,ToValue0050    more characters: branch
         SPACE 1
***********************************************************************
*        End of mantissa found.                                       *
*        R0: address of end of string                                 *
*        R1: address of first non-digit in string                     *
*        R2: 0/1 if any digits in number (used for syntax checking)   *
*        R4: power of 10 to adjust exponent                           *
*        R5: number of bytes of FpconWork used for number             *
***********************************************************************
ToValue0200 DC 0h'0'
         CIJE  R2,0,ReturnBadString No digits seen: branch
         CLGRJNL   R1,R0,ToValue0300 End of string: branch
         SR    R6,R6               Exponent is zero so far
         CLC   FpconBlank,0(R1)    End of number?
         JE    ToValue0270             yes: branch
         CLC   FpconExponent,0(R1) Valid exponent character?
         JE    ToValue0210             yes: branch
         CLC   FpconExpAlt,0(R1)       *
         JNE   ReturnBadString         no: branch
ToValue0210 DC 0h'0'
         LA    R1,1(,R1)           Point to next character
         CLGRJNL   R1,R0,ReturnBadString No more characters: branch
***********************************************************************
*        Convert the exponent (if any).                               *
*        R0: address of end of string                                 *
*        R1: address of first non-blank in string                     *
*        R2: 0/1 if any digits in exponent (used for syntax checking) *
*        R3: 0/-1 if exponent is negative                             *
*        R4: power of 10 to adjust exponent                           *
*        R5: number of bytes of FpconWork used for number             *
*        R6: exponent value                                           *
***********************************************************************
         SR    R2,R2               Indicate no digits yet
         SR    R3,R3               Assume positive exponent
         CLC   FpconPlus,0(R1)     Positive exponent?
         JE    ToValue0220             yes: branch
         CLC   FpconMinus,0(R1)    Negative exponent?
         JNE   ToValue0230             no: branch
         BCTR  R3,0                Indicate negative exponent
ToValue0220 DC 0h'0'
         LA    R1,1(,R1)           Point to next character
         CLGRJNL   R1,R0,ReturnBadString No more characters: branch
ToValue0230 DC 0h'0'               For each exponent digit:
         CLC   FpconBlank,0(R1)        end of string?
         JE    ToValue0250                 yes: branch
         CLC   FpconZero,0(R1)         valid digit?
         JH    ReturnBadString             no: branch
         CLC   FpconNine,0(R1)             *
         JL    ReturnBadString             no: branch
         LHI   R2,1                    indicate digit found
         CHI   R6,9999                 Exponent too big?
         JH    ToValue0240                 yes: branch
         IC    R11,0(,R1)              Accumulate exponent value
         NILF  R11,15                      *
         MHI   R6,10                       *
         AR    R6,R11                      *
ToValue0240 DC 0h'0'               For each exponent digit:
         LA    R1,1(,R1)               Point to next character
         CLGRJL   R1,R0,ToValue0230    More characters: branch
ToValue0250 DC 0h'0'
         CIJE  R2,0,ReturnBadString No exponent digits: branch
         CIJE  R3,0,ToValue0280    Non-negative exponent: branch
         LCR   R6,R6               convert to negative
         J     ToValue0280         go check end of string
         SPACE 1
ToValue0260 DC 0h'0'               Ensure rest of string is blank
         CLC   FpconBlank,0(R1)        *
         JNE   ReturnBadString         non-blank: branch
ToValue0270 DC 0h'0'                   *
         LA    R1,1(,R1)               *
ToValue0280 DC 0h'0'                   *
         CLGRJL   R1,R0,ToValue0260    *
         SPACE 1
         CHI   R6,9999             Is exponent too big?
         JH    ToValueOverflow         yes: branch
         CHI   R6,-9999            Is exponent too small?
         JL    ToValueUnderflow        yes: branch
         AR    R4,R6               Update exponent value
         SPACE 1
***********************************************************************
*    Done with processing the string.  Convert to floating point.     *
*        R4: exponent (power of 10)                                   *
*        R5: number of bytes of FpconWork used for number             *
*            For decimal, number is base-10 with each digit in a      *
*            separate byte and with implied decimal point at end.     *
*            Otherwise, number is base-256 with implied decimal       *
*            point at FpconWork+BinDigitsToString                     *
***********************************************************************
ToValue0300 DC 0h'0'
         CIJE  R5,0,ToValueZero    Number is zero: branch
         CLI   FpconBase,FpconBase10 Decimal floating point?
         JE    ToValue1500             yes: branch
         SPACE 1
***********************************************************************
*    Estimate the actual exponent.  This will purposely be a little   *
*    on the low side to ensure that valid numbers are not rejected.   *
***********************************************************************
         LA    R11,FpconWork+BinDigitsToString Point to first digit
         SGFR   R11,R5                 in binary string
         LLC   R0,0(,R11)          Compute the largest power of 2
         LR    R14,R5                  not more than the mantissa
         BCTR  R14,0                   *
         SLL   R14,3                   *
ToValue0310 DC 0h'0'                   *
         SRA   R0,1                    *
         JZ    ToValue0320             *
         AHI   R14,1                   *
         J     ToValue0310             *
ToValue0320 DC 0h'0'
* The power-of-10 exponent can be converted to a power-of-2
* exponent by multiplying by LN(10)/LN(2) or 3.321928095
         LR    R1,R4                   *
         M     R0,=FS24'3.321928'      *
         SRDA  R0,24                   *
         AR    R14,R1                  *
         CLI   FpconBase,FpconBase2 Binary floating point?
         JE    ToValue0330             yes: branch
         CHI   R14,252             Too large?
         JH    ToValueOverFlow         yes: branch
         CHI   R14,-261            Too small?
         JNL   ToValue0400             no: branch
         J     ToValueUnderflow        yes: branch
ToValue0330 DC 0h'0'
         CLI   FpconValueLen,FpconValueLenE Short Binary?
         JE    ToValue0340             yes: branch
         CLI   FpconValueLen,FpconValueLenD Long Binary?
         JE    ToValue0350             yes: branch
         CHI   R14,16384           Too large?
         JH    ToValueOverFlow         yes: branch
         CHI   R14,-16495          Too small?
         JNL   ToValue0400             no: branch
         J     ToValueUnderflow        yes: branch
ToValue0340 DC 0h'0'
         CHI   R14,128             Too large?
         JH    ToValueOverFlow         yes: branch
         CHI   R14,-150            Too small?
         JNL   ToValue0400             no: branch
         J     ToValueUnderflow        yes: branch
ToValue0350 DC 0h'0'
         CHI   R14,1024            Too large?
         JH    ToValueOverFlow         yes: branch
         CHI   R14,-1075           Too small?
         JL    ToValueUnderflow        yes: branch
         SPACE 1
***********************************************************************
*    The number is not too far out of range.  Next, either multiply   *
*    or divide the mantissa by 10 to the exponent power.              *
*        R4: exponent (power of 10)                                   *
*        R5: number of bytes of FpconWork used for number             *
*        R11: address of first binary digit in FpconWork              *
***********************************************************************
ToValue0400 DC 0h'0'
         CIJH  R4,0,ToValue0500    Positive exponent: branch
***********************************************************************
*    The number needs to be divided by a power of 10.  Since a        *
*    a repeating fraction will result, compute how many digits        *
*    of fraction to keep. An additional byte of fraction is needed    *
*    for each LN(10)/LN(256)*exponent, or 0.41524101186*exponent.     *
***********************************************************************
         LCR   R4,R4               Get number of times to divide by 10
         LR    R1,R4               Compute fraction digits needed
         M     R0,=FS24'.415241'       *
         SRDA  R0,24                   *
         AHI   R1,BinDigitsToString+1  *
         SLR   R1,R5                   *
         LHI   R0,L'FpconWork-BinDigitsToString
         CRJL  R1,R0,ToValue0410   Ensure within work area
         LR    R1,R0                   *
ToValue0410 DC 0h'0'
         LA    R0,FpconWork+BinDigitsToString
         SR    R3,R3               Clear fraction
         MVCL  R0,R2                   *
         LGR   R14,R0              Get address of end of number
***********************************************************************
*    For "exponent" times, divide the mantissa by 10.                 *
*        R4: exponent (power of 10)                                   *
*        R11: address of first binary digit in FpconWork              *
*        R14: address of end of number in FpconWork                   *
***********************************************************************
         CIJNH R4,0,ToValue0490    Zero exponent: branch
ToValue0430 DC 0h'0'               Until the exponent is zero:
         LGR   R2,R11                  Point to first non-zero digit
         SR    R0,R0                   Set remainder to zero
         LHI   R3,10                   Set divisor to 10
ToValue0440 DC 0h'0'                   For each digit:
         LR    R1,R0                       divident =
         SLL   R1,8                            remainder *= 256
         IC    R1,0(,R2)                       + digit
         SR    R0,R0                       Divide by 10
         DR    R0,R3                           *
         STC   R1,0(,R2)                   Save quotient
         LA    R2,1(,R2)                   point to next digit
         CLGRJL   R2,R14,ToValue0440       not end of number: branch
         CHI   R0,128                  Need to round?
         JL    ToValue0460                 no: branch
ToValue0450 DC 0h'0'                   Increment the number
*MCALL #=    19 LV= 2          BCTGR   R2,0                      *
         LAY   R2,-1(,R2)
*MEXIT #=    19 LV= 2 BCTGR
         IC    R1,0(,R2)                   *
         AHI   R1,1                        *
         STC   R1,0(,R2)                   *
         SRA   R1,8                        *
         JNZ   ToValue0450                 *
ToValue0460 DC 0h'0'                   Locate first non-zero digit
         CLI   0(R11),0                    *
         JNE   ToValue0470                 *
         LA    R11,1(,R11)                 *
         CLGRJL   R11,R14,ToValue0460      no underflow: branch
         J     ToValueUnderflow            underflow: branch
ToValue0470 DC 0h'0'
         BRCT  R4,ToValue0430          Go divide by 10 again
         SPACE 1
ToValue0490 DC 0h'0'                   Compute power-of-256 exponent
         LA    R0,FpconWork+BinDigitsToString
         SLGR   R0,R11                     *
         J     ToValue0600             Go convert to floating point
         SPACE 1
***********************************************************************
*    The number needs to be multiplied by a power of 10.              *
***********************************************************************
ToValue0500 DC 0h'0'               Move number to end of work area
         MVC   FpconWork+L'FpconWork-BinDigitsToString(BinDigitsToStrinX
               g),FpconWork
         LA    R14,FpconWork+L'FpconWork Get address of end of number
         LA    R11,FpconWork+L'FpconWork Get address of start of number
         SGFR   R11,R5                 *
         LA    R3,FpconWork        Get address of start of work area
ToValue0510 DC 0h'0'               Do until exponent is zero:
*MCALL #=    20 LV= 2          BCTGR   R14,0                 Find last X
               non-zero digit
         LAY   R14,-1(,R14)
*MEXIT #=    20 LV= 2 BCTGR
ToValue0520 DC 0h'0'                       *
         CLI   0(R14),0                    *
         JE    ToValue0510                 *
         SR    R0,R0                   Set carry to zero
         SR    R1,R1                   Clear work register
         LGR   R2,R14                  For each digit:
ToValue0530 DC 0h'0'                       *
         IC    R1,0(,R2)                   get the digit
         MHI   R1,10                       times 10
         AR    R1,R0                       plus the carry
         STC   R1,0(,R2)                   save the new value
         SRL   R1,8                        get the carry
         LR    R0,R1                           *
*MCALL #=    21 LV= 2          BCTGR   R2,0                      point X
               to next digit
         LAY   R2,-1(,R2)
*MEXIT #=    21 LV= 2 BCTGR
         CLGRJNL   R2,R11,ToValue0530      not start of number: branch
         CIJE  R0,0,ToValue0540        no carry from high-order: branch
         CLGRJL   R2,R3,ToValueOverflow value overflowed: branch
         STC   R0,0(,R2)               set new high-order digit
         LGR   R11,R2                      *
ToValue0540 DC 0h'0'                   *
         BRCT  R4,ToValue0520          Go multiply by 10 again
         LA    R0,FpconWork+L'FpconWork
         SLGR   R0,R11             Compute power-of-256 exponent
         LA    R14,FpconWork+L'FpconWork Get address of end of number
         SPACE 1
***********************************************************************
* The number is ready to be converted from binary to floating point.  *
*        R0: exponent (power of 256)                                  *
*        R11: address of first non-zero binary digit in FpconWork     *
*             number is base-256 with implied decimal point just      *
*             before the digit at R11                                 *
*        R14: address of end of number in FpconWork                   *
***********************************************************************
ToValue0600 DC 0h'0'
         CLI   FpconBase,FpconBase2 Binary formmat?
         JE    ToValue1000             yes: branch
         AR    R0,R0               Compute hexadecimal exponent
         TM    0(R11),X'F0'        Need to shift value?
         JNZ   ToValue0620             no: branch
         BCTR  R0,0                Decrement exponent
         SR    R1,R1               Shift the value 4 bits left
         SR    R4,R4                   *
         LA    R3,15(,R11)             (15 bytes maximum)
         CLGRJL   R3,R14,ToValue0610   *
         LGR   R3,R14                  *
ToValue0610 DC 0h'0'                   *
*MCALL #=    22 LV= 2          BCTGR   R3,0                  *
         LAY   R3,-1(,R3)
*MEXIT #=    22 LV= 2 BCTGR
         IC    R4,0(,R3)               *
         SLL   R4,4                    *
         OR    R4,R1                   *
         STC   R4,0(,R3)               *
         SRL   R4,8                    *
         LR    R1,R4                   *
         CLGRJH   R3,R11,ToValue0610   *
ToValue0620 DC 0h'0'               Get address of bit past end of
         LA    R1,3(,R11)              floating point mantissa
         CLI   FpconValueLen,FpconValueLenE
         JE    ToValue0630             *
         LA    R1,7(,R11)              *
         CLI   FpconValueLen,FpconValueLenD
         JE    ToValue0630             *
         LA    R1,14(,R11)             *
ToValue0630 DC 0h'0'
         CLGRJNL   R1,R14,ToValue0650 Past end of number: branch
         TM    0(R1),X'80'         Need to round?
         JZ    ToValue0650             no: branch
         SR    R2,R2               Increment number
ToValue0640 DC 0h'0'                   *
*MCALL #=    23 LV= 2          BCTGR   R1,0                  *
         LAY   R1,-1(,R1)
*MEXIT #=    23 LV= 2 BCTGR
         IC    R2,0(,R1)               *
         AHI   R2,1                    *
         STC   R2,0(,R1)               *
         SRA   R2,8                    *
         JZ    ToValue0650             no more carry: branch
         CLGRJNH   R1,R11,ToValue0640  *
* Overflow after rounding:
         AR    R0,R2               Increment exponent
         LA    R11,FpconWork       Set number to 1
         MVI   FpconWork,X'10'         with all trailing zeros
         XC    FpconWork+1(15),FpconWork+1
         LA    R14,FpconWork+16        *
ToValue0650 DC 0h'0'
         AHI   R0,64               Compute biased exponent
         JM    ToValue0700             still negative: branch
         CIJH  R0,127,ToValueOverflow Too large: branch
         LA    R2,FpconValueE+1    Point to start of output mantissa
         CLI   FpconValueLen,FpconValueLenE Short value?
         JE    ToValue0660             yes: branch
         LA    R1,7(,R11)          Point to end of long number
         CLGRJH   R1,R14,ToValue0670 Past end of number: branch
         MVC   0(7,R2),0(R11)      Copy long mantissa
         CLI   FpconValueLen,FpconValueLenD Long value?
         JE    ToValue0800             yes: branch
         LA    R2,FpconValueE+9    Point to start of 2nd half
         LGR   R11,R1                  *
         LA    R1,7(,R11)          Point to end of extended number
         CLGRJH   R1,R14,ToValue0670 Past end of number: branch
         MVC   0(7,R2),0(R11)      Copy extended mantissa
         J     ToValue0800
ToValue0660 DC 0h'0'
         LA    R1,3(,R11)          Point to end of short number
         CLGRJH   R1,R14,ToValue0670 Past end of number: branch
         MVC   0(3,R2),0(R11)      Copy short mantissa
         J     ToValue0800
ToValue0670 DC 0h'0'               Copy rest of number
         SLGR   R14,R11                *
         BCTR  R14,0                   *
         EXRL  R14,MVC_R2_R11          *
         J     ToValue0800             *
         SPACE 1
***********************************************************************
*    The value is too small to be converted without denormalizing.    *
*    This is probably not a good idea, so for now, just set the       *
*    result to zero.  If someone wants denormalized numbers,          *
*    support would be added here.  Note: it is fairly complex         *
*    logic due to all of the shifting and rounding needed.            *
***********************************************************************
ToValue0700 DC 0h'0'
         J     ToValueUnderflow
         SPACE 1
***********************************************************************
*    The mantissa of the hexadecimal floating point value has         *
*    been converted.  All that remains is to store the exponent.      *
***********************************************************************
ToValue0800 DC 0h'0'
         TM    FpconValueE,X'80'   Negative number?
         JZ    ToValue0810             no: branch
         STC   R0,FpconValueE      Set the baised exponent
         OI    FpconValueE,X'80'   Make number negative
         J     ToValue0820
ToValue0810 DC 0h'0'
         STC   R0,FpconValueE      Set the biased exponent
ToValue0820 DC 0h'0'
         CLI   FpconValueLen,FpconValueLenL Extended value?
         JNE   ReturnOk                no: branch
         AHI   R0,-14              Compute 2nd biased exponent
         STC   R0,FpconValueL+8        *
         NI    FpconValueL+8,X'7F'     *
         TM    FpconValueL,X'80'   Negative number?
         JZ    ReturnOk                no: branch
         OI    FpconValueL+8,X'80' Make 2nd number negative
         J     ReturnOk
         SPACE 2
***********************************************************************
* The number is ready to be converted from binary to BFP format.      *
*        R0: exponent (power of 256)                                  *
*        R11: address of first non-zero binary digit in FpconWork     *
*             number is base-256 with implied decimal point just      *
*             before the digit at R11                                 *
*        R14: address of end of number in FpconWork                   *
***********************************************************************
ToValue1000 DC 0h'0'
         BCTR  R0,0                Compute binary exponent
         SLA   R0,3                    *
         TM    0(R11),X'F0'        Compute right shift bits in R5
         JZ    ToValue1020             (This is a binary search
         TM    0(R11),X'C0'            for the highest 1 bit.)
         JZ    ToValue1010             *
         LHI   R5,7                    *
         TM    0(R11),X'80'            *
         JNZ   ToValue1040             *
         LHI   R5,6                    *
         J     ToValue1040             *
ToValue1010 DC 0h'0'                   *
         LHI   R5,5                    *
         TM    0(R11),X'20'            *
         JNZ   ToValue1040             *
         LHI   R5,4                    *
         J     ToValue1040             *
ToValue1020 DC 0h'0'                   *
         TM    0(R11),X'0C'            *
         JZ    ToValue1030             *
         LHI   R5,3                    *
         TM    0(R11),X'08'            *
         JNZ   ToValue1040             *
         LHI   R5,2                    *
         J     ToValue1040             *
ToValue1030 DC 0h'0'                   *
         TM    0(R11),X'02'            *
         JZ    ToValue1100             none: branch
         LHI   R5,1                    *
ToValue1040 DC 0h'0'
         AR    R0,R5               Update exponent
         SR    R1,R1               Shift the value to the right
         LGR   R3,R11                  *
         LHI   R6,16                   (16 bytes maximum)
ToValue1050 DC 0h'0'                   *
         IC    R1,0(,R3)               *
         LR    R4,R1                   *
         SLL   R1,8                    *
         SRL   R4,0(R5)                *
         STC   R4,0(,R3)               *
         LA    R3,1(,R3)               *
         CLGRJNL   R3,R14,ToValue1060  end of number: branch
         BRCT  R6,ToValue1050          *
         J     ToValue1080             *
ToValue1060 DC 0h'0'
         LA    R3,FpconWork+L'FpconWork Number can be extended
         CLGRJL   R14,R3,ToValue1100   in place: branch
         SLGR   R14,R11            Compute length of number
         LR    R3,R14              Move number to start
         BCTR  R3,0                    of work area
         EXRL  R3,ToValue1060_MVC      *
Static   LOCTR ,
ToValue1060_MVC MVC FpconWork(0),0(R11) EXecuted instruction
ToValue  LOCTR ,
         LA    R11,FpconWork       Get address of start
         LA    R14,FpconWork(R14)      and end of number
         LGR   R3,R14              Add another digit to number
         LA    R14,1(,R14)             *
ToValue1080 DC 0h'0'
         SRL   R1,0(R5)            Save carry from last byte
         STC   R1,0(,R3)               *
         SPACE 1
***********************************************************************
* The number is has been shifted so that it starts with X'01'         *
*        R0: exponent (power of 2)                                    *
*        R11: address of start of number in FpconWork                 *
*        R14: address of end of number in FpconWork                   *
***********************************************************************
ToValue1100 DC 0h'0'
         SR    R1,R1               Clear work register
         CLI   FpconValueLen,FpconValueLenE Short?
         JE    ToValue1110             yes: branch
         CLI   FpconValueLen,FpconValueLenD Long?
         JE    ToValue1120             yes: branch
         SPACE 1
         LA    R3,15(,R11)         Get location of rounding bit
         LA    R4,FpconValueL+2    Get address of mantissa in value
         LA    R5,L'FpconValueL-2  Get length of mantissa
         LHI   R6,16383            Get maximum exponent
         SR    R7,R7               Get bits to shift exponent
         CLGRJH   R3,R14,ToValue1150 Past end of number: branch
         LGR   R14,R3              Truncate number
         TM    0(R3),X'80'         Need to round?
         JZ    ToValue1150             no: branch
         LGR    R3,R14              Go increment value
         J     ToValue1130             *
         SPACE 1
ToValue1110 DC 0h'0'               Short binary:
         LA    R3,3(,R11)          Get location of rounding bit
         LA    R4,FpconValueE+1    Get address of mantissa in value
         LA    R5,L'FpconValueE-1  Get length of manissa
         LHI   R6,127              Get maximum exponent
         LHI   R7,7                Get bits to shift exponent
         CLGRJH   R3,R14,ToValue1150 Past end of number: branch
         LA    R14,1(,R3)          Truncate number
         TM    0(R3),1             Need to round number?
         JZ    ToValue1150             no: branch
         LGR   R3,R14              Go increment number
         J     ToValue1130             *
         SPACE 1
ToValue1120 DC 0h'0'               Long binary:
         LA    R3,7(,R11)          Get location of rounding bit
         LA    R4,FpconValueD+2    Get address of mantissa in value
         LA    R5,L'FpconValueD-2  Get length of mantissa
         LHI   R6,1023             Get maximum exponent
         LHI   R7,4                Get bits to shift exponent
         CLGRJH   R3,R14,ToValue1150 Past end of number: branch
         LA    R14,1(,R3)          Truncate number
         TM    0(R3),X'08'         Need to round number
         JZ    ToValue1150             no: branch
         OI    0(R3),X'0F'         Force increment
         LGR   R3,R14                  *
         SPACE 1
ToValue1130 DC 0h'0'               Increment number due to rounding
*MCALL #=    24 LV= 2          BCTGR   R3,0                  *
         LAY   R3,-1(,R3)
*MEXIT #=    24 LV= 2 BCTGR
         IC    R1,0(,R3)               *
         AHI   R1,1                    *
         STC   R1,0(,R3)               *
         SRA   R1,8                    *
         JNZ   ToValue1130             *
* It is possible that the high order digit is now X'02'
* if before rounding the number was X'01FFFFF...'
         CLI   0(R11),1            Is high-order digit still 1?
         JE    ToValue1150             yes: branch
         MVI   0(R11),1            Set number to back to 1
         LA    R14,1(,R11)             *
         AHI   R0,1                Increment exponent
         SPACE 1
***********************************************************************
* The number is has been rounded and still starts with X'01'.         *
*        R0: exponent (power of 2)                                    *
*        R4: address of mantissa in value                             *
*        R5: length of mantissa in value                              *
*        R6: exponent maximum and bias                                *
*        R7: bits to shift exponent left in halfword                  *
*        R11: address of start of number in FpconWork                 *
*        R14: address of end of number in FpconWork                   *
***********************************************************************
ToValue1150 DC 0h'0'
         CRJH  R0,R6,ToValueOverflow Exponent is too large: branch
         AR    R0,R6               Compute biased exponent
         JNP   ToValueUnderflow        too small: branch
         CLI   FpconValueLen,FpconValueLenE Short?
         JE    ToValue1170             yes: branch
         CLI   FpconValueLen,FpconValueLenD Long?
         JNE   ToValue1200             no: branch
         SPACE 1
         SR    R1,R1               Shift the value 4 bits left
         SR    R2,R2                   *
         LGR   R3,R14                  *
ToValue1160 DC 0h'0'                   *
*MCALL #=    25 LV= 2          BCTGR   R3,0                  *
         LAY   R3,-1(,R3)
*MEXIT #=    25 LV= 2 BCTGR
         IC    R2,0(,R3)               *
         SLL   R2,4                    *
         OR    R2,R1                   *
         STC   R2,0(,R3)               *
         SRL   R2,8                    *
         LR    R1,R2                   *
         CLGRJH   R3,R11,ToValue1160   *
*MCALL #=    26 LV= 2          BCTGR   R14,0             Last byte is nX
               ow zero
         LAY   R14,-1(,R14)
*MEXIT #=    26 LV= 2 BCTGR
         MVN   FpconValueD+1(1),0(R11) Copy the first digit
         J     ToValue1200
         SPACE 1
ToValue1170 DC 0h'0'
         LA    R3,1(,R11)          Any fraction digits to shift?
         CLGRJNL   R3,R14,ToValue1220  no: branch
         SR    R1,R1               Shift the fraction 1 bit right
ToValue1180 DC 0h'0'                   *
         LLC   R2,0(,R3)               *
         OR    R2,R1                   *
         LR    R1,R2                   *
         SRL   R2,1                    *
         STC   R2,0(,R3)               *
         SLL   R1,8                    *
         LA    R3,1(,R3)               *
         CLGRJL   R3,R14,ToValue1180   *
         SPACE 1
ToValue1200 DC 0h'0'
         LA    R11,1(,R11)         Skip X'01' byte
         SGR   R14,R11             Copy the mantissa
         JNP   ToValue1220             *
         CRJL  R14,R5,ToValue1210      *
         LR    R14,R5                  *
ToValue1210 DC 0h'0'                   *
         BCTR  R14,0                   *
         EXRL  R14,MVC_R4_R11          *
ToValue1220 DC 0h'0'
         SLL   R0,0(R7)            Get exponent in correct position
         LH    R1,FpconValueE      OR into first halfword of value
         OR    R1,R0                   *
         STH   R1,FpconValueE          *
         J     ReturnOk            All done!
         SPACE 1
***********************************************************************
*    Convert non-zero number to decimal floating point value.         *
*        R4: exponent (power of 10)                                   *
*        R5: number of bytes of FpconWork used for number.            *
*            Number is base-10 with each digit in a separate          *
*            byte and with the implied decimal point at end.          *
***********************************************************************
ToValue1500 DC 0h'0'
         CLI   FpconValueLen,FpconValueLenD Long value?
         JE    ToValue1520             yes: branch
         CLI   FpconValueLen,FpconValueLenE Short value?
         JE    ToValue1510             yes: branch
         LA    R1,34               Number of digits for extended
         LHI   R0,12287            Maximum exponent
         AHI   R4,6176             Add exponent bais
         J     ToValue1530
ToValue1510 DC 0h'0'
         LA    R1,7                Number of digits for short
         LHI   R0,191              Maximum exponent
         AHI   R4,101              Add exponent bias
         J     ToValue1530
ToValue1520 DC 0h'0'
         LA    R1,16               Number of digits for long
         LHI   R0,767              Maximum exponent
         AHI   R4,398              Add exponent bias
         SPACE 1
ToValue1530 DC 0h'0'               While exponent is too large:
         CRJNL R0,R4,ToValue1540       exponent not too large: branch
         LA    R14,FpconWork(R5)       get address of next digit
         CRJNL R5,R1,ToValueOverflow   too many digits: branch
         MVI   0(R14),0                add another zero
         AHI   R5,1                    increment number of digits
         BRCT  R4,ToValue1530          decrement exponent
         SPACE 1
ToValue1540 DC 0h'0'
         CIJNL R4,0,ToValue1560    Exponent not too small: branch
         AR    R5,R4               Are any digits left?
         JNP   ToValueUnderflow        no: branch
         SR    R4,R4               Exponent is now zero
         LA    R14,FpconWork-1(R5) Get address of new last digit
         CLI   1(R14),5            Need to round up?
         JL    ToValue1560             no: branch
         LA    R0,FpconWork        Get address of first digit
         SR    R15,R15             Round up value
ToValue1550 DC 0h'0'                   *
         IC    R15,0(,R14)             *
         AHI   R15,1                   *
         STC   R15,0(,R14)             *
         CIJNH R15,9,ToValue1560       no carry: branch
         MVI   0(R14),0                *
*MCALL #=    27 LV= 2          BCTGR   R14,0                 *
         LAY   R14,-1(,R14)
*MEXIT #=    27 LV= 2 BCTGR
         CLGRJNH   R0,R14,ToValue1550  *
         MVI   FpconWork,1         All 9's, so set to 10000...
         AHI   R4,1                Increment exponent
         SPACE 1
ToValue1560 DC 0h'0'
         SR    R1,R5               Compute # of zeros to prepend
         JNP   ToValue1600             none: branch
         LA    R15,FpconWork-1(R5) Shift digits to end of value
         LA    R14,0(R1,R15)           *
ToValue1570 DC 0h'0'                   *
         MVC   0(1,R14),0(R15)         *
*MCALL #=    28 LV= 2          BCTGR   R14,0                 *
         LAY   R14,-1(,R14)
*MEXIT #=    28 LV= 2 BCTGR
*MCALL #=    29 LV= 2          BCTGR   R15,0                 *
         LAY   R15,-1(,R15)
*MEXIT #=    29 LV= 2 BCTGR
         BRCT  R5,ToValue1570          *
         BCTR  R1,0                Set leading digits to zero
         EXRL  R1,ToValue1570_XC       *
Static   LOCTR ,
ToValue1570_XC XC FpconWork(0),FpconWork EXecuted instruction
ToValue  LOCTR ,
         SPACE 1
***********************************************************************
*    Convert digits in FpconWork to decimal floating point value.     *
*        R4: biased exponent                                          *
*        Value in FpconWork is the correct number of digits           *
*        for the size of the floating point value.                    *
***********************************************************************
ToValue1600 DC 0h'0'
         MVC   FpconWork+32(1),FpconValueE  Save sign bit
         STD   FPR0,FpconWork      Save FPR0
         CLI   FpconValueLen,FpconValueLenD Long value?
         JE    ToValue1610             yes: branch
         CLI   FpconValueLen,FpconValueLenL Extended value?
         JE    ToValue1620             yes: branch
         PACK  FpconWork+8(5),FpconWork(8) Pack digits
         LGF   R0,FpconWork+8      Convert digits to DFP
         CDUTR FPR0,R0                 *
         AHI   R4,398-101          Set exponent
         IEDTR FPR0,FPR0,R4            *
         LEDTR FPR0,0,FPR0,0       Convert to short
         STE   FPR0,FpconValueE    Return short value
         J     ToValue1640         Set sign and return
ToValue1610 DC 0h'0'               Long DFP:
         PACK  FpconWork+16(8),FpconWork(15) Pack digits
         PACK  FpconWork+16+7(2),FpconWork+14(3)
         LG    R0,FpconWork+16     Convert digits to DFP
         CDUTR FPR0,R0                 *
         IEDTR FPR0,FPR0,R4        Set exponent
         STD   FPR0,FpconValueD    Return long value
         J     ToValue1640         Set sign and return
ToValue1620 DC 0h'0'               Extended DFP:
         STD   FPR2,FpconWork+8    Save FPR2
         PACK  FpconWork+39(8),FpconWork(15) Pack digits
         PACK  FpconWork+39+7(8),FpconWork+14(15)
         PACK  FpconWork+39+14(4),FpconWork+28(7)
         LMG   R0,R1,FpconWork+40  Convert low-order digits to DFP
         CXUTR FPR0,R0                 *
         LLGC  R1,FpconWork+39     Get high-order 2 digits
         CIJE  R1,0,ToValue1630    High order 2 digits are zero: branch
         STD   FPR4,FpconWork+16   Save FPR4
         STD   FPR6,FpconWork+24    and FPR6
         SGR   R0,R0               Convert high-order digits to DFP
         CXUTR FPR4,R0                 *
         SLXT  FPR4,FPR4,32        Shift to high order
         AXTR  FPR0,FPR0,FPR4      Add high-order digits
         LD    FPR4,FpconWork+16   Restore FPR4
         LD    FPR6,FpconWork+24       and FPR6
ToValue1630 DC 0h'0'
         IEXTR FPR0,FPR0,R4        Set exponent
         STD   FPR0,FpconValueL    Return extended value
         STD   FPR2,FpconValueL+8      *
         LD    FPR2,FpconWork+8    Restore FPR2
ToValue1640 DC 0h'0'
         LD    FPR0,FpconWork      Restore FPR0
         OC    FpconValueE(1),FpconWork+32   Set sign bit
         J     ReturnOk            All done!
         SPACE 1
***********************************************************************
*        The number is too large.  Set the number to (MAX) and        *
*        return with the appropriate return code.                     *
***********************************************************************
ToValueOverflow DC 0h'0'
         CLI   FpconBase,FpconBase2 Binary format?
         JE    ToValueOverflowB        yes: branch
         CLI   FpconBase,FpconBase10 Decimal format?
         JE    ToValueOverflowD        yes: branch
         CLI   FpconValueLen,FpconValueLenE Short?
         JE    ToValueOverflowEH       yes: branch
         CLI   FpconValueLen,FpconValueLenD Long?
         JE    ToValueOverflowDH       yes: branch
         MVC   FpconValueL+8(1),FpconValueL Copy sign to second half
         OC    FpconValueL,=LH'(MAX)'    Set to extended maximum value
         J     ReturnOverflow
ToValueOverflowEH DC 0h'0'
         OC    FpconValueE,=LH'(MAX)'    Set to short maximum value
         J     ReturnOverflow
ToValueOverflowDH DC 0h'0'
         OC    FpconValueD,=LH'(MAX)'    Set to long maximum value
         J     ReturnOverflow
ToValueOverflowB DC 0h'0'
         CLI   FpconValueLen,FpconValueLenE Short binary?
         JE    ToValueOverflowEB       yes: branch
         CLI   FpconValueLen,FpconValueLenD Long binary?
         JE    ToValueOverflowDB       yes: branch
         OC    FpconValueL,=LB'(MAX)'    Set to extended maxiumum value
         J     ReturnOverflow
ToValueOverflowEB DC 0h'0'
         OC    FpconValueE,=EB'(MAX)'    Set to short maximum value
         J     ReturnOverflow
ToValueOverflowDB DC 0h'0'
         OC    FpconValueD,=DB'(MAX)'    Set to long maximum value
         J     ReturnOverflow
ToValueOverflowD DC 0h'0'
         CLI   FpconValueLen,FpconValueLenE Short decimal?
         JE    ToValueOverflowED       yes: branch
         CLI   FpconValueLen,FpconValueLenD Long decimal?
         JE    ToValueOverflowDD       yes: branch
         OC    FpconValueL,=LD'(MAX)'    Set to extended maxiumum value
         J     ReturnOverflow
ToValueOverflowED DC 0h'0'
         OC    FpconValueE,=ED'(MAX)'    Set to short maximum value
         J     ReturnOverflow
ToValueOverflowDD DC 0h'0'
         OC    FpconValueD,=DD'(MAX)'    Set to long maximum value
         J     ReturnOverflow
         SPACE 1
ToValueUnderflow DC 0h'0'
***********************************************************************
*        The number is too small.  Just set it to zero.               *
***********************************************************************
         MVI   FpconReturnCode+3,FpconRetUndFlo Indicate underflow
         SPACE 1
ToValueZero DC 0h'0'
***********************************************************************
*        The number is zero.  Leave the sign for IEEE format.         *
*        Remove the sign for IBM S/360 format.                        *
***********************************************************************
         CLI   FpconBase,FpconBase16 S/360 format?
         JNE   ReturnOk                no: branch (leave sign)
         MVI   FpconValueL,0       Clear sign bit
         J     ReturnOk            Done with conversion
         SPACE 1
         DROP  ,
         PRINT NoUhead
         TITLE 'Floating Point Conversion - Static Storage'
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*                                                                     *
*        Static Data Area - Addressible via R12                       *
*                                                                     *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Static   LOCTR ,
         SPACE 1
MVC_R4_R3  MVC 0(0,R4),0(R3)       EXecuted instruction
MVC_R3_R4  MVC 0(0,R3),0(R4)       EXecuted instruction
MVC_R2_R11 MVC 0(0,R2),0(R11)      EXecuted instruction
MVC_R4_R11 MVC 0(0,R4),0(R11)      EXecuted instruction
XC_R3_R3   XC  0(0,R3),0(R3)       EXecuted instruction
         SPACE 1
         LTORG ,
         SPACE 1
EBCDIC   DC    X'F0 4E 60 4B C5 85 40'    0 + - . E e blank
ASCII    DC    X'30 2B 2D 2E 45 65 20'    0 + - . E e blank
         SPACE 1
StaticEnd DC   0d'0'
         SPACE 1
*        Register Equates
R0       EQU   0,,,,GR
R1       EQU   1,,,,GR
R2       EQU   2,,,,GR
R3       EQU   3,,,,GR
R4       EQU   4,,,,GR
R5       EQU   5,,,,GR
R6       EQU   6,,,,GR
R7       EQU   7,,,,GR
R8       EQU   8,,,,GR
R9       EQU   9,,,,GR
R10      EQU   10,,,,GR
R11      EQU   11,,,,GR
R12      EQU   12,,,,GR
R13      EQU   13,,,,GR
R14      EQU   14,,,,GR
R15      EQU   15,,,,GR
         SPACE 1
FPR0     EQU   0,,,,FPR
FPR1     EQU   1,,,,FPR
FPR2     EQU   2,,,,FPR
FPR3     EQU   3,,,,FPR
FPR4     EQU   4,,,,FPR
FPR5     EQU   5,,,,FPR
FPR6     EQU   6,,,,FPR
FPR7     EQU   7,,,,FPR
FPR8     EQU   8,,,,FPR
FPR9     EQU   9,,,,FPR
FPR10    EQU   10,,,,FPR
FPR11    EQU   11,,,,FPR
FPR12    EQU   12,,,,FPR
FPR13    EQU   13,,,,FPR
FPR14    EQU   14,,,,FPR
FPR15    EQU   15,,,,FPR
         SPACE 1
Charset  DSECT ,                   EBCDIC/ASCII character set tables
CsZero      DS C                       Zero character
CsPlus      DS C                       Plus sign
CsMinus     DS C                       Minus sign
CsDecimal   DS C                       Decimal point symbol
CsExponent  DS C                       Uppercase 'E'
CsExpAlt    DS C                       Lowercase 'e'
CsBlank     DS C                       Blank character
CharsetEnd EQU *
*MEXIT #=     2 LV= 1 FPCONVRT
*
* NOTE ARCHLVL 2-5 MUST MATCH ARCHLVL IN FPCONMFC.MLC FOR FPCON DEF.
*
         END 
