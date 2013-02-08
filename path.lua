Class = require 'hump.class'
vector = require 'hump.vector'

Path = Class
{
	name = "Path",
	function(self, name, points, interp, pos)
		self.name = name or "default"
		self.pathtype = "path"
		self.position = pos or vector.zero
		self.points = points or {}
		self.interp = interp or 100
		self.curve = {n = 0}
		self:calcCurve()
	end
}

function Path:calcCurve()
end

function Path:add(p, recalc)
	table.insert(self.points, p)
	if recalc then self:calcCurve() end
end

function Path:clear()
	for k in pairs(self.points) do self.points[k] = nil end
	for k in pairs(self.curve) do self.curve[k] = nil end
end

function Path:getPos(d)
	if #self.curve <= 0 then
		return vector.zero
	end
	if d < 0 then d = 0 elseif d > 1 then d = 0 end
	return self.curve[math.floor(#self.curve * d) + 1] + self.position
end

function Path:draw()
	for k, v in ipairs(self.points) do
		love.graphics.circle("line", v.x + self.position.x, v.y + self.position.y, 4)
	end
end

function Path:softCopy()
	local p

	if self.pathtype == "linearpath" then
		p = LinearPath()
		p.length = self.length
	elseif self.pathtype == "splinepath" then
		p = SplinePath()
	else
		p = Path()
	end

	p.position = self.position:clone()
	p.interp = self.interp
	p.points = self.points
	p.curve = self.curve
	return p
end

LinearPath = Class
{
	name = "LinearPath",
	inherits = Path,
	function(self, name, points, interp, pos)
		Path.construct(self, name, points, interp, pos)
		self.pathtype = "linearpath"
		self.length = 0
		self.curve = {n = 0}
		self:calcCurve()
	end
}

function LinearPath:calcLength()
	if #self.points < 2 then return 0 end

	local l = 0

	for i = 1, #self.points - 1 do
		local p1 = self.points[i]
		local p2 = self.points[i+1]

		l = l + vector.dist(p1, p2)
	end

	return l
end

function LinearPath:calcCurve()
	if #self.points < 2 then return end

	self.length = self:calcLength()

	for k in pairs(self.curve) do self.curve[k] = nil end

	for i = 1, #self.points - 1 do
		local p1 = self.points[i]
		local p2 = self.points[i+1]
		local d = vector.dist(p1, p2)

		local segCount = d / self.length * self.interp

		for j = 0, segCount - 1 do
			table.insert(self.curve, vector.lerp(p1, p2, j / segCount))
		end
		table.insert(self.curve, p2)
	end
end

function LinearPath:draw()
	local px, py = self.position.x, self.position.y

	if #self.points > 1 then
		love.graphics.setColor(0, 255, 255)
		for k, v in ipairs(self.points) do
			love.graphics.circle("line", v.x + px, v.y + py, 4)
		end
		love.graphics.setColor(0, 255, 0)
		for i = 1, #self.points - 1 do
			local p1 = self.points[i]
			local p2 = self.points[i+1]
			love.graphics.line(p1.x + px, p1.y + py, p2.x + px, p2.y + py)
		end
	end

	-- if self.curve.n > 1 then
	-- 	love.graphics.setColor(255, 0, 0)
	-- 	for i = 0, self.curve.n - 2 do
	-- 		local p1 = self.curve[i]
	-- 		local p2 = self.curve[i+1]
	-- 		love.graphics.line(p1.x, p1.y, p2.x, p2.y)
	-- 	end
	-- end
end

function LinearPath:clone()
	return LinearPath(self.points, self.interp, self.position)
end

SplinePath = Class
{
	name = "SplinePath",
	inherits = Path,
	function(self, name, points, interp, pos)
		Path.construct(self, name, points, interp, pos)
		self.pathtype = "splinepath"
		self.curve = {n = 0}
		self:calcCurve()
	end	
}

function SplinePath:calcCurve()
	if #self.points < 4 then
		return
	end

	for k in pairs(self.curve) do self.curve[k] = nil end

	for i = 2, #self.points - 2 do
		for j = 0, self.interp - 1 do
			table.insert(self.curve, self:curveSegment(self.points[i - 1], self.points[i + 0],
									  				   self.points[i + 1], self.points[i + 2],
													   j / self.interp))
		end
	end

	table.insert(self.curve, self.points[self.points[#self.points]])
end

function SplinePath:curveSegment(p1, p2, p3, p4, t)
	result = vector(0, 0)
	
	local t1 = ((-t + 2) * t - 1) * t * 0.5
	local t2 = (((3 * t - 5) * t) * t + 2) * 0.5
	local t3 = ((-3 * t + 4) * t + 1) * t * 0.5
	local t4 = ((t - 1) * t * t) * 0.5

	result.x = p1.x * t1 + p2.x * t2 + p3.x * t3 + p4.x * t4
	result.y = p1.y * t1 + p2.y * t2 + p3.y * t3 + p4.y * t4

	return result
end

function SplinePath:draw()
	local px, py = self.position.x, self.position.y
	if #self.points > 1 then
		love.graphics.setColor(0, 255, 255)
		for k, v in ipairs(self.points) do
			love.graphics.circle("line", v.x + px, v.y + py, 4)
		end

		love.graphics.setColor(0, 255, 0)
		for i = 1, #self.points - 1 do
			local p1 = self.points[i]
			local p2 = self.points[i+1]
			love.graphics.line(p1.x + px, p1.y + py, p2.x + px, p2.y + py)
		end
	end

	if #self.curve > 1 then
		love.graphics.setColor(255, 0, 0)
		for i = 1, #self.curve - 1 do
			local p1 = self.curve[i]
			local p2 = self.curve[i+1]
			love.graphics.line(p1.x + px, p1.y + py, p2.x + px, p2.y + py)
		end
	end
end