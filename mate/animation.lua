local assert = assert

local animation = {}
animation.__index = animation

local function new(name, image)
	return setmetatable({
	                    	name = name,
	                    	image = image,
	                    	frames = {},
	                    	current = 0,
	                    	min = 1000,
	                    	max = 0,
	                    	frametime = 1,
	                    	frametimer = 0,
	                    	playing = false,
	                    	loop = false,
	                    	reverse = false,
	                    	start_callback = function(anim) end,
	                    	end_callback = function(anim) end,
	                    }, animation)
end

local function isanimation(a)
	return getmetatable(a) == animation
end

function animation:clone()
	local a = new(self.name, self.image)
	a.frames = self.frames
	a.min = self.min
	a.max = self.max
	a.frametime = self.frametime
	a.start_callback = self.start_callback
	a.end_callback = self.end_callback
	return a
end

function animation:addFrame(index, quad)
	if not self.frames[index] then	
		table.insert(self.frames, index, quad)
		if index < self.min then self.min = index end
		if index > self.max then self.max = index end
		self.current = self.min
	end
end

function animation:update(dt)
	if self.playing then
		self.frametimer = self.frametimer - dt
		if self.frametimer <= 0 then
			self:nextFrame()
			self.frametimer = self.frametime
		end
	end
end

function animation:nextFrame()
	if not self.reverse then
		if self.current < self.max then 
			self.current = self.current + 1
		else
			if self.loop then
				self.current = self.min
			else
				self.end_callback(self)
			end
		end
	else
		if self.current > self.min then
			self.current = self.current - 1
		else
			if self.loop then
				self.current = self.max
			else
				self.end_callback(self)
			end
		end
	end
end

function animation:getFrame()
	return self.frames[self.current]
end

function animation:play(loop, reverse, time)
	self.loop = loop or false
	self.reverse = reverse or false
	self.frametime = time or self.frametime

	if not self.reverse then
		self.current = self.min
	else
		self.current = self.max
	end

	self.frametimer = self.frametime
	self.playing = true
end

return setmetatable({
						new = new,
						isanimation = isanimation,
                    },
                	{ __call = function(_, ...) return new(...) end })