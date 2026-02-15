#!/bin/bash

echo "Applying custom defaults..."

# 自动查找 wan zone
WAN_IDX=$(uci show firewall | grep "@zone" | grep "name='wan'" | cut -d[ -f2 | cut -d] -f1)

if [ -n "$WAN_IDX" ]; then
    uci set firewall.@zone[$WAN_IDX].input='ACCEPT'
    uci set firewall.@zone[$WAN_IDX].forward='ACCEPT'
    uci commit firewall
fi

# 关闭 DNS 重绑定保护
uci -q set dhcp.@dnsmasq[0].rebind_protection='0'
uci -q commit dhcp

echo "Custom defaults applied."
exit 0
