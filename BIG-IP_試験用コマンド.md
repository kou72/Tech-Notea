# ログをリアルタイム表示

## 起動  
```
tail -f /var/log/ltm &
```

## 停止  

プロセスIDを調べる  
```
ps | grep tail
```
kill  
```
kill 0000
```

# connectionテーブルをリアルタイム表示

```
watch tmsh show connection
```


