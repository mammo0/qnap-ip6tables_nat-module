#!/usr/bin/env bash

. build_env.sh


KERNEL_ARCHIVE="linux-${KERNEL_VER}.tar.xz"
QNAP_ARCHIVE="GPL_QTS-${QNAP_VER}.tar.gz"


function build() {
    pushd "$SRC_DIR"

    if [[ ! -d "$KERNEL_DIR" ]]; then
        # get the kernel source
        curl -LJO "https://cdn.kernel.org/pub/linux/kernel/v${KERNEL_VER:0:1}.x/$KERNEL_ARCHIVE"

        tar -xf "$KERNEL_ARCHIVE"
        rm "$KERNEL_ARCHIVE"
    fi

    if [[ ! -d "$QNAP_DIR" ]]; then
        # get the QNAP source
        curl -LJO "https://sourceforge.net/projects/qosgpl/files/QNAP%20NAS%20GPL%20Source/QTS%20${QNAP_VER:0:5}/GPL_QTS-${QNAP_VER}.tar.gz/download"

        tar -zxf "$QNAP_ARCHIVE"
        rm "$QNAP_ARCHIVE"
    fi

    # copy the kernel config to the kernel directory
    cp "$QNAP_KERNEL_CONFIG_FILE" "$KERNEL_DIR/.config"

    # apply patches
    apply_patches "$PATCH_DIR/linux" "$KERNEL_DIR"

    popd
}


function clean() {
    rm -rf "$QNAP_DIR"

    rm -rf "$KERNEL_DIR"
}


entry_point "$@"
