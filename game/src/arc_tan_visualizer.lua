--   Project: ArcTan visualizer
--[[ Description:
	A visualizer on how the sin and cos are wave functions
]]

local arc = {}

function arc.load()
  font = love.graphics.newFont("assets/arial.ttf", 40)
  success = love.window.setMode( "1280", "512" )
  
  -- Main Circle
  list_circles = {}
  min_x, min_y = 50, 50
  max_x, max_y = 500, 500
  num_circles = 360
  spacing = 70  
  radius = 150
  
  center_x, center_y = (max_x - min_x) / 2 + min_x, (max_y - min_y) / 2 + min_y
  
  createCircleOfCircles()
  
  -- Moving Circles
  list_sm_circles = {}
  list_cm_circles = {}
  m_circle_h = 600
  
  --
  sin_index = num_circles / 2 + 1
  cosin_index = num_circles / 4 * 3 + 1
  s_countdown = 3
  c_countdown = 3
  
  -- Relay Circles
  list_sr_circles = {}
  list_sr_lines = {}
  
  list_cr_circles = {}
  list_cr_lines = {}
  
  max_countdown = 1
  
end

function arc.update(dt)
  for i, circle in ipairs(list_sm_circles) do
    circle.x = circle.x + circle.speed * dt
  end
  for i, circle in ipairs(list_cm_circles) do
    circle.x = circle.x + circle.speed * dt
  end

  
  if sin_index < table.maxn(list_circles) + 1 then
    --createSinMovingCircle(list_circles[sin_index].real_x, list_circles[sin_index].real_y)
    createSinMovingCircle(m_circle_h, list_circles[sin_index].real_y)
    createSinRelayCircle(list_circles[sin_index].real_x, list_circles[sin_index].real_y)
  end
  
  if cosin_index < table.maxn(list_circles) + 1 then
    --createSinMovingCircle(list_circles[sin_index].real_x, list_circles[sin_index].real_y)
    createCosinMovingCircle(m_circle_h, list_circles[cosin_index].real_y)
    createCosinRelayCircle(list_circles[cosin_index].real_x, list_circles[cosin_index].real_y)
  end
  
  if s_countdown == 0 then
    if sin_index > table.maxn(list_circles) - 1 then
      sin_index = 1
    else
      sin_index = sin_index + 1
    end
    s_countdown = max_countdown
  else
    s_countdown = s_countdown - 1
  end
  
  if c_countdown == 0 then
    if cosin_index > table.maxn(list_circles) - 1 then
      cosin_index = 1
    else
      cosin_index = cosin_index + 1
    end
    c_countdown = max_countdown
  else
    c_countdown = c_countdown - 1
  end
  
end

function arc.draw()
  
  love.graphics.setFont(font)
  -- Debug Text
  love.graphics.setColor(1, 1, 1)
  --love.graphics.print("x: " .. tostring(love.mouse.getX()), 10, 10)
  --love.graphics.print("y: " .. tostring(love.mouse.getY()), 10, 25)
  if sin_index > 180 then
    angle = sin_index - 180
  else
    angle = sin_index + 180
  end
  love.graphics.print("angle: " .. angle .. "°", 30, 30)
  
  -- Center Circle
  love.graphics.setColor(1, 0, 0)
  drawCircle(center_x, center_y)
  
  -- Main Circle
  love.graphics.setColor(1, 1, 1)
  for i, circle in ipairs(list_circles) do 
    drawCircle(circle.real_x, circle.real_y)
  end
  
  
  for i, circle in ipairs(list_cr_circles) do 
    love.graphics.setColor(1, 0.5, 0.5)
    drawRelayLines(circle.x, circle.y)
    love.graphics.setColor(1, 0, 0)
    drawBigCircle(circle.x, circle.y)
    
    table.remove(list_cr_circles, 1)
    
  end
  
  for i, circle in ipairs(list_sr_circles) do 
    love.graphics.setColor(0.5, 0.5, 1)
    drawRelayLines(circle.x, circle.y)
    
    love.graphics.setColor(0, 0, 1)
    drawBigCircle(circle.x, circle.y)
    
    table.remove(list_sr_circles, 1)
    
  end
  
  -- Moving Circles
  love.graphics.setColor(1, 0, 0)
  for i, circle in ipairs(list_cm_circles) do 
    drawCircle(circle.x, circle.y)
  end
  
  love.graphics.setColor(0, 0, 1)
  for i, circle in ipairs(list_sm_circles) do 
    drawCircle(circle.x, circle.y)
  end
end

function createCircle(x, y)
  circle = {}
  circle.x = x
  circle.y = y
  
  circle.distance = math.sqrt((center_x - x) ^ 2 + (center_y - y) ^ 2)
  
  vx, vy = center_x - circle.x, center_y - circle.y
  
  if (vx > 0 and vy > 0) or (vx < 0 and vy < 0) then
    total_vector = math.abs(vx + vy)
  else
    total_vector = math.abs(vx - vy)
  end
  
  circle.vx_norm, circle.vy_norm = vx /  circle.distance, vy / circle.distance
  
  vx_norm, vy_norm = circle.vx_norm, circle.vy_norm
  
  circle.real_x = center_x + radius * circle.vx_norm
  circle.real_y = center_y + radius * circle.vy_norm
  
  table.insert(list_circles, circle)
  
end

function createCircleOfCircles()
  
  --[[
  for x=min_x, max_x, spacing do createCircle(x, min_y) end
  for y=min_y, max_y, spacing do createCircle(max_x, y) end
  
  for x=max_x, min_x, -spacing do createCircle(x, max_y) end
  for y=max_y, min_y, -spacing do createCircle(min_x, y) end
  ]]
  
  for i = num_circles - 1, 0, -1 do
    local angle = (2 * math.pi / num_circles) * i -- Calculate angle in radians
    local x = center_x + radius * math.cos(angle) -- X position
    local y = center_y + radius * math.sin(angle) -- Y position
    createCircle(x, y)
  end
end

function drawCircle(x, y)
  love.graphics.circle("fill", x, y, 10)
end

function drawBigCircle(x, y)
  love.graphics.circle("fill", x, y, 20)
end

function drawRelayLines(x, y)
  love.graphics.rectangle("fill", x, y- 5, m_circle_h - x, 10)
end

function createSinMovingCircle(x, y)
  m_circle = {}
  m_circle.x = x
  m_circle.y = y
  
  m_circle.speed = 100
  m_circle.lifespan = 5000
  
  table.insert(list_sm_circles, m_circle)
end

function createSinRelayCircle(x, y)
  r_circle = {}
  r_circle.x = x
  r_circle.y = y
  
  table.insert(list_sr_circles, r_circle)
end

function createCosinMovingCircle(x, y)
  m_circle = {}
  m_circle.x = x
  m_circle.y = y
  
  m_circle.speed = 100
  m_circle.lifespan = 5000
  
  table.insert(list_cm_circles, m_circle)
end

function createCosinRelayCircle(x, y)
  r_circle = {}
  r_circle.x = x
  r_circle.y = y
  
  table.insert(list_cr_circles, r_circle)
end

return arc
