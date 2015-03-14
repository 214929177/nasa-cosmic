      SUBROUTINE QUIKVIS5B1B(T1,T50,VISTIMES,TARGPARM)
      IMPLICIT REAL*8 (A-H,O-Z)
C
C THIS ROUTINE IS PART OF THE QUIKVIS PROGRAM.  IT GIVES THE MAP OF
C AVAILABILITY TIMES FOR THE SURVEY OPTION.
C
C >>  FOR ALL DATES IN THE T1-TO-T50 SPAN, MINIMUM AVAILABILITY
C     DURATIONS PER ORBIT HAVE BEEN GATHERED FOR ALL TARGETS ON THE
C     GRID AND ALL RAAN'S AND DATES OF INTEREST.  GIVE THE RESULTS SO
C     FAR IN MAP FORMAT.
C
C VARIABLE      DIM       TYPE I/O DESCRIPTION
C --------      ---       ---- --- -----------
C
C T1             1         R*8  I  THE FIRST TIME IN THE SPAN. IN
C                                  SECONDS SINCE 1950.0
C
C T50            1         R*8  I  END TIME IN THE SPAN. IN SECONDS
C                                  SINCE 1950.0
C
C VISTIMES    MAXTARGS     R*8  I  THE DURATION PER ORBIT(ALL NODES
C                                  CONSIDERED) THAT A TARGET IS AVAIL.
C                                  MAX BE FOR A SINGLE TIME OR RANGE OF
C                                  TIMES, DEPENDING ON T1 VALUE. SEE
C                                  QUIKVIS5B FOR BETTER DESCRIPTION.
C                                  IN SECONDS.
C
C TARGPARM NPARMS,MAXTARGS R*8  I  DESCRIBED IN QUIKVIS(=MAIN) PROLOGUE.
C
C***********************************************************************
C
C  BY C PETRUZZO/GSFC/742  1/86.  CODE BASED ON CODE IN TOSS'S DURATN
C                                 SUBROUTINE USED BY SKYPLOT PGM.
C         MODIFIED...........
C
C**********************************************************************
C
      INCLUDE 'QUIKVIS.INC'
C
      REAL*8 VISTIMES(MAXTARGS)
      REAL*8 TARGPARM(NPARMS,MAXTARGS)
C
      REAL*8 SECMIN/60.D0/
      REAL*8 RACN(NRASURVEY),DECL(NDECSURVEY)
      CHARACTER*30 SHADTEXT
      CHARACTER*20 CH1,CH2
C
      PARAMETER (MAXSYM=10)
      LOGICAL*1 SYMBOLS(10)/'1','2','3','4','5','6','7','8','9','?'/
      LOGICAL*1 NOSEE/':'/,SYMSAV(61,121),BLANK/' '/,PLTSYM,QMARK/'?'/
C
CC    [NQCJP]ANGPLPRM.FOR    11/24/81
C
C//////////////////////////////////////////////////////////////////////
C
C     STANDARD ARRAYS FOR PETRUZZO'S PRINTER PLOT ROUTINES FOR ANGLES.
C
      LOGICAL*1 SYMHLD(61,121)
      REAL*4 PLTPRM(19)
      INTEGER BOTTOM,RIGHT
      REAL*8 XSEG,YSEG,WEST
C
      EQUIVALENCE (PLTPRM(1),XSEG),(PLTPRM(3),YSEG),
     1            (PLTPRM(5),WEST)
      EQUIVALENCE (PLTPRM(13),BOTTOM),(PLTPRM(14),RIGHT),
     1            (PLTPRM(15),IEWLBL),(PLTPRM(16),ILABEL),
     2            (PLTPRM(17),IGRID ),(PLTPRM(18),IEQATR),
     3            (PLTPRM(19),IOPTN )
C
C     SHORT DESCRIPTION(SETGRD HAS A LONGER DESCRIPTION)----------
C
C     USER MUST SET THE VARIABLES AS NAMED BELOW. DO NOT SET PLTPRM
C     DIRECTLY. (EX- USE BOTTOM=19, NOT PLTPRM(13)=19.)
C
C  1,2     XSEG(R*8)   RADIANS BETWEEN TICK MARKS FOR X-AXIS.
C  3,4     YSEG(R*8)   RADIANS BETWEEN TICK MARKS FOR Y-AXIS.
C  5,6     WEST(R*8)   ANGLE VALUE OF LEFT HAND BORDER. RADIANS.
C  7-12    INTERNAL    NOT USER-DEFINED.
C  13      BOTTOM(I*4) NUMBER OF LINES IN THE PRINTER PLOT.
C  14      RIGHT(I*4)  NUMBER OF COLUMNS IN THE PRINTER PLOT.
C  15      IEWLBL(I*4) EAST ONLY(+1)/EAST&WEST(-1) FLAG FOR LABELS.
C  16      ILABEL(I*4) YES(1)/NO(0) FLAG FOR LABELS.
C  17      IGRID(I*4)  YES(1)/NO(0) FLAG FOR GRID LINES AT TICK MARK.
C  18      IEQATR(I*4) YES(1)/NO(0) FLAG FOR EQUATOR INDICATION.
C  19      IOPTN(I*4)  MAP OPTION. 1=RECTANGULAR, 2=AITOFF.
C
      DATA YSEG/ 3.141592653589793D0 /
      DATA XSEG/ 6.283185307179586D0 /
      DATA WEST/0.D0/
      DATA BOTTOM/19/,RIGHT/121/
      DATA IEWLBL/1/,ILABEL/1/,IGRID/0/,IEQATR/0/,IOPTN/1/
