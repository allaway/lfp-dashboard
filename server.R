server <- function(input, output, session) {
  
  w <- Waiter$new(id = c("pantry_volume", "pantry_feedback", "pantry_needs"))
  
  ## overview tab
  filtered_data <- reactive({

    validate(
      need(input$daterange[1]<input$daterange[2], 'The selected start date must be before the selected end date.')
    )
    
    filter_dataset(raw_report_data, 
                   start_date = input$daterange[1], 
                   end_date = input$daterange[2],
                   regions = input$selected_regions)
  })
  
  output$most_empty <- renderReactable({
    df <- calculate_most_empty(filtered_data(), dir = "empty")
    reactable(df)
  })
  
  output$most_full <- renderReactable({
    df <- calculate_most_empty(filtered_data(), dir = "full")
    reactable(df)
  })
  
  ## map tab
  
  pantry_summary_data <- reactive({
    pantry_summaries(filtered_data())
  })
  
  output$map <- renderLeaflet({
    df <- pantry_locations %>% 
      dplyr::inner_join(pantry_summary_data()) %>%  
      dplyr::group_by(address) %>% 
      dplyr::mutate(label = htmltools::HTML(glue::glue("<b>Address:</b> {htmltools::htmlEscape(address)}<br/>
                                      <b> Neighborhood:</b> {htmltools::htmlEscape(neighborhood)}<br/>
                                       <b>Most requested:</b> {htmltools::htmlEscape(most_frequent_need_list)}<br/>
                                       <b>Most recent report:</b> {htmltools::htmlEscape(most_recent_record)}")))
    
    leaflet(df) %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addMarkers(lat = ~lat, lng = ~long, label = ~label)
  })

  
  ## pantry deep-dive tab
  observe({
    updateSelectizeInput(session, "address","Address:", choices = filtered_data()$address)
    })

  
  pantry_data <- reactive({
    filter_pantry(filtered_data(), address = input$address)
  })
  
  output$pantry_volume <- renderPlot({
    w$show()
    plot_pantry_volume(pantry_data(), include_amount_at_departure = T)
  })
  
  output$pantry_feedback <- renderReactable({
    w$show()
    pantry_feedback(filtered_data(), address = input$address) %>% 
      reactable()
  })
  
  output$pantry_needs <- renderPlot({
    w$show()
    pantry_data() %>% 
      purrr::pluck("need_list") %>% 
      split_most_needed_categories() %>% 
      ggplot(aes(x = ., y = n, fill = .)) +
      geom_bar(stat = "identity") + 
      labs(x = "Categories", y = "Number of reports") +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))
  })
  
}