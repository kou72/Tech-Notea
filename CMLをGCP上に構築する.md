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
