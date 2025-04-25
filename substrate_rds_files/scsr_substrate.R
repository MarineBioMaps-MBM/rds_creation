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
central_sub <- substrate |>
  filter(pmep_region == "Central California")

# Filter to Southern in the PMEP Data
south_sub <- substrate |>
  filter(pmep_region == "Southern California Bight")

# Intersect the PMEP region data with the mpas data
central_sub_mpa <- st_intersection(mpas, central_sub)
south_sub_mpa <- st_intersection(mpas, south_sub)

# Filter out SCSR MPAs from PMEP data!
scsr_substrate_central_filtered <- central_sub_mpa |> 
  filter(study_regi == "SCSR") 

# Combine the two df's that have scsr polygons
scsr_substrate <- bind_rows(south_sub_mpa, ncsr_substrate_central_filtered)

# Save the rds file into the outputs folder
outputs.dir <- file.path("rds_outputs")
file_path <- file.path(outputs.dir, "scsr_substrate.rds")
saveRDS(scsr_substrate, file = file_path)


