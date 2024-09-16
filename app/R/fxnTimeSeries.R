#' `fxnTimeSeries.R` Generate time series graph based on user input
#' 
#' @param inData - daily AZMet data from `dataAZMetDataELT()`
#' @param azmetStation - user-specified AZMet station
#' @param weatherVariable - user-specified weather variable
#' @param batteryVariable - user-specified battery variable
#' @return `timeSeries` - time series graph based on user input


fxnTimeSeries <- function(inData, azmetStation, weatherVariable, batteryVariable) {
  inData <- inData %>%
    reshape2::melt(
      id.vars = c(
        "meta_needs_review", 
        "meta_station_id", 
        "meta_station_name", 
        "meta_version", 
        "date_doy", 
        "date_year", 
        "datetime"
      ),
      measure.vars = c(batteryVariable, weatherVariable),
      variable.name = "variable",
      value.name = "value",
      na.rm = FALSE
    )
  
  timeSeries <- 
    ggplot2::ggplot() +
      geom_line(
        data = dplyr::filter(inData, meta_station_name != azmetStation),
        mapping = aes(
          x = date_doy,
          y = value,
          group = meta_station_name
        ),
        color = "#989898"
      ) +
      
      geom_line(
        data = dplyr::filter(inData, meta_station_name == azmetStation),
        mapping = aes(
          x = date_doy,
          y = value
        ),
        color = "#000000"
      ) +
    
    facet_wrap(vars(variable), ncol = 1, scales = "free_y") +
    
    theme_minimal()
  
  timeSeries <- plotly::ggplotly(timeSeries)
  return(timeSeries)
}
