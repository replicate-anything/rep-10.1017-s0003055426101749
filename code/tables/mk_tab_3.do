use "${processed}/all_asperson_fulldata.dta", clear
do "${maindir}/code/helpers/setup_analysis.do"

global facial_traits "c.attractiveness c.competence c.trustworthiness c.aggressiveness"
global controls "han i.edulevel"

reghdfe maxrank i.female##($facial_traits) $controls if toprank == 1 & proper == 1, a(byear birth_city) cluster(bcity)
estimates store gender_promo
estadd local byearfe "Yes": gender_promo
estadd local bcityfe "Yes": gender_promo
local N_promo = e(N)
local r2_promo = e(r2)

lincom han
local b_han_p : display %6.3f r(estimate)
local se_han_p : display %6.3f r(se)
local p_han_p = r(p)

lincom 1.edulevel
local b_college_p : display %6.3f r(estimate)
local se_college_p : display %6.3f r(se)
local p_college_p = r(p)

lincom 2.edulevel
local b_grad_p : display %6.3f r(estimate)
local se_grad_p : display %6.3f r(se)
local p_grad_p = r(p)

foreach v in han_p college_p grad_p {
    local star_`v' ""
    if `p_`v'' < 0.01      local star_`v' "***"
    else if `p_`v'' < 0.05  local star_`v' "**"
    else if `p_`v'' < 0.10  local star_`v' "*"
}

estimates restore gender_promo
nlcom (Attractiveness: _b[c.attractiveness]) ///
      (Competence: _b[c.competence]) ///
      (Trustworthiness: _b[c.trustworthiness]) ///
      (Aggressiveness: _b[c.aggressiveness]), post
estadd scalar N = `N_promo', replace
estadd scalar r2 = `r2_promo', replace
estadd local byearfe  "Yes"
estadd local bcityfe  "Yes"
estadd local ctrl_han     "`b_han_p'`star_han_p' (`se_han_p')"
estadd local ctrl_college "`b_college_p'`star_college_p' (`se_college_p')"
estadd local ctrl_grad    "`b_grad_p'`star_grad_p' (`se_grad_p')"
eststo promo_male

estimates restore gender_promo
nlcom (Attractiveness: _b[c.attractiveness] + _b[1.female#c.attractiveness]) ///
      (Competence: _b[c.competence] + _b[1.female#c.competence]) ///
      (Trustworthiness: _b[c.trustworthiness] + _b[1.female#c.trustworthiness]) ///
      (Aggressiveness: _b[c.aggressiveness] + _b[1.female#c.aggressiveness]), post
estadd scalar N = `N_promo', replace
estadd scalar r2 = `r2_promo', replace
estadd local byearfe  "Yes"
estadd local bcityfe  "Yes"
eststo promo_female

reghdfe purge i.female##($facial_traits) $controls if toprank == 1 & proper == 1, a(byear birth_city) cluster(bcity)
estimates store gender_purge
estadd local byearfe "Yes": gender_purge
estadd local bcityfe "Yes": gender_purge
local N_purge = e(N)
local r2_purge = e(r2)

lincom han
local b_han_g : display %6.3f r(estimate)
local se_han_g : display %6.3f r(se)
local p_han_g = r(p)

lincom 1.edulevel
local b_college_g : display %6.3f r(estimate)
local se_college_g : display %6.3f r(se)
local p_college_g = r(p)

lincom 2.edulevel
local b_grad_g : display %6.3f r(estimate)
local se_grad_g : display %6.3f r(se)
local p_grad_g = r(p)

foreach v in han_g college_g grad_g {
    local star_`v' ""
    if `p_`v'' < 0.01      local star_`v' "***"
    else if `p_`v'' < 0.05  local star_`v' "**"
    else if `p_`v'' < 0.10  local star_`v' "*"
}

estimates restore gender_purge
nlcom (Attractiveness: _b[c.attractiveness]) ///
      (Competence: _b[c.competence]) ///
      (Trustworthiness: _b[c.trustworthiness]) ///
      (Aggressiveness: _b[c.aggressiveness]), post
estadd scalar N = `N_purge', replace
estadd scalar r2 = `r2_purge', replace
estadd local byearfe  "Yes"
estadd local bcityfe  "Yes"
estadd local ctrl_han     "`b_han_g'`star_han_g' (`se_han_g')"
estadd local ctrl_college "`b_college_g'`star_college_g' (`se_college_g')"
estadd local ctrl_grad    "`b_grad_g'`star_grad_g' (`se_grad_g')"
eststo purge_male

estimates restore gender_purge
nlcom (Attractiveness: _b[c.attractiveness] + _b[1.female#c.attractiveness]) ///
      (Competence: _b[c.competence] + _b[1.female#c.competence]) ///
      (Trustworthiness: _b[c.trustworthiness] + _b[1.female#c.trustworthiness]) ///
      (Aggressiveness: _b[c.aggressiveness] + _b[1.female#c.aggressiveness]), post
estadd scalar N = `N_purge', replace
estadd scalar r2 = `r2_purge', replace
estadd local byearfe  "Yes"
estadd local bcityfe  "Yes"
eststo purge_female

* Publication table (author: esttab ... using 3_out_interaction_bygender.txt)
esttab promo_male promo_female purge_male purge_female using "${result}/tab_3_table.html", ///
    html replace ///
    b(3) se(3) star(+ 0.1 * 0.05 ** 0.01) ///
    mtitles("Promotion: Male" "Promotion: Female" "Purge: Male" "Purge: Female") ///
    title("Influence of Facial Features by Gender") ///
    stats(ctrl_han ctrl_college ctrl_grad N r2 byearfe bcityfe, ///
        labels("Han ethnicity" "College degree" "Graduate degree" ///
               "Observations" "R-squared" "Birth Year FE" "Birth City FE") fmt(0 0 0 0 3 0 0)) ///
    note("Effects calculated from interaction models. Controls constant across gender subgroups within each DV.")
