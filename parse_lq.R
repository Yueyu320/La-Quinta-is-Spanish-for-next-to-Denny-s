library(rvest)
library(tidyverse)
library(stringr)
library(here)

file_path <- here::here("data/lq/")
lq <- list.files(file_path)

hotel_info <- tibble()

scrape_hotel_page = function(url) {
  
  page = readr::read_file(url) %>% read_html()
  
  name <- page %>%
    html_element(".headline-c .highlight-wrapper") %>%
    html_text2()

  address <- page %>%
    html_element(".property-address") %>%
    html_text2()
    
  phone <- page %>%
    html_element(".highlight-wrapper a") %>%
    html_text2()
    
  latitude <- page %>% 
    html_element(".address-info a") %>% 
    html_attr("href") %>% 
    str_match("daddr=\\s*(.*?)\\s*,") %>% 
    .[2] %>% 
    as.numeric()
    
  longitude <- page %>%
    html_element(".address-info a") %>%
    html_attr("href") %>%
    str_match(",\\s*(.*?)\\s*&q") %>%
    .[2] %>%
    as.numeric()
    
  hotel_info <- tibble(Name = name, Address = address, Phone = phone,
                       Latitude = latitude, Longitude = longitude)
  return(hotel_info)
}

for (file in lq) {
  info_file <- scrape_hotel_page(paste0(file_path, file))
  hotel_info <- rbind(hotel_info, info_file)
}

# save RDS
saveRDS(hotel_info, file=here::here("data", "lq.rds"))