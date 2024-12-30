def main [path: string, out?: string, preset?: string] {
	if (which ffmpeg | is-empty) { return "FFMPEG not found"}

	let path = $path | path expand
	let file = $path | path basename | split row "."
	let out = if ($out | is-empty) {
		$"($path | path dirname)/($file.0?)_mini.($file.1?)" | path expand
	}

	match $preset { 
		_ =>  {
			ffmpeg -i $path -vcodec h264 -acodec mp3 $out
		}
	}

}
