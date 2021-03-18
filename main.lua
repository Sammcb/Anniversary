local world_factory = require("world")
local player_controller_factory = require("player_controller")
local player_factory = require("player")
local camera_factory = require("camera")

local world = world_factory.newWorld()
local player_controller = player_controller_factory.newPlayerController()
local player = player_factory.newPlayer()
local camera = camera_factory.newCamera()
local heart = player_factory.newPlayer()

local music = love.audio.newSource("ambient.wav", "stream")
local ending_music = love.audio.newSource("ending.wav", "stream")

local cutscene = false
-- local font = love.graphics.newFont("fontName.ttf", 14)
local font = love.graphics.getFont()
local cutscene_text_0 = love.graphics.newText(font, "Brooke")
local cutscene_text_1 = love.graphics.newText(font, "I'm so glad I found you while exploring the labyrinth of life.")
local cutscene_text_2 = love.graphics.newText(font, "I can't wait to navigate the future together :)")
local cutscene_text_3 = love.graphics.newText(font, "Happy anniversary")
local full_heart = love.graphics.newImage("fullheart.png")
full_heart:setFilter("nearest", "nearest")
local cutscene_text_4 = love.graphics.newText(font, "Sam")
local cutscene_timer = 0
local ending = false
local moveCount = 0

local background_tiles = {}

function love.load()
	love.math.setRandomSeed(0)

	player:load()

	heart.sprite = love.graphics.newImage("heart.png")
	heart.sprite:setFilter("nearest", "nearest")

	world.player = player
	world.heart = heart
	world:load()

	camera.player = player
	camera.world = world
	camera:load()

	player_controller.player = player
	player_controller.world = world

	music:setLooping(true)
	music:play()

	ending_music:setLooping(true)

	for x = 0, 256 do
		background_tiles[x] = {}
		for y = 0, 128 do
			if love.math.random(10) < 7 then
				background_tiles[x][y] = love.math.random(1, world.basic_grasses)
			else
				background_tiles[x][y] = love.math.random(world.basic_grasses + 1, #world.grasses)
			end
		end
	end
end

function love.update(dt)
	if world:isHeart(player.position.x, player.position.y) and not cutscene then
		cutscene = true
		music:stop()
		ending_music:play()
	end

	if not cutscene then
		player_controller:update(dt)
		camera:update(dt)	
	end

	if cutscene then
		cutscene_timer = cutscene_timer + 1
		if camera.scale.x < 1 then
			camera:scaleBy(1.005)
		end

		if camera.position.x > world.map:getWidth() * 4 then
			camera:moveBy(-1, 0)
		elseif not ending then
			ending = true
		end
	end

	if ending then
		if moveCount % 60 == 0 and moveCount < 1200 then
			player:move(player.position.x + 8, player.position.y)
			heart:move(heart.position.x + 8, heart.position.y)
		end
		moveCount = moveCount + 1
	end
end

function love.draw()
	camera:set()
	for x = 0, 256 do
		for y = 0, 128 do
			local index = background_tiles[x][y]
			love.graphics.draw(world.terrain, world.grasses[index], (x - 64) * 8, (y - 32) * 8)
		end
	end
	world:draw()
	player:draw()
	heart:draw()
	camera:unset()

	if ending then
		local r, g, b, a = love.graphics.getColor()
		love.graphics.setColor(0, 0, 0, moveCount / 1200)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		love.graphics.setColor(r, g, b, a)
	end

	if cutscene then
		love.graphics.draw(cutscene_text_0, love.graphics.getWidth() / 2, 50, 0, 1, 1, cutscene_text_0:getWidth() / 2, cutscene_text_0:getHeight() / 2)

		if cutscene_timer > 60 then
			love.graphics.draw(cutscene_text_1, love.graphics.getWidth() / 2, 100, 0, 1, 1, cutscene_text_1:getWidth() / 2, cutscene_text_1:getHeight() / 2)
		end

		if cutscene_timer > 120 then
			love.graphics.draw(cutscene_text_2, love.graphics.getWidth() / 2, 150, 0, 1, 1, cutscene_text_2:getWidth() / 2, cutscene_text_2:getHeight() / 2)
		end

		if cutscene_timer > 180 then
			love.graphics.draw(cutscene_text_3, love.graphics.getWidth() / 2, 200, 0, 1, 1, cutscene_text_3:getWidth() / 2, cutscene_text_3:getHeight() / 2)
		end

		if cutscene_timer > 240 then
			love.graphics.draw(full_heart, love.graphics.getWidth() / 2, 250, 0, 8, 8, full_heart:getWidth() / 2, full_heart:getHeight() / 2)
		end

		if cutscene_timer > 300 then
			love.graphics.draw(cutscene_text_4, love.graphics.getWidth() / 2, 300, 0, 1, 1, cutscene_text_4:getWidth() / 2, cutscene_text_4:getHeight() / 2)
		end
	end
end
