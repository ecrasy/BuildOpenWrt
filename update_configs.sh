#########################################################################
# File Name: update_configs.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: feel free to use
# Created Time: 2022-10-07 10:59:04 UTC
# Modified Time: 2022-10-07 11:27:42 UTC
#########################################################################


#!/bin/bash

configs="x86_64.config x86_64_kmod.config RaspberryPi4B.config RaspberryPi4B_kmod.config"

cd openwrt

git pull
./scripts/feeds update -a
./scripts/feeds install -a

for config in $configs 
do
    echo -e "\n======== updating $config ========"

    rm .config*
    cp ~/code/BuildOpenwrt/configs/$config .config
    make defconfig
    ./scripts/diffconfig.sh > ~/code/BuildOpenwrt/configs/$config

    echo -e "========  $config saved  ========\n"
done

