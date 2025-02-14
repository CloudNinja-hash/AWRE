
$CBDeskURL = 'http://intranet.lauramccarthy.com'


$pathChrome = 'C:\Users\Public\Desktop\Chrome.lnk'

$pathEdge = 'C:\Users\Public\Desktop\Edge.lnk'


$testChrome = Test-Path -Path $pathChrome -PathType Leaf

$testEdge = Test-Path -Path $pathEdge -PathType Leaf


$shell = New-Object -ComObject WScript.Shell


Function CreateChrome () {

    Copy-Item -Path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk' -Destination $pathChrome -Force

    Start-Sleep 5

    $ShortcutToChange = Get-ChildItem -Path $pathChrome -ErrorAction SilentlyContinue

    $url = $shell.CreateShortcut($ShortcutToChange.FullName)
    
    $url.Arguments = $CBDeskURL
    
    $url.Save()

}


Function CreateEdge () {

    Copy-Item -Path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk' -Destination $pathEdge -Force

    Start-Sleep 5

    $ShortcutToChange = Get-ChildItem -Path $pathEdge -ErrorAction SilentlyContinue

    $url = $shell.CreateShortcut($ShortcutToChange.FullName)
    
    $url.Arguments = $CBDeskURL
    
    $url.Save()

}


<##
## If Chrome does not exist, create it.
if (-not($testChrome)) {
    
    Write-Output "Chrome shortcut NOT found, creating shortcut...", ""

    CreateChrome

}
else {

    Write-Output "Cannot create $pathChrome because file already exists...", ""

}


## If Edge does not exist, create it.
if (-not($testEdge)) {
    
    Write-Output  "Edge shortcut NOT found, creating shortcut...", ""

    CreateEdge

}
else {

    Write-Output "Cannot create $pathEdge because file already exists...", ""

}
##>

CreateChrome
CreateEdge

