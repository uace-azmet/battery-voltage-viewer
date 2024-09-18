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

source("~/Library/CloudStorage/OneDrive-UniversityofArizona/Documents/azmet/code/battery-voltage-viewer/app/R/fxnAZMetDataELT.R")
azmetStation <- NULL
startDate <- "2024-06-15"
endDate <- "2024-09-16"

inData <- fxnAZMetDataELT(azmetStation = azmetStation, startDate = startDate, endDate = endDate)



fig <- plotly::plot_ly(
  data = datasets::iris,
  x = ~Petal.Length,
  y = ~Petal.Width,
  type = "scatter",
  mode = "markers",
  hoverinfo = "text",
  text = ~paste(
    "</br> Species: ", Species,
    "</br> Petal Length: ", Petal.Length,
    "</br> Petal Width: ", Petal.Width
  )
)
fig



azmetStation = "Tucson"

inData <- inData %>%
  dplyr::mutate(stationCategory = dplyr::if_else(
    meta_station_name == azmetStation, azmetStation, "other stations"
  ) %>%
    factor(levels = c(azmetStation, "other stations"))
  ) #%>%
#dplyr::select(
#  datetime, 
#  meta_station_name, 
#  stationCategory, 
#  batteryVariable, 
#  weatherVariable
#)

trace1 <- inData %>% dplyr::filter(meta_station_name != azmetStation)
trace2 <- inData %>% dplyr::filter(meta_station_name == azmetStation)

batteryVariable <- "Voltage maximum (V)"
weatherVariable <- "Air Temperature maximum (°C)"

# https://plotly-r.com/ 
# https://plotly.com/r/reference/ 
# https://plotly.github.io/schema-viewer/ -----
scatterplot <- 
  plotly::plot_ly(
    data = trace1,
    x = ~.data[[weatherVariable]],
    y = ~.data[[batteryVariable]],
    color = ~stationCategory,
    type = "scatter",
    mode = "markers",
    marker = list(
      size = 8,
      color = "rgba(201, 201, 201, 1.0)",
      line = list(
        color = "rgba(152, 152, 152, 1.0)",
        width = 1
      )
    ),
    #name = ~.data[[meta_station_name]],
    hoverinfo = "text",
    text = ~paste0(
      "<br><b>", weatherVariable, ":</b>  ", .data[[weatherVariable]],
      "<br><b>", batteryVariable, ":</b>  ", .data[[batteryVariable]],
      "<br><b>Measurement Date:</b>  ", datetime,
      "<br><b>AZMet station:</b>  ", meta_station_name
    )
    #text = ~paste(datetime),
    #hovertemplate = ~paste0(
    #  "<br><b>", weatherVariable, ":</b>  %{x}",
    #  "<br><b>", batteryVariable, ":</b>  %{y}",
      #"<br><b>Measurement date:</b>  %{text}",
    #  "<br><b>Measurement Date:</b>  %{text|%B %e, %Y}", # https://d3js.org/d3-time-format
    #  "<br><b>AZMet station:</b>  meta_station_name",
    #  "<extra></extra>"
    #)
  ) %>%
  plotly::add_trace(
    data = trace2,
    x = ~.data[[weatherVariable]],
    y = ~.data[[batteryVariable]],
    color = ~stationCategory,
    type = "scatter",
    mode = "markers",
    marker = list(
      size = 8,
      color = "rgba(89, 89, 89, 1.0)",
      line = list(
        color = "rgba(13, 13, 13, 1.0)",
        width = 1
      )
    )
  ) %>%
  plotly::config(
    displaylogo = FALSE,
    displayModeBar = TRUE,
    modeBarButtonsToRemove = c(
      'autoScale2d',
      'hoverClosestCartesian', 
      'hoverCompareCartesian', 
      'lasso2d',
      'select'
    ),
    scrollZoom = FALSE,
    toImageButtonOptions = list(
      format = 'png', # One of png, svg, jpeg
      filename = 'AZMet-battery-voltage-viewer',
      height = 500,
      width = 700,
      scale = 1 # Multiply title/legend/axis/canvas sizes by this factor
    )
  ) %>%
  plotly::layout(
    legend = list(
      orientation = "h",
      traceorder = "reversed",
      x = 0,
      xanchor = "left",
      xref = "container",
      y = 1.02,
      yanchor = "bottom",
      yref = "container"
    ),
    margin = list(
      l = 0,
      r = 30,
      b = 0,
      t = 0,
      pad = 0
    ),
    modebar = list(
      orientation = 'v'
    ),
    xaxis = list(
      title = list(
        standoff = 25,
        text = weatherVariable
      ),
      zeroline = FALSE
    ),
    yaxis = list(
      title = list(
        standoff = 25,
        text = batteryVariable
      ),
      zeroline = FALSE
    )
  )

scatterplot


