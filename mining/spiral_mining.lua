---@diagnostic disable: unused-local, unused-function
-- mining in a spiral around a fixed middle point
-- pass parameter for ceiling height

-- make a 3x3xceilingheight big hole
-- place the turtle in the middle

local wurtle = require("wurtle")

local dirs = wurtle.dirs

local CEILING_HEIGHT = 2

local FUEL_SLOT = 16
local TORCH_SLOT = 15

local c_tunnel_length = 10
local c_turn = 0

-- TODO: ste ceiling height to argument

local function check_for_ores() end

local function inventory_full() end

local function need_refuel() end

local function return_base() end

-- mines, moves and checks for ores
local function mine_move(dir)
	wurtle.mine(dir)
	wurtle.move(dir)
	check_for_ores()
end

-- digs #steps forward and checks for ores
local function dig(steps)
	for j = 1, steps, 1 do
		if CEILING_HEIGHT == 1 then
			mine_move(dirs.forward)
			check_for_ores()
		else
			for i = 1, CEILING_HEIGHT - 1, 1 do
				mine_move(dirs.up)
			end

			mine_move(dirs.forward)

			for i = 1, CEILING_HEIGHT - 1, 1 do
				mine_move(dirs.down)
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

-- Move to start position
wurtle.move(dirs.forward)
dig(4)
wurtle.turn(dirs.left)
dig(5)
wurtle.turn(dirs.left)

-- mining, cancels in return_base function
while true do
	for i = 1, 3, 1 do
		dig(c_tunnel_length)
		wurtle.turn(dirs.left)
	end
	c_tunnel_length = c_tunnel_length + 4
end
