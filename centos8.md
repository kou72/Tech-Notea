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
