$env.config.buffer_editor = "/home/thegeneralist/.nix-profile/bin/nvim"
$env.config.show_banner = false

# Basic Aliases
alias v = nvim .
alias ff = fastfetch --load-config examples/10.jsonc
alias g = glimpse --interactive -o both -f llm.md
def gg [] {
  open llm.md | save -r /dev/stdout | ^xclip -sel c
}
alias rn = yazi

# Zoxide init
#^zoxide init nushell | save --force ~/.config/nushell/zoxide.nu
#source ~/.config/nushell/zoxide.nu

alias c = clear
alias e = exa
alias el = exa -la
alias l = ls -a
alias ll = ls -la
alias cl = c; l

alias ap = cd ~/personal
alias ad = cd ~/Downloads
alias ab = cd ~/books
alias a = cd ~
alias ah = cd ~/dotfiles/hosts/thegeneralist
alias ai3 = nvim /home/thegeneralist/dotfiles/hosts/thegeneralist/dotfiles/i3/config
# alias rb = sudo nixos-rebuild switch --flake ~/dotfiles#thegeneralist
alias rb = nh os switch . -v -- --show-trace --verbose

source ~/.zoxide.nu
