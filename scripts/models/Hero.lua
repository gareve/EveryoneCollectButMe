local Hero = {}

function Hero:new(radius)
	local hero = display.newGroup()

	hero.body = display.newCircle(hero,0,0,assert(radius))
	hero.body:setReferencePoint(assert(display.CenterReferencePoint))
	hero.body.x,hero.body.y = 0,0
	hero.radius = radius

	hero.speed = Vector:new(0,0)
	
	hero.body:setStrokeColor(255,0,0)
	hero.body.strokeWidth = 2
	hero.body:setFillColor(255,0,0,50)

	hero.name = 'hero'
	hero.nameText = display.newText(hero.name,0,0,nil,7)
	hero.nameText:setReferencePoint(assert(display.CenterReferencePoint))
	hero.nameText.x,hero.nameText.y = 0,height

	hero.alive = true
	function hero:isAlive() return self.alive end
	function hero:kill() self.alive = false end

	function hero:getVCenter() return Vector:new(self.x,self.y) end
	function hero:update(delta)
		local newX,newY = self.x + self.speed.x*delta,self.y + self.speed.y*delta

		if newX + self.radius > X or newX - self.radius  < 0 then self.speed.x = -self.speed.x end
		if newY + self.radius > Y or newY - self.radius < 0 then self.speed.y = -self.speed.y end

		self.x,self.y = self.x + self.speed.x*delta,self.y + self.speed.y*delta
	end

	return hero
end

return Hero