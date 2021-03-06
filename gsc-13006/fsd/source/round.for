      SUBROUTINE ROUND(A,B,C,D)
C
C    THIS SUBROUTINE ACCEPTS CALENDAR TIME, JULIAN TIME, SECONDS OF DAY
C    AND TIME INCREMENT.  EACH OF THESE QUANTITIES IS ROUNDED AND THE
C    APPROPRIATE ADJUSTMENTS ARE MADE TO CALENDAR TIME IN THE EVENT OF A
C    DAY CHANGE.
C
      IMPLICIT REAL*8(A-H,O-Z)
      DIMENSION AMON(12)
      DATA AMON/31.,0.,31.,30.,31.,30.,31.,31.,30.,31.,30.,31./
      AMON(2)=28
C
C    ROUND YR MO DAY, SECS OF DAY, AND DELTA TIME
C
      A=IDINT(A+0.5)
      B=IDINT(B+0.5)
      C=IDINT(C+0.5)
      D=IDINT(D+0.5)
C
C    TEST FOR SECONDS=86400
C
      IF(C .NE. 86400.) GO TO 95
      B=B+1.0
C
C                      CALENDAR ROUTINE
C    EXTRACT YEAR
C
      YR=A/10000.
C
C    TEST FOR LEAP YEAR
C
      AYR=0.
      IF(DMOD(YR,4.0D0) .EQ. 0.0) AYR=1.0
C
C    TEST FOR YEAR JUMP
C
      IF(B .LE. 365.0+AYR) GO TO 5
      B=B-365.0-AYR
      YR=YR+1
C
C     RETEST FOR LEAP YEAR
C
      AYR=0
      IF(DMOD(YR,4.0D0) .EQ. 0.0) AYR=1.0
    5 IF(AYR.NE.0.0)AMON(2)=29
      DAY=B
      AMN=0.0
C
C    COMPUTE NEW MONTH AND DAY
C
      DO 10 J=1,12
      AMN=AMN+AMON(J)
      IF(B .LE. AMN) GO TO 15
   10 DAY=B-AMON(J)
   15 AMN=J
      C=0.0
      A=DAY+100.*AMN+10000.*YR
   95 RETURN
      END
