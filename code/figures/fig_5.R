# Figure 5 — Conjoint experiment AMCE estimates
# Study repo: rep-10.1017-s0003055426101749

make_fig_5 <- function(data = NULL) {
  root <- Sys.getenv("REPLICATE_STUDY_ROOT", unset = ".")
  if (!nzchar(root)) root <- "."
  raw <- file.path(root, "data", "raw")

  cov <- c(
    "Face with higher rating",
    "Birth year\n(baseline = 1973)", " -  1975", " -  1977", " -  1979",
    "Education\n(baseline = bachelor's degree)", " -  Master's degree", " -  Ph.D degree",
    "Work experience\n(baseline = SOE)", " -  Grassroots government",
    " -  Central government", " -  Personal aide to senior leader"
  )

  dx <- readr::read_csv(file.path(raw, "attractiveness.csv"), show_col_types = FALSE) |>
    dplyr::bind_rows(readr::read_csv(file.path(raw, "trustworthiness.csv"), show_col_types = FALSE)) |>
    dplyr::bind_rows(readr::read_csv(file.path(raw, "competence.csv"), show_col_types = FALSE)) |>
    dplyr::bind_rows(readr::read_csv(file.path(raw, "aggressiveness.csv"), show_col_types = FALSE)) |>
    dplyr::filter(!is.na(beta)) |>
    dplyr::mutate(beta = dplyr::if_else(beta == 0, NA_real_, beta)) |>
    dplyr::mutate(
      dim = rep(
        c(
          "Perceived Attractiveness", "Perceived Trustworthiness",
          "Perceived Competence", "Perceived Aggressiveness"
        ),
        each = 12
      ),
      dim = factor(
        dim,
        levels = c(
          "Perceived Attractiveness", "Perceived Trustworthiness",
          "Perceived Competence", "Perceived Aggressiveness"
        )
      ),
      type = factor(rep(cov, times = 4), levels = rev(cov))
    )

  ggplot2::ggplot(dx, ggplot2::aes(y = type, x = beta)) +
    ggplot2::geom_pointrange(ggplot2::aes(xmin = lb95, xmax = ub95)) +
    ggplot2::geom_vline(xintercept = 0, linetype = "dashed", color = "red") +
    ggplot2::facet_wrap(ggplot2::vars(dim), ncol = 4) +
    ggplot2::theme(axis.text.y = ggplot2::element_text(size = 12)) +
    ggplot2::labs(
      x = "AMCE on the Probability of Being Selected for Promotion",
      y = NULL,
      title = "Conjoint Experiment Results on Individual Selection Preferences"
    ) +
    ggplot2::scale_x_continuous(breaks = seq(-0.5, 0.75, 0.25), limits = c(-0.55, 0.8)) +
    ggplot2::theme_bw() +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5, face = "bold"))
}

format_fig_5 <- function(object) {
  object
}

if (sys.nframe() == 0L) {
  make_fig_5()
}
