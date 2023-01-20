Write-Host "Welcome to PowerON OSDCloud - CP Build"
Write-Host "This will installed Windows 10 21H2"

Start-Sleep -Seconds 5

Write-Host "At the prompt, press 1 & Enter to choose Windows 10 enterprise"

Start-OSDCloud -FindImageFile -SkipAutopilot -SkipODT -ZTI

Write-Host "Build complete"

#Restart from WinPE
Write-Host  -ForegroundColor Cyan "Restarting in 5 seconds!"
Start-Sleep -Seconds 5
wpeutil reboot
