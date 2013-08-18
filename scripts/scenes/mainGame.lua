local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

scene.num = 0

function scene:updateLevelCallback()
return function(delta)
   self.num = self.num + 1
   self.text.text = scene.num

   if self.num > 20 then
      GameController.getInstance().clearAllCallbacks()
      GameController.getInstance():stop()
   end
end
end

function scene:createGameObjects()
   self.text = display.newText(scene.view,'CUack',0,0,nil,15)
   self.text.x,self.text.y = X*0.5,Y*0.5
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



