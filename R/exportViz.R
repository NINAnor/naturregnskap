


exportVisnetwork <- function(data){
  path <- "figures/targetsWorkflow.html"
  visNetwork::visSave(tar_visnetwork(),
                      path)
  webshot::webshot(path, zoom = 1, file = "figures/targetsWorkflow.png")
}


