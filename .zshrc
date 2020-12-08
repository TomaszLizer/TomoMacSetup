# tab name

# tab display name
promptPreCmnd() {
    # set user/hostname
    echo -en "\033]0;$(whoami)@$(hostname)|$(pwd|cut -d "/" -f 2-100)\a"
    # tab name: directory
    echo -en "\033]1;$(pwd|cut -d "/" -f 4-100)\a"
}
precmd_functions=(promptPreCmnd)
# promptPreCmnd

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# save commands history
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=$HISTSIZE

# corretion
ENABLE_CORRECTION="true"

# ---- plugins ----
# Load completion config
source $HOME/.zsh/plugins/cd 
# syntax highlight
source $HOME/.zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
# autosuggestions
source $HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# ---- autocompletion additional setup ----
# Initialize the completion system
autoload -Uz compinit
# Cache completion if nothing changed - faster startup time
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi
# Enhanced form of menu completion called `menu selection'
zmodload -i zsh/complist
# ---- autocompletion additional setup ----

# Aliases
alias zshrc='code ~/.zshrc'
alias xcode='open -a Xcode'
alias clearClipboard='pbcopy < /dev/null'

# enable starship
eval "$(starship init zsh)"