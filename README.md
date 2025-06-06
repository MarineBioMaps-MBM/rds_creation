# .RDS CREATION
## Author: Bailey Jørgensen
### Contributors: Madison Enda, Michelle Yiv, Cori Lopazanski, Samantha Stevenson-Karl

The repository that houses the scripts ran to generate .rds files to be used throughout the MarineBioMaps MPA analysis. These files will contain data filtered for each study region, for each dataset. 

A quote from the [California Department of Fish and Wildlife website](https://wildlife.ca.gov/Conservation/Marine/MPAs/MLPA):

"For the purposes of MPA planning, a public-private partnership commonly referred to as the MLPA Initiative was established, and the state was split into five distinct regions (four coastal and the San Francisco Bay) each of which had its own MPA planning process." 

These are the 5 study regions utilized by the MBM Team for regional analysis within the state of California. This repository takes the data from the [Pacific Marine and Estuarine Partnership (PMEP)](https://www.pacificfishhabitat.org/data/), and filters it into these regions for use in analysis. These regions are defined as such:

**SCSR** = South Coast Study Region

**NCCSR** = North Central Coast Study Region

**CCSR** = Central Coast Study Region

**NCSR** = North Coast Study Region

**SFBSR** = San Francisco Bay Study Region

The use of these .rds files will standardize the filtering processes done by the team, and will also simplify and shorten the code needed for analysis. The use of these .rds files in analysis also prevents long loading time as a result of the large size of the geospatial PMEP files.

## Data Used
[Pacific Marine and Estuarine Partnership (PMEP) CMECS Nearshore Substrate Data](https://www.pacificfishhabitat.org/data/nearshore-cmecs-substrate-habitat/)

[Pacific Marine and Estuarine Partnership (PMEP) CMECS Nearshore Biotic Data](https://www.pacificfishhabitat.org/data/nearshore-cmecs-biotic-habitat/)

[California Department of Fish and Wildlife MPA Boundaries Shapefile](https://data.ca.gov/dataset/california-marine-protected-areas-ds582)

## File Contents

The R scripts housed in their respective folders will run to create .rds files of each MPA study regions, which will be stored in the rds_outputs folder.

## Repository Structure:
```bash
├── biota_rds_files
│   ├── ccsr_biota.R
│   ├── nccsr_biota.R
│   ├── ncsr_biota.R
│   └── scsr_biota.R
├── substrate_rds_files
│   ├── ccsr_substrate.R
│   ├── nccsr_substrate.R
│   ├── ncsr_substrate.R
│   └── scsr_substrate.R
├── .gitignore
├── foundational_rds_file.R
├── rds_outputs
└── README.md
```


