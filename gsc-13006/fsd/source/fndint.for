      SUBROUTINE FNDINT
C
      IMPLICIT REAL*8(A-H,O-Z)
C
      REAL*4 D21,D22,D31,DI01,DI11,DI12,DI21,DI22,DI31,DA
C
      REAL*4 DK21,DK22,DK23,DK24,DK31,DK32,DK33,DK34
C
      REAL*4 TWI,ST,CT,S2,SC,C2,S2T,C2T
C
      REAL*4 W01,W11,W12,W21,W22,W31,WK21,WK22,WK31,WK32
C
      COMMON/DEBUG2/ IOUT,JOUT,KLUGE
C
      COMMON/DITCOM/D21(3,3,2),D22(3,3,2),D31(3,3,3,2),DI01(40)
     1             ,DI11(40,3),DI12(40,3),DI21(40,3,3),DI22(40,3,3)
     2             ,DI31(40,3,3,3),DA(40,3)
C
      COMMON/ITWWRK/NKB,NTW,NTT,ILK,ILLK
C
      COMMON/SCDINT/D01S2,D01SC,D01C2,D11S2(3),D11SC(3),D11C2(3)
     1             ,D12S2(3),D12SC(3),D12C2(3),D21S2(3,3),D21SC(3,3)
     2             ,D21C2(3,3),D22S2(3,3),D22SC(3,3),D22C2(3,3)
     3             ,D23(3,3),D24(3,3),D31S2(3,3,3),D31SC(3,3,3)
     4             ,D31C2(3,3,3),D32(3,3,3)
C
      COMMON/SCIFIN/DK21C2(3,3),DK21S2(3,3),DK22S(3,3),DK22C(3,3)
     1             ,DKK23(3,3),DKK24(3,3),DK31S2(3,3,3),DK31C2(3,3,3)
     2             ,DK32S(3,3,3),DK32C(3,3,3),DKK33(3,3,3),DKK34(3,3,3)
C
      COMMON/TWIFCM/DK23(3,3,2),DK24(3,3,2),DK33(3,3,3,2),DK34(3,3,3,2)
     1             ,DK21(40,3,3),DK22(40,3,3),DK31(40,3,3,3)
     2             ,DK32(40,3,3,3)
C
      COMMON/TWWORK/FM(3,3),A(3),AD(3),B(3),BD(3),C(3),CD(3),ZL,RO
     1             ,RSQT(3)
C
C
      DATA DZERO/0.0D0/
C
C
      ID1=0
      ID2=0
      IF(ILK.EQ.2) ID1=20
      IF(ILLK.EQ.2) ID2=20
C
C     ZERO OUT ARRAYS
C
      D01S2=DZERO
      D01SC=DZERO
      D01C2=DZERO
      DO 5 I=1,3
      D11S2(I)=DZERO
      D11SC(I)=DZERO
      D11C2(I)=DZERO
      D12S2(I)=DZERO
      D12SC(I)=DZERO
      D12C2(I)=DZERO
      DO 4 J=1,3
      D21S2(I,J)=DZERO
      D21SC(I,J)=DZERO
      D21C2(I,J)=DZERO
      D22S2(I,J)=DZERO
      D22SC(I,J)=DZERO
      D22C2(I,J)=DZERO
      D23(I,J)=D21(I,J,ILK)
      D24(I,J)=D22(I,J,ILK)
      DK21C2(I,J)=DZERO
      DK21S2(I,J)=DZERO
      DK22S(I,J)=DZERO
      DK22C(I,J)=DZERO
      DKK23(I,J)=DK23(I,J,ILLK)
      DKK24(I,J)=DK24(I,J,ILLK)
      DO 3 L=1,3
      D31S2(I,J,L)=DZERO
      D31SC(I,J,L)=DZERO
      D31C2(I,J,L)=DZERO
      D32(I,J,L)=D31(I,J,L,ILK)
      DK31S2(I,J,L)=DZERO
      DK31C2(I,J,L)=DZERO
      DK32S(I,J,L)=DZERO
      DK32C(I,J,L)=DZERO
      DKK33(I,J,L)=DK33(I,J,L,ILLK)
      DKK34(I,J,L)=DK34(I,J,L,ILLK)
    3 CONTINUE
    4 CONTINUE
    5 CONTINUE
