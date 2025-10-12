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
      let expanded = scope aliases | where name == $tokens.0 | get --ignore-errors expansion.0

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
    "What is impossible for you is not impossible for me."
    "What is impossible for you is not impossible for me."
    "What is impossible for you is not impossible for me."
    "What is impossible for you is not impossible for me."
    "What is impossible for you is not impossible for me."
    "What is impossible for you is not impossible for me."
    "What is impossible for you is not impossible for me."
    "Ah, Stil, I live in an apocalyptic dream."
    "Greatness is a transitory experience."
    "Limits exist only to be exceeded."
    "I don’t follow paths. I make them."
    "What crushes others fuels me."
    "Ordinary is the disease. I am the cure."
    "You see walls. I see doors."
    "Fear is a suggestion. I ignore it."
    "If it can be imagined, it can be done—faster."
    "Mediocrity is the only true danger."
    "I bend reality so you don’t have to."
    "The impossible is just untested patience."
    "Rules are advice I choose to ignore."
    "Every boundary is a dare."
    "I don’t wait for opportunity. I invent it."
    "Pain is a fuel. Weakness is optional."
    "Victory doesn’t ask permission."
    "The future bends to those who act."
    "Obstacles are just poorly designed stepping stones."
    "Chaos is a playground."
    "Legends are written in disregard for limits."
    "Difficulty is the seasoning of achievement."
    "Success belongs to those who steal it."
    "Failure is the draft. Mastery is the publication."
    "Time fears those who don’t respect it."
    "I thrive where others break."
    "Destiny is negotiable."
    "Limits are suggestions, not laws."
    "The world bends for persistence."
    "I make the rules after winning."
    "Every ‘no’ is a challenge waiting to be conquered."
    "I don’t follow trends. I create them."
    "Adversity is just another form of applause."
    "Impossible is an opinion, not a fact."
    "I carve paths through resistance."
    "Mastery is forged, not granted."
    "Chaos reveals the capable."
    "The meek inherit nothing."
    "I turn hesitation into fuel."
    "Pain is temporary. Glory is eternal."
    "I thrive in the impossible."
    "The weak talk. The strong act."
    "Fortune favors my audacity."
    "Nothing worth having comes unchallenged."
    "Limits are the invention of the timid."
    "Every barrier is an invitation."
    "I am the variable the universe didn’t calculate."
    "Victory whispers to those who refuse to listen to fear."
    "Failure teaches. I only graduate with honors."
    "The extraordinary is a habit, not a gift."
    "Resistance exists to prove my strength."
    "Legends are crafted in defiance."
    "The impossible is just another rehearsal."
  ]
  echo ($quotes | get (random int 0..(($quotes | length) - 1)))
}

greeting
