# OVFファイルの準備

以下1~6を参考にOVAファイルを作成する  
https://qiita.com/basabasakhr/items/4d30909c77667d12b86e

## 注意

- OVAを作成するために VMware Workstation 16 **Pro** が必要
  - Free版ではOVAのエクスポートが出来ない
  - Pro版にも30日間の試用期間があるため、無料で利用可能
- `refplat-20220211-fcs.iso` の読み込みは初回起動時に行う
  - 一度接続を忘れて起動すると、移行接続して再起動しても読み込まれない
  - このファイルは Cisco の OS が入ったファイル

## 手順との差分

- 手順5が不要
  - SSH設定はデフォルトで有効
  - isoの情報を初回起動時から保持するようになったようで、 `cdrom/` のコピーや移動が不要

# GCPへデプロイ

以下を参考にGCPへデプロイする  
https://qiita.com/basabasakhr/items/1952de180a2513de77fb

## 手順との差分

- 時々登場する `gcloud auth login` コマンドは不要
  - コマンドを打ち込めば、GCP側で承認するか確認するダイアログを出してくれる
- 「4.インスタンスの作成」のコマンドを変更する必要あり

```diff
 gcloud compute instances import INSTANCE_NAME \
- --os=centos-8 \
+ --os=ubuntu-2004 \
 --zone us-central1-b \
 --source-uri=gs:PATH_TO_OVF_FILE
```

# ディスク拡張を拡張する

以下を参考にディスク拡張を拡張する  
https://qiita.com/basabasakhr/items/a04b0b478f162a88dd90

## 手順との差分

- CentOS から Ubuntu にOSが変更されており、マウントコマンドが異なる
  - CentOS : sudo xfs_growfs /
    - このコマンドは効かない
    - error : `xfs_growfs: / is not a mounted XFS filesystem`
  - Ubuntu : sudo resize2fs /dev/mapper/vg00-lv_var
    - このコマンドが効く
    - https://tech-mmmm.blogspot.com/2020/06/ubuntu-2004.html

# BIG-IPを追加する

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
