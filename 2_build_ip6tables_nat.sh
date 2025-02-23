#!/usr/bin/env bash

. build_env.sh


IP6TABLES_MODULES_DIR="$KERNEL_DIR/net/ipv6/netfilter"


function build() {
    pushd "$KERNEL_DIR"

    # apply the default QNAP kernel configuration
    make olddefconfig

    # change the kernel configuration
    # enable the IPv6 netfilter modules
    ./scripts/config --module CONFIG_IP6_NF_NAT

    # prepare building
    make scripts
    make prepare
    make modules_prepare

    # build only the IPv6 netfilter modules
    make -C . M=net/ipv6/netfilter

    popd
}


function collect_artifacts() {
    cp "$IP6TABLES_MODULES_DIR/ip6table_nat.ko" "$OUT_DIR/"
}


entry_point "$@"
