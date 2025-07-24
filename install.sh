#!/bin/bash

# Load environment variables
source .env

echo "Starting installation process..."

# Create tools directory
mkdir -p tools

# -----------------------------------------------------
# Download and install VSCode
echo "Downloading VSCode..."
if command -v curl &> /dev/null; then
    curl -L -o vscode.zip "$VSCODE_URL"
elif command -v wget &> /dev/null; then
    wget -O vscode.zip "$VSCODE_URL"
else
    echo "Error: Neither curl nor wget found. Please install one of them."
    exit 1
fi

echo "Extracting VSCode to $VSCODE_DIR..."
mkdir -p "$VSCODE_DIR"
if command -v unzip &> /dev/null; then
    unzip -q vscode.zip -d "$VSCODE_DIR"
else
    echo "Error: unzip command not found. Please install unzip."
    exit 1
fi

# Cleanup
rm vscode.zip

echo "VSCode installation completed!"

# -----------------------------------------------------
# Download and install Git
echo "Downloading Portable Git..."
if command -v curl &> /dev/null; then
    curl -L -o git-portable.7z.exe "$GIT_URL"
elif command -v wget &> /dev/null; then
    wget -O git-portable.7z.exe "$GIT_URL"
else
    echo "Error: Neither curl nor wget found. Please install one of them."
    exit 1
fi

echo "Extracting Git to $GIT_DIR..."
mkdir -p "$GIT_DIR"
./git-portable.7z.exe -o"$GIT_DIR" -y

# Cleanup
rm git-portable.7z.exe

echo "Git installation completed!"

# -----------------------------------------------------
# Download and install Python
echo "Downloading Python embeddable..."
if command -v curl &> /dev/null; then
    curl -L -o python-embed.zip "$PYTHON_URL"
elif command -v wget &> /dev/null; then
    wget -O python-embed.zip "$PYTHON_URL"
else
    echo "Error: Neither curl nor wget found. Please install one of them."
    exit 1
fi

echo "Extracting Python to $PYTHON_DIR..."
mkdir -p "$PYTHON_DIR"
if command -v unzip &> /dev/null; then
    unzip -q python-embed.zip -d "$PYTHON_DIR"
else
    echo "Error: unzip command not found. Please install unzip."
    exit 1
fi

# Cleanup
rm python-embed.zip

echo "Python installation completed!"

# -----------------------------------------------------
# Setup pip for embeddable Python
echo "Setting up pip for Python..."

# Download get-pip.py
if command -v curl &> /dev/null; then
    curl -L -o get-pip.py "$GET_PIP_URL"
elif command -v wget &> /dev/null; then
    wget -O get-pip.py "$GET_PIP_URL"
else
    echo "Error: Neither curl nor wget found. Please install one of them."
    exit 1
fi

# Install pip
./"$PYTHON_DIR"/python.exe get-pip.py

# Fix Python paths configuration
pythonPthFile="$PYTHON_DIR/python313._pth"
cat > "$pythonPthFile" << EOF
python313.zip
.
Lib\site-packages
Scripts

# Uncomment to run site.main() automatically
import site
EOF

# Cleanup
rm get-pip.py

echo "Pip setup completed!"

# -----------------------------------------------------
# Clone project repository
echo "Cloning project repository..."

# Clone the project using portable Git
./"$GIT_DIR"/bin/git.exe clone "$PROJECT_REPO" "$PROJECT_DIR"

echo "Project cloning completed!"

# -----------------------------------------------------
# Create VSCode launcher with portable tools
echo "Creating VSCode launcher..."

currentDir=$(pwd | sed 's|^/c/|C:/|' | tr '/' '\\')
cat > launch-vscode.bat << EOF
@echo off
REM VSCode launcher with portable tools
set PATH=$currentDir\\$GIT_DIR\\bin;$currentDir\\$PYTHON_DIR;$currentDir\\$PYTHON_DIR\\Scripts;%PATH%
start "" "$currentDir\\$VSCODE_DIR\\Code.exe" "$currentDir\\$PROJECT_DIR"
EOF

echo "VSCode launcher created!"
echo ""
echo "Setup completed!"
echo "To start coding, run: ./launch-vscode.bat"
