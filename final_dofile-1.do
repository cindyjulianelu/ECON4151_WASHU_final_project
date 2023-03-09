
/* ===========================================================================
	Final Project: Panel data

* Cindy Lu
* Dec 21, 2020
* ECON 4151

=========================================================================== */

** Load data 
use "\\apporto.com\dfs\WUSTL\Users\1353656183_wustl\Downloads\final_project.dta"

/* Part a: Descriptive Statistics */
** Create summary statistics of variables to be included
outreg2 using sumst.doc, replace sum(log) keep(smoke male dmage agesq hsgrad ///
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3)

/*
Question: what should we be observing here? 
Do the education variables (hsgrad somecoll collgrad) contain more variability?
Less variability for some prenatal visit variables (novisit pretri3)?
Less variability in some Kessner index variables?
More variability: smoke male dmage agesq hsgrad somecoll collgrad married adeqcode2 pretri2
Less variability: black pretri3 novisit adeqcode3
*/

/* Part b: OLS */
** Include dummies for year, state, and birth order 
reg dbirwt i.year i.nlbnl i.stateres smoke male dmage agesq hsgrad somecoll /// 
collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3 
** Save results
outreg2 using ols.doc, keep(smoke male dmage agesq hsgrad /// 
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 /// 
pretri3) word replace ctitle(birthweight) label title("OLS Results") dec(4)

reg gestat i.year i.nlbnl i.stateres smoke male dmage agesq hsgrad somecoll /// 
collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3 
** Append results
outreg2 using ols.doc,keep(smoke male dmage agesq hsgrad /// 
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 /// 
pretri3) word append ctitle(gestation) label dec(4)


/* Part c: Random Effects model */
** Define panel structure of dataset
xtset momid3 idx 
** Dependent variable: birthweight
xtreg dbirwt i.year i.nlbnl i.stateres smoke male dmage agesq hsgrad /// 
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3, re
estimates store REM1

** Save results
outreg2 using rem.doc, keep(smoke male dmage agesq hsgrad /// 
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 /// 
pretri3) word replace ctitle(birthweight) label title("REM Results") dec(4)

** Dependent variable: weeks gestation
xtreg gestat i.year i.nlbnl i.stateres smoke male dmage agesq hsgrad /// 
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3, re
estimates store REM2

** Append results
outreg2 using rem.doc, keep(smoke male dmage agesq hsgrad /// 
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 /// 
pretri3) word append ctitle(gestation) label dec(4)


/* Part d: Fixed Effects model */
** Dependent variable: birthweight
xtreg dbirwt i.year i.nlbnl i.stateres smoke male dmage agesq hsgrad /// 
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3, fe
estimates store FEM1

** Save results
outreg2 using fem.doc, keep(smoke male dmage agesq hsgrad /// 
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 /// 
pretri3) word replace ctitle(birthweight) label title("FEM Results") dec(4)

** Dependent variable: weeks gestation
xtreg gestat i.year i.nlbnl i.stateres smoke male dmage agesq hsgrad /// 
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3, fe
estimates store FEM2

** Append results
outreg2 using fem.doc, keep(smoke male dmage agesq hsgrad /// 
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 /// 
pretri3) word append ctitle(gestation) label dec(4)


/* Part e: comparison of coefficients estimated via FE & RE */
** Hausman test
/* 
Note:
	- Unobserved effect and each explanatory variable are correlated ==> FE.
	- Unobserved effect and each explanatory variable are uncorrelated ==> RE.
Hausman test:
	- H0: RE is preferred to FE (H1: FE is preferred to RE)
*/
hausman FEM1 REM1, sigmamore
hausman FEM2 REM2, sigmamore


/* Part f: reestimate with proxy */
** Subsample proxy = 0 models
use "\\apporto.com\dfs\WUSTL\Users\1353656183_wustl\Downloads\final_project.dta", clear
keep if proxy == 0

** Birthweight 3 models
** Pooled OLS on proxy = 0 dataset
reg dbirwt i.year i.nlbnl i.stateres smoke male dmage agesq hsgrad somecoll /// 
collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3
** Save results 
outreg2 using myreg.doc, keep(smoke male dmage agesq hsgrad /// 
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 /// 
pretri3) replace ctitle(OLS) dec(4)

** Define panel dataset
xtset momid3 idx

