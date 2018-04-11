-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

--General
local exit = false
local options = newOptions()
local rButtons
local eSButtons
local monButtons
local text = loadLanguageFile(options:get("lang") .. "/turbineControl.json")
local errorTable = { error = false }

--Peripherals
local mon = monitorTable[1]

---------- Control functions

local function checkPeripherals()
    if #reactorTable == 0 then
        errorTable.error = true
        errorTable["r"] = { reactorCount = 0 }
    end

    if #turbineTable == 0 then
        errorTable.error = true
        errorTable["t"] = { turbineCount = 0 }
    end

    if #energyStorageTable == 0 then
        errorTable.error = true
        errorTable["eS"] = { energyStorageCount = 0 }
    end

    if #reactorTable > 1 then
        errorTable.error = true
        errorTable["r"] = { reactorCount = 1 }
    end

    if #energyStorageTable > 1 then
        errorTable.error = true
        errorTable["eS"] = { energyStorageCount = 1 }
    end

    if #monitorTable > 1 then
        errorTable.error = true
        errorTable["m"] = { monitorCount = 1 }
    end

    -- TODO: Check peripheral config file


    if not errorTable.error then
        exit = true
    end
end


---------- UI & Button functions

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

local function selectPeripheral(peripheral, id)
    local pOptions = newOptions("/reactor-turbine-control/config/peripherals.json")

    if peripheral == "r" then
        pOptions:set("reactor", id)
    elseif peripheral == "eS" then
        pOptions:set("energyStorage", id)
    end

    pOptions:save()
end

local function createButtons()
    rButtons = newTouchpoint(monitorTable[1].side)
    eSButtons = newTouchpoint(monitorTable[1].side)
    monButtons = newTouchpoint(monitorTable[1].side)

    if errorTable.error and errorTable["r"].reactorCount == 1 then
        for i = 1, #reactorTable do
            rButtons:add("R" .. i, function()
                selectPeripheral("r", reactorTable[i].side)
            end, 2, 6 + i, 7, 6 + i)
        end
    end

    if errorTable.error and errorTable["rS"].energyStorageCount == 1 then
        for i = 1, #energyStorageTable do
            eSButtons:add("S" .. i, function()
                selectPeripheral("eS", energyStorageTable[i].side)
            end, 2, 6 + i, 7, 6 + i)
        end
    end

    if errorTable.error and errorTable["m"].monitorCount == 1 then
        for i = 1, #monitorTable do
            monButtons:add("M" .. i, function()
                    selectPeripheral("m",monitorTable[i].side)
            end, 2, 6 + i, 7, 6 + i)
        end
    end

end

local function drawMenu()
    createButtons()
    local ui = newUI("checkPeripherals", mon, text.title, options:get("version"), options:get("backgroundColor"), options:get("textColor"))

    ui:clear()
    ui:drawFrame()


    local pOptions = newOptions("/reactor-turbine-control/config/peripherals.json")

    --Print errors if one or more peripherals are missing
    if errorTable.error and errorTable["r"].reactorCount == 0 then
        ui:writeContent(2, 5, text.errors.noReactor, colors.red)
        pOptions:set("reactor","")
        os.sleep(2)
        exit = true
    elseif errorTable.error and errorTable["t"].turbineCount == 0 then
        ui:writeContent(2, 5, text.errors.noTurbine, colors.red)
        pOptions:set("turbines",{})
        os.sleep(2)
        exit = true
    elseif errorTable.error and errorTable["eS"].energyStorageCount == 0 then
        ui:writeContent(2, 5, text.errors.noEnergyStorage, colors.red)
        pOptions:set("energyStorage","")
        os.sleep(2)
        exit = true
    end

    --Present the user with a choice if more then one peripheral for a type is found
    if errorTable.error and errorTable["r"].reactorCount == 1 then
        ui:clear()
        rButtons:draw()
        ui:drawFrame()

        ui:writeContent(2, 5, text.errors.selectReactor)

        handleClicks(rButtons)

    elseif errorTable.error and errorTable["eS"].energyStorageCount == 1 then
        ui:clear()
        eSButtons:draw()
        ui:drawFrame()

        ui:writeContent(2,5, text.errors.selectEnergyStorage)

        handleClicks(eSButtons)
    elseif errorTable.error and errorTable["m"].monitorCount == 1 then
        ui:clear()
        monButtons:draw()
        ui:drawFrame()

        ui:writeContent(2,5, text.errors.selectMonitor)

        handleClicks(monButtons)
    end


end

while not exit do
    checkPeripherals()
    drawMenu()
end
