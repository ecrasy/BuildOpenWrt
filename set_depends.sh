#########################################################################
# File Name: set_depends.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: feel free to use
# Description: run this script once before make menuconfig
# Created Time: 2022-12-18 14:15:22 UTC
# Modified Time: 2023-02-10 22:33:50 UTC
#########################################################################

#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Need openwrt source path as input"
    exit 0
fi

for op_dir in $@
do
    openwrt_dir=$(echo "$op_dir" | xargs realpath -s | sed 's:/*$::')
    cd "$openwrt_dir"
    echo "================================================================"
    echo -e "update source code\n"
    git pull && ./scripts/feeds update -a && ./scripts/feeds install -a
    echo -e "\nTry to fix $openwrt_dir depends issue\n"

    # set minidlna depends on libffmpeg
    sed -i "s/libffmpeg /libffmpeg-full /g" feeds/packages/multimedia/minidlna/Makefile
    echo "Set minidlna depends on libffmpeg-full instead of libffmpeg"
    fr=$(grep -n "libffmpeg-full " feeds/packages/multimedia/minidlna/Makefile)
    if [ ! -z "$fr" ]; then
        echo $fr
        echo -e "operation success\n"
    else
        echo -e "operation fail\n"
    fi

    # set cshark depends on openssl
    sed -i "s/libustream-mbedtls/libustream-openssl/g" feeds/packages/net/cshark/Makefile
    echo "Set cshark depends on libustream-openssl instead of libustream-mbedtls"
    fr=$(grep -n "libustream-openssl" feeds/packages/net/cshark/Makefile)
    if [ ! -z "$fr" ]; then
        echo $fr
        echo -e "operation success\n"
    else
        echo -e "operation fail\n"
    fi

    # remove ipv6-helper depends on odhcpd*
    sed -i "s/+odhcpd-ipv6only//g" package/lean/ipv6-helper/Makefile
    echo "Remove ipv6-helper depends on odhcpd*"
    fr=$(grep -n "odhcpd" package/lean/ipv6-helper/Makefile)
    if [ -z "$fr" ]; then
        echo -e "operation success\n"
    else
        echo $fr
        echo -e "operation fail\n"
    fi

    # remove hnetd depends on odhcpd*
    sed -i "s/+odhcpd//g" package/feeds/routing/hnetd/Makefile
    echo "Remove hnetd depends on odhcpd*"
    fr=$(grep -n "odhcpd" package/feeds/routing/hnetd/Makefile)
    if [ -z "$fr" ]; then
        echo -e "operation success\n"
    else
        echo $fr
        echo -e "operation fail\n"
    fi

    # set shairplay depends on mdnsd
    sed -i "s/+libavahi-compat-libdnssd/+mdnsd/g" feeds/packages/sound/shairplay/Makefile
    echo "Set shairplay depends on mdnsd instead of libavahi-compat-libdnssd"
    fr=$(grep -n "+mdnsd" feeds/packages/sound/shairplay/Makefile)
    if [ ! -z "$fr" ]; then
        echo $fr
        echo -e "operation success\n"
    else
        echo -e "operation fail\n"
    fi

    # make luci-app-firewall depends on uci-firewall instead of firewall
    sed -i 's/+firewall/+uci-firewall/g' feeds/luci/applications/luci-app-firewall/Makefile
    echo "Set luci-app-firewall depends on uci-firewall instead of firewall"
    fr=$(grep -n "+uci-firewall" feeds/luci/applications/luci-app-firewall/Makefile)
    if [ ! -z "$fr" ]; then
        echo $fr
        echo -e "operation success\n"
    else
        echo -e "operation fail\n"
    fi

    echo "Fix $openwrt_dir completed!!!"
    echo -e "================================================================\n"
    cd ~-
done

