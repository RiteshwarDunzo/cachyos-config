# Disable Powerlevel10k instant prompt warning
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

# CachyOS config
source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Custom startup commands
fastfetch
