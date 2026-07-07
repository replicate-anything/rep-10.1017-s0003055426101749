* Table 3 — Gender-specific marginal effects
version 17
set more off, permanently

do "code/helpers/init_study_paths.do"

capture log close _all
local oldpwd "`c(pwd)'"
cd "${result}"
log using "tab_3_stata", replace text

do "${maindir}/code/tables/mk_tab_3.do"

capture log close
cd "`oldpwd'"
