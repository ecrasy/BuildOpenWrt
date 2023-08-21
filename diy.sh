#########################################################################
# File Name: diy.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: feel free to use
# Created Time: 2022-07-23 13:01:29 UTC
# Modified Time: 2023-08-21 12:26:02 UTC
#########################################################################


#!/bin/bash

# Change default LAN IP to 192.168.2.1
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate 
echo "Change default LAN IP to 192.168.2.1"

# Patch 02_network config file
BOARD_PATH="target/linux/x86/base-files/etc/board.d"
PATCH_FILE="${GITHUB_WORKSPACE}/data/patches/02_network.patch"
RLINE=$(grep -m1 -n 'esac' ${BOARD_PATH}/02_network |awk '{ print $1 }' |cut -d':' -f1)
if [ -n "$RLINE" ]; then
    RLINE=$((RLINE-1))
    OP_RESULT=$(sed -i -e "${RLINE}r ${PATCH_FILE}" ${BOARD_PATH}/02_network)
    echo "Patch 02_network config file: $OP_RESULT"
fi

# Patch 99-default_network config file
BOARD_PATH="package/base-files/files/etc/board.d"
cp $GITHUB_WORKSPACE/data/patches/99-default_network.patch $BOARD_PATH/
cd $BOARD_PATH/
OP_RESULT=$(patch < 99-default_network.patch)
echo "Patch 99-default_network config file: $OP_RESULT"
cd ~-

# Change default shell from ash to bash 
# Note: bash need to be selected from make menuconfig first
sed -i 's/\/bin\/ash/\/bin\/bash/g' package/base-files/files/etc/passwd
echo "Change default shell from ash to bash"

# Replace default ssh banner with my custom banner
rm -rf package/base-files/files/etc/banner
cp $GITHUB_WORKSPACE/data/etc/banner package/base-files/files/etc/
echo "Replace default ssh banner"

# Replace fgrep with grep -F in /etc/profile
sed -i 's/fgrep -sq/grep -Fsq/g' package/base-files/files/etc/profile
echo "Replace fgrep with grep -F in /etc/profile"

# Add model.sh to remove annoying board name for Intel J4125
cp $GITHUB_WORKSPACE/data/etc/model.sh package/base-files/files/etc/
chmod 0755 package/base-files/files/etc/model.sh
echo "Add model.sh"

# Add 095-ula-prefix, try to set up IPv6 ula prefix after wlan up
# and call model.sh
mkdir -p package/base-files/files/etc/hotplug.d/iface
cp $GITHUB_WORKSPACE/data/etc/095-ula-prefix package/base-files/files/etc/hotplug.d/iface/
chmod 0755 package/base-files/files/etc/hotplug.d/iface/095-ula-prefix
echo "Add 095-ula-prefix"

# Add base config files
# mkdir -p package/base-files/files/etc/config
# cp -f $GITHUB_WORKSPACE/data/etc/config/* package/base-files/files/etc/config/
# echo "Add base config files"

# Remove customization of distfeeds.conf
sed -i '/distfeeds/d' package/lean/default-settings/files/zzz-default-settings
echo "Remove customization of distfeeds.conf, cant trust them btw"

echo -e "DIY Jobs Completed!!!\n"

