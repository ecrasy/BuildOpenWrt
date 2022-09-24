#########################################################################
# File Name: diy.sh
# Author: Carbon (ecras_y@163.com)
# Description: feel free to use
# Created Time: 2022-07-23 13:01:29 UTC
# Modified Time: 2022-08-16 05:43:43 UTC
#########################################################################


#!/bin/bash

# 修改默认IP为192.168.2.1
echo "Changing default LAN IP to 192.168.2.1"
[ -e package/base-files/files/bin/config_generate ] && sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate 

# 替换默认ash为bash
echo "Changing default shell from ash to bash"
[ -e package/base-files/files/etc/passwd ] && sed -i 's/\/bin\/ash/\/bin\/bash/g' package/base-files/files/etc/passwd

# 替换默认banner
echo "Replacing default ssh banner"
rm -rf package/base-files/files/etc/banner
cp $GITHUB_WORKSPACE/data/banner package/base-files/files/etc/banner

# 添加 model 修改脚本
echo "Adding model.sh"
cp $GITHUB_WORKSPACE/data/model.sh package/base-files/files/etc/
chmod +x package/base-files/files/etc/model.sh

# 添加 IPv6 hotplug 启动脚本
echo "Adding 99-ipv6"
mkdir -p package/base-files/files/etc/hotplug.d/iface
cp $GITHUB_WORKSPACE/data/99-ipv6 package/base-files/files/etc/hotplug.d/iface/99-ipv6
chmod +x package/base-files/files/etc/hotplug.d/iface/99-ipv6

# 替换默认theme
# [ -e feeds/luci/collections/luci/Makefile ] && sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

echo "DIY Completed!!!"
