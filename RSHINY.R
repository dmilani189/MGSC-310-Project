library(shiny)
library(leaflet)
library(htmltools)

crashes <- read.csv(here("datasets", "US_Accidents_Dec20_updated.csv"))

crashes_Map <- crashes %>% mutate()

ui <- fluidPage(
  
  navbarPage("Crashes", id="nav",
             
             tabPanel("MAP",
                      leafletOutput("map", width="100%", height= 800),
                      
                      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                    draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                    width = 330, height = "auto",
                                    
                                    h2("Popup Description"),
                                    
                                    selectInput("description", "Description", list("Description", "Street") ),
                                    ),
                      
                      ),
             
             tabPanel("Data explorer",
                      fluidRow(
                       column(3,
                              selectInput("states", "States", c("All states"="", structure(state.abb, names=state.name), "Washington, DC"="DC"), multiple=TRUE)
                       ),
                       column(3,
                              conditionalPanel("input.states",
                                               selectInput("cities", "Cities", c("All cities"=""), multiple=TRUE)
                              )
                       ),
                       column(3,
                              conditionalPanel("input.states",
                                               selectInput("zipcodes", "Zipcodes", c("All zipcodes"=""), multiple=TRUE)
                              )
                       )
                     ),
                     fluidRow(
                       column(1,
                              numericInput("minScore", "Min score", min=0, max=100, value=0)
                       ),
                       column(1,
                              numericInput("maxScore", "Max score", min=0, max=100, value=100)
                              )
                       )
                     )
             
             )
  
)

server <- function(input, output, session) {
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = -93.85, lat = 37.45, zoom = 4)
  })
  
  observe({
    description <- input$description
    }
  )
  
  output$map <- renderLeaflet ({  
    leaflet(data = crashes[1:50,]) %>% addTiles() %>%
      addMarkers(~Start_Lng, ~Start_Lat, popup = ~htmlEscape(description))
  })

}

shinyApp(ui, server)

