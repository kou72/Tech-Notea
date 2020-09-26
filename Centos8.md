# SELinux無効化
https://server-network-note.net/2020/03/centos8-selinux/

```
getenforce
setenforce 0
```

`/etc/selinux/config `  
```diff
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
- SELINUX=enforcing
+ SELINUX=disabled
# SELINUXTYPE= can take one of these three values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
```


# Firewall無効化

```
systemctl status firewalld
systemctl stop firewalld
```

# sshd起動

```
systemctl status sshd
systemctl start sshd
```

# ipアドレスを設定
https://server-network-note.net/2020/03/centos8-set-network-ip/

```
# status
nmcli device
# static ip
nmcli connection modify ens192 ipv4.address 192.168.1.10/24
nmcli connection modify ens192 ipv4.gateway 192.168.1.1
nmcli connection modify ens192 ipv4.dns 192.168.1.1
nmcli connection modify ens192 ipv4.method manual
nmcli connection down ens192
nmcli connection up ens192
```

# スタティックルート
https://qiita.com/kooohei/items/b0931ae210911cc52adc

```
# status
netstat -nr
ip route
# static route
ip route add 172.31.0.0/16 via 10.13.0.145 dev eth0
```

# 新NIC追加
https://thinkit.co.jp/story/2014/12/25/5412?page=0%2C1

```
nmcli connection add type ethernet ifname ens224 con-name ens224
```
