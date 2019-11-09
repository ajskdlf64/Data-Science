LIBNAME MYDAT "J:\SASDATA" ;
options fmtsearch = (mydat) ; 
PROC IMPORT OUT= one 
            DATAFILE= "J:\SASData\custdet.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

data one ;
    set one;
	   label PURCHASE = "Purchase(y/n)"	
         AMOUNT	  = "Dollars Spent"	                
         INCOME	  = "Yearly Income"	                
         HOMEVAL  = "Home Value"	
         FREQUENT = "Order Frequency"	              
         RECENCY  = "Recency"	                      
         MARITAL  = "Married (y/n)"	                
         NTITLE	  = "Name Prefix"	                  
         AGE	  = "Age"	                          
         TELIND	  = "Telemarket Ind."	              
         APRTMNT  = "Rents Apartment"	              
         MOBILE	  = "Occupied <1 yr"	               
         DOMESTIC = "Domestic Prod."	               
         APPAREL  =	 "Apparel Purch."	               
         LEISURE  = "Leisure Prod."	                
         KITCHEN  = "Kitchen Prod."	                
         LUXURY	  = "Luxury Items"	                 
         PROMO7	  = "Promo: 1-7 mon."	              
         PROMO13  = "Promo: 8-13 mon."	              
         COUNTY	  = "County Code"	                  
         RETURN	  = "Total Returns"	                
         MENSWARE = "Mens Apparel"	                 
         FLATWARE = "Flatware Purch."	              
         DISHES	  = "Dishes Purch."	                
         HOMEACC  = "Home Furniture"	               
         LAMPS	  = "Lamps Purch."	                 
         LINENS	  = "Linens Purch."	                
         BLANKETS = "Blankets Purch."	              
         TOWELS	  = "Towels Purch."	                
         OUTDOOR  = "Outdoor Prod."	                
         COATS	  = "Coats Purch."	                 
         WCOAT	  = "Ladies Coats"	                 
         WAPPAR	  = "Ladies Apparel"	               
         HHAPPAR  = "His/Her Apparel"	              
         JEWELRY  = "Jewelry Purch."	               
         CUSTDATE = "Date 1st Order"	               
         TMKTORD  = "Telemarket Ord."	              
         ACCTNUM  = "Account Number"	               
         STATECOD = "State Code"	                   
         RACE	  = "Race"	                         
         HEAT	  = "Heating Type"	                 
         NUMCARS  = "Number of Cars"	               
         NUMKIDS  = "Number of Kids"	               
         TRAVTIME = "Travel Time"	                  
         EDLEVEL  = "Education Level"	              
         JOB	  = "Job Category"	                 
         VALRATIO = "$ Value per Mailing"	          
         DINING	  = "Total Dining (kitch+dish+flat)"
         SEX      = "Sex" ;                          
run;

proc format  library = mydat ;
    value yesno 0 = "No"
	                    1 = "Yes" ;
	value racefmt 1 = "White"
	                     2 = "Black"
					    3 = "Native American"
                        4 = "Hispanic"
					    5 = "Pacific Islander";
run;
data mydat.custdet ; 
    set one;
	format pruchase yesno.
	         married yesno.
			 race racefmt.;
run;

proc print data = mydat.custdet;
run;
