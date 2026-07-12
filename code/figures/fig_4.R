# Figure 4 — Random forest feature importance
# Study repo: rep-10.1017-s0003055426101749

make_fig_4 <- function(data = NULL) {
  root <- Sys.getenv("REPLICATE_STUDY_ROOT", unset = ".")
  if (!nzchar(root)) root <- "."
  out_dir <- file.path(root, "outputs")

  dpr <- readr::read_csv(file.path(out_dir, "run_random_forest_promotion.csv"), show_col_types = FALSE) |>
    dplyr::mutate(lab = "Promotion")
  dpu <- readr::read_csv(file.path(out_dir, "run_random_forest_purge.csv"), show_col_types = FALSE) |>
    dplyr::mutate(lab = "Purge")

  dc <- dplyr::bind_rows(dpr, dpu) |>
    dplyr::mutate(
      Feature = dplyr::recode(
        Feature,
        aggressiveness = "Perceived aggressiveness",
        attractiveness = "Perceived attractiveness",
        birthyear = "Birth year",
        connections = "Political connection",
        edu = "Education level",
        eth_han = "Han ethnicity",
        female = "Female",
        weighted_avg_gdp_growth_rate = "GDP growth rate",
        weighted_avg_fiscal_growth_rate = "Fiscal revenue growth rate",
        latitude = "Hometown latitude",
        longitude = "Hometown longitude",
        competence = "Perceived competence",
        trustworthiness = "Perceived trustworthiness"
      )
    ) |>
    dplyr::mutate(Feature = tidytext::reorder_within(Feature, Importance, lab))

  ggplot2::ggplot(dc, ggplot2::aes(x = tidytext::reorder_within(Feature, Importance, lab), y = Importance)) +
    ggplot2::geom_bar(stat = "identity", fill = "grey40") +
    ggplot2::coord_flip() +
    tidytext::scale_x_reordered() +
    ggplot2::facet_wrap(ggplot2::vars(lab), scales = "free_y") +
    ggplot2::labs(x = NULL, y = NULL, title = "Feature Importance in Promotion vs. Purge") +
    ggplot2::theme_bw() +
    ggplot2::theme(
      legend.position = "bottom",
      axis.text = ggplot2::element_text(size = 12),
      plot.title = ggplot2::element_text(hjust = 0.5, face = "bold")
    ) +
    ggplot2::scale_y_continuous(limits = c(0, 0.16), breaks = seq(0, 0.16, 0.03))
}

format_fig_4 <- function(object) {
  object
}

if (sys.nframe() == 0L) {
  make_fig_4()
}
