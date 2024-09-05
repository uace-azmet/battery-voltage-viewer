# "Hard-code" Bootstrap version before deployment
# https://rstudio.github.io/bslib/articles/dashboards/index.html
#bslib::version_default()

theme = 
  bslib::bs_theme(
    version = 5,
    preset = NULL,
    #...,
    bg = NULL,
    fg = NULL,
    primary = NULL,
    secondary = NULL,
    success = NULL,
    info = NULL,
    warning = NULL,
    danger = NULL,
    base_font = NULL,
    code_font = NULL,
    heading_font = NULL,
    font_scale = NULL,
    bootswatch = NULL
  ) %>%
  bslib::bs_add_variables(
    "link-color" = "#8b0015"
  )
