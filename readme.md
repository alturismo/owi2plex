# owi2plex in docker with cron

after docker start check your config folder and do your setups, setup is persistent, start from scratch by delete them

cron start options are updated on docker restart.

mounts to use as sample \
Container Path: /config <> /mnt/user/appdata/owi2plex/_config/ \
Container Path: /owi2plex <> /mnt/user/appdata/owi2plex/ \
Container Path: /TVH <> /mnt/user/appdata/tvheadend/data/ << not needed if no TVHeadend is used \
while /mnt/user/appdata/ should fit to your system path ...

```
docker run -d \
  --name=owi2plex \
  --net=bridge \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  -e TZ="Europe/Berlin" \
  -v /mnt/user/appdata/owi2plex/_config:/config:rw \
  -v /mnt/user/appdata/owi2plex/:/owi2plex:rw \
  alturismo/owi2plex
```

to test the cronjob functions \
docker exec -it "dockername" ./config/cronjob.sh

included functions are (all can be individual turned on / off)

owi2plex - xmltv epg grabber for enigma receivers using open web, thanks to @cvarelaruiz \
github: https://github.com/cvarelaruiz/owi2plex

some small script lines cause i personally use tvheadend and get playlist for xteve and cp xml data to tvheadend

so, credits to the programmers, i just putted this together in a docker to fit my needs 
