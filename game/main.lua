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

--- Generates the selection_text
local function getSelectionText()
	local selection_text = ''
	
	for i, v in ipairs(project_list) do
		selection_text = selection_text .. i .. ': ' .. v .. '\n'
	end

	return selection_text
end

local function setActiveProject(projectNumber)
	active_project = projectNumber

	if projectNumber == 1 then arctan.load() end
end

function love.load()
	SELECTION_TEXT = getSelectionText()
	print("Hello!")
end


function love.update(dt)
	if active_project == 1 then arctan.update(dt) end
end

--- Draws the selection list
local drawSelectionList = function (CORNER_SPACING)
	if CORNER_SPACING == nil then CORNER_SPACING = 50	end

	love.graphics.push()
	love.graphics.translate(CORNER_SPACING, CORNER_SPACING)
	love.graphics.print(SELECTION_TEXT)
	love.graphics.pop()
end

function love.draw()
	if active_project == nil then drawSelectionList() end

	if active_project == 1 then arctan.draw() end
end

-- Checks if a key on the keyboard matching a project number was pressed.
-- If so, returns the number
local doCheckIfNumberPressed = function (key)
	for i=1, #project_list do
		if key == tostring(i) then
			print('Pressed key ' .. i)
			return i
		end
	end
end

function love.keypressed(key)
	if doCheckIfNumberPressed(key) == 1 then setActiveProject(1) end
end
