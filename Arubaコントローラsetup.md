# 仮想版OSを取得

arubaのファイルサーバ(2020年11月まで)  
https://support.arubanetworks.com/
- Lifetime Warranty Software
- 検索窓から「os」で検索

新しいポータルサイト  
https://asp.arubanetworks.com/

# Esxiの注意点

- ネットワーク アダプタ 2 - Gi0/0/1 に対応している
- 仮想スイッチの編集が必要
  - セキュリティ
    - 無差別モード : 承諾

# 評価版ライセンス

### ライセンスマネージャ  
https://lms.arubanetworks.com/
- Licenses - Trial Licenses
- AOS - Add New
- 90D-MC-VA-1K-JP - Add - Create
- メールが届く
  - Order Number
  - Confirmation Number
- Licenses - Activate - Order Info入力 - Load
- Redeem - 1  
  - Serial number/ Passphrase (MCから取得)
  - Friendly Name (適当な名前)
  - チェック
  - Activate
- Activation Key取得 - Done
- Licenses - View からもActivation Key取得可能

### MC
- Mobility Controller - Configuration - License - License
- 「+」
  - License Passphrase 取得
  - フォームにActivation Keyを入力 - OK

### ライセンスマネージャでAOSが選択できないとき

- HPE Generate Eval Registration IDsへ接続
  - https://h10145.www1.hpe.com/license/GenerateEvalRegIDs.aspx
- Product Line - AOS
- Select Product(s) - JY910AAE Aruba MC-VA-1K (JP) Cntlr 1K AP E-LTU - Add product(s) - Generate

処理を進めるとライセンスのメールが届く。  

# Control Plane Securityの設定

> コントローラはデフォルトで「Control Plane Security（CPSec）」とい
う機能が有効になっています。このため、コントローラにMACアドレス
を登録したAPのみが接続できます。ここでは簡単に設定するためこの機
能を無効にします。Control Plane Securityの詳細は4-1-3項で解説していま
す。

### GUI
- Mobility Controller - デバイス名 - Configuration - System - CPSec
  - Control Plane Security
  - トグルoff
  - Submit
  
### CLI
```
(Aruba7030) #configure terminal
(Aruba7030)(config) #control-plane-security
(Aruba7030)(Control Plane Security Profile) #no cpsec-enable
```

# APをコントローラに接続

### apboot
```
factory_reset

mfginfo
osinfo
printenv

setenv name HOSTNAME
setenv ipaddr 10.1.100.1
setenv netmask 255.255.255.0
setenv gatewayip 10.1.100.254
setenv master 10.1.100.100
setenv sereverip 10.1.100.100

printenv
saveenv
boot
```

# 参考

[ArubaOS 8.x Command-Line Interface Reference Guide](https://www.arubanetworks.com/techdocs/CLI-Bank/Content/CLI%20RG/cli-home-aos.htm)


