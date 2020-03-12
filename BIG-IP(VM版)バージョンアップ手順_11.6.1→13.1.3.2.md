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

GUI  
```
System > Software Management > Install > 「DH1.○」の○にあたる文字or数字を入力 > Install
```

---

インストールに必要なストレージ容量が足りない場合、以下のエラーが出る。  

```failed (Disk full (volume group). See SOL#10636)```　　

以下に詳細なログが保存されている。  

 - /var/log/liveinstall.log

上記の情報で検索すると以下のバグに当たり、解決策も無く戸惑うことになる。  
https://support.f5.com/csp/article/K16048  

ただし今回は、単純にストレージ容量を増やすだけで解決した。  



