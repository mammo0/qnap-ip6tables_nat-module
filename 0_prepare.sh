#!/usr/bin/env bash

TMP_BASE_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
ENV_FILE="$TMP_BASE_DIR/.env"

# remove any existing .env file
if [ -f "$ENV_FILE" ]; then
    echo "" > "$ENV_FILE"
fi

# create .env that contains all globally needed environment variables
build_environment=$'
BASE_DIR="$TMP_BASE_DIR"

SRC_DIR="$BASE_DIR/src"
CONFIG_DIR="$BASE_DIR/config"
PATCH_DIR="$BASE_DIR/patches"
OUT_DIR="$BASE_DIR/out"

QNAP_DEVICE="TS-X53D"
QNAP_VER="5.1.0.20230808"
QNAP_DIR="$SRC_DIR/GPL_QTS"

KERNEL_VER="5.10"
KERNEL_DIR="$QNAP_DIR/src/linux-$KERNEL_VER"
QNAP_KERNEL_CONFIG_FILE="$QNAP_DIR/kernel_cfg/$QNAP_DEVICE/linux-$KERNEL_VER-x86_64.config"'

# evaluate the above string (e.g. resolve paths)
while IFS='=' read -r key temp || [ -n "$key" ]; do
    # ignore "empty" lines
    case "$key" in
	'')
		continue
		;;
	esac

    value=$(eval echo "$temp")
    eval export "$key='$value'"
	echo "$key=$value" >> .env
done <<< "$build_environment"
