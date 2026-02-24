############################################################################### #
# Aim ----
#| generating wastewater reports
# Requires: 
# NOTES:
#| git cheat: git status, git add -A, git commit -m "", git push, git pull, git restore
#|
############################################################################### #

# Load packages ----
# create a folder to save packages
dir.create("./library", showWarnings = F)

# specify the library
.libPaths("./library")

# select packages
pkgs <- c("dplyr", "tidyr", "ggplot2", "zoo", "flextable", "ggplot2", "writexl", "quarto", "shiny", "plotly", "sf")
# install packages
install.packages(setdiff(pkgs, rownames(installed.packages())))
invisible(lapply(pkgs, FUN = library, character.only = TRUE))

# Session 1 ----
# Source member 1 script
source("01_data_prep-session1-member1.R")

# Source member 2 script
source("01_data_prep-session1-member1.R")


