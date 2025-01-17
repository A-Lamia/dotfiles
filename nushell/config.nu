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

alias ggh = git rev-parse --abbrev-ref HEAD
alias geol = git ls-files --eol
alias gsl = do {|branch| git rebase --autostash --exec 'git commit --amend --no-edit --gpg-sign' ($branch) HEAD}
alias gld = git log --oneline --graph --all --decorate
alias glf = do {|string| git log --grep=$"($string)" --format="%h|%s|%ad" | prepend "Hash|Message|Date\n"| str join | from csv --no-infer --separator "|"}
alias gll = do {git log origin/(ggh)..HEAD --format="%h|%s|%ad" | prepend "Hash|Message|Date\n"| str join | from csv --no-infer --separator "|"}
alias gdc = do {|commit| git diff $"($commit)^!"}
alias jjo = jj --no-pager --ignore-working-copy

alias wexe = watchexec -c -q
alias wgg = wexe -- git-graph --no-pager -S -l -s r

alias blender = nu ~/.config/nushell/scripts/blender.nu
alias shrink = nu ~/.config/nushell/scripts/shrink.nu
alias eol = nu ~/.config/nushell/scripts/eol.nu

