* Quick check that this study's Stata SSC stack is present (no network install).
* Used by replicateEverything to verify Stata SSC packages before live Run (probe only).
* Exit 0 = satisfied; non-zero = install script should run.

version 17
set more off, permanently

cap which ftools
if _rc exit 10

cap which reghdfe
if _rc exit 11

* reghdfe 6.x / GitHub stack uses the require package; this study uses SSC 5.x.
cap which require
if !_rc exit 14

* Broken partial 6.x: reghdfe without require fails at runtime with r(9).
cap noi reghdfe
if _rc == 9 exit 12
if _rc != 0 & _rc != 301 exit 15

* help loads the ado without running estimation (bare reghdfe returns r(301) with no data).
cap help reghdfe
if _rc exit 12

cap which eststo
if _rc exit 13

exit 0