C
C/////////////////////////////////////////////////////////////////////
C
C
C LOAD PLOT PARAMETERS TO ARRAY 'PLTPRM' IN THE ANGLE PLOT PACKAGE.
C
      XSEG = 30.D0/DEGRAD
      YSEG = 30.D0/DEGRAD
      WEST = 0.D0
      BOTTOM = 61
      RIGHT = 121
      IGRID = 1
      IOPTN = 1
C
C SET MISC PARAMS.
C
      TGRAN = 300.D0                  ! TIME GRANULARITY. SECONDS.
      DXTARG = TWOPI/(NRASURVEY-1)    ! RACN INTERVAL BETWEEN TARGETS.
      DYTARG = PI/(NDECSURVEY-1)      ! DECL INTERVAL BETWEEN TARGETS.
      DO IRA=1,NRASURVEY
        RACN(IRA) = TARGPARM(1,IRA)   ! RACNS OF TARGETS INVOLVED.
        END DO
      DO IDEC=1,NDECSURVEY
        INDEX = (IDEC-1)*NRASURVEY + 1
        DECL(IDEC) = TARGPARM(1,IDEC) ! DECLS OF TARGETS INVOLVED.
        END DO
      DURMIN = 1.D10
      DURMAX = -1.D10
      DO I=1,NRASURVEY*NDECSURVEY
        DURMIN = DMIN1(DURMIN,VISTIMES(I))
        DURMAX = DMAX1(DURMAX,VISTIMES(I))
        END DO
C
C
C *******************
C * PLOT GENERATION *
C *******************
C
C INITIALIZE SYMHLD AND PLTPRM'S INTERNALLY SET VARIABLES..
C
      CALL ANGPL1(SYMHLD,PLTPRM)
C
C LOAD SYMHLD WITH SYMBOLS INDICATING THE DURATION OF AVAILABILITY FOR
C TARGETS. FOR EXAMPLE, IF A TARGET AT 30 DEG DECLIN AND 120 RACN IS
C VISIBLE FOR 14 MINUTES AND TGRAN IS 10, THEN PUT THE CHARACTER '2'
C AT THAT TARGET LOCATION. (1-10 MINS GETS '1', 11-20 GETS '2',....)
C
      NSYMS = 0         ! NUMBER OF TIME SYMBOLS USED FOR THIS PLOT.
      DYSKY = 1.8D0/DEGRAD     ! DECL INTERVAL BETWEEN PLOT POINTS.
      DXSKY = 1.8D0/DEGRAD     ! RACN INTERVAL BETWEEN PLOT POINTS.
      NYSKY = JIDNNT(PI/DYSKY) + 1     ! NUMBER OF DECLS TO BE PLOTTED.
      NXSKY = JIDNNT(TWOPI/DXSKY) + 1  ! NUMBER OF RACNS TO BE PLOTTED.
      DYSKY = PI/(NYSKY-1)     ! RESET TO BE SURE OF PROPER SPACING.
      DXSKY = TWOPI/(NXSKY-1)  ! RESET TO BE SURE OF PROPER SPACING.
      NXYSKY = NYSKY*NXSKY     ! TOTAL PLOT POINTS TO BE PROCESSED.
C
C TARGETS ARE EVENLY SPACED FROM 0 TO TWOPI IN RACN AND +PI/2 TO -PI/2
C IN DECL. EACH IS AT THE CENTER OF A RECTANGULAR BOX DXTARG WIDE BY
C DYTARG HIGH. A POINT IN THE SKY IS ASSUMED TO HAVE THE SAME
C AVAILABILITY TIME AS THE TARGET IN WHOSE BOX IT LIES.
C
      HALFDYTG = DYTARG/2.D0
      HALFDXTG = DXTARG/2.D0
      BASE = 0.D0        ! LOWER END OF TIME INTERVAL HAVING SYMBOL '1'.
