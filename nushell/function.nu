def --wrapped n [path:string = "", ...opts] {
  if (which neovide | is-not-empty) {
    if $env.os == "Windows_NT" {
      alias Start-Process = pwsh -nop -c Start-Process
      Start-Process neovide ...$opts $path
    }
  } else { 
    print "neovide not found"
  }
}


def --wrapped vsdevcmd [...command] {
  let vsdev = '&{Import-Module "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell 61980f80 -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"}'
  let command = ($command | str join " ")
  pwsh -nop -c ($vsdev + "; " + $command)
}


def bgl [] {
  let json = (curl https://cgm.lamia.io/api/v1/entries.json -s) 
  let sgv_0 = ($json | from json | get sgv.0 | into int) / 18 | math round -p 1
  let sgv_1 = ($json | from json | get sgv.1 | into int) / 18 | math round -p 1
  let sgv_2 = ($json | from json | get sgv.2 | into int) / 18 | math round -p 1
  print -n "\n🩸 " $sgv_2 " 󰑃  " $sgv_1 " 󰑃  " $sgv_0 "\n "
}


