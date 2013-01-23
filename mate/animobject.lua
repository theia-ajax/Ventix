local anim = require 'mate.animation'

local assert = assert

local animObject = {}
animObject.__index = animObject

local function new()
	return setmetatable({animations = {}, anim = nil, frame = nil, playing = false}, animObject)
end

local function isanimobject(a)
	return getmetatable(a) == animObject
end

function animObject:add(batch, name)
	local a = batch:getAnimation(name)
	if a and not self.animations[name] then
		self.animations[name] = a
		if not self.anim then self.anim = a end
		if not self.frame then self.frame = a.frames[a.min] end
	end
end

function animObject:getAnimation(name)
	return self.animations[name]
end

function animObject:setFrame(frame, name)
	name = name or self.anim.name or ""
	frame = frame or self.anim.min or 0
	if self.animations[name] and self.animations[name].frames[frame] then
		self.anim = self.animations[name]
		self.animations[name].current = frame
		self.frame = self.anim.frames[frame]
		self.anim.playing = false
	end
end

function animObject:play(loop, reverse, time, name)
	loop, reverse, time = loop or false, reverse or false, time or 1
	name = name or self.anim.name
	if self.animations[name] then
		self.playing = true
		self.anim = self.animations[name]
		self.anim:play(loop, reverse, time)
	end
end

function animObject:pause()
	self.playing = false
	self.anim.playing = false
end

function animObject:resume()
	self.playing =true
	self.anim.playing = true
end

function animObject:update(dt)
	if self.anim then 
		self.anim:update(dt) 
		self.frame = self.anim:getFrame()
	end
end

function animObject:draw(x, y, r, sx, sy, ox, oy, kx, ky)
	x, y, r, sx, sy, ox, oy = x or 0, y or 0, r or 0, sx or 1, sy or 1, ox or 0, oy or 0, kx or 0, ky or 0
	love.graphics.drawq(self.anim.image, self.frame,
						x, y, r, sx, sy, ox, oy, kx, ky)
end

return setmetatable({ new = new, isanimobject = isanimobject }, { __call = function(_, ...) return new(...) end })