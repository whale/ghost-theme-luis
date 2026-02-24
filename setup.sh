#!/bin/bash

# ============================================================
# Ghost Theme Development Setup for Luis
# ============================================================
# This script installs everything you need to build a Ghost
# theme using Claude Code. Run it once, then you're set.
#
# What it installs:
#   - Homebrew (Mac's package manager — like an app store for developer tools)
#   - git (version control — your "save points" system)
#   - gh (GitHub's command line tool — connects you to GitHub)
#   - Node.js (JavaScript runtime — Ghost themes need it)
#   - Claude Code (your AI coding partner)
#
# What it downloads:
#   - 20+ official Ghost themes as reference material
#   - Top community Ghost themes
#
# How to run this script:
#   1. Open Terminal (press Cmd+Space, type "Terminal", press Enter)
#   2. Copy and paste this command, then press Enter:
#      bash ~/Downloads/setup.sh
#   (Assumes you saved this file to your Downloads folder)
# ============================================================

set -e  # Stop if anything goes wrong

# Colors for readable output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No color

step() {
    echo ""
    echo -e "${GREEN}▸ $1${NC}"
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

# ============================================================
# Step 1: Homebrew
# ============================================================
step "Step 1 of 7: Installing Homebrew (Mac's package manager)"
info "Homebrew lets you install developer tools with simple commands."
info "Think of it as an app store that runs in the terminal."

if command -v brew &> /dev/null; then
    done_msg "Homebrew is already installed. Skipping."
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    done_msg "Homebrew installed."
fi

# ============================================================
# Step 2: Git
# ============================================================
step "Step 2 of 7: Installing git (version control)"
info "Git is your safety net. It creates 'save points' for your work."
info "You can always go back to any save point if something breaks."

if command -v git &> /dev/null; then
    done_msg "Git is already installed ($(git --version))."
else
    brew install git
    done_msg "Git installed."
fi

# ============================================================
# Step 3: GitHub CLI
# ============================================================
step "Step 3 of 7: Installing GitHub CLI (connects you to GitHub)"
info "GitHub is where your code lives online. It's like Dropbox for code,"
info "but with version history and collaboration built in."

if command -v gh &> /dev/null; then
    done_msg "GitHub CLI is already installed."
else
    brew install gh
    done_msg "GitHub CLI installed."
fi

# ============================================================
# Step 4: Node.js
# ============================================================
step "Step 4 of 7: Installing Node.js (JavaScript runtime)"
info "Ghost themes use JavaScript tools behind the scenes."
info "Node.js makes those tools work. You won't interact with it directly."

if command -v node &> /dev/null; then
    done_msg "Node.js is already installed ($(node --version))."
else
    brew install node
    done_msg "Node.js installed."
fi

# ============================================================
# Step 5: Claude Code
# ============================================================
step "Step 5 of 7: Installing Claude Code (your AI coding partner)"
info "Claude Code is the AI that will help you build your theme."
info "You'll talk to it in plain English, and it writes the code."

if command -v claude &> /dev/null; then
    done_msg "Claude Code is already installed."
else
    curl -fsSL https://claude.ai/install.sh | bash

    # Source the updated profile so 'claude' is available
    if [ -f ~/.zshrc ]; then
        source ~/.zshrc 2>/dev/null || true
    fi

    done_msg "Claude Code installed."
fi

# ============================================================
# Step 6: Download reference themes
# ============================================================
step "Step 6 of 7: Downloading Ghost reference themes"
info "These are 20+ professionally built Ghost themes."
info "Claude will study them to understand best practices"
info "when building your theme. You don't need to read them yourself."

PROJECT_DIR="$HOME/ghost-theme-luis"

if [ ! -d "$PROJECT_DIR" ]; then
    warn "Project folder not found at $PROJECT_DIR."
    warn "Clone the repo first (Step 7), then re-run this section."
else
    REFERENCE_DIR="$PROJECT_DIR/reference"
    mkdir -p "$REFERENCE_DIR"

    # Clone the official Ghost themes monorepo (all 20 themes in one download)
    if [ ! -d "$REFERENCE_DIR/.ghost-themes-repo" ]; then
        info "Downloading all 20 official Ghost themes..."
        git clone --depth 1 https://github.com/TryGhost/Themes.git "$REFERENCE_DIR/.ghost-themes-repo" 2>/dev/null

        # Move each theme package to its own folder
        if [ -d "$REFERENCE_DIR/.ghost-themes-repo/packages" ]; then
            for theme_dir in "$REFERENCE_DIR/.ghost-themes-repo/packages"/*/; do
                theme_name=$(basename "$theme_dir")
                if [ ! -d "$REFERENCE_DIR/$theme_name" ]; then
                    cp -r "$theme_dir" "$REFERENCE_DIR/$theme_name"
                fi
            done
        fi

        done_msg "Official themes downloaded."
    else
        done_msg "Official themes already present."
    fi

    # Clone Casper separately (it's not in the monorepo)
    if [ ! -d "$REFERENCE_DIR/casper" ]; then
        info "Downloading Casper (the classic default theme)..."
        git clone --depth 1 https://github.com/TryGhost/Casper.git "$REFERENCE_DIR/casper" 2>/dev/null
        rm -rf "$REFERENCE_DIR/casper/.git"
        done_msg "Casper downloaded."
    fi

    # Clone Source separately (it's not in the monorepo)
    if [ ! -d "$REFERENCE_DIR/source" ]; then
        info "Downloading Source (the current default theme)..."
        git clone --depth 1 https://github.com/TryGhost/Source.git "$REFERENCE_DIR/source" 2>/dev/null
        rm -rf "$REFERENCE_DIR/source/.git"
        done_msg "Source downloaded."
    fi

    # Clone top community themes
    info "Downloading top community themes..."

    if [ ! -d "$REFERENCE_DIR/liebling" ]; then
        git clone --depth 1 https://github.com/eddiesigner/liebling.git "$REFERENCE_DIR/liebling" 2>/dev/null
        rm -rf "$REFERENCE_DIR/liebling/.git"
        done_msg "Liebling downloaded."
    fi

    if [ ! -d "$REFERENCE_DIR/simply" ]; then
        git clone --depth 1 https://github.com/godofredoninja/simply.git "$REFERENCE_DIR/simply" 2>/dev/null
        rm -rf "$REFERENCE_DIR/simply/.git"
        done_msg "Simply downloaded."
    fi

    # Clean up the monorepo clone (we only needed the packages)
    rm -rf "$REFERENCE_DIR/.ghost-themes-repo"

    done_msg "All reference themes ready."
fi

# ============================================================
# Step 7: Summary & next steps
# ============================================================
step "Step 7 of 7: You're all set!"

echo ""
echo "  Everything is installed. Here's what to do next:"
echo ""
echo -e "  ${BLUE}1. Log into GitHub:${NC}"
echo "     gh auth login"
echo "     (Follow the prompts — choose GitHub.com → HTTPS → Login with browser)"
echo ""
echo -e "  ${BLUE}2. Clone your project:${NC}"
echo "     gh repo clone whale/ghost-theme-luis"
echo "     cd ghost-theme-luis"
echo ""
echo -e "  ${BLUE}3. If you haven't already, re-run this script to download reference themes:${NC}"
echo "     bash ~/Downloads/setup.sh"
echo ""
echo -e "  ${BLUE}4. Start Claude Code:${NC}"
echo "     claude"
echo "     (First time: it opens a browser — log in with your Claude account)"
echo ""
echo -e "  ${BLUE}5. Tell Claude what you want to build!${NC}"
echo "     Example: \"I want to start building my Ghost theme from my Figma design\""
echo ""
echo "  ─────────────────────────────────────────────────────"
echo ""
echo "  Useful things to tell Claude:"
echo "    • \"Save my progress\"         → Creates a save point (git commit)"
echo "    • \"Undo that\"                → Reverts the last change"
echo "    • \"It was working before\"    → Shows you past save points to go back to"
echo "    • \"Show me what I changed\"   → Shows a before/after diff"
echo "    • \"Package my theme\"         → Creates a .zip to upload to Ghost"
echo ""
