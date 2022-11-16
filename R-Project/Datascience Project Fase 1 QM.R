install.packages("readxl")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("plotly")

library(readxl)
library(dplyr)
library(ggplot2)
library(plotly)

#Data uit excel bestanden halen
Population <- read_xlsx("../data/Population USA by State 1900-2021.xlsx")
Income <- read_xlsx("../data/Income per Capita by State 1929-2021.xlsx")
Homelessness <- read_xlsx("../data/2007-2021-PIT-Counts-by-State.xlsx")

#Nieuwe dataframe aanmaken die de benodigde data uit twee datasets samenvoegd
TestUSa <- merge(Population[,c(1:2,124)],Homelessness[,c(1,51)],by="State")
colnames(TestUSa) <- c("State","Abbreviation","Population(x1000)","Sheltered Homless Population")
TestUSa <- TestUSa %>%
  mutate(Rate = ((TestUSa$`Sheltered Homless Population`/(TestUSa$`Population(x1000)`*1000)*100)))%>%
  arrange(desc(`Sheltered Homless Population`))

TopHomeless <- TestUSa %>%
  slice(1:10)

#Nieuwe dataframe aanmaken die ook de derde dataset toevoegd aan de gezamelijke dataframe
USADATA <- merge(TestUSa, Income[,c(2,95)],by ="State")
colnames(USADATA) <- c("State","Abbreviation","Population(x1000)","Sheltered Homless Population", "Rate", "Avg Income")
USADATA <- USADATA %>%
  arrange(desc(Rate)) 

TopRate <- USADATA %>%
  slice(1:10)

#Graph 1: Homelessness 2007-2021

#Graph 2: Bar chart Homelessness per state (Top 10)
TopHomeless <- TopHomeless                                                 # Replicate original data
TopHomeless$State <- factor(TopHomeless$State,                                    # Factor levels in decreasing order
                  levels = TopHomeless$State[order(TopHomeless$`Sheltered Homless Population`, decreasing = TRUE)])
p<-ggplot(TopHomeless, aes(TopHomeless$State, TopHomeless$`Sheltered Homless Population`,fill=State)) +                                    # Decreasingly ordered barchart
  geom_bar(stat = "identity")+  scale_fill_brewer(palette = "Spectral")

S<- p +
  theme(text = element_text(color = "navy"),
        panel.background = element_rect(fill = "white"),
        panel.grid.major.y = element_line(color = "grey"),
        panel.grid.minor.y = element_line(color = "grey", 
                                          linetype = "dashed"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        strip.background = element_rect(fill = "white", color="grey"))
print(S + ggtitle("Top 10 States with the most Sheltered Homeless People in 2021") + labs(y = "Number of Sheltered Homeless People", x = "State"))

#Graph 3: Bar Chart Homelessness Per state (Top 10) based on Homelessness Rate
TopRate <- TopRate                                                 # Replicate original data
TopRate$State <- factor(TopRate$State,                                    # Factor levels in decreasing order
                            levels = TopRate$State[order(TopRate$Rate, decreasing = TRUE)])
p<-ggplot(TopRate, aes(TopRate$State, TopRate$Rate,fill=State)) +                                    # Decreasingly ordered barchart
  geom_bar(stat = "identity")+  scale_fill_brewer(palette = "Paired")

S<- p +
  theme(text = element_text(color = "navy"),
        panel.background = element_rect(fill = "white"),
        panel.grid.major.y = element_line(color = "grey"),
        panel.grid.minor.y = element_line(color = "grey", 
                                          linetype = "dashed"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        strip.background = element_rect(fill = "white", color="grey"))
print(S + ggtitle("Top 10 States with the Highest Homelessness Rate in 2021") + labs(y = "Homelessness Rate", x = "State"))

#Graph 4: Correlation scatter plot Homelessness and Population, Income and housing prices (3 separate Graphs)
model <- lm(USADATA$`Sheltered Homless Population`~USADATA$`Population(x1000)`)
plot(USADATA$`Sheltered Homless Population`~USADATA$`Population(x1000)`)
abline (model)
summary(model)

model1 <- lm(USADATA$`Sheltered Homless Population`~USADATA$`Avg Income`)
plot(USADATA$`Sheltered Homless Population`~USADATA$`Avg Income`)
abline (model1)
summary(model1)

#Tests 
scatter.smooth(USADATA$`Avg Income`,USADATA$`Sheltered Homless Population`)
  
cor.test(TestUSa$`Population(x1000)`,TestUSa$`Sheltered Homless Population`)

ggplot(TestUSa, aes(TestUSa$`Population(x1000)`,TestUSa$`Sheltered Homless Population` )) + geom_point() + ggtitle('Scatter Plot of Homelessness Data')

p <- TestUSa %>%
  ggplot(aes(`Population(x1000)`,`Sheltered Homless Population`, size =`Population(x1000)`, color = State, )) +
  geom_point() +
  theme_bw()
ggplotly(p)

