# File_Server_Docker
File Server Docker for GK2A-Docker and Himawari-8_Docker.


## Start:

1. Install docker-ce:
```
[tcjj3@debian]$ sudo apt install -y curl
[tcjj3@debian]$ curl -fsSL get.docker.com -o get-docker.sh
[tcjj3@debian]$ sudo sh get-docker.sh
[tcjj3@debian]$ sudo groupadd docker
[tcjj3@debian]$ sudo usermod -aG docker $USER
[tcjj3@debian]$ sudo systemctl enable docker && sudo systemctl start docker
```

2. Run File_Server_Docker:
```
[tcjj3@debian]$ sudo docker volume create xrit-rx
[tcjj3@debian]$ sudo docker volume create himawari-rx
[tcjj3@debian]$ sudo docker run -d -i -t \
 --restart always \
 --name=File_Server \
 --net=host \
 -e FTP_PORT="21" \
 -e FTP_PASSIVE_PORTS="2500" \
 -v xrit-rx:/usr/local/bin/file_server/xrit-rx \
 -v himawari-rx:/usr/local/bin/file_server/himawari-rx \
 tcjj3/file_server_docker:latest
```

**In this part, "`21`" is the `FTP port`, and "`2500`" is the `FTP Passive port` (If you want to bind any free port, just set it to `0`). If you want to change these ports, just modify the numbers in "`-e`" arguments.**
<br>

**Like this (set the `FTP Passive port` to `0` for binding any free port):**
```
[tcjj3@debian]$ sudo docker volume create xrit-rx
[tcjj3@debian]$ sudo docker volume create himawari-rx
[tcjj3@debian]$ sudo docker run -d -i -t \
 --restart always \
 --name=File_Server \
 --net=host \
 -e FTP_PORT="21" \
 -e FTP_PASSIVE_PORTS="0" \
 -v xrit-rx:/usr/local/bin/file_server/xrit-rx \
 -v himawari-rx:/usr/local/bin/file_server/himawari-rx \
 tcjj3/file_server_docker:latest
```

**If you want to use bridge network mode for this container, just remove the "`--net=host`" argument, then add "`FTP_OVERRIDE_IP`"(`FTP Passive IP`) environment variable and add `port forward` arguments using "`-e`" argument.**
<br>
**Like this (in this case, I had wrote some codes to get the `host IP` automatic for "`FTP_OVERRIDE_IP`"(`FTP Passive IP`), and please make sure "`FTP_PASSIVE_PORTS`" is not `0`, because it's not convenience to forward the ports which is using in `FTP Passive mode`):**
```
[tcjj3@debian]$ sudo docker volume create xrit-rx
[tcjj3@debian]$ sudo docker volume create himawari-rx
[tcjj3@debian]$ sudo docker run -d -i -t \
 --restart always \
 --name=File_Server \
 -e FTP_OVERRIDE_IP="$(local_ip=$(ip route get 8.8.8.8 oif $(cat /proc/net/route | awk '{print $1}' | head -n 2 | tail -n 1)) && ([ -z "$(echo $local_ip | grep 'via' | head -n 1)" ] && echo $(echo $local_ip | awk '{print $5}')) || echo $(echo $local_ip | awk '{print $7}'))" \
 -e FTP_PORT="21" \
 -e FTP_PASSIVE_PORTS="2500" \
 -p 21:21 \
 -p 2500:2500 \
 -p 137:137/udp \
 -p 138:138/udp \
 -p 139:139 \
 -p 445:445 \
 -v xrit-rx:/usr/local/bin/file_server/xrit-rx \
 -v himawari-rx:/usr/local/bin/file_server/himawari-rx \
 tcjj3/file_server_docker:latest
```
**In this part, "`21`" is the `FTP` port, and "`2500`" is the `FTP Passive port`. If you want to change these ports, just modify the numbers both in "`-e`" and "`-p`" arguments.**
<br>

**Notice: These FTP port numbers are recommended to be set in the range of `1025-65534`, or it probably not working on some machines.**
<br>
<br>

**"`137-138/udp`" ports are for "`nmbd`", "`139`" and "`445`" ports are for "`smbd`", these ports would be used by default, so please make sure these ports on your host are not binded by other programs.**
<br>

**Notice: If your docker volume(s) are mount by `vmhgfs-fuse`, please using "``-o subtype=vmhgfs-fuse,allow_other``" argument like "``vmhgfs-fuse .host:/ /mnt/hgfs -o subtype=vmhgfs-fuse,allow_other``" to mount them to make smbd could access them.**


## Get Files

### Local Disk
1. xrit-rx:
```
[tcjj3@debian]$ cd /var/lib/docker/volumes/xrit-rx/_data
```
2. himawari-rx:
```
[tcjj3@debian]$ cd /var/lib/docker/volumes/himawari-rx/_data
```

### Via Remote Disk

1. Samba:
```
\\[Your IP]
```

2. FTP:
```
ftp://[Your IP]:21
```

