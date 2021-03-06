      SUBROUTINE AWREAD
C
      IMPLICIT REAL*8(A-H,O-Z)
C
      COMMON/ADDMOM/ HWL(3),HAXWH(3),HELGM(3)
C
      COMMON/ADSTAT/ DER(150),DEP(150)
C
      COMMON/CONSTS/ PI,TWOPI,RADIAN
C
      COMMON/CSTVAL/ TSTART
C
      COMMON/DATOUT/ IDATA,MLAST
C
      COMMON/DEBUG2/ IOUT,JOUT,KLUGE
C
      COMMON/IMAIN1/ IDATE,LSAVE,IDUM1(6)
C
      COMMON/ARBMWH/ AMPARM(200),IAMPRM(10)
C
      COMMON/RPOOL1/ RHOK(10),TIME,SA(3,3),FM1(3,3),ZLK(10),OMEG(3),
     1 DUM01(83)
C
      COMMON/TRQOUT/ OUTTRQ(150)
C
      COMMON/VARBLS/ DEPEND(150),DERIV(150)
C
      COMMON/XIN4  / UP(150),DN(150),BNDS(22)
C
C
      DIMENSION HEDPC(5),ETA(7)
      DIMENSION HDPID(5),HDMOT(5)
      DIMENSION ANOISE(3),PNOISE(3),FNOISE(3)
      DIMENSION FREQNS(3),PHASNS(3)
      DIMENSION HDOT(3),RWHEEL(3),OUTP(6)
      DIMENSION WAXIS(3)
      REAL*4 BUFF(450)
C
      DATA I8/',A8,'/
      DATA HEDPC/'AXIS MOM','ENTUM WH','EEL CONT','ROL SYST','EM      '/
      DATA HDPID/'WHEEL CO','NTROLLER',' PARAMET','ERS     ','        '/
      DATA HDMOT/'WHEEL  D','RIVE MOT','OR PARAM','ETERS   ','        '/
C
      EQUIVALENCE (IAMPRM(1),IPCONT)
C
      EQUIVALENCE (AMPARM(31),YWQNT)
      EQUIVALENCE (AMPARM(32),YWXIUP)
      EQUIVALENCE (AMPARM(33),YWXIDN)
      EQUIVALENCE (AMPARM(34),YWKP)
      EQUIVALENCE (AMPARM(35),YWKI)
      EQUIVALENCE (AMPARM(36),YWKD)
      EQUIVALENCE (AMPARM(37),YAWG)
      EQUIVALENCE (AMPARM(38),YBW)
      EQUIVALENCE (AMPARM(61),YWKA)
      EQUIVALENCE (AMPARM(62),YWKT)
      EQUIVALENCE (AMPARM(63),YWKB)
      EQUIVALENCE (AMPARM(64),YWMTUP)
      EQUIVALENCE (AMPARM(65),YWMTDN)
      EQUIVALENCE (AMPARM(66),YWTCUL)
      EQUIVALENCE (AMPARM(67),YWDMIN)
      EQUIVALENCE (AMPARM(68),YWWMOI)
      EQUIVALENCE (AMPARM(80),ANOISE(1)),(AMPARM(83),PNOISE(1))
      EQUIVALENCE (AMPARM(86),FNOISE(1))
      EQUIVALENCE (AMPARM(90),FREQNS(1)),(AMPARM(93),PHASNS(1))
      EQUIVALENCE (AMPARM(2),WAXIS(1)),(AMPARM(5),WGT1)
      EQUIVALENCE (AMPARM(6),WGT2),(AMPARM(7),WGT3)
      EQUIVALENCE (AMPARM(8),EXK)
C
C     CALLED FROM READGP
C
      CALL SETUP(8HAMPARM  ,8,AMPARM,200)
      CALL SETUP(8HIAMPRM  ,4,IAMPRM,20)
C
      RETURN
C
C   ****************************************************************
      ENTRY NUMAMW(NUMEQS)
C   ****************************************************************
C
C     CALLED FROM NUMPGE
C
      IF(IPCONT.EQ.0) RETURN
      NYAW=NUMEQS+1
      NUMEQS=NUMEQS+3
C
      RETURN
C
C   ****************************************************************
      ENTRY AWECHO
C   ****************************************************************
C
C     CALLED FROM ECHOGP
C
      IF(IPCONT.EQ.0) RETURN
C
      CALL HVAL(HEDPC)
C
      CALL HVAL(HDPID)
C
      CALL FVAL('YAW     ',4,AMPARM(31),6,0,1)
C
      CALL HVAL(HDMOT)
C
      CALL FVAL('YAW     ',4,AMPARM(61),7,0,1)
C
      RETURN
C
C   ****************************************************************
      ENTRY AWINIT
C   ****************************************************************
C
C     CALLED FROM MAIN FOR INITIAL CONDITIONS AND INTEGRATION BOUNDS
C     CALLED AFTER CALL TO SETVAL(1)
C
      IF(IPCONT.EQ.0) RETURN
C
      CALL DEBANG(YAW,ROLL,PITCH)
      ANG=WGT1*ROLL+WGT2*PITCH+WGT3*YAW
      I1=NYAW+1
      I2=I1+1
      UP(NYAW)=AMPARM(101)
      UP(I1)=AMPARM(101)
      DN(NYAW)=AMPARM(102)
      DN(I1)=AMPARM(102)
      DEP(NYAW)=ANG
      DEP(I1)=0.0D0
      UP(I2)=AMPARM(103)
      DN(I2)=AMPARM(104)
      DEP(I2)=AMPARM(131)
    6 CONTINUE
