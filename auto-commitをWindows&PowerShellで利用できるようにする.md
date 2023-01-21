# 通常

https://github.com/m1guelpf/auto-commit  

Windowsだとインストーラーが使えないので、手動でバイナリを配置する必要がある。

# Windows

## 1. 最新版`auto-commit-win-x86_64.exe`をダウンロード  

- https://github.com/m1guelpf/auto-commit/releases  

## 2. Pathの通ってる場所に配置

- `C:\Windows\System32\` など
- `auto-commit.exe` にRenameもしておく


## 3. APIキーを環境変数に設定する

- システムの詳細設定 > 環境変数 > システム環境変数 > 新規
  - 変数名：OPENAI_API_KEY
  - 変数値：sk-XXXXXXXX
- APIキーはここで取得
  - https://beta.openai.com/account/api-keys

## 4. 再起動する

- 環境変数を反映するためPCを再起動する
- `git add` してる状態で `auto-commit` を打ち込むと使える
