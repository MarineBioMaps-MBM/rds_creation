# Creating an RDS file for the substrate data for the North Coast Study Region (NCSR)

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

# Intersect the PMEP region data with the mpas data
north_sub_mpa <- st_intersection(mpas, north_sub)
central_sub_mpa <- st_intersection(mpas, central_sub)

# Filter out NCSR MPAs from PMEP data!
ncsr_substrate_central_filtered <- central_sub_mpa |> 
  filter(study_regi == "NCSR") 

# Combine the two df's that have ncsr polygons
ncsr_substrate <- bind_rows(north_sub_mpa, ncsr_substrate_central_filtered)

# Save the rds file into the outputs folder
outputs.dir <- file.path("rds_outputs")
file_path <- file.path(outputs.dir, "ncsr_substrate.rds")
saveRDS(ncsr_substrate, file = file_path)



