      --Utils
      logger = require 'scripts.utils.logger'
      Vector = require 'scripts.utils.Vector'
      GeometricUtils = require 'scripts.utils.GeometricUtils'
      LuaUtils = require 'scripts.utils.LuaUtils'     

      --Globals
      X,Y = display.viewableContentWidth,display.viewableContentHeight
      require 'scripts.GameConstants'--Include several global variables
      GameController = require 'scripts.controllers.GameController'
      GameWorld = require 'scripts.models.GameWorld'
         --Game Screen Models
         Obstacle = require 'scripts.models.Obstacle'  
         Programmer = require 'scripts.models.Programmer'
         Hero = require 'scripts.models.Hero'

--Cleaning logs
logger:clean()
logger:gameEvent('%s - %dx%d',system.getInfo("environment"),X,Y)

__global_level = 2
__global_programmer_winner = 'Cuack'

function startLevel()
   local storyboard = require "storyboard"   

   storyboard.gotoScene("scripts.scenes.mainMenu",{effect = "fade",time = 100})
   --storyboard.gotoScene("scripts.scenes.gameDescription",{effect = "fade",time = 100})
   --storyboard.gotoScene("scripts.scenes.credits",{effect = "fade",time = 100})
   --storyboard.gotoScene("scripts.scenes.winStage",{effect = "fade",time = 100})
   --storyboard.gotoScene("scripts.scenes.loseStage",{effect = "fade",time = 100})

	--storyboard.gotoScene("scripts.scenes.mainGame",{effect = "fade",time = 100})
end

startLevel()

--Finished :)