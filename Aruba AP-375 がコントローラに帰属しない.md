# Aruba AP-375 がコントローラに帰属しない

Aruba の AP-375がコントローラに帰属しないトラブルが発生しました。  
検証の中で確認できたことを共有致します。

## version

AP：Aruba AP-375 (Unifide AP)  
VMC：ArubaOS (MODEL: ArubaMC-VA-JP), Version 8.5.0.1

## 事象

APとコントローラ間での疎通は確認できるが、  
APがIAPとして起動し続けるため、コントローラへ帰属しない。

## 解決方法

上記事象はAPの保持しているOSが誤っているために発生している可能性があります。  
以下の手順で正しいOSを取得することで解消されます。

### GUI

起動後のIAPにブラウザから入り、以下のガイドにある操作で帰属させることが出来ます。  
https://www.arubanetworks.com/assets/_ja/support/cg/UG_IAPv8-4.pdf#page=98

### CLI

今回はGUIでのログインが難しく、CLIから設定する必要がありました。  
以下がCLIによる手順になります。

---

#### 1.OSの確認

APの保持しているOSの情報は以下のコマンドで確認できます。  
```
apboot> osinfo 
```
以下は出力例です。  
```
apboot> osinfo 
Partition 0:
    image type: 0
  machine type: 40
          size: 11516472
       version: 8.5.0.1
  build string: ArubaOS version 8.5.0.1 for 32x (p4build@pr-hpn-build07) (gcc version 4.6.3 20120201 (prerelease) (Linaro GCC 4.6-2012.02) ) #71357 SMP Sat Jul 13 06:55:24 UTC 2019
         flags: 
           oem: aruba

Image is signed; verifying checksum... passed
SHA2 Signature available
Signer Cert OK
Policy Cert OK
RSA signature verified using SHA2.

Partition 1:
    image type: 0
  machine type: 40
          size: 21788024
       version: 8.5.0.3-8.5.0.3
  build string: ArubaOS version 8.5.0.3-8.5.0.3 for Hercules (p4build@pr-hpn-build10) (gcc version 4.6.3 20120201 (prerelease) (Linaro GCC 4.6-2012.02) ) #72498 SMP Mon Sep 30 20:40:52 UTC 2019
         flags: Instant preserve 
           oem: aruba

Image is signed; verifying checksum... passed
SHA2 Signature available
Signer Cert OK
Policy Cert OK
RSA signature verified using SHA2.
apboot> 
```
「Partition 0」に正しいOSがインストールされている必要があります。  

#### 2. factory_reset

工場出荷状態に戻します。  
投入した設定と「Partition 0」のOSが削除されます。  

```
apboot> factory_reset
```
OSが削除されない場合は clear コマンドで削除します。
```
apboot> clear os 0
```

#### 3.setenv

設定を投入します  
```
apboot> setenv master 10.10.10.100
apboot> setenv serverip 10.10.10.100
apboot> setenv ipaddr 10.10.20.1
apboot> setenv netmask 255.255.0.0
apboot> saveenv
```

#### 4.tftpboot

コントローラからOSを取得して起動するコマンドです。  
```
apboot> tftpboot
```
以下が出力例になります。  
「Filename」の値をメモ帳などにメモしておきます。  
```
apboot> tftpboot 
eth0: link up, speed 1 Gb/s, full duplex
Using eth0 device
TFTP from server 10.10.10.100; our IP address is 10.10.20.1
Filename 'ipq806x.ari'.
Load address: 0x44000000
Loading: *#################################################################
	 #################################################################
	 ##############################################
done
Bytes transferred = 11516472 (afba38 hex)
```
このままbootを待つと帰属までに20分ほど時間が掛かります。(詳細は後述)  
一度電源を落として、再度apbootモードにります。  

#### 5.upgrade

「Partition 0」へコントローラの持つOSを書き込みます。  
ファイル名には先程 tftpboot でメモした値を入れます。  

```
apboot> upgrade os 0 10.10.10.100:ipq806x.ari
```

#### 6.boot

bootします。正常に帰属するはずです。  
```
apboot> boot
```

---

## 「Partition 0」が空の時のAP動作

「Partition 0」が空の時、マニュアルとは異なる動作が確認されました。  

参考：http://cwe-portal.ctc-g.co.jp/cwe/ps/vendor00014/Library/Tech/02_AOS8.5_Mobility%20Master概要とLabガイド_201906.pdf#page=81  

マニュアル上の動作
 - 起動 → コントローラ探索 → IAPとして起動 → 操作せず15分経過 → 起動時に戻る → 以降繰り返し

確認した動作(コントローラへは疎通可)
 - 起動 → (探索されない) → Instant OS で起動 → 操作せず15分経過 → 起動時に戻る → Aruba OS で起動 → コントローラ探索 → 帰属

上記動作により「factory_reset → boot」という操作では帰属までに20分ほど時間が必要になります。  
tftpboot、reset、ケーブル抜線での再起動、などの操作でも同様に20分掛かりました。  

この20分を回避する方法は、upgradeコマンドを使用する操作以外見つかっていません。  

# upgrade

https://community.arubanetworks.com/t5/Controllerless-Networks/Upgrade-IAP335-to-8-X/td-p/499286
https://community.arubanetworks.com/t5/Controllerless-Networks/Upgrading-the-factory-default-partition-on-IAP/td-p/241004
