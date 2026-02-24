############################################################################### #
# Aim ----
#| produce first graph
# NOTES:
#| list of things to do
############################################################################### #

# load data ----
df <- read.csv("./data/Belgium_export-nation.csv", sep = ";") %>%
  mutate(date = as.Date(date))

# set and subset dates
date_reporting <- as.Date("2026-02-01", format = "%Y-%m-%d")
date_graph_start <- as.Date("2025-09-01", format = "%Y-%m-%d")
date_graph_end <- as.Date("2026-09-01", format = "%Y-%m-%d")

df <- df %>%
  filter(date > date_graph_start & date < date_graph_end)

# produce graph ----
for (i in unique(df$measure)){
  # i <- "SARS"
  plot <- df %>%
    filter(measure == i) %>%
    ggplot(aes(x = date)) +
    geom_point(aes(y = value_pmmv), colour = "#92D050", size = 1, na.rm = T) +
    geom_line(aes(y = value_pmmv_avg14d_past), colour = "#BCCF00FF", linewidth = 0.5, na.rm = T) +
    scale_y_continuous(limits = c(0, NA)) +
    labs(x = "", y = paste(i, "viral ratio (c/c)")) +
    theme_minimal(base_size = 14)
  
  # plot
  
  # create a folder to save graphs
  dir.create("./plot", showWarnings = F)
  
  # save
  ggsave(file = paste0("./plot/graph-",i ,"-nation.png"),
         plot, width = 21, height = 12, dpi = 200)
}

# produce map ----
df <- read.csv("./data/Belgium_export-site.csv", sep = ";") %>%
  mutate(date = as.Date(date))

# load shape files
shp_belgium <- st_read("./data/belgium.shp", quiet = T)
shp_province <- st_read("./data/province.shp", quiet = T)
shp_wwtp <- st_read("./data/wwtp_2023.shp", quiet = T)

# translate names of wwtp
shp_wwtp[shp_wwtp$name == "Bruxelles-Sud", ]$name <- "Brussels-South"
shp_wwtp[shp_wwtp$name == "Bruxelles-Nord", ]$name <- "Brussels-North"

# select wwtp
shp_wwtp <- shp_wwtp %>%
  filter(name %in% unique(df_site$siteName))

# define levels for last date
df <- df %>%
  filter(date == max(date)) %>%
  mutate(value_pmmv = as.numeric(value_pmmv)*1E6,
         activity_level = case_when(
    measure == "SARS" ~
      cut(value_pmmv, breaks = c(-Inf, 1150, 2390, 5070, Inf),
          labels = c("Green", "Yellow", "Orange", "Red"),
          right = T),
    measure == "RSV" ~
      cut(value_pmmv, breaks = c(-Inf, 112, 253, 507, Inf),
          labels = c("Green", "Yellow", "Orange", "Red"),
          right = T),
    measure == "Influenza" ~
      cut(value_pmmv, breaks = c(-Inf, 84, 276, 569, Inf),
          labels = c("Green", "Yellow", "Orange", "Red"),
          right = T)))

# if value_pmmv is NA then activity_level is "Grey"
df[is.na(df$value_pmmv), ]$activity_level <- "Grey"

# function to plot map
fct_map <- function(result_in, shp_wwp_in, measure_in){
  # result_in <- df
  # shp_wwp_in <- shp_wwtp
  # measure_in <- "SARS"
  
  # select relevant variables
  df1 <- result_in %>%
    filter(measure == measure_in) %>%
    select(siteName, activity_level) %>%
    rename(name = siteName)
  # join with shape files
  shp_wwp_level <- shp_wwp_in %>%
    left_join(df1, by = "name") %>%
    filter(name!= "Brussels Airport")
  # produce the graph
  plot <- ggplot() +
    geom_sf(data = shp_belgium, fill = "white", color = "#563b8c", linewidth = 1.3) +
    geom_sf(data = shp_province, fill = "white", color = "#563b8c", linewidth = 1.3) +
    geom_sf(data = shp_wwp_level, aes(fill = activity_level), color = alpha("white", 0.5), alpha = 0.8, linewidth = 1.3+0.2) +
    scale_fill_identity() +
    theme_void() +
    theme(plot.background = element_rect(fill='white', colour='white'))
  
  # plot
  
  # save the graph
  ggsave(file = paste0("./plot/graph-map_level-", measure_in, ".png"),
         plot, width = 18, height = 13, dpi = 200)
}

# save map for 3 targets
invisible(lapply(c("SARS", "Influenza", "RSV"), fct_map,
                 result_in = df, shp_wwp_in = shp_wwtp))
