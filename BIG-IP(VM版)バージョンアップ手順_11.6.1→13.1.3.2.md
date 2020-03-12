# BIG-IP(VM版)バージョンアップ手順_11.6.1→13.1.3.2

## バージョンアップの確認項目

バージョンアップの7ステップ  
https://devcentral.f5.com/s/articles/7-steps-checklist-before-upgrading-your-big-ip-1053  

- 互換性確認
- アップグレードパス確認
- isoダウンロード
- ライセンスの再アクティブ化の確認
- iHealth Upgrade Advisor で構成の変更を確認
- バックアップ取得
- インストールチェックリスト確認

加えて以下も確認  

- アップデート先のバグ情報確認

## ストレージ領域を拡張

Esxi管理画面「編集」からハードディスク容量を40Gまで増加  
https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-ve-setup-vmware-esxi-13-0-0/2.html  
BIG-IPをreboot  

## BIG-IPのディスク領域拡張

https://support.f5.com/csp/article/K14952  

※ディスク容量が足りなくても、コマンド自体は通ってしまうので、  
　拡張分のストレージがきちんと設けられているか要確認  
 
 明確にどのくらい拡張すれば良いのか、というドキュメントは見つかっていない。  
 とりあえず例に従って3Gに拡張したがこれで足りてるっぽい。  
https://techdocs.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-ve-setup-vmware-esxi-13-1-0/4.html#guid-b869dd75-5d46-4a09-9d8c-34b5f3fc150f  
https://techdocs.f5.com/content/kb/en-us/products/big-ip_ltm/manuals/product/bigip-ve-setup-vmware-esxi-12-1-0/_jcr_content/pdfAttach/download/file.res/BIG-IP_Virtual_Edition_and_VMware_ESXi__Setup.pdf  
 ```
tmsh modify sys disk directory /config new-size 3145740
tmsh modify sys disk directory /shared new-size 3145740
tmsh modify sys disk directory /var new-size 3145740
tmsh modify sys disk directory /var/log new-size 3145740
tmsh save sys config
# ↓
# reboot
```

## isoインポート

GUI  
```
System > Software Management > Import > Import
```

進捗の確認コマンド(bash)  
```
watch df -h
```

## イメージのインストール

### VM版 ver11 → ver13 の時に発生するバグ

このケースのみバグがあるので回避が必要。  
https://cdn.f5.com/product/bugtracker/ID682174.html  

Workaroundに従って指定のファイルを削除  
```
rm /shared/.tmi_config/global_attributes
```

### GUI  
```
System > Software Management > Install > 「DH1.○」の○にあたる文字or数字を入力 > Install
```

## バージョンアップ実施

GUI  
```
System > Software Management > Boot Locations > HD1.2 > Install Configuration (No->Yes) > Activate
```

## バージョンアップ後

バージョンアップ後に以下の事象が発生  

- 保存していたucsが全て消える
- show sys disk で割り当てられている容量が勝手に変更される  
```
# tmsh show sys disk
Directory Name                  Current Size    New Size
--------------                  ------------    --------
/config                         3149824         -
/shared                         3149824         -
/var                            3149824         -
/var/log                        3149824         -

↓

# tmsh show sys disk
Directory Name                  Current Size    New Size
--------------                  ------------    --------
/config                         503808          -
/shared                         3149824         -
/var                            974848          -
/var/log                        3149824         -
```

