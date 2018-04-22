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
local errorTable = { error = false, r = {}, t = {}, eS = {}, m = {} }

--Peripherals
local mon = monitorTable[1]

---------- Control functions

local function checkPeripherals()

    local pOptions = newOptions("/reactor-turbine-program/config/peripherals.json")

    if #reactorTable == 0 and pOptions:get("reactor") == "" then
        errorTable.error = true
        errorTable["r"] = { reactorCount = 0 }
    end

    if #turbineTable == 0 and #(pOptions:get("turbines")) == 0 then
        errorTable.error = true
        errorTable["t"] = { turbineCount = 0 }
    end

    if #energyStorageTable == 0 and pOptions:get("energyStorage") == "" then
        errorTable.error = true
        errorTable["eS"] = { energyStorageCount = 0 }
    end

    if #reactorTable > 1 and pOptions:get("reactor") == "" then
        errorTable.error = true
        errorTable["r"] = { reactorCount = 1 }
    end

    if #energyStorageTable > 1 and pOptions:get("energyStorage") == "" then
        errorTable.error = true
        errorTable["eS"] = { energyStorageCount = 1 }
    end

    if #monitorTable > 1 and #(pOptions:get("monitors")) == 0 then
        errorTable.error = true
        errorTable["m"] = { monitorCount = 1 }
    end

    if not errorTable.error then
        pOptions:set("reactor", reactorTable[1].side)
        pOptions:set("energyStorage", energyStorageTable[1].side)
        local t = {}
        for i = 1, #turbineTable do
            table.insert(t,turbineTable[i].side)
        end
        pOptions:set("turbines",t)
        local m = {}
        table.insert(m, monitorTable[1].side)
        pOptions:set("monitors", m)

        pOptions:save()
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
    local pOptions = newOptions("/reactor-turbine-program/config/peripherals.json")

    if peripheral == "r" then
        pOptions:set("reactor", id)
        errorTable["r"] = {}
    elseif peripheral == "eS" then
        pOptions:set("energyStorage", id)
        errorTable["eS"] = {}
    elseif peripheral == "m" then
        local t = pOptions:get("monitors")
        table.insert(t, id)
        pOptions:set("monitors", t)
        errorTable["m"] = {}
    elseif peripheral == "t" then
        pOptions:set("turbines", turbineTable)
        errorTable["t"] = {}
    end

    pOptions:save()
    errorTable.error = false
end

local function createButtons()
    rButtons = newTouchpoint(monitorTable[1].side)
    eSButtons = newTouchpoint(monitorTable[1].side)
    monButtons = newTouchpoint(monitorTable[1].side)

    if errorTable.error and errorTable["r"].reactorCount == 1 then
        for i = 1, #reactorTable do
            rButtons:add("R" .. i, function()
                selectPeripheral("r", reactorTable[i].side)
            end, 2, 6 + i + (i - 1), 7, 6 + i + (i - 1))

        end
    end

    if errorTable.error and errorTable["eS"].energyStorageCount == 1 then
        for i = 1, #energyStorageTable do
            eSButtons:add("S" .. i, function()
                selectPeripheral("eS", energyStorageTable[i].side)
            end, 2, 6 + i + (i - 1), 7, 6 + i + (i - 1))
        end
    end

    if errorTable.error and errorTable["m"].monitorCount == 1 then
        for i = 1, #monitorTable do
            monButtons:add("M" .. i, function()
                selectPeripheral("m", monitorTable[i].side)
            end, 2, 6 + i + (i - 1), 7, 6 + i + (i - 1))
        end
    end
end

local function drawMenu()
    createButtons()
    local ui = newUI("checkPeripherals", mon, text.title, options:get("version"), options:get("backgroundColor"), options:get("textColor"))

    ui:clear()
    ui:drawFrame()

    local pOptions = newOptions("/reactor-turbine-program/config/peripherals.json")

    --Print errors if one or more peripherals are missing
    if errorTable.error and errorTable["r"].reactorCount == 0 then
        ui:writeContent(2, 5, text.errors.noReactor, colors.red)
        pOptions:set("reactor", "")
        os.sleep(2)
        exit = true
    elseif errorTable.error and errorTable["t"].turbineCount == 0 then
        ui:writeContent(2, 5, text.errors.noTurbine, colors.red)
        pOptions:set("turbines", {})
        os.sleep(2)
        exit = true
    elseif errorTable.error and errorTable["eS"].energyStorageCount == 0 then
        ui:writeContent(2, 5, text.errors.noEnergyStorage, colors.red)
        pOptions:set("energyStorage", "")
        os.sleep(2)
        exit = true
    end

    --Present the user with a choice if more then one peripheral for a type is found
    if errorTable.error and errorTable["r"].reactorCount == 1 then
        ui:clear()
        rButtons:draw()
        ui:drawFrame()

        ui:writeContent(2, 5, text.errors.selectReactor)

        for i = 1, #reactorTable do
            ui:writeContent(9, 6 + i + (i-1), "ID: "..reactorTable[i].side)
        end

        handleClicks(rButtons)

    elseif errorTable.error and errorTable["eS"].energyStorageCount == 1 then
        ui:clear()
        eSButtons:draw()
        ui:drawFrame()

        ui:writeContent(2, 5, text.errors.selectEnergyStorage)

        for i = 1, #energyStorageTable do
            ui:writeContent(9, 6 + i + (i-1), "ID: "..energyStorageTable[i].side)
        end

        handleClicks(eSButtons)
    elseif errorTable.error and errorTable["m"].monitorCount == 1 then
        ui:clear()
        monButtons:draw()
        ui:drawFrame()

        ui:writeContent(2, 5, text.errors.selectMonitor)

        for i = 1, #monitorTable do
            ui:writeContent(9, 6 + i + (i-1), "ID: "..monitorTable[i].side)
        end

        handleClicks(monButtons)
    end


end

while not exit do
    checkPeripherals()
    drawMenu()
end
