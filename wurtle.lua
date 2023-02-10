---@diagnostic disable: unused-local, unused-function

-- ### GLOBALS ###

local wurtle = {}

wurtle.x = 0
wurtle.y = 0
wurtle.z = 0

wurtle.orientation = {
	north = 0,
	east = 1,
	south = 2,
	west = 3,
}

-- current orientation
wurtle.c_orientation = 0

wurtle.dirs = {
	forward = 0,
	backward = 2,
	left = -1,
	right = 1,
	up = 0,
	down = 0,
}

-- ### LOCAL COORDINATE FUNCTINOS ###

-- calculates and changes the orientation value
function wurtle.change_orientation(dir)
	wurtle.c_orientation = ((wurtle.c_orientation + dir) % 4)
end

-- calculates and changes the coordinates
function wurtle.change_coordinates(forwards)
	forwards = forwards or true

	if wurtle.c_orientation == wurtle.orientation.north then
		if forwards then
			wurtle.x = wurtle.x + 1
		else
			wurtle.x = wurtle.x - 1
		end
	elseif wurtle.c_orientation == wurtle.orientation.south then
		if forwards then
			wurtle.x = wurtle.x - 1
		else
			wurtle.x = wurtle.x + 1
		end
	elseif wurtle.c_orientation == wurtle.orientation.east then
		if forwards then
			wurtle.z = wurtle.z + 1
		else
			wurtle.z = wurtle.z - 1
		end
	elseif wurtle.c_orientation == wurtle.orientation.west then
		if forwards then
			wurtle.z = wurtle.z - 1
		else
			wurtle.z = wurtle.z + 1
		end
	end
end

-- ### WRAPPERS ###

-- turns the turtle; takes left, right and back from dirs
function wurtle.turn(dir)
	if dir == wurtle.dirs.left then
		turtle.turnLeft()
		wurtle.change_orientation(dir)
	elseif dir == wurtle.dirs.right then
		turtle.turnRight()
		wurtle.change_orientation(dir)
	elseif dir == wurtle.dirs.backward then
		turtle.turnRight()
		turtle.turnRight()
		wurtle.change_orientation(dir)
	else
		print("Can only call turn with left, right or back")
	end
end

-- Moves and changes the coordinates; left and right turn the turtle
function wurtle.move(dir)
	if dir == wurtle.dirs.forward then
		turtle.forward()
		wurtle.change_coordinates(true)
	elseif dir == wurtle.dirs.backward then
		turtle.back()
		wurtle.change_coordinates(false)
	elseif dir == wurtle.dirs.up then
		turtle.up()
		wurtle.y = wurtle.y + 1
	elseif dir == wurtle.dirs.down then
		turtle.down()
		wurtle.y = wurtle.y - 1
	elseif dir == wurtle.dirs.left then
		wurtle.turn(wurtle.dirs.left)
		turtle.forward()
		wurtle.change_coordinates(true)
	elseif dir == wurtle.dirs.right then
		wurtle.turn(wurtle.dirs.right)
		turtle.forward()
		wurtle.change_coordinates(true)
	end
end

-- Mining blocks; right, left and back turn the turtle; Gravelproof
function wurtle.mine(dir, side)
	side = side or "left"
	if dir == wurtle.dirs.forward then
		turtle.dig(side)
	elseif dir == wurtle.dirs.backward then
		wurtle.turn(wurtle.dirs.backward)
		turtle.dig(side)
	elseif dir == wurtle.dirs.up then
		turtle.digUp(side)
	elseif dir == wurtle.dirs.down then
		turtle.digDown(side)
	elseif dir == wurtle.dirs.left then
		wurtle.turn(wurtle.dirs.left)
		turtle.dig(side)
	elseif dir == wurtle.dirs.right then
		wurtle.turn(wurtle.dirs.right)
		turtle.dig(side)
	end
end

return wurtle
