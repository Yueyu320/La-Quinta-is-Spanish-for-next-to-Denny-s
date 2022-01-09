library(magrittr)

parsermd::parse_rmd("hw4.Rmd") %>% 
  parsermd::as_tibble() %>% 
  dplyr::filter(type != "rmd_heading") %>% 
  dplyr::slice(-1, -7) %>%
  parsermd::rmd_template(keep_content = TRUE) %>%
  saveRDS(here::here(".github/workflows/template.rds"))
