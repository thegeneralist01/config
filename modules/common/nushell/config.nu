$env.config.buffer_editor = "/etc/profiles/per-user/thegeneralist/bin/nvim"
$env.config.show_banner = false

$env.config = {
  shell_integration: {
    osc2:                   false
    osc7:                   true
    osc8:                   true
    osc9_9:                 false
    osc133:                 true
    osc633:                 true
    reset_application_mode: true
  }
}

$env.config.completions = {
  algorithm:      prefix
  case_sensitive: false
  partial:        true
  quick:          true
  external: {
    enable:      true
    max_results: 100
    completer:   {|tokens: list<string>|
      let expanded = scope aliases | where name == $tokens.0 | get --optional expansion.0

      mut expanded_tokens = if $expanded != null and $tokens.0 != "cd" {
        $expanded | split row " " | append ($tokens | skip 1)
      } else {
        $tokens
      }

      $expanded_tokens.0 = ($expanded_tokens.0 | str trim --left --char "^")

      fish --command $"complete '--do-complete=($expanded_tokens | str join ' ')'"
      | $"value(char tab)description(char newline)" + $in
      | from tsv --flexible --no-infer
    }
  }
}

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

def greeting [] {
  let quotes = [
    "What is impossible for you is not impossible for me."
    "Why do we fall, Master Wayne? So that we can learn to pick ourselves up. - Alfred Pennyworth"
    "Endure, Master Wayne. Take it. They’ll hate you for it, but that’s the point of Batman. He can be the outcast. He can make the choice… that no one else can make. The right choice. - Alfred Pennyworth"
    "— I never said thank you. — And you will never have to."
    "A hero can be anyone, even a man doing something as simple and reassuring as putting a coat on a young boy's shoulders to let him know that the world hadn't ended. - Batman"
    "— Come with me. Save yourself. You don't owe these ppl anymore, you've given them everything.\n —Not everything. Not yet."
    "The night is always darkest before the dawn, but I promise you, the dawn is coming. - Harvey Dent"
    "It's not who you are underneath, but what you do that defines you. - Batman"
    "The idea was to be a symbol. Batman... could be anybody. That was the point. - Bruce Wayne"
  ]
  echo ($quotes | get (random int 0..(($quotes | length) - 1)))
}

greeting
