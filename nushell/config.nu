source ~/.cache/starship/init.nu
source ~/.cache/carapace/init.nu
source ~/.cache/zoxide/init.nu

source ~/.config/nushell/function.nu

$env.TRANSIENT_PROMPT_COMMAND = "  "
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = ""

# Alias
alias l = ls


alias shrink = nu ~/.config/nushell/scripts/shrink.nu
alias eol = nu ~/.config/nushell/scripts/eol.nu

