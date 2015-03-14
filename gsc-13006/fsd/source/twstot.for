      SUBROUTINE TWSTOT(DEP)
C
      IMPLICIT REAL*8(A-H,O-Z)
C
      COMMON/CONSTS/ PI,TWOPI,RADIAN
C
      COMMON/INEWR / NKT(10),ICP,ICPS
C
      COMMON/IPOOL1/ IGRAV,IDAMP,IK,K1,ITIM,IAB,IAPS,IBB,IBPS,NK(10)
C
     1              ,LK(10),LLK(10)
C
      COMMON/TWIOUT/ CWO(10,3),CWDO(10,3)
C
C
      DIMENSION DEP(150)
C
C
      I1=ICP-1
C
      DO 20 I=1,IK
      NTW=NKT(I)
      IF(NTW.EQ.0) GO TO 20
C
      DO 10 J=1,NTW
      IC=I1+J
      I2=IC+NTW
      CWO(I,J)=DEP(IC)/RADIAN
      CWDO(I,J)=DEP(I2)/RADIAN
   10 CONTINUE
C
      I1=I1+2*NTW
C
   20 CONTINUE
C
      RETURN
C
      END