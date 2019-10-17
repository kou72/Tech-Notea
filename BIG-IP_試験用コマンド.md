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

# RSTのログを表示

```
modify /sys db tm.rstcause.log value enable
modify /sys db tm.rstcause.pkt value enable
```

