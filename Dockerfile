FROM blitznote/debootstrap-amd64:16.04

RUN echo 'deb http://qgis.org/debian xenial main' >> /etc/apt/sources.list \
 && /usr/bin/get-gpg-key 61E0A086749E463EDE50 2255CAEB3DC3BDF7FB45 | apt-key add \
 && apt-get update && apt-get install -y \
    qgis-server \
    spawn-fcgi \
    multiwatch \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /run/qgisserver /qgisserver

VOLUME /run/qgisserver /qgisserver

ENV FCGICHILDREN=1

WORKDIR /qgisserver

ENTRYPOINT ["/bin/sh", "-c"]

CMD ["spawn-fcgi -f $FCGICHILDREN /usr/lib/cgi-bin/qgis_mapserv.fcgi -s /run/qgisserver/fastcgi.sock -M 777 -n -- /usr/bin/multiwatch"]
