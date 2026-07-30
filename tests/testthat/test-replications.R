DOI <- "10.1017/S0003055426101749"
FOLDER <- "10.1017S0003055426101749"
STUDY_REPO <- "replicate-anything/rep-10.1017-s0003055426101749"

study_test_context <- function() {
  study_root <- normalizePath(
    testthat::test_path("..", ".."),
    winslash = "/",
    mustWork = FALSE
  )
  registry_root <- normalizePath(
    file.path(study_root, "..", "registry"),
    winslash = "/",
    mustWork = FALSE
  )
  monorepo_root <- normalizePath(
    file.path(study_root, ".."),
    winslash = "/",
    mustWork = FALSE
  )

  local_index <- data.frame(
    folder = FOLDER,
    handle = "portraits-of-power",
    doi = paste0("https://doi.org/", DOI),
    title = "Portraits of Power",
    journal = "APSR",
    year = 2026,
    authors = "Jiang, Yang",
    repo = STUDY_REPO,
    stringsAsFactors = FALSE
  )

  list(
    study_root = study_root,
    registry_root = registry_root,
    monorepo_root = monorepo_root,
    local_index = local_index
  )
}

with_study_options <- function(ctx, expr) {
  withr::with_options(
    list(
      replicateEverything.registry_root = ctx$registry_root,
      replicateEverything.index = ctx$local_index,
      replicateEverything.use_sibling_packages = TRUE,
      replicateEverything.study_folders_root = ctx$monorepo_root
    ),
    expr
  )
}

test_that("replication.yml lists main-text tables and figures", {
  testthat::skip_if_not_installed("replicateEverything")
  ctx <- study_test_context()
  testthat::skip_if_not(dir.exists(ctx$registry_root), "registry checkout missing")

  with_study_options(ctx, {
    reps <- replicateEverything::list_replications(DOI, folder = FOLDER)
    ids <- vapply(reps, function(x) x$id, character(1))
    testthat::expect_true("analysis_data" %in% ids)
    testthat::expect_true(all(c("tab_1", "tab_2", "tab_3") %in% ids))
    testthat::expect_true(all(c("fig_2", "fig_4", "fig_5") %in% ids))
  })
})

test_that("prep step inputs are declared for materialize", {
  ctx <- study_test_context()
  yml <- yaml::read_yaml(file.path(ctx$study_root, "replication.yml"))
  declared <- vapply(yml$dataverse$files, function(x) x$path, character(1))
  testthat::expect_true(
    all(c(
      "data/raw/all_asperson_original.dta",
      "data/raw/CPED_2022.dta",
      "data/raw/proper.dta"
    ) %in% declared)
  )
})

test_that("fig_5 inputs are declared (materialize before live run)", {
  ctx <- study_test_context()
  yml <- yaml::read_yaml(file.path(ctx$study_root, "replication.yml"))
  declared <- vapply(yml$dataverse$files, function(x) x$path, character(1))
  testthat::expect_true(
    all(c(
      "data/raw/attractiveness.csv",
      "data/raw/trustworthiness.csv",
      "data/raw/competence.csv",
      "data/raw/aggressiveness.csv"
    ) %in% declared)
  )
  raw <- file.path(ctx$study_root, "data", "raw")
  if (!file.exists(file.path(raw, "attractiveness.csv"))) {
    testthat::skip("figure CSVs not materialized yet; run materialize_declared_data()")
  }
  testthat::skip_if_not_installed("ggplot2")
  testthat::skip_if_not_installed("dplyr")
  testthat::skip_if_not_installed("readr")
  fig_path <- file.path(ctx$study_root, "code", "figures", "fig_5.R")
  testthat::skip_if_not(file.exists(fig_path), "fig_5.R missing")
  Sys.setenv(REPLICATE_STUDY_ROOT = ctx$study_root)
  on.exit(Sys.unsetenv("REPLICATE_STUDY_ROOT"), add = TRUE)
  source(fig_path, local = TRUE)
  p <- make_fig_5()
  testthat::expect_true(inherits(p, "ggplot"))
})

test_that("fig_2 reads baked outputs sink via access parent", {
  ctx <- study_test_context()
  yml <- yaml::read_yaml(file.path(ctx$study_root, "replication.yml"))
  fig2 <- NULL
  for (step in yml$steps) {
    if (identical(step$id, "fig_2")) {
      fig2 <- step
      break
    }
  }
  testthat::expect_false(is.null(fig2))
  testthat::expect_true("access_fig_2_data" %in% unlist(fig2$parents))
  inputs <- unlist(fig2$inputs)
  if (is.null(inputs) || !length(inputs)) {
    inputs <- as.character(fig2$data)
  }
  testthat::expect_true("outputs/10fold_training_results.csv" %in% inputs)
  testthat::expect_true(file.exists(file.path(ctx$study_root, "code", "figures", "fig_2.py")))
  testthat::expect_true(
    file.exists(file.path(ctx$study_root, "outputs", "10fold_training_results.csv"))
  )
})
