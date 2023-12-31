#!/bin/bash

if [ -x /usr/bin/vagrant ]
    then
        echo "Vagrant already installed - Exiting"
        exit 0
fi

# Install Latest Vagrant from Hashicorp

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install vagrant

# Install Latest LibVirt Plugin

sudo cp /etc/apt/sources.list /etc/apt/sources.list~
sudo sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
sudo apt-get update


sudo apt-get -y build-dep vagrant ruby-libvirt
sudo apt-get -y install qemu libvirt-daemon-system libvirt-clients ebtables dnsmasq-base \
libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev \
libguestfs-tools

# sudo vagrant plugin install vagrant-libvirt
#CFLAGS="-I/opt/vagrant/embedded/include/ruby-3.0.0/ruby" vagrant plugin install vagrant-libvirt
CONFIGURE_ARGS='with-ldflags=-L/opt/vagrant/embedded/lib with-libvirt-include=/usr/include/libvirt with-libvirt-lib=/usr/lib' GEM_HOME=~/.vagrant.d/gems GEM_PATH=$GEM_HOME:/opt/vagrant/embedded/gems PATH=/opt/vagrant/embedded/bin:$PATH vagrant plugin install vagrant-libvirt

# add environment variable for vagrant provider

sudo  sed -Ei '$ a export VAGRANT_DEFAULT_PROVIDER=libvirt' /etc/environment

# add Bridge Setup Script

sudo cp ./brmgr.sh /usr/local/bin
sudo chmod 755 /usr/local/bin/brmgr.sh
sudo cp ../files/50-bridge-priv /etc/sudoers.d/50-bridge-priv


