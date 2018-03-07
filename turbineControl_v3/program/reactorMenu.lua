-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

---------- Variables

local reactorButtons
local reactorOptions = newOptions()
local mon = monitorTable[1]
local menuText = loadLanguageFile(reactorOptions:get("lang") .. "/setOptions.json")
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

---------- Button functions
local function setRodLevel(mode, count)
    local rodLevel = reactorOptions:get("rodLevel")
    if mode == "-" then
        rodLevel = rodLevel - count
    elseif mode == "+" then
        rodLevel = rodLevel + count
    end
    if rodLevel <= 0 then
        rodLevel = 0
    end
    if rodLevel >= 99 then
        rodLevel = 99
    end
    reactorOptions:set("rodLevel", rodLevel)
end

local function createReactorMenuButtons()
    reactorButtons = newTouchpoint(mon.side)

    reactorButtons:add("-1", function()
        setRodLevel("-", 1)
    end, 3, 8, 6, 8)
    reactorButtons:add("-10", function()
        setRodLevel("-", 10)
    end, 8, 8, 12, 8)
    reactorButtons:add("-100", function()
        setRodLevel("-", 100)
    end, 14, 8, 19, 8)
    reactorButtons:add("+1", function()
        setRodLevel("+", 1)
    end, 3, 10, 6, 10)
    reactorButtons:add("+10", function()
        setRodLevel("+", 10)
    end, 8, 10, 12, 10)
    reactorButtons:add("+100", function()
        setRodLevel("+", 100)
    end, 14, 10, 19, 10)

    reactorButtons:add(menuText.buttons.save, function()
        reactorButtons:save()
    end, 2, 15, 3 + string.len(menuText.buttons.save), 15)
    reactorButtons:add(menuText.buttons.backOnce, function()
        exit = true
    end, 2, 17, 3 + string.len(menuText.buttons.backOnce), 17)
end

---------- Menu functions
local function reactorMenu()
    createReactorMenuButtons()
    local ui = newUI("reactorMenu", mon, menuText.reactorMenu, reactorOptions:get("version"), reactorOptions:get("backgroundColor"), reactorOptions:get("textColor"))

    ui:clear()
    reactorButtons:draw()
    ui:drawFrame()

    ui:writeContent(2, 5, menuText.currRodLevel .. reactorOptions:get("rodLevel") .. "   ")

    handleClicks(reactorButtons)
end

while not exit do
    reactorMenu()
end


