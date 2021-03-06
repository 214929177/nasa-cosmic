      SUBROUTINE QUIKVIS5B1X(KEY,T1,T50)
      IMPLICIT REAL*8 (A-H,O-Z)
C
C THIS ROUTINE IS PART OF THE QUIKVIS PROGRAM.  IT ADDS MISCELLANEOUS
C INFO BELOW THE GRID AND MAP OUTPUT FORMATS FOR THE SURVEY OPTION.
C
C VARIABLE DIM TYPE I/O DESCRIPTION
C -------- --- ---- --- -----------
C
C KEY       1   I*4  I  =1, CALL PUTS INFO BELOW THE GRID FORMAT AND
C                           THIS ROUTINE IS TO ADD TEXT ABOUT ROUNDING
C                           DOWN OF TIME INFO PRINTED.
C                       =2, CALL PUTS INFO BELOW THE MAP FORMAT AND
C                           ROUNDING TEXT IS NOT APPROPRIATE.
C
C T1        1   R*8  I  THE BEGINNING TIME OF THE TIME SPAN FOR WHICH
C                       THE GRID OR MAP INFO IS GIVEN. IN SECONDS
C                       SINCE 1/1/50, 0.0 HR.
C
C T50       1   R*8  I  THE END TIME OF THE TIME SPAN FOR WHICH
C                       THE GRID OR MAP INFO IS GIVEN. IN SECONDS
C                       SINCE 1/1/50, 0.0 HR.
C
C***********************************************************************
C
C BY C PETRUZZO/GFSC/742.   2/86.
C       MODIFIED....
C
C***********************************************************************
C
      INCLUDE 'QUIKVIS.INC'
C
      CHARACTER*20 CH1,CH2
      CHARACTER*30 SHADTEXT
      CHARACTER*54 ROUNDTEXT
C
C
C
      IF(DOREQMT(2)) THEN
        SHADTEXT = 'ORBIT NIGHT IS REQUIRED.'
        NCH = 24
      ELSE
        SHADTEXT = 'ORBIT NIGHT IS NOT REQUIRED.'
        NCH = 28
        END IF
      WRITE(LUPRINT,2006) SHADTEXT(1:NCH),
     *       'MIN TARG/HORIZ SEP=', EAVOID*DEGRAD,
     *       'MIN TARG/VEL SEP=',   VAVOID*DEGRAD,
     *       'MAX TARG/ZENITH SEP=',ZMAXSEP*DEGRAD
C
C
      WRITE(LUPRINT,2003) SMA,ECC,ORBINCL*DEGRAD,ARGP*DEGRAD
      IF(NODEOPT.EQ.1) WRITE(LUPRINT,2004) RAAN1*DEGRAD,
     *    (RAAN1+DELRAAN*(NUMRAAN-1))*DEGRAD,DELRAAN*DEGRAD
      IF(NODEOPT.EQ.2) WRITE(LUPRINT,2005) SOLTIM1/3600.D0,
     *    (SOLTIM1+(NUMSOLT-1)*DELSOLT)/3600.D0,DELSOLT/3600.D0
C
C
      CALL PAKT50CH(T1,CH1)
      CALL PAKT50CH(T50,CH2)
C
      ROUNDTEXT = '.'
      IF(KEY.EQ.1) ROUNDTEXT = ' ROUNDED DOWN TO A WHOLE NUMBER.'
C
      IF(T50.NE.T1) THEN
        WRITE(LUPRINT,2001)
     *      CH1(1:8),CH2(1:8),(T50-T1)/86400.D0,DELTIME/86400.D0,
     *      ROUNDTEXT
      ELSE
        IF(T50.NE.0.D0) WRITE(LUPRINT,2002) CH1(1:8),ROUNDTEXT
        IF(T50.EQ.0.D0) WRITE(LUPRINT,2007) ROUNDTEXT
        END IF
C
C ADD AN EXPLANATION BELOW THE GRID OUTPUT.  IT WOULD BE USEFUL BELOW
C THE MAP OUTPUT, BUT THAT OUTPUT OS ALREADY AT ITS MAXIMUM NUMBER OF
C LINES THAT WILL PRINT ON A LINE PRINTER PAGE.
C
      IF(KEY.EQ.1) WRITE(LUPRINT,2009)
C
      RETURN
C
C***********************************************************************
C
C
C**** INITIALIZATION CALL. PUT GLOBAL PARAMETER VALUES INTO THIS
C     ROUTINE'S LOCAL VARIABLES.
C
      ENTRY QVINIT5B1X
C
      CALL QUIKVIS999(-1,R8DATA,I4DATA,L4DATA)
      RETURN
C
C***********************************************************************
C
 2006 FORMAT(/,' OBS REQMTS: ',A,3(5X,A,F6.1))
 2003 FORMAT(/,' SMA(KM)=',F8.1,'   ECC=',F9.6,'   INCL(DEG)=',F7.2,
     *            '   ARGP=',F7.2)
 2004 FORMAT(' NODE RANGE: FIRST/LAST ASCENDING NODES=',2F8.2,
     *            '  INCREMENT BETWEEN NODES PROCESSED=',F8.2)
 2005 FORMAT(' NODE RANGE SPECIFIED BY NODE''S MEAN LOCAL TIME.',
     *            ' FIRST/LAST MLT(HRS)=',2F8.3,
     *         '   INCREMENT BETWEEN MLT''S PROCESSED=',F8.3)
 2001 FORMAT(/,
     *   ' GRID SHOWS MINIMUM DURATION TARGET IS AVAILABLE PER ORBIT ',
     *      'FOR ALL DATES(Y/M/D) WITHIN ',A,' TO ',A,
     *           '   (DAYS=',F5.1,')'/,
     *   ' INCREMENT BETWEEN DATES TESTED(DAYS) = ',F5.1,5X,
     *   ' DURATION IS IN MINUTES',A)
 2002 FORMAT(/,
     *   ' GRID SHOWS MINIMUM DURATION TARGET IS AVAILABLE PER ORBIT ',
     *         'FOR DATE(Y/M/D)= ',A/,
     *   ' DURATION IS IN MINUTES',A)
 2007 FORMAT(/,
     *   ' GRID SHOWS MINIMUM DURATION TARGET IS AVAILABLE PER ORBIT.',
     *         '  INFO IS INDEPENDENT OF DATE.'/,
     *   ' DURATION IS IN MINUTES',A)
 2009 FORMAT(/,
     *   ' IN GENERAL, GRID ENTRIES ARE LARGER THAN ',
     *         '''GUARANTEED AVAILABILITY'' TIMES.  THIS GRID MERELY ',
     *         'SHOWS THE SMALLEST TIME'/,
     *   ' ENCOUNTERED AMONG ALL DATES AND ORBIT RAAN''S PROCESSED.'//,
     *   '      SIMPLE EXAMPLE:',
     *   T24,'IN ONE CASE A TARGET IS AVAILABLE FROM SUNSET TO ',
     *           'SUNSET+20 MINUTES.  IN ANOTHER IT IS AVAILABLE'/,
     *   T24,'FROM SUNSET+13 MINUTES TO SUNSET+28 ',
     *           'MINUTES.  THE MINIMUM DURATION(GRID ENTRY) IS 15 ',
     *           'MINUTES BUT'/,
     *   T24,'THE GUARANTEED AVAILABILITY IS 7 ',
     *           'MINUTES(IE, FROM SUNSET+13 TO SUNSET+20).')
      END
