#!/bin/bash

# ============================================================
# Ghost Theme Setup — One Script, Everything You Need
# ============================================================
# Run this by pasting the following into Terminal:
#
#   curl -fsSL https://raw.githubusercontent.com/whale/ghost-theme-luis/main/setup.sh | bash
#
# What it does (in order):
#   1. Installs Homebrew (a tool that installs other tools)
#   2. Installs git, GitHub CLI, Node.js
#   3. Installs Ghostty (your terminal app)
#   4. Installs Claude Code (your AI coding partner)
#   5. Connects you to GitHub (opens your browser)
#   6. Downloads your project
#   7. Downloads 20+ reference themes for Claude to study
# ============================================================

# Colors for readable output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

step() {
    echo ""
    echo -e "${GREEN}${BOLD}▸ $1${NC}"
    echo ""
}

info() {
    echo -e "${BLUE}  ℹ $1${NC}"
}

warn() {
    echo -e "${YELLOW}  ⚠ $1${NC}"
}

done_msg() {
    echo -e "${GREEN}  ✓ $1${NC}"
}

error_msg() {
    echo -e "${RED}  ✗ $1${NC}"
}

# ============================================================
# Step 1: Homebrew
# ============================================================
step "Step 1 of 7: Installing Homebrew"
info "Homebrew is like an app store for developer tools."
info "This step may ask for your Mac password and take a few minutes."

if command -v brew &> /dev/null; then
    done_msg "Homebrew is already installed. Skipping."
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    done_msg "Homebrew installed."
fi

# Make sure Homebrew is on PATH for this session
# (Apple Silicon Macs put it in /opt/homebrew, Intel Macs use /usr/local)
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    # Also add to shell profile so it persists after restart
    if ! grep -q 'brew shellenv' ~/.zprofile 2>/dev/null; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    fi
elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# ============================================================
# Step 2: Git, GitHub CLI, Node.js
# ============================================================
step "Step 2 of 7: Installing developer tools"

if command -v git &> /dev/null; then
    done_msg "Git already installed."
else
    info "Installing git (your save-point system)..."
    brew install git
    done_msg "Git installed."
fi

if command -v gh &> /dev/null; then
    done_msg "GitHub CLI already installed."
else
    info "Installing GitHub CLI (connects you to GitHub)..."
    brew install gh
    done_msg "GitHub CLI installed."
fi

if command -v node &> /dev/null; then
    done_msg "Node.js already installed."
else
    info "Installing Node.js (Ghost themes need this behind the scenes)..."
    brew install node
    done_msg "Node.js installed."
fi

# ============================================================
# Step 3: Ghostty (terminal app)
# ============================================================
step "Step 3 of 7: Installing Ghostty (your terminal app)"
info "Ghostty is a fast, clean terminal app."
info "After setup, you'll use Ghostty instead of this Terminal window."

if [[ -d "/Applications/Ghostty.app" ]] || command -v ghostty &> /dev/null; then
    done_msg "Ghostty is already installed. Skipping."
else
    brew install --cask ghostty
    done_msg "Ghostty installed. You'll find it in your Applications folder."
fi

# ============================================================
# Step 4: Claude Code
# ============================================================
step "Step 4 of 7: Installing Claude Code (your AI coding partner)"
info "Claude Code is the AI that helps you build your theme."
info "You talk to it in plain English, it writes the code."

if command -v claude &> /dev/null; then
    done_msg "Claude Code is already installed."
else
    curl -fsSL https://claude.ai/install.sh | bash

    # Make sure claude is on PATH for the rest of this script
    export PATH="$HOME/.local/bin:$PATH"

    if command -v claude &> /dev/null; then
        done_msg "Claude Code installed."
    else
        warn "Claude Code installed but may need a terminal restart to be found."
        warn "If 'claude' doesn't work later, close and reopen Ghostty."
    fi
fi

# ============================================================
# Step 5: Connect to GitHub
# ============================================================
step "Step 5 of 7: Connecting to GitHub"

if gh auth status &> /dev/null; then
    done_msg "Already logged into GitHub."
else
    info "This will open your web browser to log you into GitHub."
    info ""
    info "When it asks you questions, choose:"
    info "  • GitHub.com"
    info "  • HTTPS"
    info "  • Login with a web browser"
    info ""
    info "It will show you a code. Paste that code in your browser and click Authorize."
    echo ""

    gh auth login

    if gh auth status &> /dev/null; then
        done_msg "Connected to GitHub."
    else
        error_msg "GitHub login didn't complete. You can retry later by typing: gh auth login"
    fi
fi

# ============================================================
# Step 6: Download the project
# ============================================================
step "Step 6 of 7: Downloading your project"

PROJECT_DIR="$HOME/ghost-theme-luis"

if [ -d "$PROJECT_DIR/.git" ]; then
    done_msg "Project already downloaded at $PROJECT_DIR"
