# Portraits of Power (Jiang & Yang, APSR 2026)

Folder-backed replication study for [replicateEverything](https://github.com/replicate-anything/replicateEverything).

## Layout

```
data/raw/          # Downloaded .dta files + shipped CSVs (see data/raw/README.md)
code/steps/        # Pipeline (dataset construction, RF notebook)
code/tables/       # Main-text tables (Stata runners + mk_tab_*.do)
code/figures/      # Main-text figures (R / Python)
code/helpers/      # Shared setup and formatters
outputs/           # All pipeline and display products (see replication.yml steps)
```

Author delivery materials (appendix scripts, codebook) live in the monorepo source folder `10.1017-S0003055426101749/`, not in this study repo.

## Pipeline

1. **construct_analysis_dataset** — merge CPED biographical data → `outputs/construct_analysis_dataset/all_asperson_fulldata.dta`
2. **run_random_forest** (optional for Figure 4) — Python notebook → `outputs/run_random_forest/*.csv`
3. **Tables 1–3** — Stata (parent: `construct_analysis_dataset`)
4. **Figures** — Figure 2 (Python), Figures 4–5 (R)

## Quick start

```r
library(replicateEverything)
options(
  replicateEverything.study_folders_root = "/path/to/replicate_everything",
  replicateEverything.use_sibling_packages = TRUE
)

run_replication("10.1017/S0003055426101749", "tab_1", given = "nothing", format = TRUE)
run_replication("10.1017/S0003055426101749", "fig_2")
```

## Requirements

- Stata **17+** for live Run (scripts use `version 17`). Authors replicated on **Stata 18.0** (macOS). SSC packages: `stata_packages:` in `replication.yml`.
- R 4.5+ (see `replication.yml` dependencies)
- Python 3.10+ (see `python_dependencies` in `replication.yml`)

## Supplementary material

Appendix tables/figures can be added as further `steps:` entries when needed. Source scripts remain in `10.1017-S0003055426101749/` at the monorepo root.
