require 'table-save.lua'

Class = require 'hump.class'
json = require 'util.dkjson'
vector = require 'hump.vector'
require 'trigger'
require 'path'

Level = Class
{
	name = "Level",
	function(self, name, load)
		self.loaded = false
		self.data = {}
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

	self.loaded = true
	return true
end

function Level:save()
	table.save(self.data, 'assets/levels/'..self.name..'.lua')
end