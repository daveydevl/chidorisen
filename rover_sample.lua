
Rover_sample = r.layer {
	scale = 520 / 1080,
	y = 1920,
	alpha = 1
}

Rover_sample.setSample = function(lvl)
	Rover_sample.blocks = blocks(false, lvl, levels[lvl], true)
end