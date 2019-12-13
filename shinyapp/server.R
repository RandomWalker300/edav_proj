library("tidyverse")
library("WDI")
library("leaflet")
library("sf")
library("rnaturalearthdata")
library("magick")
library("rsvg")

source("DataProcessing.R", local = TRUE)

function(input, output, session) {
  updateSelectInput(session,
    "selected_year",
    choices = unique(hurricanes_name$year)
  )

  observeEvent(input$selected_year, {
    hurricanes_in_year <- hurricanes_name %>%
      filter(year == input$selected_year)



    updateSelectInput(session,
      "selected_hurricane",
      choices = hurricanes_in_year$name
    )
  })

  
  updateSelectInput(session,
    "selected_feature",
    choices = names$feature_name
  )
  
  output$feature_graph <- renderPlot({
    if (input$selected_feature == "Barometric Pressure"){
      df_pressure <- tidy_hurricanes2 %>% 
        filter(feature == "min_pressure", year == input$selected_year, name == input$selected_hurricane) %>% drop_na() 
      
      a <- sum(is.na(df_pressure$value)/nrow(df_pressure ))
      
      if (a < 0.7){
        ggplot(data = df_pressure, aes(x=datehour, y=value))+
          geom_line()+
          geom_point() + 
          ggtitle("Pressure Measures of Hurricane") + 
          xlab("Time") + ylab("Pressure (millibars)") +
          theme(plot.title = element_text(hjust =0.5))
      }else{
        
      }
      
      
    } else if (input$selected_feature == "Windspeed"){
      df_wind <- tidy_hurricanes2 %>% 
        filter(feature == "max_wind", year == input$selected_year, name == input$selected_hurricane) %>% drop_na()
      
      a <- sum(is.na(df_wind$value)/nrow(df_wind ))
      
      if (a < 0.7){
        ggplot(data = df_wind, aes(x=datehour, y=value))+geom_line()+geom_point()+ 
          ggtitle("Windspeed Measures of Hurricane")+ 
          xlab("Time") + ylab("Windspeed (knots)")+
          theme(plot.title = element_text(hjust =0.5))
      }else{
        
      }
      
    } else if (input$selected_feature == "Hurricane Diameter"){
      df_diameter <- tidy_hurricanes2 %>%
        filter(feature == "hu_diameter", year == input$selected_year, name == input$selected_hurricane)
      
      a <- sum(is.na(df_diameter$value)/nrow(df_diameter))
      
      if (a < 0.7){
      ggplot(data = df_diameter, aes(x=datehour, y=value))+geom_line()+geom_point()+ 
          ggtitle("Diameter Measures of Hurricane")+ 
          xlab("Time") + ylab("Diameter (miles)")+
          theme(plot.title = element_text(hjust =0.5))
      }else{
          
          
      }
    }
    
  })


    pal <- colorNumeric(
      palette = c('green', 'yellow', 'orange', 'dark orange', 'orange red', 'red'),
      domain = tidy_hurricanes$category)
    
    output$mymap <- renderLeaflet({
      leaflet(tidy_hurricanes) %>% 
        setView(lng = -70, lat = 30, zoom = 3)  %>% #setting the view over ~ center of North America
        addTiles() %>% 
        addCircles(data = tidy_hurricanes %>% filter(year == input$selected_year, name == input$selected_hurricane), lat = ~ latitude, lng = ~ longitude, weight = 1, radius = ~sqrt(max_wind)*7000, popup = ~as.character(paste0("Date:", sep = " ", format(datetime, format="%B %dth"))), label = ~as.character(paste0("Category: ", sep = " ", category)), color = ~pal(category), fillOpacity = 0.5)
    })
}
