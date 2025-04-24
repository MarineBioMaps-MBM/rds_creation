# Creating an RDS file for the substrate data for the North Central Coast Study Region (NCCSR)

# Load libraries
librarian::shelf(tidyverse, janitor, sf, terra, tmap, here)

# Read in data from primary substrate and biota RDS
substrate <- readRDS(here("data", "substrate.rds"))
biota <- readRDS(here("data", "biota.rds")) 

# Read in MPA boundaries data
boundary.dir <- "/capstone/marinebiomaps/data/MPA_boundaries"
mpa_boundaries <- sf::st_read(file.path(boundary.dir, "California_Marine_Protected_Areas_[ds582].shp"))

# Clean and transform MPA boundaries data
mpas <- mpa_boundaries |> 
  clean_names() |> 
  # select("type", "shortname", "geometry") |> 
  st_transform(mpas, crs = 4326) |> 
  st_make_valid()

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

# Filter out NCCSR MPAs from PMEP data!
nccsr_substrate <- central_sub_mpa |> 
  filter(study_regi == "NCCSR") 

# Save the rds file into the outputs folder
file_path <- file.path(rds_outputs, "nccsr_substrate.rds")
saveRDS(nccsr_substrate, file = file_path)