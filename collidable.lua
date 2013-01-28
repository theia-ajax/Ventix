Class = require 'hump.class'
vector = require 'hump.vector'

Collidable = Class
{
	name = "Collidable",
	function(self, t)
		self.type = t or ""
		self.tags = {default = true}
		self.inContactWith = {}
		self.bounds = Rectangle(vector(0, 0), vector(0, 0))
	end
}

function Collidable:onCollisionEnter(other, ...)
end

function Collidable:onCollisionStay(other, ...)
end

function Collidable:onCollisionExit(other)
end

function Collidable:isColliding(other)
	local isColliding = self.bounds:intersects(other.bounds)
	if isColliding then
		local cx, cy = self.bounds:center().x + other.bounds:center().x, self.bounds:center().y + other.bounds:center().y
		cx, cy = cx / 2, cy / 2
		local pos = vector(cx, cy)
		local norm = other.bounds:center() - self.bounds:center()
		norm:normalize()
		return isColliding, pos, norm
	else
		return isColliding, nil, nil
	end
end