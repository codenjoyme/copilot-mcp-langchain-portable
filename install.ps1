# Load environment variables from .env file
$envVars = Get-Content ".env" | ForEach-Object {
    if ($_ -match "^([^=]+)=(.*)$") {
        @{Name = $matches[1]; Value = $matches[2]}
    }
}
$envVars | ForEach-Object { Set-Variable -Name $_.Name -Value $_.Value }

# Ensure the VSCode user data directory exists
if (!(Test-Path $VSCODE_USER_DATA_DIR)) {
    New-Item -ItemType Directory -Force -Path $VSCODE_USER_DATA_DIR | Out-Null
}

# Clear screen for better visibility
Clear-Host

# Beautiful header
Write-Host "=====================================================================" -ForegroundColor Magenta
Write-Host "PORTABLE DEVELOPMENT ENVIRONMENT INSTALLER" -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "This installer will set up:" -ForegroundColor White
Write-Host "   - VSCode (Portable)" -ForegroundColor Gray
Write-Host "   - Git (Portable)" -ForegroundColor Gray
Write-Host "   - Python (Embeddable)" -ForegroundColor Gray
Write-Host "   - LangChain Project" -ForegroundColor Gray
Write-Host ""
Write-Host "Starting installation process..." -ForegroundColor Green
Write-Host ""

# Create tools directory
New-Item -ItemType Directory -Force -Path "tools" | Out-Null

# ═══════════════════════════════════════════════════════════════
# STEP 1: VSCode Installation
# ═══════════════════════════════════════════════════════════════
if (Test-Path "$VSCODE_DIR\Code.exe") {
    Write-Host "VSCode already installed, skipping..." -ForegroundColor Cyan
} else {
    Write-Host "Downloading VSCode..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $VSCODE_URL -OutFile "vscode.zip"

    Write-Host "Extracting VSCode to $VSCODE_DIR..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $VSCODE_DIR | Out-Null
    Expand-Archive -Path "vscode.zip" -DestinationPath $VSCODE_DIR -Force

    # Cleanup
    Remove-Item "vscode.zip"

    Write-Host "VSCode installation completed!" -ForegroundColor Green
}
Write-Host ""

# ═══════════════════════════════════════════════════════════════
# STEP 2: Git Installation
# ═══════════════════════════════════════════════════════════════
if (Test-Path "$GIT_DIR\bin\git.exe") {
    Write-Host "Git already installed, skipping..." -ForegroundColor Cyan
} else {
    Write-Host "Downloading Portable Git..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $GIT_URL -OutFile "git-portable.7z.exe"

    Write-Host "Extracting Git to $GIT_DIR..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $GIT_DIR | Out-Null
    Start-Process -FilePath "git-portable.7z.exe" -ArgumentList "-o$GIT_DIR", "-y" -Wait

    # Cleanup
    Remove-Item "git-portable.7z.exe"

    Write-Host "Git installation completed!" -ForegroundColor Green
}
Write-Host ""

# ═══════════════════════════════════════════════════════════════
# STEP 3: Python Installation
# ═══════════════════════════════════════════════════════════════
if (Test-Path "$PYTHON_DIR\python.exe") {
    Write-Host "Python already installed, skipping..." -ForegroundColor Cyan
} else {
    Write-Host "Downloading Python embeddable..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $PYTHON_URL -OutFile "python-embed.zip"

    Write-Host "Extracting Python to $PYTHON_DIR..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $PYTHON_DIR | Out-Null
    Expand-Archive -Path "python-embed.zip" -DestinationPath $PYTHON_DIR -Force

    # Cleanup
    Remove-Item "python-embed.zip"

    Write-Host "Python installation completed!" -ForegroundColor Green
}
Write-Host ""

# ═══════════════════════════════════════════════════════════════
# STEP 4: Pip Setup
# ═══════════════════════════════════════════════════════════════
if (Test-Path "$PYTHON_DIR\Scripts\pip.exe") {
    Write-Host "Pip already installed, skipping..." -ForegroundColor Cyan
} else {
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
}
Write-Host ""

# ═══════════════════════════════════════════════════════════════
# STEP 5: Virtual Environment Setup  
# ═══════════════════════════════════════════════════════════════
if (Test-Path "$PYTHON_DIR\Scripts\virtualenv.exe") {
    Write-Host "Virtualenv already installed, skipping..." -ForegroundColor Cyan
} else {
    Write-Host "Installing virtualenv package..." -ForegroundColor Yellow
    
    # Install virtualenv using pip
    & ".\$PYTHON_DIR\python.exe" -m pip install virtualenv
    
    Write-Host "Virtualenv installation completed!" -ForegroundColor Green
}
Write-Host ""

