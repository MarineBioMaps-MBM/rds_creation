# Creating an RDS file for the biota data for the Central Coast Study Region (CCSR)

# Load libraries
librarian::shelf(tidyverse, janitor, sf, terra, tmap, here)

# Read in data from primary substrate and biota RDS
biota <- readRDS(here("data", "biota.rds")) 

# Read in MPA boundaries data
boundary.dir <- "/capstone/marinebiomaps/data/MPA_boundaries"
mpa_boundaries <- sf::st_read(file.path(boundary.dir, "California_Marine_Protected_Areas_[ds582].shp"))

# Clean and transform MPA boundaries data
mpas <- mpa_boundaries |> 
  clean_names() |> 
  st_transform(mpas, crs = 4326) |> 
  st_make_valid()

# Filter to North in the PMEP Data
north_bio <- biota |>
  filter(pmep_region == "2")

# Filter to Central in the PMEP Data
central_bio <- biota |>
  filter(pmep_region == "3")

# Filter to Southern in the PMEP Data
south_bio <- biota |>
  filter(pmep_region == "4")

# Intersect the PMEP region data with the mpas data
north_bio_mpa <- st_intersection(mpas, north_bio)
central_bio_mpa <- st_intersection(mpas, central_bio)
south_bio_mpa <- st_intersection(mpas, south_bio)

# # Filter out CCSR MPAs from PMEP data!
# ccsr_bio_central_filtered <- central_bio_mpa |> 
#   filter(study_regi == "SCSR") 
# 
# # Combine the two df's that have scsr polygons
# scsr_substrate <- bind_rows(south_sub_mpa, ncsr_substrate_central_filtered)

# Save the rds file into the outputs folder
file_path <- file.path(rds_outputs, "ccsr_bio.rds")
saveRDS(ccsr_bio, file = file_path)