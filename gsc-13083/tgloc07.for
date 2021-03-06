      SUBROUTINE TGLOC07(NTARGS,TARGNAME,NPARMS,PARMS,TSEC50,
     *               KSYSNAT,KCENNAT,TARGPOS,LUERR,IERR)
      IMPLICIT REAL*8 (A-H,O-Z)
C
C THIS ROUTINE IS PART OF THE TOSS TARGET LOCATION PACKAGE, TGLOC.
C IT COMPUTES THE POSITION OF A SATELLITE IN GEOCENTRIC MEAN EARTH
C EQUATOR AND EQUINOX OF 1950.0 COORDINATES.
C
C VAR     DIM    TYPE I/O DESCRIPTION
C ---     ---    ---- --- -----------
C
C NTARGS   1      I*4  I  NUMBER OF TARGETS TO BE PROCESSED.
C                         IF ZERO OR NEGATIVE, NONE ARE PROCESSED.
C
C TARGNAME NTARGS CH*16 I NAME OF THE TARGET.
C
C                         IF THE NAME IS 'TDRS1' OR 'TDRS2', SPECIFIC
C                         TDRS'S ARE ASSUMED AND THE POSITIONS ARE
C                         COMPUTED BY THE TOSS ROUTINE TDRSLOC. IN THIS
C                         CASE, THE PARMS ARRAY IS IGNORED.
C
C NPARMS   1      I*4  I  THE NUMBER OF PARAMETERS SUPPLIED IN THE PARMS
C                         ARRAY.  THE MINIMUM VALUE VARIES ACCORDING TO
C                         THE CONTENTS OF PARMS(1,-), THE PARAMETER THAT
C                         TELLS HOW TO GET THE TARGET SATELLITE'S
C                         POSITION.  SEE THE PARMS DESCRIPTION IN TGLOC.
C
C PARMS           R*8  I  SAME AS TGLOC'S DESCRIPTION OF PARMS FOR
C    NPARMS,NTARGS        TARGET TYPE 7.
C
C TSEC50   1      R*8  I  TIME AT WHICH THE SATELLITE POSITION IS
C                         WANTED.  IN SECONDS SINCE 1/1/50, 0.0 HR.
C
C KSYSNAT  1      I*4  O  IDENTIFIES THE NATURAL COORDINATE SYSTEM'S
C                         ORIENTATION.  IS SET TO 1 TO INDICATE THE
C                         ORIENTATION IS MEAN EARTH EQUATOR AND
C                         EQUINOX OF 1950.0
C
C KCENNAT  1      I*4  O  IDENTIFIES THE NATURAL COORDINATE SYSTEM'S
C                         ORIGIN.  IS SET TO 1 TO INDICATE THE ORIGIN IS
C                         THE EARTH CENTER.
C
C TARGPOS 3,NTARGS R*8 O  TARGPOS(-,I) IS THE POSITION OF THE I'TH
C                         TARGET.  COORDS ARE IN THE GEOCENTRIC, MEAN
C                         EARTH EQUATOR AND EQUINOX OF 1950.0 SYSTEM.
C                         IN KM.
C
C LUERR    1      I*4  I  FORTRAN UNIT NUMBER FOR ERROR MESSAGES.
C                          = 0/NEGATIVE, NO MESSAGES POSSIBLE.
C
C IERR     1      I*4  O  ERROR RETURN FLAG.
C                          = 0, NO ERROR.
C                          = OTHERWISE, ERROR.
C
C***********************************************************************
C
C BY C PETRUZZO, GSFC/742, 8/85.
C        MODIFIED....
C
C***********************************************************************
C
      REAL*8 PARMS(NPARMS,1)
      REAL*8 TARGPOS(3,1)
      CHARACTER*16 TARGNAME(1),NAME
      REAL*8 TDRSPOS(3,2),TDLONG(2),SCPOS(3),SCVEL(3),DUM3(3),
     *       HEADPARM(12)
      CHARACTER*16 TDRS1/'TDRS1'/,TDRS2/'TDRS2'/
C
      IBUG = 0
      LUBUG = 19
C
      IF(IBUG.NE.0) THEN
        KK = MIN(NPARMS,10)
        WRITE(LUBUG,5501) NTARGS,PAKTIM50(TSEC50),NPARMS
 5501   FORMAT(/,' TGLOC07 DEBUG. INPUT IS: NTARGS=',I3,
     *              '   TIME= ',G20.12,' NPARMS=',I3)
        IF(NTARGS.GT.0) THEN
          DO ITARG=1,NTARGS
            WRITE(LUBUG,5502) ITARG,(PARMS(I,ITARG),I=1,KK)
 5502       FORMAT('   ITARG=',I4,'  TARGNAME(ITARG)=',A,
     *               '  PARMS(-,ITARG)='/,(T10,5G16.8))
            END DO
          END IF
        END IF
C
C
      IERR = 0
      KSYSNAT = 1  ! ORIENTATION IS MEAN OF 1950.0
      KCENNAT = 1  ! ORIGIN IS EARTH CENTER
      IF(NTARGS.LE.0) GO TO 9999
C
C
C GET TARGET POSITION VECTOR IN THE 'NATURAL' SYSTEM.
C
      DO 1000 ITARG=1,NTARGS
