FROM debian:buster-slim

LABEL maintainer "Chaojun Tan <https://github.com/tcjj3>"

ADD entrypoint.sh /opt/entrypoint.sh

RUN export DIR_TMP="$(mktemp -d)" \
  && cd $DIR_TMP \
  && chmod +x /opt/*.sh \
  && sed -i "s/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list \
  && sed -i "s/security.debian.org/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list \
  && apt-get update \
  || echo "continue..." \
  && apt-get install --no-install-recommends -y curl \
                                                unzip \
                                                procps \
                                                psmisc \
                                                cron \
                                                vim \
                                                net-tools \
                                                iproute2 \
                                                ca-certificates \
                                                git \
                                                pkg-config \
                                                build-essential \
                                                cmake \
                                                make \
                                                samba \
                                                vsftpd \
                                                zlib1g-dev \
  && mkdir -p /etc/samba \
  && mkdir -p /opt/file_server_config \
  && mkdir -p /usr/local/bin/file_server \
  && mkdir -p /usr/local/bin/file_server/xrit-rx \
  && mkdir -p /usr/local/bin/file_server/himawari-rx \
  && mkdir -p /var/run/vsftpd/empty \
  && chmod -w /var/run/vsftpd/empty \
  && git clone https://github.com/gamman/bftpd \
  && cd bftpd \
  && chmod +x configure \
  && ./configure --enable-pax=pax-sourcedir --enable-libz || echo "continue..." \
  && chmod +x mksources \
  && sed -Ei "s/command_pasv, STATE_AUTHENTICATED, 0\}/command_pasv, STATE_AUTHENTICATED, 1}/gi" commands.c || echo "continue..." \
  && sed -Ei "s/command_eprt, STATE_AUTHENTICATED, 1\}/command_eprt, STATE_AUTHENTICATED, 0}/gi" commands.c || echo "continue..." \
  && make \
  && make install \
  && cp /usr/etc/bftpd.conf /etc/bftpd.conf \
  && cd .. \
  && rm -rf bftpd \
  && curl https://download.samba.org/pub/samba/stable/samba-3.0.14a.tar.gz -o samba-3.0.14a.tar.gz \
  && tar zxf samba-3.0.14a.tar.gz \
  && cd samba-3.0.14a/source \
  && chmod +x configure \
  && ./configure || echo "continue..." \
  && make || (sed -Ei "s/D.dqb_curblocks/D.dqb_curspace/g" lib/sysquotas_4A.c && make) \
  && make install \
  && cd ../.. \
  && rm -rf samba-3.0.14a \
  && rm -rf samba-3.0.14a.tar.gz \
  && rm -rf ${DIR_TMP} \
  && apt-get autoremove --purge ca-certificates git pkg-config build-essential cmake make unzip -y











ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]











