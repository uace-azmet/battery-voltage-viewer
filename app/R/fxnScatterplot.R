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
    )
  
  # plotly graph https://plotly.com/r/reference/ -----
  scatterplot <- plotly::plot_ly(
    data = dplyr::filter(inData, meta_station_name != azmetStation) %>%
      dplyr::select(
        datetime,
        meta_station_name, 
        stationCategory,
        batteryVariable,
        weatherVariable
      ),
    x = ~.data[[weatherVariable]],
    y = ~.data[[batteryVariable]],
    #name = NULL,
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
    #hoverinfo = "text",
    #text = as.character(.data[datetime]),
    hovertemplate = paste0(
      "<br><b>", weatherVariable, ":</b> %{x}",
      "<br><b>", batteryVariable, ":</b> %{y}", 
      "<br><b>Measurement Date:</b> %{text}",
      "<br><b>AZMet station:</b> ", "[[meta_station_name]]"
    )
  ) %>%
    plotly::add_trace(
      data = dplyr::filter(inData, meta_station_name == azmetStation) %>%
        dplyr::select(
          meta_station_name, 
          stationCategory,
          batteryVariable,
          weatherVariable
        ),
      x = ~.data[[weatherVariable]],
      y = ~.data[[batteryVariable]],
      #name = NULL,
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
  # -----
  
  return(scatterplot)
}
