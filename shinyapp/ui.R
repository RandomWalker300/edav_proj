library("shinycustomloader")
library("leaflet")

navbarPage(
  "Hurricanes paths & features analysis",
  tabPanel(
    fluidPage(
      wellPanel(
        h4("What is this?"),
        p("This is a Shiny App that helps the user to assess hurricanes' features evolution across time and location."),
        p("The graph on the left displays the hurricane path in the Atlantic Ocean and its change in category across locations. The category can be assessed by hovering on the path; the date at which the hurricane was at each location can be assessed by clicking on the path. "),
        p("The graph on the right displays the evolution of windspeed, barometric pressure and hurricane diameter across time of a hurricane. If values for the selected variable are missing, the graph will be blank."),
        p("Note: When there are too many missing values for one feature of a hurricane, the graph will show nothing.")
      ),
      div(
        fluidRow(
          column(
            selectInput("selected_year",
              "Select a year",
              choices = NULL
            ),
            width = 3
          ),
          column(
            selectInput("selected_hurricane",
              "Select a hurricane",
              choices = NULL
            ),
            width = 4
          ),
          column(
            selectInput("selected_feature",
              "Select a feature",
              choices = NULL,
              width = "100%"
            ),
            width = 5
          )
        ),
        style = "position:relative;z-index:10000;"
      )
    ),
    hr(),
    fluidRow(
      column(
        withLoader(leafletOutput(outputId = "mymap"), loader = "dnaspin"),
        width = 6
      ),
      column(
        withLoader(plotOutput("feature_graph"), loader = "dnaspin"),
        width = 6
      )
    )
  ),
  collapsible = TRUE
)
