SET CICSPATH=cics
SET ZC39PATH=zcobol\z390
SET PROGPATH=linklib

rem
rem COBOL PROGRAMS
rem
SET PROGRAM=TESTBEC1
CALL ZC390CL %CICSPATH%\%PROGRAM% CICS SYSMAC(%CICSPATH%+ZCOBOL+%ZC39PATH%+CICS+MAC) SYSCPY(%CICSPATH%+ZCOBOL+%ZC39PATH%+MAC+.)
IF ERRORLEVEL 1 GOTO WRONG
SET PRNFILE=%CICSPATH%\%PROGRAM%.PRN
SET URFFILE=%CICSPATH%\%PROGRAM%.URF
CALL EZ390 %PROGPATH%\UNREF ASCII %1 %2
IF ERRORLEVEL 1 GOTO WRONG

SET PROGRAM=TESTBEC2
CALL ZC390CL %CICSPATH%\%PROGRAM% CICS SYSMAC(%CICSPATH%+ZCOBOL+%ZC39PATH%+CICS+MAC) SYSCPY(%CICSPATH%+ZCOBOL+%ZC39PATH%+MAC+.)
IF ERRORLEVEL 1 GOTO WRONG
SET PRNFILE=%CICSPATH%\%PROGRAM%.PRN
SET URFFILE=%CICSPATH%\%PROGRAM%.URF
CALL EZ390 %PROGPATH%\UNREF ASCII %1 %2
IF ERRORLEVEL 1 GOTO WRONG

SET PROGRAM=TESTBEC4
CALL ZC390CL %CICSPATH%\%PROGRAM% CICS SYSMAC(%CICSPATH%+ZCOBOL+%ZC39PATH%+CICS+MAC) SYSCPY(%CICSPATH%+ZCOBOL+%ZC39PATH%+MAC+.)
IF ERRORLEVEL 1 GOTO WRONG
SET PRNFILE=%CICSPATH%\%PROGRAM%.PRN
SET URFFILE=%CICSPATH%\%PROGRAM%.URF
CALL EZ390 %PROGPATH%\UNREF ASCII %1 %2
IF ERRORLEVEL 1 GOTO WRONG

SET PROGRAM=TESTBEC5
CALL ZC390CL %CICSPATH%\%PROGRAM% CICS SYSMAC(%CICSPATH%+ZCOBOL+%ZC39PATH%+CICS+MAC) SYSCPY(%CICSPATH%+ZCOBOL+%ZC39PATH%+MAC+.)
IF ERRORLEVEL 1 GOTO WRONG
SET PRNFILE=%CICSPATH%\%PROGRAM%.PRN
SET URFFILE=%CICSPATH%\%PROGRAM%.URF
CALL EZ390 %PROGPATH%\UNREF ASCII %1 %2
IF ERRORLEVEL 1 GOTO WRONG

SET PROGRAM=TESTBEC6
CALL ZC390CL %CICSPATH%\%PROGRAM% CICS SYSMAC(%CICSPATH%+ZCOBOL+%ZC39PATH%+CICS+MAC) SYSCPY(%CICSPATH%+ZCOBOL+%ZC39PATH%+MAC+.)
IF ERRORLEVEL 1 GOTO WRONG
SET PRNFILE=%CICSPATH%\%PROGRAM%.PRN
SET URFFILE=%CICSPATH%\%PROGRAM%.URF
CALL EZ390 %PROGPATH%\UNREF ASCII %1 %2
IF ERRORLEVEL 1 GOTO WRONG

SET PROGRAM=TESTBEC7
CALL ZC390CL %CICSPATH%\%PROGRAM% CICS SYSMAC(%CICSPATH%+ZCOBOL+%ZC39PATH%+CICS+MAC) SYSCPY(%CICSPATH%+ZCOBOL+%ZC39PATH%+MAC+.)
IF ERRORLEVEL 1 GOTO WRONG
SET PRNFILE=%CICSPATH%\%PROGRAM%.PRN
SET URFFILE=%CICSPATH%\%PROGRAM%.URF
CALL EZ390 %PROGPATH%\UNREF ASCII %1 %2
IF ERRORLEVEL 1 GOTO WRONG

