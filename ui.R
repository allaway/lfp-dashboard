dashboardPage(skin = "purple",
  dashboardHeader(),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Summary View", tabName = "summary", icon = icon("hands-helping")),
      menuItem("Pantry Map", tabName = "map", icon = icon("globe")),
      menuItem("Individual Pantry Data", tabName = "pantries", icon = icon("cube")),
      dateRangeInput("daterange", "Date range:",
                     start = todays_date-lubridate::days(60),
                     end = todays_date),
      shinyWidgets::prettyCheckboxGroup("selected_regions", "Filter by region:", 
                                   choices = sort(regions), selected = regions, bigger = T)
    )
  ),
  dashboardBody(
    tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
    waiter::use_waiter(),
    tabItems(
      tabItem("summary",
              fluidRow(
                box(title = "Summary Metrics",
                valueBox(all_reports_count, "Total Reports", icon = icon("list"), color = "green"),
                valueBox(recent_reports_count,"Recent Reports (30d)", icon = icon("list"), color = "red"),
                valueBox(pantry_count,"Total Pantries", icon = icon("seedling"), color = "blue"),
                width = 12
                )
              ),
              fluidRow(
                box(title = "Most empty pantries:",
                  reactableOutput("most_empty")
                  ),
                box(title = "Most full pantries:",
                  reactableOutput("most_full")
                )
              )),
      tabItem("map",
              leafletOutput("map")
      ),
      tabItem("pantries",
              fluidRow(
              box(title = "Select a pantry",
                selectizeInput("address", "Address:", choices = pantries, multiple = F), width = 12
                ),
              box(title = "Pantry fullness over time",
                plotOutput("pantry_volume"), width = 12
                ),
              box(title = "Pantry comments",
                reactableOutput("pantry_feedback"), width = 6
                ),
              box(title = "Most needed items",
                plotOutput("pantry_needs"), width = 6
                )
              ))
    )
  )
)