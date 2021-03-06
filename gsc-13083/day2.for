      FUNCTION DAY2(YMD)
      IMPLICIT REAL*8 (A-H,O-Z)
C PROGRAM NAME
C     DAY2
C
C PURPOSE
C     CALCULATES THE NUMBER OF DAYS WHICH HAVE ELAPSED SINCE
C     1 JANUARY 1962 TO ANY INPUT CALENDAR DATE.
C
C METHOD
C     NOT APPLICABLE
C CALLING SEQUENCE
C     NDAYS=DAY2(YMD)
C
C     DAYS   (OUTPUT,R8,1)  - NUMBER OF DAYS SINCE JANUARY 1,1962
C     YMD    (INPUT,R8,1)   - PACK CALENDAR DATE (YYMMDD)
C
C COMMON VARIABLES
C     NONE
C
C INPUT/OUTPUT DEVICES
C     NONE
C
C EXTERNAL REFERNCES
C     NONE
C
C RESTRICTIONS
C     NONE
C ORGINATOR
C     OBTAINED FROM STANDARD ATS SOFTWARE (DAY1)
C
C MODIFCATIONS
C  
C        CJP. 8/81. UPACKING YMD MAY GIVE WRONG 'D'. FIXED.
C
C     UNPACK CALENDAR DATE INTERNALLY
C
      REAL*8 DUM(3),TEMP(3)
      DIMENSION MM(12)
      DATA MM/0,31,59,90,120,151,181,212,243,273,304,334/
C
      CALL UNPACK(YMD,TEMP,DUM)
      NYR=TEMP(1)-1900.D0
      NMO=TEMP(2)
      NDA=TEMP(3)
C
      DAY2=0.0D0
      K=NYR-62
      K4=(12*K+NMO+21)/48
      IF(NMO .GT. 0  .AND.  NMO .LE. 12)
     1 DAY2=365*K+K4+MM(NMO)+NDA-1
C
      RETURN
      END
