#######################
# Installing packages #
#######################

# install.packages("readxl")
# install.packages("writexl")
# install.packages("dplyr")
# install.packages("ggplot2")
# install.packages("plotly")
# install.packages("data.table")
# install.packages("rjson")

###################
# adding packages #
###################

library("readxl")
library("writexl")
library("dplyr")
library("ggplot2")
library("plotly")
library("data.table")
library("rjson")

################
# loading data #
################

#average income
averageIncomeSheet = read_excel("../data/Income per Capita by State 1929-2021.xlsx")
averageIncomeStates = averageIncomeSheet[, "State"]$State

#population
populationSheet = read_excel("../data/Population USA by State 1900-2021.xlsx")
populationStates = averageIncomeSheet[, "State"]$State

# rental vacancy rates - source: https://www.census.gov/housing/hvs/data/rates.html
rentalVacancySheet = read_excel("../data/rental_vacancy_rates.xlsx")
vacancyStates = averageIncomeSheet[, "State"]$State

#rent prices
rentPricesSheet = read_excel("../data/Rent Prices USA.xlsx", "Rent per State")
rentPricesStates = rentPricesSheet[, "State"]$State

#housing units
housingUnitsSheet = read_excel("../data/housingUnits.xlsx", "Housing Units")
housingUnitsStates = housingUnitsSheet[, "State"]$State

#analysis sheets - used for multiple values
analysisSheet <- read.csv("../data/05b_analysis_file_update.csv")

##########################
# initializing variables #
##########################

#standart stateData dataframe
columnNames = c("Amount of Homeless People", 
                "Average Income", 
                "Population", 
                "Rental vacancy rates", 
                "Rent prices", 
                "Housing Units",
                "Unemployment",
                "Federal Funding",
                "Federal Funding PH")
rowNames = c("2010", 
             "2011", 
             "2012", 
             "2013",
             "2014", 
             "2015", 
             "2016", 
             "2017")
stateData = data.frame(matrix(nrow = length(rowNames), ncol = length(columnNames)))
colnames(stateData) = columnNames
rownames(stateData) = rowNames

#cleaned analysis dataframe
analysisSheet_clean <- data.frame(h1$year, h1$cocnumber, h1$pit_tot_hless_pit_hud, h1$hou_pol_fedfundcoc, h1$hou_pol_fund_project, h1$econ_labor_medinc_acs5yr, h1$econ_labor_emp_pop_BLS, h1$econ_labor_unemp_pop_BLS, h1$econ_labor_unemp_rate_BLS, h1$	
                                    dem_soc_ed_bach_acs5yr, h1$dem_soc_ed_hsgrad_acs5yr, h1$dem_soc_ed_lesshs_acs5yr, h1$dem_soc_ed_somecoll_acs5yr)
colnames(analysisSheet_clean) <- c("year", "cocnumber", "total homeless", "CoC federal funding","count of federal funded projects","median household income", "total employed", "total unemployed", "unemployment rate in %", "education share-bachelors or higher age 25-64 rate in %", "education share-high school grad age 25-64  rate in %", "ducation share-less than high school grad age 25-64  rate in %", "education share-some college age 25-64  rate in %")

##Correlations dataframe
allStateNr = c(1,2,4,6,8,9,10,11,12,13,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,44,45,46,47,48,49,50,51,53,54,55,56)
allStates = c('AL','AK','AZ','CA','CO','CT','DE','DC','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','UT','TX','VT','VA','WA','WV','WI','WY')
#(note AR is not used in many datasets, so left out)

correlations = data.frame(matrix(nrow = length(allStates), ncol = 0))
rownames(correlations) = allStates

correlations$StateNr = allStateNr
correlations$State = allStates

allData = list()

###########
# methods #
###########

getData = function (state) {
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
    stateData[year, "Population"] = population[populationStates == state, ] * 1000
    
    # get population per year
    vacancy =  rentalVacancySheet[, year]
    stateData[year, "Rental vacancy rates"] = vacancy[vacancyStates == state, ]
    
    # get rent prices per year
    rent = rentPricesSheet[, year]
    stateData[year, "Rent prices"] = rent[rentPricesStates == state, ]
    
    # get housing units per year
    rent = housingUnitsSheet[, year]
    stateData[year, "Housing Units"] = rent[housingUnitsStates == state, ]
    
    analysis_by_state = analysisSheet_clean[analysisSheet_clean$cocnumber %like% state, ]
    unemployment = aggregate(analysis_by_state['total unemployed'], by=analysis_by_state['year'], sum)
    year = unemployment$year == year
    stateData[year, 'Unemployment'] = unemployment$`total unemployed`[year]
    
    federalFunding = aggregate(analysis_by_state['CoC federal funding'], by=analysis_by_state['year'], sum)
    stateData[year, 'Federal Funding'] = federalFunding$`CoC federal funding`[year]
    
    federalFundingPH = federalFunding$`CoC federal funding`[year] / totalHomelessAmount[states == state]
    stateData[year, 'Federal Funding PH'] = federalFundingPH
  }
  #corTest = cor.test(stateData$`Amount of Homeless People`, stateData$`Rent prices`)
  #model = lm(stateData$`Amount of Homeless People` ~ stateData$`Rent prices`)
  #plot(stateData$`Amount of Homeless People` ~ stateData$`Rent prices`)
  stateData
}

