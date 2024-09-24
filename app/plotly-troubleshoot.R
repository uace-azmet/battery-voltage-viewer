library(magrittr)
library(parsnip)

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
  dplyr::filter(!is.na(batteryVariable))

lmFit <- lm(
  dataSelectedStation[[batteryVariable]] ~ dataSelectedStation[[weatherVariable]], 
  data = dataSelectedStation
)

# https://plotly-r.com/ 
# https://plotly.com/r/reference/ 
# https://plotly.github.io/schema-viewer/ -----
scatterplot <- 
  plotly::plot_ly(
    data = dataOtherStations,
    x = ~.data[[weatherVariable]],
    y = ~.data[[batteryVariable]],
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
    name = "other stations",
    hoverinfo = "text",
    text = ~paste0(
      "<br><b>", weatherVariable, ":</b>  ", .data[[weatherVariable]],
      "<br><b>", batteryVariable, ":</b>  ", .data[[batteryVariable]],
      "<br><b>Measurement Date:</b>  ", datetime,
      "<br><b>AZMet station:</b>  ", meta_station_name
    ),
    showlegend = TRUE
  ) %>%
  plotly::add_trace(
    data = dataSelectedStation,
    x = ~.data[[weatherVariable]],
    y = ~.data[[batteryVariable]],
    type = "scatter",
    mode = "markers",
    marker = list(
      size = 8,
      color = "rgba(89, 89, 89, 1.0)",
      line = list(
        color = "rgba(13, 13, 13, 1.0)",
        width = 1
      )
    ),
    name = azmetStation,
    hoverinfo = "text",
    text = ~paste0(
      "<br><b>", weatherVariable, ":</b>  ", .data[[weatherVariable]],
      "<br><b>", batteryVariable, ":</b>  ", .data[[batteryVariable]],
      "<br><b>Measurement Date:</b>  ", datetime,
      "<br><b>AZMet station:</b>  ", meta_station_name
    ),
    showlegend = TRUE
  ) %>%
  plotly::add_trace(
    data = dataSelectedStation,
    x = ~.data[[weatherVariable]],
    y = predict(lmFit, type = "response"), 
    type = "scatter",
    mode = "lines",
    marker = NULL,
    line = list(
      color = "rgba(13, 13, 13, 1.0)", 
      width = 2
    ),
    name = "regression line",
    hoverinfo = "skip",
    showlegend = FALSE
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
      format = 'png', # one of png, svg, jpeg, webp
      filename = 'AZMet-battery-voltage-viewer',
      height = 500,
      width = 700,
      scale = 1
    )
  ) %>%
  plotly::layout(
    annotations = list(
      text = "This is the caption.",
      align = "left",
      showarrow = FALSE,
      x = 0.0,
      y = -0.3,
      xref = "paper",
      yref = "paper"
    ),
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
      r = 30, # for space between plot and modebar
      b = 0,
      t = 0,
      pad = 0
    ),
    modebar = list(
      bgcolor = '#FFFFFF',
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













lmFit <- lm(
  dataSelectedStation[[batteryVariable]] ~ dataSelectedStation[[weatherVariable]], 
  data = dataSelectedStation
)
m <- lmFit$coefficients[[2]]
b <- lmFit$coefficients[[1]]

lmSelectedStation <- dataSelectedStation %>% 
  dplyr::mutate(dataSelectedStation[[batteryVariable]] = m * dataSelectedStation[[weatherVariable]] + b)



colnames(dataSelectedStation)





linearModelSpec <- parsnip::linear_reg() %>%
  parsnip::set_engine(engine = "lm") %>%
  parsnip::set_mode(mode = "regression")

set.seed(1)
linearModel <- linearModelSpec %>%
  parsnip::fit(
    dataSelectedStation[[batteryVariable]] ~ dataSelectedStation[[weatherVariable]], 
    data = dataSelectedStation
  )

dataSelectedStation %>%
  plot_ly(x = ~.data[[weatherVariable]], y = ~.data[[batteryVariable]]) %>%
  add_markers() %>%
  add_lines(x = ~.data[[weatherVariable]], y = fitted(linearModel))

y = ~.data[[batteryVariable]],

xRange <- seq(
  min(dataSelectedStation[[weatherVariable]], na.rm = TRUE), 
  max(dataSelectedStation[[weatherVariable]], na.rm = TRUE), 
  length.out = nrow(dataSelectedStation)
)

x <- matrix(xRange, nrow = nrow(dataSelectedStation), ncol = 1) |>
  data.frame()

colnames(x) <- weatherVariable
colnames(x) <- "x"

y <- linearModel %>% predict(x)

colnames(y) <- batteryVariable
colnames(y) <- "y"

xy <- data.frame(x, y, check.names = FALSE) 


data("airquality")
airq <- airquality %>%
  dplyr::filter(!is.na(Ozone))
fit <- lm(Ozone ~ Wind, data = airq)
airq %>% 
  plot_ly(x = ~Wind) %>% 
  add_markers(y = ~Ozone) %>% 
  add_lines(x = ~Wind, y = fitted(fit))

lmFit <- lm(
  dataSelectedStation[[batteryVariable]] ~ dataSelectedStation[[weatherVariable]], 
  data = dataSelectedStation
)
dataSelectedStation %>%
  plot_ly(x = ~.data[[weatherVariable]]) %>%
  add_markers(y = ~.data[[batteryVariable]]) %>%
  add_lines(x = ~.data[[weatherVariable]], y = fitted(lmFit))


# https://plotly-r.com/ 
# https://plotly.com/r/reference/ 
# https://plotly.github.io/schema-viewer/ -----
scatterplot <- 
  plotly::plot_ly(
    data = dataOtherStations,
    x = ~.data[[weatherVariable]],
    y = ~.data[[batteryVariable]],
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
    name = "other stations",
    hoverinfo = "text",
    text = ~paste0(
      "<br><b>", weatherVariable, ":</b>  ", .data[[weatherVariable]],
      "<br><b>", batteryVariable, ":</b>  ", .data[[batteryVariable]],
      "<br><b>Measurement Date:</b>  ", datetime,
      "<br><b>AZMet station:</b>  ", meta_station_name
    )
  ) %>%
  plotly::add_trace(
    data = dataSelectedStation,
    x = ~.data[[weatherVariable]],
    y = ~.data[[batteryVariable]],
    type = "scatter",
    mode = "markers",
    marker = list(
      size = 8,
      color = "rgba(89, 89, 89, 1.0)",
      line = list(
        color = "rgba(13, 13, 13, 1.0)",
        width = 1
      )
    ),
    name = azmetStation,
    hoverinfo = "text",
    text = ~paste0(
      "<br><b>", weatherVariable, ":</b>  ", .data[[weatherVariable]],
      "<br><b>", batteryVariable, ":</b>  ", .data[[batteryVariable]],
      "<br><b>Measurement Date:</b>  ", datetime,
      "<br><b>AZMet station:</b>  ", meta_station_name
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
      format = 'png', # one of png, svg, jpeg, webp
      filename = 'AZMet-battery-voltage-viewer',
      height = 500,
      width = 700,
      scale = 1
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
      bgcolor = '#FFFFFF',
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




plotly::add_trace(
  data = xy,
  x = ~.data[[weatherVariable]],
  y = ~.data[[batteryVariable]],
  type = "scatter",
  mode = "markers",
  marker = list(
    size = 8,
    color = "rgba(200, 0, 0, 1.0)",
    line = list(
      color = "rgba(255, 0, 0, 1.0)",
      width = 1
    )
  ),name = "regression fit",
  hoverinfo = "text",
  text = ~paste0(
    "<br><b>", weatherVariable, ":</b>  ", .data[[weatherVariable]],
    "<br><b>", batteryVariable, ":</b>  ", .data[[batteryVariable]]
  )
) %>%
  plotly::add_trace(
    data = xy,
    x = ~.data[[weatherVariable]],
    y = ~.data[[batteryVariable]],
    name = "regression fit line",
    mode = "lines",
    hoverinfo = "text",
    text = ~paste0(
      "<br><b>", weatherVariable, ":</b>  ", .data[[weatherVariable]],
      "<br><b>", batteryVariable, ":</b>  ", .data[[batteryVariable]]
    )
  ) %>%




library(reshape2)
data(tips)

y <- tips$tip
X <- tips$total_bill

lm_model <- linear_reg() %>% 
  set_engine('lm') %>% 
  set_mode('regression') %>%
  fit(tip ~ total_bill, data = tips) 

x_range <- seq(min(X), max(X), length.out = 100)
x_range <- matrix(x_range, nrow=100, ncol=1)
xdf <- data.frame(x_range)
colnames(xdf) <- c('total_bill')

ydf <- lm_model %>% predict(xdf) 

colnames(ydf) <- c('tip')
xy <- data.frame(xdf, ydf) 

fig <- plot_ly(tips, x = ~total_bill, y = ~tip, type = 'scatter', alpha = 0.65, mode = 'markers', name = 'Tips')
fig <- fig %>% add_trace(data = xy, x = ~total_bill, y = ~tip, name = 'Regression Fit', mode = 'lines', alpha = 1)
fig
