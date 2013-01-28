Class = require 'hump.class'
vector = require 'hump.vector'
require 'gameobject'
require 'sprite'
require 'bounds'
require 'gameconf'
require 'collidable'
require 'sprite'

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

		self.depth = 50

		self.movespeed = 1000 * self.moveMult
		self.velocity = vector(self.movespeed, 0)
		self.radius = 4
		self.bounds = Circle(self.position, self.radius)

		self.sprite = Sprite(love.graphics.newImage("assets/bullet.png"))
	end
}

function Projectile:init()
end

function Projectile:reset(...)
	self.id = 0

	self.position = arg[1]
	local t = arg[2]
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

	self.depth = 50

	self.movespeed = 1000 * self.moveMult
	self.velocity = vector(self.movespeed, 0)
	self.radius = 4
	self.bounds = Circle(self.position, self.radius)

	self.hidden = false

	self.sprite.position = self.position
end

function Projectile:update(dt)
	self.position = self.position + self.velocity * dt
	self.bounds.position = self.position
	cx, cy = game.camera:pos()
	local boundR = cx + screen.width / 2 + self.radius
	local boundL = cx - screen.width / 2 - self.radius
	if self.position.x > boundR or self.position.x < boundL then
		self.destroy = true
	end

	self.sprite.position = self.position
end

function Projectile:draw()
	self.sprite:draw()
end

function Projectile:onCollisionEnter(other, colPosition, colNormal)
	self.destroy = true
end