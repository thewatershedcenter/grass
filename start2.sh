#!/bin/sh

data=$1
script=$2
EPSG=$3
OUT=$4
input=$5 # inDTM  , generallly input file or dir
param1=$6 # maxd

echo "\n\n\n----- args recieved by start:"
echo "input = $input"
echo "param1 = $param1 \n\n\n"


docker build . -t grass_container
docker run -it --rm --user=$(id -u):$(id -g) --volume $PWD:/work --volume $data:/data --volume $OUT:/out --env HOME=/work grass_container /work/$script $EPSG $input $param1


# data=/media/data
# inDTM=arroyo_seco/usgs_1m_DEM/arroyo_seco.vrt
# out=/media/data/arroyo_seco/derivatives
# ./start2.sh $data red_relief.sh epsg:26910 $out $inDTM 20

