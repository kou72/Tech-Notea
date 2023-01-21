# 通常

https://github.com/m1guelpf/auto-commit  

Windowsだとインストーラーが使えないので、手動でバイナリを配置する必要がある。

# Windows

## 1. 最新版`auto-commit-win-x86_64.exe`をダウンロード  

- https://github.com/m1guelpf/auto-commit/releases  

## 2. Pathの通ってる場所に配置

- `C:\Windows\System32\` など
- `auto-commit.exe` にRenameもしておく
- 配置後再起動する

## 3. APIキーを環境変数に設定する

- https://learn.microsoft.com/ja-jp/powershell/module/microsoft.powershell.core/about/about_environment_variables?view=powershell-7.3
- 例）$Env:OPENAI_API_KEY = "sk-XXXXXXXX"
- APIキーはここで取得
  - https://beta.openai.com/account/api-keys

## 4. PowerShellから使う

- `git add` してる状態で `auto-commit` を打ち込むと使える
