if (!require(pacman)) install.packages("pacman") 
pacman::p_load(here, tidyverse, R.matlab, fs, data.table)

daw_path <- here("Kool et al. 2016", "data", "daw paradigm")

spaceship_path <- here("Feher da Silva & Hare 2020", "results", "spaceship", "choices")

magic_carpet_path <- here("Feher da Silva & Hare 2020", "results", "magic_carpet", "choices")



#daw_data <- readMat(file.path(daw_path, "data.mat"))


spaceship_data <- spaceship_path %>%
  dir_ls(regexp = "[[:digit:]].csv") %>%
  map_dfr(function(x){
    participant = str_extract(x, "((?<=choices\\/).+).*(.+?(?=\\.))")
    fread(x) %>%
      mutate(participant)
  })
  
magic_carpet_data <- magic_carpet_path %>%
  dir_ls(regexp = "game.csv") %>%
  map_dfr(function(x){
    participant = str_extract(x, "((?<=choices\\/).+).*(.+?(?=_game\\.))")
    fread(x) %>%
      mutate(participant)
  })

