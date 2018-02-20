-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

---------- Variables

--Loads the Touchpoint API
--shell.run("cp /reactor-turbine-program/lib/touchpoint.lua /touchpoint")
--os.loadAPI("touchpoint")
--shell.run("rm touchpoint")

local exit = false
local mainButtons
local mon = monitorTable[1]
local options = newOptions()
local menuText = loadLanguageFile(options:get("lang") .. "/setOptions.json")

---------- Event functions
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

---------- Main Menu Button functions
local function quit()
    shell.run("/reactor-turbine-program/program/mainMenu.lua")
    exit = true
end

local function drawSubMenu(subMenu)
    shell.run("/reactor-turbine-program/program/"..subMenu..".lua")
    options = newOptions()
end

---------- Main Menu functions
local function createMainButtons()
    mainButtons = newTouchpoint(mon.side)
    mainButtons:add(menuText.buttons.appearance, function() drawSubMenu("appearanceMenu") end, 2, 7, 3 + string.len(menuText.buttons.appearance), 7)
    mainButtons:add(menuText.buttons.reactorSettings, function() drawSubMenu("reactorMenu") end, 2, 9, 3 + string.len(menuText.buttons.reactorSettings), 9)
    mainButtons:add(menuText.buttons.turbineSettings, function() drawSubMenu("turbineMenu") end, 2, 11, 3 + string.len(menuText.buttons.turbineSettings), 11)
    mainButtons:add(menuText.buttons.wirelessSettings, nil, 2, 13, 3 + string.len(menuText.buttons.wirelessSettings), 13)
    mainButtons:add(menuText.buttons.advancedSettings, nil, 2, 15, 3 + string.len(menuText.buttons.advancedSettings), 15)
    mainButtons:add(menuText.buttons.manualEdit, nil, 2, 17, 3 + string.len(menuText.buttons.manualEdit), 17)
    mainButtons:add(menuText.buttons.back, quit, 2, 20, 3 + string.len(menuText.buttons.back), 20)
end

local function drawMenu()
    mon:clear()
    mainButtons:draw()
    mon:backgroundColor(options:get("backgroundColor"))
    mon:textColor(options:get("textColor"))

    drawHeader(menuText.title)

    mon:setCursor(2, 5)
    mon:write(menuText.categories)
    mon:setCursor(25, 7)
    mon:write(menuText.appearance)
    mon:setCursor(25, 9)
    mon:write(menuText.reactorSettings)
    mon:setCursor(25, 11)
    mon:write(menuText.turbineSettings)
    mon:setCursor(25, 13)
    mon:write(menuText.wirelessSettings)
    mon:setCursor(25, 15)
    mon:write(menuText.advancedSettings)
    mon:setCursor(25, 17)
    mon:write(menuText.manualEdit)

    drawFooter()
end

while not exit do
    createMainButtons()
    drawMenu()
    handleClicks(mainButtons)
end