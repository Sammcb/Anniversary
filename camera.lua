local camera_factory = {}

function camera_factory.newCamera()
	local camera = {
		player = nil,
		world = nil,
		position = {x = 0, y = 0},
		scale = {x = 1, y = 1},
		angle = 0
	}

	function camera:load()
		self:setPosition(self.player.position.x, self.player.position.y)
		self:setScale(2)
	end

	function camera:set()
		-- self.position.x = love.graphics.getWidth() / 2
		-- self.position.y = love.graphics.getHeight() / 2
		love.graphics.push()
		love.graphics.rotate(-self.angle)
		love.graphics.scale(1 / self.scale.x, 1 / self.scale.y)
		-- love.graphics.translate(-self.position.x + 50, -self.position.y + 50)
		love.graphics.translate(-self.position.x + love.graphics.getWidth() / 2 * self.scale.x, -self.position.y + love.graphics.getHeight() / 2 * self.scale.y)
	end

	function camera:unset()
		love.graphics.pop()
	end

	function camera:update(dt)
		self:setPosition(self.player.position.x, self.player.position.y)
	end

	function camera:moveBy(dx, dy)
		self.position.x = self.position.x + dx
		self.position.y = self.position.y + dy
	end

	function camera:rotateBy(dr)
		self.angle = self.angle + dr
	end

	function camera:scaleBy(sx, sy)
		self.scale.x = self.scale.x * sx
		self.scale.y = self.scale.y * (sy or sx)
	end

	function camera:setPosition(x, y)
		self.position.x = x
		self.position.y = y
	end

	function camera:setScale(sx, sy)
		self.scale.x = 1 / sx
		self.scale.y = 1 / (sy or sx)
	end

	return camera
end

return camera_factory
