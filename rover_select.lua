

Rover_select = r.layer
Rover_select.bg = r.images.select_bg

Rover_select.pages = r.sprite
local pages = Rover_select.pages


Rover_select.overL = r.images.over_scroll {
	x = 500,
	y = 1920,
	rotation = 180,
	alpha = 0
}

Rover_select.overR = r.images.over_scroll {
	x = 1080 - 500,
	alpha = 0
}

local splash = r.sprite

splash.chi = r.images.chi {
	x = 540,
	y = 1150
}

splash.chi:setAnchorPosition(983 / 2, 983 / 2)

splash.logo = r.images.logo {
	x = 520,
	y = 370,
	alpha = 0.9
}

splash.logo:setAnchorPosition(783 / 2, 348 / 2)



pages[1] = splash


for page_id = 2, 4 do

	pages[page_id] = r.sprite {
		x = 1080 * page_id - 1080
	}
	local page = pages[page_id]

	for y = 1, 3 do
		for x = 1, 3 do
			local lvl = y * 3 - 3 + x
			local abs_lvl = lvl + ((page_id - 1) * 9 - 9)
			
			page["back_"..lvl] = r.images.mini_sample_bg {
				x = 288 * x - 144 + 8,
				y = 572 * y - 280 - 45
			}
			local back = page["back_"..lvl]
			back:setAnchorPosition(20, 15)
			
			back.sample = r.levels["level_"..abs_lvl] {
				x = 10,
				y = 7
			}
			
			local state = Progress.getState(abs_lvl)
			local img = "question"
			
			if state == "1" then
			   img = "progress"
			elseif state == "2" then
				img = "check"
			end
			
			page["state_"..lvl] = r.sprite {
				x = 288 * x - 144 + 30,
				y = 572 * y - 500
			}
			
			page["state_"..lvl].img = r.images[img]
		end
	end
end

local final_page = r.images.final {
	x = 4320
}

final_page:setClip(0, 0, 1080, 1920)

final_page.img = r.congrats {
	x = 540,
	y = 1920 / 2,
	scaleX = 1.5,
	scaleY = 1.5
}

final_page.img:setAnchorPosition(593 / 2, 118 / 2)

final_page.lvl1 = r.levels.level_25 {
	x = 540,
	y = 960 - 400,
	scale = 2
}
final_page.lvl1:setAnchorPosition(216 / 2, 260 / 2)

GTween.new(final_page.lvl1, 2, {
	rotation = -360
}, {
	ease = easing.linear,
	repeatCount = math.huge
})

final_page.lvl2 = r.levels.level_27 {
	x = 540,
	y = 960 + 400,
	scale = 2
}
final_page.lvl2:setAnchorPosition(216 / 2, 260 / 2)

GTween.new(final_page.lvl2, 2, {
	rotation = 360
}, {
	ease = easing.linear,
	repeatCount = math.huge
})


--[[
local sparklesGFX = Texture.new("images/sparkle01.png")

sparkles1 = CParticles.new(sparklesGFX, 20, .5, .05, "add")
sparkles1:setRotation(10, -220, 10, 220)
sparkles1:setSize(1, 15)
sparkles1:setSpeed(200,300)
sparkles1:setDirection(0, 360)
sparkles1:setColor(200,60,200)
sparkles1:setColorMorphOut(60,60,60, .49, 255,255,255, .49)
sparkles1:setSizeMorphOut(0.1,4)
sparkles1:setGravity(0, 900)
sparkles1:setAlphaMorphOut(50, .3)
sparkles1:setLoopMode(1)

sparkles2 = CParticles.new(sparklesGFX, 20, 1, .05, "add")
sparkles2:setRotation(10, -220, 10, 220)
sparkles2:setSize(1, 15)
sparkles2:setSpeed(200,300)
sparkles2:setDirection(0, 360)
sparkles2:setColor(200,60,200)
sparkles2:setColorMorphOut(60,60,60, .99, 255,255,255, .99)
sparkles2:setSizeMorphOut(0.1,4)
sparkles2:setGravity(0, 900)
sparkles2:setAlphaMorphOut(50, .3)
sparkles2:setLoopMode(1)

sparkles3 = CParticles.new(sparklesGFX, 20, 1.5, .05, "add")
sparkles3:setRotation(10, -220, 10, 220)
sparkles3:setSize(1, 15)
sparkles3:setSpeed(200,300)
sparkles3:setDirection(0, 360)
sparkles3:setColor(200,60,200)
sparkles3:setColorMorphOut(60,60,60, 1.49, 255,255,255, 1.49)
sparkles3:setSizeMorphOut(0.1, 4)
sparkles3:setGravity(0, 900)
sparkles3:setAlphaMorphOut(50, .3)
sparkles3:setLoopMode(1)

emitter_1 = CEmitter.new(math.random(0, 1080), math.random(0, 1920),0, final_page.__obj)
emitter_2 = CEmitter.new(math.random(0, 1080), math.random(0, 1920),0, final_page.__obj)
emitter_3 = CEmitter.new(math.random(0, 1080), math.random(0, 1920),0, final_page.__obj)

emitter_1:assignParticles(sparkles1)
emitter_2:assignParticles(sparkles2)
emitter_3:assignParticles(sparkles3)


emitter_1:start()
emitter_2:start()
emitter_3:start()


local function onEmitterStop(event)
	local maxlife = math.random(5, 30)/10
	sparkles1:setColor(255, 0, 0)
	sparkles1:setColorMorphOut(60,60,60, (maxlife), 255,255,255, maxlife)

	sparkles1:setGravity(math.random(-300, 300), math.random(50, 1200))
	sparkles1:setSpeed(100,300)
	sparkles1:setAlphaMorphOut(50, .3)
	sparkles1:setMaxLife(maxlife)
	emitter_1:setPosition(math.random(144, 1080 - 144), math.random(288, 1920 - 288))
	emitter_1:start()
end

local function onEmitter2Stop(event)
	local maxlife = math.random(5, 30)/10
	sparkles2:setColor(0, 255, 0)
	sparkles2:setColorMorphOut(60,60,60, maxlife, 255,255,255, maxlife)
	sparkles2:setGravity(math.random(-300, 300), math.random(50, 1200))
	sparkles2:setSpeed(100,300)
	sparkles2:setAlphaMorphOut(50, .3)
	sparkles2:setMaxLife(maxlife)
	emitter_2:setPosition(math.random(144, 1080 - 144), math.random(288, 1920 - 288))
	emitter_2:start()
end

local function onEmitter3Stop(event)
	local maxlife = math.random(5, 30)/10
	sparkles3:setColor(0, 0, 255)
	sparkles3:setColorMorphOut(60,60,60, maxlife, 255,255,255, maxlife)
	sparkles3:setGravity(math.random(-300, 300), math.random(50, 1200))
	sparkles3:setSpeed(100,300)
	sparkles3:setAlphaMorphOut(50, .3)
	sparkles3:setMaxLife(maxlife)
	emitter_3:setPosition(math.random(144, 1080 - 144), math.random(288, 1920 - 288))
	emitter_3:start()
end



emitter_1:addEventListener("EMITTER_FINISHED", onEmitterStop, event)
emitter_2:addEventListener("EMITTER_FINISHED", onEmitter2Stop, event)
emitter_3:addEventListener("EMITTER_FINISHED", onEmitter3Stop, event)
]]


pages[5] = final_page


Rover_select.level_numbers = level_numbers() {
	y = 1920 - 150
}


Rover_select.overlay = r.images.select_overlay

Rover_select.level_numbers.setMax(Progress.determineMaxPage())
