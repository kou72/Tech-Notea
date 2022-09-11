# CMLラボ内のNodeにインターネット経由でWeb接続する

BIG-IPを例とする

## BIG-IPを追加する

以下を参考にBIG-IPのノードとImageを作成する  
https://www.cisco.com/c/dam/global/ja_jp/training-events/training-certifications/cln/seminar/jp-webinar-cml02.pdf#page=23

BIG-IPのimageはここからダウンロードする  
https://downloads.f5.com/esd/productlines.jsp

Lab内に配置して起動する

## BIG-IPにインターネット経由でWeb接続する

- BIG-IPをインターネットへ接続させる
  - 「externel connector(クラウドのアイコン)」を設置しBIG-IPと接続する
    - BIG-IP: eth0 (=mgmtポート)
    - externel connector: port
  - BIG-IPにDHCPで付与されたアドレスを確認する
  - もしくは静的にアドレスを付与する
    - セグメント: `192.168.255.0/24`
    - GW: `192.168.255.1`
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
```
- CMLのコンソールからnginx.confを編集する
  - 参考：https://github.com/kou72/Tech-Notea/blob/master/Nginx_リバースプロキシSSLパススルー.md
```
##
# Custom: Reverse Proxy and SSL Passthrough
##

stream {
    upstream backend_servers {
        server 192.168.255.168:443;
    }

    server {
        listen       4431;
        proxy_pass backend_servers;
        proxy_next_upstream on;

    }
}
```
- GCPのファイアウォールの対象ポートを許可する
- 以下に接続する
  - https://CMLのIP:4431
