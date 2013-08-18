local Programmer = {}

function Programmer:new(width,height,speedCoefficient)
	local programmer = display.newGroup()
	programmer.body = display.newRect(programmer,0,0,width,height)
	programmer.body:setReferencePoint(assert(display.CenterReferencePoint))
	programmer.body.x,programmer.body.y = 0,0

	programmer.speedCoefficient = assert(speedCoefficient)
	programmer.speed = Vector:new(0,0)
	
	programmer.body:setStrokeColor(0,255,255)
	programmer.body.strokeWidth = 2
	programmer.body:setFillColor(0,255,0,0)	

	--Target vars
	programmer.target = nil

	programmer.alive = true
	function programmer:isAlive() return self.alive end
	function programmer:getVCenter() return Vector:new(self.x,self.y) end


	function programmer:collide(obstacle)
		return GeometricUtils:pointInBox(self:getVCenter(),obstacle:getCorner1(),obstacle:getCorner2())
	end

	function programmer:update(delta,obstacles)
		if self.target ~= nil and self.target:isAlive() and self:collide(self.target) then
			self.target:kill()
		else
			self:setDirection(obstacles)
			self.x,self.y = self.x + self.speed.x*delta,self.y + self.speed.y*delta	
		end
	end

	function programmer:chooseNewTarget(obstacles)
		for i=1,#obstacles do
			local obstacle = obstacles[i]
			if obstacle:isAlive() then 
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