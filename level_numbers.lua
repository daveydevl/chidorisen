
local colors = {
	{182, 226, 254},
	{204, 0, 99},
	{134, 38, 155},
	{0, 183 - 30, 150 - 30},
	{182, 226, 254}
}

function level_numbers()
	local wrapper = r.sprite
	
	for i = 1, 5 do
		local color = colors[i]
		
		
		wrapper["n_glow_"..i] = r.images.glow {
			x = 137 * i + 79 - 15 + 62,
			y = -15 + 62,
			redMultiplier = 3,
			greenMultiplier = 3,
			blueMultiplier = 1,
			alpha = i == 1 and 1 or 0
		}
		wrapper["n_glow_"..i]:setAnchorPosition(106, 106)
				
		local n = r.images["c_"..(i - 1)] {
			x = 137 * i + 79 - 15,
			y = -15
		}
		
		wrapper["n_"..i] = n
	end
	
	wrapper.setPercent = function(percent)
		for i = 1, 5 do
			wrapper["n_glow_"..i]:setAlpha(0)
		end
		
		if percent < 1 then
			percent = 1
		elseif percent > 5 then
			percent = 5
		end
		
		local lower = wrapper["n_glow_"..math.floor(percent)]
		local upper = wrapper["n_glow_"..math.ceil(percent)]
		
		local i, f = math.modf(percent)
		
		if i == 1 then
			--Rover_select.pages[1].logo:setY(400 - 600 * f)
			--Rover_select.pages[1].logo:setAlpha(1 - 1 * f)
			Rover_select.pages[1].chi:setRotation(-135 * f)
		end
		
		if i == 4 then
			wrapper:setAlpha(1 - 1 * f)
		end
		
		lower:setAlpha(1 - f)
		if lower ~= upper then
			upper:setAlpha(f)
		end
	end
	
	wrapper.setMax = function(page)
		wrapper.maxPage = page
		
		for i = 1, 5 do
			wrapper["n_"..i] {
				redMultiplier = 0.6,
			    greenMultiplier = 0.6,
			    blueMultiplier = 0.6
			}
		end
		
		for i = 1, page do
			local color = colors[i]
			
			wrapper["n_"..i] {
				redMultiplier = color[1] / 255,
				greenMultiplier = color[2] / 255,
				blueMultiplier = color[3] / 255,
			
			}
		end
	end
	
	return wrapper
end

