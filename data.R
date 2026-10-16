library(jsonlite)

url <- paste0(
  "https://api.open-meteo.com/v1/forecast",
  "?latitude=27.3233&longitude=-82.5311",
  "&hourly=temperature_2m%2Crelative_humidity_2m%2Cprecipitation%2Cwind_speed_10m",
  "&past_days=7&forecast_days=0&timezone=America%2FNew_York"
)

weather_data <- fromJSON(url)
sarasota_hourly <- as.data.frame(weather_data$hourly)
names(sarasota_hourly)[names(sarasota_hourly) == "time"] <- "datetime"
sarasota_hourly$datetime <- as.POSIXct(
  sarasota_hourly$datetime,
  format = "%Y-%m-%dT%H:%M",
  tz = "America/New_York"
)

write.csv(sarasota_hourly, "sarasota_hourly_weather.csv", row.names = FALSE)
