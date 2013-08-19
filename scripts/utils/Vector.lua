local Vector = {}
function Vector:new(x,y)
   local vector = {}
   vector.x,vector.y = x,y

   function vector:reduce(delta,coefficient)
   	local deltaX = self.x * delta * coefficient
   	local deltaY = self.y * delta * coefficient

   	if self.x > 0 then deltaX = math.max(-deltaX,-self.x) end
   	if self.y > 0 then deltaY = math.max(-deltaY,-self.y) end

   	if self.x < 0 then deltaX = math.min(-deltaX,-self.x) end
   	if self.y < 0 then deltaY = math.min(-deltaY,-self.y) end

   	self.x,self.y = self.x + deltaX,self.y + deltaY
   end

   function vector:mod() return math.sqrt(self.x*self.x + self.y*self.y) end
   function vector:unit() local k = self:mod();return Vector:new(x/k,y/k) end
   function vector:dist(vc) local a,b = self.x - vc.x,self.y - vc.y; return math.sqrt(a*a+b*b) end

   function vector:orto()  return Vector:new(-y,x) end
   function vector:add(vc) return Vector:new(self.x + vc.x,self.y + vc.y) end
   function vector:sub(vc) return Vector:new(self.x - vc.x,self.y - vc.y) end
   function vector:mul(k)  return Vector:new(self.x * k,self.y * k) end
   function vector:div(k)  return Vector:new(self.x / k,self.y / k) end

   --[[
         90
      180    0
         270
   ]]
   function vector:angle(vc)--Degrees
      local dir = vc:sub(self)
      --if dir.x == 0 and dir.y > 0 then return 90 end
      --if dir.x == 0 and dir.y < 0 then return 270 end

      return (math.deg(math.atan2(dir.y,dir.x))) % 360
   end

   return vector
end

function Vector:cross(A,B) return A.x*B.y - A.y*B.x end
function Vector:area2(A,B,C) return Vector:cross(B:sub(A),C:sub(A)) end--For the triangle A,B,C  using A->B, A->C

return Vector