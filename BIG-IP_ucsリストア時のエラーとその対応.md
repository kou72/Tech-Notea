# BIG-IP_ucsリストア時のエラーとその対応

## 基本情報

物理版ucs -> vm版  

- 物理版  
version 11.6.1 build 1.0.326 edition Hotfix HF1
- vm版  
version 11.6.1 build 1.0.326 edition Hotfix HF1

## インターフェースに不正な値

```
01070318:3: The requested media for interface 1.1 is invalid.
Unexpected Error: Loading configuration process failed.
```

vm版に`media-fixed 10000T-FD`を追記
```
net interface 1.1 {
    stp disabled
}
```
↓
```
net interface 1.1 {
    stp disabled
    media-fixed 10000T-FD
}
```

## HA用の設定が重複している

```
010713b1:3: Cannot delete IP (1.1.1.1) because it is used by the system state-mirroring (Primary Mirror Address) setting.
Unexpected Error: Loading configuration process failed.
```

