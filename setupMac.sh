echo "Setting up your new Mac ;>"

#setup console
git clone https://github.com/zdharma/fast-syntax-highlighting.git ~/.zsh/plugins/fast-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/plugins/zsh-autosuggestions
cp console/completion.zsh ~/.zsh/plugins/

# ============== Installing Apps ==============

# Setting up Homebrew
if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Updating homebrew..."
    brew update
fi

cliApps=(
    starship # make console beautiful :)
    rbenv
    jenv
    pyenv
    swiftlint
    swift-format
    peripheryapp/periphery/periphery # Swift dead code analysis
)

# Installing brew cli tools
echo "Installing cli apps with brew"
brew install --appdir="/Applications" ${cliApps[@]}

caskApps=(
    fork # Best git GUI ever
    slack
    iterm2 # 
    isimulator # iOS simulator menu bar helper
    postman
    itsycal # menu bar calendar
    setapp
    visual-studio-code
    google-chrome
)

# Installing apps with brew cask
echo "Installing apps with brew cask"
brew install --cask --appdir="/Applications" ${caskApps[@]}


# ============== System settings ==============

# Showing all filename extensions in Finder by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disabling the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Changes Finder to List View
# Four-letter codes for the other view modes: 'icnv', 'clmv', 'Flwv'
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Shows Status Bar
defaults write com.apple.finder ShowStatusBar -bool true;

# Shows Path Bar
defaults write com.apple.finder ShowPathbar -bool true;

# New Finder windows now opens in /Users/<username>
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true

# Stop xcode from opening last used projects - always ask what to open
defaults write com.apple.dt.Xcode ApplePersistenceIgnoreState -bool YES

# ============== Prepare system ==============

# Restart Finder
killall Finder