	PROGRAM SYMBOLS
C *** LAST REVISED ON  3-AUG-1987 16:18:01.23
C *** SOURCE FILE: [DL.GRAPHICS.LONGLIB]SYMBOLS.FOR
C
C	A SIMPLE PROGRAM TO PLOT A SAMPLE OF EACH PLOTTING SYMBOL
C
C	USES CHAR() WHICH CONVERTS AN INTEGER ASCII VALUE TO A CHARACTER
C	VARIABLE.  SEE DOCUMENTATION FOR COMMENTS ON %REF().
C
	CHARACTER*2 T
	CHARACTER*65 STRING
	DATA STRING/'|6r|\0|_=|6R a|^2|_|]|]|]|]|b|1|2n=1|]|]|]|_|a|5K'/
C
	CALL FRAME(3,0,1.,1.,1.)	!INTIALIZE PLOT PACKAGE
	X1=.5
	Y=1.
C	
C	FIRST PLOT "SYMBOL" CHARACTER FONT
C
	CALL SYMBOL(0.,3.,.2,'SYMBOL Characters',90.,17,-1)
	DO 25 ISYM=0,23
		DO 26 J=0,6
			Y=FLOAT(J)*1.1
			K=J*23+ISYM
			IF (K.GT.134) GOTO 26
			CALL NUMBER(X1+.01,Y,.18,FLOAT(K),90.,-1,-1)
			CALL SYMBOL(X1,Y+.65,.2,K,90.,1,-1)
26		CONTINUE
		X1=X1+.24
25	CONTINUE
	CALL CTERM(2)
	CALL RTERM(2)
	CALL NEWPAGE
C
C	NOW PLOT "SYMS" CHARACTER FONTS
C
	CALL CTERM(-1)
	CALL SYMBOL(0.,3.,.2,'SYMS Characters',90.,15,-1)
	CALL PLOT(1.2,-.5,-3)
	CALL FACTOR(.8)
	DO 43 I=1,32
		X1=(I-1)*.25
		CALL SYMS(X1,0.,.25,I-1,0.,1,-1)
		CALL NUMBER(X1,-.6,.18,FLOAT(I-1),90.,-1,-1)
43	CONTINUE 
	CALL SYMS(-1.3,.5,.2,%REF(STRING),0.,99,-1)
	CALL SYMBOL(0.9,.5,.2,%REF(STRING),0.,60,-1)
	DO 100 I=1,9
	T=CHAR(124)//CHAR(I+47)
	CALL SYMBOL(-.35,I*.9,.15,'Font ',90.,5,-1)
	CALL SYMBOL(999.,999.,.15,I+47,90.,1,-1)
	CALL SYMS(0.,I*.9,.23,%REF(T),0.,2,-1)	! CHANGE FONT,LOCATION
	CALL SYMS(999.,999.,.23,'@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_',
     $		0.,32,-1)
	CALL SYMS(0.,.3+I*.9,.23,%REF(T),0.,2,-1)	! LOCATION
	CALL SYMS(999.,999.,.23,'`abcdefghijklmnopqrstuvwxyz{||}~',
     $		0.,32,-1)
	CALL SYMS(0.,.6+I*.9,.23,%REF(T),0.,2,-1)	! LOCATION
	CALL SYMS(999.,999.,.23,' !"#$%&''()*+,-./0123456789:;<=>?',
     $		0.,32,-1)
100	CONTINUE
	CALL PLOT(0.,0.,3)
	CALL NEWPAGE
	CALL CTERM(2)
	CALL RTERM(2)
C
C	NOW PLOT "SYMSS" CHARACTER FONTS
C
	CALL CTERM(-1)
	CALL SYMBOL(0.,3.,.2,'SYMSS Characters',90.,16,-1)
	DO 44 I=1,32
		X1=(I-1)*.25
		CALL SYMSS(X1,0.,.25,I-1,0.,1,-1,.02,0,0,0,0,0)
		CALL NUMBER(X1,-.6,.18,FLOAT(I-1),90.,-1,-1)
44	CONTINUE 
	CALL SYMSS(-1.3,.5,.2,%REF(STRING),0.,99,-1,.02,0,0,0,0,0)
	CALL SYMBOL(0.9,.5,.2,%REF(STRING),0.,60,-1)
	DO 110 I=1,9
	T=CHAR(124)//CHAR(I+47)
	CALL SYMBOL(-.35,I*.9,.15,'Font ',90.,5,-1)
	CALL SYMBOL(999.,999.,.15,I+47,90.,1,-1)
	CALL SYMSS(0.,I*.9,.23,%REF(T),0.,2,-1,-1,.02,0,0,0,0,0)! CHANGE FONT,LOCATION
	CALL SYMSS(999.,999.,.23,'@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_',
     $		0.,32,-1,.02,0,0,0,0,0)
	CALL SYMSS(0.,.3+I*.9,.23,%REF(T),0.,2,-1,.02,0,0,0,0,0)! LOCATION
	CALL SYMSS(999.,999.,.23,'`abcdefghijklmnopqrstuvwxyz{||}~',
     $		0.,32,-1,.02,0,0,0,0,0)
	CALL SYMSS(0.,.6+I*.9,.23,%REF(T),0.,2,-1,.02,0,0,0,0,0)! LOCATION
	CALL SYMSS(999.,999.,.23,' !"#$%&''()*+,-./0123456789:;<=>?',
     $		0.,32,-1,.02,0,0,0,0,0)
110	CONTINUE
	CALL PLOT(0.,0.,3)
	CALL PLOTND
	CALL CTERM(2)
	STOP
 	END
