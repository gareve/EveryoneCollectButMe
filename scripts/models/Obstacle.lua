local Obstacle = {}

function Obstacle:new(width,height)
	local obstacle = display.newGroup()

	obstacle.body = display.newRect(obstacle,0,0,width,height)
	obstacle.body:setReferencePoint(assert(display.CenterReferencePoint))
	obstacle.body.x,obstacle.body.y = 0,0
	obstacle.midWidth = width * 0.5
	obstacle.midHeight = height * 0.5

	obstacle.speed = Vector:new(0,0)
	
	obstacle.body:setStrokeColor(0,255,0)
	obstacle.body.strokeWidth = 2
	obstacle.body:setFillColor(0,255,0,0)

	obstacle.alive = true
	function obstacle:isAlive() return self.alive end
	function obstacle:kill() self.alive = false end

	function obstacle:getVCenter() return Vector:new(self.x,self.y) end
	function obstacle:update(delta)
		local newX,newY = self.x + self.speed.x*delta,self.y + self.speed.y*delta

		if newX + self.midWidth > X or newX - self.midWidth  < 0 then self.speed.x = -self.speed.x end
		if newY + self.midHeight > Y or newY - self.midHeight < 0 then self.speed.y = -self.speed.y end

		self.x,self.y = self.x + self.speed.x*delta,self.y + self.speed.y*delta
	end

	function obstacle:getCorner1() return Vector:new(self.contentBounds.xMin,self.contentBounds.yMin) end
	function obstacle:getCorner2() return Vector:new(self.contentBounds.xMax,self.contentBounds.yMax) end

	return obstacle
end

return Obstacle