local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

function scene:updateLevelCallback()
return function(delta)
	scene.gameWorld:update(delta)
end
end

function scene:createGameObjects()
   --self.text = display.newText(scene.view,'CUack',0,0,nil,15)
   --self.text.x,self.text.y = X*0.5,Y*0.5
   local level = 1
   self.gameWorld = GameWorld:new(level,self.view)

   --[[
   local obstacle = Obstacle:new(30,30)
   obstacle.x,obstacle.y = 0,Y*0.0
   self.gameWorld:addObstacle(obstacle)
   obstacle.speed = Vector:new(5,5)
   ]]

   local programmer = Programmer:new(30,30,StageConstants.PROGRAMMER_SPEED)
   programmer.x,programmer.y = 0,Y*0.9
   self.gameWorld:addProgrammer(programmer)
   programmer.speed = Vector:new(5,-5):unit():mul(StageConstants.PROGRAMMER_SPEED)
   
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



