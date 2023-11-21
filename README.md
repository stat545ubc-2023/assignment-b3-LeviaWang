# Water Flow Data Explorer

Welcome to the Water Flow Data Explorer! This Shiny web application allows users to explore, visualize, and analyze water flow data using an intuitive interface.
[flowApp](https://yuehaowang.shinyapps.io/flowApp/).

## Overview

The Water Flow Data Explorer is designed to provide users with the capability to:

- **Explore Data:** Filter and visualize water flow data based on extreme types and specific year ranges.
- **Visualize Data:** View histograms, density plots, and line plots to understand the distribution and trends in the flow data.
- **Download Data:** Obtain filtered data as a CSV file for further analysis.

## Data

The data used in this app is from datateachr [flow_sample](https://github.com/UBC-MDS/datateachr).



## Features

### Select Extreme Type and Year Range

- Use the sidebar panel to select an extreme type and set a specific year range for data filtering.

### Visualizations

- **Data table:** display filtered data.
- **Histogram:** Shows the distribution of flow data.
- **Density Plot:** Illustrates the density of the flow data.
- **Flow Plot:** Displays the flow data trends over the selected years.

### Linear Model Prediction

- Utilizes a simple linear model to predict flow values based on the chosen year.

### Download

- Download the filtered data as a CSV file

## Getting Started

### Prerequisites

- R installed on your system.
- Required R packages: shiny, ggplot2, DT, shinythemes.

### Installation

1. Clone the repository or download the project files.
2. Load the 'flow_sample.rda' dataset in your R environment.

### Running the Application

1. Open the R script containing the Shiny app.
2. Set your working directory to the folder containing the app files.
3. Run the app using the `shiny::runApp()` function.


