library(targets)
library(tarchetypes)
library(readr)
library(dplyr)
library(ggplot2)
library(patchwork)
library(quarto)
source("R/functions.R")

list(
  tar_target(net_generation_wide, 
             get_data()
  ),
  
  tar_target(prices, 
             get_data()
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
