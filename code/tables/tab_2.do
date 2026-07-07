* Table 2 — Influence of facial features by promotion steps
version 17
set more off, permanently

do "code/helpers/init_study_paths.do"

capture log close _all
local oldpwd "`c(pwd)'"
cd "${result}"
log using "tab_2_stata", replace text

do "${maindir}/code/tables/mk_tab_2.do"

capture log close
cd "`oldpwd'"
