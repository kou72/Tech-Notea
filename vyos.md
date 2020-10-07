# image install
image installをしておかないと、リブートで設定がすべて消える

https://hawksnowlog.blogspot.com/2016/12/deployed-vyos-into-esxi6.html

# 初期config
https://ichibariki.com/entry/2018/11/24/161448

# コマンド
https://ichibariki.com/entry/2018/06/16/220219

# config出力
```
show config command
```

出力例
```
vyos@vyos:~$ show configuration commands
set interfaces ethernet eth0 address '10.222.136.49/24'
set interfaces ethernet eth1 address '192.168.10.254/24'
set interfaces ethernet eth2 address 'dhcp'
set interfaces ethernet eth3 address '160.186.10.114/30'
set interfaces loopback lo
set nat source rule 1 outbound-interface 'eth2'
set nat source rule 1 source address '192.168.10.0/24'
set nat source rule 1 translation address 'masquerade'
set protocols static route 10.32.32.0/21 next-hop 10.222.136.254
set protocols static route 10.205.12.0/22 next-hop 10.222.136.254
set service ssh
set system config-management commit-revisions '100'
set system console device ttyS0 speed '115200'
set system host-name 'vyos'
set system login user vyos authentication encrypted-password '$6$xrL9ILL1D2cBQ$givGBmDqHW.zG2lBMFhM4FJqrObJjf4uI0AvlX.wKvt1Lvt/puyqqWFINxaH5AQbl8HXs0eDx9UjQQbPlEZjn1'
set system login user vyos authentication plaintext-password ''
set system ntp server 0.pool.ntp.org
set system ntp server 1.pool.ntp.org
set system ntp server 2.pool.ntp.org
set system syslog global facility all level 'info'
set system syslog global facility protocols level 'debug'
```
