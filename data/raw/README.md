# Raw data

Replication scripts expect Stata `.dta` files and CSV exports in this folder (see `10.1017-S0003055426101749/README.txt` and `Codebook.pdf` in the monorepo source delivery).

| File | Description |
|------|-------------|
| `all_asperson_original.dta` | Person-rank data before CPED merge |
| `CPED_2022.dta` | Chinese Political Elite Database (2022) |
| `proper.dta` | Auxiliary matching data |
| `conjoint.dta` | Conjoint experiment (Figure 5 / Table D.1) |
| `validation_rep.dta` | Conjoint validation sample |

CSV files from the authors' archive (conjoint AMCEs, RF results, 10-fold CV output) are included. Large `.dta` files are gitignored; copy them from the journal dataverse or the delivery folder into `data/raw/` before running the Stata pipeline.
