local anim = require 'mate.animation'
local atlas = require 'mate.atlas'
local json = require 'mate.dkjson'

local assert = assert

local atlasBatch = {}
atlasBatch.__index = atlasBatch

local function new()
	return setmetatable({basedir = "", atlases = {}, animations = {}, statics = {}}, atlasBatch)
end

local function isatlasbatch(a)
	return getmetatable(a) == atlasBatch
end

function atlasBatch:load(indexfilename)
	local filedata = love.filesystem.read(indexfilename)

	if not filedata then
		return false
	end

	local filerev = indexfilename:reverse()
	self.basedir = filerev:sub(filerev:find("/"), filerev:len()):reverse()

	local data, _, err = json.decode(filedata)

	if data then
		for i, v in ipairs(data.atlases) do
			local img, dat = v.image, v.data
			local a = atlas(self.basedir..img, self.basedir..dat)
			a:build()
			if a.built then
				table.insert(self.atlases, a)
			end
		end
	end

	return true
end

function atlasBatch:getImage(name)
	if self.statics[name] then return self.statics[name] end

	for i, a in ipairs(self.atlases) do
		if a.statics[name] then
			self.statics[name] = a.statics[name]
			return a.statics[name]
		end
	end

	return nil
end

function atlasBatch:getAnimation(name)
	if self.animations[name] then return self.animations[name] end

	for i, a in ipairs(self.atlases) do
		if a.animations[name] then
			self.animations[name] = a.animations[name]
			return a.animations[name]
		end
	end

	return nil
end

return setmetatable({ new = new, isatlasbatch = isatlasbatch, }, { __call = function(_, ...) return new(...) end })