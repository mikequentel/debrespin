#!/bin/bash
SCRIPT_NAME="$(basename "$0")"
WKDIR="$(dirname "$0")"

DEV_USB=/dev/sdf1
PATH_TO_ISO=$WKDIR/live_boot/debian-respin-live.iso
sudo dd bs=4M if=$PATH_TO_ISO of=$DEV_USB
