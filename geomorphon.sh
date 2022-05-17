#!/bin/sh

EPSG=$1
DTM=$2


echo "\n\n\n----- args recieved by geomorph_start:"
echo "EPSG  = $EPSG"
echo "DTM   = $DTM"


eval `cat /etc/os-release`

# variable for grass exec for brevity
EXEC="grass --tmp-location $EPSG --exec"

$EXEC

#r.geomorphon -m elevation=$DTM