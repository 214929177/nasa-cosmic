      SUBROUTINE ENERGY(INOPT,JTEST)
C
C     'ENERGY' IS AN EXECUTIVE SUBROUTINE THAT CONTROLS CALCULATION
C     OF THE HAMILTONIAN BY CALLING SEVERAL SUBROUTINES
C
      IMPLICIT REAL * 8(A-H,O-Z)
      REAL*8 IG(3,3),ISO(3,3),IXDB(3,3),IP,J1,J2,J3
C
C
      NAMELIST/  NSE / SE
C
      NAMELIST/NNERGY/ ZF,ZT,YOZ,YT,FC,YF,YFYF,YY,ZZDB,YYDB
C
C
      COMMON/CCNVRT/ BDYMI(3,3),DPRMI(3,3),EMODLS(10),RTUBE(10),
     .               HTUBE(10),THERMC(10),TIPMS(10),C(10)
C
      COMMON/COMALP/ SZ02(10),SZ03(10),SZ04(10),SZ12(3,10),SZ13(3,10),
     .               SZ14(3,10),SZ15(3,10),SZ16(3,10),SZ21(9,10),
     .               SZ22(9,10),SZ23(9,10),SZ25(9,10),
     .               SZ26(9,10),SZ27(9,10),SZ28(9,10),SZ31(27,10),
     .               SZ32(27,10),SZ33(27,10),SZ34(27,10),SZ35(27,10),
     .               SZ41(81,10),SZ42(81,10),SZ43(81,10)
C
      COMMON/COMBCR/ OMBC1(3)
C
      COMMON/CONSTS/ PI,TWOPI,RADIAN
C
      COMMON/DEBUG3/ ISWTCH
C
      COMMON/HAMOUT/ HAMILT,IHAMLT
C
      COMMON/IPOOL1/ IGRAV,IDAMP,IK,K1,ITIM,IAB,IAPS,IBB,IBPS,NK(10),
     .               LK(10),LLK(10)
C
      COMMON/KNERGY/ S(3,3),OMBC(3),BT(3,3)
C
      COMMON/LIBDPR/ ZK1D,ZK2D,PHIS,PHILD,DPHILD,BETLD,GAMLD,
     .               ZMDO,ZMDBO,CNV,DECAY
C
      COMMON/RNRGY1/ ZF(3),ZT(3),YOZ(3),YT(3),FC(3,3),YF(3),YFYF(3,3),
     .               YY(3,3)
C
      COMMON/RNRGY2/ ZZDB(3,3),YYDB(3,3)
C
      COMMON/RNRGY3/ J1(3,3),J2(3,3),J3(3,3),XICODT(3),W(3),ETA(3),
     .               ZETA(3)
C
      COMMON/RPOOL1/ RHOK(10),TIME,SA(3,3),FM1(3,3),ZLK(10),OMEG(3),
     .               ZLKP(10),ZLKDP(10),CMAT(3,3),GBAR(3,3),YBCM(3),
     .               ZBZK(3,10),FCM(3,3),DTO,PHID,PHI
C
      COMMON/RPOOL3/ ZMS,YIZM(3,2)
C
      COMMON/RPOOL5/ CKMAT(3,3,10),FM2(3,3)
C
      COMMON/RPOOL8/ SZ01(10),SZ11(3,10),SZ24(9,10)
C
      COMMON/RXCAL / XI(3),XID(3),XX(3,3),XXD(3,3),XDXD(3,3)
C
C
C
C
      DIMENSION ZZT1(3,3),ZZT(3,3),SUM(6),RSUM(3),XICO(3),RO(3),RDB(3),
     .          XDTF(3),FMT(3,3),YYSO(3,3),DUM(3,3),SE(10),ZBZ(3)
C
C
C
      W(1)=0.0D0
      W(2)=PHID
      W(3)=0.0D0
      TBM2=0.0D0
      IF(JTEST.EQ.1) GO TO 10
      ITIME=1
      GO TO 20
   10 CONTINUE
      JTEST=JTEST + 1
      ITIME=0
   20 CONTINUE
