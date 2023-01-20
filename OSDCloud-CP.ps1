Write-Host "Welcome to PowerON OSDCloud - CP Build"
Write-Host "This will installed Windows 10 21H2"

Start-Sleep -Seconds 5

Start-OSDCloud -FindImageFile -SkipAutopilot -SkipODT -ZTI
