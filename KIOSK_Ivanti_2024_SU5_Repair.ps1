$ebaPath = "C:\Program Files (x86)\Ivanti\EPM Agent\EPMAgentInstaller.exe"

$ebaArg = "/force"

Start-Process -FilePath $ebaPath -ArgumentList $ebaArg -Wait -NoNewWindow

Start-Sleep -Seconds 600
