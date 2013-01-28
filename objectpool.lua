Class = require 'hump.class'
require 'star'
require 'projectile'

ObjectPool = Class
{
	name = "ObjectPool",
	function(self, poolType, capacity)
		self.poolType = poolType
		self.capacity = capacity or 100
		
		self.objects = {}
		
		self.available = Stack()
		for i = 1, self.capacity do
			self.available:push(i)
		end
	end
}

function ObjectPool:register(...)
	if self.available:size() <= 0 then return end	
	
	local index = self.available:pop()
	if self.objects[index] then
		self.objects[index].id = 0
		self.objects[index].hidden = false
		self.objects[index].destroy = false
		self.objects[index]:reset(unpack(arg))
	else
		local obj = self:newObj(unpack(arg))
		obj.objPool = self
		obj.objPoolId = index
		obj.reuse = true
		self.objects[index] = obj
	end

	game.gameObjects:register(self.objects[index])
end

function ObjectPool:registerBatch(...)
	for i, v in ipairs(arg) do
		if v then 
			self:register(unpack(v))
		end
	end
end

function ObjectPool:newObj(...)
	if self.poolType == nil then
		return nil
	elseif self.poolType == "Star" then
		return Star(unpack(arg))
	elseif self.poolType == "Projectile" then
		return Projectile(unpack(arg))
	else
		return nil
	end
end

function ObjectPool:unregister(obj)
	if not obj then return end

	obj.hidden = true
	self.available:push(obj.objPoolId)
end

function ObjectPool:preload()
	for i = 1, self.capacity do
		if self.poolType == "Star" then
			self:register(vector.one * -1000)
		elseif self.poolType == "Projectile" then
			self:register(vector.one * -1000)
		end
	end

	for k, obj in pairs(self.objects) do
		if obj then obj.destroy = true end
	end
end

function ObjectPool:clear()
	for i, v in ipairs(self.objects) do
		self.objects[i] = nil
	end

	while self.available:size() > 0 do self.available:pop() end
	for i = 1, self.capacity do
		self.available:push(i)
	end
end
