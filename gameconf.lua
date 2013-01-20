function initGameConfig()
	screen = {
		width = love.graphics.getWidth(),
		height = love.graphics.getHeight()
	}

	game = {
		scrollSpeed = 50,

		stars = {
			spawnRate = 0.2,
			initialCount = 100, 
			radius = 1
		},

		hud = {
			vertSize = 96
		},

		debug = {
			on = true,
			showHUD = false
		}
	}
end