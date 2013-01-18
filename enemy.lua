Class = require 'hump.class'
vector = require 'hump.vector'
require 'gameobject'
require 'collidable'
require 'bounds'
require 'sprite'

Enemy = Class
{
	name = "Enemy",
	inherits = {GameObject, Collidable},
	function(self, img)
		GameObject.construct(self, vector(400, screen.height / 2))
		Collidable.construct(self)
		self.type = "Enemy"
		self.depth = 1
		self.tags = {Player = true, PlayerShot = true}
		self.sprite = Sprite(img)
		self.enemyState = 0
	end
}

function Enemy:init()
end

function Enemy:update(dt)
	self.sprite.position = self.position
	self.sprite.rotation = self.rotation
	self.sprite.scale = self.scale
	self.bounds = self.sprite:getBoundingRect()
end

function Enemy:draw()
	self.sprite:draw()
	self.bounds:draw(0, 255, 255)
end