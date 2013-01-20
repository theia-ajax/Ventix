Class = require 'hump.class'
vector = require 'hump.vector'

Path = Class
{
	name = "Path",
	function(self, points)
		self.points = points or {n = 0}
	end
}

function Path:getPos(d)
end

function Path:draw()
	for k, v in ipairs(self.points) do
		love.graphics.circle("line", v.x, v.y, 4)
	end
end

LinearPath = Class
{
	name = "LinearPath",
	inherits = Path,
	function(self, points)
		Path.construct(self, points)
	end
}

function LinearPath:getPos(d)
end

function LinearPath:draw()
	for k, v in ipairs(self.points) do
		love.graphics.circle("line", v.x, v.y, 4)
	end
	if self.points.n > 1 then
		for i = 1, self.points.n - 1 do
			p1 = self.points[i]
			p2 = self.points[i+1]
			love.graphics.line(p1.x, p1.y, p2.x, p2.y)
		end
	end
end

SplinePath = Class
{
	name = "SplinePath",
	inherits = Path,
	function(self, points, interp)
		Path.construct(self, points)
		self.interp = interp or 10
		self.curve = {n = 0}
		self:calcCurve()
	end	
}

function SplinePath:calcCurve()
	if self.points.n < 4 then
		return
	end

	for k in pairs(self.curve) do
		self.curve[k] = nil
	end
	self.curve.n = 0

	for i = 2, self.points.n - 2 do
		for j = 0, self.interp - 1 do
			self.curve[self.curve.n] = self:curveSegment(self.points[i - 1], self.points[i + 0],
														 self.points[i + 1], self.points[i + 2],
														 j / self.interp)
			self.curve.n = self.curve.n + 1
		end
	end

	self.curve[self.curve.n] = self.points[self.points.n - 1]
	self.curve.n = self.curve.n + 1
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

function SplinePath:getPos(d)
	if self.curve.n <= 0 then
		return vector(0, 0)
	end
	if d < 0 then d = 0 elseif d > 1 then d = 0 end
	return self.curve[math.floor(self.curve.n * d)]
end

function SplinePath:draw()
	love.graphics.setColor(0, 255, 255)
	for k, v in ipairs(self.points) do
		love.graphics.circle("line", v.x, v.y, 4)
	end

	if self.points.n > 1 then
		love.graphics.setColor(0, 255, 0)
		for i = 1, self.points.n - 1 do
			local p1 = self.points[i]
			local p2 = self.points[i+1]
			love.graphics.line(p1.x, p1.y, p2.x, p2.y)
		end
	end

	if self.curve.n > 0 then
		love.graphics.setColor(255, 0, 0)
		for i = 0, self.curve.n - 2 do
			local p1 = self.curve[i]
			local p2 = self.curve[i+1]
			love.graphics.line(p1.x, p1.y, p2.x, p2.y)
		end
	end
end