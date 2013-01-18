Class = require 'hump.class'
vector = require 'hump.vector'
camera = require 'hump.camera'
require 'gameobject'

Star = Class
{
	name = "Star",
	inherits = GameObject,
	function(self, pos)
		GameObject.construct(self)
		self.type = "Star"
		self.depth = 100
		self.speed = math.random() * -1
		cx, cy = gamecam:pos()
		self.position = pos or vector(cx + screen.width / 2 + 20, 
									  math.random(screen.height - game.hud.vertSize) + (cy - screen.height / 2))
		self.color = {}
		self.color.r = math.random(256) - 1
		self.color.g = math.random(256) - 1
		self.color.b = math.random(256) - 1
	end
}

function Star:update(dt)
	self.velocity = vector(self.speed, 0)
	self.position = self.position + self.velocity

	cx, _ = gamecam:pos()
	if self.position.x < cx - screen.width / 2 - 20 then
		self.destroy = true
	end
end

function Star:draw()
	love.graphics.setColor(self.color.r, self.color.g, self.color.b)
	love.graphics.circle("fill", self.position.x, self.position.y, 2)
end