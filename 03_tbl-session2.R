############################################################################### #
# Aim ----
#| produce tables
# NOTES:
#| git cheat: git status, git add -A, git commit -m "", git push, git pull, git restore
#| list of things to do...
############################################################################### #

# load data ----
df <- read.csv("./data/Belgium_export-site-fake.csv", sep = ";") %>%
  mutate(date = as.Date(date))

# set and subset dates
date_reporting <- as.Date("2026-02-01", format = "%Y-%m-%d")
date_graph_start <- as.Date("2025-09-01", format = "%Y-%m-%d")
date_graph_end <- as.Date("2026-09-01", format = "%Y-%m-%d")

# save table ----
# sars
tbl_bx_sars <- df %>%
  filter(measure == "SARS") %>%
  select(siteName, date, value_pmmv) %>%
  arrange(desc(date)) %>% 
  slice_head(n = 10) %>%
  flextable() %>%
  fontsize(part = "body",size = 10) %>%
  fontsize(part = "header",size = 10) %>%
  autofit() %>% theme_vanilla()

tbl_bx_sars

# Influenza
tbl_bx_influenza <- tbl_bx_sars

# sars
tbl_bx_rsv <- tbl_bx_sars

# display msg
cat("- Success : tables saved \n")
