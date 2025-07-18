library(readr)
library(ggplot2)
library(dplyr)
library(treemapify)

geo = read_csv("data/intermediate/geo.csv")
loc = read_csv("data/intermediate/local.csv")

dat = inner_join(geo, loc, by = "comuna")

ggplot(dat, aes(area = transactions, fill = hdi, label = commune)) +
    geom_treemap() +
    geom_treemap_text(grow = T, reflow = T) +
    scale_fill_distiller() +
    facet_wrap(~region, ncol = 3) +
    theme_minimal() +
    theme(legend.position = "bottom")

