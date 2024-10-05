# Git
function gitPull {git pull $args}
function gitAdd {git add $args}
function gitCommit {git commit -m $args}
function gitPush {git push $args}
function gitStatus {git status $args}
function gitBranch {git branch $args}
Set-Alias -Name gis -Value gitStatus
Set-Alias -Name gip -Value gitPush
Set-Alias -Name gic -Value gitCommit
Set-Alias -Name gia -Value gitAdd
Set-Alias -Name gil -Value gitPull 
Set-Alias -Name gib -Value gitBranch

# Other tools
function pwdclip {
		(pwd).Path | CLIP	
}
function statusItem {
		Get-Item $args | Format-List
}
function listDisks {
		gdr -PSProvider 'FileSystem'
}
function timeCommand { $Command = "$args"; Measure-Command { Invoke-Expression $Command 2>&1 | out-default} }
function topCommand {
		$num = [int]$args[0]
		if ($num -eq 0) {
				$num = 15
		}
		ps | sort -desc cpu | select -first $num
}

function computeWho {
    $Computer = $env:COMPUTERNAME
    $Users = query user /server:$Computer 2>&1

    $Users = $Users | ForEach-Object {
        (($_.trim() -replace ">" -replace "(?m)^([A-Za-z0-9]{3,})\s+(\d{1,2}\s+\w+)", '$1  none  $2' -replace "\s{2,}", "," -replace "none", $null))
    } | ConvertFrom-Csv

    foreach ($User in $Users)
    {
        [PSCustomObject]@{
            ComputerName = $Computer
            Username = $User.USERNAME
            SessionState = $User.STATE.Replace("Disc", "Disconnected")
            SessionType = $($User.SESSIONNAME -Replace '#', '' -Replace "[0-9]+", "")
        } 
    }
}
Set-Alias top topCommand
Set-Alias -Name df -Value listDisks
Set-Alias stat -Value statusItem
Set-Alias netstat Get-NetTCPConnection
Set-Alias -Name pwdc -Value pwdclip
Set-Alias -Name time -Value timeCommand
Set-Alias -Name subl -Value 'C:\Program Files\Sublime Text\sublime_text.exe'
Set-Alias -Name firefox -Value 'C:\Program Files\Mozilla Firefox\firefox.exe'
Set-Alias -Name chrome -Value 'C:\Program Files\Google\Chrome\Application\chrome.exe'
Set-Alias -Name extract -Value 'C:\Program Files\WinRAR\UnRAR.exe'
Set-Alias -Name touch -Value New-Item
Set-Alias ll ls
Set-Alias python3 python
Set-Alias vim nvim
Set-Alias vi nvim
Set-Alias open explorer
Set-Alias lt tree
Set-Alias who computeWho

# Icons
Import-Module -Name Terminal-Icons

# Oh-my-posh
Import-Module oh-my-posh
Set-PoshPrompt -Theme  ~/.oh-my-posh.omp.json

# PSReadLine
if ($host.Name -eq 'ConsoleHost')
{
		Import-Module PSReadLine
}
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineOption -EditMode vi
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadlineKeyHandler -Key Ctrl+b -Function Complete
# keep or reset to powershell default
Set-PSReadlineKeyHandler -Key Shift+Tab -Function TabCompletePrevious
# define Ctrl+Tab like default Tab behavior
Set-PSReadlineKeyHandler -Key Tab -Function TabCompleteNext
function OnViModeChange {
        if ($args[0] -eq 'Command') {
            # Set the cursor to a blinking block.
            Write-Host -NoNewLine "`e[1 q"
        } else {
            # Set the cursor to a blinking line.
            Write-Host -NoNewLine "`e[5 q"
        }
    }
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $function:OnViModeChange

# Fzf
Import-Module PsFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
#Get-PSReadLineKeyHandler

Set-PSReadLineKeyHandler -Key Ctrl+Shift+b `
												 -BriefDescription BuildCurrentDirectory `
												 -LongDescription "Build the current directory" `
												 -ScriptBlock {
		[Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
		[Microsoft.PowerShell.PSConsoleReadLine]::Insert("dotnet build")
		[Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
Import-Module cd-extras
$AUTO_CD = $true
$ColorCompletion = $true
Import-Module -Name ParameterCache
 #Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
