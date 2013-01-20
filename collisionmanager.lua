Class = require 'hump.class'
require 'collidable'
require 'stack'

CollisionManager = Class
{
	function(self)
		self.objects = {}
		self.objects.n = 0
		self.available = Stack()
	end
}

function CollisionManager:register(obj)
	local index = 0
	if self.available:size() > 0 then
		index = self.available:pop()
	else
		index = self.objects.n
		self.objects.n = self.objects.n + 1
	end
	self.objects[index] = obj
end

function CollisionManager:unregister(id)
	local index = self:findIndex(id)
	if index >= 0 then
		-- call onCollisionExit for all objects in contact with this one
		for k, v in pairs(self.objects[index].inContactWith) do
			otherIndex = self:findIndex(k)
			if v and otherIndex >= 0 and self.objects[otherIndex] ~= nil then
				self.objects[otherIndex]:onCollisionExit(self.objects[index])
			end
		end

		self.objects[index] = nil
		self.available:push(index)
	end
end

function CollisionManager:find(id)
	local index = self:findIndex(id)
	if index >= 0 then
		return self.objects[index]
	else
		return nil
	end
end

function CollisionManager:findIndex(id)
	for i = 0, self.objects.n - 1 do
		local obj = self.objects[i]
		if obj ~= nil and obj.id == id then
			return i
		end
	end

	return -1
end

function CollisionManager:update()
	for i = 0, self.objects.n - 2 do
		for j = i + 1, self.objects.n - 1 do
			local obj1 = self.objects[i]
			local obj2 = self.objects[j]
			if obj1 ~= nil and obj2 ~= nil then
				if obj1.tags[obj2.type] and obj2.tags[obj1.type] then
					if obj1.inContactWith[obj2.id] then
						c1, pos1, norm1 = obj1:isColliding(obj2)
						c2, pos2, norm2 = obj2:isColliding(obj1)
						if c1 or c2 then
							obj1:onCollisionStay(obj2, pos1, norm1)
							obj2:onCollisionStay(obj1, pos2, norm2)
						else
							obj1:onCollisionExit(obj2, pos1, norm1)
							obj2:onCollisionExit(obj1, pos2, norm2)
							obj1.inContactWith[obj2.id] = false
							obj2.inContactWith[obj1.id] = false
						end
					else
						c1, pos1, norm1 = obj1:isColliding(obj2)
						c2, pos2, norm2 = obj2:isColliding(obj1)
						if c1 or c2 then
							obj1:onCollisionEnter(obj2, pos1, norm1)
							obj2:onCollisionEnter(obj1, pos2, norm2)
							obj1.inContactWith[obj2.id] = true
							obj2.inContactWith[obj1.id] = true
						end
					end
				end
			end
		end
	end
end