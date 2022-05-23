FROM mundialis/grass-py3-pdal:8.0.1-ubuntu

RUN pip install jupyterlab

RUN mkdir /work

#COPY geomorphon_py_version.sh .

# expose port
EXPOSE 8888

CMD ["jupyter","lab","--ip=0.0.0.0","--port=8888","--no-browser","--allow-root", "--notebook-dir=/work"]

#ENTRYPOINT [ "./geomorphon_py_version.sh" ]

