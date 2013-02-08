Class = require 'hump.class'
require 'path'

PathManager = Class
{
	name = "PathManager",
	function(self)
		self.paths = {}
	end
}

function PathManager:add(path)
	if not self.paths[path.name] then
		self.paths[path.name] = path
	end
end

function PathManager:remove(name)
	if self.paths[name] then
		self.paths[name] = nil
	end
end

function PathManager:clear()
	for k, v in pairs(self.paths) do
		self.paths[k] = nil
	end
end

function PathManager:get(name)
	if self.paths[name] then
		return self.paths[name]
	else
		return nil
	end
end

function PathManager:getCopy(name)
	if self.paths[name] then
		return self.paths[name]:softCopy()
	else
		return nil
	end
end