# BuildOpenWrt
Build LEDE OpenWrt with GitHub actions  
[官方源码编译版本](https://github.com/ecrasy/BuildOfficialOpenWrt)  

SmartDNS,FakeDNS,ChinaDNS-NG,Turbo-ACC等组件建议勿选  
经测试这些模块会拖累系统造成网络故障  

## Caution
最近来自中国大陆的Jia Cheong Tan  
向测试验证过程做了手脚  
一旦Linux发行版在编译过程后运行测试程序  
就会触发“植入后门”  
把后门植入xz 5.6.0 和 5.6.1，以及liblzma  
需要谨慎对待来自中国大陆的代码  
建议使用Lede版本的同学转向Official Openwrt  

## 项目介绍
使用GitHub Actions自动化编译L大的OpenWrt固件。  
默认支持IPv6路由功能。  
**开启DHCPv6：**  
![image](/pics/DHCPv6.jpg)  

**近来很多443非https端口被封，**  
建议将vps转变为web服务器，  
由nginx等服务端将代理转交给后台的v2ray，  
具体参看[Wiki教程](https://github.com/ecrasy/BuildOpenwrt/wiki)  

**有的梯子或者VPS不支持IPv6**  
路由在开启IPv6功能之后，  
都会有概率无法访问某些网站，  
有些是同一个网站只有某些子路径会有访问问题，  
此时可以尝试:  
在**网络->接口->LAN->IPv6设置**中，  
关闭**路由通告服务**和**DHCPv6 服务**，  
暂时恢复梯子功能。  

或者打开Passwall的过滤IPv6的功能  
这样既可以保持IPv6功能，同时还能继续无忧代理  
因为这个功能是实验性功能，不能保证100%成功  
![image](/pics/dns.jpg)  

## 支持X86-64和树莓派4B
1. configs文件夹中的config配置文件，  
   是使用openwrt源码的**scripts/diffconfig.sh**生成的。  
   可以使用命令**make defconfig**将config文件复原，  
   然后再**make menuconfig**或者**make**  
2. x86-64：x86-64系统格式workflows。  
3. RaspberryPi4B：树莓派4B系统格式workflows。  
4. 该系列workflows会自动保存toolchain至release。  
5. 重复编译时会自动拉取已经编译保存的toolchain。  

## 定制脚本
1. feeds.sh：修改该文件添加额外的packages，  
   不建议一次性添加**kenzok8**的包进行编译，  
   很多编译冲突。 
2. diy.sh：修改该文件自定义固件系统选项。  
3. fix.sh: 修正某些软件包package的编译错误。  

## Release固件发布
1. Firmware-x86-64-Kmod：预配置本地kmod软件源的x86-64固件。  
2. Firmware-x86-64：不使用本地kmod软件源的x86-64固件。  
3. Firmware-bcm2711-Kmod：预配置本地kmod软件源的树莓派4B固件。  
4. Firmware-bcm2711：不使用本地kmod软件源的树莓派4B固件。  
5. Toolchain-image：编译工具链，方便workflow一次编译多次使用。  

## 网络和代理 设置说明
1. 个人感觉Passwall比Passwall2和SSR+都好用。    
2. 网络->Lan->基本设置->静态地址->使用自定义的 DNS 服务器：  
   PPPOE拨号的可以留空，系统会自动处理。  
   网关地址请留空，系统会设置默认网关地址，  
   否则**状态->概览**会将Lan口信息显示为Wan口信息。  
3. IPv6设置->通告的 DNS 服务器:  
   PPPOE拨号的可以留空，系统会自动处理。  
4. 当地ISP服务商提供的DNS地址查看方法：  
   PPPoE拨号方式：主菜单进入“状态->概览”，可以查看。  
   DHCP和静态IP方式：请查看上级路由提供的信息。  
5. 新增AdGuardHome广告过滤，  
   这个版本的AdGuardHome只需要在开启功能前，  
   在重定向那里设置为使用：  
   **作为dnsmasq的上游服务器**  
   即可开启广告拦截功能，而且不影响Passwall的代理。      
6. diy.sh将默认shell更改为bash了，  
   所以在make menuconfig里面需要激活选择bash。  
7. 剔除turbo acc：  
   测试中发现，这软件负作用。  
   需要这软件的，可以使用命令make menuconfig勾选编译。
8. 通过VPS搭建代理请查看wiki  
   [Wiki教程](https://github.com/ecrasy/BuildOpenwrt/wiki)  
   
## 光猫桥接网络设置
Lan口设置：  
![image](/pics/LAN.jpg)
Wan口设置：  
PPPOE拨号设置略过不表，  
高级设置获取拨号下发的IPv6地址如下：
![image](/pics/WAN.jpg)
Wan6口设置：
![image](/pics/WAN6-1.jpg)
物理接口这里勾选**自定义接口**然后填\@**wan**  
![image](/pics/WAN6-2.jpg)
  
### 网络概览图
设置完成之后概览可以看到网络信息如下：
![image](/pics/network_info.jpg)


## 感谢以下项目 / 厂商:

| Github Actions                                        | OpenWrt 源码项目                                             | OpenWrt 构建项目                                             | 
| ----------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | 
| [Github Actions](https://github.com/features/actions) | [openwrt/openwrt](https://github.com/openwrt/openwrt/)       | [bigbugcc/OpenWrts](https://github.com/bigbugcc/OpenWrts) | 
|                                                       | [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)    | [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt) | 
|                                                       |                                                              | [SuLingGG/OpenWrt-Rpi](https://github.com/SuLingGG/OpenWrt-Rpi) | 