C
C STEP ACROSS THE SKY AND PUT TIME SYMBOLS ON THE PLOT.
C
      DO 310 IDECL=1,NYSKY
      DECLIN = HALFPI-(IDECL-1)*DYSKY    ! DECLIN OF CURRENT SKY POINT.
      KDEC = JIDNNT((HALFPI-DECLIN)/DYTARG)+1
      DO 310 IRACN=1,NXSKY
      RGTACN = (IRACN-1)*DXSKY
      KRA = JIDNNT(RGTACN/DXTARG)+1
      INDEX = (KDEC-1)*NRASURVEY + KRA
      IF(VISTIMES(INDEX).GT.0.D0) THEN
        INDEXSYM = (VISTIMES(INDEX) - BASE - 1.D0)/TGRAN + 1
        INDEXSYM = MAX(INDEXSYM,1)
        NSYMS = MAX(NSYMS,INDEXSYM)  ! NEED TO KNOW HOW MANY SYMBOLS REQ
        INDEXSYM = MIN(INDEXSYM,MAXSYM)
        PLTSYM = SYMBOLS(INDEXSYM)
      ELSE
        PLTSYM = NOSEE    ! SYMBOL SET FOR NON-VISIBLE.
        END IF
C    PUT AVAILABILITY DURATION SYMBOL FOR THE CURRENT SKY POINT ON PLOT.
      CALL ANGPL2(DECLIN,RGTACN,SYMHLD,PLTPRM,PLTSYM)
C
  310 CONTINUE
C
C
C THE GRID HAS BEEN FILLED WITH SYMBOLS. REPLACE WITH A BLANK ANY
C SYMBOL THAT IS SURROUNDED BY THE SAME SYMBOL. THIS BLANKS OUT
C THE INTERIOR OF REGIONS HAVING THE SAME AVAILABILITY AND LEAVES
C NON-BLANKS AS BORDERS BETWEEN REGIONS WITH DIFFERENT SYMBOLS.
C
C FIRST, SAVE THE SYMBOL ARRAY SO THE BORDER CAN BE RESTORED.
C
      DO 345 IX=1,RIGHT
      DO 345 IY=1,BOTTOM
  345 SYMSAV(IY,IX) = SYMHLD(IY,IX)
C
      DO 350 IX=1,RIGHT
      IF(IX.EQ.1 .OR. IX.EQ.RIGHT) GO TO 355
      DO 350 IY=1,BOTTOM
      IF(IY.EQ.1 .OR. IY.EQ.BOTTOM) GO TO 355
      PLTSYM = SYMSAV(IY,IX)
      IF(PLTSYM.EQ.BLANK) GO TO 355
      IF(PLTSYM.EQ.NOSEE) GO TO 355
      IF(PLTSYM.EQ.QMARK) GO TO 355
C
C    LOOK UP ONE LINE, SAME PRINT POSITION.
      IF(SYMSAV(IY-1,IX).NE.PLTSYM) GO TO 355
C    LOOK DOWN ONE LINE, SAME PRINT POSITION.
      IF(SYMSAV(IY+1,IX).NE.PLTSYM) GO TO 355
C    LOOK RIGHT ONE PRINT POSITION, SAME LINE.
      IF(SYMSAV(IY,IX+1).NE.PLTSYM) GO TO 355
C    LOOK LEFT ONE PRINT POSITION, SAME LINE.
      IF(SYMSAV(IY,IX-1).NE.PLTSYM) GO TO 355
C
      SYMHLD(IY,IX) = BLANK
  355 CONTINUE
  350 CONTINUE
C
C
C THE PLOT BORDER AND GRID LINES WERE OVERLAID. RESTORE THEM.
C
      CALL ANGPL1(SYMSAV,PLTPRM)  ! FORM BORDER AND GRID LINES.
      DO 360 IX=1,RIGHT
      DO 360 IY=1,BOTTOM
      IF(SYMSAV(IY,IX).NE.BLANK) SYMHLD(IY,IX) = SYMSAV(IY,IX)
  360 CONTINUE
C
C
C PRINT THE GRID FORMING THE PLOT.
C
      CALL ANGPL3(SYMHLD,PLTPRM,LUPRINT)
C
C
C ADD INFO BELOW THE PLOT.
C
      WRITE(LUPRINT,766) NOSEE,
     *  ('(',(BASE+(ISYM-1)*TGRAN)/SECMIN, (BASE+ISYM*TGRAN)/SECMIN,
     *   SYMBOLS(JMIN0(ISYM,MAXSYM)),ISYM=1,NSYMS)
  766 FORMAT(
     *  ' KEY TO SYMBOLS: ( MIN TIME - MAX TIME)=SYMBOL',
     *        '      NEVER VISIBLE=',A1,
     *  99(/, 7(2X,A,F5.1,'-',F5.1,')=',A1) ))
C
      WRITE(LUPRINT,767) DURMIN/SECMIN,DURMAX/SECMIN
  767 FORMAT(' MIN/MAX OBSERVATION TIMES(MINUTES) = ',2G11.3)
C
C GIVE MISC DATA
C
      CALL QUIKVIS5B1X(2,T1,T50)
C
      RETURN
C
C***********************************************************************
C
C
C**** INITIALIZATION CALL. PUT GLOBAL PARAMETER VALUES INTO THIS
C     ROUTINE'S LOCAL VARIABLES.
C
      ENTRY QVINIT5B1B
C
      CALL QUIKVIS999(-1,R8DATA,I4DATA,L4DATA)
      RETURN
C
C***********************************************************************
C
      END