# load packages ----
pkgs <- c("shiny", "plotly", "ggplot2", "dplyr")
install.packages(setdiff(pkgs, rownames(installed.packages())))
invisible(lapply(pkgs, FUN = library, character.only = TRUE))

# https://rcourse.sciensano.be/shiny/deploy.html

# load data ----
df_nation <- read.csv2("./data/Belgium_export-nation.csv", sep = ";")
df_site <- read.csv2("./data/Belgium_export-site.csv", sep = ";") %>%
  select(measure, siteName, date, value:value_pmmv_avg14d_past)

# bind nation and site data
df <- rbind(df_nation, df_site)

# clean data
df$date <- as.Date(df$date)
df$value_pmmv <- as.numeric(df$value_pmmv)*1000
df$value_pmmv_avg14d_past <- as.numeric(df$value_pmmv_avg14d_past)*1000

# ui ----
ui <- navbarPage(
  title = "wastewater surveillance",
  
  tabPanel(
    "About",
    # Custom CSS for green header bar
    tags$style(HTML("
    .top-bar {
      background-color: #e8f5e9;
      padding: 15px;
      margin-bottom: 20px;
      border-radius: 5px;
      color: white;
    }
    .top-bar label {
      color: grey;
      font-weight: bold;
    }
    .info-box {
      background-color: #4CAF50;
      padding: 15px;
      border-radius: 5px;
      text-align: center;
      font-weight: bold;
      border: 1px solid #c8e6c9;
      margin-bottom: 20px;
    }
  ")),
    
    # Bottom acknowledgment box
    div(class = "info-box",
        "Welcome to this nice page describing..." )
  ),
  
  
  tabPanel(
    "Respi. viruses",
    # Bottom acknowledgment box
    div(class = "info-box",
        "Wastewater surveillance in Belgium" )
    ,
    
    # Three horizontal info boxes
    fluidRow(
      column(4, div(class = "info-box", "Number of site = 30")),
      column(4, div(class = "info-box", "Next sampling date = Wednesay")),
      column(4, div(class = "info-box", "Next dashboard update = Monday")
      )
    ),
    
    # Top bar with dropdown
    div(class = "top-bar",
        # First dropdown: siteName
        selectInput(
          inputId = "site",
          label = "Select sampling site",
          choices = unique(df$siteName),
          selected = unique(df$siteName)[1]
        ),
        # Second dropdown: measure
        selectInput(
          inputId = "measure_in",
          label = "Select pathogen",
          choices = unique(df$measure),
          selected = unique(df$measure)[1]
          )
    ),
    
    # Main content
    plotlyOutput("viralPlot")
    ,
    
    # Bottom acknowledgment box
    div(class = "info-box",
        "Acknowledgment: to all my friends" )
    
  )
  
  
)

# server ----
server <- function(input, output, session) {
  
  filtered_data <- reactive({
    df %>% filter(measure == input$measure_in & siteName == input$site)
  })
  
  output$viralPlot <- renderPlotly({
    
    data <- filtered_data()
    
    p <- ggplot(data, aes(x = date)) +
      geom_point(aes(y = value_pmmv), colour = "#92D050", size = 1, na.rm = T) +
      geom_line(aes(y = value_pmmv_avg14d_past), colour = "#BCCF00FF", linewidth = 0.5, na.rm = T) +
      scale_y_continuous(limits = c(0, NA)) +
      labs(
        title = paste(input$measure_in, "viral ratio over time -", input$site),
        x = "", y = "Viral ratio (c/c)"
      ) +
      theme_minimal(base_size = 14)
    
    ggplotly(p)
  })
}

# shinyApp ----
shinyApp(ui, server)