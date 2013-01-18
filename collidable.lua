Class = require 'hump.class'
vector = require 'hump.vector'

Collidable = Class
{
	name = "Collidable",
	function(self)
		self.tags = {default = true}
		self.inContactWith = {}
		self.bounds = Rectangle(vector(0, 0), vector(0, 0))
	end
}

function Collidable:onCollisionEnter(other, position, normal)
end

function Collidable:onCollisionStay(other, position, normal)
end

function Collidable:onCollisionExit(other, position, normal)
end

function Collidable:isColliding(other)
	local isColliding = self.bounds:intersects(other.bounds)
	local cx, cy = self.bounds:center().x + other.bounds:center().x, self.bounds:center().y + other.bounds:center().y
	cx, cy = cx / 2, cy / 2
	local pos = vector(cx, cy)
	local norm = other.bounds:center() - self.bounds:center()
	norm:normalize()
	return isColliding, pos, norm
end