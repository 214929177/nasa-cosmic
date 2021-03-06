$ IF F$MODE() .EQS. "BATCH" THEN SET PROCESS/NAME= "A New INCA"
$ SET DEF [QPLOT.INCA.SOURCE]
$ DELETE *.PEN;*
$ DELETE *.OBJ;*
$ DELETE *.LIS;*
$ CREATE INCABASE.LLL
$ CREATE INCAWORK.LLL
$ !
$ FOR/NOLIST BALGEN
$ FOR/NOLIST EZGVAL
$ FOR/NOLIST GRADEQ
$ FOR/NOLIST QZHES
$ FOR/NOLIST QZIT
$ FOR/NOLIST QZVAL
$ FOR/NOLIST REDUCE
$ FOR/NOLIST SCALEG
$ !
$ @PAS LONGREAL   INCABASE
$ @PAS POLYMATH   INCABASE
$ @PAS JENKINS    INCABASE
$ @PAS QZ         INCABASE
$ @PAS FCN        INCABASE
$ @PAS FCNOPER    INCABASE
$ @PAS FCNEVAL    INCABASE
$ @PAS FCNIO      INCABASE
$ @PAS OLDFCN     INCABASE
$ @PAS BLOCK      INCABASE
$ @PAS CURVE      INCABASE
$ !
$ @PAS UTIL       INCAWORK
$ @PAS CONVERT    INCAWORK
$ @PAS SCREENEDIT INCAWORK
$ @PAS EDIT       INCAWORK
$ @PAS MISC       INCAWORK
$ @PAS PLOT       INCAWORK
$ @PAS LOCUS      INCAWORK
$ @PAS FREQR      INCAWORK
$ @PAS DESCF      INCAWORK
$ @PAS TIMER      INCAWORK
$ @PAS MAIN       INCAWORK
$ !
$ @LINK
$ PURGE
