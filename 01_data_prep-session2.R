############################################################################### #
# Aim ----
#| load, clean and save data
# NOTES:
#| git cheat: git status, git add -A, git commit -m "", git push, git pull, git restore
#| list of things to do...
############################################################################### #

# load data ----
# Belgian data are available here https://www.geo.be/catalog/details/9eec5acf-a2df-11ed-9952-186571a04de2?l=en
#| Metadata
#| siteName is the name of the treatment plant
#| collDTStart is the date of sampling
#| labName is the name of the lab analysing the sample
#| labProtocolID is the protocol used to analyse the dample
#| flowRate is the flow rate measured at the inlet of the treatment plant during sampling
#| popServ is the population covered by the treatment plant
#| measure is the target measured
#| value is the result

# sars-cov-2 data
df_sc <- read.csv("https://data.geo.be/ws/sciensano/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=2.0.0&TYPENAMES=sciensano:wastewatertreatmentplantscovid&outputFormat=csv")

# load influenza data
df_inf <- read.csv("https://data.geo.be/ws/sciensano/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=2.0.0&TYPENAMES=sciensano:wastewatertreatmentplantsinfluenza&outputFormat=csv")

# load RSV data
df_rsv <- read.csv("https://data.geo.be/ws/sciensano/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=2.0.0&TYPENAMES=sciensano:wastewatertreatmentplantsrsv&outputFormat=csv")

# pmmv data
df_pmmv <- read.csv("https://data.geo.be/ws/sciensano/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=2.0.0&TYPENAMES=sciensano:wastewatertreatmentplantspmmv&outputFormat=csv")

# join both
df <- df_sc %>%
  rbind(df_inf, df_rsv, df_pmmv)

# clean data
df <- df %>%
  select(siteName, collDTStart, labName, labProtocolID, flowRate, popServ, measure, value, quality) %>% 
  rename(date = collDTStart) %>% 
  mutate(date = as.Date(date))

# set and subset dates
# date_reporting <- 
# date_graph_start <- 
# date_graph_end <-

# subset based on labProtocolID used betwen date_start and date_end
# display existing labProtocolID
# unique(df$labProtocolID)

# rename measures
# diplay existing measure
# unique(df$measure)

# translate siteName to english

# apply LOQ provided by the lab

# remove outliers

# normalization ----
# compute mean of replicated analysis of each measure

# pivot to have SARS, Influenza, RSV and PMMV as variables

# pivot again to have SARS, Influenza, RSV in the "measure" variable

# compute viral load (value_load), viral ratio (value_ratio)

# save
df_site_raw <- df

# smoothening ----
# compute the linear extrapolation data

# compute moving average on past 14 days

# save
df_site <- df

# export data ----
# create folder if not existing
dir.create("./data", showWarnings = F)

# export as csv
write.table(df_site_raw, file = "./data/Belgium_export-site_raw.csv", sep = ";", dec = ".",
            col.names = TRUE, row.names = FALSE)

write.table(df_site, file = "./data/Belgium_export-site.csv", sep = ";", dec = ".",
            col.names = TRUE, row.names = FALSE)

# display msg
cat("- Success : data prep \n")
