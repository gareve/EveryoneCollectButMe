local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--Methods
function scene:createScene(event)
   logger:gameEvent("Create Gameplay Scene")
   storyboard.removeAll()

   local text = display.newText(self.view,"You have completed the level " .. __global_level,0,0,nil,20)
   text:setReferencePoint(assert(display.CenterReferencePoint))
   text.x,text.y = X*0.5,Y*0.5

   
   local continueText = display.newText(self.view,"Continue to level " .. __global_level + 1,0,0,nil,20)
   continueText:setReferencePoint(assert(display.CenterReferencePoint))
   continueText.x,continueText.y = X*0.5,Y*0.7

   function continueText:tap()
   	__global_level = __global_level + 1
   	storyboard.gotoScene("scripts.scenes.mainGame",{effect = "fade",time = 100})
   end

   continueText:addEventListener('tap',continueText)
end
function scene:enterScene(event)
   logger:gameEvent("Enter Gameplay Scene")   
end

function scene:exitScene(event)
   logger:gameEvent("exit Gameplay Scene")
end

function scene:destroyScene(event)
   logger:gameEvent("destroy Gameplay Scene")
end

scene:addEventListener("createScene",scene)
scene:addEventListener("enterScene",scene)
scene:addEventListener("exitScene",scene)
scene:addEventListener("destroyScene", scene)

return scene



