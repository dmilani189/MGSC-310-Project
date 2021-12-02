library(shiny)
library(leaflet)

crashes <- read.csv(here("datasets", "US_Accidents_Dec20_updated.csv"))


ui <- fluidPage(
  leafletOutput("map"),
  p()
)

server <- function(input, output, session) {
  

  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = -93.85, lat = 37.45, zoom = 4)
  })
  
  output$map <- renderLeaflet ({  
    leaflet(data = crashes[1:50,]) %>% addTiles() %>%
      addMarkers(~Start_Lng, ~Start_Lat)
  })

  
    
}

shinyApp(ui, server)


