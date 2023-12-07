# flowApp : Water Flow Data Explorer

Welcome to the Water Flow Data Explorer! This Shiny web application allows users to explore, visualize, and analyze water flow data using an intuitive interface.

You can find the app in the shinyapps.io.[flowApp_V1](https://yuehaowang.shinyapps.io/flowApp/).

## Overview

The Water Flow Data Explorer is designed to provide users with the capability to:

- **Explore Data:** Filter and visualize water flow data based on extreme types and specific year ranges.
- **Visualize Data:** View histograms, density plots, and line plots to understand the distribution and trends in the flow data.
- **Download Data:** Obtain filtered data as a CSV file for further analysis. Obtain statistical charts.(new feature from V2).
- **Linear Model Prediction:** Provides a simple linear model prediction based on the selected year with visualization(new feature from V2).

## NEW Features from V2

### TripleTab Interactive Interface

- Use the tabPanel to divide the interface into three interactive subpages, enhancing readability and user convenience, while providing specialized functions for data exploration, visualization, and modeling.

### Enhanced Chart Download Capability

- This feature offers users the ability to download statistical charts. In version 1, only data download was available. Now, users can download not only the filtered data but also the corresponding histograms and other charts.

### Dynamic Color Customizer for Charts

- Users may download charts for use in their slides, creating a need to change the colors of the graphs to make them more prominent in their presentations. This feature introduces a customizable color selection tool for data visualization charts. Users can now personalize the appearance of their charts by choosing preferred colors, enhancing the visual appeal and adaptability of their presentations or reports.

### Visualization for Linear Model Prediction

- The prediction is based on a linear model fitted to the filtered data within the selected year range. What's more this version provide visualization for the Linear Model Prediction which makes it more clearer for users.



## Features of V1

### Select Extreme Type and Year Range

- Use the sidebar panel to select an extreme type and set a specific year range for data filtering.

### Visualizations

- **Data table:** display filtered data.
- **Histogram:** Shows the distribution of flow data.
- **Density Plot:** Illustrates the density of the flow data.
- **Flow Plot:** Displays the flow data trends over the selected years.

### Download

- Download the filtered data as a CSV file


### SimpleLinear Model Prediction

- A simple linear model prediction based on the selected year.

## Data

The data used in this app is from datateachr [flow_sample](https://github.com/UBC-MDS/datateachr).


## Getting Started

### Prerequisites

- R installed on your system.
- Required R packages: shiny, ggplot2, DT, shinythemes, colourpicker.

### Installation

1. Clone the repository or download the project files.
2. Load the 'flow_sample.rda' dataset in your R environment.

### Running the Application

1. Open the R script containing the Shiny app.
2. Set your working directory to the folder containing the app files.
3. Run the app using the `shiny::runApp()` function.


