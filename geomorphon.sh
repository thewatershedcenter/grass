#!/bin/sh

EPSG=$1
DTM=$2


echo "\n\n\n----- args recieved by geomorph_start:"
echo "EPSG  = $EPSG"
echo "DTM   = $DTM"


eval `cat /etc/os-release`

# variable for grass exec for brevity
EXEC="grass --tmp-location $EPSG --exec"

$EXEC `g.region raster=$DTM &&
       r.slope.aspect elevation=$DTM slope=Slope &&
       r.geomorphon -m elevation=Slope forms=Geomorph_25_15_7 search=25 skip=7 flat=15 dist=0 &&
       r.mapcalc expression="<= 8, 0 ,1"`

#g.region raster=$DTM
#r.slope.aspect slope=Slope
#r.geomorphon -m elevation=Slope
#r.geomorphon -m elevation=$DTM