#!/bin/bash
SCRIPT_NAME="$(basename "$0")"
WKDIR="$(dirname "$0")"

# http://willhaley.com/blog/create-a-custom-debian-stretch-live-environment-ubuntu-17-zesty

sudo apt-get install \
  debootstrap \
  syslinux \
  isolinux \
  squashfs-tools \
  genisoimage \
  memtest86+ \
  rsync

mkdir $WKDIR/live_boot

sudo debootstrap \
  --arch=amd64 \
  --variant=minbase \
  stretch $WKDIR/live_boot/chroot \
  http://mirror.csclub.uwaterloo.ca/debian

# CHROOT ENVIRONMENT
sudo chroot $WKDIR/live_boot/chroot

echo "debian-respin-live" > /etc/hostname

# apt-cache search linux-image

apt-get update && \
apt-get install \
  --yes \
  --force-yes \
  linux-image-4.9.0-3-amd64 \
  live-boot \
  systemd-sysv

apt-get install --yes --force-yes \
  ansible \
  arping \
  autoconf \
  automake \
  autotools-dev \
  awscli \
  aws-shell \
  binutils \
  binutils-aarch64-linux-gnu \
  bison \
  bluetooth \
  build-essential \
  chromium \
  curl \
  default-jdk \
  diffoscope \
  docker \
  docker-compose \
  firefox-esr \
  gimp \
  gnome \
  gnome-builder \
  golang-1.8 \
  inxi \
  ksh \
  libcloog-isl-dev \
  libgmp3-dev \
  libisl-dev \
  libmpc-dev \
  libmpfr-dev \
  libreoffice \
  linux-headers-$(uname -r) \
  netcat \
  nmap \
  nodejs \
  pandoc \
  prometheus-node-exporter \
  pylint \
  python \
  python-debian \
  redshift \
  redshift-gtk \
  rustc \
  rust-doc \
  subversion \
  texinfo \
  vim \
  wireshark-dev \
  zenmap \
  zsh 

apt-get clean

passwd root

# EXITS CHROOT ENVIRONMENT.
exit

mkdir -p $WKDIR/live_boot/image/{live,isolinux}

(cd $WKDIR/live_boot && \
  sudo mksquashfs chroot image/live/filesystem.squashfs -e boot
)

(cd $WKDIR/live_boot && \
  cp chroot/boot/vmlinuz-4.9.0-3-686 image/live/vmlinuz1
  cp chroot/boot/initrd.img-4.9.0-3-686 image/live/initrd1
)

cat > $WKDIR/live_boot/image/isolinux/isolinux.cfg<<EOF
UI menu.c32

prompt 0
menu title Debian Live

timeout 300

label Debian Respin Live 4.9.0-3-amd64
menu label ^Debian Respin Live 4.9.0-3-amd64 
menu default
kernel /live/vmlinuz1
append initrd=/live/initrd1 boot=live

label hdt
menu label ^Hardware Detection Tool (HDT)
kernel hdt.c32
text help
HDT displays low-level information about the systems hardware.
endtext

label memtest86+
menu label ^Memory Failure Detection (memtest86+)
kernel /live/memtest
EOF

# CD
(cd $WKDIR/live_boot/image/ && \
  cp /usr/lib/ISOLINUX/isolinux.bin isolinux/ && \
  cp /usr/lib/syslinux/modules/bios/menu.c32 isolinux/ && \
  cp /usr/lib/syslinux/modules/bios/hdt.c32 isolinux/ && \
  cp /usr/lib/syslinux/modules/bios/ldlinux.c32 isolinux/ && \
  cp /usr/lib/syslinux/modules/bios/libutil.c32 isolinux/ && \
  cp /usr/lib/syslinux/modules/bios/libmenu.c32 isolinux/ && \
  cp /usr/lib/syslinux/modules/bios/libcom32.c32 isolinux/ && \
  cp /usr/lib/syslinux/modules/bios/libgpl.c32 isolinux/ && \
  cp /usr/share/misc/pci.ids isolinux/ && \
  cp /boot/memtest86+.bin live/memtest
)

genisoimage \
  -rational-rock \
  -volid "Debian Respin Live" \
  -cache-inodes \
  -joliet \
  -hfs \
  -full-iso9660-filenames \
  -b isolinux/isolinux.bin \
  -c isolinux/boot.cat \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  -output $WKDIR/live_boot/debian-live.iso \
  $WKDIR/live_boot/image

