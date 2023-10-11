#########################################################################
# File Name: feeds.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: feel free to use
# Created Time: 2022-07-23 13:04:43 UTC
# Modified Time: 2023-10-11 11:28:39 UTC
#########################################################################

#!/bin/bash

echo -e "\n# Custom feeds for OpenWrt" >> feeds.conf.default

# passwall
echo "Adding xiaorouji passwall"
echo "src-git PWpackages https://github.com/ecrasy/openwrt-passwall.git;packages" >> feeds.conf.default
echo "src-git PWluci https://github.com/ecrasy/openwrt-passwall.git;luci" >> feeds.conf.default

# passwall2
echo "Adding xiaorouji Passwall2"
echo "src-git Passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main" >> feeds.conf.default

# ssrp
echo "Adding ShadowSocksR Plus"
echo "src-git ssrp https://github.com/ecrasy/ssrp.git;main" >> feeds.conf.default

# add custom packages
echo "Adding custom packages"
echo "src-git CustomPkgs https://github.com/ecrasy/custom-packages.git;for_lede" >> feeds.conf.default

echo "Adding Feeds Completed!!!"
