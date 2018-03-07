-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

---------- Variables

local advancedButtons
local advancedOptions = newOptions()
local mon = monitorTable[1]
local menuText = loadLanguageFile(advancedOptions:get("lang") .. "/setOptions.json")
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

---------- Button functions

--TODO Implement button functions


local function createAdvancedMenuButtons()
    advancedButtons = newTouchpoint(mon.side)

    --TODO Re-add Save Button
    --advancedButtons:add(menuText.buttons.save, function() advancedButtons:save() end, 2, 15, 3 + string.len(menuText.buttons.save), 15)
    advancedButtons:add(menuText.buttons.backOnce, function() exit = true end, 2, 17, 3 + string.len(menuText.buttons.backOnce), 17)
end

---------- Menu functions
local function advancedMenu()
    createAdvancedMenuButtons()
    local ui = newUI("advancedMenu",mon,menuText.advancedMenu,advancedOptions:get("version"),advancedOptions:get("backgroundColor"), advancedOptions:get("textColor"))

    ui:clear()
    advancedButtons:draw()
    ui:drawFrame()

    ui:writeContent(2,5,"Coming soon!")

    handleClicks(advancedButtons)
end

while not exit do
    advancedMenu()
end


