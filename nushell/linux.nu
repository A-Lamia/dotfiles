# starts an executable as a background process
def --wrapped pstart [$exe, ...param] {
	sh -c ($exe
		| append $param
		| append "&"
		| str join)
}

# loops through 2 displays and changes the brightness
def display (level) {
	[1] | each {|e| ddcutil -d $e setvcp 0x10 $level}
	return
}


# https://superuser.com/questions/1675877/how-to-create-a-new-pipewire-virtual-device-that-to-combines-an-real-input-and-o
# https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Virtual-Devices
def vcable (command?, name?) {
	match $command { 
		"new" => {
			pactl -f json list sources short 
			| from json
			| where name like $name
			| if ($in | length) == 0 {
				pactl load-module module-null-sink media.class=Audio/Source/Virtual sink_name=($name) channel_map=stereo 
			} else {
				print $name "already exsists"
			}
		},
		"delete" => {
			let id = (pactl -f json list sources | from json | where name == $name | $in.owner_module.0)
			pactl unload-module $id
		},
		"list" => {
			pactl -f json list sources short | from json
		}
		_ => { 
			print ([
				("Used to create a virtual input / output pass through.\n")
				("\n")
				(ansi {fg: "green"}) 
				("Usage")
				(ansi {fg: "white"}) 
				(":\n  > vcable\n")
				("\n")
				(ansi {fg: "green"}) 
				("Subcommands")
				(ansi {fg: "white"}) 
				(":\n")
				(ansi {fg: "cyan"}) 
				("  vcable new")
				(ansi {fg: "white"}) 
				(" - create a new virtual cable.\n")
				(ansi {fg: "cyan"}) 
				("  vcable delete")
				(ansi {fg: "white"}) 
				(" - deleted a virtual cable.\n")
				(ansi {fg: "cyan"}) 
				("  vcable list")
				(ansi {fg: "white"}) 
				(" - list virutal cables.\n")
				("\n")
			] | str join)
		}  
	}
}

