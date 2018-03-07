-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

---------- Variables

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
            if buttonInstance.buttonList[but].func == nil then
                break
            end
            buttonInstance:flash(but)
            buttonInstance.buttonList[but].func()
            break
        elseif event == "timer" and p1 == timer1 then
            break
        end
    end
end

---------- Main Menu Button functions
local function quit()
    shell.run("/reactor-turbine-program/program/mainMenu.lua")
    exit = true
end

local function drawSubMenu(subMenu)
    shell.run("/reactor-turbine-program/program/" .. subMenu .. ".lua")
    options = newOptions()
end

---------- Main Menu functions
local function createMainButtons()
    mainButtons = newTouchpoint(mon.side)
    mainButtons:add(menuText.buttons.appearance, function()
        drawSubMenu("appearanceMenu")
    end, 2, 7, 3 + string.len(menuText.buttons.appearance), 7)
    mainButtons:add(menuText.buttons.reactorSettings, function()
        drawSubMenu("reactorMenu")
    end, 2, 9, 3 + string.len(menuText.buttons.reactorSettings), 9)
    mainButtons:add(menuText.buttons.turbineSettings, function()
        drawSubMenu("turbineMenu")
    end, 2, 11, 3 + string.len(menuText.buttons.turbineSettings), 11)
    mainButtons:add(menuText.buttons.wirelessSettings, function()
        drawSubMenu("wirelessMenu")
    end, 2, 13, 3 + string.len(menuText.buttons.wirelessSettings), 13)
    mainButtons:add(menuText.buttons.advancedSettings, function()
        drawSubMenu("advancedMenu")
    end, 2, 15, 3 + string.len(menuText.buttons.advancedSettings), 15)
    mainButtons:add(menuText.buttons.manualEdit, function()
        drawSubMenu("manualEditMenu")
    end, 2, 17, 3 + string.len(menuText.buttons.manualEdit), 17)
    mainButtons:add(menuText.buttons.back, quit, 2, 20, 3 + string.len(menuText.buttons.back), 20)
end

local function drawMenu()
    local ui = newUI("setOptions", mon, menuText.title, options:get("version"), options:get("backgroundColor"), options:get("textColor"))
    createMainButtons()

    ui:clear()
    mainButtons:draw()
    ui:drawFrame()

    ui:writeContent(2,5,menuText.categories)
    ui:writeContent(25,7,menuText.appearance)
    ui:writeContent(25,9,menuText.reactorSettings)
    ui:writeContent(25,11,menuText.turbineSettings)
    ui:writeContent(25,13,menuText.wirelessSettings)
    ui:writeContent(25,15,menuText.advancedSettings)
    ui:writeContent(25,17,menuText.manualEdit)

    handleClicks(mainButtons)
end

while not exit do
    drawMenu()
end