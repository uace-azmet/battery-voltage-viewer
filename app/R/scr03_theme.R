# https://rstudio.github.io/bslib/articles/bs5-variables/index.html

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
    bootswatch = NULL,
    "focus-ring-color" = rgb(0, 0, 0, 0.1),
    "focus-ring-width" = "0.1rem"
  )
