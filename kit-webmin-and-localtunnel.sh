#!/bin/bash

# install webmin
mkdir ~/webmin
cd ~/webmin

sudo apt update
# sudo apt install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python unzip shared-mime-info

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
