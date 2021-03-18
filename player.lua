local player_factory = {}

function player_factory.newPlayer()
	local player = {
		sprite = nil,
		position = {x = 0, y = 0},
		scale = 1,
		speed = 12,
		anchor = {x = 0, y = 0}
	}

	function player:load()
		self.sprite = love.graphics.newImage("player.png")
		self.sprite:setFilter("nearest", "nearest")
	end

	function player:draw()
		love.graphics.draw(self.sprite, self.position.x, self.position.y, 0, self.scale, self.scale, self.anchor.x, self.anchor.y)
	end

	function player:move(x, y)
		self.position.x = x
		self.position.y = y
	end

	return player
end

return player_factory
