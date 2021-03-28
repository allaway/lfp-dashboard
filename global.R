library(shinydashboard)
library(googlesheets4)
library(dplyr)
library(purrr)
library(ggplot2)
library(reactable)
library(plotly)
library(leaflet)
source("helpers.R")

##palette:
#48639c 
#4c4c9d
#712f79
#976391
#f7996e

googlesheets4::gs4_deauth()

todays_date <- as.POSIXct(Sys.Date())

raw_report_data <- googlesheets4::read_sheet("1EjC43kxctXh82w3DD0XPIbBvmYglxTdpXNppHMm90yk") %>% 
  purrr::set_names(c('address', "timestamp", "previous_record_date", 'amount_at_arrival', 
                     'amount_at_departure', 'need_list', "feedback")) %>% 
  dplyr::mutate(timestamp = dplyr::case_when(is.na(previous_record_date) ~ timestamp,
                                      !is.na(previous_record_date) ~ previous_record_date))

recent_reports_count <- dplyr::filter(raw_report_data, todays_date - lubridate::days(7) < timestamp) %>% nrow()
all_reports_count <- raw_report_data %>% nrow()
pantries <- raw_report_data$address %>% unique()
pantry_count <- pantries %>% length()

pantry_metadata <- googlesheets4::read_sheet("1iXcz098Cc_RGejIq97JUK0Rj1oDw2QolF5_bNRlG4e4") 

pantry_locations <- pantry_metadata %>% 
  select(address, neighborhood, region, lat, long) %>% 
  filter(!is.na(lat) & !is.na(long))
  

