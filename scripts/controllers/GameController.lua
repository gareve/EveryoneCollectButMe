local _instance, lastTime,callbacks = nil,nil,{}
local isFast = false


local GameController = {}
function GameController:new()
   assert(nil, 'GameController is a singleton and cannot be instantiated - use getInstance() instead')
end

function GameController.getInstance()
   if not _instance then
     _instance = GameController
   end

   _instance.gameLoop = function(event)
      assert(lastTime,"Previous time is null :(")
      local delta = (event.time - lastTime) / 1000.0
      lastTime = event.time      

      if isFast then delta = delta * 10 end

      for i, callback in pairs(callbacks) do
         if callback ~= nil then
            callbacks[i](delta)
         end
      end
   end

   _instance.toggleSpeed = function()
      isFast = not isFast
   end

   _instance.getCallbacks = function()
      return callbacks
   end

   _instance.removeCallbackByName = function(name)
      callbacks[name] = nil
   end

   _instance.addCallback = function(callback, name)
      callbacks[name] = callback
   end

   _instance.clearAllCallbacks = function()
      callbacks = {};
   end

   function _instance:stop()
      Runtime:removeEventListener("enterFrame", _instance.gameLoop)
   end

   _instance.pause = function()
      _instance.stop();
   end

   _instance.resume = function()
      _instance.beginGame();
   end

   function _instance:beginGame()
      lastTime = system.getTimer()
      isFast = false
      Runtime:addEventListener("enterFrame", _instance.gameLoop)
   end

   return _instance
end

return GameController