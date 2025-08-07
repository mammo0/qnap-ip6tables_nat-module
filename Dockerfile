FROM mammo0/qnap-qts-toolchain:vivid

ARG BUILD_USER=builder
ARG PUID=0
ARG PGID=0
ENV BUILD_DIR=/build
ENV VOLUME_DIR=/out


# add build user
RUN [ $(getent group $PGID) ] || groupadd -f -g $PGID $BUILD_USER && \
    [ $(getent passwd $PUID) ] || useradd -ms /bin/bash -u $PUID -g $PGID $BUILD_USER

# setup build context
RUN mkdir "$BUILD_DIR" && \
    mkdir "$VOLUME_DIR" && \
    chown $PUID:$PGID "$VOLUME_DIR"
ADD . "$BUILD_DIR"
RUN chown -R $PUID:$PGID "$BUILD_DIR"
WORKDIR "$BUILD_DIR"


USER $PUID:$PGID
VOLUME "$VOLUME_DIR"
COPY docker_entrypoint.sh /usr/bin/
ENTRYPOINT ["docker_entrypoint.sh"]