C
      RETURN
C
C   ****************************************************************
      ENTRY AWREAC(ETA)
C   ****************************************************************
C
C     CALLED FROM DEREQ TO LOAD DERIVATIVES FOR SENSOR
C
      IF(IPCONT.EQ.0) RETURN
      DO 10 I=1,3
      HDOT(I)=0.0D0
      HWL(I)=0.0D0
   10 CONTINUE
      CALL DEBANG(YAW,ROLL,PITCH)
      ANG=WGT1*ROLL+WGT2*PITCH+WGT3*YAW
      DERIV(NYAW)=YAWG*ANG-YBW*DEPEND(NYAW)
      I1=NYAW+1
      I2=I1+1
      TEST=DEPEND(NYAW)
      FOPT=TEST
      IF(DEPEND(NYAW).GE.0.0D0) GO TO 32
C
C     LESS THAN ZERO
C
      IF(DEPEND(I1).GE.0.0D0) GO TO 34
      ARG=(YWXIDN-DEPEND(I1))/YWXIDN
      ARG=EXK*ARG
      IF(ARG.GT.0.0D0) ARG=-ARG
      TEST=0.0D0
      IF(DEPEND(I1).LT.YWXIDN) GO TO 34
      TEST=DEPEND(NYAW)*(1.0D0-DEXP(ARG))
      GO TO 34
C
   32 CONTINUE
C
C     GREATER THAN ZERO
C
      IF(DEPEND(I1).LE.0.0D0) GO TO 34
      ARG=(YWXIUP-DEPEND(I1))/YWXIUP
      ARG=EXK*ARG
      IF(ARG.GT.0.0D0) ARG=-ARG
      TEST=0.0D0
      IF(DEPEND(I1).GT.YWXIUP) GO TO 34
      TEST=DEPEND(NYAW)*(1.0D0-DEXP(ARG))
C
   34 CONTINUE
      FINT=DEPEND(I1)
      FDER=DERIV(NYAW)
      DERIV(I1)=TEST
      YWOUT=YWKP*DEPEND(NYAW)+YWKI*DEPEND(I1)+YWKD*DERIV(NYAW)
      VOPYW=YWKA*YWOUT
      YWMOTT=YWKT*(VOPYW-YWKB*DEPEND(I2))
      IF(YWMOTT.GT.YWMTUP) YWMOTT=YWMTUP
      IF(YWMOTT.LT.YWMTDN) YWMOTT=YWMTDN
      YWMOTT=YWMOTT-DEPEND(I2)*YWTCUL/(YWDMIN+DABS(DEPEND(I2)))
      DERIV(I2)=YWMOTT/YWWMOI
      OUTTRQ(14)=YWMOTT
      VWH=DEPEND(I2)
      YWHD=YWMOTT
      YWH=YWWMOI*DEPEND(I2)
   40 CONTINUE
      DO 36 I=1,3
      HWL(I)=YWH*WAXIS(I)
      HDOT(I)=YWHD*WAXIS(I)
   36 CONTINUE
      RWHEEL(1)=-HDOT(1)+HWL(2)*OMEG(3)-HWL(3)*OMEG(2)
      RWHEEL(2)=-HDOT(2)+HWL(3)*OMEG(1)-HWL(1)*OMEG(3)
      RWHEEL(3)=-HDOT(3)+HWL(1)*OMEG(2)-HWL(2)*OMEG(1)
      OUTTRQ(4)=RWHEEL(1)
      OUTTRQ(5)=RWHEEL(2)
      OUTTRQ(6)=RWHEEL(3)
      ETA(4)=ETA(4)+RWHEEL(1)
      ETA(5)=ETA(5)+RWHEEL(2)
      ETA(6)=ETA(6)+RWHEEL(3)
C
      RETURN
C
C   ****************************************************************
      ENTRY AWPLOT(BUFF,INDEX)
C   ****************************************************************
C
C     CALLED FROM GPPLOT TO LOAD PLOT RECORD
C
      I1=INDEX-1
      INDEX=INDEX+2
      IF(IPCONT.EQ.0) RETURN
      OUTP(1)=FOPT/RADIAN
      OUTP(2)=VWH/RADIAN
      OUTP(3)=FINT/RADIAN
      OUTP(4)=FDER/RADIAN
      BUFF(I1+1)=OUTP(1)
      BUFF(I1+2)=OUTP(2)
C
C
      RETURN
C
C   ****************************************************************
      ENTRY AWPRNT
C   ****************************************************************
C
C     CALLED FROM GPSOUT FOR PRINTED OUTPUT
C
      IF(IPCONT.EQ.0) RETURN
C
      CALL SET('FTR ANG ',0,0,OUTP(1),I8)
      CALL SET('ARB MWS ',0,0,OUTP(2),I8)
      CALL SET('MOT TK  ',0,0,YWMOTT,I8)
      CALL SET('CONT INT',0,0,OUTP(3),I8)
      CALL SET('CONT DER',0,0,OUTP(4),I8)
C
C
      RETURN
C
C
      END
