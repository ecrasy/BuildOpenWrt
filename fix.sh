#########################################################################
# File Name: fix.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: feel free to use
# Created Time: 2022-07-30 04:57:44 UTC
# Modified Time: 2022-10-25 01:20:16 UTC
#########################################################################


#!/bin/bash

# fix cjdns compile error
# sed -i 's/ -Wno-error=stringop-overflow//g' package/feeds/routing/cjdns/Makefile
# sed -i 's/ -Wno-error=stringop-overread//g' package/feeds/routing/cjdns/Makefile
# echo "Fix cjdns makefile error!!!"

# fix e2guardian compile error
# sed -i 's/-fno-rtti/-fno-rtti -std=c++14/g' package/network/services/e2guardian/Makefile
# echo "Fix e2guardian compile error!!!"

# fix lua-eco recursive depend error
# sed -i 's/ +PACKAGE_libwolfssl:libwolfssl//g' feeds/packages/lang/lua-eco/Makefile
# echo "Fix lua-eco config error!!!"

# fix qtbase package hash
# sed -i '/official_releases/d' package/feeds/packages/qtbase/Makefile
# echo "Fix qtbase hash error!!!"

# fix error from https://github.com/openwrt/luci/issues/5373
# luci-app-statistics: misconfiguration shipped pointing to non-existent directory
str="[ \f\r\t\n]*option Include '/etc/collectd/conf.d'"
cmd="s@$str@#&@"
sed -ri "$cmd" feeds/luci/applications/luci-app-statistics/root/etc/config/luci_statistics
echo "Fix luci-app-statistics error from github.com/openwrt/luci/issues/5373"

# fix stupid coremark benchmark error
touch package/base-files/files/etc/bench.log
chmod 0666 package/base-files/files/etc/bench.log
echo "Touch coremark log file to fix uhttpd error!!!"

# fix python3.9.12 sys version parse error
cd $GITHUB_WORKSPACE/data
cp patches/lib-platform-sys-version.patch feeds/packages/lang/python/python3/patches/
cd -
echo "Fix python host compile install error!!!"

echo "FIX Completed!!!"

