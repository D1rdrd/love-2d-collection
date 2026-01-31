--   Project: ArcTan visualizer
--[[ Description:
	A visualizer on how the sin and cos are wave functions
]]

--[[ Todo List:
	- [ ] Add the cos function
  - [ ] Refactor the figures to have a better structure
	- [ ] Add lines connecting the relay circles and figures
	- [ ] Fix the graphical bug on the relay figures
    - Try and add the coords every 5 frames instead on each one
]]

local arc = {}

local window = {}
window.width, window.height = love.window.getDesktopDimensions()
local game = {}
game.width, game.height = math.floor(window.width * 0.66), math.floor(window.height * 0.66)

local mainCircle = {
  center_x = game.width/6,
  center_y = game.height/2,
  radius   = game.height/6,
}

function mainCircle:draw()
  love.graphics.push()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setLineWidth(game.height/32)
  love.graphics.circle("line", self.center_x, self.center_y, self.radius)
  love.graphics.pop()
end

local relayCircle = {
  list = {}
}

function relayCircle:create(x, y, color)
  local circle = {
    x = x,
    y = y,
    size = game.height/32,
    color = color or {1, 1, 1},
    angle = 0,
    speed = 100,
    figure = {} -- List of figure points
  }

  table.insert(self.list, circle)
end

function relayCircle:draw()
  for i, c in ipairs(self.list) do
    love.graphics.push()
    love.graphics.setColor(c.color)
    love.graphics.circle('fill', math.floor(c.x), math.floor(c.y), c.size)
    love.graphics.pop()

    love.graphics.print("angle: " .. math.floor(c.angle) .. "°", game.height/8, i*game.height/16) 

    if #c.figure > 2 then
      love.graphics.line(c.figure)
    end
  end
end

function relayCircle:update(dt)
  for i, c in ipairs(self.list) do
    -- Update cardinal coords based on polar coords
    c.x = mainCircle.center_x + mainCircle.radius*math.cos(math.rad(c.angle))
    c.y = mainCircle.center_y - mainCircle.radius*math.sin(math.rad(c.angle))
    
    -- Insert the new position on the figure table
    table.insert(c.figure, game.height/2) 
    table.insert(c.figure, c.y)
    

    for j, f in ipairs(c.figure) do
      if j%2== 1 then
        c.figure[j] = c.figure[j] + 100 * dt

        if c.figure[j] > game.width/2 then -- Remove out of screen figures
          table.remove(c.figure, j)
          table.remove(c.figure, j)
        end
      end
    end

    -- Update the angle
    if c.angle > 360 then c.angle = 0.1
    else c.angle = c.angle + c.speed * dt end
  end
end

function arc.load()
  love.graphics.setFont(love.graphics.newFont("assets/arial.ttf", 40))
  love.window.setMode(game.width, game.height)

  -- Sin relay circle
  relayCircle:create(mainCircle.center_x+mainCircle.radius, mainCircle.center_y, {0, 0, 1})
  -- Todo: Cos relay circle
end

function arc.update(dt)
  relayCircle:update(dt)
end

function arc.draw()
  mainCircle:draw()
  relayCircle:draw()
end

return arc
