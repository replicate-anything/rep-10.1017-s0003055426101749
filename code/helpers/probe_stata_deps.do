* Quick check that this study's Stata SSC stack is present (no network install).
* Used by replicateEverything to verify Stata SSC packages before live Run (probe only).
* Exit 0 = satisfied; non-zero = install script should run.

version 17
set more off, permanently

cap which ftools
if _rc exit 10

cap which reghdfe
if _rc exit 11

* help loads the ado without running estimation (bare reghdfe returns r(301) with no data).
cap help reghdfe
if _rc exit 12

cap which eststo
if _rc exit 13

exit 0
