from mundialis/grass-py3-pdal:8.0.1-ubuntu

COPY geopmorph_start.sh .

ENTRYPOINT [ "./entry.sh" ]
