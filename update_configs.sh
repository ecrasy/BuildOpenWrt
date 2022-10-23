#########################################################################
# File Name: update_configs.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: feel free to use
# Created Time: 2022-10-07 10:59:04 UTC
# Modified Time: 2022-10-23 04:08:39 UTC
#########################################################################


#!/bin/bash

function prompter() {
    echo -e "\n********************************************\n$1"
    command $2
    echo -e "********************************************\n"
}

configs_dir="$HOME/code/BuildOpenWrt/configs"
openwrt_dir="$HOME/code/openwrt"
if [ "$1" != "" ] 
then
    configs_dir=$1
fi
if [ "$2" != "" ]
then
    openwrt_dir=$2
fi

configs_dir=$(echo $configs_dir | sed 's:/*$::')
openwrt_dir=$(echo $openwrt_dir | sed 's:/*$::')

configs=$(find $configs_dir -maxdepth 1 -type f -name '*.config' -printf "%f\n" | sort -f)

[ -z "$configs" ] && exit 0

prompt="Configs found:"
cmd="echo $configs"
prompter "$prompt" "$cmd"

cd $openwrt_dir

prompt="Updating openwrt source code:"
cmd="git pull"
prompter "$prompt" "$cmd"

prompt="Updating openwrt feeds packages:"
cmd="$openwrt_dir/scripts/feeds update -a"
prompter "$prompt" "$cmd"

prompt="Installing openwrt feeds packages:"
cmd="$openwrt_dir/scripts/feeds install -a"
prompter "$prompt" "$cmd"

for config in $configs 
do
    echo -e "\n********************** Updating $config **********************"

    rm -f $openwrt_dir/.config*
    cp $configs_dir/$config $openwrt_dir/.config
    make defconfig
    $openwrt_dir/scripts/diffconfig.sh > $configs_dir/$config

    echo -e "********************** $config saved **********************\n"
done

