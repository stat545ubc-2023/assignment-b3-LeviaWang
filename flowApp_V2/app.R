

library(shiny)
library(ggplot2)
library(DT)
library(shinythemes)
library(colourpicker)

# Load dataset
load("flow_sample.rda")


# UI section
ui <- navbarPage(
  theme = shinytheme("cerulean"),
  "Water Flow Data Explorer",

  tabPanel(
    "Explore Data",
    tags$p("Welcome to the Water Flow Data Explorer! This application allows you to explore and analyze water flow data."),
    tags$p("Use the options below to filter the data."),

    sidebarLayout(
      sidebarPanel(
        selectInput("extre", "Select Extreme Type:", choices = unique(flow_sample$extreme_type)),
        sliderInput("yearRange", "Select Year Range:",
                    min = min(flow_sample$year), max = max(flow_sample$year),
                    value = c(min(flow_sample$year), max(flow_sample$year))),
        downloadButton("downloadData", "Download CSV")
      ),
      mainPanel(
        dataTableOutput("dataTable"),
      )
    )
  ),

  tabPanel(
    "Data visulization",
    #If the user want to down load the plot for their presentation, they may want different color for their slides.
    # Add a color choose function to let user choose the color of plot.
    colourInput("colorInput", "Choose a color for your plot:", value = "#00A2FF"),
    plotOutput("histogram"),
    downloadButton("saveHistogram", "Save histogram Plot as Image"),
    plotOutput("densityPlot"),
    downloadButton("saveDensityPlot", "Save densityPlot Plot as Image"),
    plotOutput("flowPlot"),
    downloadButton("saveFlowPlot", "Save flowPlot Plot as Image"),

    verbatimTextOutput("summaryInfo")
  ),
  tabPanel(
    "Model Prediction",
    tags$p("Linear Model Prediction:"),
    tags$p("This section provides a simple linear model prediction based on the selected year."),
    tags$p("It shows the predicted flow value for the chosen year using a linear model."),

    # Additional descriptive text
    tags$p("The prediction is based on a linear model fitted to the filtered data within the selected year range."),
    tags$p("The 'Linear Model Summary' presents information about the model's fit and significance."),
    verbatimTextOutput("prediction"),
    tags$p("Below is the plot representing the linear model:"),
    plotOutput("linearModelPlot")

  )
)




server <- function(input, output) {
  # 1. Reactive function to filter data based on user inputs
  filteredData <- reactive({
    flow_sample %>%
      dplyr::filter(extreme_type == input$extre &
                      year >= input$yearRange[1] &
                      year <= input$yearRange[2])
  })

  # 2. Render plot to display flow data over selected years
  output$flowPlot <- renderPlot({
    gg <- ggplot(filteredData(), aes(x = year, y = flow)) +
      geom_line() +
      labs(title = paste("Flow Data for Extreme Type", input$extre))

    plot(gg)  # Display the plot

    # Add a download button below the plot to save it as an image
    tagList(
      downloadButton("saveFlowPlot", "Save Flow Plot as Image")
    )
  })

  # Function to save the flow plot as an image
  output$saveFlowPlot <- downloadHandler(
    filename = function() {
      "flow_plot.png"  # Set the filename
    },
    content = function(file) {
      gg <- ggplot(filteredData(), aes(x = year, y = flow)) +
        geom_line() +
        labs(title = paste("Flow Data for Extreme Type", input$extre))

      ggsave(file, plot = gg)  # Save the plot as an image
    }
  )

  # 3. Function to handle downloading filtered data as CSV
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("flow_data_", input$extreme, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(filteredData(), file)
    }
  )

  # 4. Render data table to display filtered data
  output$dataTable <- DT::renderDataTable({
    filteredData()
  })

  # 5. Render histogram to display distribution of flow data
  output$histogram <- renderPlot({
    gg <- ggplot(filteredData(), aes(x = flow)) +
      geom_histogram(binwidth = 10, fill = input$colorInput, color = "black") +
      labs(title = "Distribution of Flow Data", x = "Flow", y = "Frequency")

    plot(gg)  # Display the plot

    tagList(
      downloadButton("saveHistogram", "Save Histogram as Image")
    )
  })

  output$saveHistogram <- downloadHandler(
    filename = function() {
      "histogram.png"  # Set the filename
    },
    content = function(file) {
      gg <- ggplot(filteredData(), aes(x = flow)) +
        geom_histogram(binwidth = 10, fill = input$colorInput, color = "black") +
        labs(title = "Distribution of Flow Data", x = "Flow", y = "Frequency")

      ggsave(file, plot = gg)
    }
  )


  # 6. Render density plot to show density of flow data
  output$densityPlot <- renderPlot({
    gg <- ggplot(filteredData(), aes(x = flow)) +
      geom_density(fill = input$colorInput) +
      labs(title = "Density Plot of Flow Data", x = "Flow", y = "Density")

    plot(gg)  # Display the plot

    tagList(
      downloadButton("saveDensityPlot", "Save Density Plot as Image")
    )
  })

  output$saveDensityPlot <- downloadHandler(
    filename = function() {
      "density_plot.png"  # Set the filename
    },
    content = function(file) {
      gg <- ggplot(filteredData(), aes(x = flow)) +
        geom_density(fill = input$colorInput) +
        labs(title = "Density Plot of Flow Data", x = "Flow", y = "Density")

      ggsave(file, plot = gg)
    }
  )

  # 7. Render statistical summary info about the filtered data
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

  # 8. Generate a linear model, display its summary, and predict flow for the selected year
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

  # 9. Render plot to display the linear model
  output$linearModelPlot <- renderPlot({
    lm_model <- lm(flow ~ year, data = filteredData())
    par(mfrow = c(2,2))
    plot(lm_model)  # Adjust plot parameters as needed
  })
}


shinyApp(ui = ui, server = server)
