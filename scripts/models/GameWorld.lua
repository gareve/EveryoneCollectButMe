local GameWorld = {}

function GameWorld:new(level,view,hero)
	assert(level)
	assert(view)
	assert(hero)

	local gameWorld = display.newGroup()
	view:insert(gameWorld)
	gameWorld.obstacles = {}
	gameWorld.programmers = {}
	
	gameWorld.spawnTimeoutSetting = StageConstants['SPAWN_TIMEOUT_LEVEL_'..level]
	gameWorld.spawnTimeout = 0--gameWorld.spawnTimeoutSetting

	gameWorld.hero = hero
	gameWorld.ids = 0

	gameWorld.time = StageConstants['STAGE_TIME_LEVEL_' .. level]

	function gameWorld:programmersWon()
		for i=1,#self.programmers do
			if self.programmers[i]:won() then
				return assert(self.programmers[i].name)
			end
		end
		return nil
	end

	function gameWorld:programmersLose()
		return self.time <= 0
	end

	function gameWorld:update(delta)
		self:cleanObstacles()
		self.time = self.time - delta

		for i=1,#self.obstacles do
			self.obstacles[i]:update(delta)
		end
		for i=1,#self.programmers do
			self.programmers[i]:update(delta,self.obstacles,self.hero)
		end

		self.hero:update(delta)

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
		if #self.programmers == 0 then return end

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

		local rndIndex = math.random(1,#self.programmers)

		local obstacle = Obstacle:new(StageConstants.OBSTACLE_WIDTH,StageConstants.OBSTACLE_HEIGHT,self.programmers[rndIndex])
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
		programmer.programmerId = self.ids
		self.ids = self.ids + 1
		table.insert(self.programmers,programmer)
	end

	return gameWorld
end

return GameWorld