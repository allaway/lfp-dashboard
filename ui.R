dashboardPage(skin = "purple",
  dashboardHeader(),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Summary View", tabName = "summary", icon = icon("hands-helping")),
      menuItem("Pantry Map", tabName = "map", icon = icon("globe")),
      menuItem("Individual Pantry Data", tabName = "pantries", icon = icon("cube")),
      dateRangeInput("daterange", "Date range:",
                     start = todays_date-lubridate::days(30),
                     end = todays_date)
    )
  ),
  dashboardBody(
    tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
    tabItems(
      tabItem("summary",
              fluidRow(
                box(
                valueBox(all_reports_count, "Total Reports", icon = icon("list"), color = "green"),
                valueBox(recent_reports_count,"Recent Reports", icon = icon("list"), color = "red"),
                valueBox(pantry_count,"Total Pantries", icon = icon("seedling"), color = "blue"),
                width = 12
                )
              ),
              fluidRow(
                box(
                  "Most empty pantries:",
                  reactableOutput("most_empty")
                  ),
                box(
                  "Most full pantries:",
                  reactableOutput("most_full")
                )
              )),
      tabItem("map",
              leafletOutput("map")
      ),
      tabItem("pantries",
              fluidRow(selectizeInput("address", "Address:", choices = pantries, multiple = F)),
              box(plotOutput("pantry_volume")),
              box(reactableOutput("pantry_feedback"))
              )
    )
  )
)