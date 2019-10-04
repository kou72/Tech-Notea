# 環境が違うBIG-IPにucsをロードさせる
ハマるポイントがいくつかあるため、メモ

## 0.基本手順
STEP1 : UCSファイルのインポート (新しい筐体の /var/local/ucs にファイルをコピー)  
STEP2 : Masterキーを上書き  
`[root]# f5mku -r <key_value>`  
STEP3 : ホスト名の変更 (UCSファイルに含まれるホスト名に合わせる)  
`(tmos)# modify sys global-settings hostname <ホスト名>`  
STEP4 : UCSファイルの読み込み  
`(tmos)# load sys ucs <UCSファイル名> no-license`  
STEP5 : エラーが無いことを確認  
`(tmos)# tmsh save sys config`  
`(tmos)# tmsh load sys config`  

## 1.ライセンス情報が上書きされ、ロード後使用できなくなる
他筐体のucsをそのまま読み込ませるとライセンスも上書きしてしまう。  
GUIからではなく、CLIから次のコマンドで実行  

`(tmos)# load sys ucs hoge.ucs no-license no-platform-check`

### リカバリー

誤ってライセンスを上書きした時は、以下の手順でリカバリーできる

#### 以前のucsを際リストアする

`[root](tmos)# load sys ucs before.ucs`

#### ログからライセンスキーを再取得する

`[root]# cat /var/log/boot.log.1`  
`[root]# cat /dev/mapper/vg--db--sda-set.1._config`  
(vg--db--sda-set.1._config中のRegistration Keyを確認する)

### 参考
https://support.f5.com/csp/article/K13132

## 2.hash化されたパスが存在する場合、読み込みに失敗する
以下のエラーでucsが読み込めない場合がある  

```0107102b:3: Master Key decrypt failure - decrypt failure - final```

ハッシュ化されたパスフレーズが一致しないのが原因  
以下のコマンドでハッシュ化に使われるMasterKeyを一致させることができる  

UCS作成側  
`[root]# f5mku -K`  
(ハッシュ値が出力される)  

リストア側  
`[root]# f5mku -r <key_value>`  

configの展開は出来ているため再ロードする  
`[root](tmos)# load sys config`  

### リカバリー
事前にMasterキーを取得していなかった場合は、
以下の方法でリカバリーすることができる。

#### configのハッシュ化された行を削除

一度ucsを読み込み上記エラーで失敗後、  
/config/bigip.conf または /config/bigip_base.conf 中の  
ハッシュ化された値($M$で始まる文字列)が記述してある行を削除。

`(tmos)# load sys config`  
再読み込み

### 参考
https://devcentral.f5.com/s/articles/working-with-masterkeys
https://support.f5.com/csp/article/K9420
https://support.f5.com/csp/article/K73034260


## 3.Masterキーの上書きができない
上記問題に付属する問題として、Masterキーの上書きができない場合がある。

### バージョンが異なる
バージョンに差異があるとMasterキーのインストールが失敗する。  
私の環境では以下のログが出現した  
```err mcpd[7450]: 01071769:3: Decryption of the field (passphrase) for object (/Common/f5_api_com.key) failed.```  

### Masterキー取得元でHAが組まれている
MasterキーはHAが組まれたタイミングで、HAのピア間で同期される。  
詳細は不明だが、HAが組まれた機器から再取得したMasterキーとucsが合致せず、  
エラーが出る場合がある。  
私の環境では以下のログが出現した。  
```Error trying to rekey: 01071769:3: Decryption of the field (secret) for object (/Common/sctp) failed.```  

### リカバリー
上記2.と同様に、ハッシュ化された値を削除するのが最も早いと思われる。

### 参考
https://support.f5.com/csp/article/K73034260#ha
