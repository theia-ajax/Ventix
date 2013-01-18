vector = require 'hump.vector'
camera = require 'hump.camera'
require 'bounds'
require 'player'
require 'gameconf'
require 'gameobjectmanager'
require 'collisionmanager'
require 'enemy'
require 'star'
require 'text'

function love.load()
	initGameConfig()

	p = Player(love.graphics.newImage("assets/player.png"))
	p.position = vector(200, 200)
	e = Enemy(love.graphics.newImage("assets/enemy.png"))
	e.position = vector(800, 200)

	gamecam = camera()
	gameObjects = GameObjectManager()
	collisionManager = CollisionManager()

	for i = 1, game.stars.initialCount do
		gameObjects:register(Star(vector(math.random(screen.width), 
										 math.random(screen.height - game.hud.vertSize))))
	end

	text = Text("THIS IS THE HUD", "center", vector(screen.width / 2, screen.height - (game.hud.vertSize / 2)),
				0, vector(1, 1), 0, 255, 0)

	gameObjects:register(p)
	gameObjects:register(e)
end

function love.keypressed(key, unicode)
	if key == "escape" then
		love.event.push("quit")
	end
end

function love.update(dt)
	if math.random() < game.stars.spawnRate then
		gameObjects:register(Star())
	end

	gameObjects:update(dt)
	gamecam:move(game.scrollSpeed * dt, 0)

	collisionManager:update()
end

function love.draw()
	gamecam:attach()

	gameObjects:draw()

	gamecam:detach()

	love.graphics.setColor(0, 255, 0)
	love.graphics.rectangle("line", 0, screen.height - game.hud.vertSize, screen.width, game.hud.vertSize)
	text:draw()
end
