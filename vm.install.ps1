$Packages = 'office365proplus', 'nodejs', 'javaruntime', 'vscode', 'git'


function installPack () {

    ForEach ($PackageName in $Packages){
        Write-Host "installing $PackageName"
        choco install $PackageName -y
        if ($PackageName === 'javaruntime'){
            javar
        }
    }
    Write-Host "The instalation was successful"
    Write-Host "Restarting"
    Restart-Computer
}

function javar (){

    [System.Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Java\jdk-13.0.1")
    [System.Environment]::SetEnvironmentVariable("Path", [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine) + ";$($env:JAVA_HOME)\bin")
    Write-Host "vars configured"
}

function winrm(){

    enable-psremoting -force
    Set-PSSessionConfiguration -ShowSecurityDescriptorUI -Name Microsoft.PowerShell -Force
    # Set-Item WSMan:localhost\client\trustedhosts -value *
    # winrm quickconfig -y
    # winrm set winrm/config/client '@{TrustedHosts="104.43.215.127:5985"}' -y
}
try{
    winrm

    If(Test-Path -Path "$env:ProgramData\Chocolatey") {
        Write-Host "Starting package installation"
        installPack
    }
    Else {
        Write-Host "installing chocolatey"
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) -y
        Write-Host "Starting package installation"
        installPack
    }

}
catch{
    Write-Host $Error[0]
}
