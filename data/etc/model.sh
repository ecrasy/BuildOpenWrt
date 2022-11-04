#########################################################################
# File Name: model.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: replace default model string with empty string
# will be called in wlan up event
# Created Time: 2022-07-25 01:30:41 UTC
# Modified Time: 2022-11-04 12:18:32 UTC
#########################################################################


#!/bin/sh

str="Default string Default string/Default string - "
rpl="Intel(R) J4125 - "
cmd="s@$str@$rpl@"
sed -i "$cmd" /tmp/sysinfo/model

str="Default string Default string"
rpl="Intel(R) J4125"
cmd="s@$str@$rpl@"
sed -i "$cmd" /tmp/sysinfo/model

# remove custom feeds form /etc/opkg/distfeeds.conf
# they are not in the remote distfeeds repo
sed -i '/PWpackages/d' /etc/opkg/distfeeds.conf
sed -i '/PWluci/d' /etc/opkg/distfeeds.conf
sed -i '/Passwall2/d' /etc/opkg/distfeeds.conf
sed -i '/ssrp/d' /etc/opkg/distfeeds.conf
sed -i '/CustomPkgs/d' /etc/opkg/distfeeds.conf

