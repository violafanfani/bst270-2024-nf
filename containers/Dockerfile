## base container
FROM mambaorg/micromamba:0.15.3 as base_container
USER root
RUN apt-get update \
    && apt-get install --yes rename tini procps curl \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER micromamba
ENTRYPOINT ["tini", "--"]
CMD ["/bin/bash"]

## main container
ARG CONDA_FILE=containers/env.base.python.yml
FROM base_container
# adding opencontainer labels to link registry to github repository
LABEL org.opencontainers.image.title="bst270-2024-nf"
LABEL org.opencontainers.image.description="bst270 nf project"
LABEL org.opencontainers.image.url="https://github.com/violafanfani/bst270-2024-nf"
LABEL org.opencontainers.image.documentation="https://github.com/violafanfani/bst270-2024-nf"
LABEL org.opencontainers.image.source="https://github.com/violafanfani/bst270-2024-nf"
LABEL org.opencontainers.image.vendor="violafanfani"
LABEL org.opencontainers.image.authors="Viola Fanfani"
LABEL org.opencontainers.image.revision="v0.0.0"

COPY --chown=micromamba:micromamba ${CONDA_FILE} /tmp
RUN micromamba install -y -n base -f /tmp/`basename ${CONDA_FILE}` && \
    micromamba clean --all --yes
