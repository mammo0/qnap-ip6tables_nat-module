#!/usr/bin/env bash

. build_env.sh


QNAP_ARCHIVE="GPL_QTS-${QNAP_VER}_Kernel.tar.gz"


function _url_exists() {
    ret_code=$(curl -sLIk -o /dev/null -w "%{http_code}" "$1")

    [ "$ret_code" -eq "200" ]
}


function build() {
    pushd "$SRC_DIR"

    if [[ ! -d "$QNAP_DIR" ]]; then
        single_tar_url="https://sourceforge.net/projects/qosgpl/files/QNAP%20NAS%20GPL%20Source/QTS%20${QNAP_VER:0:5}/GPL_QTS-${QNAP_VER}_Kernel.tar.gz"

        # check the single tar file
        if _url_exists "$single_tar_url"; then
            # get single tar file
            curl -Lk "$single_tar_url" -o "$QNAP_ARCHIVE"

            tar -zxf "$QNAP_ARCHIVE"
            rm "$QNAP_ARCHIVE"
        else
            file_counter=0
            while true
            do
                # set the name for the split tar file
                split_tar_url="https://sourceforge.net/projects/qosgpl/files/QNAP%20NAS%20GPL%20Source/QTS%20${QNAP_VER:0:5}/QTS_Kernel_${QNAP_VER}.tar.gz.${file_counter}"

                # stop here if the file does not exits
                if ! _url_exists "$split_tar_url"; then
                    break
                fi

                # get the split tar file
                curl -Lk "$split_tar_url" -o "${QNAP_ARCHIVE}.${file_counter}"

                file_counter=$((file_counter + 1))
            done

            cat "${QNAP_ARCHIVE}."* | tar -zxf -
            rm "${QNAP_ARCHIVE}."*
        fi
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
