# 2px taskbar hidden offset; 29px title bar offset; 1px border offset; 15px window padding;
# y base is 1120 to 2560, it's calculated from the lower right left corner with applied offsets
let offset = 2 + 29 + 1 + 15 
let y      = 2560 - $offset

let list = [
  { pos: "right",       command: [--no-window-focus -p 834 ($y - 1376) 1710 1376] },
  { pos: "topright",    command: [--no-window-focus -p 969 ($y - 553) 934 400] },
  { pos: "bottomright", command: [--no-window-focus -p 969 ($y - 17) 934 400] },
  { pos: "topleft",     command: [--no-window-focus -p 17 ($y - 553) 934 400] },
  { pos: "bottomleft",  command: [--no-window-focus -p 17 ($y - 17) 934 400] },
]

def --wrapped main [pos?: string, ...param] {
  let $window = $list | where pos == $pos | get command.0?

  if ($window | is-empty) {
  	let command = $pos | append $param
    blender ...$command
  } else {
  	let command = $window | append $param
    blender ...$command
  }

}

def --wrapped "main dev" [pos?: string, ...param] {
  let dir = "X:/Projects/Blender"

  $env.BLENDER_USER_CONFIG = $"($dir)/config"
  $env.BLENDER_USER_SCRIPTS = $"($dir)/scripts"

  let $window = $list | where pos == $pos | get command.0?

  if ($window | is-empty) {
  	let command = [--python-use-system-env --python ($dir | path join "dev.py")] | append $pos | append $param
  	blender ...$command
  } else {
  	let command = [--python-use-system-env --python ($dir | path join "dev.py")] | append $window | append $param
  	blender ...$command
  }

}
