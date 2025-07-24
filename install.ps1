# Load environment variables from .env file
Get-Content ".env" | ForEach-Object {
    if ($_ -match "^([^=]+)=(.*)$") {
        Set-Variable -Name $matches[1] -Value $matches[2]
    }
}

Write-Host "Starting installation process..." -ForegroundColor Green

# Create tools directory
New-Item -ItemType Directory -Force -Path "tools" | Out-Null

# Download and install VSCode
Write-Host "Downloading VSCode..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $VSCODE_URL -OutFile "vscode.zip"

Write-Host "Extracting VSCode to $VSCODE_DIR..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $VSCODE_DIR | Out-Null
Expand-Archive -Path "vscode.zip" -DestinationPath $VSCODE_DIR -Force

# Cleanup
Remove-Item "vscode.zip"

Write-Host "VSCode installation completed!" -ForegroundColor Green
