# BIG-IP_ucsリストア時のエラーとその対応

- /config/bigip_base.conf  

を変更

## 基本情報

物理版ucs -> vm版  

- 物理版  
version 11.6.1 build 1.0.326 edition Hotfix HF1
- vm版  
version 11.6.1 build 1.0.326 edition Hotfix HF1

## インターフェースに不正な値

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

## trunk port
```
01070307:3: Invalid interface 1.7
Unexpected Error: Loading configuration process failed.
```

trunkの記述を削除
```
net stp /Common/cist {
    trunks {
        external_trunk {
            external-path-cost 20000
            internal-path-cost 20000
        }
    }
    vlans {
        /Common/external
    }
}
net stp-globals {
    config-name 00-01-D7-E4-47-80
}
net trunk external_trunk {
    interfaces {
        1.1
        1.2
    }
}
net vlan /Common/external {
    interfaces {
        external_trunk { }
    }
    tag 4094
}
```
↓
```
net stp-globals {
    config-name 00-01-D7-E4-47-80
}
net vlan /Common/external {
    tag 4094
}
```
または
```
net stp-globals {
    config-name 00-01-D7-E4-47-80
}
net vlan /Common/HA {
    interfaces {
        1.3 { }
    }
    sflow {
        poll-interval-global no
        sampling-rate-global no
    }
    tag 1
}
net vlan /Common/external {
    interfaces {
        1.1 { }
    }
    sflow {
        poll-interval-global no
        sampling-rate-global no
    }
    tag 4094
}
```
## global-settings mgmt-dhcp をdisabled に変更

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

## HA用の設定が重複している

```
010713b1:3: Cannot delete IP (1.1.1.1) because it is used by the system state-mirroring (Primary Mirror Address) setting.
Unexpected Error: Loading configuration process failed.
```

リストア後のipを事前の機器で使わないよう設定変更  
(この時は一度HA関連の設定を全て無効にし、1.1.1.1で設定していたのHA-IPを10.1.1.1に変更した。)

## master key が変更できない
```
[root@test:Active:In Sync (Trust Domain Only)] config # f5mku -r 000000000000xXX==
Rekeying Master Key...
Error trying to rekey: 01071769:3: Decryption of the field (secret) for object (/Common/sctp) failed.
```
直前に以下の操作をしていたのが原因と思われる  
- HAを組む
- master keyを変更する(1号機,2号機)
- 1号機のみをkey変更前にリストア→再設定
- 改めてHAを組んだ時にSyncによって2号機のmaster keyが変更前に上書きされる
- 2号機内部でmaster keyの差分が生まれた？

2号機も再リストア→再設定することで解決

## licenseエラー
```
This device is not operational because the loaded configuration contained errors or unlicensed objects. Please adjust the configuration and/or the license, and re-license the device.
```

以下投入してlicenseの再アクティベート
```
 reloadlic
```

## LOAD

```
tmsh load sys config
```

## リストアしたBIG-IPに対してping疎通できない

EAXiとの相性問題でいくつかの設定が必要。  

#### 仮想スイッチのセキュリティ設定を変更  

- ESXiのコンソール -> ネットワーク -> 仮想スイッチ -> 利用中の仮想スイッチを選択
- 設定の編集 -> セキュリティ
  - 無差別モード : 承諾
  - MAC アドレス変更 : 承諾
  - 偽装転送 : 承認
  
#### BIG-IP側のVLANをタグ無しへ変更

- Network -> VLANs -> 対象VLAN -> Interfaces
  - Tagging : Untagged

#### 参考
https://devcentral.f5.com/s/question/0D51T00006i7Yw2/new-bigip-ve-not-passing-any-traffic
