library(dplyr)
hurricanes <- read.csv("data/hurricanes.csv")
tidy_hurricanes <- hurricanes %>% select(year, name, datetime, latitude, longitude, category, max_wind, min_pressure, hu_diameter)
tidy_hurricanes <- tidy_hurricanes %>% dplyr::filter(name != "UNNAMED")

tidy_hurricanes2 <- tidy_hurricanes %>% tidyr::gather(key = "feature", value = "value", -year, -name, -datetime,-category, -latitude, -longitude)
tidy_hurricanes2 <- tidy_hurricanes2 %>% dplyr::filter(name != "UNNAMED") %>% mutate(datehour = datetime)
tidy_hurricanes2$datehour <- as.POSIXct(tidy_hurricanes2$datehour,format="%Y-%m-%dT%H:%M:%OS")

tidy_hurricanes$datetime <- as.Date(tidy_hurricanes$datetime)
features <- tidy_hurricanes2$feature %>% unique()
features <- data.frame(features)

names <- data.frame(c("Windspeed", "Barometric Pressure", "Hurricane Diameter"))
colnames(names) <- "feature_name"
features <- cbind(features, names)

columns <- c("name", "year")
hurricanes_name <- tidy_hurricanes[columns]
hurricanes_name <- hurricanes_name %>% distinct()
hurricanes_name <- hurricanes_name %>% dplyr::filter(name != "UNNAMED")

df_diameter <- tidy_hurricanes2 %>% 
  filter(feature == "hu_diameter", year == 1950, name == "Able")

a <- sum(is.na(df_diameter$value)/nrow(df_diameter))
print(a)

if (a<0.7){
  ggplot(data = df_diameter, aes(x=datehour, y=value))+geom_line()+geom_point()
  
}




