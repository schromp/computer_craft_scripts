local function wait_for_down()
  local flag = true
  while flag do
    os.pullEvent("redstone")
    if redstone.getAnalogInput("bottom") == 0 then
      flag = false
    end
  end
end

local cooldown = false

while true do
  if redstone.getInput("top") and not cooldown then
    -- move down
    redstone.setOutput("right", true)
    redstone.setOutput("front", true)
    redstone.setOutput("back", true)
    sleep(1)
    redstone.setOutput("front", false)

    wait_for_down()

    -- move right
    redstone.setOutput("right", false)
    redstone.setOutput("back", true)

    cooldown = true
  elseif redstone.getInput("left") and not cooldown then
    -- move down
    redstone.setOutput("right", true)
    redstone.setOutput("front", true)
    sleep(1)
    redstone.setOutput("front", false)

    wait_for_down()

    redstone.setOutput("right", false)
    redstone.setOutput("back", false)
    cooldown = true
  elseif (not redstone.getInput("left") and not redstone.getInput("top")) and cooldown then
    cooldown = false
  end

  sleep(0)
end
