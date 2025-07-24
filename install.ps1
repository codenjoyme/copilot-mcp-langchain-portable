# Load environment variables from .env file
Get-Content ".env" | ForEach-Object {
    if ($_ -match "^([^=]+)=(.*)$") {
        Set-Variable -Name $matches[1] -Value $matches[2]
    }
}

Write-Host "Starting installation process..." -ForegroundColor Green

# Create tools directory
New-Item -ItemType Directory -Force -Path "tools" | Out-Null

# -----------------------------------------------------
# Download and install VSCode
Write-Host "Downloading VSCode..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $VSCODE_URL -OutFile "vscode.zip"

Write-Host "Extracting VSCode to $VSCODE_DIR..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $VSCODE_DIR | Out-Null
Expand-Archive -Path "vscode.zip" -DestinationPath $VSCODE_DIR -Force

# Cleanup
Remove-Item "vscode.zip"

Write-Host "VSCode installation completed!" -ForegroundColor Green

# -----------------------------------------------------
# Download and install Git
Write-Host "Downloading Portable Git..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $GIT_URL -OutFile "git-portable.7z.exe"

Write-Host "Extracting Git to $GIT_DIR..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $GIT_DIR | Out-Null
Start-Process -FilePath "git-portable.7z.exe" -ArgumentList "-o$GIT_DIR", "-y" -Wait

# Cleanup
Remove-Item "git-portable.7z.exe"

Write-Host "Git installation completed!" -ForegroundColor Green

# -----------------------------------------------------
# Download and install Python
Write-Host "Downloading Python embeddable..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $PYTHON_URL -OutFile "python-embed.zip"

Write-Host "Extracting Python to $PYTHON_DIR..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $PYTHON_DIR | Out-Null
Expand-Archive -Path "python-embed.zip" -DestinationPath $PYTHON_DIR -Force

# Cleanup
Remove-Item "python-embed.zip"

Write-Host "Python installation completed!" -ForegroundColor Green

# -----------------------------------------------------
# Setup pip for embeddable Python
Write-Host "Setting up pip for Python..." -ForegroundColor Yellow

# Download get-pip.py
Invoke-WebRequest -Uri $GET_PIP_URL -OutFile "get-pip.py"

# Install pip
& ".\$PYTHON_DIR\python.exe" "get-pip.py"

# Fix Python paths configuration
$pythonPthFile = "$PYTHON_DIR\python313._pth"
$newContent = @"
python313.zip
.
Lib\site-packages
Scripts

# Uncomment to run site.main() automatically
import site
"@
Set-Content -Path $pythonPthFile -Value $newContent

# Cleanup
Remove-Item "get-pip.py"

Write-Host "Pip setup completed!" -ForegroundColor Green

# -----------------------------------------------------
# Clone project repository
Write-Host "Cloning project repository..." -ForegroundColor Yellow

# Set up Git environment
$env:PATH = ".\$GIT_DIR\bin;$env:PATH"

# Clone the project
& ".\$GIT_DIR\bin\git.exe" clone $PROJECT_REPO $PROJECT_DIR

Write-Host "Project cloning completed!" -ForegroundColor Green

# -----------------------------------------------------
# Create VSCode launcher with portable tools
Write-Host "Creating VSCode launcher..." -ForegroundColor Yellow

$currentDir = (Get-Location).Path -replace '/', '\'
$launcherContent = @"
@echo off
REM VSCode launcher with portable tools
set PATH=$currentDir\$GIT_DIR\bin;$currentDir\$PYTHON_DIR;$currentDir\$PYTHON_DIR\Scripts;%PATH%
start "" "$currentDir\$VSCODE_DIR\Code.exe" "$currentDir\$PROJECT_DIR"
"@
Set-Content -Path "launch-vscode.bat" -Value $launcherContent

Write-Host "VSCode launcher created!" -ForegroundColor Green
Write-Host ""
Write-Host "Setup completed!" -ForegroundColor Cyan
Write-Host "To start coding, run: .\launch-vscode.bat" -ForegroundColor White
