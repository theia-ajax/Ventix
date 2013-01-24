Class = require 'hump.class'
require 'collidable'
require 'stack'

CollisionManager = Class
{
	function(self)
		self.objects = {}
		if game.debug.on then
			self.debug = {
				objCount = 0
			}
		end
	end
}

function CollisionManager:register(obj)

	-- Check to see if the new objects is already colliding with anything
	local obj1 = obj
	for i, obj2 in ipairs(self.objects) do 
		if obj2.tags[obj1.type] and obj1.tags[obj2.type] then
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
	table.insert(self.objects, obj)
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

		table.remove(self.objects, index)
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
	for i, obj in ipairs(self.objects) do
		if obj ~= nil and obj.id == id then
			return i
		end
	end
	return -1
end

function CollisionManager:update()
	for i = 1, #self.objects - 1 do
		for j = i + 1, #self.objects do
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

	if game.debug.on then
		self:updateDebug()
	end
end

function CollisionManager:updateDebug()
	self.debug.objCount = #self.objects
end