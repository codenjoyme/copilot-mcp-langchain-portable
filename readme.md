# Hello LangChain Portable Environment

This project sets up a portable development environment for LangChain using Python, Git, and VSCode. It includes scripts for installation and configuration.

## Installation Instructions

### Using Bash
Run the following command in your Bash shell to download, extract, and set up the project:
```bash
bash -c 'work="workspace"; url="https://github.com/codenjoyme/copilot-mcp-langchain-portable/archive/refs/heads/main.zip"; mkdir -p "$work"; curl -L -o "$work/project.zip" "$url"; unzip -q "$work/project.zip" -d "$work/tmp"; mv "$work/tmp/copilot-mcp-langchain-portable-main/"{*,.*} "$work"; rm -rf "$work/tmp" "$work/project.zip"; cd "$work"; chmod +x install.sh; ./install.sh'
```

### Using PowerShell
Run the following command in your PowerShell terminal to achieve the same setup:
```powershell
$work = "workspace"; $url = "https://github.com/codenjoyme/copilot-mcp-langchain-portable/archive/refs/heads/main.zip"; New-Item -ItemType Directory -Force -Path $work; Invoke-WebRequest -Uri $url -OutFile "$work\project.zip"; Expand-Archive -Path "$work\project.zip" -DestinationPath "$work\tmp"; Remove-Item "$work\project.zip"; Move-Item "$work\tmp\copilot-mcp-langchain-portable-main\*" "$work"; Move-Item "$work\tmp\copilot-mcp-langchain-portable-main\.*" "$work" -Force; Remove-Item "$work\tmp" -Recurse; Set-Location "$work"; .\install.ps1
```

## Project Structure
- `install.ps1`: PowerShell script for installation.
- `install.sh`: Bash script for installation.
- `pull.sh`: Bash script for downloading and setting up the project.
- `readme.md`: Documentation for the project.

## Notes
- Ensure you have the required tools installed (e.g., `curl`, `unzip`, `PowerShell`).
- Replace `workspace` with your desired folder name for the project setup.
- For Batch, ensure you run the script with administrative privileges if required.