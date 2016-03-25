pkgs <- c(
  "broom", "dplyr", "ggplot2", "jpeg", "jsonlite", 
  "knitr", "microbenchmark", "png", "pryr", "purrr", "readr", "stringr", 
  "tidyr"
)
install.packages(pkgs)

Sys.setenv(LANGUAGE = "en")
devtools::session_info(pkgs)
