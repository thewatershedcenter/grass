#!/bin/sh

EPSG=$1
DTM=$2
AOI=$3
SRCH=$4
SKP=$5
FLT=$6
SZ=$7

# this
eval `cat /etc/os-release`

# grass exec for brevity
EXEC="grass --tmp-location $EPSG --exec"

# use cat to write script to get around constraints of --tmp-location
# ************ sTaRt oF inTeRnAl sCrIpt *****************
cat >/out/scriptception.sh <<EOF
#!/bin/bash

DTM=\$1
AOI=\$2
SRCH=\$3
SKP=\$4
FLT=\$5
SZ=\$6

# import dtm
r.in.gdal input=/data/\$DTM output=dtm --overwrite

# set region
g.region raster=dtm
echo "Region set from DTM:"
g.region -p

if [ -z \${AOI} ]
then
    # make output filename
    f=\${DTM##*/}
    OUT=/out/\${f%.*}_geomorph\$SRCH_\$SKP_\$FLT.tiff
else
    # set region to aoi
    v.in.ogr input=/data/\$AOI output=aoi
    g.region vector=aoi
    echo "Region set from AOI:"
    g.region -p
    # make output filename
    f=\${AOI##*/}
    OUT=/out/\${f%.*}_geomorph\$SRCH_\$SKP_\$FLT.tiff
fi

# calc slope from dtm
r.slope.aspect elevation=dtm slope=Slope

# calc geomorphon
r.geomorphon elevation=Slope forms=geomorph search=\$SRCH skip=\$SKP flat=\$FLT

# map algeabra
r.mapcalc expression="algeabra = if(geomorph <= 8, 0 ,1)"

# neighborhood filter
r.neighbors input=algeabra output=neighbor size=\$SZ method=sum

# export tiff
r.out.gdal input=neighbor output=\$OUT format=GTiff --overwrite
EOF
# ***************END oF inTeRnAl sCrIpt *****************

# make script executable
chmod +x /out/scriptception.sh # Make the script executable

# now execute it
$EXEC /out/scriptception.sh $DTM $AOI $SRCH $SKP $FLT $SZ

# remove the script
rm /out/scriptception.sh