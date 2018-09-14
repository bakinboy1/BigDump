         TITLE 'RTGENDIF - READ DIF DIR FILES AND CHK FOR MATCHES'
*********************************************************************
* Copyright 2008 Automated Software Tools Corporation               *
* This source code is part of z390 assembler/emulator package       *
* The z390 package is distributed under GNU general public license  *
* Author - Don Higgins                                              *
* Date   - 09/05/08                                                 *
*********************************************************************
* 09/05/08 RPI 797 READ FILENAMES FOR DIF DIR, GEN ERASE FOR MATCHES
* 09/18/08 rpi 911 replace ASELECT>ACASE, APM>ACALL
* 10/29/08 RPI 936 support mult Win ver with diff DIR column settings
*********************************************************************
*
*  RTGENDIR READS FILE &SYSPARM.DAT AND GENERATES &SYSPARM.PCH
*
*  The input file is Windows dir command listing for dif compares
*  The ouput file is erase commands for files that had no differeces.
*
*********************************************************************
         MNOTE 'RTGENDIF SYSPARM=zcobol\test\z390\dif\RTGENDIF'
         PUNCH 'ERASE zcobol\test\z390\dif\COPYFILE.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\DATETIME.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTADD1.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTADD1.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTADD1.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTADD1.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTADD1.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTADD1.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTADD1.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTADD1.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTADD1.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTADD1_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTADD2.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTADD2.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTADD2.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTADD2.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTADD2.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTADD2.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTADD2.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTADD2.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTADD2.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTADD2_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTASM4.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTASM4.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTASM4.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTASM4.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTASM4.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTBFP1.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTBFP1.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTBFP1.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTBFP1.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTBFP1.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTBFP1.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTBFP1.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTBFP1.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTBFP1.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTBFP1.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTBFP1_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL1.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL1.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL1.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL1.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL1.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL1.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL1.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL1.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL1.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL1.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL1_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL2.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL2.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL2.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL2.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL2.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL2.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL2.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL2_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL3.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL3.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL3.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL3.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL3.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL3.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL3.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL3.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL3.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCAL3_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP1.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP1.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP1.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP1.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP1.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP1.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP1.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP1.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP1.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP1.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP1_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP2.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP2.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP2.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP2.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP2.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP2.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP2.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP2.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP2.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP2.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP2_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP3.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP3.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP3.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP3.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP3.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP3.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP3.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP3.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP3.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP3.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP3_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP4.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP4.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP4.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP4.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP4.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP4.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP4.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP4.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP4.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP4.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP4_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP5.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP5.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP5.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP5.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP5.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP5.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP5.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP5.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP5.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP5.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP5_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP6.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP6.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP6.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP6.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP6.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP6.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP6.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP6.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP6.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP6.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCMP6_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY1.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY1.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY1.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY1.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY1.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY1.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY1.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY1.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY1.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY1.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY1_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY2.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY2.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY2.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY2.CPZ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY2.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY2.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY2.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY2.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY2.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY2.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY2.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPY2_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPYA.CPZ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTCPYB.CPZ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDFP1.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDFP1.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDFP1.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDFP1.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDFP1.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDFP1.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDFP1.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDFP1.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDFP1.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDFP1.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDFP1_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDIV1.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDIV1.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDIV1.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDIV1.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDIV1.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDIV1.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDIV1.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDIV1.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDIV1.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDIV1.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDIV1_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDIV2.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDIV2.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDIV2.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDIV2.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDIV2.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDIV2.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDIV2.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDIV2.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDIV2.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDIV2_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDSP1.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDSP1.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDSP1.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDSP1.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDSP1.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDSP1.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDSP1.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDSP1.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDSP1.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDSP1.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTDSP1_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL1.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL1.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL1.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL1.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL1.IN',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL1.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL1.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL1.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL1.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL1.OUT',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL1.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL1.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL1_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL2.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL2.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL2.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL2.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL2.IN',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL2.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL2.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL2.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL2.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL2.OUT',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL2.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL2.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFIL2_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFUN1.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFUN1.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFUN1.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFUN1.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFUN1.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFUN1.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFUN1.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFUN1.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFUN1.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFUN1.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTFUN1_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTGO1.CBL',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTGO1.MLC',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTHFP1.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTHFP1.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTHFP1.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTHFP1.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTHFP1.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTHFP1.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTHFP1.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTHFP1.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTHFP1.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTHFP1.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTHFP1_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF1.390',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF1.BAL',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF1.CBL',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF1.ERR',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF1.LOG',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF1.LST',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF1.MLC',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF1.OBJ',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF1.PRN',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF1.STA',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF1_ZC_LABELS.CPY',DSNAMX
               E='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF2.390',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF2.BAL',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF2.CBL',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF2.ERR',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF2.LOG',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF2.LST',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF2.MLC',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF2.OBJ',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF2.PRN',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF2.STA',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF2_ZC_LABELS.CPY',DSNAMX
               E='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF3.390',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF3.BAL',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF3.CBL',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF3.ERR',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF3.LOG',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF3.LST',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF3.MLC',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF3.OBJ',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF3.PRN',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF3.STA',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTIF3_ZC_LABELS.CPY',DSNAMX
               E='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTINT1.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTINT1.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTINT1.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTINT1.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTINT1.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTINT1.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTINT1.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTINT1.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTINT1.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTINT1.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTINT1_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTISP1.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTISP1.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTISP1.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTISP1.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTISP1.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTISP1.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTISP1.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTISP1.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTISP1.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTISP1.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTISP1_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV1.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV1.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV1.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV1.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV1.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV1.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV1.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV1.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV1.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV1.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV1_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV2.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV2.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV2.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV2.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV2.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV2.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV2.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV2.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV2.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV2.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV2_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV3.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV3.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV3.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV3.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV3.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV3.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV3.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV3.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV3.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV3.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMOV3_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMPY1.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMPY1.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMPY1.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMPY1.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMPY1.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMPY1.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMPY1.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMPY1.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMPY1.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMPY1.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMPY1_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMPY2.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMPY2.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMPY2.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMPY2.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMPY2.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMPY2.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMPY2.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMPY2.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMPY2.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTMPY2_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPIC1.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPIC1.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPIC1.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPIC1.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPIC1.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPIC1.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPIC1.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPIC1.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPIC1.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPIC1.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPIC1_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM1.390',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM1.BAL',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM1.CBL',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM1.ERR',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM1.LOG',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM1.LST',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM1.MLC',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM1.OBJ',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM1.PRN',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM1.STA',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM1_ZC_LABELS.CPY',DSNAMX
               E='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM2.390',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM2.BAL',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM2.CBL',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM2.ERR',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM2.LOG',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM2.LST',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM2.MLC',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM2.OBJ',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM2.PRN',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM2.STA',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM2_ZC_LABELS.CPY',DSNAMX
               E='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM3.390',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM3.BAL',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM3.CBL',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM3.ERR',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM3.IN',DSNAME='&SYSPARMX
               ..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM3.LOG',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM3.LST',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM3.MLC',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM3.OBJ',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM3.OUT',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM3.PRN',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM3.STA',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTPM3_ZC_LABELS.CPY',DSNAMX
               E='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTRMD1.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTRMD1.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTRMD1.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTRMD1.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTRMD1.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTRMD1.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTRMD1.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTRMD1.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTRMD1.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTRMD1.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTRMD1_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSIX1.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSIX1.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSIX1.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSIX1.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSIX1.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSIX1.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSIX1.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSIX1.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSIX1.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSIX1.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSIX1_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSIX2.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSIX2.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSIX2.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSIX2.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSIX2.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSIX2.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSIX2.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSIX2.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSIX2.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSIX2.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSIX2_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSUB1.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSUB1.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSUB1.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSUB1.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSUB1.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSUB1.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSUB1.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSUB1.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSUB1.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSUB1.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSUB1_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSUB2.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSUB2.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSUB2.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSUB2.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSUB2.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSUB2.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSUB2.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSUB2.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSUB2.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTSUB2_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC1.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC1.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC1.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC1.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC1.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC1.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC1.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC1.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC1.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC1.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC1_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC2.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC2.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC2.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC2.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC2.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC2.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC2.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC2.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC2.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC2.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC2_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC3.390',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC3.BAL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC3.CBL',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC3.ERR',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC3.LOG',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC3.LST',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC3.MLC',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC3.OBJ',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC3.PRN',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC3.STA',DSNAME='&SYSPAX
               RM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTTRC3_ZC_LABELS.CPY',DSNAX
               ME='&SYSPARM..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTWS1.390',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTWS1.BAL',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTWS1.CBL',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTWS1.ERR',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTWS1.LOG',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTWS1.LST',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTWS1.MLC',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTWS1.OBJ',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTWS1.PRN',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTWS1.STA',DSNAME='&SYSPARX
               M..BAT',ID=0
         PUNCH 'ERASE zcobol\test\z390\dif\TESTWS1_ZC_LABELS.CPY',DSNAMX
               E='&SYSPARM..BAT',ID=0
         MNOTE 'RTGENDIF FILES=506 MATCHES=504'
         PUNCH '',ID=1,DSNAME='&DIF_DIR\RT_DIF_TOT_FILES_&TOT_FILES..TXX
               T',ID=1,DSNAME='&DIF_DIR\RT_DIF_TOT_FILES_&TOT_FILES..TXX
               T'
         PUNCH '',ID=1,DSNAME='&DIF_DIR\RT_DIF_TOT_MATCH_&TOT_MATCH..TXX
               T',ID=1,DSNAME='&DIF_DIR\RT_DIF_TOT_MATCH_&TOT_MATCH..TXX
               T'
         END 
* MZ390I total mnote warnings = 0
* MZ390I total mnote errors   = 0
* MZ390I max   mnote level    = 0
* MZ390I total mz390 errors   = 0
