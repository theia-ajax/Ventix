require 'table-save'

Class = require 'hump.class'
vector = require 'hump.vector'
require 'trigger'
local Paths = require 'path'
require 'pathmanager'

Level = Class
{
	name = "Level",
	function(self, name, load)
		self.loaded = false
		self.data = {
			paths = {},
			enemies = {},
			triggers = {}
		}
		self.paths = PathManager()
		self.name = name
		if load == nil then load = true end
		if name and load then 
			self:load(name) 
		end
	end
}

function Level:load(name)
	if self.loaded then return false end
	if not self.name and not name then return false end

	self.name = name

	self.data, err = table.load('assets/levels/'..name..'.lua')

	if err then
		print(err)
		return false
	end

	if self.data.paths then
		for k, v in pairs(self.data.paths) do
			self.paths:add(Paths.fromModel(v))
		end
	end

	self.loaded = true
	return true
end

function Level:save()
	table.save(self.data, 'assets/levels/'..self.name..'.lua')
end