local function new(name, type, points, interp, pos)
	return {
		name = name,
		pathtype = type,
		points = points,
		interp = interp,
		position = pos
	}
end

return { new = new }