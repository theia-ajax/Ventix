Class = require 'hump.class'
vector = require 'hump.vector'
Signal = require 'hump.signal'
require 'collidable'
require 'gameconf'

Trigger = Class
{
	name = "Trigger",
	inherits = {GameObject, Collidable},
	function(self, enter, x, y, w, h, exit, stay)
		GameObject.construct(self)
		Collidable.construct(self, "Trigger")
		self.bounds.position = vector(x or 0, y or 0)
		self.bounds.dimensions = vector(w or 5, h or screen.height)
		self.tags = { Player = true }
		self.depth = 1
		self.enter = enter or 'onTriggerEnter'
		self.enterTable = { self.id, triggerType = "default" }
		self.stay = stay or 'onTriggerStay'
		self.stayTable = { self.id, triggerType = "default" }
		self.exit = exit or 'onTriggerExit'
		self.exitTable = { self.id, triggerType = "default" }
	end
}

function Trigger:onCollisionEnter(other, ...)
	if self.enter then Signal.emit(self.enter, self.enterTable) end
end

function Trigger:onCollisionStay(other, ...)
	if self.stay then Signal.emit(self.stay, self.stayTable) end
end

function Trigger:onCollisionExit(other, ...)
	if self.exit then Signal.emit(self.exit, self.exitTable) end
end

function Trigger:draw()
	if game.debug.on then
		self.bounds:draw(0, 255, 0)
	end
end
