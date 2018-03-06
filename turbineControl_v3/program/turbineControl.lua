-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

---------- Variables

--General
local exit = false
local options = newOptions()
local text = loadLanguageFile(options:get("lang") .. "/turbineControl.json")
local errorTable = {isPresent = false, reason = ""}

--Peripherals
local mon = monitorTable[1]
local r --Reactor
local tTable --turbineTable
local e --energyStorage

--Buttons
local mainButtons
local selectPeripheralButtons


---------- Checking data functions (peripherals, etc.)

local function checkPeripherals()
    if #reactorTable == 0 then
        errorTable.isPresent = true
        errorTable.reason = text.errors.noReactor
    end

    if #turbineTable == 0 then
        errorTable.isPresent = true
        errorTable.reason = text.errors.noTurbine
    end

    if #energyStorageTable == 0 then
        errorTable.isPresent = true
        errorTable.reason = text.errors.noEnergyStorage
    end

    if #reactorTable > 1 then

    end

    if #energyStorageTable > 1 then

    end
end


---------- Control functions

local function init()
    checkPeripherals()
end

---------- UI functions

local function createMainButtons()
    mainButtons = newTouchpoint(monitorTable[1].side)


end

local function drawHeader()
    mon:setCursor(1, 1)
    for i = 1, mon:x() do mon:write("=") end
    mon:setCursor(math.floor(mon:x() / 2 - string.len(text.title) / 2), 2)
    mon:write(text.title)
    mon:setCursor(1, 3)
    for i = 1, mon:x() do mon:write("=") end
end

local function drawFooter()
    mon:setCursor(1, mon:y() - 1)
    for i = 1, mon:x() do mon:write("-") end
    mon:setCursor(math.floor(mon:x() / 2 - string.len("Version " .. options:get("version") .. " - (c) 2017 Thor_s_Crafter") / 2), mon:y())
    mon:write("Version " .. options:get("version") .. " - (c) 2017 Thor_s_Crafter")
end

local function selectPeripherals()

end

local function drawUIElements()
    mon:clear()
    mainButtons:draw()
    mon:backgroundColor(options:get("backgroundColor"))
    mon:textColor(options:get("textColor"))

    drawHeader()
    drawFooter()

    --Print error messages if present end exit the program
    if errorTable.isPresent then
        mon:setCursor(2,5)

        mon:textColor(colors.red)
        mon:write(errorTable.reason)

        os.sleep(3)
        exit = true
    end

end

---------- Event functions

local function handleClicks(buttonInstance)
    --timer
    local timer1 = os.startTimer(1)

    while true do
        --gets the event
        local event, p1 = buttonInstance:handleEvents(os.pullEvent())

        --execute a buttons function if clicked
        if event == "button_click" then
            if buttonInstance.buttonList[p1].func == nil then
                break
            end
            buttonInstance:flash(p1)
            buttonInstance.buttonList[p1].func()
            break
        elseif event == "timer" and p1 == timer1 then
            break
        end
    end
end


---------- Execute program

init()

while not exit do
    createMainButtons()
    drawUIElements()
    handleClicks(mainButtons)
end


