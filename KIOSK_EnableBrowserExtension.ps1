
# Define registry path for Edge Extension Install Force List
$edgeExtPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist"

# Define Edge Update URL
$edgeUpdateURL = "https://edge.microsoft.com/extensionwebstorebase/v1/crx"

# Define Edge Extension IDs
$edgePrinterLogicID = "cpbdlogdokiacaifpokijfinplmdiapa"
$edgeAdobeReaderID = "elhekieabhbkpmcefcoobjddigjcaadp"
$edgeWebexID = "cmihkeafcknlomclapaddfljaeegfbdl"


# Define registry path for Chrome Extension Install Force List
$chromeExtPath = "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist"

# Define Chrome Update URL
$chromeUpdateURL = "https://clients2.google.com/service/update2/crx"

# Define Chrome Extension IDs
$chromePrinterLogicID = "bfgjjammlemhdcocpejaompfoojnjjfn"
$chromeAdobeReaderID = "efaidnbmnnnibpcajpcglclefindmkaj"
$chromeWebexID = "jlhmfgmfgeifomenelglieieghnjghma"


# Verify if Edge registry path exists, create if not found
if ( !(Test-Path -Path $edgeExtPath) ) {

    New-Item -Path $edgeExtPath -Force

}

# Create Edge registry STRING for each extension
New-ItemProperty -Path $edgeExtPath -Name "1" -PropertyType String -Value "$edgePrinterLogicID;$edgeUpdateURL" -Force

New-ItemProperty -Path $edgeExtPath -Name "2" -PropertyType String -Value "$edgeAdobeReaderID;$edgeUpdateURL" -Force

New-ItemProperty -Path $edgeExtPath -Name "3" -PropertyType String -Value "$edgeWebexID;$edgeUpdateURL" -Force


# Verify if Chrome registry path exists, create if not found
if ( !(Test-Path -Path $chromeExtPath) ) {

    New-Item -Path $chromeExtPath -Force

}

# Create Edge registry STRING for each extension
New-ItemProperty -Path $chromeExtPath -Name "1" -PropertyType String -Value "$chromePrinterLogicID;$chromeUpdateURL" -Force

New-ItemProperty -Path $chromeExtPath -Name "2" -PropertyType String -Value "$chromeAdobeReaderID;$chromeUpdateURL" -Force

New-ItemProperty -Path $chromeExtPath -Name "3" -PropertyType String -Value "$chromeWebexID;$chromeUpdateURL" -Force


# Launch Chrome for the firs time to clear the Adobe Reader pop-up
Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe"

Start-Sleep -Seconds 10

Stop-Process -Name chrome -Force
