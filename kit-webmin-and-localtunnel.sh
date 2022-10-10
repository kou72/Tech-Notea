#!/bin/bash
# run command
# curl -sf https://raw.githubusercontent.com/kou72/Tech-Notea/master/kit-webmin-and-localtunnel.sh | sh -s -x

# install webmin
# echo "\n# install webmin"
# mkdir ~/webmin
# cd ~/webmin
# sudo apt update
# sudo apt install -y libnet-ssleay-perl libauthen-pam-perl libio-pty-perl unzip
# wget http://prdownloads.sourceforge.net/webadmin/webmin_2.000_all.deb
# sudo dpkg --install webmin_2.000_all.deb

# install nodejs on nvm
echo "\n# install nodejs on nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
. ~/.nvm/nvm.sh
. ~/.profile
. ~/.bashrc
nvm install --lts

# install localtunnel
#mkdir ~/localtunnel
#cd ~/localtunnel

#sudo npm install localtunnel
#lt --port 10000 --subdomain skcml2webmin
