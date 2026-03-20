def --wrapped n [...opts] {
  if (which neovide | is-empty) { return "Neovide was not found" }
	pstart neovide ...$opts
}


def bgl [] {
  let json = (curl https://cgm.lamia.io/api/v1/entries.json -s) 
  let sgv_0 = ($json | from json | get sgv.0 | into int) / 18 | math round -p 1
  let sgv_1 = ($json | from json | get sgv.1 | into int) / 18 | math round -p 1
  let sgv_2 = ($json | from json | get sgv.2 | into int) / 18 | math round -p 1
  print -n "\n🩸 " $sgv_2 " 󰑃  " $sgv_1 " 󰑃  " $sgv_0 "\n "
}


def cht [...question: string] {
	let query = "cht.sh/" + ($question | str join "+" )
	curl --silent $query
}


def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}
