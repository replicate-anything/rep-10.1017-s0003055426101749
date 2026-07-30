# Portraits of Power (Jiang & Yang, APSR 2026)

Folder-backed replication study for [replicateEverything](https://github.com/replicate-anything/replicateEverything).

## Layout

```
data/raw/          # Materialize cache only (gitignored binaries; see data/raw/README.md)
code/steps/        # Pipeline (dataset construction, RF notebook, Dataverse access)
code/tables/       # Main-text tables (Stata runners + mk_tab_*.do)
code/figures/      # Main-text figures (R / Python)
code/helpers/      # Shared setup and formatters
outputs/           # All pipeline and display products (see replication.yml steps)
```

Author delivery materials (appendix scripts, codebook) live in the monorepo source folder `10.1017-S0003055426101749/`, not in this study repo.

## Pipeline

1. **Declared Dataverse files** — Pattern A for Stata/RF/fig_5 roots:
   `dataverse.files` → materialize into `data/raw/` (gitignored). **Figure 2**
   is Pattern B: `access_fig_2_data` (`engine: dataverse`, file 13684074) →
   baked `outputs/10fold_training_results.csv` (committed for Shiny Live Run).
2. **analysis_data** — merge CPED bios + proper flag → `outputs/analysis_data.dta`
3. **run_random_forest** (optional for Figure 4) — Python notebook → RF CSVs under `outputs/`
4. **Tables 1–3** — Stata from `outputs/analysis_data.dta` (parent: `analysis_data`)
5. **Figures** — Figure 2 (Python; parent `access_fig_2_data`, reads
   `outputs/10fold_training_results.csv`), Figures 4–5 (R). Display uses
   baked `outputs/fig_*.png`. Live Run for fig_2 uses the baked parent CSV
   (`given = "parents"`); no multi-hour retrain (authors ship precomputed scores).

## Quick start

```r
library(replicateEverything)
options(
  replicateEverything.study_folders_root = "/path/to/replicate_everything",
  replicateEverything.use_sibling_packages = TRUE
)

# Fresh clone: materialize Dataverse inputs, then build analysis_data + tab_1
materialize_declared_data("10.1017/S0003055426101749")
run_replication("10.1017/S0003055426101749", "tab_1", given = "nothing", format = TRUE)
run_replication("10.1017/S0003055426101749", "fig_2")
```

Dataverse links for Stata/RF/fig_5 inputs live under `dataverse.files` in `replication.yml`
(fetched automatically on `given = "nothing"` / `materialize_declared_data()`;
deposit `doi:10.7910/DVN/LCZERW`). Figure 2’s CSV is the Pattern B access step.

## Requirements

- Stata **17+** for live Run (scripts use `version 17`). Authors replicated on **Stata 18.0** (macOS). SSC packages: `stata_packages:` in `replication.yml`.
- R 4.5+ (see `replication.yml` dependencies)
- Python 3.10+ (see `python_dependencies` in `replication.yml`)

## Supplementary material

Appendix tables/figures can be added as further `steps:` entries when needed. Source scripts remain in `10.1017-S0003055426101749/` at the monorepo root.
