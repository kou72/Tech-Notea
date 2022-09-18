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
diag debug disable
```

# CLIで静的MGMT接続
ipアドレス設定
```
# config system interface
(interface) # edit port1
(port1) # set mode static
(port1) # set ip 192.168.255.105 255.255.255.0
(port1) # show
config system interface
    edit "port1"
        set vdom "root"
        set ip 192.168.255.105 255.255.255.0
        set allowaccess ping https ssh http fgfm
        set type physical
        set snmp-index 1
    next
end
(port1) # end
```

GW設定  
https://nwengblog.com/fortigate-static/#toc6
```
config router static
    edit 1
        set dst 0.0.0.0 0.0.0.0
        set gateway 192.168.255.1
        set device "port1"
    next
end
```

443へのログインを許可する  
https://raipachi-8888.hatenablog.com/entry/2020/08/11/215840
```
config system global
    set admin-https-pki-required enable
end
```
