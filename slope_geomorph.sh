#!/bin/bash



while getopts ":h" option; do
   case $option in
      h) # display Help
        echo "SYNOPSIS:"
        echo "      Calculates geomorphons based on slope, Creates a"
        echo "      boolean raster where forms 9 and 10 (pits and valleys) are"
        echo "      true, then perfoms neighborhood sumation.  Returns geoTiff"
        echo "USAGE:"
        echo "     ./slope_geomorph.sh EPSG DATA OUTPATH DTM OUT SRCH SKP FLT SZ [AOI]"
        echo "      "
        echo "      EPSG - srs of DTM as epsg code, e.g. epsg:26910."
        echo "      DATA - Full Pathh to directory containing DTM, and"
        echo "      AOI (if applicable)."
        echo "      DTM  - Relative path to DTM from DATA."
        echo "      OUT  - Full path to output directory."
        echo "      SRCH - Outer search radius for geomorphons algorithm"
        echo "      SKP  - Inner search radius for geomorphons algorithm"
        echo "      FLT  - Flattnes threshold for geomorphons algorithm"
        echo "      SZ   - Neoghborhood size for the sumation"
        echo "      AOI  - [OPTIONAL] Area of Interest as vector. Only tested on shape"
        echo "             file, but hypothetically should work on any OGR readable"
        echo "             vector."
        exit;;
   esac
done



EPSG=$1
DATA=$2
DTM=$3
OUT=$4
SRCH=$5
SKP=$6
FLT=$7
SZ=$8
AOI=$9

docker run -it --rm --pull=always --user=$(id -u):$(id -g)  --volume $PWD:/work --volume $DATA:/data --volume $OUT:/out --env HOME=/work quay.io/wrtc/geomorphon:sha-latest $EPSG $DTM $SRCH $SKP $FLT $SZ $AOI







# ./slope_geomorph.sh epsg:26910 /media/data arroyo_seco/usgs_1m_DEM/arroyo_seco.vrt /media/data/arroyo_seco/derivatives  25 7 15 7 arroyo_seco/aoi/aoi.shp










