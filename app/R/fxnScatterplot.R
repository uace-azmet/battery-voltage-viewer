#' `fxnScatterplot.R` Generate scatterplot based on user input
#' 
#' @param inData - daily AZMet data from `dataAZMetDataELT()`
#' @param azmetStation - user-specified AZMet station
#' @param weatherVariable - user-specified weather variable
#' @param batteryVariable - user-specified battery variable
#' @return `scatterplot` - scatterplot based on user input


fxnScatterplot <- function(inData, azmetStation, weatherVariable, batteryVariable) {
  scatterplot <- 
    ggplot2::ggplot() +
      geom_point(
        data = dplyr::filter(inData, meta_station_name != azmetStation),
        mapping = aes(
          # https://forum.posit.co/t/string-as-column-name-in-ggplot/155588/2
          x = .data[[weatherVariable]],
          y = .data[[batteryVariable]]
        ),
        color = "#989898"
      ) +
      
      geom_point(
        data = dplyr::filter(inData, meta_station_name == azmetStation),
        mapping = aes(
          # https://forum.posit.co/t/string-as-column-name-in-ggplot/155588/2
          x = .data[[weatherVariable]],
          y = .data[[batteryVariable]]
        ),
        color = "#000000"
      )
  
  scatterplot <- plotly::ggplotly(scatterplot)
  return(scatterplot)
}
