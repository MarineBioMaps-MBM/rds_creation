# Creating an RDS file for the biota data for the South Coast Study Region (SCSR)

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

# Read in MPA boundaries data
boundary.dir <- "/capstone/marinebiomaps/data/MPA_boundaries"
mpa_boundaries <- sf::st_read(file.path(boundary.dir, "California_Marine_Protected_Areas_[ds582].shp"))

# Clean and transform MPA boundaries data
mpas <- mpa_boundaries |> 
  clean_names() |> 
  st_transform(st_crs(biota)) |> 
  st_make_valid() |> 
  rename(hectares_mpa = hectares)

# Filter to Central in the PMEP Data
central_bio <- biota |>
  filter(pmep_region == "3")

# Filter to Southern in the PMEP Data
south_bio <- biota |>
  filter(pmep_region == "4")

# Intersect the PMEP region data with the mpas data
central_bio_mpa <- st_intersection(mpas, central_bio)
south_bio_mpa <- st_intersection(mpas, south_bio)

# Filter out CCSR MPAs from PMEP data!
scsr_bio_central_filtered <- central_bio_mpa |>
  filter(study_regi == "SCSR")

# Combine the two df's that have scsr polygons
scsr_bio <- bind_rows(south_bio_mpa, scsr_bio_central_filtered)

# Save the rds file into the outputs folder
outputs.dir <- file.path("rds_outputs")
file_path <- file.path(outputs.dir, "scsr_biota.rds")
saveRDS(scsr_bio, file = file_path)