C
C                       START K LOOP
C
      DO 200 K=1,IK
      DO 25 I=1,3
      ZBZ(I)=ZBZK(I,K)
      DO 25 J=1,3
   25 CMAT(I,J)=CKMAT(I,J,K)
      SE(K)=0.0D0
      M=NK(K)
      DO 40 I=1,3
      XI(I)=0.0D0
      XID(I)=0.0D0
      DO 30 J=1,3
      XX(I,J)=0.0D0
      XXD(I,J)=0.0D0
   30 XDXD(I,J)=0.0D0
   40 CONTINUE
   55 IF(M.NE.0) GO TO 60
C
      XI(1)=ZLK(K)*SZ01(K)
      XX(1,1)=ZLK(K)*ZLK(K)*SZ03(K)
C
      GO TO 70
   60 CALL XICAL(XI,ZLK,SZ11,SZ24,SZ01,M,K)
C
      CALL XXCAL(XX,ZLK,K,M)
C
C
      CALL XIDCAL(XID,ZLK,SZ11,SZ24,M,K)
C
      CALL XXDCAL(XXD,ZLK,K,M)
C
      CALL XDXDCL(XDXD,ZLK,K,M)
C
      TBM2=TBM2 + TWOTBM(K)
C
      CALL STRAIN(ZLK,SE,K,K1,M)
C
   70 CALL NERGY(K,ITIME,ZBZ)
C
      IF(K.NE.IK) GO TO 75
      IF(ISWTCH.EQ.0) WRITE(6,NSE)
      IF(ISWTCH.EQ.0) WRITE(6,NNERGY)
C
   75 IF(K.GT.1) GO TO 100
      DO 80 I=1,3
      ETA(I)=0.0D0
      ZETA(I)=0.0D0
      XICO(I)=0.0D0
      XICODT(I)=0.0D0
      DO  80 J=1,3
      J1(I,J)=0.0D0
      J2(I,J)=0.0D0
      J3(I,J)=0.0D0
      ZZT1(I,J)=0.0D0
   80 IXDB(I,J)=0.0D0
C
      DO 90 I=1,6
   90 SUM(I)=0.0D0
C
C                       START SECOND K LOOP
C
  100 RHOKLK=RHOK(K)*ZLK(K)
C
      IF(IDAMP.EQ.0) GO TO 130
      IF((K-K1).GT.0) GO TO 130
C
C
      CALL J2CAL(ZBZ,CMAT,XX,ZF,ZZT)
C
      IF(ISWTCH.EQ.0) WRITE(6,20000)
      IF(ISWTCH.EQ.0) WRITE(6,10000) ((ZZT(I,J),J=1,3),I=1,3)
C
      DO 110 I=1,3
      DO 110 J=1,3
  110 ZZT1(I,J)=ZZT1(I,J) + RHOKLK*ZZT(I,J)
C
C                       CALCULATE IXDB
C
      CALL J3CAL(ZBZ,YT,YOZ,YF,YFYF,FM1,RHOKLK,IXDB)
C
      IF(ISWTCH.EQ.0) WRITE(6,20001)
      IF(ISWTCH.EQ.0) WRITE(6,10000) ((IXDB(I,J),J=1,3),I=1,3)
C
      CALL ZETACL(CMAT,XID,XXD,ZBZ,RSUM)
C
      IF(ISWTCH.EQ.0) WRITE(6,20002)
      IF(ISWTCH.EQ.0) WRITE(6,10001) (RSUM(I),I=1,3)
C
      DO 120 I=1,3
  120 ZETA(I)=ZETA(I) + RHOKLK*RSUM(I)
C
      IF(ISWTCH.EQ.0) WRITE(6,10002) (ZETA(I),I=1,3)
C
  130 CALL ETACAL(RSUM,K)
      IF(ISWTCH.EQ.0) WRITE(6,20003)
      IF(ISWTCH.EQ.0) WRITE(6,10001) (RSUM(I),I=1,3)
C
      DO 140 I=1,3
  140 ETA(I)=ETA(I) + RHOKLK*RSUM(I)
      IF(ISWTCH.EQ.0) WRITE(6,10003) (ETA(I),I=1,3)
