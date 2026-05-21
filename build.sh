#!/bin/sh

# 先执行 prepare-packages.sh 此脚本用于拷贝所有自定义ipk到packages目录
sh prepare-packages.sh
# 以下是仓库内的包名 你可以在 openwrt 官网仓库查询插件名称：
# https://downloads.openwrt.org/releases/24.10.6/packages/x86_64/luci/
# https://mirrors.aliyun.com/openwrt/releases/24.10.6/packages/x86_64/luci/

# ===== 基础包（BASE_PACKAGES） =====
BASE_PACKAGES=""
BASE_PACKAGES="$BASE_PACKAGES curl"
BASE_PACKAGES="$BASE_PACKAGES -dnsmasq" # 去除基础 dnsmasq
# 此处为什么勾选完整版 dnsmasq-full 因为 openclash 需要该依赖 由于 dnsmasq 和 dnsmasq-full 在安装上互斥 因此只能保留一个 减号代表去除
BASE_PACKAGES="$BASE_PACKAGES dnsmasq-full"
BASE_PACKAGES="$BASE_PACKAGES luci"
BASE_PACKAGES="$BASE_PACKAGES bash"
BASE_PACKAGES="$BASE_PACKAGES block-mount"
BASE_PACKAGES="$BASE_PACKAGES fdisk"
BASE_PACKAGES="$BASE_PACKAGES ethtool"
BASE_PACKAGES="$BASE_PACKAGES tcpdump"
BASE_PACKAGES="$BASE_PACKAGES ip-full"
BASE_PACKAGES="$BASE_PACKAGES kmod-hwmon-core"
BASE_PACKAGES="$BASE_PACKAGES kmod-nft-socket"
BASE_PACKAGES="$BASE_PACKAGES kmod-nft-tproxy"
BASE_PACKAGES="$BASE_PACKAGES htop"
BASE_PACKAGES="$BASE_PACKAGES pciutils"
BASE_PACKAGES="$BASE_PACKAGES usbutils"
BASE_PACKAGES="$BASE_PACKAGES wget-ssl"
BASE_PACKAGES="$BASE_PACKAGES kmod-usb3"
BASE_PACKAGES="$BASE_PACKAGES kmod-usb-xhci-hcd"
BASE_PACKAGES="$BASE_PACKAGES kmod-usb-storage"
BASE_PACKAGES="$BASE_PACKAGES kmod-usb-storage-uas"
BASE_PACKAGES="$BASE_PACKAGES kmod-tcp-bbr"
BASE_PACKAGES="$BASE_PACKAGES kmod-atlantic"
BASE_PACKAGES="$BASE_PACKAGES lm-sensors-detect"
BASE_PACKAGES="$BASE_PACKAGES kmod-usb-hid"
BASE_PACKAGES="$BASE_PACKAGES kmod-lib-zstd"
BASE_PACKAGES="$BASE_PACKAGES kmod-fs-f2fs"
BASE_PACKAGES="$BASE_PACKAGES openssh-sftp-server"
BASE_PACKAGES="$BASE_PACKAGES i915-firmware-dmc"
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-base-zh-cn"
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-ttyd-zh-cn"
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-package-manager-zh-cn"
BASE_PACKAGES="$BASE_PACKAGES luci-compat"
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-firewall-zh-cn"
# 文件管理器
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-filemanager-zh-cn"
# openlist用来平替alist 目前阿里云镜像仓库也有了
#BASE_PACKAGES="$BASE_PACKAGES luci-i18n-openlist-zh-cn"
# 打印机相关
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-p910nd-zh-cn"
#BASE_PACKAGES="$BASE_PACKAGES luci-i18n-openvpn-zh-cn"

# ===== 自定义包（CUSTOM_PACKAGES：放 extra-packages 目录的三方包） =====
CUSTOM_PACKAGES=""
# 第三方插件 文件传输 luci-app-filetransfer
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-lib-fs"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-lua-runtime"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-filetransfer"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-filetransfer-zh-cn"
# 第三方插件 argon主题 luci-theme-argon 紫色主题 3个ipk
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-theme-argon"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-argon-config-zh-cn"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-argon-config"
# 其余三方插件全部保持注释，想用打开注释即可
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-store"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-quickstart"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-quickstart-zh-cn"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-adguardhome"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-openclash"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-passwall"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-passwall-zh-cn"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES geoview"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES xray-core"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES sing-box"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES hysteria"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-ssr-plus"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-homeproxy-zh-cn"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-homeproxy"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-nikki-zh-cn"

