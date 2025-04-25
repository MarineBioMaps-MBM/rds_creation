# Creating an RDS file for the substrate data for the Central Coast Study Region (CCSR)

# Load libraries
librarian::shelf(tidyverse, janitor, sf, terra, tmap, here)

# Read in data from primary substrate RDS
rds.dir <- "/Users/bjorgensen/bathydata/"
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

# Filter to North in the PMEP Data
north_sub <- substrate |>
  filter(pmep_region == "Pacific Northwest")

# Filter to Central in the PMEP Data
central_sub <- substrate |>
  filter(pmep_region == "Central California")

# Filter to Southern in the PMEP Data
south_sub <- substrate |>
  filter(pmep_region == "Southern California Bight")

# Intersect the PMEP region data with the mpas data
north_sub_mpa <- st_intersection(mpas, north_sub)
central_sub_mpa <- st_intersection(mpas, central_sub)
south_sub_mpa <- st_intersection(mpas, south_sub)

# Filter out CCSR MPAs from PMEP data!
ccsr_substrate <- central_sub_mpa |> 
  filter(study_regi == "CCSR") 

# Save the rds file into the outputs folder
outputs.dir <- file.path("rds_outputs")
file_path <- file.path(outputs.dir, "ccsr_substrate.rds")
saveRDS(ccsr_substrate, file = file_path)

