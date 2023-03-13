#!/usr/bin/env bash

# default free space treshold in percent
THRESHOLD_DEFAULT=30

THRESHOLD=${1:-$THRESHOLD_DEFAULT}
if [[ $THRESHOLD -lt 1 || $THRESHOLD -gt 99 ]]; then
    THRESHOLD=$THRESHOLD_DEFAULT
fi

df --output=pcent,target | tail -n +2 | while read line; do
    pcent=$(echo $line | cut -d'%' -f 1)
    free=$((100 - $pcent))
    if [[ $free -lt $THRESHOLD ]]; then
        part=$(echo $line | cut -d'%' -f 2)
        echo "WARNING: partition '$(echo $part)' free space is less than $THRESHOLD%: $free%"
    fi
done
