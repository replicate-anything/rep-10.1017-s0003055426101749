* Construct main analysis dataset (merge CPED biographical variables)
* Output: outputs/analysis_data.dta

version 17
set more off, permanently

do "code/helpers/init_study_paths.do"

clear all
use "${rawdir}/all_asperson_original.dta", clear
gen _sortorder = _n
merge 1:1 name rank using "${rawdir}/CPED_2022.dta"
tab _merge
assert _merge == 3
drop _merge
sort _sortorder
drop _sortorder

order name rank birthyear begin female education edu_year nation ///
      birth_prov birth_city purge ///
      fwhr mouth_width nose_width nose_length nwhr ///
      eyebrow_position foreheadr lip_thickness eyesize ///
      chin_length chin_width flength ///
      latitude longitude ///
      attractiveness competence aggressiveness trustworthiness ///
      exists_in_psub ///
      smile_mean facequality_mean blurness_mean glass_mean ///
      attractiveness_median competence_median aggressiveness_median ///
      trustworthiness_median facequality_median blurness_median ///
      similarity_hjt_all similarity_hjt_hs ///
      similarity_xjp_all similarity_xjp_hs ///
      similarity_jzm_all similarity_jzm_hs

save "${processed}/analysis_data.dta", replace
