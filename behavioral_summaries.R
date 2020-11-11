if (!require(pacman)) install.packages("pacman") 
pacman::p_load(here, tidyverse, R.matlab, fs, data.table)

daw_path <- here("Kool et al. 2016", "data", "daw paradigm")

spaceship_path <- here("Feher da Silva & Hare 2020", "results", "spaceship", "choices")

magic_carpet_path <- here("Feher da Silva & Hare 2020", "results", "magic_carpet", "choices")



daw_data_raw <- readMat(file.path(daw_path, "data.mat"))                            # takes several minutes to run this line

daw_data_plucked <- daw_data_raw %>%
  pluck(1) %>%
  rbindlist() 

daw_col_names = c("s", "stim_1_left", "stim_1_right", "rt_1", "choice1",
                     "stim_2_left", "stim_2_right", "rt_2", "choice2", "win",
                     "state2", "common", "score", "practice", "ps1a1", "ps1a2",
                     "ps2a1", "ps2a2", "trial", "unsure")

daw_data <- daw_data_plucked %>%
  mutate(running_count = row_number() / (nrow(daw_data_plucked) / 20),
         count_ceil = ceiling(running_count),
         soon_col_name = daw_col_names[count_ceil]) %>%
  group_by(count_ceil) %>%
  mutate(across(running_count, ~ rank(.))) %>%
  ungroup() %>%
  select(-count_ceil) %>%
  pivot_wider(names_from = soon_col_name, values_from = V1)

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

