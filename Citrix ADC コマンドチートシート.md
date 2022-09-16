# NSIP(=管理IP)を変更する

https://docs.citrix.com/ja-jp/citrix-adc/current-release/networking/ip-addressing/configuring-citrix-adc-owned-ip-addresses/configuring-citrix-adc-ip-address.html
```
set ns config -IPAddress 192.168.255.102 -netmask 255.255.255.0
add route 0 0 192.168.255.1
save config
reboot
```
確認
```
> show ns config
        NetScaler IP: 192.168.255.102  (mask: 255.255.255.0)
        Number of MappedIP(s): 0
        Node: Standalone
                           System Time: Fri Sep 16 18:43:05 2022
              Last Config Changed Time: Fri Sep 16 18:42:06 2022
                Last Config Saved Time: Fri Sep 16 18:00:32 2022
        Config Changed since Last Saved Config: TRUE
 Done
 
> show route
        Network          Netmask          Gateway/OwnedIP  State   Traffic Domain  Type
        -------          -------          ---------------  -----   --------------  ----
1)      0.0.0.0          0.0.0.0          192.168.255.1    UP      0              STATIC
2)      127.0.0.0        255.0.0.0        127.0.0.1        UP      0              PERMANENT
3)      192.168.255.0    255.255.255.0    192.168.255.102  UP      0              DIRECT
 Done
```

# ライセンスを確認する

https://docs.citrix.com/ja-jp/citrix-adc/current-release/licensing/citrix-adc-licensing-overview.html
```
> sh ns license
        License status:
                           Web Logging: YES
                      Surge Protection: NO
                        Load Balancing: YES
                                        ...
                          License Type: Standard License
                        Licensing mode: Express
```

有効化されてる機能の確認

```
> show feature

        Feature                        Acronym              Status
        -------                        -------              ------
 1)     Web Logging                    WL                   ON
 2)     Surge Protection               SP                   OFF
 3)     Load Balancing                 LB                   ON
 ...
 41)    ContentInspection              CI                   OFF
 Done
```
