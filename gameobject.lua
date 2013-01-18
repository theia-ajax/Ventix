Class = require 'hump.class'
vector = require 'hump.vector'

GameObject = Class
{
	name = "GameObject",
	function(self, pos)
		self.id = 0
		self.type = "GameObject"
		self.depth = 0
		self.position = pos or vector(0, 0)
		self.velocity = vector(0, 0)
		self.rotation = 0
		self.scale = vector(1, 1)
		self.destroy = false
	end
}

function GameObject:init()
end

function GameObject:update(dt)
end

function GameObject:draw()
end