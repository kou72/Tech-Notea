# GNS3の初期セットアップ

## GNS3インストール

GNS3：https://www.gns3.com/software/download  
GNS3-VM：https://www.gns3.com/software/download-vm  
※vmware版をインストールすること、virtualbox版ではappliancesをインストールできない。  

## VM立ち上げ

vmware上でNGS3serverを立ち上げ  
https://ichibariki.hatenablog.com/entry/2018/11/25/211353  

※設定 > プロセッサとメモリ > 詳細オプション から次にチェック
- この仮想マシンでハイパーバイザーアプリケーションを有効にする
- この仮想マシンでコードプロファイリングアプリケーションを有効にする

## GNS3を立ち上げ

プロジェクト立ち上げ  
Preference > GNS3 VMをvmwareでenable  

# Appliancesインストール

GNS3 Appliances ホーム：https://www.gns3.com/marketplace/appliances  
BIG-IP：https://www.gns3.com/marketplace/appliance/f5-big-ip  
Alpine Linux：https://www.gns3.com/marketplace/appliance/alpine-linux-2  

## Import Appliances

File > Import Appliances からインストールした .gns3aファイルインポート  
GNS3内の案内に従って、必要なOS等をDownload > Import  

# HTTPサーバー接続まで

## ネットワーク

以下のように接続  
```alpine - l2sw - nat```

alpine > config > edit からipアドレス設定（dhcpで取得）  

- /etc/network/interfaces
```
auto eth0
iface eth0 inet dhcp
```

再起動  

参考  
https://wiki.alpinelinux.org/wiki/Configure_Networking  

## http serverセットアップ

Alpine立ち上げ、コンソールに接続  
以下流し込み  
```
apk add openrc
sed -i 's/#rc_sys=""/rc_sys="lxc"/g' /etc/rc.conf
echo 'rc_provide="loopback net"' >> /etc/rc.conf
sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf
sed -i '/tty/d' /etc/inittab 
sed -i 's/hostname $opts/# hostname $opts/g' /etc/init.d/hostname
sed -i 's/mount -t tmpfs/# mount -t tmpfs/g' /lib/rc/sh/init.sh 
sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh
touch /run/openrc/softlevel

apk add lighttpd
echo "Lighttpd is running..." > /var/www/localhost/htdocs/index.html
rc-service lighttpd start
```

参考  
https://blog.adachin.me/archives/4177  
https://wiki.alpinelinux.org/wiki/Lighttpd
