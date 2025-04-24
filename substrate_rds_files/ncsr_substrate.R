# Creating an RDS file for the substrate data for the North Coast Study Region (NCSR)

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

# Filter out NCSR MPAs from PMEP data!
ncsr_substrate_central_filtered <- central_sub_mpa |> 
  filter(study_regi == "NCSR") 

# Combine the two df's that have ncsr polygons
ncsr_substrate <- bind_rows(north_sub_mpa, ncsr_substrate_central_filtered)

# Save the rds file into the outputs folder
file_path <- file.path(rds_outputs, "ncsr_substrate.rds")
saveRDS(ncsr_substrate, file = file_path)



