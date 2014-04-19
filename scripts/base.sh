#!/bin/bash

# locale
locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# install packages and upgrade
apt-get -y update
apt-get -y dist-upgrade
apt-get -y purge nano ppp pppconfig pppoeconf
apt-get -y autoremove
apt-get -y install build-essential linux-headers-generic
apt-get -y install ssh nfs-common vim curl git
apt-get clean

# Remove 2s grub timeout to speed up booting
sed -i -e 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' \
    -e 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet nosplash"/' \
    /etc/default/grub
update-grub

# SSH tweaks
echo "UseDNS no" >> /etc/ssh/sshd_config

# Disable IPv6
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p

# Disable getty on tty[2-6]
for f in /etc/init/tty[2-6].conf; do
    mv -v ${f}{,.off}
done

# reboot
echo "Rebooting the machine..."
reboot
sleep 60
