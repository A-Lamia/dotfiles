source $starship
source $carapace
source $zoxide

source ~/.config/nushell/function.nu

def bubble [prompt: string, color: string] {
	([
    (ansi reset)                           
    (ansi { fg: "black"})
    (char -u e0b6)
    (ansi { fg: $color, bg: "black"})
    ($prompt)
    (ansi reset)                           
    (ansi { fg: "black"})
    (char -u e0b4)                         
    (ansi reset)                           
  ] | str join )
}

$env.config.show_banner = false

$env.config.edit_mode = "vi"
$env.PROMPT_INDICATOR_VI_INSERT = (bubble ❯ red) + " "
$env.PROMPT_INDICATOR_VI_NORMAL = (bubble 󰊕 red) + " "

$env.TRANSIENT_PROMPT_COMMAND = " " + (bubble " "  red) + " "
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = ""
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = ""
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = ""

# Alias
alias l = ls


alias blender = nu ~/.config/nushell/scripts/blender.nu
alias shrink = nu ~/.config/nushell/scripts/shrink.nu
alias eol = nu ~/.config/nushell/scripts/eol.nu

