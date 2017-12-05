#!/bin/bash
SCRIPT_NAME="$(basename "$0")"
DIR_TO_REMOVE=live_boot

if [ -d $DIR_TO_REMOVE ]; then
  sudo rm -fvr $DIR_TO_REMOVE
fi 
