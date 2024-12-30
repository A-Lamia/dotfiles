def "main crlf" [path: string, --global, -g] {
	if ($path | path exists) == false {return ([(ansi {fg: "red"}) ("ERROR") (ansi reset) ($": \"($path)\" could not be found.")] | str join)}
	let path: string = ($path | path expand) 

	mut files: table = []

	if $global or $g {
		cd $path
		$files = ls **/* | where type == "file" | get name | path expand 	
	} else {
		$files = ls $path | where type == "file" | get name | path expand 	
	}

	for $file in $files {
		open -r $file | str replace -a "\n" "\r\n" | save -f $file
	}

	return $files
}

def "main lf" [path: string, --global, -g] {
	if ($path | path exists) == false {return ([(ansi {fg: "red"}) ("ERROR") (ansi reset) ($": \"($path)\" could not be found.")] | str join)}
	let path: string = ($path | path expand) 

	mut files: table = []

	if $global or $g {
		cd $path
		$files = ls **/* | where type == "file" | get name | path expand 	
	} else {
		$files = ls $path | where type == "file" | get name | path expand 	
	}

	for $file in $files {
		open -r $file | str replace -a "\r\n" "\n" | save -f $file
	}

	return $files
}

def main [] -> table {
	print ([
		("Converts file line endings to crlf or lf.\n")
		("\n")
		("Using this command without a subcommand will only produce this message.\n")
		("\n")
		("If path supplied is a directory only files in that directory will\n")
		("be converted. If global flag is used, then all files in\n")
		("all subdirectories will be converted.\n")
		("\n")
		("> eol [subcommand] [path] ?[flag]\n")
		("\n")
		("WARNING: make sure to commit / backup all files before using.\n")
		("\n")
		(ansi {fg: "green"}) 
		("Usage")
		(ansi {fg: "white"}) 
		(":\n  > eol\n")
		("\n")
		(ansi {fg: "green"}) 
		("Subcommands")
		(ansi {fg: "white"}) 
		(":\n")
		(ansi {fg: "cyan"}) 
		("  eol lf")
		(ansi {fg: "white"}) 
		(" - Convert line endings to lf (\\n).\n")
		(ansi {fg: "cyan"}) 
		("  eol crlf")
		(ansi {fg: "white"}) 
		(" - Convert line endings to crlf (\\r\\n).\n")
		("\n")
		(ansi {fg: "green"}) 
		("Flags")
		(ansi {fg: "white"}) 
		(":\n")
		(ansi {fg: "cyan"}) 
		("  -g, --global")
		(ansi {fg: "white"}) 
		(" - Applies to all files in all child subdirectories")
		(":\n")
	] | str join)
}
