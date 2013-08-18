local GameWorld = {}

function GameWorld:new(level,view)
	assert(level)
	assert(view)

	local gameWorld = display.newGroup()
	view:insert(gameWorld)
	gameWorld.obstacles = {}
	gameWorld.programmers = {}
	
	gameWorld.spawnTimeoutSetting = StageConstants['SPAWN_TIMEOUT_LEVEL_'..level]
	gameWorld.spawnTimeout = 0--gameWorld.spawnTimeoutSetting

	function gameWorld:update(delta)
		self:cleanObstacles()

		for i=1,#self.obstacles do
			self.obstacles[i]:update(delta)
		end
		for i=1,#self.programmers do
			self.programmers[i]:update(delta,self.obstacles)
		end

		self:updateSpawn(delta)
	end

	function gameWorld:cleanObstacles()
		for i=#self.obstacles,1,-1 do
			if self.obstacles[i]:isAlive() == false then
				display.remove(self.obstacles[i])
				table.remove(self.obstacles,i)
			end
		end
	end

	function gameWorld:updateSpawn(delta)
		gameWorld.spawnTimeout = gameWorld.spawnTimeout - delta
		if gameWorld.spawnTimeout <= 0 then
			gameWorld:spawnObstacle()
			gameWorld.spawnTimeout = gameWorld.spawnTimeoutSetting
		end
	end

	function gameWorld:getObstacleSpeed()
		return (math.random(5,10) / 10) * StageConstants.OBSTACLE_SPEED
	end

	function gameWorld:spawnObstacle()
		local x,y,speed
		if math.random() <= 0.5 then
			-- |
			if math.random() <= 0.5 then x = StageConstants.OBSTACLE_MARGIN else x = X - StageConstants.OBSTACLE_MARGIN end
			y = math.random() * Y
			if y < StageConstants.OBSTACLE_MARGIN then y = StageConstants.OBSTACLE_MARGIN end
			if y > Y - StageConstants.OBSTACLE_MARGIN then y = Y - StageConstants.OBSTACLE_MARGIN end
		else
			-- --
			if math.random() <= 0.5 then y = StageConstants.OBSTACLE_MARGIN else y = Y - StageConstants.OBSTACLE_MARGIN end
			x = math.random() * X
			if x < StageConstants.OBSTACLE_MARGIN then x = StageConstants.OBSTACLE_MARGIN end
			if x > X - StageConstants.OBSTACLE_MARGIN then x = X - StageConstants.OBSTACLE_MARGIN end
		end

		speed = Vector:new(math.random(),math.random()):unit():mul(self:getObstacleSpeed())

		local obstacle = Obstacle:new(StageConstants.OBSTACLE_WIDTH,StageConstants.OBSTACLE_HEIGHT)
		obstacle.x,obstacle.y = x,y
		obstacle.speed = speed

		self:addObstacle(obstacle)
	end


	function gameWorld:addObstacle(obstacle)
		logger:unitEvent('Added obstacle')
		self:insert(obstacle)
		table.insert(self.obstacles,obstacle)
	end

	function gameWorld:addProgrammer(programmer)
		logger:unitEvent('Added obstacle')
		self:insert(programmer)
		table.insert(self.programmers,programmer)
	end

	return gameWorld
end

return GameWorld