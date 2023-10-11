#########################################################################
# File Name: set_depends.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: feel free to use
# Description: run this script once before make menuconfig
# Created Time: 2022-12-18 14:15:22 UTC
# Modified Time: 2023-10-11 03:01:21 UTC
#########################################################################

#!/bin/bash

usage() { echo "Usage: $0 <openwrt source dir1> <openwrt source dir2> ..." 1>&2; exit 1; }
if [ $# -lt 1 ]; then
    usage
fi

for op_dir in $@
do
    openwrt_dir=$(echo "$op_dir" | xargs realpath -s | sed 's:/*$::')
    cd "$openwrt_dir"
    echo "================================================================"
    echo -e "update source code: $openwrt_dir\n"
    git pull && ./scripts/feeds update -a && ./scripts/feeds install -a
    echo -e "\nTry to fix $openwrt_dir depends issue\n"

    # set minidlna depends on libffmpeg
    sed -i "s/libffmpeg /libffmpeg-full /g" feeds/packages/multimedia/minidlna/Makefile
    echo "Set minidlna depends on libffmpeg-full instead of libffmpeg"
    fr=$(grep -m1 "libffmpeg-full " feeds/packages/multimedia/minidlna/Makefile)
    if [ ! -z "$fr" ]; then
        echo -e "operation success:\n${fr:0:50}\n"
    else
        echo -e "operation fail\n"
    fi

    # set cshark depends on openssl
    sed -i "s/libustream-mbedtls/libustream-openssl/g" feeds/packages/net/cshark/Makefile
    echo "Set cshark depends on libustream-openssl instead of libustream-mbedtls"
    fr=$(grep -m1 "libustream-openssl" feeds/packages/net/cshark/Makefile)
    if [ ! -z "$fr" ]; then
        echo -e "operation success:\n${fr:0:50}\n"
    else
        echo -e "operation fail\n"
    fi

    # remove ipv6-helper depends on odhcpd*
    sed -i "s/+odhcpd-ipv6only//g" package/lean/ipv6-helper/Makefile
    echo "Remove ipv6-helper depends on odhcpd*"
    fr=$(grep -m1 "odhcpd" package/lean/ipv6-helper/Makefile)
    if [ -z "$fr" ]; then
        echo -e "operation success\n"
    else
        echo -e "operation fail:\n${fr:0:50}\n"
    fi

    # remove hnetd depends on odhcpd*
    sed -i "s/+odhcpd//g" feeds/routing/hnetd/Makefile
    echo "Remove hnetd depends on odhcpd*"
    fr=$(grep -m1 "odhcpd" feeds/routing/hnetd/Makefile)
    if [ -z "$fr" ]; then
        echo -e "operation success\n"
    else
        echo -e "operation fail:\n${fr:0:50}\n"
    fi

    # set shairplay depends on mdnsd
    sed -i "s/+libavahi-compat-libdnssd/+mdnsd/g" feeds/packages/sound/shairplay/Makefile
    echo "Set shairplay depends on mdnsd instead of libavahi-compat-libdnssd"
    fr=$(grep -m1 "mdnsd" feeds/packages/sound/shairplay/Makefile)
    if [ ! -z "$fr" ]; then
        echo -e "operation success:\n${fr:0:50}\n"
    else
        echo -e "operation fail\n"
    fi

    # make luci-app-firewall depends on uci-firewall instead of firewall
    sed -i 's/+firewall/+uci-firewall/g' feeds/luci/applications/luci-app-firewall/Makefile
    echo "Set luci-app-firewall depends on uci-firewall instead of firewall"
    fr=$(grep -m1 "uci-firewall" feeds/luci/applications/luci-app-firewall/Makefile)
    if [ ! -z "$fr" ]; then
        echo -e "operation success:\n${fr:0:50}\n"
    else
        echo -e "operation fail\n"
    fi

    # set v2raya depends on v2ray-core
    sed -i "s/xray-core/v2ray-core/g" feeds/CustomPkgs/net/v2raya/Makefile
    echo "set v2raya depends on v2ray-core"
    fr=$(grep -m1 "v2ray-core" feeds/CustomPkgs/net/v2raya/Makefile)
    if [ ! -z "$fr" ]; then
        echo -e "operation v2raya success:\n${fr:0:50}\n"
    else
        echo -e "operation v2raya fail\n"
    fi

    echo "Fix $openwrt_dir completed!!!"
    echo -e "================================================================\n"
    cd ~-
done

