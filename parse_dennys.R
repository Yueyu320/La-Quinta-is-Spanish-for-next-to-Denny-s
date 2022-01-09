library(rvest)
library(tidyverse)
library(stringr)
library(here)

file_path = here::here("data/dennys/")
cat(file_path)
a1= list.files(file_path)

scrape_rest_page = function(url) {
  page = readr::read_file(url) %>% read_html()
  
  address <- page %>%
    html_elements("yxt-comma , .c-address-postal-code , .c-address-state , .c-address-city , .c-address-street-1") %>%
    html_text2() 
  address <- paste(address, collapse = ' ')
  address <- gsub(" ,", ',', address)
  
  phone <- page %>%
    html_elements("#phone-main") %>%
    html_text2()
  
  phone <- phone[[1]]
  
  direction <- page %>%
    html_elements("[class=Core-address]>[class=coordinates]")
  latitude <- direction %>% 
    html_elements("[itemprop=latitude]") %>% 
    html_attr('content') %>% 
    as.numeric()
  longitude <- direction %>% 
    html_elements("[itemprop=longitude]") %>% 
    html_attr('content') %>% 
    as.numeric()
  
  return(tibble(address=address, phone=phone, latitude=latitude, longitude=longitude))
}

info <- tibble()

for (file in a1) {
  info_file <- scrape_rest_page(here::here("data/dennys", file))
  info <- rbind(info, info_file)
}

# save RDS
saveRDS(info, file=here::here("data", "dennys.rds"))
