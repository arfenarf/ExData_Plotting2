
# This code prepares a plot showing the total annual emissions for Baltimore
# City, broken down by emissions type.

setwd("~/datacourse/Exploratory/ExData_Plotting2")
require(dplyr)
require(ggplot2)


# Load data from original tables
NEI <- readRDS("../exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("../exdata-data-NEI_data/Source_Classification_Code.rds")

# Transform data to reporting set
q3data <- NEI %>% filter(fips == "24510") %>% group_by(year, type) %>% 
        summarise("total" = sum(Emissions))

# Set up and plot
ggplot(q3data, aes(year, total)) + 
        geom_line(aes(color = type)) + 
        geom_point(aes(color = type)) + 
        xlab("Year") + 
        ylab("Total Emissions (tons)") + 
        ggtitle("Annual PM2.5 Emissions Baltimore City")

ggsave("plot3.png", width=5, height=5, dpi=100)
