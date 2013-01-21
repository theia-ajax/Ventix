local json = require 'dkjson'

local atlas = {}
atlas.__index = atlas

local function new(imgfile, datafile)

end

local function isatlas(a)
	return getmetatable(a) == atlas
end

return setmetatable({
						new = new,
						isatlas = isatlas,
					},
					{ __call = function(_, ...) return new(...) end	})