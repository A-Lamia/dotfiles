# Starship
const starship = ("~/.cache/starship/init.nu" | path expand)
if ($starship | path exists) == false and (which starship | is-empty) {
  mkdir ($starship | path dirname)
  starship init nu | save --force $starship
}

# Carapace
$env.CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense"
const carapace = ("~/.cache/carapace/init.nu" | path expand)
if ($carapace | path exists) == false and (which carapace | is-not-empty) {
  mkdir ($carapace | path dirname)
  carapace _carapace nushell | save --force $carapace
} 

# Zoxide
const zoxide = ("~/.cache/zoxide/init.nu" | path expand)
if ($zoxide | path exists) == false and (which zoxide | is-empty) {
  mkdir ($zoxide | path dirname)
  zoxide init nushell | save --force $zoxide
} 
