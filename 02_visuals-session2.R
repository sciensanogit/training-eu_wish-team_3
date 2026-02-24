############################################################################### #
# Aim ----
#| produce first graph
# NOTES:
#| list of things to do
############################################################################### #

# load data ----
df <- read.csv("./data/Belgium_export-site-fake.csv", sep = ";") %>%
  mutate(date = as.Date(date))

# set and subset dates
date_reporting <- as.Date("2026-02-01", format = "%Y-%m-%d")
date_graph_start <- as.Date("2025-09-01", format = "%Y-%m-%d")
date_graph_end <- as.Date("2026-09-01", format = "%Y-%m-%d")

df <- df %>%
  filter(date > date_graph_start & date < date_graph_end)

# produce graph ----
plot <- df %>%
  filter(measure == "SARS") %>%
  filter(siteName %in% c("Arlon", "Brussels-North")) %>%
  ggplot(aes(x = date, y = value, group = siteName, color = siteName)) +
  geom_point(na.rm = T)

plot

# create a folder to save graphs
dir.create("./plot", showWarnings = F)

# save
ggsave(file="./plot/graph-sars-arlon-brussels_north.png",
       plot, width = 21, height = 12, dpi = 200)
