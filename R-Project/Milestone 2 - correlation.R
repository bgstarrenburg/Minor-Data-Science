# Per staat
#        | Homeless People | Average Income
#       _|
#   2007 |
#   2008 |
#   2009 |
#   2010 |
#   2011 |
#   2012 |
#   2013 |
#   2014 |
#   2015 |
#   2016 |
#   2017 |
#   2018 |
#   2019 |

# install.packages("readxl")
library("readxl")

# get all sheets
averageIncomeSheet = read_excel("../data/Income per Capita by State 1929-2021.xlsx")
averageIncomeStates = averageIncomeSheet[, "State"]$State
#state = "NY"

columnNames = c("Amount of Homeless People", "Average Income")
rowNames = c("2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019")
stateData = data.frame(matrix(nrow = length(rowNames), ncol = length(columnNames)))
colnames(stateData) = columnNames
rownames(stateData) = rowNames

getCorrelation = function (state, title, xTitle, yTitle, sub) {
  for (year in rowNames) {
    # get amount of homeless people per year for the state CA
    homelessAmountSheet = read_excel("../data/2007-2021-PIT-Counts-by-State.xlsx", year) #source: https://www.hudexchange.info/resource/3031/pit-and-hic-data-since-2007/
    states = homelessAmountSheet[, "State"]
    totalHomelessAmount = homelessAmountSheet[, paste("Overall Homeless,", year)]
    stateData[year, "Amount of Homeless People"] = totalHomelessAmount[states == state]
    
    # get amount of income per year for the state CA
    averageIncome = averageIncomeSheet[, paste("Income", year)]
    stateData[year, "Average Income"] = averageIncome[averageIncomeStates == state, ]
  }
  
  model = lm(stateData$`Amount of Homeless People` ~ stateData$`Average Income`)
  print(cor.test(stateData$`Average Income`, stateData$`Amount of Homeless People`))
  print(summary(model))
  
  plot(stateData$`Amount of Homeless People` ~ stateData$`Average Income`,
       main=title, sub = sub, xlab = xTitle, ylab = yTitle
       )
  abline(model, col="steelblue")
  
}

getCorrelation("NY", 
               "Correlation between income and homelesness in the state New York", 
               "Average Income of state (in $)\n", 
               "Amount of homeless people", 
               "sources: https://www.hudexchange.info/resource/3031/pit-and-hic-data-since-2007/ \nhttps://fred.stlouisfed.org/")



#getCorrelation("MA", 
#               "Correlation between income and homelesness in the state Massachusettsk", 
#               "Average Income of state (in $)\n", 
#               "Amount of homeless people", 
#               "sources: https://www.hudexchange.info/resource/3031/pit-and-hic-data-since-2007/ \nhttps://fred.stlouisfed.org/")


getCorrelation("FL", 
               "Correlation between income and homelesness in the state Florida", 
               "Average Income of state (in $)\n", 
               "Amount of homeless people", 
               "sources: https://www.hudexchange.info/resource/3031/pit-and-hic-data-since-2007/ \nhttps://fred.stlouisfed.org/")


#NY, MA & FL goede correlaties