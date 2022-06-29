#!/bin/bash

## Variables
DATA=${DATA_DIR}
BIN=${BIN_DIR}

SRC='http://saidlm.tone.cz/twamp/'

echo "Downloading new configuration ..."

# Downloading new configs
curl -o $DATA/global_config.json.new $SRC/global_config.json
if [ $? -ne 0 ]; then
	echo "Global config is missin, nothing to donload! Skipping .."
	exit 1
fi

curl -o $DATA/targets_list.json.new $SRC/targets_list.json
if [ $? -ne 0 ]; then
	echo "Targets list is missing, nothing to download! Skipping ..."
	exit 1
fi

cp -u $DATA/global_config.json $DATA/global_config.json.old
cp -u $DATA/targets_list.json $DATA/targets_list.json.old

cp -u $DATA/global_config.json.new $DATA/global_config.json
cp -u $DATA/targets_list.json.new $DATA/targets_list.json

rm $DATA/global_config.json.new
rm $DATA/targets_list.json.new

echo "Download complete."

#EOF
