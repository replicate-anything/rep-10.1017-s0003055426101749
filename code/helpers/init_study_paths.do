* Locate study root, set path globals, ensure folders exist, install SSC deps.
* Call at the top of every Stata runner (tables, prep steps).
* Expects the working directory to be inside the study repo (as set by replicateEverything).

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

cap mkdir "${maindir}/data"
cap mkdir "${rawdir}"
cap mkdir "${processed}"
cap mkdir "${maindir}/artifacts"
cap mkdir "${result}"

do "${maindir}/code/helpers/install_stata_deps.do"
