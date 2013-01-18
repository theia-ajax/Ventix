Class = require 'hump.class'

LivingObject = Class
{
	name = "LivingObject",
	function(self, max, curr)
		self.maxHealth = max or 100
		self.currentHealth = curr or self.maxHealth
		self.isAlive = self.currentHealth > 0
	end
}

function LivingObject:adjustHealth(amt)
	if not self.isAlive then
		return
	end

	self.currentHealth = self.currentHealth + amt

	if self.currentHealth > self.maxHealth then
		self.currentHealth = self.maxHealth
	elseif self.currentHealth <= 0 then
		self.isAlive = false
	end
end

function LivingObject:heal(amt)
	self:adjustHealth(amt)
end

function LivingObject:damage(amt)
	self:adjustHealth(-amt)
end