#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: OpenWrt-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 修改 分区大小，默认 mod 分区大小为 112MB：0x7000000。改为 114MB：0x7200000
# sed -i '/label = "ubi"/{n;s/reg = <0x5c0000 0x[0-9a-f]\+>/reg = <0x5c0000 0x7000000>/}' target/linux/mediatek/dts/mt7981b-cudy-tr3000-v1.dts 

#Modify default IP
#sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
#sed -i 's/192.168.0.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 更改默认 Shell 为 zsh
#sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# 修改设备名称
# sed -i 's/OpenWrt/cudy/g' package/base-files/files/bin/config_generate

# 修改 argon 为默认主题,可根据你喜欢的修改成其他的（不选择那些会自动改变为默认主题的主题才有效果）
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

#sed -i "s/set \${s}.disabled='.\+'/set \${s}.disabled='0'/" package/network/config/wifi-scripts/files/lib/wifi/mediatek.sh

#允许root用户编译
#export FORCE_UNSAFE_CONFIGURE=1
