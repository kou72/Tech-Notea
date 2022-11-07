# アカウントを作成する

```plantuml
@startuml
' 位置揃え用矢印の太さを0、色を白にして見えなくする
skinparam ArrowThickness 0
skinparam ArrowColor white

rectangle ユーザーストーリー {
  file アカウントを新規作成する as signup
  file ログインする as login
  file ログアウトする as logout
}

signup -[#black;thickness=1]right-> login
login -[#black;thickness=1]right-> logout

@enduml
```

# プロフィールを作成する

```plantuml
@startuml
' 位置揃え用矢印の太さを0、色を白にして見えなくする
skinparam ArrowThickness 0
skinparam ArrowColor white

rectangle ユーザーストーリー {
  file プロフィール画面を確認する as view
  file 基本情報を変更する as base
  file プロフィールを記入する as prof
  file 音源を掲載する as track
}

view -[#black;thickness=1]right-> base
base -[#black;thickness=1]right-> prof
prof -[#black;thickness=1]right-> track

ユーザーストーリー -[#black;thickness=1]- 機能

rectangle 機能 {

  rectangle プロフィール画面を確認する as fview {
    file アイコンの表示 as iconview
    file ユーザー名の表示 as nameview
    file ユーザーIDの表示 as idview
    file プロフィール記入欄の表示 as profview
    file 音源掲載欄の表示 as trackview
  }
  iconview -right- nameview
  nameview -right- idview
  idview -right- profview
  profview -right- trackview

  rectangle 基本情報を変更する as fbase {
    file アイコンの変更 as icon
    file ユーザー名の変更 as name
    file ユーザーIDの変更 as id
  }
  icon -right- name
  name -right- id

  rectangle プロフィールを記入する as fprof {
    file プロフィール文章を記入 as text
    file リンクを挿入する as link
    file 画像を挿入する as image
  }
  text -right- link
  link -right- image

  rectangle 音源を掲載する as ftrack {
    file 外部サービスへのリンク掲載 as url
    file 外部サービスURL埋め込み as iframe
    file 音源アップロード as upload

  }
  url -right- iframe
  iframe -right- upload

}
fview -- fbase
fbase -- fprof
fprof -- ftrack
@enduml
```

# お金に関する情報を設定する

```plantuml
@startuml
' 位置揃え用矢印の太さを0、色を白にして見えなくする
skinparam ArrowThickness 0
skinparam ArrowColor white

rectangle ユーザーストーリー {
  file クレジットカードを登録する as credit
  file 銀行口座を登録する as bank
  file 振込申請を行う as transf
}

credit -[#black;thickness=1]right-> bank
bank -[#black;thickness=1]right-> transf

@enduml
```

# イベントを作成する

```plantuml
@startuml
' 位置揃え用矢印の太さを0、色を白にして見えなくする
skinparam ArrowThickness 0
skinparam ArrowColor white

rectangle ユーザーストーリー {
  file イベントを新規作成する as new
  file テンプレート適用する as temple
  file イベント詳細を記入する as ditail
  file タイムテーブルを作成する as table
  file 他の基本情報を入力する as base
  file グッズを設定する as goods
  file 広告を申し込む as promot
  file イベントを公開する as public
}

new -[#black;thickness=1]right-> temple
temple -[#black;thickness=1]right-> ditail
ditail -[#black;thickness=1]right-> table
table -[#black;thickness=1]right-> base
base -[#black;thickness=1]right-> goods
goods -[#black;thickness=1]right-> promot
promot -[#black;thickness=1]right-> public

@enduml
```

# イベントを見つける

```plantuml
@startuml
' 位置揃え用矢印の太さを0、色を白にして見えなくする
skinparam ArrowThickness 0
skinparam ArrowColor white

rectangle ユーザーストーリー {
  file トップページを確認する as top
  file 検索窓から検索する as search
  file 検索結果を読み進める as page
  file 気になったイベントをお気に入りする as favo
  file 検索結果に戻って他のイベントを探す as back
}

top -[#black;thickness=1]right-> search
search -[#black;thickness=1]right-> page
page -[#black;thickness=1]right-> favo
favo -[#black;thickness=1]right-> back

@enduml
```

# DJの募集に申し込む

