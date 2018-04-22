-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

---------- Variables

--General
local exit = false
local options = newOptions()
local text = loadLanguageFile(options:get("lang") .. "/turbineControl.json")

--Peripherals
local mon = monitorTable[1] --Main Monitor
local r = "" --Reactor
local tTable = {} --turbineTable
local e = "" --energyStorage

--Buttons
local mainButtons



---------- Control functions

local function loadPeripherals()
    local p = newOptions("/reactor-turbine-program/config/peripherals.json")
    r = newReactor("r1",peripheral.wrap(p:get("reactor")), p:get("reactor"),peripheral.getType(p:get("reactor")))
    e = newEnergyStorage("e1", peripheral.wrap(p:get("energyStorage")), p:get("energyStorage"), peripheral.getType(p:get("energyStorage")))
    local t = p:get("turbines")
    for i=1, #t do
        table.insert(tTable, newTurbine("t"..i, peripheral.wrap(t[i]), t[i], peripheral.getType(t[i])))
    end
end

local function init()
    shell.run("/reactor-turbine-program/program/turbinePrograms/checkPeripherals.lua")
    loadPeripherals()
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

---------- UI functions

local function createMainButtons()
    mainButtons = newTouchpoint(mon.side)


end

local function drawMenu()
    local ui = newUI("turbineControl",mon,text.title,options:get("version"), options:get("backgroundColor"),options:get("textColor"))
    createMainButtons()

    ui:clear()
    mainButtons:draw()
    ui:drawFrame()


    handleClicks(mainButtons)
end



---------- Execute program

init()

while not exit do
    drawMenu()
end


