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
	self.image = love.graphics.newImage(self.imgfile)
	self.data = love.filesystem.read(self.datafile)

	if not self.image or not self.data then
		return false
	end

	self.image:setFilter("nearest", "linear")
	self.batch = love.graphics.newSpriteBatch(self.image, 1000) --TODO: smarter max objects support

	local data, _, err = json.decode(self.data)

	print(data.frames[1].filename)

	built = true
	return true
end

function atlas:batch()
	if built then
		return self.batch
	else
		return nil
	end
end

function atlas:quads()
	if built then
		return self.quads
	else
		return nil
	end
end


return setmetatable({
						new = new,
						isatlas = isatlas,
					},
					{ __call = function(_, ...) return new(...) end	})