# GNS3の初期セットアップ

## GNS3インストール

GNS3：https://www.gns3.com/software/download  
GNS3-VM：https://www.gns3.com/software/download-vm  
※vmware版をインストールすること、virtualbox版ではappliancesをインストールできない。  

## VM立ち上げ

vmware上でNGS3serverを立ち上げ  
https://ichibariki.hatenablog.com/entry/2018/11/25/211353  

※設定 > プロセッサとメモリ > 詳細オプション から次にチェック
- この仮想マシンでハイパーバイザーアプリケーションを有効にする
- この仮想マシンでコードプロファイリングアプリケーションを有効にする

## GNS3を立ち上げ

プロジェクト立ち上げ  
Preference > GNS3 VMをvmwareでenable  

# Appliancesインストール

GNS3 Appliances：https://www.gns3.com/marketplace/appliances  

## BIG-IPインストール

https://www.gns3.com/marketplace/appliance/f5-big-ip

## Alpine Linux

https://www.gns3.com/marketplace/appliance/alpine-linux-2

## Import Appliances

File > Import Appliances からインストールした .gns3aファイルインポート  
GNS3内の案内に従って、必要なOS等をDownload > Import  

# HTTPサーバー用意




