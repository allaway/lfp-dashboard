filter_dataset <- function(dataset, start_date, end_date, regions){
  
  date_inclusive <- (as.POSIXct(end_date) + lubridate::days(1) - lubridate::seconds(1))
  
  dplyr::filter(dataset, 
                timestamp >= as.POSIXct(start_date) & 
                  timestamp <= date_inclusive &
                region %in% regions)
}

calculate_most_empty <- function(df, n_pantries = 10, dir = c("empty","full")){
  df <- dplyr::select(df, timestamp, address, amount_at_arrival) %>% 
    dplyr::group_by(address) %>% 
    dplyr::summarize(fullness = round(mean(amount_at_arrival),2)) %>% 
    dplyr::arrange(fullness) %>% 
    dplyr::ungroup() %>% 
    purrr::set_names(c("Address", "Fullness (1-5)"))
  
  if(dir == "empty"){
    dplyr::slice_head(df, n={{n_pantries}})
  }else if(dir == "full"){
    dplyr::slice_tail(df, n={{n_pantries}}) %>% 
      dplyr::arrange(dplyr::desc(`Fullness (1-5)`))
      
  }
}

plot_pantry_visits <- function(df){
  
  visit_df <- df %>% 
    dplyr::group_by(address, region) %>% 
    dplyr::tally(name = "visits")
  
   ggplot(visit_df, aes(x = forcats::fct_reorder(address,visits,.desc=T), y = visits, fill = region)) +
     geom_bar(stat = "identity") +
     theme_bw() +
     theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(),
           text = element_text(size = 15)) +
     labs(x = "Location", y = "Number of visits")
       
}

plot_regional_fullness <- function(df){
  
  visit_df <- df %>% 
    dplyr::group_by(address) %>% 
    dplyr::slice_max(timestamp) 
  
  ggplot(visit_df, aes(x =  forcats::fct_reorder(address,amount_at_arrival,.desc=T), y = amount_at_arrival, fill = region)) +
    geom_bar(stat = "identity") +
    theme_bw() +
    theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(),
          text = element_text(size = 15)) +
    labs(x = "Region", y = "Fullness") +
    facet_wrap(~region, scales = "free_x")
  
}


split_most_needed_categories <- function(input_vector){
  input_vector %>% 
    stringr::str_split(pattern = ", ") %>% 
    simplify() %>% 
    table() %>% 
    dplyr::as_data_frame()
}

calculate_most_needed_categories <- function(input_vector){
  split_most_needed_categories(input_vector) %>% 
    dplyr::slice_max(order_by = "n") %>% 
    purrr::pluck(".") %>% 
    stringr::str_c(sep = ", ", collapse = ", ")
}

pantry_summaries <- function(df){
  df %>% 
    dplyr::group_by(address) %>% 
    dplyr::mutate(most_recent_record = max(timestamp)) %>% 
    dplyr::mutate(most_frequent_need_list = calculate_most_needed_categories(need_list)) %>%
    dplyr::select(address, most_recent_record, most_frequent_need_list) %>% 
    dplyr::distinct()
}

filter_pantry <- function(df, address_in){
  dplyr::filter(df, address %in% address_in)
}

plot_pantry_volume <- function(pantry_data, include_amount_at_departure = F){

  if(include_amount_at_departure){
    df <- tidyr::pivot_longer(pantry_data, 
                            cols = c("amount_at_arrival", "amount_at_departure"),
                            names_to = "when",
                            values_to = "amount") %>% 
      dplyr::mutate(timestamp = case_when(when == "amount_at_arrival" ~ timestamp,
                                        when == "amount_at_departure" ~ timestamp + lubridate::hours(1)))
  }else{
    df <- dplyr::rename(pantry_data, amount = amount_at_arrival)
  }
  
  ggplot(data = df, aes(x = timestamp, y = amount)) + 
    geom_line(color="#48639c") +
    geom_area(fill="#48639c", alpha = 1, orientation = "x") +
    geom_point(color="#48639c") +
    ylim(0,5) +
    theme_bw() +
    theme(text = element_text(size = 15)) +
    labs(x = "Date", y = "Fullness (1-5)")
}

pantry_feedback <- function(df, address_in){
  filter_pantry(df, address_in = address_in) %>% 
    dplyr::select(timestamp, feedback) %>% 
    dplyr::distinct()
}
