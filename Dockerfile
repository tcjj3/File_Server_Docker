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
  && git clone https://github.com/gamman/bftpd \
  && cd bftpd \
  && chmod +x configure \
  && ./configure --enable-pax=pax-sourcedir --enable-libz || echo "continue..." \
  && chmod +x mksources \
  && make \
  && make install \
  && cp /usr/etc/bftpd.conf /etc/bftpd.conf \
  && cd .. \
  && rm -rf bftpd \
  && curl https://download.samba.org/pub/samba/stable/samba-3.0.14a.tar.gz -o samba-3.0.14a.tar.gz || echo "continue..." \
  && tar zxf samba-3.0.14a.tar.gz || echo "continue..." \
  && cd samba-3.0.14a/source || echo "continue..." \
  && chmod +x configure || echo "continue..." \
  && ./configure || echo "continue..." \
  && (make || (sed -Ei "s/D.dqb_curblocks/D.dqb_curspace/g" lib/sysquotas_4A.c && make)) || echo "continue..." \
  && make install || echo "continue..." \
  && cd ../.. || echo "continue..." \
  && rm -rf samba-3.0.14a || echo "continue..." \
  && rm -rf samba-3.0.14a.tar.gz || echo "continue..." \
  && rm -rf ${DIR_TMP} \
  && apt-get autoremove --purge ca-certificates git pkg-config build-essential cmake make unzip -y











ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]











