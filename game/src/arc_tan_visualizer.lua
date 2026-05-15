--   Project: ArcTan visualizer
--[[ Description:
	A visualizer on how the sin and cos are wave functions
]]

--[[ Todo List:
	- [ ] Add the cos function
  - [ ] Refactor the figures to have a better structure
	- [x] Add lines connecting the relay circles and figures
	- [x] Fix the graphical bug on the relay figures
]]

local arc = {}

local window = {}
window.width, window.height = love.window.getDesktopDimensions()
local game = {}
game.width, game.height = math.floor(window.width * 0.66), math.floor(window.height * 0.66)

local mainCircle = {
  center_x = game.width /6,
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
    x =      x,
    y =      y,
    size =   game.height/32,
    color =  color or {1, 1, 1},
    angle =  0,
    speed =  100,
    figure = {} -- List of figure points
  }

  table.insert(self.list, circle)
end

function relayCircle:draw()
  for i, c in ipairs(self.list) do
    if #c.figure <= 2 then break end  -- Skip frame if the line has less than two vertices

    -- Line
    love.graphics.setColor(0.5, 0.5, 1)
    love.graphics.setLineWidth(game.height/64)
    love.graphics.line(math.floor(c.x), math.floor(c.y), c.figure[#c.figure-1], c.figure[#c.figure])

    -- Relay circle
    love.graphics.setColor(c.color)
    love.graphics.circle('fill', math.floor(c.x), math.floor(c.y), c.size)

    -- Angle text
    love.graphics.print("angle: " .. math.floor(c.angle) .. "°", game.height/8, i*game.height/16) 

    -- Wave shape
    love.graphics.setLineWidth(game.height/32)
    love.graphics.line(c.figure)
    love.graphics.circle('fill', c.figure[1],           c.figure[2],         game.height/64) -- Trail smoothing start
    love.graphics.circle('fill', c.figure[#c.figure-1], c.figure[#c.figure], game.height/64) -- Trail smoothing end
  end
end

function relayCircle:update(dt)
  for _, c in ipairs(self.list) do
    -- Update cardinal coords based on polar coords
    c.x = mainCircle.center_x + mainCircle.radius*math.cos(math.rad(c.angle))
    c.y = mainCircle.center_y - mainCircle.radius*math.sin(math.rad(c.angle))

    if self.start == nil then 
      self.start = love.timer.getTime()
    else
      self.result = love.timer.getTime() - self.start
      if self.result > 0.01 then
        -- Insert the new position on the figure table
        table.insert(c.figure, game.height/2) 
        table.insert(c.figure, c.y)
        self.start = love.timer.getTime()
      end
    end

    for i in ipairs(c.figure) do
      if i%2== 1 then
        c.figure[i] = c.figure[i] + 100 * dt

        if c.figure[i] > game.width*1.2 then -- Remove off-screen figures
          table.remove(c.figure, i)
          table.remove(c.figure, i)
        end
      end
    end

    -- Update the angle
    if c.angle > 360 then c.angle = c.angle - 360 end -- Adjust if full circle
    c.angle = c.angle + c.speed * dt
  end
end

function arc.load()
  love.graphics.setFont(love.graphics.newFont("assets/arial.ttf", 40))
  love.window.setMode(game.width, game.height)

  -- Sin relay circle
  relayCircle:create(mainCircle.center_x+mainCircle.radius, mainCircle.center_y, {0, 0, 1})
  -- Cos relay circle
  --relayCircle:create(mainCircle.center_x-mainCircle.radius, mainCircle.center_y, {1, 0, 0})
end

function arc.update(dt)
  relayCircle:update(dt)
end

function arc.draw()
  mainCircle:draw()
  relayCircle:draw()
end

return arc
