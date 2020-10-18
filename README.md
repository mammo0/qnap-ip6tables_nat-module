# `ip6tables_nat` kernel module for QNAP NAS

This repository contains a collection of scripts for building the `ip6tables_nat` kernel module for a QNAP NAS.

![Build ip6tables_nat kernel module for QNAP](https://github.com/mammo0/qnap-ip6tables_nat-module/workflows/Build%20ip6tables_nat%20kernel%20module%20for%20QNAP/badge.svg)



### Motivation
The main problem why I need those kernel modules is IPV6.

Basically I want to publish some web services that run in Docker containers (on my QNAP NAS) to the internet. The problem is that my internet provider only gives me an IPV6 address. So Docker on my NAS must also use IPV6.

Thes led me to [docker-ipv6nat](https://github.com/robbertkl/docker-ipv6nat). At this repository the problem of Docker with IPV6 is described much more in detail.

To use this workaraound/software the `ip6table_nat` kernel module is required. Sadly it's not built into the QTS kernel...

So I built it myself :)



### Download the precompiled images
There's a GitHub workflow that builds kernel images of this repository. You can download them directly from the [releases page](https://github.com/mammo0/qnap-ip6tables_nat-module/releases).

Currently the modules are only compiled for the `x86_64` architecture!

The modules are based on the GPL QTS version

    4.4.3

~But they also work up to QTS version `4.4.3`.~



### Building
On my own QNAP NAS the toolchain for building the kernel is

    gcc-4.9.2 binutils-2.25 glibc-2.21

Because these are quite old versions the simpliest solution to get this build context was to use Docker with an old Ubuntu `15.04` image.

I reccomend to use Docker to build these modules rather than to setup the build context on your PC manually.

##### 1) Build the Docker image
To build the Docker image run:
```shell
docker build -t ip6tables_nat-qnap --build-arg PUID=`id -u` --build-arg PGID=`id -g` .
```
For customizations you can specify the following build arguments:
- `BUILD_USER` [**builder**]: The name for the user that runs the build process.
- `PUID` [**1000**]: The user ID of that user. *The above command uses the current user ID.*
- `PGID` [**1000**]: The group ID that belongs to that user. *The above command uses the current group ID.*

##### 2) Run the Docker image to build the OpenWRT images
To start the automated build process run:
```shell
docker run -v `pwd`:/out ip6tables_nat-qnap
```
By default if no arguments were specified, the resulting kernel modules should be available in your current working directory. Otherwise check the `-v` argument. On container side the path should be equal to the `VOLUME_DIR` path that is defined in the Dockerfile.



### Using the kernel modules
1. Copy them to your QNAP NAS.
2. Load them via `insmod`:
```shell
# the ip6_tables module is must be loaded before
# on my NAS it was already there so using modprobe was enough
/sbin/modprobe ip6_tables
# otherwise load it via:
/sbin/insmod /<path_to_module>/ip6_tables.ko
# then load the other modules
/sbin/insmod /<path_to_module>/nf_nat_ipv6.ko
/sbin/insmod /<path_to_module>/nf_nat_masquerade_ipv6.ko
/sbin/insmod /<path_to_module>/nf_reject_ipv6.ko
/sbin/insmod /<path_to_module>/ip6t_MASQUERADE.ko
/sbin/insmod /<path_to_module>/ip6t_NPT.ko
/sbin/insmod /<path_to_module>/ip6t_REJECT.ko
/sbin/insmod /<path_to_module>/ip6table_nat.ko
```

The other modules that were also built can be ommited.

You can add the above commands to the `autorun.sh` file to load those modules at boot time. The process for creating the `autorun.sh` file is described in the official QNAP Wiki:
https://wiki.qnap.com/wiki/Running_Your_Own_Application_at_Startup
