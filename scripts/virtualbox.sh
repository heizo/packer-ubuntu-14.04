#!/bin/bash

apt-get -y install dkms

# Install the VirtualBox guest additions
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
VBOX_ISO=VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop $VBOX_ISO /mnt
yes|sh /mnt/VBoxLinuxAdditions.run
umount /mnt
# https://www.virtualbox.org/ticket/12879
if [ ! -d /usr/lib/VBoxGuestAdditions ]; then
    ln -s /opt/VBoxGuestAdditions-$VBOX_VERSION/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
fi

# Cleanup VirtualBox
rm $VBOX_ISO
rm /home/vagrant/.vbox_version