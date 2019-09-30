# Auto Last Hop

戻りのパケットにルーティングテーブルを使用しない  
→ GWを設定していなくても正確に戻りのパケットを送信できる  

`デフォルトでenableだがdisable推奨`

Auto Last Hop  
http://www.f5networks.co.jp/shared/pdf/BIG-IP_TB_Last_Hop.pdf  
ICMPリダイレクト  
https://www.infraexpert.com/study/fhrpz12.html

# Packet Filter

通信をフィルタリングしたい時に使用  
Network → Packet Filters → General  

https://alpha-netzilla.blogspot.com/2011/07/big-ip.html

# Traffic-group

`FloatingするIPアドレス(Floating IP と Virtual Server)に紐づく`、バランシングするためのグループ  
Traffic-groupごとに、どの筐体をActiveとするか決めることが出来る  
Active-Standby構成の場合は、必然的にTraffic-groupは1つになる  

https://www.infraeye.com/study/bigip10.html
