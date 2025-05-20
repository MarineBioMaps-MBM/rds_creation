# Creating an RDS file for the substrate data for the Central Coast Study Region (CCSR)

# Load libraries
librarian::shelf(tidyverse, janitor, sf, terra, tmap, here)

# Read in data from primary substrate RDS
rds.dir <- "/capstone/marinebiomaps/data/rds-files"
substrate <- readRDS(file.path(rds.dir, "substrate.rds"))

# Ensure it's in a projected CRS (meters)
substrate <- st_transform(substrate, crs = 32610)

# Calculate area in hectares
substrate <- substrate |>
  mutate(area_ha = as.numeric(st_area(Shape)) / 10000)

# Make a map of the MLPA Study regions without MPAs
sr_boundary.dir <- "/capstone/marinebiomaps/data/MLPA_Study_Regions"
sr_boundaries <- sf::st_read(file.path(sr_boundary.dir, "Marine_Life_Protection_Act_Study_Regions_-_R7_-_CDFW_[ds3178].shp")) |> 
  clean_names() |> 
  st_transform(st_crs(substrate)) 

ccsr_boundary <- sr_boundaries |> 
  filter(study_regi == "CCSR")

# Filter to Central in the PMEP Data
central_sub <- substrate |>
  filter(pmep_region == "Central California")

# Intersect the PMEP region data with the sr boundaries data
ccsr_substrate_fullregion <- st_intersection(ccsr_boundary, central_sub)

# Save the rds file into the outputs folder
outputs.dir <- file.path("rds_outputs")
file_path <- file.path(outputs.dir, "ccsr_substrate_fullregion.rds")
saveRDS(ccsr_substrate_fullregion, file = file_path)






