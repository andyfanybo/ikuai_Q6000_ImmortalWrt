#!/bin/sh

# Keep ImmortalWrt/OpenWrt security defaults intact.
# Device-specific defaults that are safe for every deployment may be added here.
# Do not globally expose router services on WAN or disable DNS rebind protection.

echo "Applying Q6000 custom defaults..."

# Example:
# uci -q set system.@system[0].zonename='Asia/Shanghai'
# uci -q commit system

echo "Q6000 custom defaults applied."
exit 0
