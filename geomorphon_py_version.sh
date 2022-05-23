#!/bin/sh
echo " "
for ARGUMENT in "$@"
do
    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    echo "KEY = $KEY"

    KEY_LENGTH=${#KEY}
    echo "KEY_LENGTH = $KEY_LENGTH"

    VALUE="${ARGUMENT:$KEY_LENGTH+1}"

    export "$KEY"="$VALUE"
done

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
GUASS=\$7

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
    OUT=/out/\${f%.*}_geomorph_\${SRCH}_\${SKP}_\$FLT.tiff
else
    # set region to aoi
    v.in.ogr input=/data/\$AOI output=aoi
    g.region vector=aoi
    echo "Region set from AOI:"
    g.region -p
    # make output filename
    f=\${AOI##*/}
    OUT=/out/\${f%.*}_geomorph_\${SRCH}_\${SKP}_\$FLT.tiff
fi

# calc slope from dtm
r.slope.aspect elevation=dtm slope=Slope

# calc geomorphon
r.geomorphon elevation=Slope forms=geomorph search=\$SRCH skip=\$SKP flat=\$FLT

# map algeabra
r.mapcalc expression="algeabra = if(geomorph <= 8, 0 ,1)"

if [ -z \${GAUSS}]
then
    # neighborhood filter sans gauss
    r.neighbors input=algeabra output=neighbor size=\$SZ method=sum
else
    # neighborhood filter with gauss
    r.neighbors input=algeabra output=neighbor size=\$SZ method=sum  gauss=\$GAUSS

# export tiff
r.out.gdal input=neighbor output=\$OUT format=GTiff --overwrite
EOF
# ***************END oF inTeRnAl sCrIpt *****************

# make script executable
chmod +x /out/scriptception.sh # Make the script executable

# now execute it
$EXEC /out/scriptception.sh $DTM $AOI $SRCH $SKP $FLT $SZ $GUASS

# remove the script
rm /out/scriptception.sh