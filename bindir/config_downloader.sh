#!/bin/bash

## Variables
DATA=${DATA_DIR}
BIN=${BIN_DIR}

## Loading global configuration
if [ -f "$DATA/global_config.json" ]; then
        eval "$(cat $DATA/global_config.json | jq -r '{ ConfigURL, ConfigPassword, ConfigUser } | to_entries | .[] | .key + "=" + (.value | @sh)')"
else
        echo "Global config is missing! Trere is no information how to download config files!"
        exit 1
fi

echo "Downloading new configuration ..."
# Downloading new configs
curl -o $DATA/global_config.json.new $ConfigURL/global_config.json
if [ $? -ne 0 ]; then
	echo "Global config is missin, nothing to donload! Skipping .."
	exit 1
fi

if [ -n "ConfigUser" ]; then
	curl --user ConfigUser:ConfigPassword -o $DATA/targets_list.json.new $ConfigURL/targets_list.json
else
	curl -o $DATA/targets_list.json.new $ConfigURL/targets_list.json
fi

if [ $? -ne 0 ]; then
	echo "Global config is missing, nothing to download! Skipping ..."
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
