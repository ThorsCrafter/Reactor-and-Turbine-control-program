-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

---------- Variables

local wirelessButtons
local wirelessOptions = newOptions()
local mon = monitorTable[1]
local menuText = loadLanguageFile(wirelessOptions:get("lang") .. "/setOptions.json")
local exit = false


---------- Event function
local function handleClicks(buttonInstance)
    --timer
    local timer1 = os.startTimer(1)

    while true do
        --gets the event
        local event, but = buttonInstance:handleEvents(os.pullEvent())

        --execute a mainButtons function if clicked
        if event == "button_click" then
            if buttonInstance.buttonList[but].func == nil then break end
            buttonInstance:flash(but)
            buttonInstance.buttonList[but].func()
            break
        elseif event == "timer" and p1 == timer1 then
            break
        end
    end
end

---------- Header and Footer
local function drawHeader(title)
    mon:setCursor(1, 1)
    for i = 1, mon:x() do mon:write("=") end
    mon:setCursor(math.floor(mon:x() / 2 - string.len(title) / 2), 2)
    mon:write(title)
    mon:setCursor(1, 3)
    for i = 1, mon:x() do mon:write("=") end
end

local function drawFooter()
    mon:setCursor(1, mon:y() - 1)
    for i = 1, mon:x() do mon:write("-") end
    mon:setCursor(math.floor(mon:x() / 2 - string.len("Version " .. reactorOptions:get("version") .. " - (c) 2017 Thor_s_Crafter") / 2), mon:y())
    mon:write("Version " .. reactorOptions:get("version") .. " - (c) 2017 Thor_s_Crafter")
end

---------- Button functions

--TODO Implement Button functions

local function createWirelessMenuButtons()
    wirelessButtons = newTouchpoint(mon.side)

    --TODO Re-add Save Button
    --wirelessButtons:add(menuText.buttons.save, function() reactorButtons:save() end, 2, 15, 3 + string.len(menuText.buttons.save), 15)
    wirelessButtons:add(menuText.buttons.backOnce, function() exit = true end, 2, 17, 3 + string.len(menuText.buttons.backOnce), 17)
end

---------- Menu functions
local function wirelessMenu()
    createWirelessMenuButtons()

    mon:clear()
    wirelessButtons:draw()
    mon:backgroundColor(wirelessOptions:get("backgroundColor"))
    mon:textColor(wirelessOptions:get("textColor"))

    drawHeader(menuText.wirelessMenu)

    mon:setCursor(2, 5)
    mon:write("Coming soon!")

    drawFooter()
    handleClicks(wirelessButtons)
end

while not exit do
    wirelessMenu()
end


