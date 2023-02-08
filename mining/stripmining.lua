---@diagnostic disable: unused-function, unused-local

-- functions that work on level 1 and 2
-- when mining watch for gravel
-- one move and mine function to accomplish every direction

-- ### FLAG VARIABLES ###
local running = true
local returning = false
local distance = 0
local y_level = 0
local torch_distance = 12

local FUEL_SLOT = 16
local EXTERNAL_INVENTORY_SLOT = 15
local TORCH_SLOT = 14
local FIRST_PICKUP_SLOT = 13


-- ### MOVING AND MINING - DIRECTION AGNOSTIC ###

local dirs = {
	front = 0,
	back = 1,
	right = 2,
	left = 3,
	up = 4,
	down = 5,
}

local function turn() 
	turtle.turnRight()
	turtle.turnRight()
end

-- move function which takes a direction.
-- if direction is not forwards, up or down then the turtle turns itself
local function move(direction)
	if direction == dirs.front then
		turtle.forward()
	elseif direction == dirs.back then
		turn()
		turtle.forward()
	elseif direction == dirs.right then
		turtle.turnRight()
		turtle.forward()
	elseif direction == dirs.left then
		turtle.turnLeft()
		turtle.forward()
	elseif direction == dirs.up then
		turtle.up()
	elseif direction == dirs.down then
		turtle.down()
	end
end

-- dig function which takes a direction
-- if direction is not forwards, up or down then the turtle turns itself
-- is gravel and sand safe
local function dig(direction)
	if direction == dirs.front then
		while turtle.dig() do end
	elseif direction == dirs.back then
		turn()
		while turtle.dig() do end
	elseif direction == dirs.right then
		turtle.turnRight()
		while turtle.dig() do end
	elseif direction == dirs.left then
		turtle.turnLeft()
		while turtle.dig() do end
	elseif direction == dirs.up then
		while turtle.digUp() do end
	elseif direction == dirs.down then
		while turtle.digDown() do end
	end
end

-- wrapper function for dig and move together
local function dig_and_move(direction)
	dig(direction)
	if direction == dirs.up then
		turtle.up()
		move(dirs.up)
	elseif direction == dirs.down then
		move(dirs.down)
	else 
		move(dirs.front)
	end
end


-- ### INVENTORY FUNCTIONS

local function deposit() end

local function inventory_full()
	if turtle.getItemCount(FIRST_PICKUP_SLOT) > 0 then
		deposit()
	end
end

-- ### FUEL FUNCTIONS ###

local function check_range()
	local fuel = turtle.getFuelLevel()
	if fuel <= distance then
		return false
	end
	return true
end

-- check if there is enough fuel left to do branch mining
-- returns 0 for no, 1 for yes, 2 for yes but then backtrack earlier
local function can_deviate()
	if distance + 10 > turtle.getFuelLevel() then
		return false
	else
		return true
	end
end

-- ### ORE FUNCTIONS ###
local function mine_branch() end

local function check_for_ores()
	if can_deviate() then
		local exists, block = turtle.inspectUp()
		if block.tags and block.tags["c:ores"] then
			mine_branch()
		end
	end
end


-- ### MOVEMENT FUNCTIONS ###

-- internal function used in advanced to decide which movement to use
local function intern_advance()
	if y_level == 0 then
		dig_and_move(dirs.up)
		y_level = 1
	else 
		dig_and_move(dirs.down)
		y_level = 0
	end
end

-- advance three steps forwards
local function advance()
	dig_and_move(dirs.front)
	check_for_ores()
	intern_advance()
	check_for_ores()

	dig_and_move(dirs.front)
	check_for_ores()
	intern_advance()
	check_for_ores()

	dig_and_move(dirs.front)
	check_for_ores()
	intern_advance()
	check_for_ores()

	if distance % 12 == 0 then
		turtle.select(TORCH_SLOT)
		turn()
		turtle.place()
		turn()
	end

	distance = distance + 3
end

local function strip_line(range)
	for i = 1, range, 1 do
		dig_and_move(dirs.front)
		if check_for_ores() then
			mine_branch()
		end
	end
end

local function intern_strip() 
	if y_level == 0 then
		dig_and_move(dirs.up)
		y_level = 1
	else
		dig_and_move(dirs.down)
		y_level = 0
	end
end

local function strip()
	turtle.turnLeft()
	strip_line(4)
	intern_strip()
	if check_for_ores() then
		mine_branch()
	end
	turn()

	strip_line(8)
	intern_strip()
	if check_for_ores() then
		mine_branch()
	end
	turn()
	strip_line(4)
	turtle.turnRight()
end

-- wrapper function to stripmine and set returning if fuel too low
local function stripmine()
	advance()
	strip()
	if check_range() == false then
		returning = true
	end
end

local function return_to_start()
	turn()
	for i = 1, distance, 1 do
		move(dirs.front)
	end
end

-- ### start the program ###

print("Starting the stripmining program")

-- refuel the turtle
turtle.select(FUEL_SLOT)
if turtle.refuel(0) == false then
	error(string.format("Please place a fuel item in slot %s", FUEL_SLOT), 1)
end
turtle.refuel(64)
print("Turtle is refueled")

turtle.select(1)

while not returning do
	stripmine()
end

return_to_start()