SET PROGRAM=TESTBEC8
CALL ZC390CL %CICSPATH%\%PROGRAM% CICS SYSMAC(%CICSPATH%+ZCOBOL+%ZC39PATH%+CICS+MAC) SYSCPY(%CICSPATH%+ZCOBOL+%ZC39PATH%+MAC+.)
IF ERRORLEVEL 1 GOTO WRONG
SET PRNFILE=%CICSPATH%\%PROGRAM%.PRN
SET URFFILE=%CICSPATH%\%PROGRAM%.URF
CALL EZ390 %PROGPATH%\UNREF ASCII %1 %2
IF ERRORLEVEL 1 GOTO WRONG

SET PROGRAM=TESTBEC9
CALL ZC390CL %CICSPATH%\%PROGRAM% CICS SYSMAC(%CICSPATH%+ZCOBOL+%ZC39PATH%+CICS+MAC) SYSCPY(%CICSPATH%+ZCOBOL+%ZC39PATH%+MAC+.)
IF ERRORLEVEL 1 GOTO WRONG
SET PRNFILE=%CICSPATH%\%PROGRAM%.PRN
SET URFFILE=%CICSPATH%\%PROGRAM%.URF
CALL EZ390 %PROGPATH%\UNREF ASCII %1 %2
IF ERRORLEVEL 1 GOTO WRONG

SET PROGRAM=TESTBMC1
CALL ZC390CL %CICSPATH%\%PROGRAM% CICS SYSMAC(%CICSPATH%+ZCOBOL+%ZC39PATH%+CICS+MAC) SYSCPY(%CICSPATH%+ZCOBOL+%ZC39PATH%+MAC+.)
IF ERRORLEVEL 1 GOTO WRONG
SET PRNFILE=%CICSPATH%\%PROGRAM%.PRN
SET URFFILE=%CICSPATH%\%PROGRAM%.URF
CALL EZ390 %PROGPATH%\UNREF ASCII %1 %2
IF ERRORLEVEL 1 GOTO WRONG

SET PROGRAM=TESTICC1
CALL ZC390CL %CICSPATH%\%PROGRAM% CICS SYSMAC(%CICSPATH%+ZCOBOL+%ZC39PATH%+CICS+MAC) SYSCPY(%CICSPATH%+ZCOBOL+%ZC39PATH%+MAC+.)
IF ERRORLEVEL 1 GOTO WRONG
SET PRNFILE=%CICSPATH%\%PROGRAM%.PRN
SET URFFILE=%CICSPATH%\%PROGRAM%.URF
CALL EZ390 %PROGPATH%\UNREF ASCII %1 %2
IF ERRORLEVEL 1 GOTO WRONG

SET PROGRAM=TESTVSC1
CALL ZC390CL %CICSPATH%\%PROGRAM% CICS SYSMAC(%CICSPATH%+ZCOBOL+%ZC39PATH%+CICS+MAC) SYSCPY(%CICSPATH%+ZCOBOL+%ZC39PATH%+MAC+.)
IF ERRORLEVEL 1 GOTO WRONG
SET PRNFILE=%CICSPATH%\%PROGRAM%.PRN
SET URFFILE=%CICSPATH%\%PROGRAM%.URF
CALL EZ390 %PROGPATH%\UNREF ASCII %1 %2
IF ERRORLEVEL 1 GOTO WRONG

SET PROGRAM=TESTVSC2
CALL ZC390CL %CICSPATH%\%PROGRAM% CICS SYSMAC(%CICSPATH%+ZCOBOL+%ZC39PATH%+CICS+MAC) SYSCPY(%CICSPATH%+ZCOBOL+%ZC39PATH%+MAC+.)
IF ERRORLEVEL 1 GOTO WRONG
SET PRNFILE=%CICSPATH%\%PROGRAM%.PRN
SET URFFILE=%CICSPATH%\%PROGRAM%.URF
CALL EZ390 %PROGPATH%\UNREF ASCII %1 %2
IF ERRORLEVEL 1 GOTO WRONG

SET PROGRAM=TESTVSC3
CALL ZC390CL %CICSPATH%\%PROGRAM% CICS SYSMAC(%CICSPATH%+ZCOBOL+%ZC39PATH%+CICS+MAC) SYSCPY(%CICSPATH%+ZCOBOL+%ZC39PATH%+MAC+.)
IF ERRORLEVEL 1 GOTO WRONG
SET PRNFILE=%CICSPATH%\%PROGRAM%.PRN
SET URFFILE=%CICSPATH%\%PROGRAM%.URF
CALL EZ390 %PROGPATH%\UNREF ASCII %1 %2
IF ERRORLEVEL 1 GOTO WRONG

GOTO END
:WRONG
rem ERROR ERROR ERROR
:END
