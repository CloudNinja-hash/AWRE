
## Define SentriCard Uninstaller
$uniSentri = "C:\Program Files (x86)\SentriCardUtility\unins000.exe" 

## Define SentriCard Desktop Shortcut
$deskSentri = "C:\Users\Public\Desktop\Sentri Card Utility.lnk"

## Verify SentriCard is installed
if ( Test-Path -Path $uniSentri ) {

    Start-Process -FilePath $uniSentri -ArgumentList "/SILENT" -Wait

    Remove-Item -Path $deskSentri -Force -ErrorAction SilentlyContinue

}
