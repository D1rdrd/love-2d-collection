--[[ Todo List:
	- [x] General ACTIVE_PROJECT logic
]]

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

-- Draws the selection list
local drawSelectionList = function (CORNER_SPACING)
	if CORNER_SPACING == nil then CORNER_SPACING = 50	end

	love.graphics.push()
	love.graphics.translate(CORNER_SPACING, CORNER_SPACING)
	love.graphics.print(SELECTION_TEXT)
	love.graphics.pop()
end

ACTIVE_PROJECT = nil

local function setActiveProject(projectNumber)
	ACTIVE_PROJECT = projectNumber
	projects[ACTIVE_PROJECT].load()
end

function love.load()
	SELECTION_TEXT = getSelectionText()
end

function love.update(dt)
	if ACTIVE_PROJECT == nil then return end
	projects[ACTIVE_PROJECT].update(dt)
end

function love.draw()
	if ACTIVE_PROJECT == nil then drawSelectionList() return end
	projects[ACTIVE_PROJECT].draw()
end

function love.keypressed(key)
	if project_list[tonumber(key)] then setActiveProject(tonumber(key)) end
end
