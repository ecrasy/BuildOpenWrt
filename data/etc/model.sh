#########################################################################
# File Name: model.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: Replace model default string with vendor name from lscpu.
# Description: It will be called in wlan up event.
# Created Time: 2022-07-25 01:30:41 UTC
# Modified Time: 2023-02-17 10:34:53 UTC
#########################################################################

#!/bin/sh


vendor=$(lscpu | grep -m1 "Vendor ID:" | cut -d':' -f 2)
if [ -z "$vendor" ]; then
    vendor=$(lscpu | grep -m1 "BIOS Vendor ID:" | cut -d':' -f 2)
fi

if [ -z "$vendor" ]; then
    vendor="GenuineIntel"
fi

str1="Default string Default string/Default string"
str2="Default string Default string"
str3="Default string"
rpl="$vendor"

sed -i -e "s|$str1|$rpl|g" -e "s|$str2|$rpl|g" -e "s|$str3|$rpl|g" -e "s/^[ \t]*//g" /tmp/sysinfo/model

