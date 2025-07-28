#!/bin/bash

# Load environment variables from .env file
while IFS='=' read -r key value || [ -n "$key" ]; do
    # Skip comments and empty lines
    if [[ $key =~ ^[[:space:]]*# ]] || [[ -z "$key" ]]; then
        continue
    fi
    # Remove leading/trailing whitespace and export
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs)
    if [[ -n "$key" && -n "$value" ]]; then
        export "$key"="$value"
    fi
done < .env

# Ensure the VSCode user data directory exists
mkdir -p "$VSCODE_USER_DATA_DIR"

# Clear screen for better visibility
clear

# Color definitions for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# Beautiful header
echo -e "${MAGENTA}════════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}PORTABLE DEVELOPMENT ENVIRONMENT INSTALLER (macOS)${NC}"
echo -e "${MAGENTA}════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${WHITE}This installer will set up:${NC}"
echo -e "${GRAY}   - VSCode (Portable)${NC}"
echo -e "${GRAY}   - Git (System)${NC}"
echo -e "${GRAY}   - Python (System/Homebrew)${NC}"
echo -e "${GRAY}   - LangChain Project${NC}"
echo ""
echo -e "${GREEN}Starting macOS installation process...${NC}"
echo ""

# Create tools directory
mkdir -p tools

# ═══════════════════════════════════════════════════════════════
# STEP 1: VSCode Installation
# ═══════════════════════════════════════════════════════════════
if [ -d "$VSCODE_DIR/Visual Studio Code.app" ]; then
    echo -e "${CYAN}VSCode already installed, skipping...${NC}"
else
    echo -e "${YELLOW}Downloading VSCode for macOS...${NC}"
    if command -v curl &> /dev/null; then
        curl -L -o vscode-macos.zip "$VSCODE_URL_MACOS"
    elif command -v wget &> /dev/null; then
        wget -O vscode-macos.zip "$VSCODE_URL_MACOS"
    else
        echo -e "${RED}Error: Neither curl nor wget found. Please install one of them.${NC}"
        exit 1
    fi

    echo -e "${YELLOW}Extracting VSCode to $VSCODE_DIR...${NC}"
    mkdir -p "$VSCODE_DIR"
    if command -v unzip &> /dev/null; then
        unzip -q vscode-macos.zip -d "$VSCODE_DIR"
    else
        echo -e "${RED}Error: unzip command not found. Please install unzip.${NC}"
        exit 1
    fi

    # Cleanup
    rm vscode-macos.zip

    echo -e "${GREEN}VSCode installation completed!${NC}"
fi
echo ""

# ═══════════════════════════════════════════════════════════════
# STEP 2: Git Setup (System Git)
# ═══════════════════════════════════════════════════════════════
if command -v git &> /dev/null; then
    echo -e "${CYAN}Git found in system, using system Git...${NC}"
    GIT_EXECUTABLE=$(which git)
    echo -e "${GRAY}Git location: $GIT_EXECUTABLE${NC}"
else
    echo -e "${YELLOW}Git not found. Installing Git...${NC}"
    
    # Check if Homebrew is available
    if command -v brew &> /dev/null; then
        echo -e "${YELLOW}Installing Git via Homebrew...${NC}"
        brew install git
        GIT_EXECUTABLE=$(which git)
    # Check if MacPorts is available
    elif command -v port &> /dev/null; then
        echo -e "${YELLOW}Installing Git via MacPorts...${NC}"
        sudo port install git
        GIT_EXECUTABLE=$(which git)
    else
        echo -e "${RED}Error: Git not found and no package manager available.${NC}"
        echo -e "${RED}Please install Git manually from https://git-scm.com/download/mac${NC}"
        echo -e "${RED}Or install Homebrew first: https://brew.sh${NC}"
        exit 1
    fi
    
    if command -v git &> /dev/null; then
        echo -e "${GREEN}Git installation completed!${NC}"
    else
        echo -e "${RED}Git installation failed!${NC}"
        exit 1
    fi
fi
echo ""

# ═══════════════════════════════════════════════════════════════
# STEP 3: Python Setup
# ═══════════════════════════════════════════════════════════════
if command -v python3 &> /dev/null; then
    echo -e "${CYAN}Python3 found in system, using system Python...${NC}"
    PYTHON_EXECUTABLE=$(which python3)
    echo -e "${GRAY}Python location: $PYTHON_EXECUTABLE${NC}"
    
    # Check Python version
    PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
    echo -e "${GRAY}Python version: $PYTHON_VERSION${NC}"
else
    echo -e "${YELLOW}Python3 not found. Installing Python...${NC}"
    
    # Check if Homebrew is available
    if command -v brew &> /dev/null; then
        echo -e "${YELLOW}Installing Python via Homebrew...${NC}"
        brew install python
        PYTHON_EXECUTABLE=$(which python3)
    # Check if MacPorts is available
    elif command -v port &> /dev/null; then
        echo -e "${YELLOW}Installing Python via MacPorts...${NC}"
        sudo port install python312
        PYTHON_EXECUTABLE=$(which python3.12)
    else
        echo -e "${RED}Error: Python not found and no package manager available.${NC}"
        echo -e "${RED}Please install Python manually from https://www.python.org/downloads/mac-osx/${NC}"
        echo -e "${RED}Or install Homebrew first: https://brew.sh${NC}"
        exit 1
    fi
    
    if command -v python3 &> /dev/null; then
        echo -e "${GREEN}Python installation completed!${NC}"
    else
        echo -e "${RED}Python installation failed!${NC}"
        exit 1
    fi
fi
echo ""

# ═══════════════════════════════════════════════════════════════
# STEP 4: Pip Setup
# ═══════════════════════════════════════════════════════════════
if command -v pip3 &> /dev/null; then
    echo -e "${CYAN}Pip3 already available, skipping...${NC}"
else
    echo -e "${YELLOW}Setting up pip for Python...${NC}"

    # Download get-pip.py
    if command -v curl &> /dev/null; then
        curl -L -o get-pip.py "$GET_PIP_URL"
    elif command -v wget &> /dev/null; then
        wget -O get-pip.py "$GET_PIP_URL"
    else
        echo -e "${RED}Error: Neither curl nor wget found. Please install one of them.${NC}"
        exit 1
    fi

    # Install pip
    python3 get-pip.py --user

    # Cleanup
    rm get-pip.py

    echo -e "${GREEN}Pip setup completed!${NC}"
fi
echo ""

# ═══════════════════════════════════════════════════════════════
# STEP 5: Virtual Environment Setup
# ═══════════════════════════════════════════════════════════════
if python3 -m venv --help &> /dev/null; then
    echo -e "${CYAN}Virtual environment support available...${NC}"
else
    echo -e "${YELLOW}Installing virtualenv package...${NC}"
    
    # Install virtualenv using pip
    python3 -m pip install --user virtualenv
    
    echo -e "${GREEN}Virtualenv installation completed!${NC}"
fi
echo ""

# ═══════════════════════════════════════════════════════════════
# STEP 6: Project Repository
# ═══════════════════════════════════════════════════════════════
if [ -d "$PROJECT_DIR/.git" ]; then
    echo -e "${CYAN}Project already cloned, skipping...${NC}"
else
    echo -e "${YELLOW}Cloning project repository...${NC}"

    # Clone the project using system Git
    git clone "$PROJECT_REPO" "$PROJECT_DIR"

    echo -e "${GREEN}Project cloning completed!${NC}"
fi
echo ""

# ═══════════════════════════════════════════════════════════════
# STEP 7: Replace workspaceFolder in `.cursor/mcp.json`
# ═══════════════════════════════════════════════════════════════
workspace_folder=$(pwd)
if [ -f "$PROJECT_DIR/.cursor/mcp.json" ]; then
    echo -e "${YELLOW}Replacing '{workspaceFolder}' in .cursor/mcp.json...${NC}"
    sed -i '' "s|{workspaceFolder}|$workspace_folder|g" "$PROJECT_DIR/.cursor/mcp.json"
    echo -e "${GREEN}Replacement completed!${NC}"
else
    echo -e "${RED}.cursor/mcp.json not found! Skipping replacement.${NC}"
fi

# ═══════════════════════════════════════════════════════════════
# STEP 8: Project Environment Setup
# ═══════════════════════════════════════════════════════════════
if [ -d "$PROJECT_DIR/.virtualenv" ]; then
    echo -e "${CYAN}Project environment already set up, skipping...${NC}"
else
    echo -e "${YELLOW}Setting up project environment...${NC}"

    # Navigate to project directory and run install.sh
    cd "$PROJECT_DIR"

    # Run install.sh using bash
    bash ./install.sh

    # Return to original directory
    cd ..

    echo -e "${GREEN}Project environment setup completed!${NC}"
fi
echo ""

# ═══════════════════════════════════════════════════════════════
# STEP 9: macOS VSCode Launcher Creation
# ═══════════════════════════════════════════════════════════════
if [ -f "launch-vscode-macos.sh" ]; then
    echo -e "${CYAN}macOS VSCode launcher already exists, skipping...${NC}"
else
    echo -e "${YELLOW}Creating macOS VSCode launcher...${NC}"

    currentDir=$(pwd)
    # Create macOS launcher script
    cat > launch-vscode-macos.sh << EOF
#!/bin/bash
# VSCode launcher for macOS with portable tools
export PATH="$currentDir/tools/git/bin:$currentDir/tools/python:$PATH"

# Launch VSCode app bundle
open "$currentDir/$VSCODE_DIR/Visual Studio Code.app" --args --user-data-dir="$currentDir/$VSCODE_USER_DATA_DIR" "$currentDir/$PROJECT_DIR"
EOF

    chmod +x launch-vscode-macos.sh

    echo -e "${GREEN}macOS VSCode launcher created!${NC}"
fi
echo ""

# ════════════════════════════════════════════════════════════════
# INSTALLATION COMPLETED!
# ════════════════════════════════════════════════════════════════
echo -e "${GREEN}macOS setup completed successfully!${NC}"
echo ""
echo -e "${CYAN}To start coding, run:${NC}"
echo -e "${WHITE}   ./launch-vscode-macos.sh${NC}"
echo ""
echo -e "${YELLOW}Your portable development environment includes:${NC}"
echo -e "${GRAY}   - VSCode with extensions${NC}"
echo -e "${GRAY}   - Git version control${NC}"
echo -e "${GRAY}   - Python with LangChain${NC}"
echo -e "${GRAY}   - Hello-LangChain project${NC}"
echo ""
echo -e "${MAGENTA}Happy coding on macOS!${NC}"
echo ""

# ════════════════════════════════════════════════════════════════
# Running the VSCode launcher
# ════════════════════════════════════════════════════════════════
if [ -f "launch-vscode-macos.sh" ]; then
    echo -e "${CYAN}VSCode launcher found, running...${NC}"
    ./launch-vscode-macos.sh
else
    echo -e "${RED}VSCode launcher not found! Please ensure the launcher is created.${NC}"
fi 