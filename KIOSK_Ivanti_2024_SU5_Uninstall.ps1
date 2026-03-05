Start-Process -FilePath "C:\Program Files (x86)\Ivanti\EPM Agent\EPMAgentInstaller.exe" -ArgumentList "/forceuninstall" -Wait

Start-Sleep -Seconds 300
