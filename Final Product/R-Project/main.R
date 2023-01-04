#######################
# Installing packages #
#######################

install.packages("readxl")
install.packages("dplyr")
install.packages("data.table")
install.packages("rjson")

###################
# adding packages #
###################

library("readxl")
library("dplyr")
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

# rental vacancy rates
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

# Analysis Sheet
analysisSheet <- read.csv("../data/05b_analysis_file_update.csv")


###########################
# initializing dataframes #
###########################

#standard stateData dataframe
columnNames = c("Amount of Homeless People", 
                "Average Income", 
                "Population", 
                "Rental vacancy rates", 
                "Average Rent prices", 
                "Housing Units",
                "Unemployment",
                "Federal Funding")
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
analysisSheet_clean <- data.frame(analysisSheet$year, analysisSheet$cocnumber, analysisSheet$pit_tot_hless_pit_hud, analysisSheet$hou_pol_fedfundcoc, analysisSheet$hou_pol_fund_project, analysisSheet$econ_labor_medinc_acs5yr, analysisSheet$econ_labor_emp_pop_BLS, analysisSheet$econ_labor_unemp_pop_BLS, analysisSheet$econ_labor_unemp_rate_BLS, analysisSheet$	
                                    dem_soc_ed_bach_acs5yr, analysisSheet$dem_soc_ed_hsgrad_acs5yr, analysisSheet$dem_soc_ed_lesshs_acs5yr, analysisSheet$dem_soc_ed_somecoll_acs5yr)
colnames(analysisSheet_clean) <- c("year", "cocnumber", "total homeless", "CoC federal funding","count of federal funded projects","median household income", "total employed", "total unemployed", "unemployment rate in %", "education share-bachelors or higher age 25-64 rate in %", "education share-high school grad age 25-64  rate in %", "ducation share-less than high school grad age 25-64  rate in %", "education share-some college age 25-64  rate in %")

##all data list
allStates = c('AL','AK','AZ','CA','CO','CT','DE','DC','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','UT','TX','VT','VA','WA','WV','WI','WY')

allData = list()

###########
# methods #
###########

getData = function (state) {
  for (year in rowNames) {
    # get amount of homeless people per year
    homelessAmountSheet = read_excel("../data/2007-2021-PIT-Counts-by-State.xlsx", year)
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
    stateData[year, "Average Rent prices"] = rent[rentPricesStates == state, ]
    
    # get housing units per year
    rent = housingUnitsSheet[, year]
    stateData[year, "Housing Units"] = rent[housingUnitsStates == state, ]
    
    analysis_by_state = analysisSheet_clean[analysisSheet_clean$cocnumber %like% state, ]
    unemployment = aggregate(analysis_by_state['total unemployed'], by=analysis_by_state['year'], sum)
    year = unemployment$year == year
    stateData[year, 'Unemployment'] = unemployment$`total unemployed`[year]
    
    federalFunding = aggregate(analysis_by_state['CoC federal funding'], by=analysis_by_state['year'], sum)
    stateData[year, 'Federal Funding'] = federalFunding$`CoC federal funding`[year] * 1000
  }
    
  stateData
}

##########################
# get all data to a list #
##########################

for (state in allStates) {
  try({
    print(state)
    data = getData(state)
    stateDataEntry = list(data)
    allData = c(allData, stateDataEntry)
  })
}

##########
# output #
##########

jsonData <- toJSON(allData)
write(jsonData, "../data/parsedData.json") 