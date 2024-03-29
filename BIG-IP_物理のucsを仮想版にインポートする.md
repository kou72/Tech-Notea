# master keyを合わせる

UCS作成側
```
[root]# f5mku -K
```

リストア側
```
[root]# f5mku -r <key_value>
```

# ucsをロードする

## GUIかFTP等を用いてucsをアップロードする  

- GUIの場合  
```
GUI > System > Archives > Uploadよりアップロード
```  

- FTP等を利用する場合
```
cd /var/local/ucs/
ftp
ftp> open <ftp server ip address>
ftp> <username>
ftp> <password>
ftp> get ucs_name.ucs
ftp> quit
cd /var/config
```

## ホスト名を揃える
```
tmsh modify sys global-settings hostname <ホスト名>
```

## ロード
```
tmsh load sys ucs <UCSファイル名> no-license no-platform-check
```

# bigip_base.config からtrunk設定を削除

VE版はtrunkが組めないので、その部分だけ削除  
- net stp 全削除
- net trunk 全削除
- net vlan インターフェース部分削除
---
- /config/bigip_base.conf
```diff
net interface 1.0 {
    lldp-tlvmap 114552
-   stp-edge-port false
}
- net stp /Common/cist {
-   trunks {
-       external_trunk {
-           external-path-cost 20000
-           internal-path-cost 20000
-       }
-   }
-   vlans {
-       /Common/external
-   }
- }
net stp-globals {
    config-name 00-01-D7-E4-47-80
-   mode rstp
}
- net trunk external_trunk {
-   interfaces {
-       1.1
-       1.2
-   }
- }
net vlan /Common/external {
-   interfaces {
-       external_trunk { }
-   }
    tag 4094
}
```
↓
```
net interface 1.0 {
    lldp-tlvmap 114552
}
net stp-globals {
    config-name 00-01-D7-E4-47-80
}
net vlan /Common/external {
    tag 4094
}
```

# global-settings mgmt-dhcp をdisabled に変更

mgmt-dhcp がenableのまま管理IPを設定するよう記述されていると以下のエラーが出る 

```
Conflicting configuration. Management-ip can't be deleted manually while DHCP is enabled. Within tmsh run 'modify sys global-settings mgmt-dhcp disabled' before manually changing the management-ip.
```

configを手動で書き換える 

- /config/bigip_base.conf
```
sys global-settings {
    gui-setup disabled
    hostname bigip.host
}
```
↓
```
sys global-settings {
    gui-setup disabled
    hostname bigip.host
    mgmt-dhcp disabled
}
```

# license.maxcores の差分によりエラーが出るとき

エラーメッセージ
```
Modifying license.maxcores to a value other than 2 is not allowed.
```

原因はこれ  
https://cdn.f5.com/product/bugtracker/ID675742.html  

UCSを取る前に以下コマンドを投下して、数値を揃える必要がある
```
# tmsh modify sys db license.maxcores value 8
```

もしくは7zipの「開く」機能から、UCSを解凍せずにファイルの中身を編集可能  
- /config/BigDB.dat
```
[License.MaxCores]
type=integer
default=0
min=0
max=1000
realm=local
scf_config=false
display_name=License.MaxCores
value=2 #　<---追加
```

# Master key を合わせたのに複合化エラーが出るとき
エラーメッセージ
```
Symmetric Unit Key decrypt failure - decrypt failure
```

原因はこれ  
https://cdn.f5.com/product/bugtracker/ID639619.html  

手順に従って実行
- 仮想版は '/config/bigip/kstore/.unitkey' が無いので、削除でOK
- Master Key は揃えているので '/config/bigip/kstore/master' の置き換えは不要
```
# bigstart stop
# rm /config/bigip/kstore/.unitkey
# rm -f /var/db/mcpd.bin
# rm -f /var/db/mcpd.info
# bigstart start
# tmsh load sys config
```

# config再読み込み
```
tmsh load sys config
```
