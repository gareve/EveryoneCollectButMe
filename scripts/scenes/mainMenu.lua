local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--Methods
function scene:createScene(event)
   logger:gameEvent("Create Gameplay Scene")
   storyboard.removeAll()

   local text = display.newText(self.view,string.format("Everyone Collect but me"),0,0,nil,20)
   text:setReferencePoint(assert(display.CenterReferencePoint))
   text.x,text.y = X*0.5,Y*0.3

   local tutorialText = display.newText(self.view,"<Tutorial>",0,0,nil,20)
   tutorialText:setReferencePoint(assert(display.CenterReferencePoint))
   tutorialText.x,tutorialText.y = X*0.5,Y*0.6

   function tutorialText:tap()
   	storyboard.gotoScene("scripts.scenes.gameDescription",{effect = "fade",time = 100})
   end
   tutorialText:addEventListener('tap',tutorialText)

   local continueText = display.newText(self.view,"<Start Game>",0,0,nil,20)
   continueText:setReferencePoint(assert(display.CenterReferencePoint))
   continueText.x,continueText.y = X*0.5,Y*0.8

   function continueText:tap()
   	__global_level = 1
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



