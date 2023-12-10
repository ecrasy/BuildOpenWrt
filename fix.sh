#########################################################################
# File Name: fix.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: feel free to use
# Created Time: 2022-07-30 04:57:44 UTC
# Modified Time: 2023-12-10 23:55:04 UTC
#########################################################################


#!/bin/bash

# fix error from https://github.com/openwrt/luci/issues/5373
# luci-app-statistics: misconfiguration shipped pointing to non-existent directory
str="^[^#]*option Include '/etc/collectd/conf.d'"
cmd="s@$str@#&@"
sed -ri "$cmd" feeds/luci/applications/luci-app-statistics/root/etc/config/luci_statistics
echo "Fix luci-app-statistics ref wrong path error"

# fix stupid coremark benchmark error
touch package/base-files/files/etc/bench.log
chmod 0666 package/base-files/files/etc/bench.log
echo "Touch coremark log file to fix uhttpd error!!!"

# fix python3.9.12 sys version parse error
python3_path="feeds/packages/lang/python/python3"
cp $GITHUB_WORKSPACE/data/patches/lib-platform-sys-version.patch ${python3_path}/patches/
echo "Fix python host compile install error!!!"

# Try dnsmasq v2.89 with pkg version 7
dnsmasq_path="package/network/services/dnsmasq"
dnsmasq_ver=$(grep -m1 'PKG_UPSTREAM_VERSION:=2.89' ${dnsmasq_path}/Makefile)
if [ -z "${dnsmasq_ver}" ]; then
    rm -rf $dnsmasq_path
    cp $GITHUB_WORKSPACE/data/etc/ipcalc.sh package/base-files/files/bin/ipcalc.sh
    cp -r $GITHUB_WORKSPACE/data/dnsmasq ${dnsmasq_path}
    echo "Try dnsmasq v2.89"
else
# upgrade dnsmasq to version 2.89
    pkg_ver=$(grep -m1 'PKG_RELEASE:=7' ${dnsmasq_path}/Makefile)
    if [ -z "${pkg_ver}" ]; then
        # rm -rf $dnsmasq_path
        # cp $GITHUB_WORKSPACE/data/etc/ipcalc.sh package/base-files/files/bin/ipcalc.sh
        # cp -r $GITHUB_WORKSPACE/data/dnsmasq ${dnsmasq_path}
        echo "Already dnsmasq v2.89"
    fi
fi

# make minidlna depends on libffmpeg-full instead of libffmpeg
# little bro ffmpeg mini custom be gone
sed -i "s/libffmpeg /libffmpeg-full /g" feeds/packages/multimedia/minidlna/Makefile
echo "Set minidlna depends on libffmpeg-full instead of libffmpeg"

# make cshark depends on libustream-openssl instead of libustream-mbedtls
# i fucking hate stupid mbedtls so much, be gone
sed -i "s/libustream-mbedtls/libustream-openssl/g" feeds/packages/net/cshark/Makefile
echo "Set cshark depends on libustream-openssl instead of libustream-mbedtls"

# remove ipv6-helper depends on odhcpd*
sed -i "s/+odhcpd-ipv6only//g" package/lean/ipv6-helper/Makefile
echo "Remove ipv6-helper depends on odhcpd*"

# remove hnetd depends on odhcpd*
sed -i "s/+odhcpd//g" feeds/routing/hnetd/Makefile
echo "Remove hnetd depends on odhcpd*"

# make shairplay depends on mdnsd instead of libavahi-compat-libdnssd
sed -i "s/+libavahi-compat-libdnssd/+mdnsd/g" feeds/packages/sound/shairplay/Makefile
echo "Set shairplay depends on mdnsd instead of libavahi-compat-libdnssd"

# set v2raya depends on v2ray-core
sed -i "s/xray-core/v2ray-core/g" feeds/CustomPkgs/net/v2raya/Makefile
echo "set v2raya depends on v2ray-core"

# replace miniupnp with official openwrt feeds packages
upnp_ver=$(grep -m1 'PKG_VERSION:=2.0.20170421' feeds/packages/net/miniupnpd/Makefile)
if [ ! -z "${upnp_ver}" ]; then
    rm -rf feeds/packages/net/miniupnpd
    rm -rf feeds/packages/net/miniupnpc
    cp -r $GITHUB_WORKSPACE/data/app/miniupnpd feeds/packages/net/
    cp -r $GITHUB_WORKSPACE/data/app/miniupnpc feeds/packages/net/
    echo "Replace miniupnp with official openwrt feeds packages"
fi

# make luci-app-firewall depends on uci-firewall instead of firewall
sed -i 's/+firewall/+uci-firewall/g' feeds/luci/applications/luci-app-firewall/Makefile
echo "Set luci-app-firewall depends on uci-firewall instead of firewall"

echo -e "Fixing Jobs Completed!!!\n"

