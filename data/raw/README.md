# Raw data (materialize cache — not committed)

Nothing under `data/raw/` is shipped in git except this README.
Inputs are declared under `dataverse.files` in `replication.yml` and fetched by
`replicateEverything::materialize_declared_data()` (also runs automatically
before `run_replication(..., given = "nothing")`).

Stata `${rawdir}` points here after materialize; `analysis_data` writes
`outputs/analysis_data.dta`. **Figure 2** does **not** use this cache: the
author-precomputed 10-fold scores are Pattern B
(`access_fig_2_data` → `outputs/10fold_training_results.csv`, baked in git).

| Local path | Role | Dataverse (format=original) |
|------------|------|-----------------------------|
| `all_asperson_original.dta` | `analysis_data` input | [13684082](https://dataverse.harvard.edu/api/access/datafile/13684082?format=original) |
| `CPED_2022.dta` | `analysis_data` input | [13684095](https://dataverse.harvard.edu/api/access/datafile/13684095?format=original) |
| `proper.dta` | `analysis_data` input (proper-sample flag) | [13684089](https://dataverse.harvard.edu/api/access/datafile/13684089?format=original) |
| `attractiveness.csv` etc. | Figure 5 | see `replication.yml` |
| `all_asperson_gdpconn_undemean.csv` | RF prep | [13684097](https://dataverse.harvard.edu/api/access/datafile/13684097?format=original) |

Deposit DOI: `doi:10.7910/DVN/LCZERW`. Figure 2 CSV: file
[13684074](https://dataverse.harvard.edu/api/access/datafile/13684074?format=original)
→ `outputs/10fold_training_results.csv`.
