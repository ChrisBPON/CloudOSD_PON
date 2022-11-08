Write-Host  -ForegroundColor Cyan "Starting PowerONPlatform's Custom OSDCloud ..."
Start-Sleep -Seconds 5

#Change Display Resolution for Virtual Machine
if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host  -ForegroundColor Cyan "Device is a virtual machine - Setting Display Resolution to 1600x"
    Set-DisRes 1600
}

#Make sure I have the latest OSD Content
Write-Host  -ForegroundColor Cyan "Updating the new OSD PowerShell Module"
Install-Module OSD -Force

Write-Host  -ForegroundColor Cyan "Importing the new OSD PowerShell Module"
Import-Module OSD -Force

#Start OSDCloud ZTI
Write-Host  -ForegroundColor Cyan "Start OSDCloud with default Parameters"
Start-OSDCloud -OSName "Windows 11 21H2 x64" -OSEdition Enterprise -OSLanguage en-GB -Screenshot -ZTI

#Restart from WinPE
Write-Host  -ForegroundColor Cyan "Restarting in 10 seconds!"
Start-Sleep -Seconds 10
wpeutil reboot
