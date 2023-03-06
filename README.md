# ps6-shinyapp-damidia
This code is a Shiny application that displays data from the University of Alabama Huntsville (UAH) lower troposphere temperature dataset. The dataset contains monthly temperature measurements for different regions of the world, from January 1979 to present. The data is stored in a tab-delimited file.

The fluidPage() method from the shiny package is used to define the application's user interface (UI). Three tabs are present in the UI: About, Plots, and Table.

The About page presents a random sample of the data in a table format and gives some background information about the data.


The user can choose regions of interest on the Plots tab, which then shows a scatterplot of temperature variations from the baseline period of 1991–2020 for those places. Moreover, the user has the option of choosing a color scheme and whether to show trendlines on the scatterplot.
Depending on the user's choice, the Table tab shows a table of average temperature variances for each month or year.

When displaying output to the user, the renderText() and renderTable() APIs are utilized. The scatterplot is generated based on user input using the renderPlot() function. Many widgets, including selectInput(), checkboxInput(), and radioButtons(), are used to build the user interface and enable the user to select and interact with the data.

The UAH lower troposphere temperature dataset can be explored and visualized using the Shiny application defined by this code.

Link to project: https://adamidi.shinyapps.io/shinyapp-ps6/
