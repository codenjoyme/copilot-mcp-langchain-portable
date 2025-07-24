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
