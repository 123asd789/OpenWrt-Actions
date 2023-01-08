sed -i '/exit 0/d' package/lean/default-settings/files/zzz-default-settings
sed -i '/openwrt_release/d' package/lean/default-settings/files/zzz-default-settings
echo "echo 'iptables -t mangle -A POSTROUTING -j TTL --ttl-set 128' >> /etc/firewall.user" >> package/lean/default-settings/files/zzz-default-settings
echo "echo 'iptables -t nat -N ntp_force_local' >> /etc/firewall.user" >> package/lean/default-settings/files/zzz-default-settings
echo "echo 'iptables -t nat -I PREROUTING -p udp --dport 123 -j ntp_force_local' >> /etc/firewall.user" >> package/lean/default-settings/files/zzz-default-settings
echo "echo 'iptables -t nat -A ntp_force_local -d 0.0.0.0/8 -j RETURN' >> /etc/firewall.user" >> package/lean/default-settings/files/zzz-default-settings
echo "echo 'iptables -t nat -A ntp_force_local -d 127.0.0.0/8 -j RETURN' >> /etc/firewall.user" >> package/lean/default-settings/files/zzz-default-settings
echo "echo 'iptables -t nat -A ntp_force_local -d 192.168.0.0/16 -j RETURN' >> /etc/firewall.user" >> package/lean/default-settings/files/zzz-default-settings
echo "echo 'iptables -t nat -A ntp_force_local -s 192.168.0.0/16 -j DNAT --to-destination 192.168.3.1' >> /etc/firewall.user" >> package/lean/default-settings/files/zzz-default-settings
echo "exit 0" >> package/lean/default-settings/files/zzz-default-settings
sed -i 's/192.168.1.1/192.168.3.1/g' package/base-files/files/bin/config_generate
sed -i "s/hostname='OpenWrt'/hostname='DESKTOP-RFK5J88'/g" package/base-files/files/bin/config_generate
sed -i "s/DISTRIB_REVISION=.*/DISTRIB_REVISION='$(date +"%Y%m%d")'/g" package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_DESCRIPTION=.*/DISTRIB_DESCRIPTION='OpenWrt By QiYueYi'/g" package/base-files/files/etc/openwrt_release
# 调整 V2ray服务器 到 VPN 菜单
sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/controller/*.lua
sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/model/cbi/v2ray_server/*.lua
sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/view/v2ray_server/*.htm
target=$(grep "^CONFIG_TARGET" .config --max-count=1 | awk -F "=" '{print $1}' | awk -F "_" '{print $3}')
for configFile in $(ls target/linux/$target/config*)
do
    echo -e "\nCONFIG_NETFILTER_NETLINK_GLUE_CT=y" >> $configFile
done