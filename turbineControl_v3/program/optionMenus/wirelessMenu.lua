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

---------- Button functions

--TODO Implement Button functions

local function createWirelessMenuButtons()
    wirelessButtons = newTouchpoint(mon.side)

    --TODO Re-add Save Button
    --wirelessButtons:add(menuText.buttons.save, function() wirelessButtons:save() end, 2, 15, 3 + string.len(menuText.buttons.save), 15)
    wirelessButtons:add(menuText.buttons.backOnce, function() exit = true end, 2, 17, 3 + string.len(menuText.buttons.backOnce), 17)
end

---------- Menu functions
local function wirelessMenu()
    createWirelessMenuButtons()
    local ui = newUI("wirelessMenu", mon, menuText.wirelessMenu, wirelessOptions:get("version"), wirelessOptions:get("backgroundColor"), wirelessOptions:get("textColor"))

    ui:clear()
    wirelessButtons:draw()
    ui:drawFrame()

    ui:writeContent(2,5,"Coming soon!")

    handleClicks(wirelessButtons)
end

while not exit do
    wirelessMenu()
end


