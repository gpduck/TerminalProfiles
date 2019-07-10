ipmo MSTerminalSettings -ErrorAction Stop

$ProfilePath = Find-MSTerminalFolder
$Here = $PSScriptRoot

$Profiles = @(
    [PSCustomObject]@{
        Test = { $true }
        IconUrl = "https://raw.githubusercontent.com/PowerShell/PowerShell/master/assets/Powershell_64.png"
        Profile = @{
            Name = "Windows PowerShell"
            CommandLine = "powershell.exe -noexit -encodedcommand JABIAG8AcwB0AC4AVQBJAC4AUgBhAHcAVQBJAC4AVwBpAG4AZABvAHcAVABpAHQAbABlACAAPQAgACIAUABvAHcAZQByAFMAaABlAGwAbAAiAA=="
            Background = ""
            AcrylicOpacity = 0.9
            Icon = "ms-appdata:///roaming/Powershell_64.png"
            Padding = @(5,5,5,5)
            HistorySize = 9001
            ColorScheme = "Pandora"
            CursorColor = ""
            CursorShape = "bar"
            FontFace = "Fira Code Retina"
            StartingDirectory = "%USERPROFILE%"
            FontSize = 12
            CloseOnExit = $true
            SnapOnInput = $true
            UseAcrylic = $true
        }
    },[PSCustomObject]@{
        Test = { Test-Path "C:\Program Files\PowerShell\6\pwsh.exe"}
        IconUrl = "https://raw.githubusercontent.com/PowerShell/PowerShell/master/assets/Square44x44Logo.png"
        BackgroundUrl = "https://live.staticflickr.com/109/304067807_7aea893c99_o_d.jpg"
        Profile = @{
            Name = "PowerShell Core"
            CommandLine = "C:\Program Files\PowerShell\6\pwsh.exe -noexit -encodedcommand JABIAG8AcwB0AC4AVQBJAC4AUgBhAHcAVQBJAC4AVwBpAG4AZABvAHcAVABpAHQAbABlACAAPQAgACIAcAB3AHMAaAAiAA=="
            Background = ""
            AcrylicOpacity = 0.9
            Icon = "ms-appdata:///roaming/Square44x44Logo.png"
            backgroundImage = "ms-appdata:///roaming/304067807_7aea893c99_o_d.jpg"
            backgroundImageOpacity = 0.35
            backgroundImageStretchMode = "uniformToFill"
            Padding = @(5,5,5,5)
            HistorySize = 9001
            ColorScheme = "Pandora"
            CursorColor = ""
            CursorShape = "bar"
            FontFace = "Fira Code Retina"
            StartingDirectory = "%USERPROFILE%"
            FontSize = 12
            CloseOnExit = $true
            SnapOnInput = $true
            UseAcrylic = $false
        }
    },[PSCustomObject]@{
        Test = { Test-Path "C:\Program Files\PowerShell\7-preview\pwsh.exe"}
        IconUrl = "https://raw.githubusercontent.com/PowerShell/PowerShell/master/assets/Square44x44Logo-Preview.png"
        BackgroundUrl = "https://live.staticflickr.com/115/304040363_f0ce0f7633_o_d.jpg"
        Profile = @{
            Name = "PowerShell Core Preview"
            CommandLine = "C:\Program Files\PowerShell\7-preview\pwsh.exe -noexit -encodedcommand JABIAG8AcwB0AC4AVQBJAC4AUgBhAHcAVQBJAC4AVwBpAG4AZABvAHcAVABpAHQAbABlACAAPQAgACIAcAB3AHMAaAAiAA=="
            Background = ""
            AcrylicOpacity = 0.9
            Icon = "ms-appdata:///roaming/Square44x44Logo-Preview.png"
            backgroundImage = "ms-appdata:///roaming/304040363_f0ce0f7633_o_d.jpg"
            backgroundImageOpacity = 0.35
            backgroundImageStretchMode = "uniformToFill"
            Padding = @(5,5,5,5)
            HistorySize = 9001
            ColorScheme = "Pandora"
            CursorColor = ""
            CursorShape = "bar"
            FontFace = "Fira Code Retina"
            StartingDirectory = "%USERPROFILE%"
            FontSize = 12
            CloseOnExit = $true
            SnapOnInput = $true
            UseAcrylic = $false
        }
    },[PSCustomObject]@{
        Test = {
            $ubuntu = [Text.Encoding]::Utf8.GetString([text.encoding]::Unicode.GetBytes("Ubuntu"))
            (Get-Command wsl -ErrorAction SilentlyContinue) -and ((wsl --list) -match $Ubuntu)
        }
        Iconurl = "https://raw.githubusercontent.com/gpduck/TerminalProfiles/master/ubuntu.png"
        Profile =@{
            Name = "ubuntu"
            CommandLine = "wsl.exe -d Ubuntu"
            Background = ""
            AcrylicOpacity = 0.9
            Icon = "ms-appdata:///roaming/ubuntu.png"
            Padding = @(5,5,5,5)
            HistorySize = 9001
            ColorScheme = "Desert"
            CursorColor = ""
            CursorShape = "bar"
            FontFace = "Fira Code Retina"
            StartingDirectory = "%USERPROFILE%"
            FontSize = 12
            CloseOnExit = $true
            SnapOnInput = $true
            UseAcrylic = $true
        }
    },[PSCustomObject]@{
        Test = { $true }
        Profile = @{
            Name = "cmd"
            CommandLine = "cmd.exe"
            Background = ""
            AcrylicOpacity = 0.9
            Icon = "ms-appx:///ProfileIcons/{0caa0dad-35be-5f56-a8ff-afceeeaa6101}.png"
            Padding = @(5,5,5,5)
            HistorySize = 9001
            ColorScheme = "Campbell"
            CursorColor = ""
            CursorShape = "bar"
            FontFace = "Fira Code Retina"
            StartingDirectory = "%USERPROFILE%"
            FontSize = 12
            CloseOnExit = $true
            SnapOnInput = $true
            UseAcrylic = $true
        }
    }
)

