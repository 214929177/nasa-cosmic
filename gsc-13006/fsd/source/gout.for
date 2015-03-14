      SUBROUTINE GOUT(SA,OMEG,TIME,IPLOT,IPLTPE,PHI,TESTY)
C
C
C     SUBROUTINE GOUT DETERMINES EULER ANGLES AND RATES WRT THE
C     LOCAL VERTICAL FRAME FOR GRAVITY GRADIENT SATELLITES.
C     IT CALLS ARANGE TO EXTRACT ELEMENT DATA ; DMOMNT TO CALCULATE
C     ELEMENT BENDING MOMENTS AND TENSIONS ; AND WRTPLT TO WRITE
C     TEMPORARY DATA SET FOR PLOTS .
C     MODIFICATION AS OF SEPT. 1977.
C
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      COMMON/CANTNA/ A(10,3),ADOT(10,3),B(10,3),BDOT(10,3),DIN(10,3),
     .               DINDOT(10,3),DOUT(10,3),DOUTDT(10,3)
C
C
      COMMON/COMBCR/ OMBC1(3)
C
      COMMON/CONSTS/ PI,TWOPI,RADIAN
C
      COMMON/CSTAT /XDEB(20)
C
      COMMON/DMMNT1/ZKBM(6),EMAK(10),EMBK(10),DUMM1(6),
     *    ITORK,IBENDM,ITENSE,ITNS1
C
      COMMON/HAMOUT/HAMILT,IHAMLT
C
      COMMON/HOUTPT/IHCALC
C
      COMMON/HVCOUT/HBODY(3),HINERT(3),HMAG
C
      COMMON/ICNTRL/KNTRL(10)
C
      COMMON/IPOOL1/ IGRAV,IDAMP,IK,K1,ITIM,IAB,IAPS,IBB,IBPS,NK(10),
     .               LK(10),LLK(10)
C
      COMMON/JBTEST/ IBTEST
C
      COMMON/KNERGY/ S,OMC,BT
C
      COMMON/NUTANG/ANUT
C
C
      COMMON/RMAIN1/ DELTAT,FACTOR,FREQ,TSTOP,DELMIT,
     .               UPBND(150),DNBND(150)
C
      COMMON/RPOOL2/ PO,SD(3),DAN(3,10),DBN(3,10),CFMT(3,3),DIY1(3),
     .               SD1(3),DT1,P1,AERO,DTO1,YIZK(3),PO1
C
      COMMON/SUNANG/ DSL2
C
      COMMON/VECTRS/ XSAT(3),XSATDT(3),AD(3)
C
      COMMON/XIN2  / ALFAE,BETAE,GAMAE,OMBC(3),ITEST2
C
C
      DIMENSION SA(3,3),OMEG(3),SAT(3,3),S(3,3),BS(3,3),BT(3,3),
     .          OMC(3),SXOMC(3)
C
C
      DATA IB /0/
C
      DATA ALPOLD,BETOLD,GAMOLD/ 3*0.D0/
C
C
      JTEST=1
      ITEST2=1
C
C
      RADIUS=0.D0
      DO 5 I=1,3
    5 RADIUS=RADIUS + XSAT(I)*XSAT(I)
      RADIUS=DSQRT(RADIUS)
C
      DO 10 I=1,3
   10 BS(3,I)=XSAT(I)/RADIUS
C
      YZ=XSAT(2)*XSATDT(3) - XSAT(3)*XSATDT(2)
      ZX=XSAT(3)*XSATDT(1) - XSAT(1)*XSATDT(3)
      XY=XSAT(1)*XSATDT(2) - XSAT(2)*XSATDT(1)
C
      RXVMAG=DSQRT(YZ*YZ + ZX*ZX + XY*XY)
C
      BS(2,1)=YZ/RXVMAG
      BS(2,2)=ZX/RXVMAG
      BS(2,3)=XY/RXVMAG
C
      BS(1,1)=BS(2,2)*BS(3,3)-BS(2,3)*BS(3,2)
      BS(1,2)=BS(2,3)*BS(3,1)-BS(2,1)*BS(3,3)
      BS(1,3)=BS(2,1)*BS(3,2)-BS(2,2)*BS(3,1)
C
      DO 20 I=1,3
      DO 20 L=1,3
   20 BT(I,L)=BS(L,I)
      SDLV2=BT(1,2)*SD(1)+BT(2,2)*SD(2)+BT(3,2)*SD(3)
      DELSLV=DARCOS(-1.0D0*SDLV2)
      DSL2=DELSLV/RADIAN
      DO 30 I=1,3
      DO 30 J=1,3
   30 SAT(I,J)=SA(J,I)
