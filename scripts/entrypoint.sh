#!/bin/bash
set -e

DATA=${DATA_DIR}
BIN=${BIN_DIR}
CRON=${CRON_DIR}

create_conf_dirs() {
  echo "Creating config dir ..."
  mkdir -p /config

  # populate default configuration if it does not exis
  echo "Populating default configs ..."

  if [ ! -d $BIN ]; then
    cp -r /ipprobe/bin $BIN
  fi

  if [ ! -d $DATA ]; then
    cp -r /ipprobe/data $DATA
  fi

  mkdir -p $CRON
}

create_crontabs() {
  # Adding crontabs 
  echo "Creating crontabs ..."

  echo "SHELL=/bin/bash" > $CRON/probe
  echo "BASH_ENV=/container.env" >> $CRON/probe
  echo "*/5 * * * * root $BIN/probe.sh > /proc/1/fd/1 2>/proc/1/fd/2" >> $CRON/probe

  echo "SHELL=/bin/bash" > $CRON/config_downloader
  echo "BASH_ENV=/container.env" >> $CRON/config_downloader
  echo "1 */12 * * * root $BIN/config_downloader.sh > /proc/1/fd/1 2>/proc/1/fd/2" >> $CRON/config_downloader

  echo "Linking crontabs ..."
  rm -rf /etc/cron.d
  ln -s $CRON /etc/cron.d
}

export_env() {
  # Environment variables export	
  echo "Exporting variables for CRON jobs ..."

  echo "DATA_DIR=$DATA" > /container.env
  echo "BIN_DIR=$BIN" >> /container.env
  echo "CRON_DIR=$CRON" >> /container.env
}

create_conf_dirs
create_crontabs
export_env

echo "Starting download of the configuration (first run) .."
/config/bin/config_downloader.sh

echo "Starting crond ..."
exec $(which cron) -f -L 15
