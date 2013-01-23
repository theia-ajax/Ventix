local anim = require 'mate.animation'
local json = require 'mate.dkjson'

local assert = assert

local atlas = {}
atlas.__index = atlas

local function new(imgfile, datafile)
	assert(imgfile, "new: imgfile is nil")
	assert(datafile, "new: datafile is nil")

	return setmetatable({imgfile = imgfile, datafile = datafile, built = false}, atlas)
end

local function isatlas(a)
	return getmetatable(a) == atlas
end

function atlas:build()
	if self.built then return false end

	self.image = love.graphics.newImage(self.imgfile)
	local filedata = love.filesystem.read(self.datafile)

	if not self.image or not filedata then
		return false
	end

	self.image:setFilter("nearest", "linear")
	self.batch = love.graphics.newSpriteBatch(self.image, 1000) --TODO: smarter max objects support

	self.data, _, err = json.decode(filedata)

	self.width = self.data.meta.size.w
	self.height = self.data.meta.size.h

	if self.data then
		self.statics = {}
		self.animations = {}
		for i, frame in ipairs(self.data.frames) do
			local index = string.find(frame.filename, "_")

			-- Animations have '_' in them but static images do not
			-- if index is nil there is no _ and therefore we should add
			-- this frame to statics, otherwise we'll add it to animations

			if index then
				local name = string.sub(frame.filename, 1, index-1)
				local animIndex = tonumber(string.sub(frame.filename, 
				                           			  index+1, 
				                           			  string.find(frame.filename, ".", 1, true)))
				local quad = love.graphics.newQuad(frame.frame.x, frame.frame.y,
				                                   frame.frame.w, frame.frame.h,
				                                   self.width, self.height)
				if self.animations[name] then
					self.animations[name]:addFrame(animIndex, quad)
				else
					self.animations[name] = anim(name, self.image)
					self.animations[name]:addFrame(animIndex, quad)
				end
			else
				local name = string.sub(frame.filename, string.find("."))
				local simg = {
					name = name,
					frame = love.graphics.newQuad(frame.frame.x, frame.frame.y,
					                              frame.frame.w, frame.frame.h,
					                              self.width, self.height)
				}
				if not self.statics[name] then
					self.statics[name] = simg
				end
			end
		end
	end

	self.built = true
	return true
end

function atlas:batch()
	if self.built then
		return self.batch
	else
		return nil
	end
end

function atlas:frames()
	if self.built then
		return self.statics, self.animations
	else
		return nil
	end
end


return setmetatable({
						new = new,
						isatlas = isatlas,
					},
					{ __call = function(_, ...) return new(...) end	})