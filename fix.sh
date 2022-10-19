#########################################################################
# File Name: fix.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: feel free to use
# Created Time: 2022-07-30 04:57:44 UTC
# Modified Time: 2022-10-19 10:50:42 UTC
#########################################################################


#!/bin/bash

# fixing cjdns compile error
# sed -i 's/ -Wno-error=stringop-overflow//g' package/feeds/routing/cjdns/Makefile
# sed -i 's/ -Wno-error=stringop-overread//g' package/feeds/routing/cjdns/Makefile
# echo "Fixing cjdns makefile error!!!"

# fixing e2guardian compile error
# sed -i 's/-fno-rtti/-fno-rtti -std=c++14/g' package/network/services/e2guardian/Makefile
# echo "Fixing e2guardian compile error!!!"

# fixing lua-eco recursive depend error
# sed -i 's/ +PACKAGE_libwolfssl:libwolfssl//g' feeds/packages/lang/lua-eco/Makefile
# echo "Fixing lua-eco config error!!!"

# fixing qtbase package hash
# sed -i '/official_releases/d' package/feeds/packages/qtbase/Makefile
# echo "Fixing qtbase hash error!!!"

# remove adguardhome dup package
rm -rf feeds/CustomPkgs/adguardhome
echo "Remove unused adguardhome binary packages!!!"

# fixing error from https://github.com/openwrt/luci/issues/5373
# luci-app-statistics: misconfiguration shipped pointing to non-existent directory
str="[ \f\r\t\n]*option Include '/etc/collectd/conf.d'"
cmd="s@$str@#&@"
sed -ri "$cmd" feeds/luci/applications/luci-app-statistics/root/etc/config/luci_statistics
echo "Fixing luci-app-statistics error from github.com/openwrt/luci/issues/5373"

# fixing stupid coremark error
touch package/base-files/files/etc/bench.log
chmod 0666 package/base-files/files/etc/bench.log
echo "Touching coremark log file to fix uhttpd error!!!"

# fixing python3.9.12 sys version parse error
cp $GITHUB_WORKSPACE/data/lib-platform-sys-version.patch feeds/packages/lang/python/python3/patches/
echo "Fixing python host compile install error!!!"

echo "FIX Completed!!!"

