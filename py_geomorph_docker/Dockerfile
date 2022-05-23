FROM mundialis/grass-py3-pdal:8.0.1-ubuntu

# downlaod, chmod and run intallation script
RUN wget -c https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh &\
    chmod +x Miniconda3-latest-Linux-x86_64.sh & \
    bash Miniconda3-latest-Linux-x86_64.sh -b

# add to path
ENV PATH=/root/miniconda3/bin:${PATH}

# update, install packages
RUN conda update -y conda
RUN conda install mamba -n base -c conda-forge
RUN mamba install -c conda-forge jupyterlab scipy tqdm dask seaborn

# cleanup
RUN rm Miniconda3-latest-Linux-x86_64.sh

# make dir for notebokks
RUN mkdir /notebooks

#COPY geomorphon_py_version.sh .

# expose port
EXPOSE 8888

CMD ["jupyter","notebook","--ip=0.0.0.0","--port=8888","--no-browser","--allow-root", "--notebook-dir=/notebooks"]

#ENTRYPOINT [ "./geomorphon_py_version.sh" ]
