#########################################################################
# File Name: fix.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: feel free to use
# Created Time: 2022-07-30 04:57:44 UTC
# Modified Time: 2025-02-22 04:37:48 UTC
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

# Try latest dnsmasq
tmp_ver=$(grep -m1 'PKG_UPSTREAM_VERSION:=' $GITHUB_WORKSPACE/data/dnsmasq/Makefile)
tmp_pkg=$(grep -m1 'PKG_RELEASE:=' $GITHUB_WORKSPACE/data/dnsmasq/Makefile)
dnsmasq_data_ver="${tmp_ver##*=}.${tmp_pkg##*=}"
if [ -n "${dnsmasq_data_ver}" ]; then
    dnsmasq_path="package/network/services/dnsmasq"
    tmp_ver=$(grep -m1 'PKG_UPSTREAM_VERSION:=' ${dnsmasq_path}/Makefile)
    tmp_pkg=$(grep -m1 'PKG_RELEASE:=' ${dnsmasq_path}/Makefile)
    dnsmasq_repo_ver="${tmp_ver##*=}.${tmp_pkg##*=}"
    if [ "${dnsmasq_repo_ver}" != "${dnsmasq_data_ver}" ]; then
        rm -rf $dnsmasq_path
        cp $GITHUB_WORKSPACE/data/etc/ipcalc.sh package/base-files/files/bin/ipcalc.sh
        cp -r $GITHUB_WORKSPACE/data/dnsmasq ${dnsmasq_path}
        echo "Try dnsmasq ${dnsmasq_data_ver}"
    fi
fi

# Try latest golang
tmp_ver=$(grep -m1 'GO_VERSION_MAJOR_MINOR:=' $GITHUB_WORKSPACE/data/golang/golang/Makefile)
tmp_pkg=$(grep -m1 'GO_VERSION_PATCH:=' $GITHUB_WORKSPACE/data/golang/golang/Makefile)
golang_data_ver="${tmp_ver##*=}.${tmp_pkg##*=}"
if [ -n "${golang_data_ver}" ]; then
    golang_path="feeds/packages/lang/golang"
    tmp_ver=$(grep -m1 'GO_VERSION_MAJOR_MINOR:=' ${golang_path}/golang/Makefile)
    tmp_pkg=$(grep -m1 'GO_VERSION_PATCH:=' ${golang_path}/golang/Makefile)
    golang_feeds_ver="${tmp_ver##*=}.${tmp_pkg##*=}"
    if [ "${golang_feeds_ver}" != "${golang_data_ver}" ]; then
        rm -rf $golang_path
        cp -r $GITHUB_WORKSPACE/data/golang ${golang_path}
        echo "Try golang ${golang_data_ver}"
    fi
fi

# Try latest v2ray-core
tmp_ver=$(grep -m1 'PKG_VERSION:=' ${GITHUB_WORKSPACE}/data/v2ray-core/Makefile)
v2ray_data_ver="${tmp_ver##*=}"
if [ -n "${v2ray_data_ver}" ]; then
    v2ray_path="feeds/packages/net/v2ray-core"
    tmp_ver=$(grep -m1 'PKG_VERSION:=' ${v2ray_path}/Makefile)
    v2ray_feeds_ver="${tmp_ver##*=}"
    if  [ "${v2ray_feeds_ver}" != "${v2ray_data_ver}" ]; then
        rm -rf $v2ray_path
        cp -r $GITHUB_WORKSPACE/data/v2ray-core ${v2ray_path}
        echo "Try v2ray-core ${v2ray_data_ver}"
    fi
fi

# make minidlna depends on libffmpeg-full not libffmpeg
sed -i "s/libffmpeg /libffmpeg-full /g" feeds/packages/multimedia/minidlna/Makefile
echo "Set minidlna depends on libffmpeg-full not libffmpeg"

# make cshark depends on libustream-openssl not libustream-mbedtls
# i fucking hate stupid mbedtls so much, be gone
sed -i "s/libustream-mbedtls/libustream-openssl/g" feeds/packages/net/cshark/Makefile
echo "Set cshark depends on libustream-openssl not libustream-mbedtls"

# remove ipv6-helper depends on odhcpd*
sed -i "s/+odhcpd-ipv6only//g" package/lean/ipv6-helper/Makefile
echo "Remove ipv6-helper depends on odhcpd*"

# remove hnetd depends on odhcpd*
sed -i "s/+odhcpd//g" feeds/routing/hnetd/Makefile
echo "Remove hnetd depends on odhcpd*"

# make shairplay depends on mdnsd not libavahi-compat-libdnssd
shairplay_path=feeds/packages/sound/shairplay/Makefile
if [ -f ${shairplay_path} ]; then
    sed -i "s/+libavahi-compat-libdnssd/+mdnsd/g" ${shairplay_path}
    echo "Set shairplay depends on mdnsd not libavahi-compat-libdnssd"
fi

# set v2raya depends on v2ray-core
sed -i "s/xray-core/v2ray-core/g" feeds/CustomPkgs/net/v2raya/Makefile
echo "set v2raya depends on v2ray-core"

# replace miniupnp with official openwrt feeds packages
upnp_ver=$(grep -m1 'PKG_VERSION:=2.0.20170421' feeds/packages/net/miniupnpd/Makefile)
if [ -n "${upnp_ver}" ]; then
    rm -rf feeds/packages/net/miniupnpd
    rm -rf feeds/packages/net/miniupnpc
    cp -r $GITHUB_WORKSPACE/data/app/miniupnpd feeds/packages/net/
    cp -r $GITHUB_WORKSPACE/data/app/miniupnpc feeds/packages/net/
    echo "Replace miniupnp with official openwrt feeds packages"
fi

# make luci-app-firewall depends on uci-firewall not firewall
sed -i 's/+firewall/+uci-firewall/g' feeds/luci/applications/luci-app-firewall/Makefile
echo "Set luci-app-firewall depends on uci-firewall not firewall"

echo -e "Fixing Jobs Completed!!!\n"

