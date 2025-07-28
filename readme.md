# Hello LangChain Portable Environment

This project sets up a portable development environment for LangChain using Python, Git, and VSCode. It includes scripts for installation and configuration across multiple platforms.

## Platform-Specific Installation Instructions

### macOS Installation

Run the following command in your Terminal to download, extract, and set up the project:
```bash
bash -c 'work="workspace"; url="https://github.com/agzyamov/copilot-mcp-langchain-portable/archive/refs/heads/main.zip"; mkdir -p "$work"; curl -L -o "$work/project.zip" "$url"; unzip -q "$work/project.zip" -d "$work/tmp"; mv "$work/tmp/copilot-mcp-langchain-portable-main/"{*,.*} "$work"; rm -rf "$work/tmp" "$work/project.zip"; cd "$work"; chmod +x install-macos.sh; ./install-macos.sh'
```

Or manually:
1. Clone or download this repository
2. Navigate to the project directory
3. Run: `chmod +x install-macos.sh && ./install-macos.sh`

### Windows Installation

Run the following command in your PowerShell terminal:
```powershell
$work = "workspace"; $url = "https://github.com/agzyamov/copilot-mcp-langchain-portable/archive/refs/heads/main.zip"; New-Item -ItemType Directory -Force -Path $work; Invoke-WebRequest -Uri $url -OutFile "$work\project.zip"; Expand-Archive -Path "$work\project.zip" -DestinationPath "$work\tmp"; Remove-Item "$work\project.zip"; Move-Item "$work\tmp\copilot-mcp-langchain-portable-main\*" "$work"; Move-Item "$work\tmp\copilot-mcp-langchain-portable-main\.*" "$work" -Force; Remove-Item "$work\tmp" -Recurse; Set-Location "$work"; .\install.ps1
```

### Linux/Unix Installation

Run the following command in your Bash shell:
```bash
bash -c 'work="workspace"; url="https://github.com/agzyamov/copilot-mcp-langchain-portable/archive/refs/heads/main.zip"; mkdir -p "$work"; curl -L -o "$work/project.zip" "$url"; unzip -q "$work/project.zip" -d "$work/tmp"; mv "$work/tmp/copilot-mcp-langchain-portable-main/"{*,.*} "$work"; rm -rf "$work/tmp" "$work/project.zip"; cd "$work"; chmod +x install.sh; ./install.sh'
```

Or manually:
1. Clone or download this repository  
2. Navigate to the project directory
3. Run: `chmod +x install.sh && ./install.sh`

## Project Structure

### Installation Scripts
- `install-macos.sh`: macOS-specific installation script
- `install.ps1`: PowerShell script for Windows installation
- `install.sh`: Bash script for Linux/Unix installation

### Launcher Scripts (created during installation)
- `launch-vscode-macos.sh`: macOS VSCode launcher
- `launch-vscode.bat`: Windows VSCode launcher
- `launch-vscode-linux.sh`: Linux/Unix VSCode launcher

### Configuration
- `.env`: Environment variables for all platforms
- `readme.md`: This documentation file

## Platform-Specific Features

### macOS
- Uses system Git (installed via Homebrew if needed)
- Uses system Python3 (installed via Homebrew if needed)
- VSCode installed as app bundle
- Supports both Intel and Apple Silicon Macs

### Windows
- Portable Git installation
- Embedded Python installation
- Portable VSCode installation
- Self-contained environment

### Linux/Unix
- Uses system package managers (apt, dnf, pacman, zypper)
- System Git and Python installation
- VSCode installation via package manager or manual download
- Supports major Linux distributions

## Prerequisites

### macOS
- macOS 11.0 or later
- Command line tools (automatically installed)
- Optional: Homebrew for easier package management

### Windows
- Windows 10 or later
- PowerShell 5.1 or later
- Internet connection for downloads

### Linux/Unix
- Modern Linux distribution
- Package manager (apt, dnf, pacman, or zypper)
- curl or wget
- unzip utility

## Notes

- Each platform uses its own optimized installation approach
- All platforms create isolated development environments
- VSCode user data is stored in a portable location
- Git and Python configurations are preserved across sessions
- The environment is self-contained and doesn't interfere with system installations

## Starting Your Development Environment

After installation, start coding with the platform-specific launcher:

- **macOS**: `./launch-vscode-macos.sh`
- **Windows**: `.\launch-vscode.bat`
- **Linux/Unix**: `./launch-vscode-linux.sh`