# 校验自定义包名合法性
package_file="packages_names.txt"
for pkg in $CUSTOM_PACKAGES; do
  if ! grep -qx "$pkg" "$package_file"; then
    echo "❌ 错误：包 $pkg 不存在于 $package_file 中 请检查自定义包名是否正确!"
    exit 1
  fi
done

# ===== 移除不需要的包（REMOVE_PACKAGES） =====
REMOVE_PACKAGES=""
REMOVE_PACKAGES="$REMOVE_PACKAGES -kmod-amazon-ena"
REMOVE_PACKAGES="$REMOVE_PACKAGES -kmod-amd-xgbe"
REMOVE_PACKAGES="$REMOVE_PACKAGES -kmod-bnx2"
REMOVE_PACKAGES="$REMOVE_PACKAGES -kmod-e1000e"
REMOVE_PACKAGES="$REMOVE_PACKAGES -kmod-e1000"
REMOVE_PACKAGES="$REMOVE_PACKAGES -kmod-forcedeth"
REMOVE_PACKAGES="$REMOVE_PACKAGES -kmod-igb"
REMOVE_PACKAGES="$REMOVE_PACKAGES -kmod-ixgbe"
REMOVE_PACKAGES="$REMOVE_PACKAGES -kmod-r8169"
REMOVE_PACKAGES="$REMOVE_PACKAGES -kmod-tg3"
REMOVE_PACKAGES="$REMOVE_PACKAGES -luci-app-attendedsysupgrade"

# ===== 最终组合 =====
PACKAGES="$BASE_PACKAGES $CUSTOM_PACKAGES $REMOVE_PACKAGES"

# 若构建 openclash 则添加内核
if echo "$PACKAGES" | grep -q "luci-app-openclash"; then
    echo "✅ [构建逻辑] 已选择 luci-app-openclash，添加 openclash core"
    mkdir -p files/etc/openclash/core
    if [ -f extra-packages/temp-unpack/clash_meta ]; then
        cp extra-packages/temp-unpack/clash_meta files/etc/openclash/core/clash_meta
    else
        echo "⚠️ [警告] 缺少 clash_meta 内核,跳过复制,你应该确保extra-packages目录下有相关run文件"
    fi
else
    echo "⚪️ [构建逻辑] 未选择 luci-app-openclash"
    [ -d files/etc/openclash ] && rm -rf files/etc/openclash
fi

# 若构建 luci-app-adguardhome 则添加内核
if echo "$PACKAGES" | grep -q "luci-app-adguardhome"; then
    echo "✅ [构建逻辑] 已选择 luci-app-adguardhome，添加 AdGuardHome core"
    if [ -f extra-packages/temp-unpack/AdGuardHome/AdGuardHome ]; then
        cp extra-packages/temp-unpack/AdGuardHome/AdGuardHome files/usr/bin/AdGuardHome
    else
        echo "⚠️ [警告] 缺少 AdGuardHome内核,跳过复制,你应该确保extra-packages目录下有相关run文件"
    fi
else
    echo "⚪️ [构建逻辑] 未选择 luci-app-adguardhome"
    [ -f files/usr/bin/AdGuardHome ] && rm -f files/usr/bin/AdGuardHome
fi

# 开始构建 软件包大小1024代表1GB 
# 可选参数FILES=files 代表files目录中若有文件 则覆盖openwrt的根目录 原样注入  
# 例如files/etc对应覆盖openwrt系统/etc目录中的文件 
# 例如files/mnt对应覆盖openwrt系统/mnt目录中的文件 
OUTPUT_DIR=$(pwd)/output
mkdir -p $OUTPUT_DIR
make image PROFILE=generic PACKAGES="$PACKAGES"  FILES=files ROOTFS_PARTSIZE=1024 BIN_DIR=$OUTPUT_DIR
ls -lah $OUTPUT_DIR
