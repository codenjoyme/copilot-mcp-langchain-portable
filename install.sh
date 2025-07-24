#!/bin/bash

# Load environment variables
source .env

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
echo -e "${CYAN}PORTABLE DEVELOPMENT ENVIRONMENT INSTALLER${NC}"
echo -e "${MAGENTA}════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${WHITE}This installer will set up:${NC}"
echo -e "${GRAY}   - VSCode (Portable)${NC}"
echo -e "${GRAY}   - Git (Portable)${NC}"
echo -e "${GRAY}   - Python (Embeddable)${NC}"
echo -e "${GRAY}   - LangChain Project${NC}"
echo ""
echo -e "${GREEN}Starting installation process...${NC}"
echo ""

# Create tools directory
mkdir -p tools

# ═══════════════════════════════════════════════════════════════
# STEP 1: VSCode Installation
# ═══════════════════════════════════════════════════════════════
if [ -f "$VSCODE_DIR/Code.exe" ]; then
    echo -e "${CYAN}VSCode already installed, skipping...${NC}"
else
    echo -e "${YELLOW}Downloading VSCode...${NC}"
    if command -v curl &> /dev/null; then
        curl -L -o vscode.zip "$VSCODE_URL"
    elif command -v wget &> /dev/null; then
        wget -O vscode.zip "$VSCODE_URL"
    else
        echo -e "${RED}Error: Neither curl nor wget found. Please install one of them.${NC}"
        exit 1
    fi

    echo -e "${YELLOW}Extracting VSCode to $VSCODE_DIR...${NC}"
    mkdir -p "$VSCODE_DIR"
    if command -v unzip &> /dev/null; then
        unzip -q vscode.zip -d "$VSCODE_DIR"
    else
        echo -e "${RED}Error: unzip command not found. Please install unzip.${NC}"
        exit 1
    fi

    # Cleanup
    rm vscode.zip

    echo -e "${GREEN}VSCode installation completed!${NC}"
fi
echo ""

# ═══════════════════════════════════════════════════════════════
# STEP 2: Git Installation
# ═══════════════════════════════════════════════════════════════
if [ -f "$GIT_DIR/bin/git.exe" ]; then
    echo -e "${CYAN}Git already installed, skipping...${NC}"
else
    echo -e "${YELLOW}Downloading Portable Git...${NC}"
    if command -v curl &> /dev/null; then
        curl -L -o git-portable.7z.exe "$GIT_URL"
    elif command -v wget &> /dev/null; then
        wget -O git-portable.7z.exe "$GIT_URL"
    else
        echo -e "${RED}Error: Neither curl nor wget found. Please install one of them.${NC}"
        exit 1
    fi

    echo -e "${YELLOW}Extracting Git to $GIT_DIR...${NC}"
    mkdir -p "$GIT_DIR"
    ./git-portable.7z.exe -o"$GIT_DIR" -y

    # Cleanup
    rm git-portable.7z.exe

    echo -e "${GREEN}Git installation completed!${NC}"
fi
echo ""

# ═══════════════════════════════════════════════════════════════
# STEP 3: Python Installation
# ═══════════════════════════════════════════════════════════════
if [ -f "$PYTHON_DIR/python.exe" ]; then
    echo -e "${CYAN}Python already installed, skipping...${NC}"
else
    echo -e "${YELLOW}Downloading Python embeddable...${NC}"
    if command -v curl &> /dev/null; then
        curl -L -o python-embed.zip "$PYTHON_URL"
    elif command -v wget &> /dev/null; then
        wget -O python-embed.zip "$PYTHON_URL"
    else
        echo -e "${RED}Error: Neither curl nor wget found. Please install one of them.${NC}"
        exit 1
    fi

    echo -e "${YELLOW}Extracting Python to $PYTHON_DIR...${NC}"
    mkdir -p "$PYTHON_DIR"
    if command -v unzip &> /dev/null; then
        unzip -q python-embed.zip -d "$PYTHON_DIR"
    else
        echo -e "${RED}Error: unzip command not found. Please install unzip.${NC}"
        exit 1
    fi

    # Cleanup
    rm python-embed.zip

    echo -e "${GREEN}Python installation completed!${NC}"
fi
echo ""

