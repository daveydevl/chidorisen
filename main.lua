application:setBackgroundColor(0x0)
application:setKeepAwake(false)

stage:setClip(0, 0, 1080, 3840)

--0 hidden
--1 shown
--2 shown with mark



enableTouch = true

current_block = nil

local previous = {}
local coord = {}
local stuck = false
local valid_x = false
local valid_y = false
local dir = 0

local stage_down = false
local stage_pos = {}


local prv = {0, 0}
local once = true
local page_prv = 0
local c_page = 1
local tap_item = 0
local last_diff = 0

stage:addEventListener(Event.MOUSE_DOWN, function(event)
	if not enableTouch then
		return
	end
	
	last_diff = 0
	
	local x, y = event.x - stage:getX(), event.y - stage:getY()
	
	if y > 0 and y <= 1920 then
		if y >= 1920 - 200 and y <= 1920 then
			if x >= 130 and x <= 880 then
				local page = math.floor((x + 28.2) / 160.2)
				
				if page > Progress.determineMaxPage() then
					return
				end
				
				c_page = page
				if Rover_select.pages.tween then
					Rover_select.pages.tween:setPaused(true)
					Rover_select.pages.tween = nil
				end
				
				Rover_select.pages.tween = GTween.new(Rover_select.pages, 1, {
					x = -1080 * c_page + 1080
				}, {
					ease = easing.outExponential,
					onChange = function()
						Rover_select.level_numbers.setPercent(-Rover_select.pages:getX() / 1080 + 1)
					end
				})
				
			end
			
			return
		end
		
		if Rover_select.pages.tween then
			Rover_select.pages.tween:setPaused(true)
			Rover_select.pages.tween = nil
		end
		stage_down = true
		once = true
		page_prv = Rover_select.pages:getX()
		stage_pos = {event.x, event.y}
		
		if c_page == 1 or c_page == 5 then
			return
		end
		
		for y = 1, 3 do
			for x = 1, 3 do
				local lvl = y * 3 - 3 + x 
				local dx = 288 * x - 144 + 8
				local dy = 572 * y - 280 - 45
				
				if event.x >= dx and event.x <= dx + 246 and event.y >= dy and event.y <= dy + 280 then
					tap_item = lvl
					return
				end
			end
		end
	
		return
	end
	

	if x >= 520 and x <= 1080 and y >= 208 + 1920 and y <= 416 + 1920 then
		
		local btn_id = 1
		if event.x > 800 then
			btn_id = 2
		end
		
		local btn_names = {"quit", "retry"}
		
		local btn = Rover_play[btn_names[btn_id]]
		btn:setColorTransform(2, 2, 2, 1)
		
		GTween.new(btn, 0.4, {
			redMultiplier = 1,
			greenMultiplier = 1,
			blueMultiplier = 1
		}, {
			ease = easing.linear
		})
		
		if btn_id == 1 then
			enableTouch = false
			GTween.new(stage, 1, {
				y = 0
			}, {
				ease = easing.inOutQuartic,
				onComplete = function()
					enableTouch = true
					
					local lvl = Rover_play.c_level
					local s_lvl = (lvl - 1) % 9 + 1
					local page = math.ceil(lvl / 9) + 1
					
					local state = Progress.getState(lvl)
					local img
					
					if state == "1" then
						img = r.images.progress
					elseif state == "2" then
						img = r.images.check
					else
						img = r.images.question
					end
					
					Rover_select.pages[page]["state_"..s_lvl].img = img {
						redMultiplier = 5,
						greenMultiplier = 5,
						blueMultiplier = 5
					}
					
					
					GTween.new(img, 2, {
						redMultiplier = 1,
						greenMultiplier = 1,
						blueMultiplier = 1
					}, {
						ease = easing.outExponential
					})
				end
			})
		elseif btn_id == 2 then
			Rover_play.reloadPlay()
		end
		
		return
	end
	
	if Rover_play.blocks and Rover_play.blocks.win then
		return
	end
	
	local cx = math.ceil((x - 108) / 216)
	local cy = math.ceil((y - 624 - 108 - 1920) / 216)
	
	valid_x = true
	valid_y = true
	
	if cx < 1 or cx > 4 then
		valid_x = false
	end
	
	if cy < 1 or cy > 5 then
		valid_y = false
	end
	
	previous = {x, y - 624}
	coord = {cx, cy}
	
	stuck = false

end)

local last_dir = false

local current_stuck = nil


