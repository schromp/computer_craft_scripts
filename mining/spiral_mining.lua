---@diagnostic disable: unused-local, unused-function
-- mining in a spiral around a fixed middle point
-- pass parameter for ceiling height

-- make a 3x3xceilingheight big hole
-- place the turtle in the middle

-- place torch all 14 blocks
-- TODO: this is broken!

local wurtle = require("wurtle")

local dirs = wurtle.dirs

local CEILING_HEIGHT = 2

local FUEL_SLOT = 16
local TORCH_SLOT = 15

local c_tunnel_length = 10
local c_turn = 0

-- TODO: ste ceiling height to argument

local function is_ore(dir) end

local function check_for_ores() 
	wurtle.turn(dirs.left)
	is_ore(dirs.forward)
	wurtle.turn(dirs.backward)
	is_ore(dirs.forward)
	wurtle.turn(dirs.left)
	is_ore(dirs.up)
	is_ore(dirs.down)
end

local function inventory_full() end

local function need_refuel() end

local function place_torch() 
	turtle.select(15)
	wurtle.turn(dirs.backward)
	turtle.place()	
	wurtle.turn(dirs.backward)
end

local function return_base() end

-- mines, moves and checks for ores
local function mine_move(dir)
	wurtle.mine(dir)
	wurtle.move(dir)
	check_for_ores()
	if wurtle.x % 14 == 1 or wurtle.y % 14 == 1 then
		place_torch()
	end	
end

-- digs #steps forward and checks for ores
local function dig(steps)
	for j = 1, steps, 1 do
		if CEILING_HEIGHT == 1 then
			mine_move(dirs.forward)
			check_for_ores()
		else

			if wurtle.y > 0 then
                mine_move(dirs.forward)
                for i = 1, CEILING_HEIGHT - 1, 1 do
                    mine_move(dirs.down)
                end
			elseif wurtle.y == 0 then
				mine_move(dirs.forward)
				for i = 1, CEILING_HEIGHT - 1, 1 do
					mine_move(dirs.up)
				end
			else 
				print("Cannot do dig function on minus y level")
			end
		end

		if wurtle.x == 0 or wurtle.y == 0 then
			if need_refuel() then
				return_base()
			end

			if inventory_full() then
				return_base()
			end
		end
	end
end

-- ### START OF PROGRAM ###

turtle.select(16)
turtle.refuel(64)

-- Move to start position
wurtle.move(dirs.forward)
dig(4)
wurtle.turn(dirs.left)
dig(5)
wurtle.turn(dirs.left)

-- mining, cancels in return_base function
while true do
	for i = 1, 2, 1 do
		dig(c_tunnel_length)
		wurtle.turn(dirs.left)
	end
	c_tunnel_length = c_tunnel_length + 4
	wurtle.turn(dirs.left)
	turtle.select(15)
	turtle.place()
	wurtle.turn(dirs.right)
end
