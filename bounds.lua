Class = require 'hump.class'
vector = require 'hump.vector'

Bounds = Class
{
	name = "Bounds",
	function(self)
		self.type = "bounds"
	end
}

function Bounds:center()
end

function Bounds:intersects(other)
	if other.type == "rect" then
		return self:intersectsRect(other)
	elseif other.type == "circ" then
		return self:intersectsCirc(other)
	else
		return false
	end
end

function Bounds:intersectsRect()
end

function Bounds:intersectsCirc()
end

function Bounds:getBoundingRect()
end

function Bounds:containsPoint()
end

Rectangle = Class
{
	name = "Rectangle",
	inherits = Bounds,
	function(self, pos, dim)
		Bounds.construct(self)
		self.type = "rect"
		self.position = pos
		self.dimensions = dim
	end
}

function Rectangle:width()
	return self.dimensions.x
end

function Rectangle:height()
	return self.dimensions.y
end

function Rectangle:left()
	return self.position.x
end

function Rectangle:right()
	return self.position.x + self.dimensions.x
end

function Rectangle:top()
	return self.position.y
end

function Rectangle:bottom()
	return self.position.y + self.dimensions.y
end

function Rectangle:getBoundingRect()
	return self
end

function Rectangle:intersectsRect(rect)
	if self:left() < rect:right() and self:right() > rect:left() and
	   self:top() < rect:bottom() and self:bottom() > rect:top() then
		return true
	end
	return false
end

function Rectangle:intersectsCirc(circ)
	
	-- Create a rectangle that is essentially a scaled up version of this rectangle based on the radius
	-- of the circle.  If the circle's center is then located within this larger rectangle we know
	-- that they intersect
	local r = Rectangle(vector(self.position.x - circ.radius, self.position.y - circ.radius),
				  vector(self.dimensions.x + circ.radius * 2, self.dimensions.y + circ.radius * 2))

	if r:containsPoint(circ.position) then
		return true
	else
		return false
	end
end

function Rectangle:containsPoint(vec)
	if vec.x >= self:left() and vec.x <= self:right() and
	   vec.y >= self:top() and vec.y <= self:bottom() then
	  	return true
	else
		return false
	end
end

function Rectangle:center()
	return vector(self.position.x + self.dimensions.x / 2, self.position.y + self.dimensions.y / 2)
end

function Rectangle:grow(growvec)
	self.position.x = self.position.x - math.floor(growvec.x / 2)
	self.position.y = self.position.y - math.floor(growvec.y / 2)
	self.dimensions.x = self.dimensions.x + growvec.x
	self.dimensions.y = self.dimensions.y + growvec.y
end

function Rectangle:shrink(shrinkvec)
	self.position.x = self.position.x + math.floor(shrinkvec.x / 2)
	self.position.y = self.position.y + math.floor(shrinkvec.y / 2)
	self.dimensions.x = self.dimensions.x - shrinkvec.x
	self.dimensions.y = self.dimensions.y - shrinkvec.y
end

function Rectangle:draw(r, g, b, a)
	r = r or 255
	g = g or 255
	b = b or 255
	a = a or 255
	
	love.graphics.setColor(r, g, b, a)
	love.graphics.rectangle("line", self.position.x, self.position.y, self.dimensions.x, self.dimensions.y)
end

Circle = Class
{
	name = "Circle",
	inherits = Bounds,
	function(self, center, rad)
		Bounds.construct(self)
		self.type = "circ"
		self.position = center
		self.radius = rad
	end
}

function Circle:getBoundingRect()
	return Rectangle(vector(self.position.x - self.radius, self.position.y - self.radius), 
					 vector(self.radius * 2, self.radius * 2))
end

function Circle:intersectsCirc(circ)
	if (vector.dist(self.position, circ.position) <= self.radius + circ.radius) then
		return true
	else
		return false
	end
end

function Circle:intersectsRect(rect)
	return rect:intersectsCirc(self)
end

function Circle:containsPoint(vec)
	if vector.dist(self.position, vec) <= self.radius then
		return true
	else
		return false
	end
end

function Circle:center()
	return self.position
end

function Circle:draw(r, g, b, a)
	r = r or 255
	g = g or 255
	b = b or 255
	a = a or 255
	love.graphics.setColor(r, g, b, a)
	love.graphics.circle("line", self.position.x, self.position.y, self.radius)
end