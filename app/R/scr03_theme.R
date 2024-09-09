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
    #"nav-bg" = "green",
    "card-border-radius" = 0,
    "focus-ring-color" = rgb(0, 0, 0, 0.1),
    "focus-ring-width" = "0.1rem"#,
    #"nav-link-color" = "#8b0015",
    #"nav-link-hover-color" = "green"
  ) |>
  #bslib::bs_add_rules(".test-card { background-color: red; }") |>
  bslib::bs_add_rules("
    .card-header {
      background-color: #FFFFFF !important;
    }
    
    .nav-item {
      background-color: red !important;
      color: pink !important;
    }
    
    .nav-link {
      color: #8B0015 !important;
      text-decoration: underline !important;
    }
    
    .nav-link:hover {
      color: var(--bs-body-color) !important;
      text-decoration: underline;
      text-shadow: red 3px 3px 3px;
    }
    
    .nav-link.active {
      color: var(--bs-body-color) !important;
      text-decoration: underline;
      text-shadow: 1px 1px 1px 1px blue !important;
    }
    
    #navsetCardTab { 
      background-color: #FFFFFF !important;
    }
  ")
