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
		self.speed = math.random() * -10
		self.radius = game.stars.radius
		cx, cy = game.camera:pos()
		self.position = pos or vector(cx + screen.width / 2 + self.radius, 
									  math.random(screen.height - game.hud.vertSize) + 
									  			  (cy - screen.height / 2))
		self.color = {}
		self.color.r = math.random(256) - 1
		self.color.g = math.random(256) - 1
		self.color.b = math.random(256) - 1
	end
}

function Star:update(dt)
	self.velocity = vector(self.speed, 0)
	self.position = self.position + self.velocity * dt

	cx, _ = game.camera:pos()
	if self.position.x < cx - screen.width / 2 - 20 then
		self.destroy = true
	end
end

function Star:draw()
	love.graphics.setColor(self.color.r, self.color.g, self.color.b)
	if self.radius > 1 then
		love.graphics.circle("fill", self.position.x, self.position.y, self.radius)
	else
		love.graphics.point(self.position.x, self.position.y)
	end
end