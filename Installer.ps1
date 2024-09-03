$projectName = "HelloWorldApp"
$appVersion = "1.0"
$baseDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Define relative paths based on the base directory
$outputDir = Join-Path $baseDir "Output\Installer"
$exeSourcePath = Join-Path $baseDir "HelloWorldApp\bin\Release\HelloWorldApp.exe"
$innoSetupPath = "C:\Program Files (x86)\Inno Setup 6"
$templatePath = Join-Path $baseDir "InnoSetup.iss"
$downloadUrl = "https://jrsoftware.org/download.php/is.exe"  # Inno Setup download link
$installerPath = Join-Path $baseDir "InnoSetupInstaller.exe"

# Function to download Inno Setup if it's not installed
function Install-InnoSetup {
    if (-Not (Test-Path "$innoSetupPath\ISCC.exe")) {
        Write-Host "Inno Setup not found. Downloading..."
        Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath
        
        Write-Host "Installing Inno Setup..."
        Start-Process -FilePath $installerPath -ArgumentList "/VERYSILENT /NORESTART" -Wait
        
        # Check if installed successfully
        if (-Not (Test-Path "$innoSetupPath\ISCC.exe")) {
            Write-Error "Inno Setup installation failed."
            exit 1
        }
    } else {
        Write-Host "Inno Setup is already installed."
    }
}

# Ensure Output Directory exists
if (-Not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Force -Path $outputDir
}

# Install Inno Setup if necessary
Install-InnoSetup

# Load the .iss template content
$scriptContent = Get-Content -Path $templatePath -Raw

# Replace placeholders with actual values
$scriptContent = $scriptContent -replace '{#AppName}', $projectName
$scriptContent = $scriptContent -replace '{#AppVersion}', $appVersion
$scriptContent = $scriptContent -replace '{#OutputDir}', $outputDir
$scriptContent = $scriptContent -replace '{#ExeSourcePath}', $exeSourcePath

# Save the modified script to the output directory
$issFilePath = Join-Path $outputDir "$projectName.iss"
$scriptContent | Set-Content -Path $issFilePath

# Run Inno Setup to compile the installer
$innosetupCompiler = Join-Path $innoSetupPath "ISCC.exe"
& $innosetupCompiler $issFilePath

Write-Host "Inno Setup script created and compiled successfully."