C
      SUM(1)=SUM(1) + RHOKLK*(YY(2,2) + YY(3,3))
      SUM(2)=SUM(2) + RHOKLK*(YY(1,1) + YY(3,3))
      SUM(3)=SUM(3) + RHOKLK*(YY(1,1) + YY(2,2))
      SUM(4)=SUM(4) + RHOKLK*YY(1,2)
      SUM(5)=SUM(5) + RHOKLK*YY(1,3)
      SUM(6)=SUM(6) + RHOKLK*YY(2,3)
C
      DO 150 I=1,3
  150 XICO(I)=XICO(I) + RHOKLK*YT(I)
C
      IF(ISWTCH.EQ.0) WRITE(6,20004)
      IF(ISWTCH.EQ.0) WRITE(6,10001) (XICO(I),I=1,3)
C
      IF(INOPT.EQ.1) RL=ROFUN(RO,OMEG,YT)
      IF(INOPT.EQ.2) RL=ROFUN(RO,OMBC,YT)
C
      DO 170 I=1,3
  170 RDB(I)=0.0D0
C
      IF(IDAMP.EQ.0) GO TO 180
      IF((K-K1).GT.0) GO TO 180
C
      RSUM(1)=W(2)*ZT(3) - W(3)*ZT(2)
      RSUM(2)=W(3)*ZT(1) - W(1)*ZT(3)
      RSUM(3)=W(1)*ZT(2) - W(2)*ZT(1)
      CALL MULTM(FM1,RSUM,RDB,3,1,3)
  180 CALL MULTM(FC,XID,XDTF,3,1,3)
      CALL MSUM(RO,XDTF,RSUM,3)
C
      DO 190 I=1,3
  190 XICODT(I)=RHOKLK*(RSUM(I) + RDB(I)) + XICODT(I)
C
      IF(ISWTCH.EQ.0) WRITE(6,20005)
      IF(ISWTCH.EQ.0) WRITE(6,10001) (XICODT(I),I=1,3)
C
  200 CONTINUE
C
C            END OF K LOOP
C
      DO 210 I=1,3
      XICO(I)=-XICO(I)/ZMS
  210 XICODT(I)=-XICODT(I)/ZMS
C
      IF(ISWTCH.EQ.0) WRITE(6,20006)
      IF(ISWTCH.EQ.0) WRITE(6,10001) (XICO(I),I=1,3)
      IF(ISWTCH.EQ.0) WRITE(6,20007)
      IF(ISWTCH.EQ.0) WRITE(6,10001) (XICODT(I),I=1,3)
C
C
      CALL J1CAL(J1,SUM,YYDB,BDYMI,ISO)
      IF(ISWTCH.EQ.0) WRITE(6,20008)
      IF(ISWTCH.EQ.0) WRITE(6,10000) ((ISO(I,J),J=1,3),I=1,3)
      SPRNG=0.0D0
C
      IF(IDAMP.EQ.0) GO TO 240
C
      SPRNG=SPRING(ZK1D,ZK2D,PHI,PHIS,RADIAN)
C
      DO 220 I=1,3
      DO 220 J=1,3
  220 ZZT1(I,J)=ZZT1(I,J) + ZZDB(I,J)
      IF(ISWTCH.EQ.0) WRITE(6,20009)
      IF(ISWTCH.EQ.0) WRITE(6,10000) ((ZZT1(I,J),J=1,3),I=1,3)
C
      J2(1,1)=ZZT1(2,2) + ZZT1(3,3)
      J2(2,2)=ZZT1(3,3) + ZZT1(1,1)
      J2(3,3)=ZZT1(1,1) + ZZT1(2,2)
C
      DO 230 I=1,3
      DO 230 J=1,3
  230 IF(I.NE.J) J2(I,J)=-ZZT1(I,J)
      IF(ISWTCH.EQ.0) WRITE(6,20010)
      IF(ISWTCH.EQ.0) WRITE(6,10000) ((J2(I,J),J=1,3),I=1,3)
