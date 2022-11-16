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
state = "NY"

columnNames = c("Amount of Homeless People", "Average Income")
rowNames = c("2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019")
stateData = data.frame(matrix(nrow = length(rowNames), ncol = length(columnNames)))
colnames(stateData) = columnNames
rownames(stateData) = rowNames

for (year in rowNames) {
  # get amount of homeless people per year for the state CA
  homelessAmountSheet = read_excel("../data/2007-2021-PIT-Counts-by-State.xlsx", year)
  states = homelessAmountSheet[, "State"]
  totalHomelessAmount = homelessAmountSheet[, paste("Overall Homeless,", year)]
  stateData[year, "Amount of Homeless People"] = totalHomelessAmount[states == state]
  
  # get amount of income per year for the state CA
  averageIncome = averageIncomeSheet[, paste("Income", year)]
  stateData[year, "Average Income"] = averageIncome[averageIncomeStates == state, ]
}

plot(stateData)

model = lm(stateData$`Amount of Homeless People` ~ stateData$`Average Income`)
cor.test(stateData$`Amount of Homeless People`, stateData$`Average Income`)
