_print = print
Timer = require 'hump.timer'
vector = require 'hump.vector'
Camera = require 'hump.camera'
atlas = require 'mate.atlas'
anim = require 'mate.animation'
animObject = require 'mate.animobject'
atlasBatch = require 'mate.atlasbatch'
Console = require 'love-console.console'
require 'table-save'
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
require 'level'
require 'objectpool'

function love.load()
	initGameConfig()

	love.graphics.setFont(love.graphics.newFont())

	game.camera = Camera()
	game.center.x, game.center.y = game.camera:pos()
	game.center.y = (game.center.y + (game.center.y - game.hud.vertSize)) / 2

	atlases = atlasBatch()
	atlases:load("assets/atlasindex.json")

	-- local at = atlas("assets/floppyFloop.png", "assets/floppyFloop.json")
	-- at:build()
	-- aObj = animObject()
	-- aObj:add(atlases, "armWave")
	-- aObj:play(true, false, 0.05)
	-- aObj:setFrame(1)

	game.gameObjects = GameObjectManager()
	collisionManager = CollisionManager()

	game.starPool = ObjectPool(200)
	for i = 1, game.stars.initialCount do
		game.starPool:register(Star(vector(math.random(screen.width), 
					 					   math.random(screen.height - game.hud.vertSize))))
	end

	text = Text("THIS IS THE HUD", "center", 
				vector(screen.width / 2, screen.height - (game.hud.vertSize / 2)),
				0, vector(1, 1), 0, 255, 0)


	p = Player(love.graphics.newImage("assets/player.png"))
	p.position = vector(200, 200)
	game.gameObjects:register(p)

	for i = 1, 50 do
		local cx, cy = game.camera:pos()
		local e = Enemy(love.graphics.newImage("assets/enemy.png"))
		local ex = screen.width + 50 + (250 * i)
		local ey = math.random(64, screen.height - game.hud.vertSize) + (cy - screen.height / 2) - 64
		e.position = vector(ex, ey)
		game.gameObjects:register(e)
	end
	
	-- path = SplinePath()
	-- path:add(vector(100, 100), false)
	-- path:add(vector(100, 100), false)
	-- path:add(vector(150, 150), false)
	-- path:add(vector(200, 200), false)
	-- path:add(vector(250, 175), false)
	-- path:add(vector(300, 100), false)
	-- path:add(vector(300, 100), true)
	
	game.console = Console.new(love.graphics.newFont("love-console/VeraMono.ttf", 12),
	                           love.graphics.getWidth(), 200, 4, console_disabled)
	startup()

	game.gameObjects:register(Trigger(function() print("Hit Trigger") end, 400))

	if game.stars.spawnRate >= 0 then 
		Timer.addPeriodic(game.stars.spawnRate, function() game.starPool:register(Star()) end)
	end
	Timer.addPeriodic(game.debug.gcUpdateRate, function() game.debug.gccount = collectgarbage("count") end)
end

function console_disabled()
	game.input.enabled = true
end

function love.keypressed(key, unicode)
	if key == "escape" then
		love.event.push("quit")
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
		game.console:focus()
		game.input.enabled = false
	end
end

function love.update(dt)
	game.gameObjects:update(dt)
	game.camera:move(game.scrollSpeed * dt, 0)
	game.center.x, game.center.y = game.camera:pos()
	game.center.y = (game.center.y + (game.center.y - game.hud.vertSize)) / 2

	collisionManager:update()

	-- aObj:update(dt)

	game.console:update(dt)

	Timer.update(dt)
end

function love.draw()
	game.camera:attach()

	game.gameObjects:draw()

	if game.debug.on then
		local cx, cy = game.center.x, game.center.y
		love.graphics.setColor(0, 0, 255)
		love.graphics.line(cx, cy - 5, cx, cy + 5)
		love.graphics.line(cx - 5, cy, cx + 5, cy)
	end

	game.camera:detach()

	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 0, screen.height - game.hud.vertSize, screen.width, game.hud.vertSize)
	love.graphics.setColor(0, 255, 0)
	love.graphics.rectangle("line", 0, screen.height - game.hud.vertSize, screen.width, game.hud.vertSize)
	text:draw()

	debugDraw()

	-- path:draw()

	-- love.graphics.setColor(255, 255, 255)
	-- aObj:draw(0, 300)

	game.console:draw()
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
		love.graphics.print("GameObjects: "..tostring(game.gameObjects.debug.objCount), 10, 40)
		love.graphics.print("Collidables: "..tostring(collisionManager.debug.objCount), 10, 55)
		-- love.graphics.print("press 'd' to hide", 50, 90)
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
	return game.console:print(...)
end

function printf(fmt, ...)
	return print(string.format(fmt, ...))
end

function clear()
	game.console:clear()
end

function startup()
	print("  Ventix  v"..game.version)
	print()
	print("  <Escape> or ~ leaves the console. Call quit() or exit() to quit.")
	print("  Try hitting <Tab> to complete your current input.")
	print("  Type help() for commands and usage")
	print("  You can overwrite every love callback (but love.keypressed).")
	print()

	debughud(1)
end

function debughud(val)
	if val then
		game.debug.showHUD = true
	else
		game.debug.showHUD = false
	end
end