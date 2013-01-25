Class = require 'hump.class'
vector = require 'hump.vector'
require 'gameobject'
require 'sprite'
require 'bounds'
require 'gameconf'
require 'collidable'

Projectile = Class
{
	name = "Projectile",
	inherits = {GameObject, Collidable},
	function(self, pos, t)
		GameObject.construct(self, pos or vector(0, 0))
		Collidable.construct(self)
		self.type = t or "PlayerShot"
		if self.type == "PlayerShot" then
			self.tags = {Enemy = true}
			self.moveMult = 1
		elseif self.type == "EnemyShot" then
			self.tags = {Player = true}
			self.moveMult = -1
		else
			self.moveMult = 1
		end

		self.movespeed = 1000 * self.moveMult
		self.velocity = vector(self.movespeed, 0)
		self.radius = 4
		self.bounds = Circle(self.position, self.radius)
	end
}

function Projectile:init()
end

function Projectile:update(dt)
	self.position = self.position + self.velocity * dt
	self.bounds.position = self.position
	cx, cy = game.camera:pos()
	if self.position.x > cx + screen.width / 2 + 10 or self.position.x < cx - screen.width / 2 - 10 then
		self.destroy = true
	end
end

function Projectile:draw()
	love.graphics.setColor(255, 255, 0)
	love.graphics.circle("fill", self.position.x, self.position.y, self.radius)
end

function Projectile:onCollisionEnter(other, colPosition, colNormal)
	self.destroy = true
end