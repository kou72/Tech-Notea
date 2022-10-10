#!/bin/bash
# ubuntu に webmin と localtunnel をインストールするスクリプト 以下コマンドで実行(引数としてサブドメインとなる任意の文字列を指定すること)
# curl -sf https://raw.githubusercontent.com/kou72/Tech-Notea/master/kit-webmin-and-localtunnel.sh | sh -x -s 'skcml2webmin'

# install webmin
echo "\n# install webmin\n"
mkdir ~/webmin
cd ~/webmin
sudo apt update
sudo apt install -y libnet-ssleay-perl libauthen-pam-perl libio-pty-perl unzip
wget http://prdownloads.sourceforge.net/webadmin/webmin_2.000_all.deb
sudo dpkg --install webmin_2.000_all.deb

# install node16
echo "\n# install nodejs on nvm\n"
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

# install localtunnel
echo "\n# install localtunnel\n"
mkdir ~/localtunnel
cd ~/localtunnel
sudo npm install localtunnel

cat << EOS > localtunnel.js
const localtunnel = require('localtunnel');

(async () => {
  const tunnel = await localtunnel({ 
    port: 10000,
    subdomain: "$1",
    local_https: true,
    allow_invalid_cert: true,
  });
  console.log(\`Open \${tunnel.url}.\`);
})();
EOS

# enable localtunnel.d
echo "\n# enable localtunnel.d\n"

cat << "EOS" > localtunnel.sh
#!/bin/bash
sudo node $HOME/localtunnel/localtunnel.js
EOS

sudo chmod a+x ~/localtunnel/localtunnel.sh

# 権限の無いファイルに cat で出力するため sudo tee を連結
cat << EOS | sudo tee /etc/systemd/system/localtunnel.service
[Unit]
Description = localtunnel daemon

[Service]
ExecStart = $HOME/localtunnel/localtunnel.sh
Restart = always
Type = simple

[Install]
WantedBy = multi-user.target
EOS

sudo systemctl enable localtunnel
sudo systemctl start localtunnel
sudo systemctl status localtunnel
