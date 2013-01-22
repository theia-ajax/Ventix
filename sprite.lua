Class = require 'hump.class'
vector = require 'hump.vector'
require 'gameobject'
require 'bounds'

Sprite = Class
{
	inherits = GameObject,
	function (self, img, align)
		GameObject.construct(self, vector(0, 0))
		self.type = "Sprite"
		self.image = img
		self.alignment = align or "center"
		self.origin = self:getOriginForAlignment(self.alignment)
	end
}

function Sprite:getOriginForAlignment(align)
	if align == "top left" then
		return vector(0, 0)
	elseif align == "top" then
		return vector(self.image:getWidth() / 2, 0)
	elseif align == "top right" then
		return vector(self.image:getWidth(), 0)
	elseif align == "left" then
		return vector(0, self.image:getHeight() / 2)
	elseif align == "center" then
		return vector(self.image:getWidth() / 2, self.image:getHeight() / 2)
	elseif align == "right" then
		return vector(self.image:getWidth(), self.image:getHeight() / 2)
	elseif align == "bottom left" then
		return vector(0, self.image:getHeight())
	elseif align == "bottom" then
		return vector(self.image:getWidth() / 2, self.image:getHeight())
	elseif align == "bottom right" then
		return vector(self.image:getWidth(), self.image:getHeight())
	else
		return vector(self.image:getWidth() / 2, self.image:getHeight() / 2)
	end
end

function Sprite:draw()
	if not self.image then return end

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.image, self.position.x, self.position.y, self.rotation, 
					   self.scale.x, self.scale.y, self.origin.x, self.origin.y)
end

function Sprite:getBoundingRect()
	return Rectangle(self.position - self.origin, vector(self.image:getWidth(), self.image:getHeight()))
end