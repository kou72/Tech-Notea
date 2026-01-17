# インストール後に初期化スクリプト実行

- enterprise -> no-subscription にリポジトリ変更
- subscription のナビゲーションをオフ
- ※ HAの無効化が案内されるが実行しないようにする

https://community-scripts.github.io/ProxmoxVE/scripts?id=post-pve-install

```
    ____ _    ________   ____             __     ____           __        ____
   / __ \ |  / / ____/  / __ \____  _____/ /_   /  _/___  _____/ /_____ _/ / /
  / /_/ / | / / __/    / /_/ / __ \/ ___/ __/   / // __ \/ ___/ __/ __ `/ / /
 / ____/| |/ / /___   / ____/ /_/ (__  ) /_   _/ // / / (__  ) /_/ /_/ / / /
/_/     |___/_____/  /_/    \____/____/\__/  /___/_/ /_/____/\__/\__,_/_/_/

 ✓ Corrected Proxmox VE Sources
 ✓ Disabled 'pve-enterprise' repository
 ✓ Disabled 'pve-enterprise' repository
 ✓ Enabled 'pve-no-subscription' repository
 ✓ Enabled 'pve-no-subscription' repository
 ✓ Corrected 'ceph package repositories'
 ✓ Added 'pvetest' repository
 ✓ Disabled subscription nag (Delete browser cache)
 ✗ Selected no to Disabling high availability <-- HAを無効化だけ実行しないようにする
 ✓ Updated Proxmox VE
 ✓ Completed Post Install Routines
```

# Ceph用 Raspi Proxmox 構築

手順に従って実行

https://www.bachmann-lan.de/proxmox-8-auf-dem-raspberry-pi-4-installieren/

Cephの最新バージョンを使うためにリポジトリを変更する

- /etc/apt/sources.list.d/ceph.list
```diff
- deb http://download.proxmox.com/debian/ceph-reef bookworm no-subscription
+ deb https://mirrors.apqa.cn/proxmox/debian/pve bookworm ceph-reef
```

# Vlan設定

<img width="1697" height="537" alt="image" src="https://github.com/user-attachments/assets/a894d669-7cc6-411a-b4f3-a7f42b10379c" />
<img width="614" height="299" alt="image" src="https://github.com/user-attachments/assets/1cb2c8f9-68bd-4926-b874-3e05a3c73289" />
<img width="612" height="262" alt="image" src="https://github.com/user-attachments/assets/bb7a2718-f743-4c2a-82ec-01ab1e7696f2" />

---
以下内容は古い（Proxmox VE Helper-Scripts の Proxmox VE Post Install で代用可能）

# APTリポジトリの設定

Proxmoxが提供しているフリーのアップデートリポジトリを追加します。

#### /etc/apt/sources.list
```
deb http://ftp.debian.org/debian buster main contrib
deb http://ftp.debian.org/debian buster-updates main contrib

# PVE pve-no-subscription repository provided by proxmox.com,
# NOT recommended for production use
deb http://download.proxmox.com/debian/pve buster pve-no-subscription

# security updates
deb http://security.debian.org/debian-security buster/updates main contrib
```

エンタープライズリポジトリを利用できないので、コメントアウトします。

#### /etc/apt/sources.list.d/pve-enterprise.list
```
# deb https://enterprise.proxmox.com/debian/pve buster pve-enterprise
```

https://pve.proxmox.com/wiki/Package_Repositories


# ログイン後のポップアップダイアログを無効化する

#### /usr/share/pve-manager/js/pvemanagerlib.js
```diff
- if (data.status === 'Active') {
+ if (false) {
```

https://qiita.com/naoyoshinori/items/950b796b7dc41b87b821
