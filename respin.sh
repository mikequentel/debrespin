#!/bin/bash
SCRIPT_NAME="$(basename "$0")"
# WKDIR="$(dirname "$0")"
WKDIR=/home/mikequentel/mq/mq_wkspc/debrespin

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

# EXITS
exit

