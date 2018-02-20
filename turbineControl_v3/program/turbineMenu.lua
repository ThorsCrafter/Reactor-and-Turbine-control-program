-- turbine / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

---------- Variables

local turbineButtons
local turbineOptions = newOptions()
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
    mon:setCursor(math.floor(mon:x() / 2 - string.len("Version " .. options:get("version") .. " - (c) 2017 Thor_s_Crafter") / 2), mon:y())
    mon:write("Version " .. options:get("version") .. " - (c) 2017 Thor_s_Crafter")
end

---------- Button functions
local function setRotorSpeed(mode, count)
    local rotorSpeed = turbineOptions:get("turbineTargetSpeed")
    if mode == "-" then rotorSpeed = rotorSpeed - count
    elseif mode == "+" then rotorSpeed = rotorSpeed + count
    end
    if rotorSpeed <= 0 then rotorSpeed = 0 end
    if rotorSpeed >= 99 then rotorSpeed = 99 end
    turbineOptions:set("turbineTargetSpeed", rotorSpeed)
end

local function setSteamInput(mode, count)
    local steamInput = turbineOptions:get("targetSteam")
    if mode == "-" then steamInput = steamInput - count
    elseif mode == "+" then
        steamInput = steamInput + count
    end
    if steamInput <= 0 then steamInput = 0 end
    if steamInput >= 2000 then steamInput = 2000 end
    turbineOptions:set("targetSteam", steamInput)
end

local function createTurbineMenuButtons()
    turbineButtons = newTouchpoint(monitorTable[i].side)

    turbineButtons:add("-1", function() setRotorSpeed("-", 1) end, 3, 8, 6, 8)
    turbineButtons:add("-10", function() setRotorSpeed("-", 10) end, 8, 8, 12, 8)
    turbineButtons:add("-100", function() setRotorSpeed("-", 100) end, 14, 8, 19, 8)
    turbineButtons:add("+1", function() setRotorSpeed("+", 1) end, 3, 10, 6, 10)
    turbineButtons:add("+10", function() setRotorSpeed("+", 10) end, 8, 10, 12, 10)
    turbineButtons:add("+100", function() setRotorSpeed("+", 100) end, 14, 10, 19, 10)

    turbineButtons:add("-1", function() setSteamInput("-", 1) end, 3, 8, 6, 8)
    turbineButtons:add("-10", function() setSteamInput("-", 10) end, 8, 8, 12, 8)
    turbineButtons:add("-100", function() setSteamInput("-", 100) end, 14, 8, 19, 8)
    turbineButtons:add("+1", function() setSteamInput("+", 1) end, 3, 10, 6, 10)
    turbineButtons:add("+10", function() setSteamInput("+", 10) end, 8, 10, 12, 10)
    turbineButtons:add("+100", function() setSteamInput("+", 100) end, 14, 10, 19, 10)

    turbineButtons:add(menuText.buttons.save, function() turbineButtons:save() end, 2, 15, 3 + string.len(menuText.buttons.save), 15)
    turbineButtons:add(menuText.buttons.backOnce, function() exit = true end, 2, 17, 3 + string.len(menuText.buttons.backOnce), 17)
end

---------- Menu functions
local function turbineMenu()
    createTurbineMenuButtons()

    mon:clear()
    turbineButtons:draw()
    mon:backgroundColor(turbineOptions:get("backgroundColor"))
    mon:textColor(turbineOptions:get("textColor"))

    drawHeader(menuText.turbineMenu)

    mon:setCursor(2, 5)
    mon:write(menuText.currRotorSpeed)
    mon:write(turbineOptions:get("turbineTargetSpeed") .. "   ")

    drawFooter()
    handleClicks(turbineButtons)
end

while not exit do
    turbineMenu()
    handleClicks(turbineButtons)
end


