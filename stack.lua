Class = require 'hump.class'

Stack = Class
{
	name = "Stack",
	function(self)
		self.data = {}
		self.data.n = 0
	end
}

function Stack:push(obj)
	self.data[self.data.n] = obj
	self.data.n = self.data.n + 1
end

function Stack:pop()
	if self.data.n <= 0 then
		return nil
	end

	result = self.data[self.data.n - 1]
	self.data[self.data.n - 1] = nil
	self.data.n = self.data.n - 1
	return result
end

function Stack:peek()
	if self.data.n <= 0 then
		return nil
	else
		return self.data[self.data.n - 1]
	end
end

function Stack:size()
	return self.data.n
end