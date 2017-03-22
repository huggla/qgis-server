FROM blitznote/debootstrap-amd64:16.04

RUN echo 'deb http://qgis.org/debian xenial main' >> /etc/apt/sources.list \
 && apt-get update && apt-get install -y --allow-unauthenticated \
    qgis-server \
    spawn-fcgi \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /run/qgisserver /qgisserver

VOLUME /run/qgisserver /qgisserver

ENV FCGICHILDREN=1

WORKDIR /qgisserver

ENTRYPOINT ["/bin/sh", "-c"]

CMD ["spawn-fcgi -f /usr/lib/cgi-bin/qgis_mapserv.fcgi -s /run/qgisserver/fcgi.sock -M 777 -F $FCGICHILDREN && tail -f /dev/null"]
