local project_list = {
	'arc_tan_visualizer',
	-- 'collision',
	-- 'factory',
	-- 'graph',
	-- 'love-mining-test',
	-- 'sheepolution-demo',
	-- 'sin-cos-visualizer',
	-- 'vampire-test',
}

-- Load each project based on the list 
local projects = {}
for _, project in ipairs(project_list) do
	table.insert(projects, require('src/' .. project))
end

-- Generates the selection_text
local function getSelectionText()
	local selection_text = ''
	
	for i, v in ipairs(project_list) do
		selection_text = selection_text .. i .. ': ' .. v .. '\n'
	end

	return selection_text
end

-- * Wouldn't it be a better idea to have a default function callback which gets
--   called every frame and overwrite it when the active_project changes?
local function setActiveProject(projectNumber)
	active_project = projectNumber

	if projectNumber == 1 then projects[1].load() end
end

function love.load()
	SELECTION_TEXT = getSelectionText()
	print("Hello!")
end


function love.update(dt)
	if active_project == 1 then projects[1].update(dt) end
end

-- Draws the selection list
local drawSelectionList = function (CORNER_SPACING)
	if CORNER_SPACING == nil then CORNER_SPACING = 50	end

	love.graphics.push()
	love.graphics.translate(CORNER_SPACING, CORNER_SPACING)
	love.graphics.print(SELECTION_TEXT)
	love.graphics.pop()
end

function love.draw()
	if active_project == nil then drawSelectionList() end

	if active_project == 1 then projects[1].draw() end
end

function love.keypressed(key)
	-- Checks if a key on the keyboard matching a project number was pressed.
	-- If so, set that as active project
	for i=1, #project_list do
		if tonumber(key) == i then setActiveProject(i) end
	end
end