# ═══════════════════════════════════════════════════════════════
# STEP 6: Project Repository
# ═══════════════════════════════════════════════════════════════
if (Test-Path "$PROJECT_DIR\.git") {
    Write-Host "Project already cloned, skipping..." -ForegroundColor Cyan
} else {    
    Write-Host "Cloning project repository..." -ForegroundColor Yellow

    # Set up Git environment
    $env:PATH = ".\" + $GIT_DIR + "\bin;" + $env:PATH

    # Clone the project
    & ".\$GIT_DIR\bin\git.exe" clone $PROJECT_REPO $PROJECT_DIR

    Write-Host "Project cloning completed!" -ForegroundColor Green
}
Write-Host ""

# ═══════════════════════════════════════════════════════════════
# STEP 7: Replace workspaceFolder in `.cursor/mcp.json`
# ═══════════════════════════════════════════════════════════════
$workspaceFolder = (Get-Location).Path -replace '\\', '\\'
if (Test-Path "$PROJECT_DIR\.cursor\mcp.json") {
    Write-Host "Replacing '{workspaceFolder}' in '.cursor/mcp.json'..." -ForegroundColor Yellow
    (Get-Content "$PROJECT_DIR\.cursor\mcp.json") -replace "{workspaceFolder}", $workspaceFolder | Set-Content "$PROJECT_DIR\.cursor\mcp.json"
    Write-Host "Replacement completed!" -ForegroundColor Green
} else {
    Write-Host "'.cursor\mcp.json' not found! Skipping replacement." -ForegroundColor Red
}

# ═══════════════════════════════════════════════════════════════
# STEP 8: Project Environment Setup
# ═══════════════════════════════════════════════════════════════
if (Test-Path "$PROJECT_DIR\.virtualenv") {
    Write-Host "Project environment already set up, skipping..." -ForegroundColor Cyan
} else {
    Write-Host "Setting up project environment..." -ForegroundColor Yellow

    # Navigate to project directory and run install.sh
    Push-Location $PROJECT_DIR    # Run install.sh using our portable tools
    $env:PATH = "..\" + $GIT_DIR + "\bin;..\" + $PYTHON_DIR + ";..\" + $PYTHON_DIR + "\Scripts;" + $env:PATH
    & ("..\" + $GIT_DIR + "\bin\bash.exe") "./install.sh"

    # Return to original directory
    Pop-Location

    Write-Host "Project environment setup completed!" -ForegroundColor Green
}
Write-Host ""

# ═══════════════════════════════════════════════════════════════
# STEP 9: VSCode Launcher Creation
# ═══════════════════════════════════════════════════════════════
if (Test-Path "launch-vscode.bat") {
    Write-Host "VSCode launcher already exists, skipping..." -ForegroundColor Cyan
} else {    
    Write-Host "Creating VSCode launcher..." -ForegroundColor Yellow

    $currentDir = (Get-Location).Path -replace '/', '\'
    $launcherContent = @"
@echo off
REM VSCode launcher with portable tools
set PATH=$currentDir\$GIT_DIR\bin;$currentDir\$PYTHON_DIR;$currentDir\$PYTHON_DIR\Scripts;%PATH%
"$currentDir\$VSCODE_DIR\Code.exe" --user-data-dir="$currentDir\$VSCODE_USER_DATA_DIR" "$currentDir\$PROJECT_DIR"
"@
    Set-Content -Path "launch-vscode.bat" -Value $launcherContent

    Write-Host "VSCode launcher created!" -ForegroundColor Green
}
Write-Host ""

# =====================================================================
# INSTALLATION COMPLETED!
# =====================================================================
Write-Host "Setup completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "To start coding, run:" -ForegroundColor Cyan
Write-Host "   .\launch-vscode.bat" -ForegroundColor White
Write-Host ""
Write-Host "Your portable development environment includes:" -ForegroundColor Yellow
Write-Host "   - VSCode with extensions" -ForegroundColor Gray
Write-Host "   - Git version control" -ForegroundColor Gray
Write-Host "   - Python with LangChain" -ForegroundColor Gray
Write-Host "   - Hello-LangChain project" -ForegroundColor Gray
Write-Host ""
Write-Host "Happy coding!" -ForegroundColor Magenta
Write-Host ""

# =====================================================================
# RUNNUNG THE VSCODE LAUNCHER
# =====================================================================

if (Test-Path "launch-vscode.bat") {
    Write-Host "Running VSCode launcher..." -ForegroundColor Yellow
    Start-Process -FilePath ".\launch-vscode.bat"
} else {
    Write-Host "VSCode launcher not found, please run 'launch-vscode.bat' manually." -ForegroundColor Red
}