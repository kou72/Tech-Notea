# Apresia でLAGを組むときの注意
speedを固定する必要がある

config(100m/fullで固定)
```
interface fastEthernet 1
 advertise delete 10m/half
 advertise delete 10m/full
 advertise delete 100m/half
 link-aggregation 1
!
interface fastEthernet 2
 advertise delete 10m/half
 advertise delete 10m/full
 advertise delete 100m/half
 link-aggregation 1
```
