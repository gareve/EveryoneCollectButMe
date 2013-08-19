local Programmer = {}

function Programmer:new(width,height,speedCoefficient,name,goal)
	local programmer = display.newGroup()
	programmer.body = display.newRoundedRect(programmer,0,0,width,height,5)
	programmer.body:setReferencePoint(assert(display.CenterReferencePoint))
	programmer.body.x,programmer.body.y = 0,0

	programmer.speedCoefficient = assert(speedCoefficient)
	programmer.speed = Vector:new(0,0)
	programmer.approxRadius = width * 0.5

	programmer.heroForce = Vector:new(0,0)

	programmer.colors = {math.random(20,255),math.random(20,255),math.random(20,255)}
	programmer.body:setStrokeColor(programmer.colors[1],programmer.colors[2],programmer.colors[3])
	programmer.body.strokeWidth = 2
	programmer.body:setFillColor(programmer.colors[1],programmer.colors[2],programmer.colors[3],50)

	programmer.name = assert(name)
	programmer.nameText = display.newText(programmer,name,0,0,nil,7)
	programmer.nameText:setReferencePoint(assert(display.CenterReferencePoint))
	programmer.nameText.x,programmer.nameText.y = 0,height

	programmer.goal = assert(goal)
	programmer.goalText = display.newText(programmer,goal,0,0,nil,12)
	programmer.goalText.x,programmer.goalText.y = 0,0

	--Target vars
	programmer.target = nil

	programmer.alive = true
	function programmer:isAlive() return self.alive end
	function programmer:getVCenter() return Vector:new(self.x,self.y) end
	function programmer:won() return self.goal == 0 end

	function programmer:collide(obstacle)
		return GeometricUtils:pointInBox(self:getVCenter(),obstacle:getCorner1(),obstacle:getCorner2())
	end

	function programmer:update(delta,obstacles,hero)
		if __global_level >= 2 and self.alpha == 1.0 and math.random() <= StageConstants.VANISH_PROB then

			transition.to(
				programmer,
				{
					time = StageConstants.FADE_TIME * 1000,
					alpha = 0.1,
					onComplete = function()
						if programmer ~= nil then
							transition.to(
								programmer,
								{
									alpha = 1,
									time = StageConstants.FADE_TIME * 1000
								}
							)
						end
					end
				}
			)
		end

		local hc = hero:getVCenter()
		local pc = self:getVCenter()

		if self.alpha >= 0.8 and GeometricUtils:collideCircleCircle(pc,self.approxRadius,hc,hero.radius) then
			self.heroForce = pc:sub(hc):unit():mul(hero.speed:mod()*StageConstants.CRASH_COEFFICIENT)
		end

		if self.target ~= nil and self.target:isAlive() and self:collide(self.target) then
			self.target:kill()
			self.goal = self.goal - 1
			self.goalText.text = self.goal

			local rect = display.newRoundedRect(self.parent,0,0,StageConstants.OBSTACLE_WIDTH,StageConstants.OBSTACLE_WIDTH,2)
			rect:setReferencePoint(display.CenterReferencePoint)
			rect:setStrokeColor(self.colors[1],self.colors[2],self.colors[3],255)
			rect:setFillColor(self.colors[1],self.colors[2],self.colors[3],100)
			rect.strokeWidth = 2
			rect.x,rect.y = self.x,self.y

			transition.to(
				rect,
				{
					time = 2000,
					alpha = 0,
					width = StageConstants.OBSTACLE_WIDTH * 2,
					height = StageConstants.OBSTACLE_WIDTH * 2,
					onComplete = function()
						if rect  ~= nil then
							display.remove(rect)
						end
					end
				}
			)

		else
			self:setDirection(obstacles)			
		end
		self.heroForce:reduce(delta,StageConstants.HERO_FORCE_DECREASE)
		local tSpeed = self.speed:add(self.heroForce)

		local newX,newY = self.x + tSpeed.x*delta,self.y + tSpeed.y*delta
		if newX + self.approxRadius > X or newX - self.approxRadius < 0 then tSpeed.x = -tSpeed.x;self.heroForce.x = -self.heroForce.x end
		if newY + self.approxRadius > Y or newY - self.approxRadius < 0 then tSpeed.y = -tSpeed.y;self.heroForce.y = -self.heroForce.y end		

		self.x,self.y = self.x + tSpeed.x*delta,self.y + tSpeed.y*delta
	end

	function programmer:chooseNewTarget(obstacles)
		for i=1,#obstacles do
			local obstacle = obstacles[i]
			if obstacle:isAlive() and obstacle.programmerId == self.programmerId then 
				return obstacle
			end 
		end
		return nil
	end

	function programmer:setDirection(obstacles)
		if self.target == nil or self.target:isAlive() == false then
			self.target = self:chooseNewTarget(obstacles)
		end

		if self.target == nil then
			self.speed = Vector:new(0,0)
		else
			--TODO: check performance
			self.speed = self.target:getVCenter():sub(self:getVCenter()):unit():mul(self.speedCoefficient)
		end
	end

	return programmer
end

return Programmer