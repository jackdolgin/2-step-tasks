if (!require(pacman)) install.packages("pacman")
pacman::p_load(here, tidyverse, R.matlab, fs, data.table)

daw_path <- here("Kool et al. 2016", "data", "daw paradigm")

spaceship_path <- here("Feher da Silva & Hare 2020", "results", "spaceship", "choices")

magic_carpet_path <- here("Feher da Silva & Hare 2020", "results", "magic_carpet", "choices")



daw_data <- readMat(file.path(daw_path, "data.mat"))


pull_da_silva_data <- function(df){
  df %>%
    dir_ls(regexp = "[[:digit:]].csv") %>%
    map_dfr(function(x){
      participant = str_extract(x, "((?<=choices\\/).+).*(.+?(?=\\.))")
      fread(x) %>%
        mutate(participant)
    })
}

spaceship_data <- pull_da_silva_data(spaceship_path)
magic_carpet_data <- pull_da_silva_data(magic_carpet_path)
