$WRITE SYS$OUTPUT "THIS IS THE VMS-SPAM BUILD PROCEDURE FILE.  IT IS"
$WRITE SYS$OUTPUT "ASSUMED SPAM.H AND V*.C HAVE BEEN CONFIGURED FOR"
$WRITE SYS$OUTPUT "YOUR INSTALLATION.  IF THESE FILES WERE PRESENT BEFORE"
$WRITE SYS$OUTPUT "YOU LOADED IN THE NEW DISTRIBUTION, YOU MAY WANT TO"
$WRITE SYS$OUTPUT "DELETE THE NEWER DISTRIBUTED VERSIONS NOW."
$WRITE SYS$OUTPUT " "
$DELETE SPAM.H.,V*.C./CONFIRM
$WRITE SYS$OUTPUT "COMPILING"
$SET VER
$CC CLUSTER.C
$CC CURVEGEN.C
$CC DELETE.C
$CC DIGIPLOT.C
$CC DIRECTORY.C
$CC DISP.C
$CC ERASE.C
$CC FEASUBS.C
$CC FEATURE.C
$CC FILTER.C
$CC FIND.C
$CC FUNC.C
$CC GET.C
$CC HARDCOPY.C
$CC HELP.C
$CC HIST.C
$CC HISTSUBS.C
$CC IDENTIFY.C
$CC INIT.C
$CC KEEP.C
$CC LIBCODE.C
$CC LIBPLOT.C
$CC LIBRSUBS.C
$CC MERGE.C
$CC MIXTURE.C
$CC NORM.C
$CC PAR.C
$CC PHOTO.C
$CC PLOT.C
$CC PLOTSUBS.C
$CC RATIO.C
$CC RETURN.C
$CC SAVEPLOT.C
$CC SCAN.C
$CC SEGDISP.C
$CC SEGSUBS.C
$CC SNAPSHOT.C
$CC SPAMSUBS.C
$CC STORESPEC.C
$CC STRETCH.C
$CC SUBS.C
$CC TOKEN.C
$CC VDI.C
$CC VOS.C
$CC WAVELENG.C
$SET NOVER
$WRITE SYS$OUTPUT "CREATING LINK LIBRARY"
$LIBR/CREATE SPAM.OLB
$LIBR SPAM.OLB *.OBJ
$WRITE SYS$OUTPUT "LINKING SPAM"
$CC MAIN.C
$@LINK
$WRITE SYS$OUTPUT "BUILDING MAKELABEL"
$CC MAKELABEL.C
$@LINK MAKELABEL
$WRITE SYS$OUTPUT "BUILDING UNMAKELA"
$CC UNMAKELA.C
$@LINK UNMAKELA
$WRITE SYS$OUTPUT "REMOVING OBJECT FILES AND PURGING"
$DEL *.OBJ.*
$PURGE/LOG