local save_file = "|D|progress.txt"

local states = {}
for i = 1, 27 do
	states[i] = "0"
end

local f = io.open(save_file, "r")
if f ~= nil then
    progress = f:read("*a")
	f:close()
	
	for i = 1, 27 do
		states[i] = "1" --string.sub(progress, i, i)
	end
end


Progress = {
    determineMaxPage = function()
		for i = 1, 27 do
			if states[i] == "0" then
				return math.floor((i - 1) / 9) + 2
			end
		end
		
		return 5
	end,
	
    getState = function(level)
		return states[level]
	end,

    setState = function(level, state)
		if states[level] ~= "2" then
			states[level] = state
		
			local f = io.open(save_file, "w")
			local text = ""
			
			for i = 1, 27 do
				text = text .. states[i]
			end
			
			f:write(text)
			f:close()
		end
		
		Rover_select.level_numbers.setMax(Progress.determineMaxPage())
	end
}
	
	
	