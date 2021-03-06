      SUBROUTINE ROOTS (A     ,NA    ,CROOTS,IRL   )
      IMPLICIT COMPLEX*16 (C),  REAL*8 (A-B,D-H,O-Z)
      DIMENSION         A(NA) ,CROOTS(NA)   ,Z(2)  ,ZS(2)
      EQUIVALENCE      (Z(1),CZ)     ,(ZS(1),CZS)
C
C.......................................................................
C
C   VERSION OF APRIL 5, 1976
C
C   PURPOSE:
C    THIS SUBROUTINE COMPUTES ANY DESIRED COMPLEX ROOTS (ZEROES) OF A
C    GIVEN POLYNOMIAL, IF APPROXIMATIONS TO THE DESIRED ROOTS ARE KNOWN.
C
C   METHOD:
C    NEWTON'S METHOD, AS DESCRIBED IN THE REFERENCE.
C
C   REFERENCE:
C    HENRICI, P., 'ELEMENTS OF NUMERICAL ANALYSIS', NEW YORK, WILEY,
C    1965, PAGE 84.
C
C   CALLING SEQUENCE EXPLANATION :
C
C     VARIABLE  I/O   DESCRIPTION
C     --------  ---   --------------------------------------------------
C     A          I    IS AN INPUT DIMENSION NA ARRAY OF REAL
C                     (NON-IMAGINARY) POLYNOMIAL COEFFICIENTS, STARTING
C                     WITH THE LOWEST POWER.
C     NA         I    IS THE NUMBER OF IMPUT COEFFICIENTS (ONE MORE
C                     THAN THE DEGREE OF THE POLYNOMIAL).
C     CROOTS    I/O   IS A COMPLEX*16 ARRAY OF DIMENSION NA
C                     CONTAINING THE STARTING APPROXIMATIONS TO THE
C                     DESIRED ROOTS ON INPUT AND THE SOLUTIONS ON
C                     OUTPUT.
C     IRL        I    IS THE NUMBER OF ROOTS (ZEROES) DESIRED TO BE
C                     SOLVED FOR
C
C   COMMON BLOCK PARAMETERS;
C    NONE
C
C   SUBROUTINES AND FUNCTIONS REQUIRED:
C    NONE
C
C   CALLED BY:
C    LOWALT
C
C.......................................................................
C
C
C   IR COUNTS ROOTS SOLVED SO FAR
C
      IR = 0
      N1 = NA - 1
C
  100 IR = IR + 1
      IF (IR .GT. IRL)  RETURN
C
C   IT COUNTS ITERATIONS ON THIS ROOT SO FAR
C
      IT = 0
C
C   CZ IS THE CURRENTLY ITERATED VALUE OF THE ROOT.
C
      CZ = CROOTS(IR)
C
  150 CB = A(NA)
      CC = A(NA)
C
      DO 200 I=1,N1
         J = NA - I
C
C   CB & CC ARE THE VALUES OF THE POLYNOMIAL(P(Z)) AND ITS DERIVATIVE
C                                                            (P'(Z)).
C
         CB = CZ*CB + A(J)
         IF (J .EQ. 1)  GO TO 200
C
         CC = CZ*CC + CB
  200 CONTINUE
C
      IT = IT + 1
C
C   THE RESULT OF THE LAST ITERATION IS SAVED IN CZS.
C
      CZS = CZ
C
C   NEWTONS METHOD SAYS THAT
C                  Z(I)  =  Z(I-1) - P(Z(I-1))/P'(Z(I-1))
C    TENDS TOWARD A ROOT OF THE POLYNOMIAL P(Z).
C
      CZ = CZ - CB/CC
C
C   THE CONVERGENCE CRITERION (DIF) IS THE SUM OF THE RELATIVE CHANGES
C   IN THE REAL AND IMMAGINARY PARTS OF THE ROOT (CZ).
C
      DIF =DABS((ZS(1) - Z(1))/ZS(1))
      IF (ZS(2) .NE. 0.D0)  DIF = DIF + DABS((ZS(2) - Z(2))/ZS(2))
C
C   IF THE CONVERGENCE CRITERION IS TOO LARGE, ITERATE AGAIN.
C
      IF (DIF .GT.1.D-14)  GO TO 150
C
C   OTHERWISE, THE CONVERGENCE IS COMPLETE.  STORE THE ANSWER FOR OUTPUT
C   AND START ON THE NEXT ROOT.
C
      CROOTS(IR) = CZ
      GO TO 100
C
      END
