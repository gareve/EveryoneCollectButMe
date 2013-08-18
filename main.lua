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

--Cleaning logs
logger:clean()
logger:gameEvent('%s - %dx%d',system.getInfo("environment"),X,Y)

function startLevel()
    local storyboard = require "storyboard"   
    --storyboard.gotoScene("scripts.scenes.scoreScene",{effect = "fade",time = 100})

	storyboard.gotoScene("scripts.scenes.mainGame",{effect = "fade",time = 100})   
end

startLevel()