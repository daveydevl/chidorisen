

function generateSignature(which)
	local v_laps = {}
	for x = 1, 4 do
		v_laps[x] = {}
		for y = 1, 5 do
			v_laps[x][y] = false
		end
	end
	
	for x = 1, 4 do
		local vert = which["block_v"..x]
		
		if vert ~= nil then
			local parent = which
			
			for ii = 1, vert.len do
			    v_laps[x][ii] = vert.aboves[ii] or false
				
				if not v_laps[x][ii] then
					local h_block = which["block_h"..(vert.extend + ii - 1)]
					if h_block ~= nil then
						local lower = h_block.extend
						local upper = lower + h_block.len - 1
						
						if x < lower or x > upper then
							v_laps[x][ii] = true
						elseif h_block.aboves[x - h_block.extend + 1] then
							v_laps[x][ii] = false
						else
							
							if parent:getChildIndex(vert.__obj) > parent:getChildIndex(h_block.__obj) then
								v_laps[x][ii] = true
							else
								v_laps[x][ii] = false
							end
						end
					end
				end
			end
		end
	end
	
	return v_laps
end

function cmpSig(sig1, sig2)
	for x = 1, 4 do
		for y = 1, 5 do
			if sig1[x][y] ~= sig2[x][y] then
				return false
			end
		end
	end
	
	return true
end

function isSolved()

	local level = levels[Rover_play.c_level]
				
	local top = level[1]
	local left = level[2]
	local laps = level[3]
	local blocks = Rover_play.blocks.wrapper
	
	
	for i = 1, #top do
		local vert_def = top[i]
		
		if vert_def ~= "" then
			local vert_extend = tonumber(string.sub(vert_def, 2, 2))
			
			
			if blocks["block_v"..i].extend ~= vert_extend then
				return false
			end
		end
	end
	
	for i = 1, #left do
		local hori_def = left[i]
		
		if hori_def ~= "" then
			local hori_extend = tonumber(string.sub(hori_def, 2, 2))
			
			if blocks["block_h"..i].extend ~= hori_extend then
				return false
			end
		end
	end
	
	local laps1 = generateSignature(Rover_play.blocks.wrapper)
	local laps2 = generateSignature(Rover_sample.blocks.wrapper)
	
	return cmpSig(laps1, laps2)
end