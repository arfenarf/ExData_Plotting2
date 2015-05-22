
# This code prepares a plot showing the change in motor vehicle source
# emissions in Baltimore City

setwd("~/datacourse/Exploratory/ExData_Plotting2")
require(dplyr)
require(ggplot2)


# Load data from original tables
NEI <- readRDS("../exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("../exdata-data-NEI_data/Source_Classification_Code.rds")

# Transform data to reporting set
## Find motor vehicles in the EI.Sector

SCCcars <- SCC[grep("Mobile - On-Road*", SCC$EI.Sector), ]

## get the factors out of SCC to facilitate merge

SCCcars$SCC <- as.character(SCCcars$SCC)

## Strip out a few needless columns

SCCcars <- select(SCCcars, SCC, EI.Sector, SCC.Level.One, SCC.Level.Two)

NEIcars <- NEI[NEI$SCC %in% SCCcars$SCC, ]
NEIcars_joined <- left_join(NEIcars, SCCcars, by = "SCC")

# Build data set and create category labels that fit and are still meaningful
q5data <- NEIcars_joined %>% 
        group_by(year, EI.Sector) %>% 
        summarise("total" = sum(Emissions)) %>%
        mutate("Source" = as.character(EI.Sector)) %>%
        mutate("Source" = gsub("Mobile - On-Road ", "", Source)) %>%
        mutate("Source" = gsub(" Vehicles", "", Source)) %>%
        arrange(desc(total))

# Set up and plot
ggplot(q5data, aes(year, total)) +
        geom_area(aes(fill = Source, ymax = 1.3 * max(total)), position = "stack") +
        xlab("Year") +
        ylab("Total Emissions (tons)") +
        ggtitle("Baltimore MV Emissions")
        
ggsave("plot5.png", width=8, height=5, dpi=100)
