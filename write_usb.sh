#!/bin/bash
SCRIPT_NAME="$(basename "$0")"
# WKDIR="$(dirname "$0")"
WKDIR=/home/mikequentel/mq/mq_wkspc/debrespin

DEV_USB=/dev/sdf1
# PATH_TO_ISO=$WKDIR/live_boot/debian-respin-live.iso
# sudo dd bs=4M if=$PATH_TO_ISO of=$DEV_USB

sudo dd if=/usr/lib/syslinux/mbr/mbr.bin of=${DEV_USB} conv=notrunc bs=440 count=1

sudo mount /dev/sdf1 /mnt/usb

sudo cp /usr/lib/syslinux/modules/bios/menu.c32 /mnt/usb/ && \
sudo cp /usr/lib/syslinux/modules/bios/hdt.c32 /mnt/usb/ && \
sudo cp /usr/lib/syslinux/modules/bios/ldlinux.c32 /mnt/usb/ && \
sudo cp /usr/lib/syslinux/modules/bios/libutil.c32 /mnt/usb/ && \
sudo cp /usr/lib/syslinux/modules/bios/libmenu.c32 /mnt/usb/ && \
sudo cp /usr/lib/syslinux/modules/bios/libcom32.c32 /mnt/usb/ && \
sudo cp /usr/lib/syslinux/modules/bios/libgpl.c32 /mnt/usb/ && \
sudo cp /boot/memtest86+.bin /mnt/usb/memtest && \
sudo cp $WKDIR/live_boot/image/isolinux/isolinux.cfg /mnt/usb/syslinux.cfg && \
sudo cp /usr/share/misc/pci.ids /mnt/usb/ && \
sudo rsync -rv $WKDIR/live_boot/image/live /mnt/usb/
