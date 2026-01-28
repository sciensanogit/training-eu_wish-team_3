# load packages ----
pkgs <- c("shiny", "plotly", "ggplot2", "dplyr")
install.packages(setdiff(pkgs, rownames(installed.packages())))
invisible(lapply(pkgs, FUN = library, character.only = TRUE))

# load data ----
# load nation data
df_nation <- read.csv2("./data/Belgium_export-nation.csv", sep = ";")

# load the data by site and select appropriate variables
# df_site <- read.csv2("??.csv", sep = ";") %>%
#   select(??)

# bind nation and site data
df <- rbind(df_nation)

# clean data
df$date <- as.Date(df$date)
df$value_pmmv <- as.numeric(df$value_pmmv)*1000
df$value_pmmv_avg14d_past <- as.numeric(df$value_pmmv_avg14d_past)*1000

# ui ----
ui <- navbarPage(
  title = "Wastewater surveillance",
  
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
      color: white;
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
    "SARS-CoV-2",
    # Bottom acknowledgment box
    div(class = "info-box",
        "Add a description of the surveillance..." )
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
        selectInput(
          inputId = "site",
          label = "Select sampling site",
          choices = unique(df$siteName),
          selected = "Belgium"
        )
    ),
    
    # Main content
    plotlyOutput("viralPlot")
    ,
    
    # Bottom acknowledgment box
    div(class = "info-box",
        "Acknowledgment: to be filled" )
    
  )
  
  
)

# server ----
server <- function(input, output, session) {
  
  filtered_data <- reactive({
    df %>% filter(siteName == input$site)
  })
  
  output$viralPlot <- renderPlotly({
    
    data <- filtered_data()
    
    p <- ggplot(data, aes(x = date)) +
      geom_point(aes(y = value_pmmv), colour = "#92D050", size = 1, na.rm = T) +
      scale_y_continuous(limits = c(0, NA)) +
      labs(
        title = paste(input$site),
        x = "", y = "(c/c)"
      ) +
      theme_minimal(base_size = 14)
    
    ggplotly(p)
  })
}

# shinyApp ----
shinyApp(ui, server)