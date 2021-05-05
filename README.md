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

**In this part, "`21`" is the `FTP` port, and "`2500`" is the `FTP Passiv` port. If you want to change these ports, just modify the numbers in "`-e`" argument.**
<br>
**Notice: These FTP port numbers are recommended to be set in the range of `1025-65534`, or it probably not working on some machines.**
<br>
**"`137-138/udp`" ports are for "`nmbd`", "`139`" and "`445`" ports are for "`smbd`", these ports would be used by default, so please make sure these ports on your host are not binded by other programs.**


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

