# ucsのインポート(ha)

haを組んだ機器のucsをインポートする場合、インポート先もあらかじめhaを組む必要がある。  
haでのucsインポートまでの流れをcliでメモ  
(ver 14.1.0.6)

# 手順

0. osバージョンを合わせる
1. 時刻を合わせる
1. haを組ませる
1. masterキーを合わせる
1. ucsをインポートする

# 時刻を合わせる
haを組むために時刻同期を行う必要がある。  
手動で合わせる場合は、以下のコマンドを`3秒以内`の間隔で投入。  

```
date --set "2020/10/01 21:30"
hwclock -w
```

# haを組ませる

## 結線
1号機と2号機を1番ポートで結線  

## (device)name, hostname を確認
- device name
```
tmsh show cm device | grep Device
```
- host name
```
tmsh show cm device | grep Hostname
```

## HA用のVLAN作成
- 1,2号機共通  
```
tmsh create net vlan VLN-HA interfaces add { 1.1 { } }
```

## HA用アドレス付与
- 1号機  
```
tmsh create net self HA-IP { address 1.1.1.1/24 allow-service all traffic-group traffic-group-local-only vlan VLN-HA }
```

- 2号機  
```
tmsh create net self HA-IP { address 1.1.1.2/24 allow-service all traffic-group traffic-group-local-only vlan VLN-HA }
```

## Device Connectivity設定
- 1号機  
```
tmsh modify cm device devicename.local configsync-ip 1.1.1.1
tmsh modify cm device devicename.local unicast-address { { effective-ip 1.1.1.1 effective-port 1026 ip 1.1.1.1 }}
tmsh modify cm device devicename.local mirror-ip 1.1.1.1
```

- 2号機  
```
tmsh modify cm device devicename.local configsync-ip 1.1.1.2
tmsh modify cm device devicename.local unicast-address { { effective-ip 1.1.1.2 effective-port 1026 ip 1.1.1.2 }}
tmsh modify cm device devicename.local mirror-ip 1.1.1.2
```

## 同期
- 1号機のみ入力  
```
tmsh run cm add-to-trust device 1.1.1.2 username admin password admin device-name devicename.local
```

2号機に以下を流し込み  
```
tmsh modify sys global-settings hostname big-ip2.local
tmsh create sys management-ip 192.168.1.246/24
tmsh create net vlan VLN-HA interfaces add { 1.0 { } } tag 10
tmsh create net self HA-IP { address 192.168.2.2/30 allow-service all traffic-group traffic-group-local-only vlan VLN-HA }
tmsh modify cm device BIG-IP850.local configsync-ip 192.168.2.2
tmsh modify cm device BIG-IP850.local unicast-address { { effective-ip 192.168.2.2 effective-port 1026 ip 192.168.2.2 }}
tmsh modify cm device BIG-IP850.local mirror-ip 192.168.2.2
tmsh mv cm device BIG-IP850.local big-ip2.local
```

1号機に以下を流し込み  
```
tmsh modify sys global-settings hostname big-ip1.local
tmsh create sys management-ip 192.168.1.247/24
tmsh create net vlan VLN-HA interfaces add { 1.0 { } } tag 10
tmsh create net self HA-IP { address 192.168.2.1/30 allow-service all traffic-group traffic-group-local-only vlan VLN-HA }
tmsh modify cm device BIG-IP850.local configsync-ip 192.168.2.1
tmsh modify cm device BIG-IP850.local unicast-address { { effective-ip 192.168.2.1 effective-port 1026 ip 192.168.2.1 }}
tmsh modify cm device BIG-IP850.local mirror-ip 192.168.2.1
tmsh mv cm device BIG-IP850.local big-ip1.local

tmsh run cm add-to-trust device 192.168.2.2 username admin password admin device-name big-ip2.local
```

# masterキーを合わせる
masterキーを取得するコマンドは`f5mku -K`  

```
f5mku -r 00000000
```

# ucsをインポートする
ucsをBIG-IPに入れた後、以下のコマンドでインポート  
```
tmsh load sys ucs ucsFile.ucs no-license no-platform-check
```
