* Shared data preparation after loading all_asperson_fulldata.dta

encode education, gen(edu)
encode birth_city, gen(bcity)
encode nation, gen(ethnic)
g edulevel = 0
replace edulevel = 1 if education == "大学" | education == "专科" | education == "本科"
replace edulevel = 2 if education == "硕士" | education == "博士"
egen maxrank = max(rank), by(name birthyear)
g toprank = rank == maxrank
g by = substr(birthyear, 1, 4)
destring by, gen(byear)
generate han = (nation == "汉族")
tostring name, replace
merge m:1 name byear birth_prov using "${rawdir}/proper.dta"
g proper = _merge == 3
drop _merge

label var attractiveness "Perceived attractiveness"
label var trustworthiness "Perceived trustworthiness"
label var competence "Perceived competence"
label var aggressiveness "Perceived aggressiveness"

egen std_att = std(attractiveness)
egen std_trust = std(trustworthiness)
egen std_comp = std(competence)
egen std_agg = std(aggressiveness)

global cov female han i.edulevel
