# proxmox インストール

https://www.bachmann-lan.de/proxmox-8-auf-dem-raspberry-pi-4-installieren/

# ceph のバージョンアップ

GUIからcephインストールする
 /etc/apt/sources.list.d/ceph.list を書き換える

 ```diff
- deb http://download.proxmox.com/debian/ceph-reef bookworm no-subscription
+ deb https://mirrors.apqa.cn/proxmox/debian/pve bookworm ceph-reef
```

※ インストール手順中に出てくる Proxmox Repository と同じURLからcepf用のレポジトリを見つけてくる

```bash
ceph --version
apt update
apt full-upgrade
ceph --version
```

