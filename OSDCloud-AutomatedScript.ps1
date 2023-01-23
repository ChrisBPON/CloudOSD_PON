## Start PONOSD with default values for internal devices

function Start-PONOSD {

Write-Host  -ForegroundColor Cyan "Starting PowerONPlatform's Custom OSDCloud Script..."
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

net use * \\10.0.5.2\Cats_AP

Start-OSDCloud -FindImageFile -SkipAutopilot -SkipODT -ZTI

#Restart from WinPE
Write-Host -ForegroundColor Cyan "Build complete!"
Write-Host  -ForegroundColor Cyan "Shutting down in 5 seconds!"
Start-Sleep -Seconds 5
wpeutil shutdown


}



## Countdown function found online with customisations (https://jdhitsolutions.com/blog/powershell/2261/friday-fun-powershell-countdown/)

Function Start-Countdown {
<# comment based help is in the download version #>

Param(
[Parameter(Position=0,HelpMessage="Enter seconds to countdown from")]
[Int]$Seconds = 10,
[Parameter(Position=1,Mandatory=$False,
HelpMessage="Enter a scriptblock to execute at the end of the countdown")]
[scriptblock]$Scriptblock,
[Switch]$ProgressBar,
[Switch]$Clear,
[String]$Message = "Blast Off!"
)

#save beginning value for total seconds
$TotalSeconds=$Seconds

If ($clear) {
Clear-Host
#find the middle of the current window
$Coordinate.X=[int]($host.ui.rawui.WindowSize.Width/2)
$Coordinate.Y=[int]($host.ui.rawui.WindowSize.Height/2)
}

#define the Escape key
$ESCKey = 27

#define a variable indicating if the user aborted the countdown
$Abort=$False

while ($seconds -ge 1) {

if ($host.ui.RawUi.KeyAvailable)
{
$key = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyUp,IncludeKeyDown")

if ($key.VirtualKeyCode -eq $ESCkey)
{
#ESC was pressed so quit the countdown and set abort flag to True
$Seconds = 0
$Abort=$True
}
}

If($ProgressBar){
#calculate percent time remaining, but in reverse so the progress bar
#moves from left to right
$percent=100 - ($seconds/$TotalSeconds)*100
Write-Progress -Activity "Countdown" -SecondsRemaining $Seconds -Status "Time Remaining" -PercentComplete $percent
Start-Sleep -Seconds 1
} Else {
if ($Clear) {
Clear-Host
}
#write the seconds with padded trailing spaces to overwrite any extra digits such
#as moving from 10 to 9
$pad=($TotalSeconds -as [string]).Length
if ($seconds -le 10) {
$color="Red"
}
else {
$color="Green"
}
Write-Host "$(([string]$Seconds).Padright($pad))" -foregroundcolor $color
Start-Sleep -Seconds 1
}
#decrement $Seconds
$Seconds--
} #while

if (-Not $Abort) {
if ($clear) {
#if $Clear was used, center the message in the console
$Coordinate.X=$Coordinate.X - ([int]($message.Length)/2)
}


Write-Host "Starting PON OSD with default values" -ForegroundColor Green
Start-PONOSD
#run the scriptblock if specified
if ($scriptblock) {
Invoke-Command -ScriptBlock $Scriptblock
}
}
else {
Write-Warning "ESC Key Pressed. Starting OSDCloudGUI..."
Start-OSDCloudGUI
}
} #end function

#define the Escape key
$ESCKey = 27

#define a variable indicating if the user aborted the countdown
$Abort=$False

while ($seconds -ge 1) {

if ($host.ui.RawUi.KeyAvailable)
{
$key = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyUp,IncludeKeyDown")

if ($key.VirtualKeyCode -eq $ESCkey)
{
#ESC was pressed so quit the countdown and set abort flag to True
$Seconds = 0
$Abort=$True
}
}
}


Write-Host "Welcome to PowerON OSD Cloud!"
Start-Sleep 1
Write-Warning "Press ESC within 10 seconds to customise OSDCloud or else default script will run"
Write-Host "`n"
Write-Host "`n"
Write-Host "`n"

Start-PONOSD

## Use below for automation
## Start-Countdown -ProgressBar -Seconds 10 -Clear

