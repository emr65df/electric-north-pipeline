get_data <- function(output, url){
  output <- readr::read_csv(url)
}

update_ngw <- function(net_generation_wide){
  updated_ngw <- net_generation_wide %>%
    rowwise() %>%
    mutate(total_gen = sum(dplyr::c_across(c(oil, gas, coal, hydro, wind, solar, storage, other)), na.rm = T)) %>%
    dplyr::ungroup() %>%
    dplyr::group_by(year, aea_energy_region) %>%
    dplyr::summarize(across(c(oil, gas, coal, hydro, wind, solar, storage, other, total_gen),
                            ~ sum(.x, na.rm = T)))
}

update_p <- function(prices){
  updated_p <- prices %>%
    dplyr::group_by(year, aea_energy_region) %>%
    dplyr::summarize(across(c(residential_customers, commercial_customers, other_customers, total_customers),
                            ~ sum(.x, na.rm = T)))
}

join_data <- function(updated_ngw, updated_p){
  joined_ngw_p <- updated_ngw %>%
    dplyr::left_join(., updated_p, by = join_by("year" == "year", "aea_energy_region" == "aea_energy_region"))
}

make_plot <- function(joined_ngw_p){
  p_total_customers <- ggplot(data = joined_ngw_p, aes(x = total_customers)) +
    ggplot2::geom_histogram()
  p_total_generation <- ggplot2::ggplot(data = joined_ngw_p, aes(x = total_gen)) +
    ggplot2::geom_histogram()
  plot <- p_total_customers / p_total_generation
}

