#!/usr/bin/env bash

# the following ENV variables should be set by the Dockerfile:
#   - BUILD_USER
#   - PUID
#   - PGID
#   - BUILD_DIR
#   - VOLUME_DIR

# just to be sure we're in the right directory
cd "$BUILD_DIR"

# load build environment
./0_prepare.sh
. build_env.sh

# do all two steps
./1_download_sources.sh
./2_build_rtl8761b.sh

# copy the resulting modules to the output volume
cp "$OUT_DIR/"*.ko "$VOLUME_DIR/"
