
# This code prepares a plot showing the total PM2.5 emission from all sources 
# for each of the years 1999, 2002, 2005, and 2008.

setwd("~/datacourse/Exploratory/ExData_Plotting2")
require(dplyr)

# Load data from original tables
NEI <- readRDS("../exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("../exdata-data-NEI_data/Source_Classification_Code.rds")

# Transform data to reporting set
q1data <- NEI %>% 
        group_by(year) %>% 
        summarise("total_emissions" = sum(Emissions)) %>%
        mutate(total_emissions, "cropped_emissions" = total_emissions/1000)
        # 'cropped_emissions' creates a more friendly y-axis scale

# Set up and plot
par(mar = c(5.1 4.1 4.1 2.1)
png(filename = "plot1.png")
barplot(q1data$cropped_emissions, names = q1data$year, xlab = "Year", 
        ylab = "PM2.5 Emissions (1000s of tons)", main = "Total Annual PM2.5 Emissions",
        ylim = c(0,8000))

#close the file
dev.off()