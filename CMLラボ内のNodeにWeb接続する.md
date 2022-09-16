# CMLラボ内のNodeにインターネット経由でWeb接続する

BIG-IPを例とする

## BIG-IPを追加する

以下を参考にBIG-IPのノードとImageを作成する  
https://www.cisco.com/c/dam/global/ja_jp/training-events/training-certifications/cln/seminar/jp-webinar-cml02.pdf#page=23

BIG-IPのimageはここからダウンロードする  
https://downloads.f5.com/esd/productlines.jsp

Lab内に配置して起動する

## BIG-IPにインターネット接続する

インターネットに接続した後、CMLのNginxをリバースプロキシとして稼働させて繋ぐ

- BIG-IPをインターネットへ接続させる
  - 「externel connector(クラウドのアイコン)」を設置しBIG-IPと接続する
    - BIG-IP: eth0 (=mgmtポート)
    - externel connector: port
  - BIG-IPにDHCPで付与されたアドレスを確認する
  - もしくは静的にアドレスを付与する
    - セグメント: `192.168.255.0/24`
    - GW: `192.168.255.1`
    - コマンド
```
[root@localhost:NO LICENSE:Standalone] config # ifconfig mgmt
mgmt: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.255.168  netmask 255.255.255.0  broadcast 192.168.255.255
        inet6 fe80::5054:ff:fe02:ba49  prefixlen 64  scopeid 0x20<link>
        ether 52:54:00:02:ba:49  txqueuelen 1000  (Ethernet)
        RX packets 7962  bytes 1425834 (1.3 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 7348  bytes 5593760 (5.3 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

[root@localhost:Active:Standalone] config # tmsh
root@(localhost)(cfg-sync Standalone)(Active)(/Common)(tmos)# modify sys global-settings mgmt-dhcp disabled
root@(localhost)(cfg-sync Standalone)(Active)(/Common)(tmos)# create sys management-ip 192.168.255.101/24
root@(localhost)(cfg-sync Standalone)(Active)(/Common)(tmos)# create sys management-route default gateway 192.168.255.1
root@(localhost)(cfg-sync Standalone)(Active)(/Common)(tmos)# save sys config
root@(localhost)(cfg-sync Standalone)(Active)(/Common)(tmos)# quit
[root@localhost:Active:Standalone] config #

[root@localhost:Active:Standalone] config # ifconfig mgmt
mgmt: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.255.101  netmask 255.255.255.0  broadcast 192.168.255.255
        inet6 fe80::5054:ff:fe02:ba49  prefixlen 64  scopeid 0x20<link>
        ether 52:54:00:02:ba:49  txqueuelen 1000  (Ethernet)
        RX packets 163  bytes 31316 (30.5 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 168  bytes 77025 (75.2 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

# CMLのnginxでリバースプロキシを設定する

- CMLのコンソールからnginx.confを編集してリバースプロキシさせる
  - 参考：https://github.com/kou72/Tech-Notea/blob/master/Nginx_リバースプロキシSSLパススルー.md
```
##
# Custom: Reverse Proxy and SSL Passthrough
##

stream {
    upstream backend_servers {
        server 192.168.255.101:443;
    }

    server {
        listen       4431;
        proxy_pass backend_servers;
        proxy_next_upstream on;

    }
}
```
- CMLのFirewallの対象ポートを許可する
```
admin@cml-instance:~$ sudo firewall-cmd --list-all --permanent
public
  target: default
  icmp-block-inversion: no
  interfaces:
  sources:
  services: dhcpv6-client http https ssh
  ports: 1122/tcp 9090/tcp
  protocols:
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:

admin@cml-instance:~$ sudo firewall-cmd --zone=public --add-port=4431/tcp --permanent
success

admin@cml-instance:~$ sudo firewall-cmd --list-all --permanent
public
  target: default
  icmp-block-inversion: no
  interfaces:
  sources:
  services: dhcpv6-client http https ssh
  ports: 1122/tcp 9090/tcp 4431/tcp
  protocols:
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:

admin@cml-instance:~$ sudo systemctl restart firewalld.service
```
- GCPのファイアウォールの対象ポートを許可する
- 以下に接続する
  - https://CMLのIP:4431
