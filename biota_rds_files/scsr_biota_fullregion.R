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

# Make a map of the MLPA Study regions without MPAs
sr_boundary.dir <- "/capstone/marinebiomaps/data/MLPA_Study_Regions"
sr_boundaries <- sf::st_read(file.path(sr_boundary.dir, "Marine_Life_Protection_Act_Study_Regions_-_R7_-_CDFW_[ds3178].shp")) |> 
  clean_names() |> 
  st_transform(st_crs(biota)) |> 
  st_make_valid()

# Filter the data to just the scsr boundary
scsr_boundary <- sr_boundaries |> 
  filter(study_regi == "SCSR")

# Filter to Central in the PMEP Data
central_bio <- biota |>
  filter(pmep_region == "3")

# Filter to Southern in the PMEP Data
south_bio <- biota |>
  filter(pmep_region == "4")

# Intersect the PMEP region data with the mpas data
central_bio_mpa <- st_intersection(scsr_boundary, central_bio)
south_bio_mpa <- st_intersection(scsr_boundary, south_bio)

# Combine the two df's that have scsr polygons
scsr_biota_fullregion <- bind_rows(south_bio_mpa, central_bio_mpa)

# Save the rds file into the outputs folder
outputs.dir <- file.path("/capstone/marinebiomaps/data/rds-files")
file_path <- file.path(outputs.dir, "scsr_biota_fullregion.rds")
saveRDS(scsr_biota_fullregion, file = file_path)










