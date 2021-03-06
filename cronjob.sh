#!/bin/sh

##### Config

use_owi2plex="yes"
use_xTeveAPI="no"
use_TVH_Play="no"
use_TVH_move="no"

### List bouquets to grab from enigma owi
# sample with 2 buoquets to grab epg
bouquets="UHD SPORT"

### owi credentials
owi_ip="192.168.1.103"
owi_user="root"
owi_pass="password"

### xTeve ip, Port in case API is used to update XEPG
xTeveIP="192.168.1.2"
xTevePORT="34400"

### TVHeadend ip, Port in case m3u Playlist is wanted
TVHIP="192.168.1.2"
TVHPORT="9981"
TVHUSER="username"
TVHPASS="password"
TVHOUT="/root/.xteve/data/channels.m3u"

### Copy a final xml (sample xteve) to tvheadend Data ### u have to mount TVHPATH data dir
TVHSOURCE="/root/.xteve/data/xteve.xml"
TVHPATH="/TVH"

# cronjob, check sample_cron.txt with an editor to adjust time

### END Config
##
#

# run owi2plex in loop
if [ "$use_owi2plex" = "yes" ]; then
	for bouquet in $bouquets
		do
		owi2plex -h $owi_ip -u $owi_user -p $owi_pass -b $bouquet -o /owi2plex/enigma$bouquet.xml >> /dev/null
	done
fi

sleep 1

# get TVH playlist
if [ "$use_TVH_Play" = "yes" ]; then
	if [ -z "$TVHIP" ]; then
		echo "no TVHeadend credentials"
	else
		if [ -z "$TVHUSER" ]; then
			wget -O $TVHOUT http://$TVHIP:$TVHPORT/playlist
		else
			wget -O $TVHOUT http://$TVHUSER:$TVHPASS@$TVHIP:$TVHPORT/playlist
		fi
	fi
fi

sleep 1

# update xteve via API
if [ "$use_xTeveAPI" = "yes" ]; then
	if [ -z "$xTeveIP" ]; then
		echo "no xTeve credentials"
	else
		curl -X POST -d '{"cmd":"update.xmltv"}' http://$xTeveIP:$xTevePORT/api/
		sleep 1
		curl -X POST -d '{"cmd":"update.xepg"}' http://$xTeveIP:$xTevePORT/api/
		sleep 1
	fi
fi

# copy file to TVHeadend
if [ "$use_TVH_move" = "yes" ]; then
	if [ -z "$TVHPATH" ]; then
		echo "no Path credential"
	else
		cp $TVHSOURCE $TVHPATH/guide.xml
	fi
fi

exit