stage:addEventListener(Event.MOUSE_MOVE, function(event)
	if not enableTouch then
		return
	end
	
	if stage_down then
		local dir = event.x - stage_pos[1]
		last_dir = dir > 0
		local diff = page_prv + dir
		
		last_diff = math.abs(dir)
		
		if last_diff > 10 and tap_item > 0 then
			tap_item = 0
		end
		
		local diff_stick = -1080 * Rover_select.level_numbers.maxPage + 1080
		
		if diff > 0 then
			local a = diff / 500 + prv[1]
			if a > 1 then
				a = 1
			end
			Rover_select.overL:setAlpha(a)
			
		elseif diff < diff_stick then
			local a = (-diff + diff_stick) / 500 + prv[2]
			if a > 1 then
				a = 1
			end
			Rover_select.overR:setAlpha(a)
		end
		
		if diff > 0 then
			diff = 0
		elseif diff < diff_stick then
			diff = diff_stick
		end
		
		Rover_select.pages:setX(diff)
		
		Rover_select.level_numbers.setPercent(-diff / 1080 + 1)
		
		
		
		
		if Rover_select.overL.tween then
			Rover_select.overL.tween:setPaused(true)
			Rover_select.overL.tween = nil
		end
		
		if Rover_select.overR.tween then
			Rover_select.overR.tween:setPaused(true)
			Rover_select.overR.tween = nil
		end
		
		if once then
			prv = {Rover_select.overL:getAlpha(), Rover_select.overR:getAlpha()}
			once = false
		end
		
	
		return
	end



	if not valid_x and not valid_y or (Rover_play.blocks and Rover_play.blocks.win) then
		return
	end

	local x, y = event.x, event.y - 624 + 1920
	local blocks = Rover_play.blocks.wrapper

	if stuck then
	
		if dir == 1 then
			stuck:setX(x - previous[1])
			
			local x = stuck:getX()
			
			local extend = math.floor((x + 108) / 216)
			
			for i = 1, extend - 1 do
				if i <= 4 then
					if blocks["block_v"..i] ~= nil then
						blocks["block_v"..i].resetOne(stuck.place)
					end
				end
			end
			
			for i = extend + stuck.len + 1, 4 do
				if i > 0 then
					if blocks["block_v"..i] ~= nil then
						blocks["block_v"..i].resetOne(stuck.place)
					end
				end
			end
		elseif dir == 2 then
			stuck:setY(y - previous[2])
			
			local y = stuck:getY()
			
			local extend = math.floor((y + 108) / 216)
			
			
			for i = 1, extend - 1 do
				if i <= 5 then
					if blocks["block_h"..i] ~= nil then
						blocks["block_h"..i].resetOne(stuck.place)
					end
				end
			end
			
			for i = extend + stuck.len + 1, 5 do
				if i > 0 then
					if blocks["block_h"..i] ~= nil then
						blocks["block_h"..i].resetOne(stuck.place)
					end
				end
			end
		end
	
		return
	end
	
	
	local diff = math.abs(previous[1] - x) - math.abs(previous[2] - y)
	
	if valid_y and diff >= 10 then
		
	
		stuck = blocks["block_h"..coord[2]]
		current_stuck = stuck
		if stuck == nil then
			return
		end
		
		
		if stuck.tween then
			stuck.tween:setPaused(true)
			stuck.tween = nil
		end
		
		
		
		local parent = stuck:getParent()
		
		for i = parent:getChildIndex(stuck.__obj) + 1, parent:getNumChildren() do
			local child = parent:getChildAt(i)
			
			if child.dir == "v" then
				local lower = stuck.extend
				local upper = lower + stuck.len - 1
				
				if child.place >= lower and child.place <= upper then
					if stuck.aboves[child.place - stuck.extend + 1] then
						stuck.resetOne(child.place)
					else
					    child.above(stuck.place)
					end
				end
			end
		end
		
		stuck:getParent():addChild(stuck.__obj)
		
		previous = {previous[1] - stuck:getX(), previous[2] - stuck:getY()}
		dir = 1
	elseif valid_x and diff <= -10 then
		stuck = blocks["block_v"..coord[1]]
		current_stuck = stuck
		
		if stuck == nil then
			return
		end
		
		
		if stuck.tween then
			stuck.tween:setPaused(true)
			stuck.tween = nil
		end
		
		
		
		local parent = stuck:getParent()
		
		for i = parent:getChildIndex(stuck.__obj) + 1, parent:getNumChildren() do
			local child = parent:getChildAt(i)
			
			
			
			
			if child.dir == "h" then
				local lower = stuck.extend
				local upper = lower + stuck.len - 1
				
				if child.place >= lower and child.place <= upper then
					if stuck.aboves[child.place - stuck.extend + 1] then
						stuck.resetOne(child.place)
					else
					    child.above(stuck.place)
					end
				end
			end
		end
		
		stuck:getParent():addChild(stuck.__obj)
		
		previous = {previous[1] - stuck:getX(), previous[2] - stuck:getY()}
		dir = 2
	elseif math.abs(diff) >= 10 then
		valid_x = false
		valid_y = false
	end
	
	
	
	
	
end)

