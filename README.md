# GRASS Based Tools

## Command Line Tools
All of the tools below run in a container.  GRASS need not be installed locally.  Docker is required. 

+ `slope_geomorph.sh`  -  Calculates geomorphons based on slope, Creates a boolean raster where forms 9 and 10 (pits and valleys) are true, then performs neighborhood summation.  Returns a geoTiff.  &ensp; USAGE: &ensp;  ./slope_geomorph.sh EPSG DATA OUTPATH DTM OUT SRCH SKP FLT SZ [AOI]

    - EPSG - srs of DTM as epsg code, e.g. epsg:26910.
    - DATA - Full Path to directory containing DTM, and
    - AOI (if applicable).
    - DTM  - Relative path to DTM from DATA.
    - OUT  - Full path to output directory.
    - SRCH - Outer search radius for geomorphons algorithm
    - SKP  - Inner search radius for geomorphons algorithm
    - FLT  - Flatness threshold for geomorphons algorithm
    - SZ   - Neighborhood size for the summation
    - AOI  - [OPTIONAL] Area of Interest as vector. Only tested on shape file, but hypothetically should work on any OGR readable vector.



## Cyverse Discovery Environment tools