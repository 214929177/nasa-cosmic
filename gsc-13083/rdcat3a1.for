      SUBROUTINE RDCAT3A1(TARGDATA,MAXPARM,TARGPARM,KTARGID,TARGNAME,
     *     KTARGTYP,NLOADED,LUERR,IERR)
      IMPLICIT REAL*8 (A-H,O-Z)
C
C THIS IS A SERVICE ROUTINE FOR THE TARGET CATALOGUE READER. IT
C LOADS THE READER'S TARGPARM OUTPUT ARRAY WITH POSITION-RELATED
C INFO READ FROM THE CATALOGUE AND PASSED HERE IN TARGDATA. THIS
C ROUTINE IS ONLY FOR DATA TYPES NOT NEEDING SPECIAL HANDLING.
C
C
C***********************************************************************
C
C BY C PETRUZZO, GSFC/742, 7/85.
C    MODIFIED.....
C
C***********************************************************************
C
      INCLUDE 'RDCAT.INC'
C
      REAL*8 TARGPARM(MAXPARM),TARGDATA(MAXDATA)
      CHARACTER*16 TARGNAME
      REAL*8 DEGRAD / 57.29577951308232D0 /
      LOGICAL HAVEALL
C
C
      IERR = 0
C
C     NUMNEED = NUMBER OF PARAMS IN TARGDATA REQ'D FOR THIS DATA TYPE
      NUMNEED = NUMPARM(KTARGTYP)
C
C ERROR CHECK. SHOULD NOT HAVE CALLED THIS ROUTINE IF SPECIAL HANDLING
C IS REQUIRED FOR THIS DATA TYPE
C
      DO I=1,NSPECIAL
        IF( KTARGTYP.EQ.KSPECIAL(I) )
     *     STOP 'STOPPED IN RDCAT3A1. PROGRAMMER ERROR. SEE CODE.'
        END DO
C
C VERIFY THAT ALL REQUIRED DATA HAS BEEN SUPPLIED WITH A VALUE. THIS
C TEST LOOKS FOR THE PRESENCE OF DATA, NOT ITS VALIDITY.
C
      HAVEALL = .TRUE.
      IF(NUMNEED.GT.0) THEN
        DO I=1,NUMNEED
          HAVEALL = HAVEALL .AND. TARGDATA(I).NE.DEFALT
          END DO
        END IF
C
C
C IF WE HAVE ALL OF THE REQUIRED DATA:
C
C   IF MAXPARM IS LARGE ENOUGH FOR TARGPARM TO HOLD THE DATA THAT IS
C   REQUIRED TO BE PRESENT, LOAD TARGPARM. IF MAXPARM IS TOO SMALL,
C   LOAD NO DATA.
C
      IF(HAVEALL) THEN
        IF(NUMNEED.GT.MAXPARM) THEN
          IERR = KERRFLG2  ! A REDUNDANT TEST. RDCAT3 SHOULD HAVE
          NLOADED = 0      ! FOUND ERROR AND NOT CALLED THIS ROUTINE.
        ELSE
          NLOADED = NUMNEED
          IF(NUMNEED.GT.0) THEN
            DO I=1,NUMNEED
              TARGPARM(I) = TARGDATA(I)*FACTOR(I,KTARGTYP)
              END DO
            END IF
          END IF
        END IF
C
C IF WE ARE MISSING SOME DATA, LOAD NO DATA.
C
      IF(.NOT.HAVEALL) THEN
        IERR = KERRFLG1
        NLOADED = 0
        END IF
C
      RETURN
      END
