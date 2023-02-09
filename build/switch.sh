#!/bin/sh

# Initialise the development by grabbing assets
apt-get install git xdg-user-dirs -yq #These are mostly already installed. Just setting it to manually installed for minimal
# Perform system upgrade
apt-get update -y
apt-get upgrade -y
apt autopurge -y
apt install git -y
# Install MatuusOS repo
apt-get install -y apt-transport-https
keyring_location=~/creation/usr/share/keyrings/matus-mastena-Hcr-matuusos-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/matus-mastena-Hcr/matuusos/gpg.F1028552B20EF14C.key' |  gpg --dearmor > ${keyring_location}
curl -1sLf 'https://dl.cloudsmith.io/public/matus-mastena-Hcr/matuusos/config.deb.txt?distro=ubuntu&codename=xenial' > ~/creation/etc/apt/sources.list.d/matus-mastena-Hcr-matuusos.list
# Create distribution configuration files
mkdir -p /etc/skel/.config
git clone https://github.com/MatuusOS/i3-dotfiles
# Install rhino-deinst onto system
mkdir ~/creation/rhino-deinst
cd ~/creation/rhino-deinst
wget -q https://github.com/rollingrhinoremix/rhino-deinst/releases/latest/download/rhino-deinst
chmod +x ~/creation/rhino-deinst/rhino-deinst
mv ~/creation/rhino-deinst/rhino-deinst /usr/bin
# Install the latest Linux kernel (from Ubuntu mainline repositories)
mkdir ~/creation/kernel
cd ~/creation/kernel
echo 'deb http://deb.xanmod.org releases main' | sudo tee ~/creation/etc/apt/sources.list.d/xanmod-kernel.list
sudo apt update
sudo apt install ./*.deb -y
# Install Nala
apt-get install nala -y
# Clean up system files
apt-get clean -y
sed -i 's/kinetic/devel/g' /etc/apt/sources.list
sed -i 's/kinetic/devel/g' /etc/lsb-release
sed -i 's/kinetic/devel/g' /usr/lib/os-release
#So much release info that are mostly same!
sed -i 's/PRETTY_NAME="Ubuntu Kinetic Kudu (development branch)"/PRETTY_NAME="MatuusOS Bratislava"/g' /etc/os-release
sed -i 's%HOME_URL="https://www.ubuntu.com/"%HOME_URL="https://www.matuusos.github.io"%g' /etc/os-release
apt-get --allow-releaseinfo-change update -y
apt-get --allow-releaseinfo-change dist-upgrade -y
apt-get autopurge -y
apt-get clean

sed -i 's/^set -e//g' /var/lib/dpkg/info/snapd.prerm #For minimal as snapd fails at some point
sed -i 's/^set -e//g' /var/lib/dpkg/info/snapd.postrm
echo 'find / -type f -name "*snap*" -delete 2> /dev/null' >> /var/lib/dpkg/info/snapd.postrm #to make snap is fully removed
echo 'rm -rf /snap' >> /var/lib/dpkg/info/snapd.postrm
echo 'rm -rf ~/snap' >> /var/lib/dpkg/info/snapd.postrm
echo 'rm -rf /root/snap' >> /var/lib/dpkg/info/snapd.postrm
rm -rf ~/creation
