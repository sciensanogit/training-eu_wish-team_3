# Session 4 (05/05/2026) ----
You can select one of the following options for this session
- Back_to_session_3
- Shiny_basic: focus on shiny
- Shiny_advanced: implement SARS/Flu/RSV in data preparation, visuals, tables, reporting, and shiny

Decide which option your team would like to work on today.
Read the instructions and split the tasks within your team.
Meet regularly to share advancement.

## Back_to_session_3 instructions
- Do the session 3 again.
- Follow instructions in presentation-session3.md

## Shiny_basic instructions
- run 01_data_prep-solution.R code to create ./data/_.csv, ./data/_.rds, and ./data/_.xlsx
- check that Belgium_export-site.csv contains the right data
- Click on the "Run app" button to run app_V1.R and vizualise your dashboard
- Adapt the app_V1.R script to explain what is presented in the "About" tab
- In the "SARS-CoV-2" tab, change the colors of text, xaxis, yaxis, date format and acknowledgement text
- Add a new "Influenza" tab with a text explaining that in 2027 data will be added here
- Add a line to the graph using the color "#BCCF00FF" and the variable value_pmmv_avg14d_past
- At line 10, load the data by site, select appropriate variables and join it to the nation data
- Run app to display changes
- Share your version to your team through github and test apps of developed by others
- Discover how to deploy your shinyapp online on https://www.shinyapps.io/

## Shiny_advanced instructions

### 01_data_prep-solution.R
- run the code to create ./data/_.csv, ./data/_.rds, and ./data/_.xlsx
- check that Belgium_export-site.csv contains the right data
- modify the script to add RSV and Flu to the existing sars data flow
- subset dates after 01/09/2025
- due to the improvement of analytical method, the labProtocolIDs after this date are "SC_COV_5.0", "UA_COV_5.0", "SC_PMMV_3.0", "UA_PMMV_3.0", "SC_INF_2.0", "UA_INF_2.0", "SC_RSV_2.0" and "UA_RSV_2.0"
- import flu data with read.csv("https://data.geo.be/ws/sciensano/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=2.0.0&TYPENAMES=sciensano:wastewatertreatmentplantsinfluenza&outputFormat=csv")
- import rsv data with read.csv("https://data.geo.be/ws/sciensano/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=2.0.0&TYPENAMES=sciensano:wastewatertreatmentplantsrsv&outputFormat=csv")
- match the metadata of ./Belgium_export-nation-sc_flu_rsv-fake.csv

### 02_visuals.R
- load and use ./Belgium_export-nation-sc_flu_rsv-fake.csv until the 01_data_prep.r script is ready
- adapt date_reporting to last Monday, date_graph_start to 01/09/2025, date_graph_end to 01/09/2026
- write a function to save a graph for sars, rsv and flu

### 03_tbl.R
- load and use ./Belgium_export-nation-sc_flu_rsv-fake.csv until the 01_data_prep.R script is ready
- save a table showing last ten dates of the national viral ratio with the last date being the date_reporting defined in 01_data_prep.R
- display only sampling days which are Mondays
- save a table for sars, rsv and flu. this table will be added in the report

### 04_quarto.R
- modify scripts to display the targets in dedicated sections with graphs and tables

### app_V1.R
- Perform the Shiny_basic instructions
- load and use ./Belgium_export-nation-sc_flu_rsv-fake.csv until the 01_data_prep.r script is ready
- Add "Flu", "RSV" tabs displaying the graphs at the national level and at the site level

### Adapt 00_main.R code to
- start doing this 45 min before the session end
- ask each team member to commit their change and push it to the online repository
- source all scripts in the 00_main.R
- make sure to load all packages needed in 00_main.R only
- commit and push the modifications
