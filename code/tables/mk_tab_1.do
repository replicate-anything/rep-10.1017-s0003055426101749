clear
use "${processed}/all_asperson_fulldata.dta", clear
do "${maindir}/code/helpers/setup_analysis.do"

eststo clear
eststo m1: reghdfe maxrank attractiveness female han i.edulevel if toprank == 1 & proper == 1, a(byear birth_city) cluster(bcity) keepsing
estadd local birth "$\checkmark$"
estadd local birth_city "$\checkmark$"
estadd local cov "$\checkmark$"

eststo m2: reghdfe maxrank competence female han i.edulevel if toprank == 1 & proper == 1, a(byear birth_city) cluster(bcity) keepsing
estadd local birth "$\checkmark$"
estadd local birth_city "$\checkmark$"
estadd local cov "$\checkmark$"

eststo m3: reghdfe maxrank trustworthiness female han i.edulevel if toprank == 1 & proper == 1, a(byear birth_city) cluster(bcity) keepsing
estadd local birth "$\checkmark$"
estadd local birth_city "$\checkmark$"
estadd local cov "$\checkmark$"

eststo m4: reghdfe maxrank aggressiveness female han i.edulevel if toprank == 1 & proper == 1, a(byear birth_city) cluster(bcity) keepsing
estadd local birth "$\checkmark$"
estadd local birth_city "$\checkmark$"
estadd local cov "$\checkmark$"

eststo m5: reghdfe maxrank attractiveness trustworthiness competence aggressiveness female han i.edulevel if toprank == 1 & proper == 1, a(byear birth_city) cluster(bcity) keepsing
estadd local birth "$\checkmark$"
estadd local birth_city "$\checkmark$"
estadd local cov "$\checkmark$"

eststo m1b: reghdfe purge attractiveness female han i.edulevel if toprank == 1 & proper == 1, a(byear birth_city) cluster(bcity) keepsing
estadd local birth "$\checkmark$"
estadd local birth_city "$\checkmark$"
estadd local cov "$\checkmark$"

eststo m2b: reghdfe purge competence female han i.edulevel if toprank == 1 & proper == 1, a(byear birth_city) cluster(bcity) keepsing
estadd local birth "$\checkmark$"
estadd local birth_city "$\checkmark$"
estadd local cov "$\checkmark$"

eststo m3b: reghdfe purge trustworthiness female han i.edulevel if toprank == 1 & proper == 1, a(byear birth_city) cluster(bcity) keepsing
estadd local birth "$\checkmark$"
estadd local birth_city "$\checkmark$"
estadd local cov "$\checkmark$"

eststo m4b: reghdfe purge aggressiveness female han i.edulevel if toprank == 1 & proper == 1, a(byear birth_city) cluster(bcity) keepsing
estadd local birth "$\checkmark$"
estadd local birth_city "$\checkmark$"
estadd local cov "$\checkmark$"

eststo m5b: reghdfe purge attractiveness competence trustworthiness aggressiveness female han i.edulevel if toprank == 1 & proper == 1, a(byear birth_city) cluster(bcity) keepsing
estadd local birth "$\checkmark$"
estadd local birth_city "$\checkmark$"
estadd local cov "$\checkmark$"

esttab m1 m2 m3 m4 m5 m1b m2b m3b m4b m5b, b se order(attractiveness competence trustworthiness aggressiveness female han *edulevel) label replace stats(N r2 F, labels("Number of obs" "R-squared" "F statistic"))
