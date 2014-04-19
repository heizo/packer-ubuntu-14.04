#!/bin/bash

# Remove old kernels
apt-get -y purge `ls /boot/vmlinuz-* | sed -e '$d' | sed s/.*vmlinuz/linux-image/`
apt-get -y purge $(dpkg --list |egrep 'linux-image-[0-9]' |awk '{print $3,$2}' |sort -nr |tail -n +2 |grep -v $(uname -r) |awk '{ print $2}')
apt-get -y purge $(dpkg --list |grep '^rc' |awk '{print $2}')
apt-get -y autoremove
apt-get -y clean

# Cleanup tmp
rm -rf /tmp/*

# Removing leftover leases and persistent rules
echo "cleaning up dhcp leases"
rm -f /var/lib/dhcp/*
rm -f /etc/resolv.conf

# Make sure Udev doesn't block our network
# http://6.ptmc.org/?p=164
echo "cleaning up udev rules"
rm -f /etc/udev/rules.d/70-persistent-net.rules
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm -f /lib/udev/rules.d/75-persistent-net-generator.rules

echo "Adding a 2 sec delay to the interface up, to make the dhclient happy"
echo "pre-up sleep 2" >> /etc/network/interfaces

# Zero out the free space to save space in the final image:
echo "Zeroing device to make space..."
dd if=/dev/zero of=/EMPTY bs=1M
dd if=/dev/zero of=/boot/EMPTY bs=1M
rm -f /EMPTY /boot/EMPTY
