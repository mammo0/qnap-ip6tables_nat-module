#!/usr/bin/env bash

. build_env.sh


QNAP_ARCHIVE="GPL_QTS-${QNAP_VER}_Kernel.tar.gz"


function build() {
    pushd "$SRC_DIR"

    if [[ ! -d "$QNAP_DIR" ]]; then
        # get the QNAP source
        curl -LJOk "https://sourceforge.net/projects/qosgpl/files/QNAP%20NAS%20GPL%20Source/QTS%20${QNAP_VER:0:5}/GPL_QTS-${QNAP_VER}_Kernel.tar.gz/download"

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
}


entry_point "$@"
