      DOUBLE PRECISION FUNCTION ANGVEC(VEC1,VEC2)
      IMPLICIT REAL*8 (A-H,O-Z)
C
C  FIND THE ANGLE BETWEEN TWO 3-VECTORS.
C
C  VAR  DIM  TYPE  I/O  DESCRIPTION
C  ---  ---  ----  ---  -----------
C
C  VEC1  3   R*8    I   ONE OF THE TWO VECTORS. MAY HAVE ANY MAGNITUDE.
C
C  VEC2  3   R*8    I   THE OTHER VECTOR. ANY MAGNITUDE.
C
C  ANGVEC    R*8    O   THE ANGLE BETWEEN THE VECTORS. IN RADIANS.
C                       IF A VECTOR HAS ZERO MAGNITUDE, THE ANGLE IS
C                       RETURNED AS ZERO.
C
C                       THIS IS A FUNCTION SUBROUTINE AND IS USED AS:
C                                  SEP=ANGVEC(VEC1,VEC2)
C
C*******************************************************************
C
C  CODED BY CHARLIE PETRUZZO 6/81.
C
C  MODIFIED........
C
C*******************************************************************
C
C
      REAL*8 VEC1(3),VEC2(3)
C
C  GET THE PRODUCT OF THE MAGNITUDES OF THE VECTORS.
      V1SQ=VEC1(1)**2 + VEC1(2)**2 + VEC1(3)**2
      V2SQ=VEC2(1)**2 + VEC2(2)**2 + VEC2(3)**2
      V1V2=DSQRT(V1SQ*V2SQ)
C
C  GET THE ANGLE. TEMP=COS(ANGLE). 
      TEMP=1.D0
      IF(V1V2.NE.0.D0) TEMP=DOT(VEC1,VEC2)/V1V2
C     DABS(TEMP) MAY BE >1.D0 BECAUSE OF ROUNDING. MAKE IT +/- 1.D0
      IF(DABS(TEMP).GE.1.D0) TEMP=DSIGN(1.D0,TEMP)
      ANGVEC=DACOS(TEMP)
C
      RETURN
      END
