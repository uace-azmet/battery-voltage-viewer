#' `fxnScatterplot.R` Generate scatterplot based on user input
#' 
#' @param inData - daily AZMet data from `dataAZMetDataELT()`
#' @param azmetStation - user-specified AZMet station
#' @param weatherVariable - user-specified weather variable
#' @param batteryVariable - user-specified battery variable
#' @return `scatterplot` - scatterplot based on user input


fxnScatterplot <- function(inData, azmetStation, weatherVariable, batteryVariable) {
  inData <- inData %>%
    dplyr::mutate(stationCategory = dplyr::if_else(
      meta_station_name == azmetStation, azmetStation, "other stations"
    ) %>%
      factor(levels = c("other stations", azmetStation))
    )
  
  stationCategoryColor <- c("#989898", "#3b3b3b")
  
  # Graph
  scatterplot <- 
    ggplot2::ggplot(
      data = inData,
      mapping = aes(
        # https://forum.posit.co/t/string-as-column-name-in-ggplot/155588/2
        x = .data[[weatherVariable]],
        y = .data[[batteryVariable]],
        color = stationCategory
      )
    ) +
    
    geom_point() +
    geom_smooth(
      data = dplyr::filter(inData, meta_station_name == azmetStation),
      method = lm,
      formula = y ~ x,
      se = FALSE,
      show.legend = TRUE
    ) +
    
    scale_color_manual(values = stationCategoryColor) +
    
    theme_minimal()
  
  scatterplot <- plotly::ggplotly(scatterplot)
  return(scatterplot)
}
