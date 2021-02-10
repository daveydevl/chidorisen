


local block = function(bool, place, len, vp, styled)
	local wrapper = r.sprite
	
	local img_attach = ""
	
	if not styled then
		img_attach = "_simple"
	end

	local dir = "h"
	if bool then
		dir = "v"
	end
	
	wrapper.extend = -1
	
	wrapper:setAnchorPosition(50, 50)
	
	local ax, ay = 216 * -len + 108 - 36, 
	               216 * place - 72
				 
	if bool then
		ax, ay = ay, ax
	end
	
	wrapper {
		x = ax,
		y = ay
	}
	
	if len == 1 then
		wrapper.block_1 = r.images["block_"..dir.."_only"..img_attach]
	else
		wrapper.block_1 = r.images["block_"..dir.."_first"..img_attach]
		
		for i = 2, len do
			local ax, ay = 216 * i - 166, 0
			if bool then
				ax, ay = ay, ax
			end
			
			local name = "block_"..dir
			if i == len then
				name = name.."_last"
			end
			
			wrapper["block_"..i] = r.images[name..img_attach] {
				x = ax,
				y = ay
			}
			
		end
	end
	
	wrapper.len = len
	
	wrapper.dir = dir
	
	wrapper.place = place
	wrapper.aboves = {}
	
	wrapper.resetOne = function(which)
		which = which - wrapper.extend + 1
		
		if which < 1 or which > wrapper.len then
			return
		end
		
		wrapper.aboves[which] = nil
		
		local x, y = 216 * which - 166, 0
		if bool then
			x, y = y, x
		end
		
		if which == 1 then
			x, y = 0, 0
		end
		
		local st = wrapper["block_"..which]
		
		if st.__obj:getParent() ~= wrapper.__obj then
			st {
				redMultiplier = 1,
				greenMultiplier = 1,
				blueMultiplier = 1,
				x = x,
				y = y
			}
			
			wrapper:addChild(st.__obj)
		end
	end
	
	wrapper.above = function(index)
		local normal = index - wrapper.extend + 1
		
		if normal > len or normal < 1 then
			return
		end
		
		local b = wrapper["block_"..normal]
		wrapper.aboves[normal] = true
		b:setColorTransform(wrapper:getColorTransform())
		
		local x, y
		
		if bool then
			x = wrapper:getX() - 50
			y = 216 * wrapper.extend - 108 + b:getY() - 50
			
		else
			x = 216 * wrapper.extend - 108 + b:getX() - 50
			y = wrapper:getY() - 50
			
		end
		
		vp:addChild(b.__obj)
		
		b:setPosition(x, y)
	end
	
	return wrapper
end




local v_colors = {c.blue, c.red, c.green, c.orange}
local h_colors = {c.purple, c.blue2, c.pink, c.green2, c.yellow}


function blocks(bool, id, level, styled)
	if styled then
		id = id.."s"
	end

	local space = r.sprite
	
	local wrapper = r.sprite
	local viewports = r.sprite
	
	space.wrapper = wrapper
	space.viewports = viewports
	
	
	wrapper:setClip(0, 0, 1080, 1296)
	
	local vert = level[1]
	local hori = level[2]
	local laps = level[3]
	local vert_colors = level[4]
	local hori_colors = level[5]
	
	for i = 1, #vert do
		local vert_def = vert[i]
		
		if vert_def ~= "" then
		
			local len = tonumber(string.sub(vert[i], 1, 1))
			local extend = tonumber(string.sub(vert[i], 2, 3))
			
			local b = block(true, i, len, viewports, styled)
			b.extend = extend
			b:setY(216 * extend - 108)
			
			if bool then
				b.extend = -len + 1
				b:setY(216 * b.extend - 108 - 36)
			end
			
			local c = vert_colors[i]
			b:setColorTransform(c[1] / 255, c[2] / 255, c[3] / 255, 1)
			
			wrapper["block_v"..i] = b
			
		end
	end

	for i = 1, #hori do
		local hori_def = hori[i]
		
		if hori_def ~= "" then
		
			local len = tonumber(string.sub(hori[i], 1, 1))
			local extend = tonumber(string.sub(hori[i], 2, 3))
			
			local b = block(false, i, len, viewports, styled)
			b.extend = extend
			b:setX(216 * extend - 108)
			
			if bool then
				b.extend = -len + 1
				b:setX(216 * b.extend - 108 - 36)
			end
			
			local c = hori_colors[i]
			b:setColorTransform(c[1] / 255, c[2] / 255, c[3] / 255, 1)
			
			wrapper["block_h"..i] = b
			
		end
	end
	
	
	
	space.solve = function()
		for i = 1, #laps do
			local lap = laps[i]
			local b = wrapper["block_v"..i]
			
			for i2 = 1, string.len(lap) do
				local state = string.sub(lap, i2, i2)
				if state == "1" then
					b.above(i2)
				end
			end
		end
	end
	
	if not bool then
		space.solve()
	end
	
	
	return space

end

