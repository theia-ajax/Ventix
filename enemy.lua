Timer = require 'hump.timer'
Class = require 'hump.class'
vector = require 'hump.vector'
require 'gameobject'
require 'collidable'
require 'bounds'
require 'sprite'
require 'livingobject'

Enemy = Class
{
	name = "Enemy",
	inherits = {GameObject, Collidable, LivingObject},
	function(self, img)
		GameObject.construct(self, vector(400, screen.height / 2))
		Collidable.construct(self)
		LivingObject.construct(self)
		self.type = "Enemy"
		self.depth = 10
		self.tags = {Player = true, PlayerShot = true}
		self.sprite = Sprite(img)
		self.enemyState = "idle"
		self.sprite.position = self.position
		self.bounds = self.sprite:getBoundingRect()
		self:init()
	end
}

function Enemy:init()
	self.bounds:shrink(vector(8, 56))
	self.boundsOffset = self.bounds.position - self.position
end

function Enemy:update(dt)
	self.position.x = self.position.x - 80 * dt

	self:updateSprite()

	if not self.isAlive then
		self.destroy = true
	end
end

function Enemy:onCollisionEnter(other, ...)
	if other.type == "PlayerShot" then
		self:damage(10)
		self.sprite.color = {255, 0, 0, 255}
		Timer.add(0.1, function() self.sprite.color = {255, 255, 255, 255} end)
	end
end

function Enemy:updateSprite()
	self.sprite.position = self.position
	self.sprite.rotation = self.rotation
	self.sprite.scale = self.scale
	self.bounds.position = self.position + self.boundsOffset
end

function Enemy:draw()
	self.sprite:draw()
	if game.debug.on then
		self:debugDraw()
	end
end

function Enemy:debugDraw()
	self.bounds:draw(0, 255, 255)
end