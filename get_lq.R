library(rvest)
library(tidyverse)
library(stringr)
library(here)

#orginal urls and the genral url for lq
url = "http://www2.stat.duke.edu/~cr173/data/lq/www.wyndhamhotels.com/laquinta/locations.html"
url2 = "http://www2.stat.duke.edu/~cr173/data/lq/www.wyndhamhotels.com/laquinta/"

#save the url for individual hotel 
hotel_urls <- read_html(url) %>%
  html_elements("[class=property]>a:nth-child(1)") %>%
  html_attr("href") %>%
  paste0(url2, .)

#use state names to match later
state_name <- tolower(state.name)
state_name <- gsub(" ", '-', state_name)

#filter out all hotels which are not in the U.S.
hotel_urls <- tibble(hotel_urls) %>% 
  filter(str_detect(hotel_urls, paste(state_name, collapse = "|"))) %>%
  pull(hotel_urls)

# save html
dir.create(here::here("data/lq/"), recursive = TRUE, showWarnings = FALSE)

#download all hotel urls
for(hotel_url in hotel_urls) {
  save_name <- str_extract(hotel_url,"(?<=laquinta/).+(?=/overview.html)")
  download.file(
    url = hotel_url,
    destfile = here::here("data/lq", basename(save_name)),
    quiet = TRUE
  )
}
