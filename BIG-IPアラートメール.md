# BIG-IPでのアラートメール設定

## 設定の流れ

1. /etc/ssmtp/ssmtp.conf の編集
    - メールサーバを指定
    - tmsh コマンドから編集可能

2. /config/user_alert.conf の編集
    - アラート内容とメール送信の紐づけ
    - 項目は /etc/alertd/alert.conf から流用して使用
    - 各項目の詳細は /usr/share/snmp/mibs/F5-BIGIP-COMMON-MIB.txt. を参照する

3. logger コマンドでテスト
    - 正しく設定できてるかテスト
    - alert code は /var/run/bigip_error_maps.dat から取得

### 参考

- https://support.f5.com/csp/article/K59616664
- https://support.f5.com/csp/article/K15188934
- https://support.f5.com/csp/article/K11127



## /etc/ssmtp/ssmtp.conf の編集

BIG-IPではssmtpを使用してメールの送信を行います。
ssmtpとは簡易にメールを送信できるソフトウェアです。

### 編集手順

対象ファイルを直接書き換えることは非推奨であるため、tmshコマンドを利用して編集します。  
`sys outbound-smtp` がファイルと対応するComponentsです。  
以下のように編集します。  

```
config # tmsh
(tmos)# modify sys outbound-smtp from-line-override enabled
(tmos)# modify sys outbound-smtp mailhub xxxx.co.jp:25
(tmos)# modify sys outbound-smtp rewrite-domain bigip.yyyy.co.jp
```

- `from-line-override` 送信元を書き換えるための項目です。
- `mailhub` メールサーバーのipもしくはFQDNです。コロン使ってポートを指定することもできます。
- `rewrite-domain` 自身のホスト名を書き込みます。(v13以降から必要になったようです)

### 参考

- https://wiki.archlinux.jp/index.php/SSMTP



## /config/user_alert.conf の編集

BIG-IPではSNMPのトラップ項目として設定されている項目に、メール情報を紐づける必要があります。

### 編集手順

/etc/alertd/alert.conf から必要な項目を選び、 /config/user_alert.conf にコピーした上で編集します。
トラップの処理は /config/user_alert.conf -> /etc/alertd/alert.conf の順で行われるようです。

プールが落ちたことを検知して、メールを飛ばす設定は以下になります。

- /config/user_alert.conf

```
alert BIGIP_MCPD_MCPDERR_POOL_MEMBER_MON_STATUS {
    snmptrap OID=".1.3.6.1.4.1.3375.2.4.0.10";
    email toaddress="aaaa@to.co.jp"
    fromaddress="bbbb@from.co.jp"
    body="free"
}
```

- `email toaddress` 宛先とするメールアドレスです。
- `fromaddress` 送信元とするメールアドレスです。
- `body` メールの内容です。自由に記述できます。

SNMPとしてのアラート概要はメールのタイトルとして記述されます。  
トラップの詳細が知りたい場合はMIBファイル(/usr/share/snmp/mibs/F5-BIGIP-COMMON-MIB.txt.)を参照します。



## logger コマンドでテスト

テスト用のトラップを飛ばすためにloggerコマンドを使用します。

### テスト手順

loggerコマンドからSNMPトラップを飛ばすために、以下のフォーマットでの記述が必要になります。

```
logger -p <facility>.<level> "<alert code>:<log level>: <descriptive message>"
```

- `facility` ファシリティ設定です。次で使用する`local0`は /var/run/bigip_error_maps.dat で設定されているようです。
- `level` loggerとしてのログレベルです。
- `alert code` アラートコードです。/var/run/bigip_error_maps.dat で定義されています。
- `log level` BIG-IPが処理するログレベルです。`level`と合わせた方が良いと思われます。
- `descriptive message` メッセージ内容です。

上で設定した `BIGIP_MCPD_MCPDERR_POOL_MEMBER_MON_STATUS` でテストを行う際は、以下のようになります。

```
logger -p local0.Emerg "01070638:0: test_hogehoge."
```

### 参考

- https://qiita.com/mykysyk@github/items/e5398bc8262d35f4a1b9
