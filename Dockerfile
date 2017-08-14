FROM daskdev/dask

LABEL maintainer "joshua.foster@stfc.ac.uk"

ENV CONDA_HOME /opt/conda
ENV DASK_USER datalab
ENV DASK_USER_HOME /home/${DASK_USER}
ENV DASK_UID 1000

USER root

# Add datalab user
RUN useradd -m -s /bin/bash -N -u $DASK_UID $DASK_USER &&\
    chown -R $DASK_USER $CONDA_HOME

# # Expose port for monitoring.
# # Dask boken UI on 8787
EXPOSE 8786 8787

WORKDIR ${DASK_USER_HOME}

# Daskdev/dask uses dumb-init in-place of tini
ENTRYPOINT ["dumb-init", "--"]
CMD ["bash", "-c", "/usr/bin/prepare.sh && exec dask-scheduler"]

USER $DASK_USER