# ═══════════════════════════════════════════════════════════════
# STEP 4: Pip Setup
# ═══════════════════════════════════════════════════════════════
if [ -f "$PYTHON_DIR/Scripts/pip.exe" ]; then
    echo -e "${CYAN}Pip already installed, skipping...${NC}"
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

    echo -e "${GREEN}Pip setup completed!${NC}"
fi
echo ""

# ═══════════════════════════════════════════════════════════════
# STEP 5: Virtual Environment Setup
# ═══════════════════════════════════════════════════════════════
if [ -f "$PYTHON_DIR/Scripts/virtualenv.exe" ]; then
    echo -e "${CYAN}Virtualenv already installed, skipping...${NC}"
else
    echo -e "${YELLOW}Installing virtualenv package...${NC}"
    
    # Install virtualenv using pip
    ./"$PYTHON_DIR"/python.exe -m pip install virtualenv
    
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

    # Clone the project using portable Git
    ./"$GIT_DIR"/bin/git.exe clone "$PROJECT_REPO" "$PROJECT_DIR"

    echo -e "${GREEN}Project cloning completed!${NC}"
fi
echo ""

# ═══════════════════════════════════════════════════════════════
# STEP 7: Replace workspaceFolder in `.cursor/mcp.json`
# ═══════════════════════════════════════════════════════════════
workspace_folder=$(pwd | sed 's|\\|/|g')
if [ -f "$PROJECT_DIR/.cursor/mcp.json" ]; then
    echo -e "${YELLOW}Replacing '{workspaceFolder}' in .cursor/mcp.json...${NC}"
    sed -i "s|{workspaceFolder}|$workspace_folder|g" "$PROJECT_DIR/.cursor/mcp.json"
    sed -i "s|\\\\\\\\|/|g" "$PROJECT_DIR/.cursor/mcp.json"
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

    # Set up environment with our portable tools
    export PATH="../$GIT_DIR/bin:../$PYTHON_DIR:../$PYTHON_DIR/Scripts:$PATH"

    # Run install.sh using bash
    bash ./install.sh

    # Return to original directory
    cd ..

    echo -e "${GREEN}Project environment setup completed!${NC}"
fi
echo ""

# ═══════════════════════════════════════════════════════════════
# STEP 9: VSCode Launcher Creation
# ═══════════════════════════════════════════════════════════════
if [ -f "launch-vscode.sh" ]; then
    echo -e "${CYAN}VSCode launcher already exists, skipping...${NC}"
else
    echo -e "${YELLOW}Creating VSCode launcher...${NC}"

    currentDir=$(pwd | sed 's|^/c/|C:/|' | tr '/' '\\')
    # Replace Windows launcher with Bash launcher
    cat > launch-vscode.sh << EOF
#!/bin/bash
# VSCode launcher with portable tools
export PATH="$currentDir/$GIT_DIR/bin:$currentDir/$PYTHON_DIR:$currentDir/$PYTHON_DIR/Scripts:$PATH"
"$currentDir/$VSCODE_DIR/Code.exe" "$currentDir/$PROJECT_DIR"
EOF

    chmod +x launch-vscode.sh

    echo -e "${GREEN}VSCode Bash launcher created!${NC}"
fi
echo ""

# ════════════════════════════════════════════════════════════════
# INSTALLATION COMPLETED!
# ════════════════════════════════════════════════════════════════
echo -e "${GREEN}Setup completed successfully!${NC}"
echo ""
echo -e "${CYAN}To start coding, run:${NC}"
echo -e "${WHITE}   ./launch-vscode.sh${NC}"
echo ""
echo -e "${YELLOW}Your portable development environment includes:${NC}"
echo -e "${GRAY}   - VSCode with extensions${NC}"
echo -e "${GRAY}   - Git version control${NC}"
echo -e "${GRAY}   - Python with LangChain${NC}"
echo -e "${GRAY}   - Hello-LangChain project${NC}"
echo ""
echo -e "${MAGENTA}Happy coding!${NC}"
echo ""

# ════════════════════════════════════════════════════════════════
# Running the VSCode launcher
# ════════════════════════════════════════════════════════════════
if [ -f "launch-vscode.sh" ]; then
    echo -e "${CYAN}VSCode launcher found, running...${NC}"
    ./launch-vscode.sh
else
    echo -e "${RED}VSCode launcher not found! Please ensure the launcher is created.${NC}"
fi