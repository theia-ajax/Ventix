_print = print
Timer = require 'hump.timer'
vector = require 'hump.vector'
camera = require 'hump.camera'
atlas = require 'mate.atlas'
anim = require 'mate.animation'
animObject = require 'mate.animObject'
atlasBatch = require 'mate.atlasBatch'
Console = require 'love-console.console'
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
require 'trigger'

function love.load()
	initGameConfig()

	love.graphics.setFont(love.graphics.newFont())

	p = Player(love.graphics.newImage("assets/player.png"))
	p.position = vector(200, 200)
	e = Enemy(love.graphics.newImage("assets/enemy.png"))
	e.position = vector(800, 200)

	atlases = atlasBatch()
	atlases:load("assets/atlasindex.json")

	-- local at = atlas("assets/floppyFloop.png", "assets/floppyFloop.json")
	-- at:build()
	-- aObj = animObject()
	-- aObj:add(atlases, "armWave")
	-- aObj:play(true, false, 0.05)
	-- aObj:setFrame(1)


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

	-- path = SplinePath()
	-- path:add(vector(100, 100), false)
	-- path:add(vector(100, 100), false)
	-- path:add(vector(150, 150), false)
	-- path:add(vector(200, 200), false)
	-- path:add(vector(250, 175), false)
	-- path:add(vector(300, 100), false)
	-- path:add(vector(300, 100), true)
	
	console = Console.new(love.graphics.newFont("love-console/VeraMono.ttf", 12),
	                          love.graphics.getWidth(), 200, 4, console_disabled)
	startup()

	gameObjects:register(Trigger(function() print("Hit Trigger") end, 400))

	Timer.addPeriodic(game.stars.spawnRate, function() gameObjects:register(Star()) end)
	Timer.addPeriodic(game.debug.gcUpdateRate, function() game.debug.gccount = collectgarbage("count") end)
end

function console_disabled()
	game.input.enabled = true
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

	if key == "r" then
		if aObj.playing then
			aObj:pause()
		else
			aObj:resume()
		end
	end

	if key == "`" and game.debug.con_enable then
		console:focus()
		game.input.enabled = false
	end
end

function love.update(dt)
	gameObjects:update(dt)
	gamecam:move(game.scrollSpeed * dt, 0)

	collisionManager:update()

	-- aObj:update(dt)

	console:update(dt)

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

	-- path:draw()

	-- love.graphics.setColor(255, 255, 255)
	-- aObj:draw(0, 300)

	console:draw()
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

----------------------------------
--		Console Functions       --
----------------------------------

function quit()
	love.event.push("quit")
end
exit = quit

function print(...)
	return console:print(...)
end

function printf(fmt, ...)
	return print(string.format(fmt, ...))
end

function clear()
	console:clear()
	startup()
end

function startup()
	print("  Ventix  v"..game.version)
	print()
	print("  <Escape> or ~ leaves the console. Call quit() or exit() to quit.")
	print("  Try hitting <Tab> to complete your current input.")
	print("  Type help() for commands and usage")
	print("  You can overwrite every love callback (but love.keypressed).")
	print()	
end