C
C    ERROR CHECK ON NPARMS VALUE AND PARMS CONTENTS.
      CALL TGLOC07A(NPARMS,PARMS(1,ITARG),TARGNAME(ITARG),LUERR,IERR1)
      IF(IERR1.NE.0) THEN
        IERR = 1
        TARGPOS(1,ITARG) = 'ERROR'
        TARGPOS(2,ITARG) = 'ERROR'
        TARGPOS(3,ITARG) = 'ERROR'
        GO TO 1000
        END IF
C
      NAME = TARGNAME(ITARG)
      KSOURCE = JIDNNT(PARMS(1,ITARG))
      IER1 = 0
      KCOORD = 0
C
      IF(KSOURCE.EQ.0) THEN    ! NO INITIAL CONDS
        KCOORD = 1
        IF(NAME.EQ.TDRS1 .OR. NAME.EQ.TDRS2) THEN
          CALL TDRSLOC(TSEC50,TDRSPOS,TDLONG)  ! GET LOCATION OF BOTH
          ITD = 1
          IF(NAME.EQ.TDRS2) ITD = 2
          SCPOS(1) = TDRSPOS(1,ITD)
          SCPOS(2) = TDRSPOS(2,ITD)
          SCPOS(3) = TDRSPOS(3,ITD)
        ELSE
          SCPOS(1) = 0.D0
          SCPOS(2) = 0.D0
          SCPOS(3) = 0.D0
          END IF
        END IF
C
      IF(KSOURCE.EQ.1) THEN   ! INITIAL CONDS PRESENT
        KELEMS = JIDNNT(PARMS(4,ITARG))    ! KEPLERIAN(=1)/CARTESIAN(=2)
        KCOORD = JIDNNT(PARMS(2,ITARG))    ! COORDINATE SYSTEM INPUT
        ERTHMU = CONST(56)
        EPOCH = PARMS(3,ITARG)
        IF(KELEMS.EQ.1) THEN       ! KEPLERIAN ELEMENTS WERE SUPPLIED
          CALL TOCART(ERTHMU,PARMS(5,ITARG),0,SCPOS,SCVEL,LUERR,IER1)
          IF(IER1.NE.0) GO TO 990
        ELSE IF(KELEMS.EQ.2) THEN  ! CARTESIAN STATE WAS SUPPLIED
          DO I=1,3
            SCPOS(I) = PARMS(4+I,ITARG)
            SCVEL(I) = PARMS(7+I,ITARG)
            END DO
        ELSE  ! ERROR SHOULD HAVE BEEN SENSED IN TARGET CATALOGUE READER
          TYPE *,' TGLOC07. KELEMS VALUE NOT VALID. SEE SOURCE. STOP.'
          STOP   ' TGLOC07. KELEMS VALUE NOT VALID. SEE SOURCE. STOP.'
          END IF
        CALL TUBODY(ERTHMU,SCPOS,SCVEL,TSEC50-EPOCH,SCPOS,
     *         DUM3,LUERR,IER1)
        IF(IER1.NE.0) GO TO 990
        END IF
C
      IF(KSOURCE.EQ.2) THEN  ! EPHEM FILE IS THE SOURCE
        LUEPHEM = JIDNNT(PARMS(2,ITARG))
        IF(LUEPHEM.GT.0) THEN
          CALL EPHEAD(LUEPHEM,0,1,HEADPARM,LUERR,IER1)
          IF(IER1.NE.0) GO TO 990
          CALL GETEPH(TSEC50,SCPOS,DUM3,0,LUEPHEM,LUERR,IER1)
          IF(IER1.NE.0) GO TO 990
          KCOORD = HEADPARM(12)
        ELSE
C        THIS ERROR SHOULD HAVE BEEN PICKED UP IN TGLOC07A.
          TYPE *,' TGLOC07. ERROR END 1.  CODING ERROR.  SEE SOURCE.'
          STOP   ' TGLOC07. ERROR END 1.  CODING ERROR.  SEE SOURCE.'
          END IF
        END IF
C
  990 CONTINUE
C
      IF(IER1.EQ.0) THEN
C      IF NECESSARY, ROTATE SCPOS TO MEAN OF 1950.0
        IF(KCOORD.EQ.1) THEN
          CONTINUE
        ELSE IF(KCOORD.EQ.2) THEN
          CALL VECM50MDT(TSEC50,-1,SCPOS,SCPOS)
        ELSE IF(KCOORD.EQ.3) THEN
          CALL VECM50TOD(TSEC50,-1,SCPOS,SCPOS)
        ELSE  ! COORDINATE SYSTEM IS NOT RECOGNIZED.
          TYPE *,' TGLOC07. ERROR END 2.  CODING ERROR.  SEE SOURCE.'
          STOP   ' TGLOC07. ERROR END 2.  CODING ERROR.  SEE SOURCE.'
          END IF
      ELSE
C      ERROR CONDITION FOR THIS TARGET.
        IERR = 1
        SCPOS(1) = 'ERROR'
        SCPOS(2) = 'ERROR'
        SCPOS(3) = 'ERROR'
        END IF
C
      TARGPOS(1,ITARG) = SCPOS(1)
      TARGPOS(2,ITARG) = SCPOS(2)
      TARGPOS(3,ITARG) = SCPOS(3)
C
 1000 CONTINUE
C
 9999 CONTINUE
      RETURN
  510 FORMAT(/,' TARGET LOCATION PACKAGE ERROR. TGLOC07 ERROR ',I1,
     * '. SEE CODE.'/,' KSOURCE=',I5,'  NPARMS=',I5,'   TARGET NAME=',A)
      END
