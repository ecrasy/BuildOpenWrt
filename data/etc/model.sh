#########################################################################
# File Name: model.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: replace default model string with model name from lscpu
# will be called in wlan up event
# Created Time: 2022-07-25 01:30:41 UTC
# Modified Time: 2022-12-12 04:05:41 UTC
#########################################################################


#!/bin/sh


vendor=$(lscpu | grep -m1 "Vendor ID:" | cut -d':' -f 2)
if [ -z "$vendor" ]; then
    vendor=$(lscpu | grep -m1 "BIOS Vendor ID:" | cut -d':' -f 2)
fi

if [ -z "$vendor" ]; then
    vendor="GenuineIntel"
fi

str="Default string Default string/Default string"
rpl="$vendor"
cmd="s|$str|$rpl|g"
sed -i "$cmd" /tmp/sysinfo/model

str="Default string Default string"
rpl="$vendor"
cmd="s|$str|$rpl|g"
sed -i "$cmd" /tmp/sysinfo/model

str="Default string"
rpl="$vendor"
cmd="s|$str|$rpl|g"
sed -i "$cmd" /tmp/sysinfo/model

