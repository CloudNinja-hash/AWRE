Rename-LocalUser -Name "Administrator" -NewName "Agent"

Start-Sleep -Seconds 10

Restart-Computer -Force
