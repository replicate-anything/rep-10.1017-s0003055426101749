* Install SSC dependencies for this study (batch / server safe).
* First run needs internet access. Uses reghdfe 5.x from SSC (author replication stack).
* Reghdfe 6.x from GitHub requires the separate "require" package — not used here.

version 17
set more off, permanently
cap set netmsg off

* Drop GitHub 6.x stack when "require" is present; reinstall SSC 5.x.
cap which require
if !_rc {
    di as txt "Reinstalling SSC ftools/reghdfe (replacing reghdfe 6.x / require stack)..."
    cap ado uninstall reghdfe
    cap ado uninstall ftools
}

cap which ftools
if _rc {
    di as txt "Installing ftools from SSC..."
    ssc install ftools, replace
}
cap noisily ftools, compile
cap mata: mata mlib index

cap which reghdfe
if _rc {
    di as txt "Installing reghdfe from SSC..."
    ssc install reghdfe, replace
}

cap which estout
if _rc {
    di as txt "Installing estout from SSC..."
    ssc install estout, replace
}

cap which reghdfe
if _rc {
    di as err "reghdfe is not installed."
    di as err "Run interactively once: ssc install ftools, replace"
    di as err "  ftools, compile"
    di as err "  ssc install reghdfe, replace"
    di as err "  ssc install estout, replace"
    exit 498
}

* reghdfe being *findable* is not enough: a stale ftools makes reghdfe.ado
* fail to load at runtime (r(9), "install from Github ... ftools, compile").
* Force the ado to load here; if it fails, refresh the whole stack from SSC,
* recompile ftools, and discard cached programs so the fresh copies load.
cap reghdfe
if _rc != 0 & _rc != 100 {
    di as txt "reghdfe failed to load (rc=`=_rc'); refreshing ftools + reghdfe stack..."
    ssc install ftools, replace
    cap noisily ftools, compile
    cap mata: mata mlib index
    ssc install reghdfe, replace
    cap discard
    cap reghdfe
    if _rc != 0 & _rc != 100 {
        di as err "reghdfe still fails to load after refresh (rc=`=_rc')."
        di as err "Run interactively once:"
        di as err "  ssc install ftools, replace"
        di as err "  ftools, compile"
        di as err "  ssc install reghdfe, replace"
        di as err "  ssc install estout, replace"
        exit 498
    }
}

cap which eststo
if _rc {
    di as err "eststo not found — run: ssc install estout, replace"
    exit 498
}
