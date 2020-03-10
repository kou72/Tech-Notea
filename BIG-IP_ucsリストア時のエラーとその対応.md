# 基本情報

物理版ucs -> vm版  

- 物理版  
version 11.6.1 build 1.0.326 edition Hotfix HF1
- vm版  
version 11.6.1 build 1.0.326 edition Hotfix HF1

# インターフェースに不正な値

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
