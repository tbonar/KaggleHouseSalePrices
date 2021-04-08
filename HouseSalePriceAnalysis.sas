PROC IMPORT DATAFILE= "C:\Users\Taylo\OneDrive - Southern Methodist Univ
ersity\MSDS-6371\KaggleHouse\train.csv" 
			OUT=WORK.TRAINSET REPLACE
            DBMS=CSV;
     DATAROW=2; 
RUN;

PROC IMPORT DATAFILE= "C:\Users\Taylo\OneDrive - Southern Methodist Univ
ersity\MSDS-6371\KaggleHouse\test.csv" 
			OUT=WORK.TESTSET REPLACE
            DBMS=CSV;
     DATAROW=2; 
RUN;

proc print data=work.trainset;
run;

proc print data=work.testset;
run;

data trainset2;
  set trainset testset;
run;

# QOI: Is there a difference in SalePrice for houses in NAmes, Edwards, or BrkSide related to GrLivArea (sq ft of living room);

# Step 1: Plot the Data;
ods html style=BarrettsBlue;
proc sgscatter data = trainset2
				(where=(Neighborhood eq "NAmes" | Neighborhood eq "Edwards" | Neighborhood eq "BrkSide"));
plot SalePrice*GrLivArea / group=Neighborhood;
title "Square Footage of Living Room vs. Sales Price";
label SalePrice="Sale Price" GrLivArea="Square Footage of Living Room";
run;

# Log Transform may be needed;
data logSalePriceGrLivArea;
	set trainset2;
	logSalePrice = log(SalePrice);
	logGrLivArea = log(GrLivArea);
;

proc sgscatter data = logSalePriceGrLivArea
				(where=(Neighborhood eq "NAmes" | Neighborhood eq "Edwards" | Neighborhood eq "BrkSide"));
plot SalePrice*logGrLivArea / group=Neighborhood;
title1 "Log Square Footage of Living Room vs. Sales Price";
label SalePrice="Sale Price" GrLivArea="Square Footage of Living Room";
run;

proc sgscatter data = logSalePriceGrLivArea
				(where=(Neighborhood eq "NAmes" | Neighborhood eq "Edwards" | Neighborhood eq "BrkSide"));
plot logSalePrice*GrLivArea / group=Neighborhood;
title2 "Square Footage of Living Room vs. Log Sales Price";
label SalePrice="Sale Price" GrLivArea="Square Footage of Living Room";
run;

proc sgscatter data = logSalePriceGrLivArea
				(where=(Neighborhood eq "NAmes" | Neighborhood eq "Edwards" | Neighborhood eq "BrkSide"));
plot logSalePrice*logGrLivArea / group=Neighborhood;
title3 "Log Square Footage of Living Room vs. Log Sales Price";
label SalePrice="Log Sale Price" GrLivArea="Log Square Footage of Living Room";
run;

title1;
title2;
title3;
# Construct a Model;
# SalePrice = beta_0 + beta_1*GrLivArea Ask Halle what model she fitted;
proc glm data = logSalePriceGrLivArea
			(where=(Neighborhood eq "NAmes" | Neighborhood eq "Edwards" | Neighborhood eq "BrkSide"))
			plots = all;
  class Neighborhood;
  model SalePrice = GrLivArea Neighborhood / solution clparm;
run;

proc glm data = logSalePriceGrLivArea
			(where=(Neighborhood eq "NAmes" | Neighborhood eq "Edwards" | Neighborhood eq "BrkSide"))
			plots = all;
  class Neighborhood;
  model logSalePrice = logGrLivArea Neighborhood / solution clparm;
run;



