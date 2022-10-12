#########################################################################
# File Name: feeds.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: feel free to use
# Created Time: 2022-07-23 13:04:43 UTC
# Modified Time: 2022-10-12 14:31:14 UTC
#########################################################################

#!/bin/bash


# passwall
echo "Adding xiaorouji passwall"
echo "src-git PWpackages https://github.com/xiaorouji/openwrt-passwall.git;packages" >> feeds.conf.default
echo "src-git PWluci https://github.com/xiaorouji/openwrt-passwall.git;luci" >> feeds.conf.default

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
