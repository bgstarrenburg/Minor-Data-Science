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
h1 <- read.csv("../data/05b_analysis_file_update.csv")
homeless_data_explaination <- read_xlsx("../data/HUD TO3 - 05b Analysis File - Data Dictionary.xlsx")

#state = "NY"
h1_clean <- data.frame(h1$year, h1$cocnumber, h1$pit_tot_hless_pit_hud, h1$hou_pol_fedfundcoc, h1$hou_pol_fund_project, h1$econ_labor_medinc_acs5yr, h1$econ_labor_emp_pop_BLS, h1$econ_labor_unemp_pop_BLS, h1$econ_labor_unemp_rate_BLS, h1$	
                         dem_soc_ed_bach_acs5yr, h1$dem_soc_ed_hsgrad_acs5yr, h1$dem_soc_ed_lesshs_acs5yr, h1$dem_soc_ed_somecoll_acs5yr)
colnames(h1_clean) <- c("year",
 "cocnumber", 
 "total homeless", 
 "CoC federal funding",
 "count of federal funded projects",
 "median household income",
 "total employed",
  "total unemployed", 
  "unemployment rate in %",
   "education share-bachelors or higher age 25-64 rate in %",
    "education share-high school grad age 25-64  rate in %", 
    "ducation share-less than high school grad age 25-64  rate in %",
     "education share-some college age 25-64  rate in %")


columnNames = c("Amount of Homeless People", "Average unemployment")
rowNames = c("2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019")
stateData = data.frame(matrix(nrow = length(rowNames), ncol = length(columnNames)))
colnames(stateData) = columnNames
rownames(stateData) = rowNames
h1_CA <-  h1_clean[h1_clean$cocnumber %like% "CA", ]
h1_CA_grouped <- h1_CA

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
    
    # get amount of unemployed for the state CA (2010 - 2017)
    CA_unemployment <- aggregate(h1_CA_grouped['total unemployed'], by=h1_CA_grouped['year'], sum)
    
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