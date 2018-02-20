-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

---------- Variables

local appearanceMode = "background"
local appearanceButtons
local appearanceOptions = newOptions()
local mon = monitorTable[1]
local menuText = loadLanguageFile(appearanceOptions:get("lang") .. "/setOptions.json")
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
    mon:setCursor(math.floor(mon:x() / 2 - string.len("Version " .. appearanceOptions:get("version") .. " - (c) 2017 Thor_s_Crafter") / 2), mon:y())
    mon:write("Version " .. appearanceOptions:get("version") .. " - (c) 2017 Thor_s_Crafter")
end

---------- Button functions
local function setColor(value)
    appearanceOptions:set(appearanceMode .. "Color", value)
end

local function createAppearanceButtons()
    appearanceButtons = newTouchpoint(monitorTable[1].side)
    appearanceButtons:add(menuText.buttons.background, function() appearanceMode = "background" end, 2, 9, 14, 9)
    appearanceButtons:add(menuText.buttons.text, function() appearanceMode = "text" end, 2, 11, 14, 11)

    appearanceButtons:add(menuText.colors.white, function() setColor(1) end, 35, 5, 48, 5)
    appearanceButtons:add(menuText.colors.orange, function() setColor(2) end, 50, 5, 63, 5)
    appearanceButtons:add(menuText.colors.magenta, function() setColor(4) end, 35, 7, 48, 7)
    appearanceButtons:add(menuText.colors.lightblue, function() setColor(8) end, 50, 7, 63, 7)
    appearanceButtons:add(menuText.colors.yellow, function() setColor(16) end, 35, 9, 48, 9)
    appearanceButtons:add(menuText.colors.lime, function() setColor(32) end, 50, 9, 63, 9)
    appearanceButtons:add(menuText.colors.pink, function() setColor(64) end, 35, 11, 48, 11)
    appearanceButtons:add(menuText.colors.gray, function() setColor(128) end, 50, 11, 63, 11)
    appearanceButtons:add(menuText.colors.lightgray, function() setColor(256) end, 35, 13, 48, 13)
    appearanceButtons:add(menuText.colors.cyan, function() setColor(512) end, 50, 13, 63, 13)
    appearanceButtons:add(menuText.colors.purple, function() setColor(1024) end, 35, 15, 48, 15)
    appearanceButtons:add(menuText.colors.blue, function() setColor(2048) end, 50, 15, 63, 15)
    appearanceButtons:add(menuText.colors.brown, function() setColor(4096) end, 35, 17, 48, 17)
    appearanceButtons:add(menuText.colors.green, function() setColor(8192) end, 50, 17, 63, 17)
    appearanceButtons:add(menuText.colors.red, function() setColor(16384) end, 35, 19, 48, 19)
    appearanceButtons:add(menuText.colors.black, function() setColor(32768) end, 50, 19, 63, 19)

    appearanceButtons:add(menuText.buttons.save, function() appearanceOptions:save() end, 2, 15, 3 + string.len(menuText.buttons.save), 15)
    appearanceButtons:add(menuText.buttons.backOnce, function() exit = true end, 2, 17, 3 + string.len(menuText.buttons.backOnce), 17)

    appearanceButtons:toggleButton(menuText.buttons[appearanceMode])
end

---------- Menu functions

local function appearanceMenu()
    createAppearanceButtons()

    mon:clear()
    appearanceButtons:draw()
    mon:backgroundColor(appearanceOptions:get("backgroundColor"))
    mon:textColor(appearanceOptions:get("textColor"))

    drawHeader(menuText.appearanceMenu)

    mon:backgroundColor(appearanceOptions:get("backgroundColor"))
    mon:textColor(appearanceOptions:get("textColor"))

    mon:setCursor(2, 5)
    mon:write(menuText.changeColor)

    mon:backgroundColor(appearanceOptions:get("backgroundColor"))
    mon:textColor(appearanceOptions:get("textColor"))

    mon:setCursor(2, 7)
    mon:write(menuText.mode)
    drawFooter()
    handleClicks(appearanceButtons)
end

while not exit do
    appearanceMenu()
end