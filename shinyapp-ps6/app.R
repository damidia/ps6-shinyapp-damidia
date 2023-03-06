# Load necessary packages
library(shiny)
library(ggplot2)
library(dplyr)

# Load data

data <- read.delim("dataset.bz2")

# Define UI
ui <- fluidPage(
  titlePanel("UAH lower troposphere temperature"),
  
  # Main panel with tabs
  mainPanel(
    tabsetPanel(
      
      # Opening page with explanatory text
      tabPanel("About", 
               tags$p("This application makes use of ", strong("UAH") ," satellite temperature data."),
               tags$p("Temperature is measured as a difference (deg C) from the base period of ",
                      min(data$year),"-", max(data$year), "."),
               textOutput("summary"),
               tags$p("Here is a small (random) sample of data:"),
               # Add a table to display a random sample of the data
               tableOutput("random_sample_table")
      ),
      
      # Plot page
      tabPanel("Plots",
               sidebarLayout(
                 sidebarPanel(
                   tags$p("For many regions, you may see the average temperature worldwide. Choose 
                          the areas in which you have an interest. You may view the associated trend
                          lines and a monthly scatterplot."),
                   
                   # Add widgets for Plots tab
                   selectInput(inputId = "region", label = "Select region(s) to display", 
                               choices = c("globe", "globe_land", "globe_ocean", "nh", "nh_land", "nh_ocean", 
                                           "sh", "sh_land", "sh_ocean", "trpcs", "trpcs_land", "trpcs_ocean",
                                           "noext", "noext_land", "noext_ocean", "soext", "soext_land", "soext_ocean",
                                           "nopol", "nopol_land", "nopol_ocean", "sopol", "sopol_land", "sopol_ocean",
                                           "usa48", "usa49", "aust"), 
                               multiple = TRUE, selected = "globe"),
                               checkboxInput(inputId = "trendline", label = "Show trendline", value = TRUE),
                               selectInput(inputId = "color", label = "Select color palette",
                                           choices = c("Dark2", "Set1"), selected = "Dark2")
                 ),
                 mainPanel(
                   # Add output for Plots tab
                   plotOutput(outputId = "scatterplot"),
                   verbatimTextOutput(outputId = "summary_plot")
                 )
               )
      ),
      
      tabPanel("Table", 
               sidebarLayout(
                 sidebarPanel(
                   tags$p("The average temperature is shown on this panel for months and years."),
                   
                   # Add widgets for Tables tab
                   radioButtons(inputId = "time_period", label = "Average over:", 
                                choices = c("Month" = "month", "Year" = "year"), 
                                selected = "year")
                 ),
                 mainPanel(

                   # Add output for Tables tab
                   tableOutput(outputId = "average_table")
                 )
               )
      ),
    )
  )
)

server <- function(input, output) {
  
  # Output the summary text
  output$summary <- renderText({
    paste("The dataset contains: ", nrow(data), "observations and ", ncol(data), "variables\n")
  })
  
  # Generate a random subset of the data
  random_sample <- data %>% sample_n(size = 5, replace = FALSE)
  
  # Render a table of the random sample
  output$random_sample_table <- renderTable(random_sample)
  
  # Generate scatterplot based on user input
  output$scatterplot <- renderPlot({
    # Subset data based on selected regions
    selected_data <- data %>%
      filter(region %in% input$region)
    
    if (input$trendline) {
      ggplot(selected_data, aes(x = year + (month-1)/12, y = temp, color = region)) + 
        geom_point() +
        geom_smooth(method = "lm", se = FALSE) +
        scale_color_brewer(palette = input$color) +  # add color palette option
        labs(title = "Global Temperature by Region",
             x = "Year",
             y = "Temperature deviation (°C) from 1991-2020 baseline") +
        theme_minimal()
    } else {
      ggplot(selected_data, aes(x = year + (month-1)/12, y = temp, color = region)) + 
        geom_point() +
        scale_color_brewer(palette = input$color) +  # add color palette option
        labs(title = "Global Temperature by Region",
             x = "Year",
             y = "Temperature deviation (°C) from 1991-2020 baseline") +
        theme_minimal()
    }
  })
  
  output$summary_plot <- renderText({
    selected_data <- data %>%
      filter(region %in% input$region)
    paste("Observations shown: ", nrow(selected_data), "\n",
          "Time period range: ", min(selected_data$year), "-", max(selected_data$year), "\n")
  })
  
  # Generate average table based on user input
  output$average_table <- renderTable({
    # Group data by selected time period and calculate average temperature
    data %>%
      group_by(!!sym(input$time_period)) %>%
      summarise(avg_temp = mean(temp))
  })
  
}


# Run the application 
shinyApp(ui = ui, server = server)