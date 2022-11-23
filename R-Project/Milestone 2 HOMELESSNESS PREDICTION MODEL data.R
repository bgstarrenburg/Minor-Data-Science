library(readxl)
library(dplyr)
library(ggplot2)
library(plotly)



h1 <- read.csv("../data/05b_analysis_file_update.csv")
homeless_data_explaination <- read_xlsx("../data/HUD TO3 - 05b Analysis File - Data Dictionary.xlsx")
homeless_data

h1_clean <- data.frame(h1$year, h1$cocnumber, h1$pit_tot_hless_pit_hud, h1$hou_pol_fedfundcoc, h1$hou_pol_fund_project, h1$econ_labor_medinc_acs5yr, h1$econ_labor_emp_pop_BLS, h1$econ_labor_unemp_pop_BLS, h1$econ_labor_unemp_rate_BLS, h1$	
                         dem_soc_ed_bach_acs5yr, h1$dem_soc_ed_hsgrad_acs5yr, h1$dem_soc_ed_lesshs_acs5yr, h1$dem_soc_ed_somecoll_acs5yr)
colnames(h1_clean) <- c("year", "cocnumber", "total homeless", "CoC federal funding","count of federal funded projects","median household income", "total employed", "total unemployed", "unemployment rate in %", "education share-bachelors or higher age 25-64 rate in %", "education share-high school grad age 25-64  rate in %", "ducation share-less than high school grad age 25-64  rate in %", "education share-some college age 25-64  rate in %")
