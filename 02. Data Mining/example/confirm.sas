LIBNAME MYDAT "J:\SASDATA" ;
options fmtsearch = (mydat) ; 
proc print data = mydat.custdet;
run;
