-- main.lua, only source file of 'Life of Land Shark'
-- licensed under the zlib license but I haven't understood
-- LOVE animations yet and suppose that my use of them is
-- wrong, so this piece is probably worthless for derivation
-- anyways.

function load()

	-- create shark (class?)
	shark = {
		sound = {
			bites = {},
		},
		anim = {
			walk = {},
			bite = {},
		},
	}
	
	-- load bite sounds
	shark.sound.bites = {
		love.audio.newSound("sound/land_shark_bite_1.ogg"),
		love.audio.newSound("sound/land_shark_bite_2.ogg"),
		love.audio.newSound("sound/land_shark_bite_3.ogg"),
		love.audio.newSound("sound/land_shark_bite_4.ogg"),
		love.audio.newSound("sound/land_shark_bite_5.ogg"),
		love.audio.newSound("sound/land_shark_bite_6.ogg"),
		love.audio.newSound("sound/land_shark_bite_7.ogg"),
	}
	
	-- load walk animation
	shark.anim.walk.left = love.graphics.newAnimation(love.graphics.newImage("animation/land_shark_walk_left.png"), 28, 2, 0.15)
	shark.anim.walk.right = love.graphics.newAnimation(love.graphics.newImage("animation/land_shark_walk_right.png"), 28, 2, 0.15)
	
	-- load bite animation
	shark.anim.bite.left = love.graphics.newAnimation(love.graphics.newImage("animation/land_shark_bite_left.png"), 28, 22, 0.1)
	shark.anim.bite.right = love.graphics.newAnimation(love.graphics.newImage("animation/land_shark_bite_right.png"), 28, 22, 0.1)

	-- init shark status
	shark.bites = false
	shark.walks = false
	shark.facesLeft = false
	shark.position = 233

	-- shark's speed
	shark.speed = 20

	-- colors
	colors = {
		blue = love.graphics.newColor(030,115,175),
		green = love.graphics.newColor(070,155,090),
		grey = love.graphics.newColor(117,114,120),
	}
	love.graphics.setBackgroundColor(love.graphics.newColor(145,185,185))

	dtSum = 0 -- used for periodically start/stop walking, biting and changing direction
	dtLimit = 1 -- intervall in which updates to previously mentioned attributes happen
	-- key/control management
	keyDown = {
		left = false,
		right = false,
		space = false,
	}
end

function update(dt)
	dtSum = dtSum + dt
	-- randomly walk/bite/changedirection
	if keyDown.left == false and keyDown.right == false and keyDown.space == false and dtSum > dtLimit then
		dtSum = dtSum - dtLimit
		if math.random(1,3) == 1 then -- start/stop walking
			shark.walks = not shark.walks
		end
		if math.random(1,3) == 1 then -- bite
			shark.bites = true
			love.audio.play(shark.sound.bites[math.random(1,#shark.sound.bites)])
		end
		if math.random(1,6) == 1 then -- change direction
			shark.facesLeft = not shark.facesLeft
		end
	end
	--refresh shark position
	if shark.walks then
		if shark.facesLeft then
			shark.position = shark.position - shark.speed * dt
		else
			shark.position = shark.position + shark.speed * dt
		end
	end
	-- refresh walk animation
	if shark.walks then
		shark.anim.walk.left:update(dt)
		shark.anim.walk.right:update(dt)
	end
	-- refresh bite animation
	if shark.bites then
		shark.anim.bite.left:update(dt)
		shark.anim.bite.right:update(dt)
		if shark.anim.bite.left:getCurrentFrame() == 3 then
			shark.bites = false
			shark.anim.bite.left:reset()
			shark.anim.bite.right:reset()
		end
	end
	-- over-border-walking-prevention
	if shark.position > 600 then shark.facesLeft = true end
	if shark.position < 60 then shark.facesLeft = false end
end

function draw()
	-- draw floor, water, rock
	love.graphics.setColor(colors.green)
	love.graphics.rectangle(0,0,72,640,56)
	love.graphics.setColor(colors.blue)
	love.graphics.rectangle(0,0,72,60,56)
	love.graphics.setColor(colors.grey)
	love.graphics.rectangle(0,600,0,40,80)
	-- draw shark
	if shark.facesLeft then
		love.graphics.draw(shark.anim.walk.left, shark.position, 80)
		love.graphics.draw(shark.anim.bite.left, shark.position, 68)
	else
		love.graphics.draw(shark.anim.walk.right, shark.position, 80)
		love.graphics.draw(shark.anim.bite.right, shark.position, 68)
	end

end

function keypressed(key)
	if key == love.key_space then
		keyDown.space = true
		shark.bites = true
		love.audio.play(shark.sound.bites[math.random(1,#shark.sound.bites)])
	elseif key == love.key_left then
		keyDown.left = true
		shark.facesLeft = true
		shark.walks = true
	elseif key == love.key_right then
		keyDown.right = true
		shark.facesLeft = false
		shark.walks = true
	end
end

function keyreleased(key)
	if key == love.key_space then
		keyDown.space = false
	elseif key == love.key_left then
		keyDown.left = false
		shark.walks = false
	elseif key == love.key_right then
		keyDown.right = false
		shark.walks = false
	end
end
