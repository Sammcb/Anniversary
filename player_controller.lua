local player_controller_factory = {}

function player_controller_factory.newPlayerController()
	local player_controller = {
		player = nil,
		world = nil,
		cooldown = 0
	}

	function player_controller:update(dt)
		if self.cooldown > 0 then
			self.cooldown = self.cooldown - self.player.speed
			return
		end

		if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
			if self.world:isWall(self.player.position.x, self.player.position.y - 8) then
				return
			end
			self.player:move(self.player.position.x, self.player.position.y - 8)
		elseif love.keyboard.isDown("a") or love.keyboard.isDown("left") then
			if self.world:isWall(self.player.position.x - 8, self.player.position.y) then
				return
			end
			self.player:move(self.player.position.x - 8, self.player.position.y)
		elseif love.keyboard.isDown("s") or love.keyboard.isDown("down") then
			if self.world:isWall(self.player.position.x, self.player.position.y + 8) then
				return
			end
			self.player:move(self.player.position.x, self.player.position.y + 8)
		elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
			if self.world:isWall(self.player.position.x + 8, self.player.position.y) then
				return
			end
			self.player:move(self.player.position.x + 8, self.player.position.y)
		end

		self.cooldown = 60
	end

	return player_controller
end

return player_controller_factory
