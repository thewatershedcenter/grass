#!/bin/sh

inDTM=$1
maxd=$2


echo $inDTM
ls /data


echo ""
echo "**************************************"
echo ""
echo "g.extension extension=r.skyview operation=add"
echo ""

g.extension extension=r.skyview operation=add

echo ""
echo "**************************************"
echo ""
echo "r.in.gdal input=$inDTM output=DTM --overwrite"
echo ""

r.in.gdal input=$inDTM output=DTM --overwrite

echo ""
echo "**************************************"
echo ""
echo "r.info"
echo ""

r.info DTM

echo ""
echo "**************************************"
echo ""
echo "r.slope.aspect elevation=DTM slope=SL"
echo ""

r.slope.aspect elevation=DTM slope=SL

echo ""
echo "**************************************"
echo ""
echo "r.skyview -o input=DTM output=OP maxdistance=$maxd --overwrite"
echo ""

r.skyview -o input=DTM output=OP maxdistance=$maxd --overwrite

echo ""
echo "**************************************"
echo ""
echo "r.colors -n map=SL color=reds"
echo ""

r.colors -n map=SL color=reds

echo ""
echo "**************************************"
echo ""
echo "r.his hue=SL intensity=OP"
echo ""

r.his hue=SL intensity=OP red=RR green=RG blue=RBs

echo ""
echo "**************************************"
echo ""
echo "g.region raster=RR"
echo ""
g.region raster=DTM -p


f=${inDTM##*/}
OUT=/out/${f%.*}_RedRelief.tiff
echo ""
echo "**************************************"
echo ""
echo "r.out.gdal input=RR output=$OUT format=GTiff type=Byte --overwrite"
echo ""

r.out.gdal input=DTM output=$OUT format=GTiff --overwrite

g.proj -p