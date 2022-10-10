#########################################################################
# File Name: diy.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: feel free to use
# Created Time: 2022-07-23 13:01:29 UTC
# Modified Time: 2022-10-10 04:26:18 UTC
#########################################################################


#!/bin/bash

# Changing default LAN IP to 192.168.2.1
echo "Changing default LAN IP to 192.168.2.1"
[ -e package/base-files/files/bin/config_generate ] && sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate 

# Changing default shell from ash to bash 
# Note: bash need to be selected from make menuconfig first
echo "Changing default shell from ash to bash"
[ -e package/base-files/files/etc/passwd ] && sed -i 's/\/bin\/ash/\/bin\/bash/g' package/base-files/files/etc/passwd

# Replacing default ssh banner with my custom banner
echo "Replacing default ssh banner"
rm -rf package/base-files/files/etc/banner
cp $GITHUB_WORKSPACE/data/banner package/base-files/files/etc/banner

# Adding model.sh to remove annoying board name for Intel J4125
echo "Adding model.sh"
cp $GITHUB_WORKSPACE/data/model.sh package/base-files/files/etc/
chmod +x package/base-files/files/etc/model.sh

# Adding 99-ipv6, try to set up IPv6 ula prefix after wlan up
# and call model.sh
echo "Adding 99-ipv6"
mkdir -p package/base-files/files/etc/hotplug.d/iface
cp $GITHUB_WORKSPACE/data/99-ipv6 package/base-files/files/etc/hotplug.d/iface/99-ipv6
chmod +x package/base-files/files/etc/hotplug.d/iface/99-ipv6

# Changing default theme
# [ -e feeds/luci/collections/luci/Makefile ] && sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

echo "DIY Completed!!!"

