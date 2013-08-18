local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

function scene:updateLevelCallback()
return function(delta)
	scene.gameWorld:update(delta)
	scene:updateHUD()
end
end

function scene:createGameObjects()
   self.timeText = display.newText(scene.view,'CUack',0,0,nil,15)
   self.timeText:setReferencePoint(assert(display.BottomRightReferencePoint))
   self.timeText.x,self.timeText.y = X,Y

   local timeBox = display.newRect(scene.view,0,0,self.timeText.contentWidth,self.timeText.contentHeight)
   timeBox:setReferencePoint(assert(display.BottomRightReferencePoint))
   timeBox:setFillColor(255,255,255,40)
   timeBox.x,timeBox.y = X,Y

   local hero = Hero:new(StageConstants.HERO_RADIUS)
   self.gameWorld = GameWorld:new(__global_level,self.view,hero)
   hero.x,hero.y = X*0.5,Y*0.5

   --[[
   local obstacle = Obstacle:new(30,30)
   obstacle.x,obstacle.y = 0,Y*0.0
   self.gameWorld:addObstacle(obstacle)
   obstacle.speed = Vector:new(5,5)
   ]]

   self:loadProgrammers()
end

function scene:loadProgrammers()
	local names = require('scripts.data.programmers')
	for i=1,#names do 
		local name = names[i]
		logger:spawnEvent('New Programmer: ' .. name)

		local x,y = math.random()*X,math.random()*Y
		local goal = StageConstants['PROGRAMMER_GOAL_LEVEL_'..__global_level]

		local programmer = Programmer:new(StageConstants.PROGRAMMER_WIDTH,StageConstants.PROGRAMMER_HEIGHT,StageConstants.PROGRAMMER_SPEED,name,goal)
	   programmer.x,programmer.y = x,y
	   programmer.speed = Vector:new(5,-5):unit():mul(StageConstants.PROGRAMMER_SPEED)

	   self.gameWorld:addProgrammer(programmer)	   
	end
end

function scene:updateHUD()
	local time = self.gameWorld.time
	self.timeText.text = string.format('%d:%d',time/60,time%60)
end

--Methods
function scene:createScene(event)
   logger:gameEvent("Create Gameplay Scene")
   storyboard.removeAll()

   scene:createGameObjects()
end
function scene:enterScene(event)
   logger:gameEvent("Enter Gameplay Scene")

   GameController.getInstance().addCallback(scene:updateLevelCallback(), 'mainLoop')
   GameController.getInstance():beginGame()
end

function scene:exitScene(event)
   logger:gameEvent("exit Gameplay Scene")
   GameController.getInstance().clearAllCallbacks()
   GameController.getInstance():stop()
end

function scene:destroyScene(event)
   logger:gameEvent("destroy Gameplay Scene")
   GameController.getInstance().clearAllCallbacks()
   GameController.getInstance():stop()
end

scene:addEventListener("createScene",scene)
scene:addEventListener("enterScene",scene)
scene:addEventListener("exitScene",scene)
scene:addEventListener("destroyScene", scene)

return scene



