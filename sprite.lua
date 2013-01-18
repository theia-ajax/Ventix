Class = require 'hump.class'
vector = require 'hump.vector'
require 'gameobject'
require 'bounds'

Sprite = Class
{
	inherits = GameObject,
	function (self, img, origin)
		GameObject.construct(self, vector(0, 0))
		self.type = "Sprite"
		self.image = img
		self.origin = origin or vector(self.image:getWidth() / 2, self.image:getHeight() / 2)
	end
}

function Sprite:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.image, self.position.x, self.position.y, self.rotation, 
					   self.scale.x, self.scale.y, self.origin.x, self.origin.y)
end

function Sprite:getBoundingRect()
	return Rectangle(self.position - self.origin, vector(self.image:getWidth(), self.image:getHeight()))
end