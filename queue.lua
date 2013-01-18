Class = require 'hump.class'

Queue = Class
{
	name = "Queue",
	function(self)
		self.data = {}
		self.data.n = 0
		self.head = 0
		self.tail = 0
	end
}

function Queue:push(obj)
	self.data[self.tail] = obj
	self.data.n = self.data.n + 1
	self.tail = self.tail + 1
end

function Queue:pop()
	if self.data.n <= 0 then
		return nil
	end

	result = self.data[self.head]
	self.data[self.head] = nil
	self.data.n = self.data.n - 1
	self.head = self.head + 1
	if self.data.n <= 0 then
		self.head = 0
		self.tail = 0
	end
	return result
end

function Queue:peek()
	if self.data.n <= 0 then
		return nil
	else
		return self.data[self.head]
	end
end

function Queue:size()
	return self.data.n
end