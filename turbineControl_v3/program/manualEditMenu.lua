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

---------- Header and Footer
local function drawHeader(title)
    mon:setCursor(1, 1)
    for i = 1, mon:x() do
        mon:write("=")
    end
    mon:setCursor(math.floor(mon:x() / 2 - string.len(title) / 2), 2)
    mon:write(title)
    mon:setCursor(1, 3)
    for i = 1, mon:x() do
        mon:write("=")
    end
end

local function drawFooter()
    mon:setCursor(1, mon:y() - 1)
    for i = 1, mon:x() do
        mon:write("-")
    end
    mon:setCursor(math.floor(mon:x() / 2 - string.len("Version " .. manualOptions:get("version") .. " - (c) 2017 Thor_s_Crafter") / 2), mon:y())
    mon:write("Version " .. manualOptions:get("version") .. " - (c) 2017 Thor_s_Crafter")
end

---------- Button functions

local function doManualEdit()
    mon:backgroundColor(manualOptions:get("backgroundColor"))
    mon:textColor(manualOptions:get("textColor"))
    mon:clear()

    drawHeader(menuText.manualEditMenu)

    mon:setCursor(2,5)
    mon:write(menuText.manualEditRedirect)

    drawFooter()

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

    mon:clear()
    manualButtons:draw()
    mon:backgroundColor(manualOptions:get("backgroundColor"))
    mon:textColor(manualOptions:get("textColor"))

    drawHeader(menuText.manualEditMenu)

    mon:setCursor(2, 5)
    mon:write(menuText.manualEditWarning1)
    mon:setCursor(2, 7)
    mon:write(menuText.manualEditWarning2)
    mon:setCursor(2, 9)
    mon:write(menuText.manualEditWarning3)
    mon:setCursor(2, 12)
    mon:write(menuText.manualEditConfirm)

    drawFooter()
    handleClicks(manualButtons)
end

while not exit do
    manualMenu()
end


