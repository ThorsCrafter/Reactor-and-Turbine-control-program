-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

---------- Variables

local manualButtons
local manualOptions = newOptions()
local mon = monitorTable[1]
local menuText = loadLanguageFile(manualOptions:get("lang") .. "/setOptions.json")
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

local function doManualEdit()
    local ui = newUI("manualEditMenu", mon, menuText.manualEditMenu, manualOptions:get("version"), manualOptions:get("backgroundColor"), manualOptions:get("textColor"))

    ui:clear()
    ui:drawFrame()

    ui:writeContent(2, 5, menuText.manualEditRedirect)

    shell.run("edit /reactor-turbine-program/config/options.json")

    exit = true
end

local function createAdvancedMenuButtons()
    manualButtons = newTouchpoint(mon.side)

    manualButtons:add(menuText.buttons.yes, doManualEdit, 2, 14, 3 + string.len(menuText.buttons.yes), 14)
    manualButtons:add(menuText.buttons.no, function()
        exit = true
    end, 6 + string.len(menuText.buttons.yes), 14, 9 + string.len(menuText.buttons.yes) + string.len(menuText.buttons.no), 14)
end

---------- Menu functions

local function manualMenu()
    createAdvancedMenuButtons()
    local ui = newUI("manualEditMenu", mon, menuText.manualEditMenu, manualOptions:get("version"), manualOptions:get("backgroundColor"), manualOptions:get("textColor"))

    ui:clear()
    manualButtons:draw()
    ui:drawFrame()

    ui:writeContent(2, 5, menuText.manualEditWarning1)
    ui:writeContent(2, 7, menuText.manualEditWarning2)
    ui:writeContent(2, 9, menuText.manualEditWarning3)
    ui:writeContent(2, 12, menuText.manualEditConfirm)

    handleClicks(manualButtons)
end

while not exit do
    manualMenu()
end


