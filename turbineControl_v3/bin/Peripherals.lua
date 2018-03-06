-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

reactorTable = {}
turbineTable = {}
monitorTable = {}
energyStorageTable = {}

local function searchPeripherals()
    local peripheralList = peripheral.getNames()
    for i = 1, #peripheralList do
        if peripheral.getType(peripheralList[i]) == "BigReactors-Reactor" then
            reactorTable[#reactorTable + 1] = newReactor("r" .. tostring(#reactorTable + 1), peripheral.wrap(peripheralList[i]))
        elseif peripheral.getType(peripheralList[i]) == "BigReactors-Turbine" then
            turbineTable[#turbineTable + 1] = newTurbine("t" .. tostring(#turbineTable + 1), peripheral.wrap(peripheralList[i]))
        elseif peripheral.getType(peripheralList[i]) == "monitor" then
            monitorTable[#monitorTable + 1] = newMonitor("m" .. tostring(#monitorTable + 1), peripheralList[i], peripheral.wrap(peripheralList[i]))
        else
            local tmp = peripheral.wrap(peripheralList[i])
            local success, err = pcall(function() tmp.getEnergyStored() end)
            if success then
                energyStorageTable[#energyStorageTable + 1] = newEnergyStorage("e" .. tostring(#energyStorageTable + 1), tmp, peripheralList[i], peripheral.getType(peripheralList[i]))
            end
        end
    end
end

local function checkPeripherals()
    if reactorTable[1] == nil then
     --   error("No reactor found!")
    end
    if monitorTable[1] == nil then
        error("No monitor found!")
    end
end


function initPeripherals()
    searchPeripherals()
    checkPeripherals()
end


