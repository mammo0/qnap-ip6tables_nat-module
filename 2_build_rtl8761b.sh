#!/usr/bin/env bash

. build_env.sh


RTL8761B_MODULES_DIR="$KERNEL_DIR/drivers/bluetooth"


function build() {
    pushd "$KERNEL_DIR"

    # apply kernel patches
    apply_patches "$PATCH_DIR" "$KERNEL_DIR"

    # apply the default QNAP kernel configuration
    make olddefconfig

    # change the kernel configuration
    # enable the Realtek bluetooth modules
    ./scripts/config --module CONFIG_BT_HCIBTUSB
    ./scripts/config --enable CONFIG_BT_HCIBTUSB_RTL
    ./scripts/config --module CONFIG_BT_RTL

    # prepare building
    make scripts
    make prepare
    make modules_prepare

    # build only the bluetooth modules
    make -C . M=drivers/bluetooth

    popd
}


function collect_artifacts() {
    cp "$RTL8761B_MODULES_DIR/btbcm.ko" "$OUT_DIR/"
    cp "$RTL8761B_MODULES_DIR/btintel.ko" "$OUT_DIR/"
    cp "$RTL8761B_MODULES_DIR/btrtl.ko" "$OUT_DIR/"
    cp "$RTL8761B_MODULES_DIR/btusb.ko" "$OUT_DIR/"
}


entry_point "$@"
