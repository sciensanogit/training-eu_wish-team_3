############################################################################### #
# Aim ----
#| generating wastewater reports
# Requires: 
# NOTES:
#| git cheat: git status, git add -A, git commit -m "", git push, git pull, git restore
############################################################################### #

# Load packages ----
# select packages
pkgs <- c("dplyr", "ggplot2", "flextable", "quarto")
# install packages
install.packages(setdiff(pkgs, rownames(installed.packages())))
invisible(lapply(pkgs, FUN = library, character.only = TRUE))

# load epi assessment
main_text <- read.csv("epi_assessment_text.csv")
cat("- Success : text loaded \n")

# Save table ----
tbl_oostende_aalst <- df %>%
  filter(labProtocolID == "SC_COV_4.1") %>%
  filter(measure == "SARS-CoV-2 E gene") %>%
  filter(date > date_graph_start & date < date_reporting) %>%
  filter(siteName %in% c("Aalst", "Oostende")) %>%
  select(siteName, date, measure, value) %>%
  arrange(desc(date)) %>% 
  slice_head(n = 10) %>%
  flextable() %>%
  fontsize(part = "body",size = 10) %>%
  fontsize(part = "header",size = 10) %>%
  autofit() %>% theme_vanilla()

cat("- Success : tables saved \n")

# Render weekly sub report ----
save.image(".RData")

# settings
output_name <- paste0("Report-", format(date_reporting, "%G-W%V"))
format_output <- c("html")
# format_output <- c("html","docx")

quarto_render(input = "mission2.qmd",
              output_file = output_name,
              output_format = format_output)

cat("- Success : quarto render \n")
