
# This code prepares a plot showing the change in coal-combustion source
# emissions 

setwd("~/datacourse/Exploratory/ExData_Plotting2")
require(dplyr)
require(ggplot2)


# Load data from original tables
NEI <- readRDS("../exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("../exdata-data-NEI_data/Source_Classification_Code.rds")

# Transform data to reporting set
## Find combustion *and* coal in the SCC Short Names

comb <- SCC[grep("* Comb *", SCC$Short.Name), ]
SCCcoal <- comb[grep("* Coal*", comb$Short.Name), ]

## get the factors out of SCC to facilitate merge
SCCcoal$SCC <- as.character(SCCcoal$SCC)

## Strip out a few needless columns

SCCcoal <- select(SCCcoal, SCC, EI.Sector, SCC.Level.One, SCC.Level.Two)

## Index and merge
NEIcoal <- NEI[NEI$SCC %in% SCCcoal$SCC, ]
NEIcoal_joined <- left_join(NEIcoal, SCCcoal, by = "SCC")


q4data <- NEIcoal_joined %>% 
        group_by(year, EI.Sector) %>% 
        summarise(total_emissions = sum(Emissions)) %>%
        mutate(cropped_emissions = total_emissions/1000) %>% #get to human-friendly units
        arrange(desc(cropped_emissions)) %>%                 #stack it well
        mutate("Source" = as.character(EI.Sector)) %>%       #make a nice label
        mutate("Source" = gsub("Fuel Comb - ", "", Source))

# Set up and plot
ggplot(q4data, aes(year, cropped_emissions)) +
        geom_area(aes(fill = Source, ymax = 1.3 * max(cropped_emissions)), position = "stack") +
        xlab("Year") +
        ylab("Total Emissions (1000s of tons)") +
        ggtitle("Coal-Combustion Emissions") 


ggsave("plot4.png", width=8, height=5, dpi=100)
