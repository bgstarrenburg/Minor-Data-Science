# Per staat
#        | Homeless People | Average Income | Population | Rental vacancy rates | Rent prices
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

#source 
populationSheet = read_excel("../data/Population USA by State 1900-2021.xlsx")
populationStates = averageIncomeSheet[, "State"]$State

#source: https://www.census.gov/housing/hvs/data/rates.html
rentalVacancySheet = read_excel("../data/rental_vacancy_rates.xlsx")
vacancyStates = averageIncomeSheet[, "State"]$State
#state = "NY"

rentPricesSheet = read_excel("../data/Rent Prices USA.xlsx", "Rent per State")
rentPricesStates = rentPricesSheet[, "State"]$State

columnNames = c("Amount of Homeless People", "Average Income", "Population", "Rental vacancy rates", "Rent prices")
rowNames = c("2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019")
stateData = data.frame(matrix(nrow = length(rowNames), ncol = length(columnNames)))
colnames(stateData) = columnNames
rownames(stateData) = rowNames

getCorrelation = function (state) {
  for (year in rowNames) {
    # get amount of homeless people per year
    homelessAmountSheet = read_excel("../data/2007-2021-PIT-Counts-by-State.xlsx", year) #source: https://www.hudexchange.info/resource/3031/pit-and-hic-data-since-2007/
    states = homelessAmountSheet[, "State"]
    totalHomelessAmount = homelessAmountSheet[, paste("Overall Homeless,", year)]
    stateData[year, "Amount of Homeless People"] = totalHomelessAmount[states == state]
    
    # get amount of income per year
    averageIncome = averageIncomeSheet[, paste("Income", year)]
    stateData[year, "Average Income"] = averageIncome[averageIncomeStates == state, ]
    
    # get population per year
    population =  populationSheet[, paste("Population", year)]
    stateData[year, "Population"] = population[populationStates == state, ]
    
    # get population per year
    vacancy =  rentalVacancySheet[, year]
    stateData[year, "Rental vacancy rates"] = vacancy[vacancyStates == state, ]
    
    # get rent prices per year
    rent = rentPricesSheet[, year]
    stateData[year, "Rent prices"] = rent[rentPricesStates == state, ]
  }
  
  print(cor.test(stateData$`Amount of Homeless People`, stateData$`Rent prices`))
  #model = lm(stateData$`Amount of Homeless People` ~ stateData$Population)
  #print(summary(model))
  
}

getCorrelation("NY") 
getCorrelation("MA") 
getCorrelation("FL")