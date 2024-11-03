# Imports
source ~/.cache/starship/init.nu
source ~/.cache/carapace/init.nu
source ~/.config/nushell/.zoxide.nu

if ($env.os == "Windows_NT") {
  source ~/.config/nushell/profiles/windows.nu
} else {
  source ~/.config/nushell/profiles/linux.nu
}

# Alias
alias l = ls
