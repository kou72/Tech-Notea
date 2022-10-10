#!/bin/bash

# install webmin
echo " # install webmin "
echo " ## mkdir webmin"
mkdir ~/webmin
cd ~/webmin

echo "## sudo apt update"
sudo apt update

echo "## sudo apt install packages"
PACKAGES=(
perl
libnet-ssleay-perl
openssl
libauthen-pam-perl
libpam-runtime
libio-pty-perl
apt-show-versions
python
unzip
shared-mime-info
)

for PACKAGE in ${PACKAGES[@]};
do
  sudo apt install -y $PACKAGE
done

wget http://prdownloads.sourceforge.net/webadmin/webmin_2.000_all.deb
sudo dpkg --install webmin_2.000_all.deb

# install nodejs on nvm
#curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
#source ~/.bashrc
#nvm install --lts

# install localtunnel
#mkdir ~/localtunnel
#cd ~/localtunnel

#sudo npm install localtunnel
#lt --port 10000 --subdomain skcml2webmin
