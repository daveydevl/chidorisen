


local textures = {}
local level_textures = {}
local fonts = {}

function preload(img)
	textures[img] = Texture.new("images/"..img..".png")
end

local preloads = {
	"block_h",
	"block_h_first",
	"block_h_first_simple",
	"block_h_last" ,
	"block_h_last_simple",
	"block_h_only",
	"block_h_only_simple",
	"block_h_simple",
	"block_v",
	"block_v_first",
	"block_v_first_simple",
	"block_v_last",
	"block_v_last_simple",
	"block_v_only",
	"block_v_only_simple",
	"block_v_simple",
	"c_0",
	"c_1",
	"c_2",
	"c_3",
	"c_4",
	"check",
	"glow",
	"hud",
	"level_bg",
	"mini_sample_bg",
	"over_scroll",
	"question",
	"quit",
	"retry",
	"sample_bg",
	"select_bg",
	"select_overlay",
	"stage_bg",
	"timer_bg"
}

for k, v in ipairs(preloads) do
	preload(v)
end
	

local smt = function(obj)
	local tmp = {}

	return setmetatable({__obj = obj}, {
		__newindex = function(arr, index, value)		
			if type(tmp[index]) == "table" and tmp[index].__obj then
				obj:removeChild(tmp[index].__obj)
			end
		
			if type(value) == "table" and value.__obj then
				obj:addChild(value.__obj)
			end
			
			tmp[index] = value
			obj[index] = value
		end,
		
		__call = function(arr, param)
			for k, v in pairs(param) do
				obj:set(k, v)
			end
			
			return arr
		end,
		
		__index = function(arr, index)
			if tmp[index] ~= nil then
				return tmp[index]
			elseif obj[index] ~= nil then
				return function(...)
					arg[1] = arg[1].__obj
					return obj[index](unpack(arg))
				end
			else
				return rawget(arr, index)
			end
		end
	})
end

local parts = {
	layer = function()
		local layer = Sprite.new()
		stage:addChild(layer)
		return layer
	end,
	
	sprite = function()
		return Sprite.new()
	end,
	
	viewport = function()
		return Viewport.new()
	end,
	
	congrats = function()
		local grid = TileMap.new(593, 118, Texture.new("images/congrats.png"), 593, 118)
		local n = 1
		local delay = 0
		
		grid:addEventListener(Event.ENTER_FRAME, function()
			delay = delay + 1
			if delay < 4 then
				return
			end
			delay = 0
		
			grid:setTile(1, 1, 1, n)
			
			n = n + 1
			if n > 8 then
				n = 1
			end
		end)
		
		return grid
	end,
	
	number = function()
		local grid = TileMap.new(77, 135, Texture.new("images/numbers.png"), 77, 135)
		local n = 0
		
		grid.setNumber = function(num)
			grid:setTile(1, 1, num + 1, 1)
			n = num
		end
		
		grid.getNumber = function()
			return n
		end
		
		return grid
	end
		
}

r = setmetatable({
	images = setmetatable({}, {
		__index = function(arr, image)
			if textures[image] == nil then
				textures[image] = Texture.new("images/"..image..".png")
			end
			
			return smt(Bitmap.new(textures[image]))
		end
	}),
	
	levels = setmetatable({}, {
		__index = function(arr, image)
			if level_textures[image] == nil then
				level_textures[image] = Texture.new("levels/"..image..".png")
			end
			
			return smt(Bitmap.new(level_textures[image]))
		end
	})
}, {
	__index = function(arr, index)
		if string.len(index) > 4 and string.sub(index, 1, 4) == "text" then
			local font = tonumber(string.sub(index, 5))
			if fonts[font] == nil then
				fonts[font] = TTFont.new("font.ttf", font)
			end
			return smt(TextField.new(fonts[font]))
		elseif parts[index] ~= nil then
			return smt(parts[index]())
		else
			assert(false, "'"..index .. "' is not a valid component!")
		end
	end
})

function exists(file)
    local f = io.open(file, "rb")
    if f == nil then
        return false
    end
    f:close()
    return true
end