C
      DO 40 I=1,3
      DO 40 J=1,3
      S(I,J)=0.D0
      DO 40 K=1,3
   40 S(I,J)=S(I,J) + SAT(I,K)*BT(K,J)
C
C
      IF(S(3,1).EQ.0.D0.AND.S(3,3).EQ.0.D0) GO TO 50
      W=-S(3,2)
      ALFAE=DARSIN(W)
      IF(DABS(ALFAE/RADIAN).GT.89.D0.AND.DABS(ALFAE/RADIAN).LT.91.D0)
     .           GO TO 100
      SN=DCOS(ALFAE)
      TEST1=S(3,3)/SN
      W=S(3,1)/SN
      BETAE=DARSIN(W)
      IF(TEST1.LT.0.D0) BETAE=-DARSIN(W) + PI
      TEST2=S(2,2)/SN
      W=S(1,2)/SN
      GAMAE=DARSIN(W)
      IF(TEST2.LT.0.D0) GAMAE=-DARSIN(W) + PI
      ALFAE=ALFAE/RADIAN
      BETAE=BETAE/RADIAN
      GAMAE=GAMAE/RADIAN
      ALPOLD=ALFAE
      BETOLD=BETAE
      GAMOLD=GAMAE
      IF (IBTEST .EQ. 0)  GO TO 110
      IF (IB .EQ. 0)  BPAST=BETAE
      IB=1
      IF (BPAST*BETAE .GE. 0.D0)  GO TO 101
      IF (BETAE .LT. 0.D0)  GO TO 101
      TESTY=TIME
      IBTEST=0
      IB=0
      GO TO 110
  101 BPAST=BETAE
      GO TO 110
   50 IF(S(3,2)-1.D0) 60,80,60
   60 IF(S(3,2)+1.D0) 100,70,100
   70 ALFAE=90.D0
      ALPOLD=ALFAE
      GO TO 100
   80 ALFAE=-90.D0
      ALPOLD=ALFAE
  100 ITEST2=0
  110 OMC(1)=0.D0
      OMC(2)=RXVMAG/RADIUS**2
C
      DOTX=AD(1)*YZ
      DOTY=AD(2)*ZX
      DOTZ=AD(3)*XY
C
      OMC(3)=((DOTX + DOTY + DOTZ)*RADIUS)/RXVMAG**2
C
      DO 120 I=1,3
      SXOMC(I)=0.D0
      DO 120 J=1,3
  120 SXOMC(I)=SXOMC(I) + S(I,J)*OMC(J)
C
      DO 130 I=1,3
      OMBC(I)=(OMEG(I) - SXOMC(I))/RADIAN
      OMBC1(I)=OMC(I)
  130 OMC(I)=OMBC(I)*RADIAN
C
      ALFAE=ALPOLD
      BETAE=BETOLD
      GAMAE=GAMOLD
      PHILD=0.0D0
      IF(IDAMP.NE.0) PHILD=PHI/RADIAN
      AL=ALFAE*RADIAN
      BE=BETAE*RADIAN
      GA=GAMAE*RADIAN
      RRAT=OMBC(1)*DCOS(GA)-OMBC(2)*DSIN(GA)
      PRAT=(OMBC(1)*DSIN(GA)+OMBC(2)*DCOS(GA))/DCOS(AL)
      YRAT=OMBC(3)+DTAN(AL)*(OMBC(1)*DSIN(GA)+OMBC(2)*DCOS(GA))
C
      IF(KNTRL(1).EQ.0) GO TO 140
C
      IF(IHCALC.EQ.0) GO TO 140
C
      WS=HBODY(2)/HMAG
      IF(WS.GT.1.0D0) WS=1.0D0
      IF(WS.LT.-1.0D0) WS=-1.0D0
      ANUT=DARCOS(WS)/RADIAN
      XDEB(5)=ANUT
C
  140 CONTINUE
C
C     CALL ARANGE
C
      IF(ITENSE.NE.0.OR.IBENDM.NE.0) CALL DMOMNT
C
      IF(IHAMLT.NE.0) CALL ENERGY(2,JTEST)
C
      IF(IPLOT.NE.0) CALL WRTPLT(TIME,ALFAE,BETAE,GAMAE,OMBC,PHILD
     1                          ,RRAT,PRAT,YRAT,2)
C
      RETURN
      END