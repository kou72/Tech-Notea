# 環境

centos 7  

/etc/pki/tls/openssl.cnf  
  - configファイル

/etc/pki/CA  
  - 作業ディレクトリ
  
参考:  
[http://www.petatec.co.jp/achives/254/](http://www.petatec.co.jp/achives/254/)  
[https://www.kakiro-web.com/linux/ssl-client.html](https://www.kakiro-web.com/linux/ssl-client.html)  
[https://weblabo.oscasierra.net/openssl-gencert-1/](https://weblabo.oscasierra.net/openssl-gencert-1/)  
[https://qiita.com/takech9203/items/5206f8e2572e95209bbc](https://qiita.com/takech9203/items/5206f8e2572e95209bbc)  
[https://qiita.com/mitzi2funk/items/602d9c5377f52cb60e54](https://qiita.com/mitzi2funk/items/602d9c5377f52cb60e54)

# configファイル

configファイルの読解が難しい

## CA局

```
[ CA_default ]
dir             = /etc/pki/CA           # CAコマンドで参照されるディレクトリ
certs           = $dir/certs            # Where the issued certs are kept
crl_dir         = $dir/crl              # Where the issued crl are kept
database        = $dir/index.txt        # database index file.
#unique_subject = no                    # Set to 'no' to allow creation of
                                        # several ctificates with same subject.
new_certs_dir   = $dir/newcerts         # default place for new certs.
certificate     = $dir/cacert.pem       # The CA certificate
serial          = $dir/serial           # The current serial number
crlnumber       = $dir/crlnumber        # the current crl number
                                        # must be commented out to leave a V1 CRL
crl             = $dir/crl.pem          # The current CRL
private_key     = $dir/private/cakey.pem# The private key
RANDFILE        = $dir/private/.rand    # private random number file
x509_extensions = usr_cert              # The extentions to add to the cert
# Comment out the following two lines for the "traditional"
# (and highly broken) format.
name_opt        = ca_default            # Subject Name options
cert_opt        = ca_default            # Certificate field options
# Extension copying option: use with caution.
# copy_extensions = copy
# Extensions to add to a CRL. Note: Netscape communicator chokes on V2 CRLs
# so this is commented out by default to leave a V1 CRL.
# crlnumber must also be commented out to leave a V1 CRL.
# crl_extensions        = crl_ext
default_days    = 365                   # how long to certify for
default_crl_days= 30                    # how long before next CRL
default_md      = sha256                # use SHA-256 by default
preserve        = no                    # keep passed DN ordering
# A few difference way of specifying how similar the request should look
# For type CA, the listed attributes must be the same, and the optional
# and supplied fields are just that :-)
```

## policy

```
policy          = policy_match  # ここで証明書作成時のポリシーを設定
# policy        = policy_anything # デフォルトのpolicymを緩いルールに変更

# For the CA policy
[ policy_match ]
countryName             = match
stateOrProvinceName     = match
organizationName        = match
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional

[ policy_anything ]  # 全てのステータスをoptionalに変えると、証明書作成のルールが緩くなる
countryName             = optional
stateOrProvinceName     = optional
localityName            = optional
organizationName        = optional
organizationalUnitName  = optional
commonName              = optional
emailAddress            = optional
```

## default setting

```
[ req_distinguished_name ]  # 先にこれを設定しておくと、対話形式のCA作成や証明書作成が楽になる
countryName                     = Country Name (2 letter code)
countryName_default             = JP # 国を入力
countryName_min                 = 2
countryName_max                 = 2
stateOrProvinceName             = State or Province Name (full name)
stateOrProvinceName_default     = Tokyo # 都市入力
localityName                    = Locality Name (eg, city)
localityName_default            = Osaki # 区入力
0.organizationName              = Organization Name (eg, company)
0.organizationName_default      = CTC # 社名入力
# we can do this but it is not needed normally :-)
#1.organizationName             = Second Organization Name (eg, company)
#1.organizationName_default     = World Wide Web Pty Ltd
organizationalUnitName          = Organizational Unit Name (eg, section)
#organizationalUnitName_default =
commonName                      = Common Name (eg, your name or your server\'s hostname)
commonName_default              = host # ホスト名(ここ大事)
commonName_max                  = 64
emailAddress                    = Email Address
emailAddress_max                = 64
```

# CA作成

CA_defaultで指定されているディレクトリに移動  
```cd /etc/pki/CA```

index.txtとprivate/cakey.pemを削除  
というか全部のフォルダを削除

```/etc/pki/tls/misc/CA -newca```
でCA局を作成  
[https://qiita.com/kobake@github/items/af0e4d27807601c1fce1](https://qiita.com/kobake@github/items/af0e4d27807601c1fce1)  

これで以下のディレクトリができる  
```
CA
├ cacert.pem  # CA自身の証明書
├ careq.pem  # CA自身の証明書署名要求
├ certs/ # 発行証明書の保存ディレクトリ
├ crl/ # 失効リスト
├ index.txt # インデックス
├ newcerts/ #発行証明書の保存ディレクトリ
└ private/
　 └ cakey.pem  # CA自身の秘密鍵
```  

- crlnumber作成  
```
echo 00 > crlnumber
```  

# 証明書の発行

CAの子供になるServer証明書の発行　　
server証明書もclient証明書も手順は同じ  

- 秘密鍵作成  
```
openssl genrsa -out private/server.key
```  
- 証明書署名要求作成  
```
openssl req -new -key private/server.key -out server.csr
```  
※CAと入力情報が同じだとエラーになるため、Common Nameに別のホスト名を入力する  

- 証明書発行  
```
openssl ca -in server.csr -out certs/server.crt -keyfile private/cakey.pem -cert cacert.pem
```  
x509コマンドでも証明書は発行できるが、CAとの連携ができていない模様、index.txtに何も書き込まれない。  
おそらくcaコマンドを利用するのが正しい。 

- 証明書署名要求削除  
```
rm server.csr
```  

- PKCS#12形式のファイルにまとめる  
```
openssl pkcs12 -export -inkey private/server.key -in certs/server.crt -out server.pfx
```  

- 証明書の失効
```
openssl ca -revoke certs/server.crt -keyfile private/cakey.pem -cert cacert.pem
```  

- 失効リストを作成
```
openssl ca -gencrl -out crl/revoke.crl
```
