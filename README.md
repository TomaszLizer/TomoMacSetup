# TomoMacSetup

Automated setup script for a new Mac. Installs apps, configures the shell for fast startup, and applies sensible macOS defaults.

## Quick Start

```bash
git clone https://github.com/tomocrafter/TomoMacSetup.git
cd TomoMacSetup
sh ./setupMac.sh
```

## What It Does

### 1. Installs Homebrew
- Installs Homebrew if not present
- Configures shell environment in `~/.zprofile`

### 2. CLI Tools

| Tool | Purpose |
|------|---------|
| `starship` | Fast, customizable prompt |
| `mise` | Universal version manager (replaces nvm, rbenv, pyenv, jenv) |
| `swiftlint` | Swift linter |
| `swift-format` | Swift formatter |
| `periphery` | Swift dead code analysis |
| `zsh-syntax-highlighting` | Fish-like syntax highlighting |
| `zsh-autosuggestions` | Fish-like autosuggestions |
| `zsh-completions` | Additional completions |

### 3. Applications

| App | Purpose |
|-----|---------|
| iTerm2 | Primary terminal |
| Ghostty | Modern GPU-accelerated terminal (alternative) |
| Fork | Git GUI |
| Slack | Communication |
| Postman | API testing |
| Itsycal | Menu bar calendar |
| BetterDisplay | Display management |
| Setapp | App subscription service |
| Visual Studio Code | Code editor |
| Google Chrome | Browser |

### 4. Shell Configuration

Creates optimized ZSH configuration targeting fast startup time:

- **`~/.zprofile`** - Homebrew environment (runs once per login)
- **`~/.zshrc`** - Plugins, completions, aliases (runs per shell)

Key optimizations:
- Uses `mise` instead of multiple version managers
- Cached `compinit` (regenerates once per 24h)
- Homebrew-managed plugins

### 5. iTerm2 Profile

Automatically imports the custom iTerm2 profile via Dynamic Profiles.

### 6. macOS Settings

Configures sensible Finder defaults:
- Show all file extensions
- Show hidden files
- List view by default
- Show status bar and path bar
- Disable extension change warnings

Xcode:
- Always ask what to open (don't restore last project)

## Project Structure

```
TomoMacSetup/
├── setupMac.sh              # Main setup script
├── README.md                # This file
└── console/
    ├── zprofile             # Login shell config
    ├── zshrc                # Interactive shell config
    └── Tomo-iTerm_profile.json  # iTerm2 profile
```

## After Setup

### Install Language Runtimes with Mise

```bash
# Node.js
mise use --global node@lts

# Python
mise use --global python@3.12

# Ruby
mise use --global ruby@3.3

# Java
mise use --global java@21
```

### Customize

Edit the arrays in `setupMac.sh` to add/remove apps:

```bash
CLI_APPS=(
    # Add your CLI tools here
)

CASK_APPS=(
    # Add your GUI apps here
)
```

## Requirements

- macOS (Apple Silicon)

## License

MIT
