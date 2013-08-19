local logger = {}
local logPaths = system.pathForFile('coronablitz_',system.TemporaryDirectory)

function logger:info(TAG,fmt,...)
   arg = {...}
   local logLine = string.format(tostring(fmt),unpack(arg))
   print(logLine)

   local file = io.open(logPaths..TAG..'.log', "a")
   file:write(logLine .. "\n")
   file:close()
end

function logger:gameEvent(fmt,...)  self:info('###',fmt,unpack({...})) end
function logger:unitEvent(fmt,...)  self:info('$$$',fmt,unpack({...})) end
function logger:spawnEvent(fmt,...) self:info('@@@',fmt,unpack({...})) end
function logger:debug(fmt,...)      self:gameEvent('DBG> '..tostring(fmt),unpack({...})) end

require'lfs'
function logger:clean()
   self:gameEvent( '#############################\n### Starting Game Events  ###\n#############################')
   self:unitEvent( '#############################\n### Starting Unit Events  ###\n#############################')
   self:spawnEvent('#############################\n### Starting Spawn Events ###\n#############################')
end

return logger