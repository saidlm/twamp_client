FROM debian:buster-slim

MAINTAINER Martin Saidl, martin.saidl@tone.cz

ENV DATA_DIR=/config/data
ENV BIN_DIR=/config/bin
ENV CRON_DIR=/config/cron.d

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install --no-install-recommends -y \
        ca-certificates \
        gnupg2 \
        curl \ 
        wget \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl http://downloads.perfsonar.net/debian/perfsonar-official.gpg.key | apt-key add - \
    && curl -o /etc/apt/sources.list.d/perfsonar-release.list http://downloads.perfsonar.net/debian/perfsonar-release.list \
    && apt-get -y update \
    && apt-get install --no-install-recommends -y \
	jq \
        cron \
        git \
	traceroute \	
        twamp-client \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY /scripts/entrypoint.sh /sbin/entrypoint.sh
RUN chmod +x /sbin/entrypoint.sh

RUN mkdir /ipprobe
RUN mkdir /ipprobe/cron.d/ 
COPY bindir /ipprobe/bin/
COPY datadir /ipprobe/data/
RUN chmod +x /ipprobe/bin/*

ENTRYPOINT ["/sbin/entrypoint.sh"]
