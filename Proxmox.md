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
- if (data.status !== 'Active') {
+ if (false) {
```

https://qiita.com/naoyoshinori/items/950b796b7dc41b87b821
