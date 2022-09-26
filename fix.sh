#########################################################################
# File Name: fix.sh
# Author: Carbon (ecras_y@163.com)
# Description: feel free to use
# Created Time: 2022-07-30 04:57:44 UTC
# Modified Time: 2022-09-26 01:36:31 UTC
#########################################################################


#!/bin/bash

# 修正cjdns编译错误
# sed -i 's/ -Wno-error=stringop-overflow//g' package/feeds/routing/cjdns/Makefile
# sed -i 's/ -Wno-error=stringop-overread//g' package/feeds/routing/cjdns/Makefile
# echo "Fixing cjdns makefile error!!!"

# 修正e2guardian编译错误
# sed -i 's/-fno-rtti/-fno-rtti -std=c++14/g' package/network/services/e2guardian/Makefile
# echo "Fixing e2guardian compile error!!!"

# 修正lua-eco的递归依赖错误
# sed -i 's/ +PACKAGE_libwolfssl:libwolfssl//g' feeds/packages/lang/lua-eco/Makefile
# echo "Fixing lua-eco config error!!!"

# 删除冗余的包
rm -rf feeds/CustomPkgs/adguardhome
echo "Remove unused packages!!!"

