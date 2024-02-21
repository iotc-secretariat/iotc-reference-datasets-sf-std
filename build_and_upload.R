library(httr)
library(iotc.core.utils.misc)

source("./data-raw/load_datasets.R")

TOKEN = Sys.getenv("BITBUCKET_UPLOAD_SF_STD_DATASET_TOKEN")

if(TOKEN == "") {
  stop("No 'BITBUCKET_UPLOAD_SF_STD_DATASET_TOKEN' value found in system environment: cannot upload artifacts!")
} else {
  BITBUCKET_REPO_URL = paste0("https://api.bitbucket.org/2.0/repositories/iotc-ws/iotc-reference-datasets-SF-std/downloads")

  FILES = list.files("./data", pattern = "*.rda")

  if(length(FILES) == 0) {
    stop("No .RDA files found: check that these have been produced and that you are running this script from the right directory (its container folder)")
  }

  for(file in FILES) {
    log_info(paste0("Uploading '", file, "' to BitBucket repository under ", BITBUCKET_REPO_URL))

    upload_response =
      POST(BITBUCKET_REPO_URL,
           body = list(files = upload_file(paste0("./data/", file))),
           add_headers(
             Authorization = paste0("Bearer ", TOKEN)
           )
      )

    log_info(paste0("Upload response: [", status_code(upload_response), "] / ", content(upload_response)))
  }

  unlink(paste0("./out/", list.files("./out", pattern = "*.tar.gz")))

  devtools::document(roclets = c('rd', 'collate', 'namespace'))
  devtools::build(path = "./out")

  FILES = list.files("./out", pattern = "*.tar.gz")

  if(length(FILES) == 0) {
    stop("No .tar.gz file found: check that these have been produced and that you are running this script from the right directory (its container folder)")
  }

  for(file in FILES) {
    log_info(paste0("Uploading '", file, "' to BitBucket repository under ", BITBUCKET_REPO_URL))

    upload_response =
      POST(BITBUCKET_REPO_URL,
           body = list(files = upload_file(paste0("./out/", file))),
           add_headers(
             Authorization = paste0("Bearer ", TOKEN)
           )
      )

    log_info(paste0("Upload response: [", status_code(upload_response), "] / ", content(upload_response)))
  }
}
