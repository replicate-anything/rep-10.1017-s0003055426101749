# Raw data

CSV exports used by figures are committed here. The two Stata inputs for
`analysis_data` are **not** shipped in git; they are declared under
`dataverse.files` in `replication.yml` and materialized into `data/raw/` by
`replicateEverything::materialize_declared_data()` (also runs automatically
before `run_replication(..., given = "nothing")`).

| Local path | Dataverse (format=original) |
|------------|-----------------------------|
| `all_asperson_original.dta` | [file 13684082](https://dataverse.harvard.edu/api/access/datafile/13684082?format=original) |
| `CPED_2022.dta` | [file 13684095](https://dataverse.harvard.edu/api/access/datafile/13684095?format=original) |

There is no `access_data` step — fetching is yaml location wiring, not a
transform.

| File | Description |
|------|-------------|
| `all_asperson_original.dta` | Person-rank data before CPED merge (fetched) |
| `CPED_2022.dta` | Chinese Political Elite Database (2022) (fetched) |
| `*.csv` | Author CSV exports (committed) |
