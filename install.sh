#!/bin/bash

# Load environment variables
source .env

echo "Starting installation process..."

# Create tools directory
mkdir -p tools

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
