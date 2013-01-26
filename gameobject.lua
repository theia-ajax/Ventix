Class = require 'hump.class'
vector = require 'hump.vector'

GameObject = Class
{
	name = "GameObject",
	function(self, pos)
		self.id = 0	--ID assigned by the game object manager
		self.type = "GameObject" 
		self.depth = 0 --draw depth, 0 draws on top of everything else, higher values draw further back
		self.position = pos or vector(0, 0)
		self.velocity = vector(0, 0)
		self.rotation = 0
		self.scale = vector(1, 1)
		self.destroy = false --if set to true the object is removed from the active objects
		self.hidden = false --if hidden the object is not drawn
		
		-- variables for object reuse in an object pool
		self.reuse = false
		self.objPool = nil
		self.objPoolId = 0
	end
}

function GameObject:init()
end

function GameObject:reset()
end

function GameObject:update(dt)
end

function GameObject:draw()
end

function GameObject:debugDraw()
end