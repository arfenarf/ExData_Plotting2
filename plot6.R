
# This code prepares a plot showing the change in motor vehicle source
# emissions in Baltimore City and Los Angeles County

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

#carve down NEI to include only MV rows from desired cities
NEIcars <- NEI[NEI$SCC %in% SCCcars$SCC, ]
NEIcars <- filter(NEIcars, (fips == "24510" | fips == "06037"))

#join
NEIcars_joined <- left_join(NEIcars, SCCcars, by = "SCC")

# Build data set and create category labels that fit and are still meaningful
q6data <- NEIcars_joined %>% 
        group_by(fips, year) %>% 
        summarise("total" = sum(Emissions)) %>%
        arrange(year) %>% 
        mutate(pctchange = (total - lag(total))/total*100)

# Add real city names
cities <- data.frame(fips = (c("06037", "24510")), 
                     City = (c("Los Angeles County", "Baltimore City")),
                     stringsAsFactors = FALSE)
q6data <- left_join(q6data, cities, by = "fips")

# Set up and plot
ggplot(q6data, aes(year, total)) +
        geom_line(aes(color = City)) +
        xlab("Year") +
        ylab("Total Emissions (tons)") +
        ggtitle("Annual Motor Vehicle Emissions") +
        geom_point(aes(color = City))+
        geom_text(aes(label=ifelse(!is.na(pctchange),
                                paste("(",ifelse(pctchange>0, "+", ""), 
                                      as.character(round(pctchange,1)),"%)", sep = ''),
                                '')),
                                hjust=1, vjust=1, size = 3)

        
ggsave("plot6.png", width=8, height=5, dpi=100)
