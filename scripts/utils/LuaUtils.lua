local LuaUtils = {}

function LuaUtils:tableContains(tbl,findObject)
   for key, value in pairs(tbl) do
      if value == findObject then return true end
   end
   return false
end

function LuaUtils:removeValueFromTable(tbl,findObject)
   logger:debug('Removing object')
   for i=1,#tbl do
      local value = tbl[i]
      if value == findObject then table.remove(tbl,i);return true end
   end
   return false
end

function LuaUtils:deepCopy(t)
   if type(t) ~= 'table' then return t end
   local mt = getmetatable(t)
   local res = {}
   for k,v in pairs(t) do
      if type(v) == 'table' then
         v = LuaUtils:deepCopy(v)
      end
      res[k] = v
   end
   setmetatable(res,mt)
   return res
end

return LuaUtils