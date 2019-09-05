```
While ($True) {
date;
$res = $null
$res = Invoke-WebRequest http://172.24.165.200/test.html -TimeoutSec 1
$res.StatusCode
$res.StatusDescription
echo ---
Sleep 1
}
```
