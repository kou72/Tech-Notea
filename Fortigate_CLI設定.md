# NTPサーバー

```
# show sys ntp
config system ntp
    set ntpsync enable
    set type custom
    config ntpserver
        edit 1
            set server "160.186.10.113"
        next
    end
    set server-mode enable
    set interface "VLAN614" "VLAN615" "VLAN620" "VLAN650"
end
```

# MGMT

https://gold.nvc.co.jp/document/fortinet/tech/tech_doc/HA_manage_.pdf

```
# show system ha
config system ha
    set group-name "shi"
    set mode a-p
    set password ENC XXXX
    set hbdev "port13" 0 "port14" 0
    set ha-mgmt-status enable
    config ha-mgmt-interfaces
        edit 1
            set interface "mgmt"
            set gateway 172.30.38.249
        next
    end
    set override disable
    set priority 200
end
```

# MGMTポートでポーリング

http://veracosta.hateblo.jp/entry/2016/02/02/170545

set ha-direct enableの設定が必要
```
# show system snmp community
config system snmp community
    edit 1
        set name "public"
        config hosts
            edit 1
                set ha-direct enable
                set host-type query
            next
        end
        set query-v1-status disable
        set trap-v1-status disable
        set trap-v2c-status disable
        set events XXXX
    next
end
```

# Proxy経由でシグネチャアップデート

https://tec-world.networld.co.jp/faq/show/2371

```
# show sys autoupdate tunneling
config system autoupdate tunneling
    set address "160.186.249.227"
    set port 8080
end
```

# 手動シグネチャアップデート(デバッグ取得)

アップデート用デバック開始
```
diag debug enable
diag debug application update 255
```

上記設定後、手動アップデート
```
exec update-now
```

デバック終了
```
diag debug enable 
```
