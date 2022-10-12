#!/bin/bash

## Variables
DATA=${DATA_DIR}
BIN=${BIN_DIR}

## Loading global configuration
if [ -f "$DATA/global_config.json" ]; then
        eval "$(cat $DATA/global_config.json | jq -r '.ConfigSource | { ConfigMethod, ConfigURL, ConfigPassword, ConfigUser } | to_entries | .[] | .key + "=" + (.value | @sh)')"
else
        echo "Global config is missing! Trere is no information how to download config files!"
        exit 1
fi

if [ "$ConfigURL" == "null" ]; then
	echo "Source URL is not configured."
	exit 1
fi

echo "Downloading new configuration ..."

ERR=0
mkdir -p $DATA/config.old
ERR=$(($ERR + $?))

if [ "$ConfigMethod" == "web" ]; then
	mkdir -p $DATA/config.new
	ERR=$(($ERR + $?))

	if [ "$ConfigUser" == "null" ]; then
		echo "Access to your configuration files is not protected by password!"
		curl -k -o $DATA/config.new/targets_list.json $ConfigURL/targets_list.json
		ERR=$(($ERR + $?))
		curl -k -o $DATA/config.new/global_config.json $ConfigURL/global_config.json
		ERR=$(($ERR + $?))
	else
		curl -k --user ConfigUser:ConfigPassword -o $DATA/config.new/targets_list.json $ConfigURL/targets_list.json
		ERR=$(($ERR + $?))
		curl -k --user ConfigUser:ConfigPassword -o $DATA/config.new/global_config $ConfigURL/global_config.json
		ERR=$(($ERR + $?))
	fi

elif [ "$ConfigMethod" == "git" ]; then
	if [ ! -d "$DATA/config.new/.git" ]; then
		rm -rf $DATA/config.new
		git clone $ConfigURL $DATA/config.new/
		ERR=$(($ERR + $?))
	fi
	#git -C $DATA/config.new $ConfigURL pull
	ERR=$(($ERR + $?))
else
	echo "No configuration download method is configured! The valid methods are: web or git. Skipping ..."
	exit 1
fi

if [ "$ERR" -ne 0 ]; then
	echo "Global config is missing or something went wrong, nothing to download! Skipping ..."
	exit 1
fi

jq '.' $DATA/config.new/global_config.json >/dev/null 2>&1
ERR=$?

if [ "$ERR" -eq 0 ]; then 
	cp -u $DATA/global_config.json $DATA/config.old/global_config.json
	cp -u $DATA/config.new/global_config.json $DATA/global_config.json
else
	echo "Global config has wrong format. Skipping ..."
fi

jq '.' $DATA/config.new/targets_list.json >/dev/null 2>&1
ERR=$?

if [ "$ERR" -eq 0 ]; then
	cp -u $DATA/targets_list.json $DATA/config.old/targets_list.json
	cp -u $DATA/config.new/targets_list.json $DATA/targets_list.json
else
	echo "Targets list has wrong format. Skipping ..."
fi

echo "Download complete."

#EOF
