#########################################################################
# File Name: model.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: replace default model string with model name from lscpu
# will be called in wlan up event
# Created Time: 2022-07-25 01:30:41 UTC
# Modified Time: 2022-11-05 15:12:08 UTC
#########################################################################


#!/bin/sh

model=$(lscpu | grep -m1 "^Model name:" | sed -e "s|Model name:||g")
if [ -z "$model" ]
then
    model=$(lscpu | grep -m1 "^BIOS Model name:" | sed -e "s|BIOS Model name:||g")
fi

if [ -z "$model" ]
then
    model="GenuineIntel"
fi

str="Default string Default string/Default string"
rpl="$model"
cmd="s|$str|$rpl|g"
sed -i "$cmd" /tmp/sysinfo/model

str="Default string Default string"
rpl="$model"
cmd="s|$str|$rpl|g"
sed -i "$cmd" /tmp/sysinfo/model

# remove my custom feeds from feeds.conf.default
# they dont belong to the remote distfeeds repo
sed -i '/PWpackages/d' /etc/opkg/distfeeds.conf
sed -i '/PWluci/d' /etc/opkg/distfeeds.conf
sed -i '/Passwall2/d' /etc/opkg/distfeeds.conf
sed -i '/ssrp/d' /etc/opkg/distfeeds.conf
sed -i '/CustomPkgs/d' /etc/opkg/distfeeds.conf
