# Surgical Dataverse fetch → outputs/10fold_training_results.csv
# File id 13684074 (native CSV behind 10fold_training_results.tab).
# Author ML training product — regenerating is expensive; bake under outputs/
# for Shiny Live Run with given=parents (no outbound Dataverse on server).

make_access_fig_2_data <- function() {
  replicateEverything::fetch_dataverse_file(
    file_id = "13684074",
    path = "outputs/10fold_training_results.csv",
    original = TRUE,
    server = "dataverse.harvard.edu"
  )
}
