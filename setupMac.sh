echo "Setting up your new Mac ;>"

#setup console
git clone https://github.com/zdharma/fast-syntax-highlighting.git ~/.zsh/plugins/fast-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/plugins/zsh-autosuggestions


# ============== Installing Apps ==============

# installing rvm with ruby
\curl -sSL https://get.rvm.io | bash -s stable --ruby

# Setting up Homebrew
if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Updating homebrew..."
    brew update
fi

# Installing brew packages
brew install mas #tool to install mac app store apps from command line
brew install starship #make cosnole beautifull :)

# Avio speciffic
brew install xcodegen

caskWorkspaceApps=(
    fork
    iterm2
    isimulator
    postman
    charles
    visual-studio-code
)

caskApps=(
    zoomus
    google-chrome
    tunnelblick
)

masApps=(
    640199958 # Apple Developer
    497799835 # Xcode
    803453959 # Slack
)

# Installing apps with brew cask
echo "Installing apps with brew cask"
brew install --cask --appdir="/Applications/Work" ${caskWorkspaceApps[@]}
brew install --cask --appdir="/Applications" ${caskApps[@]}


# ============== System settings ==============

#"Showing all filename extensions in Finder by default"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

#"Disabling the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

#Changes Finder to List View
#Four-letter codes for the other view modes: 'icnv', 'clmv', 'Flwv'
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

#Shows Status Bar
defaults write com.apple.finder ShowStatusBar -bool true;

#Shows Path Bar
defaults write com.apple.finder ShowPathbar -bool true;

#New Finder windows now opens in /Users/<username>
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true


# ============== Prepare system ==============

# Restart Finder
killall Finder