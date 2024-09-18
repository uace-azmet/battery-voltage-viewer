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
  scatterplot <- plotly::plot_ly(
    data = trace1,
    x = ~.data[[weatherVariable]],
    y = ~.data[[batteryVariable]],
    #color = ~stationCategory,
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
    #hoverinfo = "text",
    #text = ~paste0(
    #  "<br><b>", weatherVariable, ":</b>  ", .data[[weatherVariable]],
    #  "<br><b>", batteryVariable, ":</b>  ", .data[[batteryVariable]],
    #  "<br><b>Measurement Date:</b>  ", "datetime",
    #  "<br><b>AZMet station:</b>  ", "meta_station_name"
    #)
    hovertemplate = paste0(
      "<br><b>", weatherVariable, ":</b>  %{x}",
      "<br><b>", batteryVariable, ":</b>  %{y}",
      #"%{text}",
      #"<br><b>Measurement Date:</b>  %{text|%B%e, %Y}", # https://d3js.org/d3-time-format
      "<br><b>AZMet station:</b>  meta_station_name",
      "<extra></extra>"
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
    )
  
  plotly::config(
    scatterplot, 
    modeBarButtonsToRemove = c("select", "lasso2d", "hoverCompareCartesian")
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
