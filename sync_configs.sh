#########################################################################
# File Name: sync_configs.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: feel free to use
# Created Time: 2023-02-26 01:57:56 UTC
# Modified Time: 2023-02-27 08:17:36 UTC
#########################################################################


#!/bin/bash

set -e

usage() { echo "Usage: $0 -c <configs dir> [-s <configs sub file>] [-a <configs add file>]" 1>&2; exit 1; }

configs_dir=""
diffs_sub=""
diffs_add=""

while getopts ":c:s:a:" o; do
    case "${o}" in
        c)
            configs_dir=${OPTARG}
            ;;
        s)
            diffs_sub=${OPTARG}
            ;;
        a)
            diffs_add=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))
[ -n "$configs_dir" ] || usage

configs_dir=$(echo $configs_dir | xargs realpath -s | sed 's:/*$::')
configs=$(find $configs_dir -maxdepth 2 -type f -name '*.config' | sort -f)
[ -n "$configs" ] || exit 0

# do subtraction
if [[ -n "$diffs_sub" && -e $diffs_sub ]]; then
    for config in $configs 
    do
        cdiffs=$(cat $diffs_sub)
        echo -e "\n**************** Updating $(basename $config) ****************"
        for cdiff in $cdiffs
        do
            sed -i -e "/${cdiff}/d" $config
            echo "remove $cdiff from $(basename $config)"
        done
        echo -e "**************** $(basename $config) saved ****************\n"
    done
fi

# do addition
if [[ -n "$diffs_add" && -e $diffs_add ]]; then
    for config in $configs 
    do
        cdiffs=$(cat $diffs_add)
        echo -e "\n**************** Updating $(basename $config) ****************"
        for cdiff in $cdiffs
        do
            echo $cdiff >> $config
            echo "add $cdiff to $(basename $config)"
        done
        echo -e "**************** $(basename $config) saved ****************\n"
    done
fi

