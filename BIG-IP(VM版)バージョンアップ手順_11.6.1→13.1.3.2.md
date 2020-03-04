# ストレージ領域を拡張

Esxi管理画面「編集」からハードディスク容量増加  
BIG-IPをreboot  

# BIG-IPのディスク領域拡張

https://support.f5.com/csp/article/K14952  

※ディスク容量が足りなくても、コマンド自体は通ってしまうので、  
　拡張分のストレージがきちんと設けられているか要確認

# isoインポート

GUI  
```
System > Software Management > Import > Import
```

進捗の確認コマンド(bash)  
```
watch df -h
```

# イメージのインストール

GUI  
```
System > Software Management > Install > 「DH1.○」の○にあたる文字or数字を入力 > Install
```

---

ストレージ容量が足りずに場合、以下のエラーが出る。  

```failed (Disk full (volume group). See SOL#10636)```　　

以下に詳細なログが保存されている。  

 - /var/log/liveinstall.log

上記の情報で検索すると以下のバグに当たり、解決策も無く戸惑うことになる。  
https://support.f5.com/csp/article/K16048  

ただし今回は、単純にストレージ容量を増やすだけで解決した。  



