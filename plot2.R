
# This code prepares a plot showing the total PM2.5 emission from all sources 
# in Baltimore City for each of the years 1999, 2002, 2005, and 2008.

setwd("~/datacourse/Exploratory/ExData_Plotting2")
require(dplyr)

# Load data from original tables
NEI <- readRDS("../exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("../exdata-data-NEI_data/Source_Classification_Code.rds")

# Transform data to reporting set
q2data <- NEI %>% 
        filter(fips == "24510") %>%
        group_by(year) %>% 
        summarise("Total Emissions" = sum(Emissions))

# Set up and plot
par(mar = c(5.1 4.1 4.1 2.1)
png(filename = "plot2.png")
barplot(q2data$Total, names = q2data$year, xlab = "Year", 
        ylab = "PM2.5 Emissions (tons)", main = "Total Annual PM2.5 Emissions",
        sub = "Baltimore City, MD", ylim = c(0, max(q2data$Total)* 1.1))

#close the file
dev.off()