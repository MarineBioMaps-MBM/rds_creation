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
  st_transform(st_crs(biota))

# Filter the data to just the ncsr boundary
ncsr_boundary <- sr_boundaries |> 
  filter(study_regi == "NCSR") |> 
  st_make_valid()

# Intersect the PMEP region data with the ncsr boundary
north_bio_mpa <- st_intersection(ncsr_boundary, north_bio)
central_bio_mpa <- st_intersection(ncsr_boundary, central_bio)

ncsr_bio_central_filtered <- central_bio_mpa |>
  filter(study_regi == "NCSR")

# Combine the two df's that have ncsr polygons
ncsr_biota_fullregion <- bind_rows(north_bio_mpa, ncsr_bio_central_filtered)

# Save the rds file into the outputs folder
outputs.dir <- file.path("/capstone/marinebiomaps/data/rds-files")
file_path <- file.path(outputs.dir, "ncsr_biota_fullregion.rds")
saveRDS(ncsr_biota_fullregion, file = file_path)










