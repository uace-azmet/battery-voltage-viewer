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
      factor(levels = c(azmetStation, "other stations"))
    )
  
  #stationCategoryColor <- c("#3b3b3b", "#c9c9c9")
  
  # ggplot graph -----
  #scatterplot <- 
  #  ggplot2::ggplot(
  #    data = inData,
  #    mapping = aes(
  #      # https://forum.posit.co/t/string-as-column-name-in-ggplot/155588/2
  #      x = .data[[weatherVariable]],
  #      y = .data[[batteryVariable]],
  #      color = stationCategory
  #    )
  #  ) +
    
  #  geom_point() +
    
  #  geom_smooth(
  #    data = dplyr::filter(inData, meta_station_name == azmetStation),
  #    method = lm,
  #    formula = y ~ x,
  #    se = FALSE,
  #    show.legend = FALSE
  #  ) +
    
  #  scale_color_manual(values = stationCategoryColor) +
    
  #  theme_minimal()
  # -----
  
  # plotly graph -----
  scatterplot <- plotly::plot_ly(
    data = dplyr::filter(inData, meta_station_name != azmetStation),
    x = ~.data[[weatherVariable]],
    y = ~.data[[batteryVariable]],
    color = ~stationCategory,
    type = "scatter",
    mode = "markers",
    marker = list(
      size = 10,
      color = "rgba(152, 152, 152, 1.0)",
      line = list(
        color = "rgba(201, 201, 201, 0.8)",
        width = 1
      )
    ),
    text = ~paste(
      "Station: ",
      meta_station_name,
      "<br>Battery voltage: ", 
      "batteryVariable", 
      "<br>Weather variable: ", 
      "weather variable"
    )
  ) %>%
    plotly::add_trace(
      data = dplyr::filter(inData, meta_station_name == azmetStation),
      x = ~.data[[weatherVariable]],
      y = ~.data[[batteryVariable]],
      color = ~stationCategory,
      type = "scatter",
      mode = "markers",
      marker = list(
        size = 10,
        color = "rgba(59, 59, 59, 1.0)",
        line = list(
          color = "rgba(152, 152, 152, 0.8)",
          width = 1
        )
      )
    )
  # -----
  
  #scatterplot <- plotly::ggplotly(scatterplot)
  return(scatterplot)
}
