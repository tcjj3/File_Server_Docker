#!/bin/sh






/etc/init.d/cron restart







mkdir -p /etc/samba

cat << EOF > /etc/samba/smb_server.conf
[global]
	netbios name = Server
	display charset = UTF-8
	interfaces = loopback lan 
	server string = Server smb share
	unix charset = UTF-8
	workgroup = WORKGROUP
	browseable = yes
	deadtime = 30
	domain master = yes
	encrypt passwords = true
	enable core files = no
	guest account = nobody
	guest ok = yes
	invalid users = root
	local master = yes
	load printers = no
	map to guest = Bad User
	max protocol = SMB2
	min receivefile size = 8192
	null passwords = yes
	obey pam restrictions = yes
	os level = 20
	passdb backend = smbpasswd
	preferred master = yes
	printable = no
	security = user
	smb encrypt = disabled
	smb passwd file = /etc/samba/smbpasswd
	socket options = TCP_NODELAY IPTOS_LOWDELAY SO_RCVBUF=65535 SO_SNDBUF=65535
	syslog = 2
	use sendfile = yes
	use mmap = yes
	writeable = yes
	log level = 0
	disable spoolss = yes
	host msdfs = no
	unix extensions = no

	admin users = nobody

#============== Share Definitions ==============
[Server]
	path = /usr/local/bin/file_server
	read only = no
	guest ok = yes
	create mask = 0777
	directory mask = 0777



EOF









if [ -z "$FTP_PORT" ]; then
	FTP_PORT="21"
fi

if [ -z "$FTP_PASSIVE_PORTS" ]; then
	FTP_PASSIVE_PORTS="2500"
fi


cat << EOF > /etc/bftpd_server.conf
global {
  DENY_LOGIN="no"
  PORT="$FTP_PORT"
  PASSIVE_PORTS="$FTP_PASSIVE_PORTS"
  DATAPORT20="no"
  ADMIN_PASS="x"
  #PATH_BFTPDUTMP="/var/run/bftpd/bftpdutmp"
  XFER_BUFSIZE="2048"
  CHANGE_BUFSIZE="no"
  XFER_DELAY="0"
  SHOW_HIDDEN_FILES="yes"
  SHOW_NONREADABLE_FILES="yes"
  ALLOW_FXP="no"
  CONTROL_TIMEOUT="300"
  DATA_TIMEOUT="30"
  RATIO="none"
  #ROOTDIR="%h"
  ROOTDIR="/"
  INITIAL_CHROOT="/usr/local/bin/file_server"
  UMASK="022"
  LOGFILE="syslog"
  HELLO_STRING="bftpd %v at %i ready."
  AUTO_CHDIR="/"
  AUTH="PASSWD"
  FILE_AUTH="/etc/ftpdpassword"
  RESOLVE_CLIENT_IP="no"
  MOTD_GLOBAL="/etc/issue.net"
  MOTD_USER="/.ftpmotd"
  RESOLVE_UIDS="yes"
  #DO_CHROOT="yes"
  DO_CHROOT="no"
  LOG_WTMP="yes"
  BIND_TO_ADDR="any"
  PATH_FTPUSERS="/etc/ftpusers"
  AUTH_ETCSHELLS="no"
  ALLOWCOMMAND_DELE="yes"
  ALLOWCOMMAND_STOR="yes"
  ALLOWCOMMAND_SITE="yes"
  HIDE_GROUP=""
  QUIT_MSG="See you later..."
  USERLIMIT_GLOBAL="0"
  USERLIMIT_SINGLEUSER="0"
  USERLIMIT_HOST="0"
  GZ_UPLOAD="no"
  GZ_DOWNLOAD="no"
  ANONYMOUS_USER="yes"
  CHANGE_UID="no"
}
user ftp {
  ANONYMOUS_USER="yes"
  DO_CHROOT="no"
}
user anonymous {
  ALIAS="ftp"
  DO_CHROOT="no"
}
user root {
  #DENY_LOGIN="Root login not allowed."
  DO_CHROOT="no"
}
user admin {
  DO_CHROOT="no"
}
user guest {
  DO_CHROOT="no"
}

EOF









cat << EOF > /etc/ftpdpassword
root root root /
admin admin root /
guest guest usr /

EOF














##/usr/local/samba/sbin/smbd -D -s /etc/samba/smb_server.conf >/dev/null 2>&1 &
##/usr/local/samba/sbin/nmbd -D -s /etc/samba/smb_server.conf >/dev/null 2>&1 &
/usr/sbin/smbd -D -s /etc/samba/smb_server.conf >/dev/null 2>&1 &
/usr/sbin/nmbd -D -s /etc/samba/smb_server.conf >/dev/null 2>&1 &




##/usr/sbin/bftpd -d >/dev/null 2>&1 &
#/usr/sbin/bftpd -d -c /etc/bftpd_server.conf >/dev/null 2>&1 &

##/usr/sbin/bftpd -D >/dev/null 2>&1
/usr/sbin/bftpd -D -c /etc/bftpd_server.conf >/dev/null 2>&1











