
# install.packages("readxl")
# install.packages("writexl")
# install.packages("dplyr")
# install.packages("ggplot2")
# install.packages("plotly")
# install.packages("data.table")
library("readxl")
library("writexl")
library("dplyr")
library("ggplot2")
library("plotly")
library("data.table")

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

housingUnitsSheet = read_excel("../data/housingUnits.xlsx", "Housing Units")
housingUnitsStates = housingUnitsSheet[, "State"]$State

columnNames = c("Amount of Homeless People", 
                "Average Income", 
                "Population", 
                "Rental vacancy rates", 
                "Rent prices", 
                "Housing Units",
                "Unemployment",
                "Federal Funding",
                "High School",
                "Bachelor")

rowNames = c("2010", 
             "2011", 
             "2012", 
             "2013",
             "2014", 
             "2015", 
             "2016", 
             "2017")#, 
             #"2018", 
             #"2019")

stateData = data.frame(matrix(nrow = length(rowNames), ncol = length(columnNames)))
colnames(stateData) = columnNames
rownames(stateData) = rowNames

##### data from niels his file ######
h1 <- read.csv("../data/05b_analysis_file_update.csv")
h1_clean <- data.frame(h1$year, h1$cocnumber, h1$pit_tot_hless_pit_hud, h1$hou_pol_fedfundcoc, h1$hou_pol_fund_project, h1$econ_labor_medinc_acs5yr, h1$econ_labor_emp_pop_BLS, h1$econ_labor_unemp_pop_BLS, h1$econ_labor_unemp_rate_BLS, h1$	
                         dem_soc_ed_bach_acs5yr, h1$dem_soc_ed_hsgrad_acs5yr, h1$dem_soc_ed_lesshs_acs5yr, h1$dem_soc_ed_somecoll_acs5yr)
colnames(h1_clean) <- c("year", "cocnumber", "total homeless", "CoC federal funding","count of federal funded projects","median household income", "total employed", "total unemployed", "unemployment rate in %", "education share-bachelors or higher age 25-64 rate in %", "education share-high school grad age 25-64  rate in %", "ducation share-less than high school grad age 25-64  rate in %", "education share-some college age 25-64  rate in %")
h1Years = h1_clean$year

#####################################


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

    h1_by_state = h1_clean[h1_clean$cocnumber %like% state, ]
    unemployment = aggregate(h1_by_state['total unemployed'], by=h1_by_state['year'], sum)
    year = unemployment$year == year
    stateData[year, 'Unemployment'] = unemployment$`total unemployed`[year]
    
    federalFunding = aggregate(h1_by_state['CoC federal funding'], by=h1_by_state['year'], sum)
    stateData[year, 'Federal Funding'] = federalFunding$`CoC federal funding`[year]
  }
  #corTest = cor.test(stateData$`Amount of Homeless People`, stateData$`Rent prices`)
  #model = lm(stateData$`Amount of Homeless People` ~ stateData$`Rent prices`)
  #plot(stateData$`Amount of Homeless People` ~ stateData$`Rent prices`)
  stateData
}

getCorrelation = function(x, y) {
  cor(x, y)
}

allStateNr = c(1,
2,
4,
#5,
6,
8,
9,
10,
11,
12,
13,
15,
16,
17,
18,
19,
20,
21,
22,
23,
24,
25,
26,
27,
28,
29,
30,
31,
32,
33,
34,
35,
36,
37,
38,
39,
40,
41,
42,
44,
45,
46,
47,
48,
49,
50,
51,
53,
54,
55,
56)

allStates = c('AL',
'AK',
'AZ',
#'AR',
'CA',
'CO',
'CT',
'DE',
'DC',
'FL',
'GA',
'HI',
'ID',
'IL',
'IN',
'IA',
'KS',
'KY',
'LA',
'ME',
'MD',
'MA',
'MI',
'MN',
'MS',
'MO',
'MT',
'NE',
'NV',
'NH',
'NJ',
'NM',
'NY',
'NC',
'ND',
'OH',
'OK',
'OR',
'PA',
'RI',
'SC',
'SD',
'TN',
'UT',
'TX',
'VT',
'VA',
'WA',
'WV',
'WI',
'WY')

correlations = data.frame(matrix(nrow = length(allStates), ncol = 0))
rownames(correlations) = allStates

correlations$StateNr = allStateNr
correlations$State = allStates

for (state in allStates) {
  try({
    print(state)
    data = getData(state)
    x = data$`Amount of Homeless People`
    correlations[state, "Amount of Homeless People"] = x[length(x)]
    
    averageIncome = data$'Average Income'
    correlations[state, "Average Income"] = averageIncome[length(averageIncome)]
    correlation1 = getCorrelation(x, averageIncome)
    correlations[state, 'Homeless people ~ Average Salary'] = correlation1
    
    pop = data$'Population'
    correlations[state, "Population"] = pop[length(pop)]
    correlation2 = getCorrelation(x, pop)
    correlations[state, 'Homeless people ~ Population'] = correlation2
    
    rent = data$'Rent prices'
    correlations[state, "Average Rent"] = rent[length(rent)]
    correlation3 = getCorrelation(x, rent)
    correlations[state, 'Homeless people ~ Rent prices'] = correlation3
    
    housing = data$'Housing Units'
    correlations[state, "Housing Units"] = housing[length(housing)]
    correlation4 = getCorrelation(x, housing)
    correlations[state, 'Homeless people ~ Housing Units'] = correlation4
    
    housingPerPerson = housing / pop
    correlations[state, "Housing Per Person"] = housingPerPerson[length(housing)]
    correlation4 = getCorrelation(x, housingPerPerson)
    correlations[state, 'Homeless people ~ Housing Per Person'] = correlation4

    incomeRent = averageIncome / rent
    correlations[state, "Income ~ rent"] = incomeRent[length(housing)]
    correlation5 = getCorrelation(x, incomeRent)
    correlations[state, 'Homeless people ~ Income / Rent'] = correlation5
    
    unEmployment = data$Unemployment
    correlations[state, "Unemployment"] = unEmployment[length(unEmployment)]
    correlation6 = getCorrelation(x, unEmployment)
    correlations[state, 'Homeless people ~ Unemployment'] = correlation6
    
    funding = data$`Federal Funding`
    correlations[state, "Federal Funding"] = funding[length(funding)]
    correlation7 = getCorrelation(x, funding)
    correlations[state, 'Homeless people ~ Federal Funding'] = correlation7
    
    fundingPH = data$`Federal Funding` / x
    correlations[state, "Federal Funding PH"] = fundingPH[length(funding)]
    correlation8 = getCorrelation(x, fundingPH)
    correlations[state, 'Homeless people ~ Federal Funding PH'] = correlation8
    
  })

}

write_xlsx(correlations,"../data/correlationsResults.xlsx")
