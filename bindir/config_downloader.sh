#!/bin/bash


## Variables
DATA=${DATA_DIR}
BIN=${BIN_DIR}

CONFIG_FILE="global_config.json"
TARGETS_FILE="targets_list.json"

## Loading global configuration
echo $DATA/$CONFIG_FILE

if [ -f "$DATA/$CONFIG_FILE" ]; then
        eval "$(cat $DATA/$CONFIG_FILE | jq -r '.ConfigSource | { ConfigMethod, ConfigURL, ConfigPassword, ConfigUser } | to_entries | .[] | .key + "=" + (.value | @sh)')"
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
		curl -k -o $DATA/config.new/$TARGETS_FILE $ConfigURL/$TARGETS_FILE
		ERR=$(($ERR + $?))
		curl -k -o $DATA/config.new/$CONFIG_FILE $ConfigURL/$CONFIG_FILE
		ERR=$(($ERR + $?))
	else
		curl -k --user ConfigUser:ConfigPassword -o $DATA/config.new/$TARGETS_FILE $ConfigURL/$TARGETS_FILE
		ERR=$(($ERR + $?))
		curl -k --user ConfigUser:ConfigPassword -o $DATA/config.new/global_config $ConfigURL/$CONFIG_FILE
		ERR=$(($ERR + $?))
	fi

elif [ "$ConfigMethod" == "git" ]; then
	if [ ! -d "$DATA/config.new/.git" ]; then
		rm -rf $DATA/config.new
		git --exec-path=/usr/lib/git-core --git-dir=$DATA/.git/ --work-tree=$DATA/config.new/ clone $ConfigURL $DATA/config.new/
		ERR=$(($ERR + $?))
	fi
	#git -C $DATA/config.new $ConfigURL pull
	ERR=$(($ERR + $?))
else
	echo "No configuration download method is configured! The valid methods are: web or git. Skipping ..."
	exit 1
fi

if [ "$ERR" -ne 0 ]; then
	echo "Global config is missing or somrthing went wrong, nothing to download! Skipping ..."
	exit 1
fi

cp -u $DATA/$CONFIG_FILE $DATA/config.old/$CONFIG_FILE
cp -u $DATA/$TARGETS_FILE $DATA/config.old/$TARGETS_FILE

cp -u $DATA/config.new/$CONFIG_FILE $DATA/$CONFIG_FILE
cp -u $DATA/config.new/$TARGETS_FILE $DATA/$TARGETS_FILE

echo "Download complete."

#EOF