function InstallFile {
    param(
        [Parameter(Mandatory=$true)]
        $Url,

        [Parameter(Mandatory=$false)]
        $Name
    )
    $Uri = [Uri]$Url
    if($Name) {
        $FilePath = Join-Path $ProfilePath $Name
    } else {
        $FilePath = Join-Path $ProfilePath $Uri.Segments[-1]
    }
    if(!(Test-Path $FilePath)) {
        try {
            switch -Wildcard ($Uri.Scheme) {
                "http*" {
                    Invoke-RestMethod -Uri $Uri -OutFile $FilePath
                }
                "file" {
                    Copy-Item $Uri.LocalPath $FilePath
                }
                default {
                    Write-Warning "Unknown Uri scheme '$_' on $Url"
                }
            }
        } catch {
            Write-Error "Unable to install file to $FilePath from $Url" -ErrorAction Continue
        }
    }
}

function InstallItermProfile {
    param($Name)

    if(!(Get-MSTerminalColorScheme -Name $Name)) {
        try {
            $TempFile = [IO.Path]::GetTempFileName()
            Invoke-RestMethod -Uri "https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/${Name}.itermcolors" -OutFile $TempFile
            Import-Iterm2ColorScheme -Path $TempFile -Name $Desired.ColorScheme
        } finally {
            if(Test-Path $TempFile) {
                Remove-Item $TempFile
            }
        }
    }
}

$Profiles | ForEach-Object {
    if(&$_.Test) {
        $Desired = $_.Profile
        Write-Verbose "Installing $($Desired.Name)"
        if($_.IconUrl) {
            InstallFile -Url $_.IconUrl
        }
        if($_.BackgroundUrl) {
            InstallFile -Url $_.BackgroundUrl
        }
        if($Desired.ColorScheme) {
            InstallItermProfile -Name $Desired.ColorScheme
        }
        $P = Get-MSTerminalProfile -Name $Desired.Name
        if($P) {
            Set-MSTerminalProfile @Desired
        } else {
            New-MSTerminalProfile  @Desired
        }
    }
}

$Default = Get-MSTerminalProfile -Name pwsh
Set-MSTerminalSetting -AlwaysShowTabs -ShowTabsInTitlebar:$false -DefaultProfile $Default.Guid