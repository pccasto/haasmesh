if cat /sys/firmware/devicetree/base/model | grep -q "WRTQ-329ACN";  then 
echo "On a Luma - rotating eth ports"

cd /etc/config

sed -i s%eth2%eth3%g network
sed -i s%eth1%eth2%g network
sed -i s%eth0%eth1%g network
sed -i s%eth3%eth0%g network

cd -

batethifname=`uci get network.bat_eth.device`
echo "Backhaul ethernet is now $batethifname "
lanethifname=`uci get network.lan.device`
echo "LAN ethernet is now $lanethifname "
wanethifname=`uci get network.wan.device`
echo "WAN ethernet is now $wanethifname "

batethmac=`ifconfig | grep HW | grep $batethifname |cut -d ":" -f 3-|sed 's% %%g'`
uci set network.bat_eth.macaddr="00:${batethmac}"
uci changes
uci commit

/etc/init.d/network restart

else
echo "Not on a Luma"
fi
