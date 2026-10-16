library(ggplot2)

sarasota_weather <- read.csv("sarasota_hourly_weather.csv")
sarasota_weather$datetime <- as.POSIXct(
  paste(sarasota_weather$datetime, ifelse(nchar(sarasota_weather$datetime) == 10, "00:00:00", "")),
  format = "%Y-%m-%d %H:%M:%S",
  tz = "America/New_York"
)

weather_long <- rbind(
  data.frame(datetime = sarasota_weather$datetime, variable = "Temperature (°C)", value = sarasota_weather$temperature_2m),
  data.frame(datetime = sarasota_weather$datetime, variable = "Humidity (%)", value = sarasota_weather$relative_humidity_2m),
  data.frame(datetime = sarasota_weather$datetime, variable = "Precipitation (mm)", value = sarasota_weather$precipitation),
  data.frame(datetime = sarasota_weather$datetime, variable = "Wind speed (km/h)", value = sarasota_weather$wind_speed_10m)
)

weather_long$variable <- factor(
  weather_long$variable,
  levels = c("Temperature (°C)", "Humidity (%)", "Precipitation (mm)", "Wind speed (km/h)")
)

weather_plot <- ggplot(weather_long, aes(x = datetime, y = value, color = variable, fill = variable)) +
  geom_area(alpha = 0.18, show.legend = FALSE) +
  geom_line(linewidth = 0.9, show.legend = FALSE) +
  facet_wrap(vars(variable), scales = "free_y", ncol = 2) +
  scale_color_manual(values = c(
    "Temperature (°C)" = "#FB7185",
    "Humidity (%)" = "#38BDF8",
    "Precipitation (mm)" = "#A78BFA",
    "Wind speed (km/h)" = "#34D399"
  )) +
  scale_fill_manual(values = c(
    "Temperature (°C)" = "#FB7185",
    "Humidity (%)" = "#38BDF8",
    "Precipitation (mm)" = "#A78BFA",
    "Wind speed (km/h)" = "#34D399"
  )) +
  scale_x_datetime(date_breaks = "1 day", date_labels = "%a\n%b %d") +
  labs(
    title = "A week in Sarasota",
    subtitle = "Hourly weather at a glance",
    x = NULL,
    y = NULL,
    caption = "Source: Open-Meteo • Local time (America/New_York)"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.background = element_rect(fill = "#0B1220", color = NA),
    panel.background = element_rect(fill = "#111C2E", color = NA),
    panel.grid.major = element_line(color = "#26354A", linewidth = 0.35),
    panel.grid.minor = element_blank(),
    strip.text = element_text(color = "#E2E8F0", face = "bold", size = 11),
    strip.background = element_rect(fill = "#1E293B", color = NA),
    axis.text = element_text(color = "#A7B4C8"),
    plot.title = element_text(color = "#F8FAFC", face = "bold", size = 24),
    plot.subtitle = element_text(color = "#CBD5E1", size = 13),
    plot.caption = element_text(color = "#94A3B8"),
    panel.spacing = grid::unit(1.2, "lines"),
    plot.margin = margin(18, 22, 14, 22)
  )

ggsave("sarasota-weather.png", plot = weather_plot, width = 12, height = 8, dpi = 300, bg = "#0B1220")
