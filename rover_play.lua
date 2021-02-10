
Rover_play = r.layer {
	y = 1920
}



Rover_play.sample = r.images.sample_bg

Rover_play.stage_bg = r.images.stage_bg {
	y = 624
}

Rover_play.level_bg = r.images.level_bg {
	x = 520,
	y = 0
}

Rover_play.timer_bg = r.images.timer_bg {
	x = 520,
	y = 416
}





Rover_play.c_level = 1

Rover_play:setClip(0, 0, 1080, 1920)



Rover_play.quit = r.images.quit {
	x = 520,
	y = 208
}

Rover_play.retry = r.images.retry {
	x = 800,
	y = 208
}




Rover_play.level_indicator = r.text86 {
	y =  135
}
Rover_play.level_indicator:setTextColor(0xFFFFFF)

Rover_play.moves_indicator = r.text64 {
	y =  416 + 120
}

Rover_play.c_moves = 0
Rover_play.max_moves = 0

Rover_play.setMoves = function(m_max)
	Rover_play.c_moves = 0
	Rover_play.max_moves = m_max
	
	Rover_play.moves_indicator:setText(Rover_play.c_moves.." / "..Rover_play.max_moves.." MOVES")
	Rover_play.moves_indicator:setX(800 - Rover_play.moves_indicator:getWidth() / 2)
	Rover_play.moves_indicator:setTextColor(0xFFFFFF)
end

Rover_play.increaseMoves = function()
	Rover_play.c_moves = Rover_play.c_moves + 1
	local text = Rover_play.c_moves.." / "..Rover_play.max_moves.." MOVES"
	if Rover_play.c_moves > Rover_play.max_moves then
		text = "EXCEEDED"
		Rover_play.moves_indicator:setTextColor(0xFF0000)
	end
	
	Rover_play.moves_indicator:setText(text)
	Rover_play.moves_indicator:setX(800 - Rover_play.moves_indicator:getWidth() / 2)
end

Rover_play.setPlay = function(lvl)
	Rover_play.c_level = lvl
	Rover_play.blocks = blocks(true, lvl, levels[lvl], true) {
		y = 624
	}
	
	Rover_play.level_indicator:setText("LEVEL "..lvl)
    Rover_play.level_indicator:setX(800 - Rover_play.level_indicator:getWidth() / 2)
	
	Rover_play.image = r.images.hud
end

Rover_play.reloadPlay = function(done)
	enableTouch = false
	
	Rover_play.setMoves(Rover_play.max_moves)

	GTween.new(Rover_play.blocks, 0.25, {
		alpha = 0
	}, {
		ease = easing.linear,
		onComplete = function()
			local lvl = Rover_play.c_level
		
			Rover_play.blocks = blocks(true, lvl, levels[lvl], true) {
				y = 624
			}
			Rover_play.blocks:setAlpha(0)
			
			GTween.new(Rover_play.blocks, 0.25, {
				alpha = 1
			}, {
				ease = easing.linear,
				onComplete = function()
					enableTouch = true
				end
			})
			
			Rover_play.image = r.images.hud
			
			
			
		end
	})
	
	
	
	
end


