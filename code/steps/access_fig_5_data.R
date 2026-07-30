# Surgical Dataverse fetches → outputs/*.csv for Figure 5 conjoint inputs.
# Author AMCE estimates (native CSV behind .tab listings). Bake under outputs/
# for Shiny Live Run with given=parents (no outbound Dataverse on server).

make_access_fig_5_data <- function() {
  files <- list(
    list(id = "13684105", path = "outputs/attractiveness.csv"),
    list(id = "13684086", path = "outputs/trustworthiness.csv"),
    list(id = "13684076", path = "outputs/competence.csv"),
    list(id = "13684101", path = "outputs/aggressiveness.csv")
  )
  for (f in files) {
    replicateEverything::fetch_dataverse_file(
      file_id = f$id,
      path = f$path,
      original = TRUE,
      server = "dataverse.harvard.edu"
    )
  }
  invisible(vapply(files, `[[`, character(1), "path"))
}
