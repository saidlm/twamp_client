#!/bin/bash

## Variables
DATA=${DATA_DIR}
BIN=${BIN_DIR}

GLOBAL_CONFIG_FILE="global_config.json"
LOCAL_CONFIG_FILE="local_config.json"
TARGETS_FILE="targets_list.json"

## Using lock to avoid to start more processes
(
flock -n 200 || echo "Measuring is still in progress, skipping this run."

## Loading global configuration
if [ -f "$DATA/$GLOBAL_CONFIG_FILE" ]; then

	DESTINATIONS=''

        cat $DATA/$GLOBAL_CONFIG_FILE | jq -r '.Destinations[] | @base64' | while read line ; do
                eval "$(echo $line | base64 --decode | jq -r '{ DestinationURL, DestinationPassword } | to_entries | .[] | .key + "=" + (.value | @sh)')"
                DESTINATIONS="$DESTINATIONS $DestinationPassword@$DestinationURL"

        done
else
        echo "Global config is missing! Waiting for 5 minutes."
        exit 1
fi

## Loading local configuration
if [ -f "$DATA/$LOCAL_CONFIG_FILE" ]; then
        eval "$(cat $DATA/$LOCAL_CONFIG_FILE | jq -r '{ SourceName, Description, Tags } | to_entries | .[] | .key + "=" + (.value | @sh)')"

        SOURCE_DESCR=$Description
        SOURCE_TAGS=$Tags
fi

## Setting probe source name
if [ -z "$PROBE_SOURCE" ]; then
        SOURCE=`hostname -f`
elif [ -z "$SourceName" ]; then
        SOURCE=$SourceName
else
        SOURCE=$PROBE_SOURCE
fi

echo "Probe source nane: $SOURCE"


## Main loop
if [ -f "$DATA/$TARGETS_FILE" ]; then
	cat $DATA/$TARGETS_FILE | jq -r '.Targets[] | @base64' | while read line ; do
		eval "$(echo $line | base64 --decode | jq -r '{ IP, DSCP, Description, Latitude, Longitude, Tags} | to_entries | .[] | .key + "=" + (.value | @sh)')"

                TARGET_DESCR=$Description
                TAGS="$SOURCE_TAGS $Tags"		

		echo -n "Processing $IP ... "
		$BIN/metis_twmping.sh -t "$IP" -q "$DSCP" -d "$DESTINATIONS" -s "$SOURCE" -c "$TARGET_DESCR"
		ERR=$?
		if [ $ERR -eq 124 ]; then
			echo "Destination host is not responding; timeout."
		elif [ $ERR -eq 129 ]; then
			echo "Some unexpected situation occurred; KILL signal was sent to twamp ping."
		elif [ $ERR -ne 0 ]; then
    			echo "Some error occurred during processing of metis twamp wrapper!"
		else
			echo "Ok."
		fi

	done
else
        echo "Probe list doesn't found. Waiting for 5 minutes."
	exit 1
fi
exit 0

) 200>/var/lock/mylockfile

# EOF
