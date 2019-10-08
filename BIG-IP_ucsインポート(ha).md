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
1号機と2号機を1番ポートで結線  
  
2号機に以下を流し込み  
```
tmsh modify sys global-settings hostname big-ip2.local
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
