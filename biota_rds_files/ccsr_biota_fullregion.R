# Load libraries
librarian::shelf(tidyverse, janitor, sf, terra, tmap, here)

# Read in data from primary substrate and biota RDS
rds.dir <- "/capstone/marinebiomaps/data/rds-files"
biota <- readRDS(file.path(rds.dir, "biota.rds"))

# Ensure it's in a projected CRS (meters)
biota <- st_transform(biota, crs = 32610)

# Calculate area in hectares
biota <- biota |>
  mutate(area_ha = as.numeric(st_area(Shape)) / 10000)

# Filter to Central in the PMEP Data - to avoid invalid polygons and make data more manageable
central_bio <- biota |>
  filter(pmep_region == "3")

# Make a map of the MLPA Study regions without MPAs
sr_boundary.dir <- "/capstone/marinebiomaps/data/MLPA_Study_Regions"
sr_boundaries <- sf::st_read(file.path(sr_boundary.dir, "Marine_Life_Protection_Act_Study_Regions_-_R7_-_CDFW_[ds3178].shp")) |> 
  clean_names() |> 
  st_transform(st_crs(biota))


# Filter the data to just the ccsr boundary
ccsr_boundary <- sr_boundaries |> 
  filter(study_regi == "CCSR")

# intersect ccsr boundary with central bio
ccsr_biota_fullregion <- st_intersection(ccsr_boundary, central_bio)

# Save the rds file into the outputs folder
outputs.dir <- file.path("rds_outputs")
file_path <- file.path(outputs.dir, "ccsr_biota_fullregion.rds")
saveRDS(ccsr_biota_fullregion, file = file_path)


