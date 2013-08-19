local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

function scene:updateLevelCallback()
return function(delta)
	if scene.gameWorld:programmersWon() then
		--YOU Lose
		__global_programmer_winner = scene.gameWorld:programmersWon()

		storyboard.gotoScene("scripts.scenes.loseStage",{effect = "fade",time = 100})
	elseif scene.gameWorld:programmersLose() then
		--YOU Win
		if __global_level == StageConstants.LEVELS then
			storyboard.gotoScene("scripts.scenes.credits",{effect = "fade",time = 100})
		else
			storyboard.gotoScene("scripts.scenes.winStage",{effect = "fade",time = 100})
		end
	else
		scene.gameWorld:update(delta)
		scene:updateHUD()
	end
end
end

function playerTouch(event)
	if event.phase == 'began' then
		scene.startTouch = Vector:new(event.x,event.y)

		local circ = display.newCircle(scene.view,event.x,event.y,5)
		circ:setFillColor(0,0,0,0)
		circ:setStrokeColor(0,100,255,255)
		circ.strokeWidth = 1

		transition.to(circ,
			{
				alpha = 0,
				time = 1 * 1000,
				onComplete = function()
					if circ ~= nil then
						display.remove(circ)
					end
				end
			}
		)

	elseif event.phase == 'ended' then
		scene.endTouch = Vector:new(event.x,event.y)

		logger:debug('S: ' .. scene.startTouch.x .. ' ' ..scene.startTouch.y )
		logger:debug('E: ' .. scene.endTouch.x .. ' ' ..scene.endTouch.y)

		local circ = display.newCircle(scene.view,event.x,event.y,5)
		circ:setFillColor(0,0,0,0)
		circ:setStrokeColor(100,255,0,255)
		circ.strokeWidth = 1

		transition.to(circ,
			{
				alpha = 0,
				time = 1 * 1000,
				onComplete = function()
					if circ ~= nil then
						display.remove(circ)
					end
				end
			}
		)

		local force = scene.endTouch:sub(scene.startTouch):mul(StageConstants.FLING_COEFFICIENT)
		scene.gameWorld.hero:applyForce(force)
	end
	return true
end

function scene:createGameObjects()
	--local bg = display.newRect(self.view,0,0,X,Y)
	local bg = display.newImageRect(self.view,'sprites/bg1.jpg',X,Y)
	bg:setReferencePoint(assert(display.CenterReferencePoint))
	bg.x,bg.y = X*0.5,Y*0.5

	bg.alpha = 0.6

	function bg:touch(event)
		playerTouch(event)
	end

	bg:addEventListener(
		'touch',
		bg
	)

	self.bg  = bg

   self.timeText = display.newText(scene.view,' L  - X:XX',0,0,nil,15)
   self.timeText:setReferencePoint(assert(display.BottomRightReferencePoint))
   self.timeText.x,self.timeText.y = X,Y

   local timeBox = display.newRect(scene.view,0,0,self.timeText.contentWidth,self.timeText.contentHeight)
   timeBox:setReferencePoint(assert(display.BottomRightReferencePoint))
   timeBox:setFillColor(255,255,255,40)
   timeBox.x,timeBox.y = X,Y

   local hero = Hero:new(StageConstants.HERO_RADIUS)
   self.gameWorld = GameWorld:new(__global_level,self.view,hero)
   hero.x,hero.y = X*0.5,Y*0.5
   self.gameWorld:insert(hero)

   self:loadProgrammers()
end

function scene:loadProgrammers()
	local names = require('scripts.data.programmers')
	for i=1,#names do 
		local name = names[i]
		logger:spawnEvent('New Programmer: ' .. name)

		local x,y = math.random()*X,math.random()*Y
		local goal = StageConstants['PROGRAMMER_GOAL_LEVEL_' .. __global_level]

		local programmer = Programmer:new(StageConstants.PROGRAMMER_WIDTH,StageConstants.PROGRAMMER_HEIGHT,StageConstants.PROGRAMMER_SPEED,name,goal)
	   programmer.x,programmer.y = x,y
	   programmer.speed = Vector:new(5,-5):unit():mul(StageConstants.PROGRAMMER_SPEED)

	   self.gameWorld:addProgrammer(programmer)	   
	end
end

function scene:updateHUD()
	local time = self.gameWorld.time
	self.timeText.text = string.format('L%d - %d:%02d',__global_level,time/60,time%60)
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



