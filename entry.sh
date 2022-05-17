#!/bin/sh

script=$1
EPSG=$2
input=$3 #inDTM
param1=$4 #maxd



echo "\n\n\n----- args recieved by entry:"
echo "script   = $script"
echo "epsg     = $EPSG"
echo "input    = $input"
echo "param1   = $param1"


echo "\n\n\n--- Linux distro used:"
cat /etc/os-release | grep 'NAME\|VERSION'

eval `cat /etc/os-release`

# variable for grass exec for brevity
EXEC="grass --tmp-location $EPSG --exec"

echo "--- GRASS version used:"
$EXEC g.version -rge

echo "--- GISDBASE, LOCATION_NAME, and MAPSET:"
$EXEC g.gisenv

echo "------------- Entering script ------------------"

$EXEC $script /data/$input $param1 $OUT

