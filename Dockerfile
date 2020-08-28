FROM ubuntu:15.04

ARG BUILD_USER=builder
ARG PUID=1000
ARG PGID=1000
ENV BUILD_DIR=/build
ENV VOLUME_DIR=/out


ADD config/ubunut_sources.list /etc/apt/sources.list

# install dependencies
RUN apt-get update && \
    apt-get -y install \
        build-essential \
        curl \
        bc \
        libelf-dev


# add build user
RUN [ $(getent group $PGID) ] || groupadd -f -g $PGID $BUILD_USER && \
    useradd -ms /bin/bash -u $PUID -g $PGID $BUILD_USER

# setup build context
RUN mkdir "$BUILD_DIR" && \
    mkdir "$VOLUME_DIR" && \
    chown $PUID:$PGID "$VOLUME_DIR"
ADD . "$BUILD_DIR"
RUN chown -R $PUID:$PGID "$BUILD_DIR"
WORKDIR "$BUILD_DIR"


USER $BUILD_USER
VOLUME "$VOLUME_DIR"
COPY docker_entrypoint.sh /usr/bin/
ENTRYPOINT ["docker_entrypoint.sh"]
