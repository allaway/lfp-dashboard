library(tidygeocoder)

get_latlong <- function(google_sheet_id, colname, query_city = NULL, query_county = "King", query_state = "Washington"){
  
  googlesheets4::gs4_deauth()
  
  df <- googlesheets4::read_sheet(google_sheet_id) %>% 
    dplyr::select({{colname}})

  pbapply::pblapply(df[[colname]], function(x){
    tidygeocoder::geo(street = x, city = query_city, state = query_state, county = "King", method = "osm")
  }) %>% dplyr::bind_rows()
}
