* Table 1 — Baseline results: promotion and purge
version 17
set more off, permanently

do "code/helpers/init_study_paths.do"

capture log close _all
local oldpwd "`c(pwd)'"
cd "${result}"
log using "tab_1_stata", replace text

do "${maindir}/code/tables/mk_tab_1.do"

capture log close
cd "`oldpwd'"
