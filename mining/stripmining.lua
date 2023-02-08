---@diagnostic disable: unused-function, unused-local

-- ### FLAG VARIABLES ###
local running = true
local returning = false
local distance = 0

local FUEL_SLOT = 15
local EXTERNAL_INVENTORY_SLOT = 14
local TORCH_SLOT = 13

-- ### INVENTORY FUNCTIONS

local function deposit() end

local function inventory_full()
	if turtle.getItemCount(15) > 0 then
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
local function check_for_ores()
	if can_deviate() then
		local block = turtle.inspectUp()
	end
end

local function mine_branch() end

-- ### MOVEMENT FUNCTIONS ###

-- advance three steps forwards
local function advance()
	turtle.dig()
	turtle.forward()
	check_for_ores()
	turtle.digUp()
	turtle.up()
	check_for_ores()

	turtle.dig()
	turtle.forward()
	check_for_ores()
	turtle.digDown()
	turtle.down()
	check_for_ores()

	turtle.dig()
	turtle.forward()
	check_for_ores()
	turtle.digUp()
	turtle.up()
	check_for_ores()
	turtle.down()

	distance = distance + 3
end

local function strip_line(range)
	for i = 1, range, 1 do
		turtle.dig()
		turtle.forward()
		if check_for_ores() then
			mine_branch()
		end
	end
end

local function strip()
	turtle.turnLeft()
	strip_line()
	turtle.digUp()
	turtle.up()
	if check_for_ores() then
		mine_branch()
	end
	turtle.turnLeft()
	turtle.turnLeft()

	strip_line(9)
	turtle.digDown()
	turtle.down()
	if check_for_ores() then
		mine_branch()
	end
	turtle.turnLeft()
	turtle.turnLeft()
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
	turtle.turnRight()
	turtle.turnRight()
	for i = 1, distance, 1 do
		turtle.forward()
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

while not returning do
	stripmine()
end

return_to_start()
