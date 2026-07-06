* Install Stata dependencies used by this study (no-op if already present)
cap which ftools
if _rc ssc install ftools, replace
cap ftools, compile
cap which reghdfe
if _rc ssc install reghdfe, replace
cap which estout
if _rc ssc install estout, replace
