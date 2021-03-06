      SUBROUTINE GDALMG(MODEL,TM,GDLAT,GDLON,GDALT,X,Y,Z,F,H,DEC,AINC)
C ****  GEODETIC VERSION OF GEOMAGNETIC FIELD SUBROUTINE
C ****  PROGRAM DESIGNED AND TESTED BY G D MEAD AND E G STASSINOPOULOS,
C ****  CODE 641, NASA GODDARD SPACE FLT CTR, GREENBELT, MD 20771
C***INPUT   MODEL = 1-7; CHOICE OF SEVEN MODELS - SEE ALLMAG
C           TM = TIME IN YEARS FOR DESIRED FIELD (E.G. 1971.25)
C           GDLAT = GEODETIC LATITUDE (DEGREES)
C           GDLON = EAST LONGITUDE (DEGREES)
C           GDALT = ALTITUDE ABOVE GEOID (KMS)
C***OUTPUT  X,Y,Z = GEODETIC FIELD COMPONENTS (GAUSS)
C           F = MAGNITUDE OF FIELD (GAUSS)
C           H = HORIZONTAL INTENSITY (GAUSS)
C           DEC, AINC = DECLINATION AND INCLINATION ANGLES (DEGREES)
C***  NOTE  FOR GREATEST EFFICIENCY, COMPLETE ALL CALCULATIONS WITH ONE
C     MODEL AND ONE TIME BEFORE CHANGING MODEL OR TIME.
C   REFERENCE GEOID IS THAT ADOPTED BY IAU IN 1964
      IMPLICIT REAL*8(A-H,O-Z)
      DATA RAD,A,AB2,E2/57.29578D0,6378.165D0,1.0067397D0,.0067397D0/
      SINLAT = DSIN(GDLAT/RAD)
      COSLAT = DSQRT(1.-SINLAT**2)
      IF(MODEL.EQ.6) GO TO 2
    1 SINBET = SINLAT /DSQRT(SINLAT**2+(AB2*COSLAT)**2)
C***   BETA = GEOCENTRIC LATITUDE AT SURFACE OF GEOID
      COSBET =DSQRT(1.-SINBET*SINBET)
      RGEOID = A /DSQRT(1.+E2*SINBET*SINBET)
      XKM = RGEOID*COSBET + GDALT*COSLAT
      YKM = RGEOID*SINBET + GDALT*SINLAT
      RKM = DSQRT(XKM**2+YKM**2)
      ST = XKM/RKM
      CT = YKM/RKM
      GO TO 3
    2 RKM = 6371.2 + GDALT
      ST = COSLAT
      CT = SINLAT
    3 SP = DSIN(GDLON/RAD)
      CP = DCOS(GDLON/RAD)
      CALL ALLMAG(MODEL,TM,RKM,ST,CT,SP,CP,BR,BT,Y,F)
      SIND = ST*SINLAT - CT*COSLAT
      COSD = CT*SINLAT + ST*COSLAT
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C     X = -BT*COSD - BR*SIND
C     Z =  BT*SIND - BR*COSD
C   REPLACE BY THE FOLLOWING CARDS
C    IN THIS CASE THE VECTOR OF FIELD IS OUTWARD POSITIVE
      X=-BT
      Z=BR
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      H = DSQRT(X*X+Y*Y)
      DEC = RAD * DATAN2(Y,X)
      AINC = RAD * DATAN(Z/H)
      RETURN
      END
