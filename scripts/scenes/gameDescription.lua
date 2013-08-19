local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--Methods
function scene:createScene(event)
   logger:gameEvent("Create Gameplay Scene")
   storyboard.removeAll()

   local desc = ''
   desc = desc .. "Everyone on the Corona Blitz wants to collect their favorite\n"
   desc = desc .. "items but you. You hate it. Collect items is just not for you\n"
   desc = desc .. "But ... do you know what is more interesting???\n.\n"
   desc = desc .. "Prevent that the other players of the Corona Blitz 2013\n"
   desc = desc .. "can collect successfully all their items.\n"

   desc = desc .. "within a time frame.\n"

   desc = desc .. "With the movements of your finger, you can move the player and\n"
   desc = desc .. "deflect the other players that want to collect items of their same color.\n.\n"

   desc = desc .. "If some player collect all their items, you will lose.\n"

   local text = display.newText(self.view,desc,0,0,X,0,nil,10)
   text:setReferencePoint(assert(display.CenterReferencePoint))
   text.x,text.y = X*0.7,Y*0.4

   local continueText = display.newText(self.view,"<Back>",0,0,nil,20)
   continueText:setReferencePoint(assert(display.CenterReferencePoint))
   continueText.x,continueText.y = X*0.5,Y*0.8

   function continueText:tap()
   	storyboard.gotoScene("scripts.scenes.mainMenu",{effect = "fade",time = 100})
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



