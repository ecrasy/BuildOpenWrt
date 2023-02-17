#########################################################################
# File Name: fix.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: feel free to use
# Created Time: 2022-07-30 04:57:44 UTC
# Modified Time: 2023-02-17 10:33:53 UTC
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

# fixing dnsmasq v2.86 compile error
# from: https://github.com/openwrt/openwrt/issues/9043
dnsmasq_path="package/network/services/dnsmasq"
dnsmasq_ver=$(grep 'PKG_UPSTREAM_VERSION:=2.86' ${dnsmasq_path}/Makefile)
if [ ! -z "${dnsmasq_ver}" ]; then
    cp $GITHUB_WORKSPACE/data/patches/dnsmasq-struct-daemon.patch ${dnsmasq_path}/patches/
    echo "Fix dnsmasq v2.86 issue 9043"
else
# try nftables version 1.0.5 for dnsmasq v2.87
    nftables_path="package/network/utils/nftables"
    nftables_ver=$(grep 'PKG_VERSION:=0.9.6' ${nftables_path}/Makefile)
    if [ ! -z "${nftables_ver}" ]; then
        rm -rf package/network/utils/nftables
        cp -r $GITHUB_WORKSPACE/data/app/nftables  package/network/utils/
        echo "try nftables version 1.0.5 for dnsmasq v2.87"
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
sed -i "s/+odhcpd//g" package/feeds/routing/hnetd/Makefile
echo "Remove hnetd depends on odhcpd*"

# make shairplay depends on mdnsd instead of libavahi-compat-libdnssd
sed -i "s/+libavahi-compat-libdnssd/+mdnsd/g" feeds/packages/sound/shairplay/Makefile
echo "Set shairplay depends on mdnsd instead of libavahi-compat-libdnssd"

# replace miniupnpd from official openwrt feeds
upnp_ver=$(grep 'PKG_VERSION:=2.0.20170421' feeds/packages/net/miniupnpd/Makefile)
if [ ! -z "${upnp_ver}" ]; then
    rm -rf feeds/packages/net/miniupnpd
    cp -r $GITHUB_WORKSPACE/data/app/miniupnpd feeds/packages/net/
    echo "Replace miniupnpd from official openwrt feeds"
fi

# make luci-app-firewall depends on uci-firewall instead of firewall
sed -i 's/+firewall/+uci-firewall/g' feeds/luci/applications/luci-app-firewall/Makefile
echo "Set luci-app-firewall depends on uci-firewall instead of firewall"

# remove 98-passwall
rm -rf feeds/PWluci/luci-app-passwall/root/etc/hotplug.d/iface/98-passwall
echo "Remove passwall stupid restart script"

echo -e "Fixing Jobs Completed!!!\n"

