Class = require 'hump.class'

ObjectPool = Class
{
	name = "ObjectPool",
	function(self, capacity)
		self.capacity = capacity or 100
		
		self.objects = {}
		
		self.available = Stack()
		for i = 1, self.capacity do
			self.available:push(i)
		end
	end
}

function ObjectPool:register(obj)
	if not obj then return end

	game.gameObjects:register(obj)

	if self.available:size() <= 0 then return end
	
	local index = self.available:pop()
	if self.objects[index] then
		self.objects[index]:reset()
	else
		obj.objPool = self
		obj.objPoolId = index
		self.objects[index] = obj
	end
end

function ObjectPool:unregister(obj)
	if not obj then return end

	obj.hidden = true
	self.available:push(obj.objPoolId)
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
