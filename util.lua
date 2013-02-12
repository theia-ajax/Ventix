vector = require 'hump.vector'
require 'enemy'

function spawnEnemy(...)
	local imgname = arg[1] or "assets/enemy.png"
	local pos = arg[2] or vector(100, game.screen.height / 2)
	local cx, cy = game.camera:pos()
	pos.x, pos.y = pos.x + cx, pos.y + (cy - screen.height / 2)
	print(pos.x, pos.y)

	local enemy = Enemy(love.graphics.newImage(imgname))
	enemy.position = pos
	game.gameObjects:register(enemy)
end