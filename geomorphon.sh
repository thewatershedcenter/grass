#!/bin/sh

EPSG=$1
DTM=$2

# soeme debugging output
echo "\n\n\n----- args recieved by geomorph_start:"
echo "EPSG  = $EPSG"
echo "DTM   = $DTM"

# this
eval `cat /etc/os-release`

# variable for grass exec for brevity
EXEC="grass --tmp-location $EPSG --exec"

# use cat to write script to get around constraints of --tmp-location
# ************ sTaRt oF inTeRnAl sCrIpt *****************
cat >scriptception.sh <<EOF
#!/bin/bash
EPSG=\$1
DTM=\$2

# set region
g.region raster=\$DTM

# calc slope from dtm
r.slope.aspect elevation=\$DTM slope=Slope

# calc 27 7 15 geomorphon
r.geomorphon -m elevation=Slope forms=Geomorph_25_15_7 search=25 skip=7 flat=15>

# map algeabra
r.mapcalc expression="<= 8, 0 ,1
EOF
# ***************END oF inTeRnAl sCrIpt *****************


# make script executable
chmod +x scriptception.sh # Make the script executable

# now execute it
$EXEC scriptception.sh