getCorrelation = function(x, y) {
  cor(x, y)
}

###########################################
# get correlations + all data to a vector #
###########################################

for (state in allStates) {
  try({
    print(state)
    data = getData(state)
    stateDataEntry = list(data)
    allData = c(allData, stateDataEntry)
    
    x = data$`Amount of Homeless People`
    #correlations[state, "Amount of Homeless People"] = x[length(x)]
    
    averageIncome = data$'Average Income'
    #correlations[state, "Average Income"] = averageIncome[length(averageIncome)]
    correlation1 = getCorrelation(x, averageIncome)
    correlations[state, 'Homeless people ~ Average Salary'] = correlation1
    
    pop = data$'Population'
    #correlations[state, "Population"] = pop[length(pop)]
    correlation2 = getCorrelation(x, pop)
    correlations[state, 'Homeless people ~ Population'] = correlation2
    
    rent = data$'Rent prices'
    #correlations[state, "Average Rent"] = rent[length(rent)]
    correlation3 = getCorrelation(x, rent)
    correlations[state, 'Homeless people ~ Rent prices'] = correlation3
    
    housing = data$'Housing Units'
    #correlations[state, "Housing Units"] = housing[length(housing)]
    correlation4 = getCorrelation(x, housing)
    correlations[state, 'Homeless people ~ Housing Units'] = correlation4
    
    housingPerPerson = housing / pop
    #correlations[state, "Housing Per Person"] = housingPerPerson[length(housing)]
    correlation4 = getCorrelation(x, housingPerPerson)
    correlations[state, 'Homeless people ~ Housing Per Person'] = correlation4
    
    incomeRent = averageIncome / rent
    #correlations[state, "Income ~ rent"] = incomeRent[length(housing)]
    correlation5 = getCorrelation(x, incomeRent)
    correlations[state, 'Homeless people ~ Income / Rent'] = correlation5
    
    unEmployment = data$Unemployment
    #correlations[state, "Unemployment"] = unEmployment[length(unEmployment)]
    correlation6 = getCorrelation(x, unEmployment)
    correlations[state, 'Homeless people ~ Unemployment'] = correlation6
    
    funding = data$`Federal Funding`
    #correlations[state, "Federal Funding"] = funding[length(funding)]
    correlation7 = getCorrelation(x, funding)
    correlations[state, 'Homeless people ~ Federal Funding'] = correlation7
    
    fundingPH = data$`Federal Funding PH`
    #correlations[state, "Federal Funding PH"] = fundingPH[length(funding)]
    correlation8 = getCorrelation(x, fundingPH)
    correlations[state, 'Homeless people ~ Federal Funding PH'] = correlation8
  })
}

#####################
# Correlation graph #
#####################

x = 1:50
y1 = sort(correlations$`Homeless people ~ Average Salary`)
y2 = sort(correlations$`Homeless people ~ Population`)
y3 = sort(correlations$`Homeless people ~ Rent prices`)
y4 = sort(correlations$`Homeless people ~ Federal Funding PH`)
plot(x, y1, type='l', col='blue', phc='o', ylab='correlation value between -1 and 1', xlab="states", ylim = c(-1, 1))

#points(x, y2, col='red', pch='*')
lines(x, y2, col='red')

#points(x, y3, col='dark red', pch='*')
lines(x, y3, col='dark red')

#points(x, y4, col='green', pch='*')
lines(x, y4, col='green')

title("Correlation values related to Homelesness per State")
legend(0, 1, legend=c("Average Salary", "Population", "Rent Prices", "Federal Funding PH"), fill= c("blue", "red", "dark red", "green"))
abline(h = 0)

##########
# output #
##########

jsonData <- toJSON(allData)
write(jsonData, "../data/parsedData.json") 

write_xlsx(correlations,"../data/correlationsResults.xlsx")
