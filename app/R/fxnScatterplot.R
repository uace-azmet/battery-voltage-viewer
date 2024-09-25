#' `fxnScatterplot.R` Generate scatterplot based on user input
#' 
#' @param inData - daily AZMet data from `dataAZMetDataELT()`
#' @param azmetStation - user-specified AZMet station
#' @param batteryVariable - user-specified battery variable
#' @param weatherVariable - user-specified weather variable
#' @return `scatterplot` - scatterplot based on user input


fxnScatterplot <- function(inData, azmetStation, batteryVariable, weatherVariable) {
  #inData <- inData %>%
  #  dplyr::mutate(stationCategory = dplyr::if_else(
  #    meta_station_name == azmetStation, azmetStation, "other stations"
  #  ) %>%
  #    factor(levels = c(azmetStation, "other stations"))
  #  )
  
  dataOtherStations <- inData %>% dplyr::filter(meta_station_name != azmetStation)
  dataSelectedStation <- inData %>% dplyr::filter(meta_station_name == azmetStation)
  
  lmFit <- lm(
    dataSelectedStation[[batteryVariable]] ~ dataSelectedStation[[weatherVariable]], 
    data = dataSelectedStation
  )
  
  # https://plotly-r.com/ 
  # https://plotly.com/r/reference/ 
  # https://plotly.github.io/schema-viewer/ -----
  scatterplot <- 
    plotly::plot_ly( # points for `dataOtherStations`
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
    plotly::add_trace( # points for `dataSelectedStation`
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
      name = azmetStation
    ) %>%
    plotly::add_trace( # line for linear model of `dataSelectedStation` points
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
      font = list(
        #family = "Open Sans",
        color = "#989898"
      ),
      legend = list(
        orientation = "h",
        traceorder = "reversed",
        x = 0.00,
        xanchor = "left",
        xref = "container",
        y = 1.04,
        yanchor = "bottom",
        yref = "container"
      ),
      margin = list(
        l = 0,
        r = 50, # for space between plot and modebar
        b = 110, # for space between x-axis title and caption
        t = 0,
        pad = 0
      ),
      modebar = list(
        bgcolor = '#FFFFFF',
        orientation = 'v'
      ),
      title = list(
        text = paste0("<i>The dark gray line is a linear trend of the ", azmetStation, " station data.</i>"),
        font = list(
          color = "#989898",
          size = 14
        ),
        x = 0.0,
        xanchor = "left",
        xref = "container",
        y = 0.02,
        yanchor = "bottom",
        yref = "container"
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
  
  return(scatterplot)
}
