local world_factory = {}

local cheat = false

function world_factory.newWorld()
	local world = {
		scale = 10,
		terrain = nil,
		map = nil,
		grasses = {},
		walls = {},
		waters = {},
		grass_rgb = {r = 102, g = 57, b = 49},
		wall_rgb = {r = 75, g = 105, b = 47},
		water_rgb = {r = 99, g = 155, b = 255},
		player_rgb = {r = 91, g = 110, b = 225},
		heart_rbg = {r = 215, g = 123, b = 186},
		terrains = 0,
		tiles = {},
		player = nil,
		heart = nil,
		animate_cooldown = 0,
		basic_grasses = 2
	}

	local function colors_equal(r, g, b, t)
		return r * 255 == t.r and g * 255 == t.g and b * 255 == t.b
	end

	function world:load()
		love.graphics.setBackgroundColor(89 / 255, 193 / 255, 53 / 255, 1)

		self.terrain = love.graphics.newImage("terrain.png")
		self.terrain:setFilter("nearest", "nearest")

		for i = 0, 5 do
			self.grasses[i + 1] = love.graphics.newQuad(i * 8, 0, 8, 8, self.terrain:getDimensions())
		end

		for i = 0, 2 do
			self.walls[i + 1] = love.graphics.newQuad(i * 8, 8, 8, 8, self.terrain:getDimensions())
		end

		for i = 0, 1 do
			self.waters[i + 1] = love.graphics.newQuad(i * 8, 16, 8, 8, self.terrain:getDimensions())
		end

		self.terrains = #self.grasses + #self.walls + #self.waters

		self.map = love.image.newImageData("labyrinth.png")
		local mapWidth, mapHeight = self.map:getDimensions()
		for x = 0, mapWidth - 1 do
			self.tiles[x] = {}
			for y = 0, mapHeight - 1 do
				local r, g, b, a = self.map:getPixel(x, y)
				if colors_equal(r, g, b, self.grass_rgb) then
					if love.math.random(10) < 7 then
						self.tiles[x][y] = love.math.random(1, self.basic_grasses)
					else
						self.tiles[x][y] = love.math.random(self.basic_grasses + 1, #self.grasses)
					end
				elseif colors_equal(r, g, b, self.wall_rgb) then
					self.tiles[x][y] = love.math.random(#self.grasses + 1, #self.grasses + #self.walls)
				elseif colors_equal(r, g, b, self.water_rgb) then
					self.tiles[x][y] = #self.grasses + #self.walls + 1
				elseif colors_equal(r, g, b, self.player_rgb) then
					self.tiles[x][y] = self.terrains + 1
					self.player.position.x = x * 8
					self.player.position.y = y * 8
				elseif colors_equal(r, g, b, self.heart_rbg) then
					self.tiles[x][y] = self.terrains + 2
					self.heart.position.x = x * 8
					self.heart.position.y = y * 8
					-- For quickly viewing the ending
					if cheat then
						self.player.position.x = x * 8
						self.player.position.y = y * 8 + 8
					end
				else
					self.tiles[x][y] = love.math.random(#self.grasses + 1, #self.grasses + #self.walls)
				end
			end
		end

	end

	function world:draw()
		for x = 0, #self.tiles do
			for y = 0, #self.tiles[x] do
				local index = self.tiles[x][y]
				if index <= #self.grasses then
					love.graphics.draw(self.terrain, self.grasses[index], x * 8, y * 8)
				elseif index <= #self.grasses + #self.walls then
					love.graphics.draw(self.terrain, self.walls[index - #self.grasses], x * 8, y * 8)
				elseif index <= #self.grasses + #self.walls + #self.waters then
					if self.animate_cooldown >= 60 then
						index = index + 1
					end

					love.graphics.draw(self.terrain, self.waters[index - #self.grasses - #self.walls], x * 8, y * 8)
				elseif index == self.terrains + 1 then
					love.graphics.draw(self.terrain, self.grasses[2], x * 8, y * 8)
				elseif index == self.terrains + 2 then
					love.graphics.draw(self.terrain, self.grasses[2], x * 8, y * 8)
				end
			end
		end

		self.animate_cooldown = (self.animate_cooldown + 1) % 120
	end

	function world:isWall(x, y)
		local tile = self.tiles[x / 8][y / 8]
		return (tile > #self.grasses and tile <= self.terrains) or tile == 0
	end

	function world:isHeart(x, y)
		if x / 8 > #self.tiles or y / 8 > #self.tiles[0] then
			return false
		end

		local tile = self.tiles[x / 8][y / 8]
		return tile == self.terrains + 2
	end

	return world
end

return world_factory
