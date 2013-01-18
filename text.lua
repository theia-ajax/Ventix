Class = require 'hump.class'
vector = require 'hump.vector'
require 'gameconf'

Text = Class
{
	name = "Text",
	function(self, text, align, pos, rot, scl, r, g, b, a, font)
		self.font = font or love.graphics.newFont(24)
		self.text = text or ""
		self.position = pos or vector(0, 0)
		self.rotation = rot or 0
		self.scale = scl or vector(1, 1)
		self.alignment = align or "left"
		self.color = {}
		self.color.r = r or 255
		self.color.g = g or 255
		self.color.b = b or 255
		self.color.a = a or 255
	end
}

function Text:draw()
	love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
	love.graphics.setFont(self.font)
	
	local ox, oy = 0, self.font:getHeight(self.text) / 2

	if self.alignment == "right" then
		ox = self.font:getWidth(self.text)
	elseif self.alignment == "center" then
		ox = self.font:getWidth(self.text) / 2
	else
		-- do nothing
	end

	love.graphics.print(self.text, self.position.x, self.position.y, self.rotation, self.scale.x, self.scale.y, ox, oy)
end