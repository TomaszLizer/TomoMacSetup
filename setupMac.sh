#!/bin/bash

# ============== App Lists ==============

CLI_APPS=(
    starship                              # Prompt - make console beautiful :)
    swiftlint
    swift-format
    tuist
    aria2
    xcodes
    peripheryapp/periphery/periphery      # Swift dead code analysis
    zsh-syntax-highlighting               # ZSH plugin
    zsh-autosuggestions                   # ZSH plugin
    zsh-completions                       # ZSH completions
)

CASK_APPS=(
    fork                      # Best git GUI ever
    iterm2                    # Primary terminal
    slack
    postman
    itsycal                   # Menu bar calendar
    betterdisplay
    setapp
    visual-studio-code
    google-chrome
)

# ============== Colors & UI Helpers ==============

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Section header
section() {
    echo ""
    echo "${BOLD}━━━ $1 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Spinner function - shows rotating animation while command runs
spin() {
    local pid=$1
    local msg=$2
    local spinchars='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    
    while kill -0 "$pid" 2>/dev/null; do
        printf "\r${BLUE}${spinchars:i++%${#spinchars}:1}${NC} %s" "$msg"
        sleep 0.1
    done
    
    wait "$pid"
    return $?
}

# Run command with spinner
run_with_spinner() {
    local msg="$1"
    shift
    
    # Run command in background, capture output
    "$@" > /tmp/setup_output.log 2>&1 &
    local pid=$!
    
    spin "$pid" "$msg"
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        printf "\r${GREEN}✓${NC} %s\n" "$msg"
    else
        printf "\r${RED}✗${NC} %s\n" "$msg"
        echo "${YELLOW}  └─ See /tmp/setup_output.log for details${NC}"
    fi
    
    return $exit_code
}

# Simple success/fail messages (for non-background tasks)
success() {
    echo "${GREEN}✓${NC} $1"
}

fail() {
    echo "${RED}✗${NC} $1"
}

# ============== Install Functions ==============

install_formula() {
    local pkg="$1"
    run_with_spinner "Installing $pkg" brew install "$pkg"
}

install_cask() {
    local app="$1"
    run_with_spinner "Installing $app" brew install --cask "$app"
}

# ============== Main Setup ==============

echo ""
echo "🍎 ${BOLD}Setting up your new Mac...${NC}"

# ============== Homebrew ==============

section "Homebrew"

if ! command -v brew &> /dev/null; then
    echo "${BLUE}⠋${NC} Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    if [ $? -eq 0 ]; then
        success "Installing Homebrew"
    else
        fail "Installing Homebrew"
        echo "${RED}Cannot continue without Homebrew. Exiting.${NC}"
        exit 1
    fi
else
    success "Homebrew already installed"
    run_with_spinner "Updating Homebrew" brew update
fi

# Add Homebrew to current session
eval "$(/opt/homebrew/bin/brew shellenv)"

# Persist to ~/.zprofile if not already there
if ! grep -q 'brew shellenv' ~/.zprofile 2>/dev/null; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    success "Configured shell environment"
else
    success "Shell environment already configured"
fi

# ============== mise (Version Manager) ==============

section "mise"

# Install mise directly (not via brew) to enable autoupdate feature
if ! command -v mise &> /dev/null; then
    run_with_spinner "Installing mise" bash -c "curl -fsSL https://mise.run | sh"
    if [ $? -eq 0 ]; then
        # Add mise to current session
        eval "$($HOME/.local/bin/mise activate bash)"
    fi
else
    success "mise already installed"
fi

# ============== CLI Tools ==============

section "CLI Tools"

for pkg in "${CLI_APPS[@]}"; do
    install_formula "$pkg"
done

# ============== Applications ==============

section "Applications"

for app in "${CASK_APPS[@]}"; do
    install_cask "$app"
done

# ============== Shell Configuration ==============

section "Shell Configuration"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create ~/.zsh directory if it doesn't exist
mkdir -p ~/.zsh

# Copy zprofile
if [ -f "$SCRIPT_DIR/console/zprofile" ]; then
    cp "$SCRIPT_DIR/console/zprofile" ~/.zprofile
    success "Creating ~/.zprofile"
else
    fail "console/zprofile not found"
fi

# Copy zshrc
if [ -f "$SCRIPT_DIR/console/zshrc" ]; then
    cp "$SCRIPT_DIR/console/zshrc" ~/.zshrc
    success "Creating ~/.zshrc"
else
    fail "console/zshrc not found"
fi

# Import iTerm2 profile via Dynamic Profiles (auto-loads on iTerm startup)
if [ -f "$SCRIPT_DIR/console/Tomo-iTerm_profile.json" ]; then
    ITERM_DYNAMIC_PROFILES="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
    mkdir -p "$ITERM_DYNAMIC_PROFILES"
    cp "$SCRIPT_DIR/console/Tomo-iTerm_profile.json" "$ITERM_DYNAMIC_PROFILES/"
    success "Importing iTerm2 profile"
fi

# ============== macOS Settings ==============

section "macOS Settings"

# Finder settings
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
success "Configuring Finder preferences"

# Xcode settings
defaults write com.apple.dt.Xcode ApplePersistenceIgnoreState -bool YES
success "Configuring Xcode preferences"

# Restart Finder to apply changes
killall Finder 2>/dev/null
success "Restarting Finder"

# ============== Done ==============

echo ""
echo "🎉 ${BOLD}Setup complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal to apply shell changes"
echo "  2. Run ${BOLD}mise use --global node@lts${NC} to install Node.js"
echo "  3. Run ${BOLD}mise use --global python@3.12${NC} to install Python"
echo "  4. Import iTerm profile from console/Tomo-iTerm_profile.json (optional)"
echo ""