```plantuml
@startuml
' 位置揃え用矢印の太さを0、色を白にして見えなくする
skinparam ArrowThickness 0
skinparam ArrowColor white

rectangle ユーザーストーリー {
  file イベントの詳細を確認する as check
  file DJ枠に申し込む as apply
  file 主催者とメッセージを行う as messag
  file 出演が確定した通知を受け取る as notice
  file セットリストを組む as list
  file 出演を辞退する as cancel
}

check -[#black;thickness=1]right-> apply
apply -[#black;thickness=1]right-> messag
messag -[#black;thickness=1]right-> notice
notice -[#black;thickness=1]right-> list
list -[#black;thickness=1]right-> cancel

@enduml
```

# 観客としてイベントに申し込む

```plantuml
@startuml
' 位置揃え用矢印の太さを0、色を白にして見えなくする
skinparam ArrowThickness 0
skinparam ArrowColor white

rectangle ユーザーストーリー {
  file イベントの詳細を確認する as check
  file 観客枠に申し込む as apply
  file キャンセル待ちから繰り上がった通知を受け取る as notice
  file チケットを購入する as buy
  file 参加をキャンセルする as cancel
}

check -[#black;thickness=1]right-> apply
apply -[#black;thickness=1]right-> notice
notice -[#black;thickness=1]right-> buy
buy -[#black;thickness=1]right-> cancel

@enduml
```

# イベント当日に会場に入場する

```plantuml
@startuml
' 位置揃え用矢印の太さを0、色を白にして見えなくする
skinparam ArrowThickness 0
skinparam ArrowColor white

rectangle ユーザーストーリー {
  file イベント直前の通知を受け取る as notice
  file チケットを使って受付を済ませる as recept
  file 今流れている曲を確認する as sound
}

notice -[#black;thickness=1]right-> recept
recept -[#black;thickness=1]right-> sound

@enduml
```

# イベントの事後処理を行う

```plantuml
@startuml
' 位置揃え用矢印の太さを0、色を白にして見えなくする
skinparam ArrowThickness 0
skinparam ArrowColor white

rectangle ユーザーストーリー {
  file 動画や音声をイベントページにアップロードする as upload
  file DJのセットリストを更新する as list
  file イベントの収支データを確認する as calcul
}

upload -[#black;thickness=1]right-> list
list -[#black;thickness=1]right-> calcul

@enduml
```

# 他のユーザーのプロフィールを閲覧する

```plantuml
@startuml
' 位置揃え用矢印の太さを0、色を白にして見えなくする
skinparam ArrowThickness 0
skinparam ArrowColor white

rectangle ユーザーストーリー {
  file イベントページからユーザーのプロフィールに移動する as trans
  file プロフィールを確認する as profil
  file 過去の参加イベントを確認する as old
  file 気になったユーザーをフォローする as follow
}

trans -[#black;thickness=1]right-> profil
profil -[#black;thickness=1]right-> old
old -[#black;thickness=1]right-> follow

@enduml
```

# 過去のイベントを振り返る

```plantuml
@startuml
' 位置揃え用矢印の太さを0、色を白にして見えなくする
skinparam ArrowThickness 0
skinparam ArrowColor white

rectangle ユーザーストーリー {
  file 過去に参加したイベントを確認する as old
  file お気に入りのイベント確認する as favo
  file イベントページの動画や音声を確認する as movie
}

old -[#black;thickness=1]right-> favo
favo -[#black;thickness=1]right-> movie

@enduml
```

# レコメンドを受け取ってイベントを知る

```plantuml
@startuml
' 位置揃え用矢印の太さを0、色を白にして見えなくする
skinparam ArrowThickness 0
skinparam ArrowColor white

rectangle ユーザーストーリー {
  file トップ画面のオススメのイベントを確認する as recom
  file フォローしているユーザーのイベント通知を受け取る as notice
  file 通知からイベントページに遷移する as trans
}

recom -[#black;thickness=1]right-> notice
notice -[#black;thickness=1]right-> trans

@enduml
```

# ひな形

```plantuml
@startuml
' 位置揃え用矢印の太さを0、色を白にして見えなくする
skinparam ArrowThickness 0
skinparam ArrowColor white

rectangle ユーザーストーリー {
  file story1 as s1
  file story2 as s2
}

s1 -[#black;thickness=1]right-> s2

ユーザーストーリー -- 機能

rectangle 機能 {

  rectangle future1 as f1 {
    file future11 as f11
    file future12 as f12
  }
  f11 -right- f12

  rectangle future2 as f2 {
    file future21 as f21
    file future22 as f22
  }
  f21 -right- f22

}
f1 -- f2
@enduml
```
