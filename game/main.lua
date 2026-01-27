arctan = require('src/arc_tan_visualizer')

local project_list = {
	'arc-tan-visualizer',
	'collision',
	'factory',
	'graph',
	'love-mining-test',
	'sheepolution-demo',
	'sin-cos-visualizer',
	'vampire-test',
}

local function getSelectionText()
	local selection_text = ''
	
	for i, v in ipairs(project_list) do
		selection_text = selection_text .. i .. ': ' .. v .. '\n'
	end

	return selection_text
end

function love.load()
	SELECTION_TEXT = getSelectionText()
	print("Hello!")
	arctan.load()
end

function love.update()
	
end

local drawSelectionList = function ()
	local CORNER_SPACING = 50

	love.graphics.push()
	love.graphics.translate(CORNER_SPACING, CORNER_SPACING)
	love.graphics.print(SELECTION_TEXT)
	love.graphics.pop()
end

function love.draw()
	drawSelectionList()
end

local doCheckIfNumberPressed = function (key)
	for i=1, #project_list do
		if key == tostring(i) then
			print('Pressed key ' .. i)
		end
	end
end

function love.keypressed(key)
	doCheckIfNumberPressed()
end