else
    info "Downloading the project from GitHub..."
    git clone https://github.com/whale/ghost-theme-luis.git "$PROJECT_DIR"
    done_msg "Project downloaded to $PROJECT_DIR"
fi

# ============================================================
# Step 7: Download reference themes
# ============================================================
step "Step 7 of 7: Downloading Ghost reference themes"
info "Downloading 20+ professional Ghost themes."
info "Claude studies these to understand best practices."
info "You don't need to open or read them yourself."

REFERENCE_DIR="$PROJECT_DIR/reference"
mkdir -p "$REFERENCE_DIR"

# Official Ghost themes monorepo (all themes in one download)
if [ ! -d "$REFERENCE_DIR/source" ] || [ ! -d "$REFERENCE_DIR/dawn" ]; then
    info "Downloading official Ghost themes (this may take a minute)..."
    TEMP_DIR=$(mktemp -d)
    if git clone --depth 1 https://github.com/TryGhost/Themes.git "$TEMP_DIR" 2>/dev/null; then
        if [ -d "$TEMP_DIR/packages" ]; then
            for theme_dir in "$TEMP_DIR/packages"/*/; do
                theme_name=$(basename "$theme_dir")
                if [ ! -d "$REFERENCE_DIR/$theme_name" ]; then
                    cp -r "$theme_dir" "$REFERENCE_DIR/$theme_name"
                fi
            done
        fi
        done_msg "Official themes downloaded."
    else
        warn "Could not download official themes. You can retry by running this script again."
    fi
    rm -rf "$TEMP_DIR"
else
    done_msg "Official themes already present."
fi

# Casper (classic default theme — separate repo)
if [ ! -d "$REFERENCE_DIR/casper" ]; then
    info "Downloading Casper theme..."
    if git clone --depth 1 https://github.com/TryGhost/Casper.git "$REFERENCE_DIR/casper" 2>/dev/null; then
        rm -rf "$REFERENCE_DIR/casper/.git"
        done_msg "Casper downloaded."
    else
        warn "Could not download Casper. Non-critical — skipping."
    fi
else
    done_msg "Casper already present."
fi

# Source (current default theme — separate repo)
if [ ! -d "$REFERENCE_DIR/source" ]; then
    info "Downloading Source theme..."
    if git clone --depth 1 https://github.com/TryGhost/Source.git "$REFERENCE_DIR/source" 2>/dev/null; then
        rm -rf "$REFERENCE_DIR/source/.git"
        done_msg "Source downloaded."
    else
        warn "Could not download Source. Non-critical — skipping."
    fi
else
    done_msg "Source already present."
fi

# Top community themes
if [ ! -d "$REFERENCE_DIR/liebling" ]; then
    info "Downloading Liebling theme..."
    if git clone --depth 1 https://github.com/eddiesigner/liebling.git "$REFERENCE_DIR/liebling" 2>/dev/null; then
        rm -rf "$REFERENCE_DIR/liebling/.git"
        done_msg "Liebling downloaded."
    else
        warn "Could not download Liebling. Non-critical — skipping."
    fi
else
    done_msg "Liebling already present."
fi

if [ ! -d "$REFERENCE_DIR/simply" ]; then
    info "Downloading Simply theme..."
    if git clone --depth 1 https://github.com/godofredoninja/simply.git "$REFERENCE_DIR/simply" 2>/dev/null; then
        rm -rf "$REFERENCE_DIR/simply/.git"
        done_msg "Simply downloaded."
    else
        warn "Could not download Simply. Non-critical — skipping."
    fi
else
    done_msg "Simply already present."
fi

# ============================================================
# Done!
# ============================================================
echo ""
echo ""
echo -e "${GREEN}${BOLD}  ════════════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}   Setup complete! Everything is installed.${NC}"
echo -e "${GREEN}${BOLD}  ════════════════════════════════════════════${NC}"
echo ""
echo "  You can close this Terminal window now."
echo ""
echo -e "  ${BOLD}To start working on your theme:${NC}"
echo ""
echo "  1. Open ${BOLD}Ghostty${NC} (press Cmd+Space, type Ghostty, press Enter)"
echo ""
echo "  2. Type this and press Enter:"
echo -e "     ${BLUE}cd ~/ghost-theme-luis && claude${NC}"
echo ""
echo "  3. First time: Claude opens your browser to log in."
echo "     Use the Claude account you created earlier."
echo ""
echo "  4. Once Claude is running, try saying:"
echo "     \"What files are in my project? Give me a quick overview.\""
echo ""
echo "  ─────────────────────────────────────────────────"
echo ""
echo "  ${BOLD}Cheat sheet — things to say to Claude:${NC}"
echo "    • \"Save my progress\"         → Creates a save point"
echo "    • \"Undo that\"                → Reverses the last change"
echo "    • \"It was working before\"    → Go back to a working version"
echo "    • \"Package my theme\"         → Creates a .zip to upload to Ghost"
echo "    • \"Push my changes\"          → Sends your work to GitHub"
echo ""
