library(targets)
library(tarchetypes)
source("R/functions.R")

tar_option_set(packages = c("tidyverse", "patchwork", "quarto")
               )
list(
  tar_target(prices, 
             get_data(prices,
                      "https://raw.githubusercontent.com/acep-uaf/aetr-web-book-2024/main/data/working/prices/prices.csv")
  ),
  
  tar_target(net_generation_wide, 
             get_data(net_generation_wide,
                      "https://raw.githubusercontent.com/acep-uaf/aetr-web-book-2024/main/data/working/generation/net_generation_wide.csv")
  ),
  
  tar_target(updated_ngw,
             update_ngw(net_generation_wide)
  ),
  
  tar_target(updated_p,
             update_p(prices)
  ),
  
  tar_target(joined_ngw_p,
             join_data(updated_ngw, updated_p)
  ),
  
  tar_target(plot,
             make_plot(joined_ngw_p)
  ),
  
  tar_quarto(quarto_report,
             path = "quarto_report.qmd")
)
