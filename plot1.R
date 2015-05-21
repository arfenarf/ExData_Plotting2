
# This code prepares a plot showing the total PM2.5 emission from all sources 
# for each of the years 1999, 2002, 2005, and 2008.

setwd("~/datacourse/Exploratory/ExData_Plotting2")
require(dplyr)

# Load data from original tables
NEI <- readRDS("../exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("../exdata-data-NEI_data/Source_Classification_Code.rds")

# Transform data to reporting set
q1data <- NEI %>% group_by(year) %>% summarise("Total Emissions" = sum(Emissions))

# Set up and plot
par(mar = c(5.1 4.1 4.1 2.1)
png(filename = "plot1.png")
barplot(q1data$Total, names = q1data$year, xlab = "Year", 
        ylab = "PM2.5 Emissions (tons)", main = "Total Annual PM2.5 Emissions")

#close the file
dev.off()