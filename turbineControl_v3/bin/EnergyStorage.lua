-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

local EnergyStorage = {
    name = "",
    id = {},
    side = "",
    type = "",
    
    energy = function(self)
        return self.id.getEnergyStored()
    end,
    capacity = function(self)
        return self.id.getCapacityStored()
    end,
    percentage = function(self)
        return math.floor(self:energy()/self:capacity()*100)
    end,
    percentagePrecise = function(self)
        return self:energy()/self:capacity()*100
    end
}

function newEnergyStorage(name,id, side, type)
    local storage = {}
    setmetatable(storage,{__index=EnergyStorage})

    storage.name = name
    storage.id = id
    storage.side = side
    storage.type = type

    return storage
end

function printEnergyStorageData(storage)
    print("Name: "..storage.name)
    print("ID: "..tostring(storage.id))
    print("Energy: "..storage:energy())
    print("Capacity: "..storage:capacity())
    print("Fill: "..storage:percentage().."%")
end







