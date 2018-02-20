-- turbine / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

---------- Variables

local turbineButtons
local turbineOptions = newOptions()
local mon = monitorTable[1]
local menuText = loadLanguageFile(turbineOptions:get("lang") .. "/setOptions.json")
local exit = false
local turbineMode = "rotorSpeed"


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
    mon:setCursor(math.floor(mon:x() / 2 - string.len("Version " .. turbineOptions:get("version") .. " - (c) 2017 Thor_s_Crafter") / 2), mon:y())
    mon:write("Version " .. turbineOptions:get("version") .. " - (c) 2017 Thor_s_Crafter")
end

---------- Button functions
local function setRotorSpeed(mode, count)
    local rotorSpeed = turbineOptions:get("turbineTargetSpeed")
    if mode == "-" then rotorSpeed = rotorSpeed - count
    elseif mode == "+" then rotorSpeed = rotorSpeed + count
    end
    if rotorSpeed <= 0 then rotorSpeed = 0 end
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

local function changeValue(mode, count)
    if turbineMode == "rotorSpeed" then setRotorSpeed(mode, count)
    elseif turbineMode == "steamInput" then setSteamInput(mode, count)
    end
end

local function createTurbineMenuButtons()
    turbineButtons = newTouchpoint(mon.side)

    turbineButtons:add(menuText.buttons.rotorSpeed, function() turbineMode = "rotorSpeed" end, 2, 9, 3 + string.len(menuText.buttons.rotorSpeed), 9)
    turbineButtons:add(menuText.buttons.steamInput, function() turbineMode = "steamInput" end, 2, 11, 3 + string.len(menuText.buttons.steamInput), 11)

    turbineButtons:add("-1", function() changeValue("-", 1) end, 35, 9, 38, 9)
    turbineButtons:add("-10", function() changeValue("-", 10) end, 40, 9, 44, 9)
    turbineButtons:add("-100", function() changeValue("-", 100) end, 46, 9, 51, 9)
    turbineButtons:add("+1", function() changeValue("+", 1) end, 35, 11, 38, 11)
    turbineButtons:add("+10", function() changeValue("+", 10) end, 40, 11, 44, 11)
    turbineButtons:add("+100", function() changeValue("+", 100) end, 46, 11, 51, 11)

    turbineButtons:add(menuText.buttons.save, function() turbineOptions:save() end, 2, 15, 3 + string.len(menuText.buttons.save), 15)
    turbineButtons:add(menuText.buttons.backOnce, function() exit = true end, 2, 17, 3 + string.len(menuText.buttons.backOnce), 17)

    if turbineMode == "rotorSpeed" then
        turbineButtons:toggleButton(menuText.buttons.rotorSpeed)
    elseif turbineMode == "steamInput" then
        turbineButtons:toggleButton(menuText.buttons.steamInput)
    end
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
    if turbineMode == "rotorSpeed" then
        mon:write(menuText.currRotorSpeed)
        mon:write(turbineOptions:get("turbineTargetSpeed") .. "   ")
        elseif turbineMode == "steamInput" then
        mon:write(menuText.currSteamInput)
        mon:write(turbineOptions:get("targetSteam").."           ")
    end

    drawFooter()
    handleClicks(turbineButtons)
end

while not exit do
    turbineMenu()
end


