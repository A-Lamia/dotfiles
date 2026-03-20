# starts an executable as a background process
def --wrapped pstart [$exe, ...param] {
	pwsh -nop -c  ('Start-Process' 
		| append $exe 
		| append ($param 
		| enumerate 
		| each {|c| $"'($c.item)',"}) 
		| str join " "
	  | str trim --right --char "," ) 
}


def --wrapped vsdevcmd [...command] {
  let vsdev = '&{Import-Module "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell 61980f80 -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"}'
  let command = ($command | str join " ")
  pwsh -nop -c ($vsdev + "; " + $command)
}


