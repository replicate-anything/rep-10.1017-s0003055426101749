use "${processed}/all_asperson_fulldata.dta", clear
do "${maindir}/code/helpers/setup_analysis.do"
save "${result}/original_data.dta", replace

capture drop maxrank2
gen maxrank2 = maxrank
replace maxrank2 = 4 if maxrank == 5

preserve
    sort name birthyear rank
    by name birthyear: gen rank_order = _n
    keep if rank == 1
    gen promoted = (maxrank2 >= 2)
    gen promotion_step = 1
    keep name birthyear promoted promotion_step attractiveness competence trustworthiness aggressiveness female han edulevel byear birth_city bcity
    save "${result}/step1.dta", replace
restore

preserve
    sort name birthyear rank
    by name birthyear: gen rank_order = _n
    keep if rank == 2
    gen promoted = (maxrank2 >= 3)
    gen promotion_step = 2
    keep name birthyear promoted promotion_step attractiveness competence trustworthiness aggressiveness female han edulevel byear birth_city bcity
    save "${result}/step2.dta", replace
restore

preserve
    sort name birthyear rank
    by name birthyear: gen rank_order = _n
    keep if rank == 3
    gen promoted = (maxrank2 >= 4)
    gen promotion_step = 3
    keep name birthyear promoted promotion_step attractiveness competence trustworthiness aggressiveness female han edulevel byear birth_city bcity
    save "${result}/step3.dta", replace
restore

clear
use "${result}/step1.dta"
append using "${result}/step2.dta"
append using "${result}/step3.dta"

fvset base 1 promotion_step

global facial_traits "c.attractiveness c.competence c.trustworthiness c.aggressiveness"
global controls "female han i.edulevel"

reghdfe promoted i.promotion_step##($facial_traits) $controls, a(byear birth_city) cluster(bcity)
estimates store pooled_model
estadd local byearfe "Yes": pooled_model
estadd local bcityfe "Yes": pooled_model
local N_pooled = e(N)
local r2_pooled = e(r2)

lincom female
local b_female : display %6.3f r(estimate)
local se_female : display %6.3f r(se)
local p_female = r(p)

lincom han
local b_han : display %6.3f r(estimate)
local se_han : display %6.3f r(se)
local p_han = r(p)

lincom 1.edulevel
local b_college : display %6.3f r(estimate)
local se_college : display %6.3f r(se)
local p_college = r(p)

lincom 2.edulevel
local b_grad : display %6.3f r(estimate)
local se_grad : display %6.3f r(se)
local p_grad = r(p)

foreach v in female han college grad {
    local star_`v' ""
    if `p_`v'' < 0.01      local star_`v' "***"
    else if `p_`v'' < 0.05  local star_`v' "**"
    else if `p_`v'' < 0.10  local star_`v' "*"
}

eststo clear

estimates restore pooled_model
nlcom (Attractiveness: _b[c.attractiveness]) ///
      (Competence: _b[c.competence]) ///
      (Trustworthiness: _b[c.trustworthiness]) ///
      (Aggressiveness: _b[c.aggressiveness]), post
estadd scalar N = `N_pooled', replace
estadd scalar r2 = `r2_pooled', replace
estadd local byearfe  "Yes"
estadd local bcityfe  "Yes"
estadd local ctrl_female  "`b_female'`star_female' (`se_female')"
estadd local ctrl_han     "`b_han'`star_han' (`se_han')"
estadd local ctrl_college "`b_college'`star_college' (`se_college')"
estadd local ctrl_grad    "`b_grad'`star_grad' (`se_grad')"
eststo step1

estimates restore pooled_model
nlcom (Attractiveness: _b[c.attractiveness] + _b[2.promotion_step#c.attractiveness]) ///
      (Competence: _b[c.competence] + _b[2.promotion_step#c.competence]) ///
      (Trustworthiness: _b[c.trustworthiness] + _b[2.promotion_step#c.trustworthiness]) ///
      (Aggressiveness: _b[c.aggressiveness] + _b[2.promotion_step#c.aggressiveness]), post
estadd scalar N = `N_pooled', replace
estadd scalar r2 = `r2_pooled', replace
estadd local byearfe  "Yes"
estadd local bcityfe  "Yes"
eststo step2

estimates restore pooled_model
nlcom (Attractiveness: _b[c.attractiveness] + _b[3.promotion_step#c.attractiveness]) ///
      (Competence: _b[c.competence] + _b[3.promotion_step#c.competence]) ///
      (Trustworthiness: _b[c.trustworthiness] + _b[3.promotion_step#c.trustworthiness]) ///
      (Aggressiveness: _b[c.aggressiveness] + _b[3.promotion_step#c.aggressiveness]), post
estadd scalar N = `N_pooled', replace
estadd scalar r2 = `r2_pooled', replace
estadd local byearfe  "Yes"
estadd local bcityfe  "Yes"
eststo step3

* Publication table (author: esttab ... using 2_out_interaction_bystep.txt)
esttab step1 step2 step3 using "${result}/tab_2_table.html", ///
    html replace ///
    b(3) se(3) star(+ 0.1 * 0.05 ** 0.01) ///
    mtitles("Step 1: Pref-Deputy" "Step 2: Deputy-Full" "Step 3: Full-National") ///
    title("Influence of Facial Features by Promotion Steps") ///
    stats(ctrl_female ctrl_han ctrl_college ctrl_grad N r2 byearfe bcityfe, ///
        labels("Female" "Han ethnicity" "College degree" "Graduate degree" ///
               "Observations" "R-squared" "Birth Year FE" "Birth City FE") fmt(0 0 0 0 0 3 0 0)) ///
    note("Controls are from the same pooled interaction model and constant across steps.")
