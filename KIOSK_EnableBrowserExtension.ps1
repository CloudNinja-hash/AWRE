
$edgeExtPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist"

$edgeUpdateURL = "https://edge.microsoft.com/extensionwebstorebase/v1/crx"

$edgePrinterLogicID = "cpbdlogdokiacaifpokijfinplmdiapa"
$edgeAdobeReaderID = "elhekieabhbkpmcefcoobjddigjcaadp"
$edgeWebexID = "cmihkeafcknlomclapaddfljaeegfbdl"


$chromeExtPath = "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist"

$chromeUpdateURL = "https://clients2.google.com/service/update2/crx"

$chromePrinterLogicID = "bfgjjammlemhdcocpejaompfoojnjjfn"
$chromeAdobeReaderID = "efaidnbmnnnibpcajpcglclefindmkaj"
$chromeWebexID = "jlhmfgmfgeifomenelglieieghnjghma"


if ( !(Test-Path -Path $edgeExtPath) ) {

    New-Item -Path $edgeExtPath -Force

}

New-ItemProperty -Path $edgeExtPath -Name "1" -PropertyType String -Value "$edgePrinterLogicID;$edgeUpdateURL" -Force

New-ItemProperty -Path $edgeExtPath -Name "2" -PropertyType String -Value "$edgeAdobeReaderID;$edgeUpdateURL" -Force

New-ItemProperty -Path $edgeExtPath -Name "3" -PropertyType String -Value "$edgeWebexID;$edgeUpdateURL" -Force


if ( !(Test-Path -Path $chromeExtPath) ) {

    New-Item -Path $chromeExtPath -Force

}

New-ItemProperty -Path $chromeExtPath -Name "1" -PropertyType String -Value "$chromePrinterLogicID;$chromeUpdateURL" -Force

New-ItemProperty -Path $chromeExtPath -Name "2" -PropertyType String -Value "$chromeAdobeReaderID;$chromeUpdateURL" -Force

New-ItemProperty -Path $chromeExtPath -Name "3" -PropertyType String -Value "$chromeWebexID;$chromeUpdateURL" -Force


Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe"

Start-Sleep -Seconds 10

Stop-Process -Name chrome -Force
