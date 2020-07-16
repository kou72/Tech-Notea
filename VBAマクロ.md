# 全てのシートの赤文字を黒文字に変更する

```
Sub color()

Dim Ws As Worksheet
For Each Ws In Worksheets
    Ws.Activate
    
    y = Cells(Rows.Count, "A").End(xlUp).Row
    x = 35

    For i = 1 To y
        For j = 1 To x
    
            If Cells(i, j).Font.ColorIndex = 3 Then
                Cells(i, j).Font.ColorIndex = 1
            End If
    
        Next j
    Next i

Next Ws

End Sub
```

##### 参考
[文字色の設定 - フォントやサイズの設定 - Excel VBA入門](https://www.officepro.jp/excelvba/cell_font/index6.html)  
[最終行の取得（EndRows.Count）｜VBA入門](http://www.start-macro.com/55/w/s029.html)  
[ブック内のすべてのワークシートで同じ処理を行う 《For Each～Next》｜Excel｜ヘルプの森](https://www.helpforest.com/excel/emv_sample/ex100001.htm)

# A1を選択、シートの倍率を100%

```
Sub cell()

Dim Ws As Worksheet
For Each Ws In Worksheets
    Ws.Activate
    
    Cells(1, 1).Select
    ActiveWindow.Zoom = 100

Next Ws

End Sub
```

# 非表示の名前の定義を表示させる

```
Public Sub VisibleNames()
    Dim name As Object
    For Each name In Names
        If name.Visible = False Then
            name.Visible = True
        End If
    Next
    MsgBox "すべての名前の定義を表示しました。", vbOKOnly
End Sub
```

##### 参考
[[Excel] シートで非表示になっている名前の定義を消す方法 | Developers.IO](https://dev.classmethod.jp/articles/excel-delete-name/)
