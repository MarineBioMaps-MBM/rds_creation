# Creating an RDS file for the substrate data and biota foundational data

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
  st_transform(st_crs(substrate)) |> 
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

# Combine the three dfs that have the MPAs substrate data
substrate_in_mpas <- bind_rows(north_sub_mpa, central_sub_mpa, south_sub_mpa)


# Read in data from primary biota RDS
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

# Combine the three dfs that have the MPAs biota data
biota_in_mpas <- bind_rows(north_bio_mpa, central_bio_mpa, south_bio_mpa)

# Save the broad biota rds file into the outputs folder
outputs.dir <- file.path("rds_outputs")
file_path <- file.path(outputs.dir, "biota.rds")
saveRDS(biota, file = file_path)

# Save the rds of the biota within MPAs
file_path0 <- file.path(outputs.dir, "biota_in_mpas")
saveRDS(biota_in_mpas, file = file_path0)

# Save the broad substrate rds file into the outputs folder
file_path1 <- file.path(outputs.dir, "substrate.rds")
saveRDS(substrate, file = file_path1)

# Save the rds of the substrate within MPAs
file_path2 <- file.path(outputs.dir, "substrate_in_mpas")
saveRDS(substrate_in_mpas, file = file_path2)




# Generate the RDS files for the outside MPAs analysis

# # Filter out the parts of sub that intersect with mpas
# north_no_sub <- st_difference(north_sub, mpas)
# central_no_sub <- st_difference(central_sub, mpas)
# south_no_sub <- st_difference(south_sub, mpas)
# 
# # Combine three sub dfs
# substrate_outside_mpas <- bind_rows(north_no_sub, central_no_sub, south_no_sub)
# 
# # Filter out the parts of bio that intersect with mpas
# north_no <- st_difference(north_bio, mpas)
# central_no <- st_difference(central_bio, mpas)
# south_no <- st_difference(south_bio, mpas)
# 
# # Combine three dfs
# biota_outside_mpas <- bind_rows(north_no, central_no, south_no)
# 
# 
# # Save the rds of biota outside MPAs
# file_path3 <- file.path(outputs.dir, "biota_outside_mpas")
# saveRDS(biota_outside_mpas, file = file_path3)
# 
# # Save the rds of the substrate outside MPAs
# file_path4 <- file.path(outputs.dir, "substrate_outside_mpas")
# saveRDS(substrate_outside_mpas, file = file_path4) 
