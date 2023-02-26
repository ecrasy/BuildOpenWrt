#########################################################################
# File Name: update_configs.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: feel free to use
# Created Time: 2022-10-07 10:59:04 UTC
# Modified Time: 2023-02-26 03:10:45 UTC
#########################################################################


#!/bin/bash

set -e

usage() { echo "Usage: $0 -c <configs dir> -o <openwrt source dir>" 1>&2; exit 1; }

prompter() {
    echo -e "\n********************************************\n$1"
    command $2
    echo -e "********************************************\n"
}

configs_dir=""
openwrt_dir=""

while getopts ":c:o:" o; do
    case "${o}" in
        c)
            configs_dir=${OPTARG}
            ;;
        o)
            openwrt_dir=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))
[ -n "$configs_dir" ] || usage
[ -n "$openwrt_dir" ] || usage

configs_dir=$(echo $configs_dir | xargs realpath -s | sed 's:/*$::')
openwrt_dir=$(echo $openwrt_dir | xargs realpath -s | sed 's:/*$::')
[ -n "$configs_dir" ] || exit 0
[ -n "$openwrt_dir" ] || exit 0

configs=$(find $configs_dir -maxdepth 1 -type f -name '*.config' -printf "%f\n" | sort -f)
[ -z "$configs" ] && exit 0

prompt="Configs dir: $configs_dir\nConfigs found:"
cmd="echo $configs"
prompter "$prompt" "$cmd"

cd $openwrt_dir

prompt="Openwrt source dir: $openwrt_dir\nUpdating openwrt source code:"
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