C
C     OBTAIN INTEGRATED ARRAYS
C
      DO 20 I=1,20
      I1=ID1+I
      I2=ID2+I
      TWI=0.0E0
      DO 8 J=1,NTW
      TWI=TWI+C(J)*DA(I1,J)
    8 CONTINUE
      ST=SIN(TWI)
      CT=COS(TWI)
      S2=ST*ST
      SC=ST*CT
      C2=CT*CT
      S2T=2.0E0*SC
      C2T=C2-S2
      W01=DI01(I1)
      D01S2=D01S2+S2*W01
      D01SC=D01SC+SC*W01
      D01C2=D01C2+C2*W01
C
      DO 12 J=1,NTW
      W12=DI12(I1,J)
      D12S2(J)=D12S2(J)+S2*W12
      D12SC(J)=D12SC(J)+SC*W12
      D12C2(J)=D12C2(J)+C2*W12
C
      IF(NKB.EQ.0) GO TO 12
C
      DO 11 L=1,NKB
      W22=DI22(I1,J,L)
      D22S2(J,L)=D22S2(J,L)+S2*W22
      D22SC(J,L)=D22SC(J,L)+SC*W22
      D22C2(J,L)=D22C2(J,L)+C2*W22
      WK22=DK22(I1,J,L)
      DK22S(J,L)=DK22S(J,L)+ST*WK22
      DK22C(J,L)=DK22C(J,L)+CT*WK22
C
      DO 9 M=1,NKB
      W31=DI31(I1,J,L,M)
      D31S2(J,L,M)=D31S2(J,L,M)+S2*W31
      D31SC(J,L,M)=D31SC(J,L,M)+SC*W31
      D31C2(J,L,M)=D31C2(J,L,M)+C2*W31
C
      WK31=DK31(I1,J,L,M)
      DK31S2(J,L,M)=DK31S2(J,L,M)+S2T*WK31
      DK31C2(J,L,M)=DK31C2(J,L,M)+C2T*WK31
    9 CONTINUE
C
      DO 10 M=1,NTW
      WK32=DK32(I1,J,M,L)
      DK32S(J,M,L)=DK32S(J,M,L)+ST*WK32
      DK32C(J,M,L)=DK32C(J,M,L)+CT*WK32
   10 CONTINUE
C
   11 CONTINUE
C
   12 CONTINUE
C
C
C
      IF(NKB.EQ.0) GO TO 20
C
      DO 16 J=1,NKB
      W11=DI11(I1,J)
      D11S2(J)=D11S2(J)+S2*W11
      D11SC(J)=D11SC(J)+SC*W11
      D11C2(J)=D11C2(J)+C2*W11
C
      DO 14 L=1,NKB
      W21=DI21(I1,J,L)
      D21S2(J,L)=D21S2(J,L)+S2*W21
      D21SC(J,L)=D21SC(J,L)+SC*W21
      D21C2(J,L)=D21C2(J,L)+C2*W21
C
      WK21=DK21(I1,J,L)
      DK21S2(J,L)=DK21S2(J,L)+S2T*WK21
      DK21C2(J,L)=DK21C2(J,L)+C2T*WK21
C
   14 CONTINUE
C
   16 CONTINUE
C
   20 CONTINUE
C
C
      IF(IOUT.EQ.1) GO TO 30
      WRITE(6,6000)
 6000 FORMAT('0',10X,'DEBUGGING OUTPUT FROM FNDINT'/)
      WRITE(6,6001) D01S2,D01SC,D01C2,D11S2,D11SC
      WRITE(6,6001) D11C2,D12S2,D12SC
      WRITE(6,6001) D12C2,D21S2,D21SC,D21C2,D22S2,D22SC,D22C2
      WRITE(6,6001) D23,D24,D31S2,D31SC,D31C2,D32
      WRITE(6,6000)
      WRITE(6,6001) DK21C2,DK21S2,DK22S,DK22C,DKK23,DKK24
      WRITE(6,6001) DK31S2,DK31C2,DK32S,DK32C,DKK33,DKK34
 6001 FORMAT(' ',1P9E14.6)
   30 CONTINUE
C
C
      RETURN
C
      END
