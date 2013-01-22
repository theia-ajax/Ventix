Timer = require 'hump.timer'
vector = require 'hump.vector'
camera = require 'hump.camera'
atlas = require 'mate.atlas'
require 'bounds'
require 'player'
require 'gameconf'
require 'gameobjectmanager'
require 'collisionmanager'
require 'enemy'
require 'star'
require 'text'
require 'numformat'
require 'path'

function love.load()
	initGameConfig()

	p = Player(love.graphics.newImage("assets/player.png"))
	p.position = vector(200, 200)
	e = Enemy(love.graphics.newImage("assets/enemy.png"))
	e.position = vector(800, 200)

	local at = atlas("assets/testpacker.png", "assets/testpacker.json")
	at:build()

	gamecam = camera()
	gameObjects = GameObjectManager()
	collisionManager = CollisionManager()

	for i = 1, game.stars.initialCount do
		gameObjects:register(Star(vector(math.random(screen.width), 
										 math.random(screen.height - game.hud.vertSize))))
	end

	text = Text("THIS IS THE HUD", "center", 
				vector(screen.width / 2, screen.height - (game.hud.vertSize / 2)),
				0, vector(1, 1), 0, 255, 0)

	gameObjects:register(p)
	gameObjects:register(e)

	path = SplinePath()
	path:add(vector(100, 100), false)
	path:add(vector(100, 100), false)
	path:add(vector(150, 150), false)
	path:add(vector(200, 200), false)
	path:add(vector(250, 175), false)
	path:add(vector(300, 100), false)
	path:add(vector(300, 100), true)
	ppt = vector.zero
	time = 0

	Timer.addPeriodic(game.stars.spawnRate, function() gameObjects:register(Star()) end)
	Timer.addPeriodic(game.debug.gcUpdateRate, function() game.debug.gccount = collectgarbage("count") end)
end

function love.keypressed(key, unicode)
	if key == "escape" then
		love.event.push("quit")
	end

	if game.debug.on and key == "d" then
		game.debug.showHUD = not game.debug.showHUD
	end
	if key == "\\" then
		game.debug.on = not game.debug.on
	end
end

function love.update(dt)

	gameObjects:update(dt)
	gamecam:move(game.scrollSpeed * dt, 0)

	collisionManager:update()

	path.position.x = path.position.x + 20 * dt
	time = time + 0.25 * dt
	while time > 1 do time = time - 1 end
	ppt = path:getPos(time)

	Timer.update(dt)
end

function love.draw()
	gamecam:attach()

	gameObjects:draw()

	gamecam:detach()

	love.graphics.setColor(0, 255, 0)
	love.graphics.rectangle("line", 0, screen.height - game.hud.vertSize, screen.width, game.hud.vertSize)
	text:draw()

	debugDraw()

	path:draw()
	love.graphics.circle("fill", ppt.x, ppt.y, 4)
end


function debugDraw()
	if game.debug.on and game.debug.showHUD then
		love.graphics.setFont(love.graphics.newFont(12))
		love.graphics.setColor(0, 0, 0, 127)
		love.graphics.rectangle("fill", 5, 5, 200, 100)
		love.graphics.setColor(0, 255, 0)
		love.graphics.rectangle("line", 5, 5, 200, 100)
		love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 10, 10)
		love.graphics.print("Garbage: "..format_num(game.debug.gccount), 10, 25)
		love.graphics.print("GameObjects: "..tostring(gameObjects.debug.objCount), 10, 40)
		love.graphics.print("Collidables: "..tostring(collisionManager.debug.objCount), 10, 55)
		love.graphics.print("press 'd' to hide", 50, 90)
	end
end
