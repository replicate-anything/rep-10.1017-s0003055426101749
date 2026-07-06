* Table 3 — Gender-specific marginal effects
version 17
set more off, permanently

local root "`c(pwd)'"
local root : subinstr local root "\" "/", all
while !fileexists("`root'/replication.yml") & "`root'" != "" {
    local parent = substr("`root'", 1, strrpos("`root'", "/") - 1)
    if "`parent'" == "`root'" | !nzchar("`parent'") continue, break
    local root "`parent'"
}
global maindir "`root'"
global rawdir "${maindir}/data/raw"
global processed "${maindir}/data/processed"
if "${REPLICATE_STATA_RESULT}" != "" {
    global result "${REPLICATE_STATA_RESULT}"
}
else {
    global result "${maindir}/artifacts/staging"
}
cap mkdir "${maindir}/artifacts"
cap mkdir "${result}"

capture log close _all
local oldpwd "`c(pwd)'"
cd "${result}"
log using "tab_3_stata", replace text

do "${maindir}/code/tables/mk_tab_3.do"

capture log close
cd "`oldpwd'"
