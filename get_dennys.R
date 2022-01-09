library(rvest)
library(tidyverse)
library(stringr)
library(here)

url = "http://www2.stat.duke.edu/~cr173/data/dennys/locations.dennys.com/"

States_name <- read_html(url) %>%
  html_elements(".Directory-listLink") %>%
  html_attr('href')

states_url <- paste0(url, States_name)

# get city name
city_url <- c()
for (link in states_url) {
  city_name <- read_html(link) %>%
    html_elements(".Directory-listLinkText") %>%
    html_text()
  city_name <- gsub("[ .']", '-', city_name) %>% toupper()
  city_url <- c(city_url, paste0(paste0(gsub("\\.html", '', link), '/'), city_name))
}

city_url <- gsub("/$", '', city_url)

# get restaurant id
restaurant_url <- c()
for (link in city_url) {
  # cat(link, '\n')
  restaurant <- read_html(paste0(link, ".html")) %>%
    html_elements(".Teaser-titleLink") %>%
    html_attr('href')
  restaurant <- gsub(".*/", '/', restaurant)
  restaurant_url <- c(restaurant_url, paste0(link, restaurant))
}

# save html
dir.create(here::here("data/dennys/"), recursive = TRUE, showWarnings = FALSE)
for (link in restaurant_url) {
  download.file(
    url = link,
    destfile = here::here("data/dennys/", basename(link)),
    quiet = TRUE
  )
}

