clear
use "${processed}/analysis_data.dta", clear
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

* Publication table (author: esttab ... using 1_out_main.txt)
esttab m1 m2 m3 m4 m5 m1b m2b m3b m4b m5b using "${result}/tab_1_table.html", ///
    html replace ///
    nonote nobaselevels nocons ///
    b(3) se(3) star(* 0.05 ** 0.01) ///
    order(attractiveness competence trustworthiness aggressiveness female han *edulevel) ///
    label ///
    nomtitles ///
    mgroups("DV: Maximum Rank" "DV: Purge", pattern(1 0 0 0 0 1 0 0 0 0)) ///
    stats(birth birth_city r2 N, labels("Birth year FE" "Birth city FE" "R-squared" "Observations") fmt(0 0 2 0))
