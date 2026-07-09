# Portraits of Power (Jiang & Yang, APSR 2026)

Folder-backed replication study for [replicateEverything](https://github.com/replicate-anything/replicateEverything).

## Layout

```
data/raw/          # Downloaded .dta files + shipped CSVs (see data/raw/README.md)
data/processed/    # Pipeline outputs (e.g. all_asperson_fulldata.dta)
code/steps/        # Prep / pipeline (dataset construction, RF notebook)
code/tables/       # Main-text tables (Stata runners + mk_tab_*.do)
code/figures/      # Main-text figures (R / Python)
code/helpers/      # Shared setup (setup_analysis.do) and formatters (format_stata.R)
artifacts/         # Display outputs for Shiny
```

Author delivery materials (appendix scripts, codebook) live in the monorepo source folder `10.1017-S0003055426101749/`, not in this study repo.

## Pipeline

1. **construct_analysis_dataset** — merge CPED biographical data → `data/processed/all_asperson_fulldata.dta`
2. **run_random_forest** (optional for Figure 4) — Python notebook → `promotion_results.csv`, `purge_results.csv` (CSVs already shipped in `data/raw/`)
3. **Tables 1–3** — Stata (`requires: construct_analysis_dataset`)
4. **Figures** — Figure 2 (Python), Figures 4–5 (R)

## Quick start

```r
library(replicateEverything)
options(
  replicateEverything.study_folders_root = "/path/to/replicate_everything",
  replicateEverything.use_sibling_packages = TRUE
)

run_prep_step("10.1017/S0003055426101749", "construct_analysis_dataset")
run_replication("10.1017/S0003055426101749", "tab_1", language = "stata", format = TRUE)
run_replication("10.1017/S0003055426101749", "fig_2", language = "python")
```

## Requirements

- Stata 17+ with SSC packages (`ftools`, `reghdfe`, `estout`). Maintainers run `code/helpers/install_stata_deps.do` once during onboarding; live Run probes only via `stata_deps_probe`.
- R 4.5+ (see `replication.yml` dependencies)
- Python 3.10+ (see `python_dependencies` in `replication.yml`)

## Supplementary material

Appendix tables/figures can be added as further `replication.yml` entries when needed. Source scripts remain in `10.1017-S0003055426101749/` at the monorepo root.
