$env.ENV_CONVERSIONS.PATH = {
  from_string: {|string|
    $string | split row (char esep) | path expand --no-symlink
  }
  to_string: {|value|
    $value | path expand --no-symlink | str join (char esep)
  }
}

$env.LS_COLORS = (open ~/.config/nushell/ls_colors.txt)

source ~/.config/nushell/zoxide.nu
# NVM
# source ("/Users/thegeneralist/.nvm/" | path join "nvm.sh")

# GPG TTY
# $env.GPG_TTY = (tty)

# Extra PATHs
# $env.PATH = [
#   # "/home/thegeneralist/AppImages"
#   # ($env.HOME | path join "personal/zen")
#   # ($env.HOME | path join ".local/scripts")
#   # ($env.HOME | path join ".local/bin")
#   # ($env.HOME | path join ".bun/bin")
#   # ($env.HOME | path join ".nix-profile/bin")
#   # "/nix/var/nix/profiles/default/bin"
#   # ($env.HOME | path join ".local/share/pnpm")
#   # "/usr/bin"
#   # "/usr/sbin"
#   # "/sbin"
#   # "/Applications/Ghostty.app/Contents/MacOS"
#   # ($env.HOME | path join ".local/bin")
#   # ($env.HOME | path join ".cargo/env")
#   # ($env.HOME | path join ".cargo/bin")
#   # "/usr/local/go/bin"
#   # ($env.HOME | path join "go/bin")
#   # ($env.HOME | path join ".npm-packages/bin")
#   # ($env.HOME | path join ".Android/Sdk/platform-tools")
#   # ($env.HOME | path join ".Android/Sdk/emulator")
# ] ++ $env.PATH
