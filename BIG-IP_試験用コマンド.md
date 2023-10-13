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

# Externalのコネクション情報

```
tmsh show sys connection cs-server-addr <バーチャルIPアドレス>
tmsh show sys connection cs-server-addr <バーチャルIPアドレス> all-properties
```

# Internalのコネクション情報

```
tmsh show sys connection ss-server-addr <ノードIPアドレス>
tmsh show sys connection ss-server-addr <ノードIPアドレス> all-properties
```

# プール、ノードのモニターの状況確認

```
tmsh show ltm pool <プール名>
tmsh show ltm node <ノード名>
```

# ハードウェアステータスの確認

```
tmsh show sys hardware
```

# RSTのログを表示

```
modify /sys db tm.rstcause.log value enable
modify /sys db tm.rstcause.pkt value enable
```

# プロセス毎のBIG-IPの負荷状況確認

```
tmstat
```

# BIG-IPの通信状況に関する状況確認

```
bigtop
bigtop -conn
bigtop -once
```
出力
```
                              |  bits  since       |  bits  in prior    |  current
                              |  Oct 18 16:38:17   |  4 seconds         |  time
BIG-IP      STANDBY           |---In----Out---Conn-|---In----Out---Conn-|  14:26:33
xxxxxxxxxx.xxxxxx.co.jp        2.020T 5.826T 45.37M  53408  36544     50

VIRTUAL ip:port               |---In----Out---Conn-|---In----Out---Conn-|-Nodes Up--
/Common/xxx.xxx.xxx.xxx:http     858.8G 4.682T 8.264M      0      0      0      4
/Common/0.0.0.0:any            334.9G 1.118T 2.328M      0      0      0      0
/Common/xxx.xxx.xxx.xxx:http         0      0      0      0      0      0      1
/Common/xxx.xxx.xxx.xxx:http         0      0      0      0      0      0      2
/Common/xxx.xxx.xxx.xxx:http         0      0      0      0      0      0      1
/Common/xxx.xxx.xxx.xxx:9110         0      0      0      0      0      0      2
/Common/xxx.xxx.xxx.xxx:9130         0      0      0      0      0      0      2
/Common/xxx.xxx.xxx.xxx:9140         0      0      0      0      0      0      2
/Common/xxx.xxx.xxx.xxx:http         0      0      0      0      0      0      2
/Common/xxx.xxx.xxx.xxx:9120         0      0      0      0      0      0      2

NODE ip:port                  |---In----Out---Conn-|---In----Out---Conn-|--State----
/Common/xxxxxxxxxx:http        219.1G 1.197T 2.066M      0      0 2.066M UP
/Common/xxxxxxxxxx:http        219.4G 1.184T 2.059M      0      0 2.059M UP
/Common/xxxxxxxxxx:http        218.0G 1.172T 2.029M      0      0 2.029M UP
/Common/xxxxxxxxxx:http        217.2G 1.161T 2.038M      0      0 2.038M UP
/Common/xxxxxxxxxx:irdmi            0      0      0      0      0      0 UP
/Common/xxxxxxxxxx:vcom-tunnel      0      0      0      0      0      0 UP
/Common/xxxxxxxxxx:irdmi            0      0      0      0      0      0 DOWN
/Common/xxxxxxxxxx:irdmi            0      0      0      0      0      0 UP
/Common/xxxxxxxxxx:9110             0      0      0      0      0      0 UP
/Common/xxxxxxxxxx:9110             0      0      0      0      0      0 UP
```
