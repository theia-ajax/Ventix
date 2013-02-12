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
			con_enable = true,
			on = false,
			showHUD = false,
			gccount = 0,
			gcUpdateRate = 0.5
		},

		input = {
			enabled = true,
		},

		version = "0.1"
	}

	game.center = {
		x = 0,
		y = 0
	}

	game.screen = {
		width = screen.width,
		height = screen.height - game.hud.vertSize
	}
end