C
      CALL MATRAN(FM1,FMT,3,3)
      CALL MULTM(FMT,IXDB,J3,3,3,3)
C
  240 YYSO(1,1)=(ISO(2,2) + ISO(3,3) - ISO(1,1))/2
      YYSO(2,2)=(ISO(3,3) + ISO(1,1) - ISO(2,2))/2
      YYSO(3,3)=(ISO(1,1) + ISO(2,2) - ISO(3,3))/2
C
      DO 250 I=1,3
      DO 250 J=1,3
  250 IF(I.NE.J) YYSO(I,J)=ISO(I,J)
C
      IF(ISWTCH.EQ.0) WRITE(6,20011)
      IF(ISWTCH.EQ.0) WRITE(6,10000) ((YYSO(I,J),J=1,3),I=1,3)
C
      CALL IGCAL(INOPT,YYSO,XICO,ZMS,SA,S,IG)
C
      IF(ISWTCH.EQ.0) WRITE(6,20012)
      IF(ISWTCH.EQ.0) WRITE(6,10000) ((IG(I,J),J=1,3),I=1,3)
C
      IP=IG(1,1) + IG(2,2) + IG(3,3)
C
      VRG=VRG1(IP,IG)
      IF(ISWTCH.EQ.0) WRITE(6,10004) VRG
C
      IF(INOPT.EQ.1) GO TO 260
C
      TRSP=TWOT(OMBC,S,ZMS,TBM2)
      VRG=VRG+VGG(BT,OMBC1,IG,IP)
      IF(ISWTCH.EQ.0) WRITE(6,10005) VRG
      IF(ISWTCH.EQ.0) WRITE(6,10006) TRSP
      GO TO 270
  260 TRSP=TWOT(OMEG,SA,ZMS,TBM2)
      IF(ISWTCH.EQ.0) WRITE(6,10007) TRSP
C
  270 HAMILT=TRSP + SPRNG + STRN(SE,IK) + VRG
      IF(ISWTCH.EQ.0) WRITE(6,10008) SPRNG
      IF(ISWTCH.EQ.0) WRITE(6,10009) HAMILT
      RETURN
C
C
10000 FORMAT('0',5X,3(G20.13,2X)/6X,3(G20.13,2X)/6X,3(G20.13,2X))
C
10001 FORMAT('0',5X,3(G20.13,2X))
C
10002 FORMAT('0',2X,'ZETA ',3(G20.13,2X))
C
10003 FORMAT('0',2X,'ETA ',3(G20.13,2X))
C
10004 FORMAT('0',2X,'VRG FOR G.G. ',G20.13)
C
10005 FORMAT('0',2X,'VRG PLUS VCG ',G20.13)
C
10006 FORMAT('0',2X,'TRSP FOR G.G. ',G20.13)
C
10007 FORMAT('0',2X,'TRSP FOR S.S. ',G20.13)
C
10008 FORMAT('0',2X,'SPRING ',G20.13)
C
10009 FORMAT('0',2X,'HAMILTONIAN ',G20.13)
C
20000 FORMAT('0',2X,'ZZT FROM J2CAL')
C
20001 FORMAT('0',2X,'IXDB FROM J3CAL')
C
20002 FORMAT('0',2X,'RSUM FROM ZETACL')
C
20003 FORMAT('0',2X,'RSUM FROM ETACAL')
C
20004 FORMAT('0',2X,'XICO IN K-LOOP')
C
20005 FORMAT('0',2X,'XICODT IN K-LOOP')
C
20006 FORMAT('0',2X,'SUM OVER K OF XICO')
C
20007 FORMAT('0',2X,'SUM OVER K OF XICODT')
C
20008 FORMAT('0',2X,'ISO FROM J1CAL')
C
20009 FORMAT('0',2X,'SUM OF ZZT1 + ZZDB')
C
20010 FORMAT('0',2X,'J2 = SUM OF ZZT1')
C
20011 FORMAT('0',2X,'YYSO = ISO')
C
20012 FORMAT('0',2X,'IG FROM IGCAL')
C
C
      END