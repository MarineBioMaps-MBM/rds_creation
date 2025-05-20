# Creating an RDS file for the substrate data for the South Coast Study Region (SCSR)

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
  st_transform(st_crs(substrate)) |> 
  st_make_valid()

# Filter to scsr
scsr_boundary <- sr_boundaries |> 
  filter(study_regi == "SCSR")

# Filter to Central in the PMEP Data
central_sub <- substrate |>
  filter(pmep_region == "Central California")

# Filter to Southern in the PMEP Data
south_sub <- substrate |>
  filter(pmep_region == "Southern California Bight")

# Intersect the PMEP region data with the mpas data
central_sub_scsr <- st_intersection(scsr_boundary, central_sub)
south_sub_scsr <- st_intersection(scsr_boundary, south_sub)

# Combine the two df's that have scsr polygons
scsr_substrate_fullregion <- bind_rows(south_sub_scsr, central_sub_scsr)

# Save the rds file into the outputs folder
outputs.dir <- file.path("/capstone/marinebiomaps/data/rds-files")
file_path <- file.path(outputs.dir, "scsr_substrate_fullregion.rds")
saveRDS(scsr_substrate_fullregion, file = file_path)








