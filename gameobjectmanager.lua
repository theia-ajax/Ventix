Class = require 'hump.class'
require 'stack'
require 'queue'
require 'gameobject'
require 'collidable'
require 'collisionmanager'

GameObjectManager = Class
{
	function(self)
		self.objects = {}
		self.objects.n = 0
		self.available = Stack()
		self.currentId = 0
		self.destroyQueue = Queue()
	end
}

function GameObjectManager:register(obj)
	index = 0
	if self.available:size() > 0 then
		index = self.available:pop()
	else
		index = self.objects.n
		self.objects.n = self.objects.n + 1
	end
	obj.id = self:nextId()
	self.objects[index] = obj
	if obj:is_a(Collidable) then
		collisionManager:register(obj)
	end
end

function GameObjectManager:unregister(id)
	index = self:findIndex(id)
	if index >= 0 then
		if self.objects[index]:is_a(Collidable) then
			collisionManager:unregister(self.objects[index].id)
		end
		self.objects[index] = nil
		self.available:push(index)
	end
end

function GameObjectManager:find(id)
	index = self:findIndex(id)
	if index >= 0 then
		return self.objects[index]
	else
		return nil
	end
end

function GameObjectManager:findIndex(id)
	for i = 0, self.objects.n - 1 do
		if self.objects[i] ~= nil then
			obj = self.objects[i]
			if obj.id == id then
				return i
			end
		end
	end

	return -1
end

function GameObjectManager:nextId()
	self.currentId = self.currentId + 1
	return self.currentId - 1
end

function GameObjectManager:update(dt)
	for i = 0, self.objects.n - 1 do
		if self.objects[i] ~= nil then
			self.objects[i]:update(dt)
			if self.objects[i].destroy then
				self.destroyQueue:push(self.objects[i].id)
			end
		end
	end

	while self.destroyQueue:size() > 0 do
		self:unregister(self.destroyQueue:pop())
	end
end

function GameObjectManager:draw()
	local orderedObjects = {};
	for i = 0, self.objects.n - 1 do
		if self.objects[i] ~= nil then
			table.insert(orderedObjects, self.objects[i])
		end
	end
	table.sort(orderedObjects, function(a, b) return a.depth > b.depth 	end)
	for i, v in ipairs(orderedObjects) do
		v:draw()
	end
end