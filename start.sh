#!/bin/bash
set -e

cd /etc/direwolf

if [ -n "$CALLSIGN" -a  -n "$PASSCODE" ]; then
  sed -i "s/^MYCALL.*$/MYCALL ${CALLSIGN}/g" direwolf.conf
  sed -i "s/^IGLOGIN.*$/IGLOGIN ${CALLSIGN} ${PASSCODE}/g" direwolf.conf
else
  echo "CALLSIGN & PASSCODE are required."
  exit 2
fi

## PBEACON line configuration
if [ -n "$LATITUDE" -a -n "$LONGITUDE" ]; then
  sed -i "s/%LATITUDE%/${LATITUDE}/g" direwolf.conf
  sed -i "s/%LONGITUDE%/${LONGITUDE}/g" direwolf.conf
  sed -i "s/%SYMBOL%/${SYMBOL}/g" direwolf.conf
  sed -i "s/%COMMENT%/${COMMENT//\//\\/}/g" direwolf.conf
else
  echo "LATITUDE & LONGITUDE are required."
  exit 3
fi

if [ -n "$ADEVICE" ]; then
  sed -i "s/^ADEVICE.*$/ADEVICE ${ADEVICE//\//\\/}/g" direwolf.conf
fi

if [ -n "$IGSERVER" ]; then
  sed -i "s/^IGSERVER.*$/IGSERVER ${IGSERVER}/g" direwolf.conf
fi

rtl_fm -f $FREQUENCY | direwolf -c direwolf.conf