stage:addEventListener(Event.MOUSE_UP, function(event)
	if not enableTouch then
		return
	end
	
	if stage_down then
		
		local push = -0.4
		if last_dir then
			push = -push
		end
			
		c_page = 1 - math.floor(Rover_select.pages:getX() / 1080 + 0.5 + push)
		Rover_select.pages.tween = GTween.new(Rover_select.pages, 0.5, {
			x = math.floor(Rover_select.pages:getX() / 1080 + 0.5 + push) * 1080
		}, {
			ease = easing.outExponential,
			onChange = function()
				Rover_select.level_numbers.setPercent(-Rover_select.pages:getX() / 1080 + 1)
			end
		})
		
		if Rover_select.overL.tween then
			Rover_select.overL.tween:setPaused(true)
			Rover_select.overL.tween = nil
		end
		
		if Rover_select.overR.tween then
			Rover_select.overR.tween:setPaused(true)
			Rover_select.overR.tween = nil
		end
	
		Rover_select.overL.tween = GTween.new(Rover_select.overL, 0.5, {
			alpha = 0
		})
		
		Rover_select.overR.tween = GTween.new(Rover_select.overR, 0.5, {
			alpha = 0
		})
		
		stage_down = false
		
		if last_diff <= 10 then
			if c_page == 5 then
				return
			end
			if c_page == 1 then
				
				c_page = 2
				if Rover_select.pages.tween then
					Rover_select.pages.tween:setPaused(true)
					Rover_select.pages.tween = nil
				end
				
				Rover_select.pages.tween = GTween.new(Rover_select.pages, 1, {
					x = -1080
				}, {
					ease = easing.outExponential,
					onChange = function()
						Rover_select.level_numbers.setPercent(-Rover_select.pages:getX() / 1080 + 1)
					end
				})
				
				return
			end
			
			for y = 1, 3 do
				for x = 1, 3 do
					local lvl = y * 3 - 3 + x
					local r_lvl = lvl + (c_page * 9 - 9)
					local dx = 288 * x - 144 + 8
					local dy = 572 * y - 280 - 45
					
					if event.x >= dx and event.x <= dx + 246 and event.y >= dy and event.y <= dy + 280 then
						local back = Rover_select.pages[c_page]["back_"..lvl]
						back:setAlpha(2)
						
						Rover_sample.setSample(r_lvl - 9)
						Rover_play.setPlay(r_lvl - 9)
						Rover_play.setMoves(levels[r_lvl - 9][6])
						
						
						GTween.new(back, 0.5, {
							alpha = 1
						}, {
							ease = easing.outExponential
						})
						
						enableTouch = false
						
						GTween.new(stage, 1, {
							y = -1920
						}, {
							ease = easing.inOutQuartic,
							onComplete = function()
								enableTouch = true
							end
						})
						
						return
					end
				end
			end
		end
		
		return
	
	end
	
	if Rover_play.blocks and Rover_play.blocks.win then
		return
	end

	valid_x = false
	valid_y = false

	if stuck then
	
		local x, y
		
		if dir == 1 then
			local cx = math.floor((stuck:getX() + 108) / 216 + 0.5)
			local bool_left, bool_right = false, false
			
			if cx <= -stuck.len + 1 then
				cx = -stuck.len + 1
				bool_left = true
			elseif cx >= 5 then
				cx = 5
				bool_right = true
			end
			
			stuck.extend = cx
			
			
			x = cx * 216 - 108
			if bool_left then
				x = x - 36
			elseif bool_right then
				x = x + 36
			end
			
			y = stuck:getY()
			
		elseif dir == 2 then
			local cy = math.floor((stuck:getY() + 108) / 216 + 0.5)
			local bool_left, bool_right = false, false
			
			if cy <= -stuck.len + 1 then
				cy = -stuck.len + 1
				bool_left = true
			elseif cy >= 6 then
				cy = 6
				bool_right = true
			end
			
			stuck.extend = cy
			
			x = stuck:getX()
			y = cy * 216 - 108
			if bool_left then
				y = y - 36
			elseif bool_right then
				y = y + 36
			end
		end
		
		
		if stuck ~= current_block then
			Rover_play.increaseMoves()
		end
		
		current_block = stuck
		
		local s = stuck
		
		stuck.tween = GTween.new(stuck, 0.5, {
			x = x,
			y = y
		}, {
			ease = easing.outExponential,
			onComplete = function()
				if s ~= current_stuck then
					return
				end
			
			    if isSolved() then
					enableTouch = false
					
					local state = "1"
					local img = "passed"
					if Rover_play.c_moves <= Rover_play.max_moves then
						state = "2"
						img = "excellent"
					end
					
					Progress.setState(Rover_play.c_level, state)
					
					Rover_play.blocks.win = r.images[img] {
						x = 540,
						y = 648,
						scaleX = 10,
						scaleY = 10,
						alpha = 0
					}
					Rover_play.blocks.win:setAnchorPosition(802 / 2, 678 / 2)
					GTween.new(Rover_play.blocks.win, 1, {
						scaleX = 1,
						scaleY = 1,
						alpha = 1
					}, {
						ease = easing.inQuartic,
						onComplete = function()
							enableTouch = true
						end
					})
					
				end
			end
		})
		
	end

	stuck = nil
	
	
end)

