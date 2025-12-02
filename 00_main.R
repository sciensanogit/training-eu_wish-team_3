############################################################################### #
# Aim ----
#| generating wastewater reports
# Requires: 
# NOTES:
#| git cheat: git status, git add -A, git commit -m "", git push, git pull, git restore
#|
############################################################################### #

# Load packages ----
# select packages
pkgs <- c("dplyr", "ggplot2")
# install packages
install.packages(setdiff(pkgs, rownames(installed.packages())))
invisible(lapply(pkgs, FUN = library, character.only = TRUE))


# Mission 1_1 ----
# Source member 1 script
source("mission1_1-member1.R")

# Source member 2 script
source("mission1_1-member2.R")

# Source member MG script
source("mission1_1-MG.R")

# Mission 1_2 ----
# produce visuals
source("mission1_2.R")

# Mission 2 ----
# produce reports
source("mission2.R")


