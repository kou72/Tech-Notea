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
