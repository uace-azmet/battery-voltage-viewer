library(magrittr)

batteryVariables <- 
  tibble::tibble(
    name = c(
      "meta_bat_volt_max", "meta_bat_volt_mean", "meta_bat_volt_min"
    ),
    variable = c(
      "Voltage maximum (V)", "Voltage average (V)", "Voltage minimum (V)"
    )
  )

weatherVariables <- 
  tibble::tibble(
    name = c(
      "relative_humidity_max", 
      "relative_humidity_mean", 
      "relative_humidity_min", 
      "sol_rad_total",
      "temp_air_maxC", 
      "temp_air_meanC", 
      "temp_air_minC"
    ),
    variable = c(
      "Relative Humidity maximum (%)", 
      "Relative Humidity average (%)", 
      "Relative Humidity minimum (%", 
      "Solar Radiation total (MJ/m^2)",
      "Air Temperature maximum (°C)", 
      "Air Temperature average (°C)", 
      "Air Temperature minimum (°C)")
  )

source("~/Library/CloudStorage/OneDrive-UniversityofArizona/Documents/azmet/code/office/battery-voltage-viewer/app/R/fxnAZMetDataELT.R")
azmetStation <- NULL
startDate <- "2024-06-15"
endDate <- "2024-09-16"

inData <- fxnAZMetDataELT(azmetStation = azmetStation, startDate = startDate, endDate = endDate)

azmetStation = "Tucson"
batteryVariable <- "Voltage maximum (V)"
weatherVariable <- "Air Temperature maximum (°C)"

dataOtherStations <- inData %>% 
  dplyr::filter(meta_station_name != azmetStation) %>%
  dplyr::filter(!is.na(weatherVariable)) %>%
  dplyr::filter(!is.na(batteryVariable))

dataSelectedStation <- inData %>% 
  dplyr::filter(meta_station_name == azmetStation) %>%
  dplyr::filter(!is.na(weatherVariable)) %>%
  dplyr::filter(!is.na(batteryVariable)) %>%
  dplyr::select(tidyselect::all_of(c("date_doy", batteryVariable)))

date_doy <- dataSelectedStation["date_doy"]

batteryVariableTimeSeries <- 
  plotly::plot_ly( # lines for `dataOtherStations`
    data = dataSelectedStation,
    x = date_doy,
    y = ~.data[[batteryVariable]], 
    type = 'scatter', 
    mode = 'lines'
  ) 

batteryVariableTimeSeries

weatherVariableTimeSeries <- 
  plotly::plot_ly( # lines for `dataOtherStations`
    data = dataSelectedStation,
    x = ~.data[[batteryVariable]],
    y = ~.data[[weatherVariable]], 
    type = 'scatter', 
    mode = 'lines'
  )

weatherVariableTimeSeries

fig <- subplot(
  batteryVariableTimeSeries, weatherVariableTimeSeries, nrows = 2, shareX = FALSE
)

fig



