# Starship
const starship = ("~/.cache/starship/init.nu" | path expand)
if ($starship | path exists) == false and (which starship | is-not-empty) {
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
if ($zoxide | path exists) == false and (which zoxide | is-not-empty) {
  mkdir ($zoxide | path dirname)
  zoxide init nushell | save --force $zoxide
} 

# Mise 
const mise = ("~/.cache/mise/init.nu" | path expand)
if ($mise | path exists ) == false and (which mise | is-not-empty) {
  mkdir ($mise | path dirname)
  mise activate nu | save --force $mise
} 

$env.EDITOR = "nvim"
