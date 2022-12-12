#########################################################################
# File Name: model.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: replace default model string with model name from lscpu
# will be called in wlan up event
# Created Time: 2022-07-25 01:30:41 UTC
# Modified Time: 2022-12-12 04:05:41 UTC
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

str="Default string"
rpl="$model"
cmd="s|$str|$rpl|g"
sed -i "$cmd" /tmp/sysinfo/model

