#! /bin/sh
#
# If pfsense is the DCHP server, then it will likely have a good view of the arp->IP mapping
# Default pfsense does not have arpwatch - so install that package, and have it monitor interface of interest (probably LAN)
# If more than one interface is to be monitored, then the below script could be modified to loop over all.
#
# This script can be run as a regular user, or as root. It will need to be added to a start-up/on-boot script.
# Add the appropriate pfsense key to the '.ssh/authorized_keys' on the system that will be used to inject into alfred
#
# Note: there does not seem to be a port of alfred in the FreeBSD world at this time, otherwised pfSense could just inject directly

ARPWATCH_INTERFACE="igb1"
ALFRED_SERVER="root@192.168.2.1"
ALFRED_DHCP_EXCHANGE="68"
ALFRED_UPDATE_FREQ=290 # Alfred has a 10 minute timeout, this allows for one possible miss and still keeps the data fresh

while true; do
  ARPLIST=$(cat /usr/local/arpwatch/arp_${ARPWATCH_INTERFACE}.dat | awk '{ print $3, $1, $2, $4 }' | sort -r)
  ssh $ALFRED_SERVER "echo '$ARPLIST' | alfred -s $ALFRED_DHCP_EXHCANGE"
  sleep $ALFRED_UPDATE_FREQ
done
