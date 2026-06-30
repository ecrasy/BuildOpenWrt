#########################################################################
# File Name: fix.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: feel free to use
# Created Time: 2022-07-30 04:57:44 UTC
# Modified Time: 2026-06-30 01:21:16 UTC
#########################################################################


#!/bin/bash

version_comp () {
    if [[ $1 == $2 ]]
    then
        echo "="
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if ((10#${ver1[i]:=0} > 10#${ver2[i]:=0}))
        then
            echo ">"
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            echo "<"
            return 2
        fi
    done

    echo "="
    return 0
}

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
# python3_path="feeds/packages/lang/python/python3"
# cp $GITHUB_WORKSPACE/data/patches/lib-platform-sys-version.patch ${python3_path}/patches/
# echo "Fix python host compile install error!!!"

# Try latest dnsmasq
dnsmasq_patch_path="$GITHUB_WORKSPACE/data/dnsmasq"
dnsmasq_package_path="package/network/services/dnsmasq"
puv_patch=$(grep -m1 'PKG_UPSTREAM_VERSION:=' ${dnsmasq_patch_path}/Makefile)
pr_patch=$(grep -m1 'PKG_RELEASE:=' ${dnsmasq_patch_path}/Makefile)
dnsmasq_ver_patch="${puv_patch##*=}.${pr_patch##*=}"
if [ -n "${dnsmasq_ver_patch}" ]; then
    puv_package=$(grep -m1 'PKG_UPSTREAM_VERSION:=' ${dnsmasq_package_path}/Makefile)
    pr_package=$(grep -m1 'PKG_RELEASE:=' ${dnsmasq_package_path}/Makefile)
    dnsmasq_ver_package="${puv_package##*=}.${pr_package##*=}"
    cr=$(version_comp "${dnsmasq_ver_package}" "${dnsmasq_ver_patch}")
    if [ "$cr" == "<" ]; then
        rm -rf ${dnsmasq_package_path}
        cp $GITHUB_WORKSPACE/data/etc/ipcalc.sh package/base-files/files/bin/ipcalc.sh
        cp -r ${dnsmasq_patch_path} ${dnsmasq_package_path}
        echo "Upgrade dnsmasq from ${dnsmasq_ver_package} to ${dnsmasq_ver_patch}"
    else
        echo "Dnsmasq no change need to make: ${dnsmasq_ver_package}"
    fi
fi

# Try latest golang
golang_feeds_path="feeds/packages/lang/golang"
golang_patch_path="$GITHUB_WORKSPACE/data/golang"
gp_default=$(grep -m1 'GO_DEFAULT_VERSION:=' ${golang_patch_path}/golang-values.mk)
gf_default=$(grep -m1 'GO_DEFAULT_VERSION:=' ${golang_feeds_path}/golang-values.mk)
golang_patch_default="${gp_default##*=}"
golang_feeds_default="${gf_default##*=}"
gvmm_patch=$(grep -m1 'GO_VERSION_MAJOR_MINOR:=' ${golang_patch_path}/golang${golang_patch_default}/Makefile)
gvp_patch=$(grep -m1 'GO_VERSION_PATCH:=' ${golang_patch_path}/golang${golang_patch_default}/Makefile)
golang_ver_patch="${gvmm_patch##*=}.${gvp_patch##*=}"
if [ -n "${golang_ver_patch}" ]; then
    gvmm_feeds=$(grep -m1 'GO_VERSION_MAJOR_MINOR:=' ${golang_feeds_path}/golang${golang_feeds_default}/Makefile)
    gvp_feeds=$(grep -m1 'GO_VERSION_PATCH:=' ${golang_feeds_path}/golang${golang_feeds_default}/Makefile)
    golang_ver_feeds="${gvmm_feeds##*=}.${gvp_feeds##*=}"
    cr=$(version_comp "${golang_ver_feeds}" "${golang_ver_patch}")
    if [ "$cr" == "<" ]; then
        rm -rf ${golang_feeds_path}
        cp -r ${golang_patch_path} ${golang_feeds_path}
        echo "Upgrade golang from ${golang_ver_feeds} to ${golang_ver_patch}"
    else
        echo "Golang no change need to make: ${golang_ver_feeds}"
    fi
fi

# Try latest v2ray-core
v2ray_patch_path="${GITHUB_WORKSPACE}/data/v2ray-core"
v2ray_feeds_path="feeds/packages/net/v2ray-core"
pv_patch=$(grep -m1 'PKG_VERSION:=' ${v2ray_patch_path}/Makefile)
v2ray_ver_patch="${pv_patch##*=}"
if [ -n "${v2ray_ver_patch}" ]; then
    if [ -d "${v2ray_feeds_path}" ]; then
        pv_feeds=$(grep -m1 'PKG_VERSION:=' ${v2ray_feeds_path}/Makefile)
        v2ray_ver_feeds="${pv_feeds##*=}"
        cr=$(version_comp "${v2ray_ver_feeds}" "${v2ray_ver_patch}")
        if [ "$cr" == "<" ]; then
            rm -rf ${v2ray_feeds_path}
            cp -r ${v2ray_patch_path} ${v2ray_feeds_path}
            echo "Upgrade v2ray-core from ${v2ray_ver_feeds} to ${v2ray_ver_patch}"
        else
            echo "v2ray-core no change need to make: ${v2ray_ver_feeds}"
        fi
    fi
fi

#Try latest v2ray-geodata
v2ray_geodata_patch_path="${GITHUB_WORKSPACE}/data/v2ray-geodata"
v2ray_geodata_feeds_path="feeds/packages/net/v2ray-geodata"
gv_patch=$(grep -m1 'GEOIP_VER:=' ${v2ray_geodata_patch_path}/Makefile)
v2ray_geodata_ver_patch="${gv_patch##*=}"
if [ -n "${v2ray_geodata_ver_patch}" ]; then
    if [ -d "${v2ray_geodata_feeds_path}" ]; then
        gv_feeds=$(grep -m1 'GEOIP_VER:=' ${v2ray_geodata_feeds_path}/Makefile)
        v2ray_geodata_ver_feeds="${gv_feeds##*=}"
        cr=$(version_comp "${v2ray_geodata_ver_feeds}" "${v2ray_geodata_ver_patch}")
        if [ "$cr" == "<" ]; then
            rm -rf ${v2ray_geodata_feeds_path}
            cp -r ${v2ray_geodata_patch_path} ${v2ray_geodata_feeds_path}
            echo "Upgrade v2ray-geodata from ${v2ray_geodata_ver_feeds} to ${v2ray_geodata_ver_patch}"
        else
            echo "v2ray-geodata no change need to make: ${v2ray_geodata_ver_feeds}"
        fi
    fi
fi

# make minidlna depends on libffmpeg-full not libffmpeg
minidlna_path="feeds/packages/multimedia/minidlna/Makefile"
if [ -f ${minidlna_path} ]; then
    sed -i "s/libffmpeg /libffmpeg-full /g" ${minidlna_path}
    echo "Set minidlna depends on libffmpeg-full not libffmpeg"
fi

# make cshark depends on libustream-openssl not libustream-mbedtls
# i fucking hate stupid mbedtls so much, be gone
cshark_path="feeds/packages/net/cshark/Makefile"
if [ -f ${cshark_path} ]; then
    sed -i "s/libustream-mbedtls/libustream-openssl/g" ${cshark_path}
    echo "Set cshark depends on libustream-openssl not libustream-mbedtls"
fi

# remove hnetd depends on odhcpd*
hnetd_path="feeds/routing/hnetd/Makefile"
if [ -f ${hnetd_path} ]; then
    sed -i "s/+odhcpd//g" ${hnetd_path}
    echo "Remove hnetd depends on odhcpd*"
fi

# make shairplay depends on mdnsd not libavahi-compat-libdnssd
shairplay_path=feeds/packages/sound/shairplay/Makefile
if [ -f ${shairplay_path} ]; then
    sed -i "s/+libavahi-compat-libdnssd/+mdnsd/g" ${shairplay_path}
    echo "Set shairplay depends on mdnsd not libavahi-compat-libdnssd"
fi

# remove ipv6-helper depends on odhcpd*
sed -i "s/+odhcpd-ipv6only//g" package/lean/ipv6-helper/Makefile
echo "Remove ipv6-helper depends on odhcpd*"

# set v2raya depends on v2ray-core
sed -i "s/xray-core/v2ray-core/g" feeds/CustomPkgs/net/v2raya/Makefile
echo "set v2raya depends on v2ray-core"

# upgrade libtorrent-rasterbar to latest version
ras_patch_path="${GITHUB_WORKSPACE}/data/app/libtorrent-rasterbar"
ras_feeds_path="feeds/packages/libs/libtorrent-rasterbar"
pv_patch=$(grep -m1 'PKG_VERSION:=' ${ras_patch_path}/Makefile)
pr_patch=$(grep -m1 'PKG_RELEASE:=' ${ras_patch_path}/Makefile)
ras_ver_patch="${pv_patch##*=}.${pr_patch##*=}"
if [ -n "${ras_ver_patch}" ]; then
    if [ -d "${ras_feeds_path}" ]; then
        pv_feeds=$(grep -m1 'PKG_VERSION:=' ${ras_feeds_path}/Makefile)
        pr_feeds=$(grep -m1 'PKG_RELEASE:=' ${ras_feeds_path}/Makefile)
        ras_ver_feeds="${pv_feeds##*=}.${pr_feeds##*=}"
        cr=$(version_comp "${ras_ver_feeds}" "${ras_ver_patch}")
        if [ "$cr" == "<" ]; then
            rm -rf ${ras_feeds_path}
            cp -r ${ras_patch_path} ${ras_feeds_path}
            echo "Upgrade libtorrent-rasterbar from ${ras_ver_feeds} to ${ras_ver_patch}"
        else
            echo "libtorrent-rasterbar no change need make: ${ras_ver_feeds} ${ras_ver_patch}"
        fi
    else
        rm -rf ${ras_feeds_path}
        cp -r ${ras_patch_path} ${ras_feeds_path}
        echo "Add libtorrent-rasterbar ${ras_ver_patch} to repo"
    fi
fi

if [ -d "${GITHUB_WORKSPACE}/data/app/hwinfo" ]; then
    hwinfo_path=feeds/packages/utils/hwinfo
    rm -rf ${hwinfo_path}
    cp -r $GITHUB_WORKSPACE/data/app/hwinfo feeds/packages/utils/
    echo "Try hwinfo from openwrt official repo"
fi

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

