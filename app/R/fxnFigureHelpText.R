#' `fxnFigureHelpText.R` - Build help text for figure
#' 
#' @param startDate - Start date of period of interest
#' @param endDate - End date of period of interest
#' @return `figureHelpText` - Help text for figure


fxnFigureHelpText <- function(startDate, endDate) {
  figureHelpText <- 
    htmltools::p(
      htmltools::HTML(
        "Data are from ", gsub(" 0", " ", format(startDate, "%B %d, %Y")), " through ", gsub(" 0", " ", format(endDate, "%B %d, %Y")), ". Click or tap on legend items to toggle data visibility." # https://github.com/plotly/plotly.js/blob/c1ef6911da054f3b16a7abe8fb2d56019988ba14/src/components/fx/hover.js#L1596
      ), 
      
      class = "figure-help-text"
    )
  
  return(figureHelpText)
}