** Random effects on proxy = 0 dataset
xtreg dbirwt i.year i.nlbnl i.stateres smoke male dmage agesq hsgrad /// 
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3, re

estimates store REbirth0
** Append results
outreg2 using myreg.doc, append ctitle(Random Effects) keep(smoke male dmage agesq hsgrad somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3) dec(4)

** Fixed effects on proxy = 0 dataset
xtreg dbirwt i.year i.nlbnl i.stateres smoke male dmage agesq hsgrad /// 
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3, fe

estimates store FEbirth0
** Append results
outreg2 using myreg.doc, append ctitle(Fixed Effects) keep(smoke male dmage agesq hsgrad somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3) dec(4)


** Gestation models
** Pooled OLS on proxy = 0 dataset
reg gestat i.year i.nlbnl i.stateres smoke male dmage agesq hsgrad somecoll /// 
collgrad married black adeqcode2 adeqcode3 novisit pretri2 

** Save results 
outreg2 using gestat0.doc, keep(smoke male dmage agesq hsgrad /// 
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 /// 
pretri3) replace ctitle(OLS) dec(4)

** Random Effects on proxy = 0 
xtreg gestat i.year i.nlbnl i.stateres smoke male dmage agesq hsgrad /// 
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3, re

estimates store REgest0
** Append results
outreg2 using gestat0.doc, append ctitle(Random Effects) keep(smoke male dmage agesq hsgrad somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3) dec(4)

** Fixed effects on proxy = 0 dataset
xtreg gestat i.year i.nlbnl i.stateres smoke male dmage agesq hsgrad /// 
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3, fe

estimates store FEgest0
** Append results
outreg2 using gestat0.doc, append ctitle(Fixed Effects) keep(smoke male dmage agesq hsgrad somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3) dec(4)


** Subsample proxy = 1 models
use "\\apporto.com\dfs\WUSTL\Users\1353656183_wustl\Downloads\final_project.dta", clear
keep if proxy == 1

** Birthweight 3 models
** Pooled OLS on proxy = 1
reg dbirwt i.year i.nlbnl i.stateres smoke male dmage agesq hsgrad somecoll /// 
collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3

** Save results
outreg2 using bweight1.doc, keep(smoke male dmage agesq hsgrad /// 
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 /// 
pretri3) word replace ctitle(OLS) dec(4)

** Define panel dataset
xtset momid3 idx

** Random Effects on proxy = 1
xtreg dbirwt i.year i.nlbnl i.stateres smoke male dmage agesq hsgrad /// 
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3, re

estimates store REbirth1
** Append results
outreg2 using bweight1.doc, append ctitle(Random Effects) keep(smoke male dmage agesq hsgrad somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3) dec(4)

** Fixed effects on proxy = 1 
xtreg dbirwt i.year i.nlbnl i.stateres smoke male dmage agesq hsgrad /// 
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3, fe

estimates store FEbirth1
** Append results
outreg2 using bweight1.doc, append ctitle(Fixed Effects) keep(smoke male dmage agesq hsgrad somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3) dec(4)


** Gestation models
** Pooled OLS on proxy = 1 dataset
reg gestat i.year i.nlbnl i.stateres smoke male dmage agesq hsgrad somecoll /// 
collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3

** Save results 
outreg2 using gestat1.doc, keep(smoke male dmage agesq hsgrad /// 
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 /// 
pretri3) replace ctitle(OLS) dec(4)

** Random Effects on proxy = 1
xtreg gestat i.year i.nlbnl i.stateres smoke male dmage agesq hsgrad /// 
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3, re

estimates store REgest1
** Append results
outreg2 using gestat1.doc, append ctitle(Random Effects) keep(smoke male dmage agesq hsgrad somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3) dec(4)

** Fixed effects on proxy = 1 dataset
xtreg gestat i.year i.nlbnl i.stateres smoke male dmage agesq hsgrad /// 
somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3, fe

estimates store FEgest1
** Append results
outreg2 using gestat1.doc, append ctitle(Fixed Effects) keep(smoke male dmage agesq hsgrad somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3) dec(4)



/* Part g: comparing FE & RE estimates using subsample proxy = 1 */
** Hausman test
hausman FEgest1 REgest1
hausman FEbirth1 REbirth1

/* Part h: comparing FE & RE estimates using subsample proxy = 0 */
** Hausman test
hausman FEgest0 REgest0
hausman FEbirth0 REbirth0

