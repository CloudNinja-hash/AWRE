# Specify the directory to clear
$clearDesktop = "C:\Users\Agents\Desktop"
$clearDownloads = "C:\Users\Agents\Downloads"
$clearDocuments = "C:\Users\Agents\Documents"
$clearPictures = "C:\Users\Agents\Pictures"

# Delete all files and folders in the specified directory
Remove-Item -Path "$clearDesktop\*" -Recurse -Force
Remove-Item -Path "$clearDownloads\*" -Recurse -Force
Remove-Item -Path "$clearDocuments\*" -Recurse -Force
Remove-Item -Path "$clearPictures\*" -Recurse -Force

# Empty the recycle bin for all users
Get-ChildItem "C:\`$Recycle.Bin\" -Force | Remove-Item -Recurse -Force
