#' `fxnScatterplot.R` Generate scatterplot based on user input
#' 
#' @param inData - daily AZMet data from `dataAZMetDataELT()`
#' @param azmetStation - user-specified AZMet station
#' @param batteryVariable - user-specified battery variable
#' @param weatherVariable - user-specified weather variable
#' @return `scatterplot` - scatterplot based on user input


fxnScatterplot <- function(inData, azmetStation, batteryVariable, weatherVariable) {
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
      hoverinfo = "text",
      text = ~paste0(
        "<br><b>", weatherVariable, ":</b>  ", .data[[weatherVariable]],
        "<br><b>", batteryVariable, ":</b>  ", .data[[batteryVariable]],
        "<br><b>Measurement Date:</b>  ", datetime,
        "<br><b>AZMet station:</b>  ", meta_station_name
      )
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
  
  return(scatterplot)
}
