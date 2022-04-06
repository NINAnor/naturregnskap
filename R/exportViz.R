


exportVisnetwork <- function(data){
  path <- "figures/targetsWorkflow.html"
  visNetwork::visSave(tar_visnetwork(),
                      path)
  webshot(path, zoom = 2, file = "figures/targetsWorkflow.png")
  
}


