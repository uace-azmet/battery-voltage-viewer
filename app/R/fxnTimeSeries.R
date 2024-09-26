#' `fxnTimeSeries.R` Generate time series graph based on user input
#' 
#' @param inData - daily AZMet data from `dataAZMetDataELT()`
#' @param azmetStation - user-specified AZMet station
#' @param startDate - Planting date of period of interest
#' @param endDate - End date of period of interest
#' @param batteryVariable - user-specified battery variable
#' @param weatherVariable - user-specified weather variable
#' @return `timeSeries` - time series graph based on user input

# https://plotly-r.com/ 
# https://plotly.com/r/reference/ 
# https://plotly.github.io/schema-viewer/


fxnTimeSeries <- function(
    inData, 
    azmetStation, 
    startDate, 
    endDate, 
    batteryVariable, 
    weatherVariable
) {
  
  dataOtherStations <- inData %>% dplyr::filter(meta_station_name != azmetStation)
  dataSelectedStation <- inData %>% dplyr::filter(meta_station_name == azmetStation)
  
  batteryVariableTimeSeries <- 
    plotly::plot_ly( # lines for `dataOtherStations`
      data = dataOtherStations,
      x = ~.data[[datetime]],
      y = ~.data[[batteryVariable]],
      type = "scatter",
      mode = "lines",
      marker = NULL,
      line = list(
        color = "rgba(201, 201, 201, 1.0)", 
        width = 2
      ),
      name = "other station data",
      hoverinfo = "text",
      text = ~paste0(
        "<br><b>", batteryVariable, ":</b>  ", .data[[batteryVariable]],
        "<br><b>Measurement Date:</b>  ", datetime,
        "<br><b>AZMet station:</b>  ", meta_station_name
      ),
      showlegend = TRUE
    ) %>%
    plotly::add_trace( # lines for `dataSelectedStation`
      data = dataSelectedStation,
      x = ~.data[[datetime]],
      y = ~.data[[batteryVariable]],
      type = "scatter",
      mode = "lines",
      marker = NULL,
      line = list(
        color = "rgba(89, 89, 89, 1.0)", 
        width = 2
      ),
      name = paste0(azmetStation, " station data"),
      hoverinfo = "text",
      text = ~paste0(
        "<br><b>", batteryVariable, ":</b>  ", .data[[batteryVariable]],
        "<br><b>Measurement Date:</b>  ", datetime,
        "<br><b>AZMet station:</b>  ", meta_station_name
      ),
      showlegend = TRUE
    )
  
  weatherVariableTimeSeries <- 
    plotly::plot_ly( # lines for `dataOtherStations`
      data = dataOtherStations,
      x = ~.data[[datetime]],
      y = ~.data[[weatherVariable]],
      type = "scatter",
      mode = "lines",
      marker = NULL,
      line = list(
        color = "rgba(201, 201, 201, 1.0)", 
        width = 2
      ),
      name = "other station data",
      hoverinfo = "text",
      text = ~paste0(
        "<br><b>", weatherVariable, ":</b>  ", .data[[weatherVariable]],
        "<br><b>Measurement Date:</b>  ", datetime,
        "<br><b>AZMet station:</b>  ", meta_station_name
      ),
      showlegend = TRUE
    ) %>%
    plotly::add_trace( # lines for `dataSelectedStation`
      data = dataSelectedStation,
      x = ~.data[[datetime]],
      y = ~.data[[weatherVariable]],
      type = "scatter",
      mode = "lines",
      marker = NULL,
      line = list(
        color = "rgba(89, 89, 89, 1.0)", 
        width = 2
      ),
      name = paste0(azmetStation, " station data"),
      hoverinfo = "text",
      text = ~paste0(
        "<br><b>", weatherVariable, ":</b>  ", .data[[weatherVariable]],
        "<br><b>Measurement Date:</b>  ", datetime,
        "<br><b>AZMet station:</b>  ", meta_station_name
      ),
      showlegend = TRUE
    )
  
  timeseries <- subplot(
    batteryVariableTimeSeries, 
    weatherVariableTimeSeries, 
    nrows = 2, 
    shareX = TRUE
  )
  
  #inData <- inData %>%
  #  reshape2::melt(
  #    id.vars = c(
  #      "meta_needs_review", 
  #      "meta_station_id", 
  #      "meta_station_name", 
  #      "meta_version", 
  #      "date_doy", 
  #      "date_year", 
  #      "datetime"
  #    ),
  #    measure.vars = c(batteryVariable, weatherVariable),
  #    variable.name = "variable",
  #    value.name = "value",
  #    na.rm = FALSE
  #  )
  
  #timeSeries <- 
  #  ggplot2::ggplot() +
  #    geom_line(
  #      data = dplyr::filter(inData, meta_station_name != azmetStation),
  #      mapping = aes(
  #        x = date_doy,
  #        y = value,
  #        group = meta_station_name
  #      ),
  #      color = "#989898"
  #    ) +
      
  #    geom_line(
  #      data = dplyr::filter(inData, meta_station_name == azmetStation),
  #      mapping = aes(
  #        x = date_doy,
  #        y = value
  #      ),
  #      color = "#000000"
  #    ) +
    
  #  facet_wrap(vars(variable), ncol = 1, scales = "free_y") +
    
  #  theme_minimal()
  
  #timeSeries <- plotly::ggplotly(timeSeries)
  return(timeSeries)
}
