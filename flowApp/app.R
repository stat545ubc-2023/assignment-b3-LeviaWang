

library(shiny)
library(ggplot2)
library(DT)
library(shinythemes)

# Load dataset
read.csv("data/flow_sample.csv")

# UI section
ui <- fluidPage(
  theme = shinytheme("cerulean"),



  titlePanel("Water Flow Data Explorer"),

  # Adding descriptive text
  tags$p("Welcome to the Water Flow Data Explorer! This application allows you to explore and analyze water flow data."),
  tags$p("Use the options on the left to select an extreme type and a specific year range to filter the data."),
  tags$p("You can download the filtered data as a CSV file for further analysis."),

  dataTableOutput("dataTable"),

  sidebarLayout(
    sidebarPanel(
      selectInput("extre", "Select Extreme Type:", choices = unique(flow_sample$extreme_type)),
      sliderInput("yearRange", "Select Year Range:",
                  min = min(flow_sample$year), max = max(flow_sample$year),
                  value = c(min(flow_sample$year), max(flow_sample$year))),
      downloadButton("downloadData", "Download CSV")
    ),
    mainPanel(
      # Adding descriptive text
      tags$p("Here are the visualizations of the selected data:"),
      tags$p("Histogram: Shows the distribution of flow data."),
      plotOutput("histogram"),

      tags$p("Density Plot: Illustrates the density of the flow data."),
      plotOutput("densityPlot"),
      tags$p("Flow Plot: Displays the flow data over the selected years."),
      plotOutput("flowPlot"),
      verbatimTextOutput("summaryInfo")
    )
  ),
  # More descriptive text
  tags$p("Linear Model Prediction:"),
  tags$p("This section provides a simple linear model prediction based on the selected year."),
  tags$p("It shows the predicted flow value for the chosen year using a linear model."),
  verbatimTextOutput("prediction")
)


server <- function(input, output) {
  # feature 1. Reactive function to filter data based on user inputs
  filteredData <- reactive({
    flow_sample %>%
      dplyr::filter(extreme_type == input$extre &
                      year >= input$yearRange[1] &
                      year <= input$yearRange[2])
  })

  # Render plot to display flow data over selected years
  output$flowPlot <- renderPlot({
    ggplot(filteredData(), aes(x = year, y = flow)) +
      geom_line() +
      labs(title = paste("Flow Data for Extreme Type", input$extreme))
  })

  #feature 2. Function to handle downloading filtered data as CSV
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("flow_data_", input$extreme, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(filteredData(), file)
    }
  )

  # feature 3. Render data table to display filtered data
  output$dataTable <- DT::renderDataTable({
    filteredData()
  })

  # feature 4. Render histogram to display distribution of flow data
  output$histogram <- renderPlot({
    ggplot(filteredData(), aes(x = flow)) +
      geom_histogram(binwidth = 10, fill = "skyblue", color = "black") +
      labs(title = "Distribution of Flow Data", x = "Flow", y = "Frequency")
  })

  # feature 4. Render density plot to show density of flow data
  output$densityPlot <- renderPlot({
    ggplot(filteredData(), aes(x = flow)) +
      geom_density(fill = "skyblue") +
      labs(title = "Density Plot of Flow Data", x = "Flow", y = "Density")
  })

  # feature 4. Render statistical summary info about the filtered data
  output$summaryInfo <- renderPrint({
    summary_data <- summary(filteredData()$flow)
    summary_text <- paste(
      "Summary of Flow Data:",
      "\nMean:", summary_data["Mean"],
      "\nMedian:", summary_data["Median"],
      "\nMinimum:", summary_data["Min."],
      "\nMaximum:", summary_data["Max."]
    )
    cat(summary_text)
  })

  # feature 5. Generate a linear model, display its summary, and predict flow for the selected year
  output$prediction <- renderPrint({
    # Create a linear model
    lm_model <- lm(flow ~ year, data = filteredData())

    # Get the summary information of the linear model
    summary_info <- capture.output(summary(lm_model))

    # Display linear model summary and prediction for the selected year
    cat("Linear Model Summary:\n")
    cat(summary_info, sep = "\n")
    cat("\nPredicted flow for selected year:",
        predict(lm_model, newdata = data.frame(year = input$yearRange[1])))
  })
}


shinyApp(ui = ui, server = server)
