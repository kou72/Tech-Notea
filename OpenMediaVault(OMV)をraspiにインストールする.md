# インストール

https://wiki.omv-extras.org/doku.php?id=omv7:raspberry_pi_install

# NAS設定

- ストレージ > ファイルシステム > 新規作成 > EXT4 > 保存
- ストレージ > 共有フォルダ > 新規作成 > 相対パス(share/など)設定 > 保存
  - 以下のようにファイルが作成されて共有される
```
/srv/dev-disk-by-uuid-12a95330-6499-4d65-a537-b6b3d958a6bf/sda/
/srv/dev-disk-by-uuid-f1169f7f-869d-4892-a5f9-1025b7872ccc/sdb/
```
- ストレージ > 共有フォルダ > 作成したフォルダ > パーミッション > パーミッション変更 > 保存

- サービス > NFS > 設定 > 有効 > 保存
- サービス > NFS > 共有 > 新規作成 > クライアント(192.168.11.0/24など)設定 > 追加オプション※ 設定 > 保存
  - ※ subtree_check,insecure,no_root_squash,sync
    - subtree_check: エクスポートしたディレクトリのパス検証機能
    - insecure: 非特権ポートからのアクセスを許可
    - no_root_squash: リモートのroot権限をそのまま許可
    - sync: データ書き込みの完了を確認してから応答

- サービス > SMB/CIFS > 設定 > 有効 > パーミッション継承 > 保存
- サービス > SMB/CIFS > 共有 > 新規作成 > パーミッションを継承 > 保存

# プラグインインストール

https://wiki.omv-extras.org/

- sshでログイン後、実行

```bash
wget -O - https://github.com/OpenMediaVault-Plugin-Developers/packages/raw/master/install | bash
```

# Dockerインストール

https://wiki.omv-extras.org/doku.php?id=omv7:docker_in_omv#install_and_configure_docker

- システム > omv-extras > Docker repo > Enabling backports > 保存
- システム > プラグイン > openmediavault-compose > インストール

Docker用のファイルを作成する

- ストレージ > ファイルシステム > 新規作成 > EXT4 > 保存
- ストレージ > 共有フォルダ > 新規作成
  - composedata: 相対パス(compose/data/)
  - composefile: 相対パス(compose/file/)

- サービス > Compose > 設定 > 保存
  - Compose Files > 共有フォルダ(composefile)設定
  - Data > 共有フォルダ(composedata)設定

## portainer-agent

- サービス > Compose > Files > 新規作成 > Add form Example > portainer-agent > 保存 > up

## filebrowser

- サービス > Compose > Files > 新規作成 > 追加 > 保存 > up
```
version: "3"
services:
  filebrowser:
    image: filebrowser/filebrowser:s6
    user: "0:0" # rootユーザー
    environment:
      - PUID=1000
      - PGID=100
      - TZ=Asia/Tokyo
    volumes:
      # - fb_data:/srv/data  # filebrowserの設定データ用
      - /srv/dev-disk-by-uuid-12a95330-6499-4d65-a537-b6b3d958a6bf/sda:/srv/sda
      - /srv/dev-disk-by-uuid-f1169f7f-869d-4892-a5f9-1025b7872ccc/sdb:/srv/sdb
    ports:
      - 8035:80
    restart: unless-stopped

volumes:
  fb_data:
```
