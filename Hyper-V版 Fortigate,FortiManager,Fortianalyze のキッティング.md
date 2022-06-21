# ＯＳを入手する

https://support.fortinet.com/

- Support > VM Images
  - Select Product > FortiGate or FortiManager or FortiAnalyzer
  - Select Platform > Hyper-V
  - FXX_VM64_HV-vX.X.X-buildXXXX-FORTINET.out.hyperv.zip
    - New deployment of FortiAnalyzer for Microsoft Hyper-V

# インストールガイドに従ってインストールする

## FortiGate

https://docs.fortinet.com/document/fortigate-private-cloud/6.0.0/fortigate-vm-on-microsoft-hyper-v/12225/deploying-the-fortigate-vm

## FortiManager

https://help.fortinet.com/fmgr/vm-install/56/Document/Hyper-V/HV0_Hyper-V_Example.htm

## FortiAnalyzer

https://help.fortinet.com/fa/vm-install/56/Document/Hyper-V/HV0_Hyper-V_Example.htm

## 注意

### ハードドライブの追加

実施しない場合、CLIには入れるが、GUIで反応しないとい挙動になる。

- Hyper-V マネージャー > 仮想マシン > 設定 > IDEコントローラ0 > 追加
  - 追加されたハードドライブを以下手順で設定
    - https://help.fortinet.com/fmgr/vm-install/56/Document/Hyper-V/HV2_Configure_HW_settings.htm
    - 「新規」からログを保存する領域を作成

# 検証ライセンスを有効化する

## FortiGate or FortiManager

インターネット接続 > GUIにてFortiCloudのアカウントの登録 > リブートされるので再度アクセス

## FrotiGate

GUIにて以下が表示される

> fortigate evaluation license has expired. upload a new license  
> Expired on 1969/12/31


ファクトリーリセットを行うことで解消する。
```
Fortigate-VM # execute factoryreset 
```

### 注意

FotiGateの評価版ライセンスではHTTPSのGUIが利用できない
