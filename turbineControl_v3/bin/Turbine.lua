-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

local Turbine = {
    name = "",
    id = {},

    active = function(self)
        return self.id.getActive()
    end,
    coilsEngaged = function(self)
        return self.id.getInductorEngaged()
    end,
    rotorSpeed = function(self)
        return self.id.getRotorSpeed()
    end,
    energy = function(self)
        return self.id.getEnergyStored()
    end,
    energyProduction = function(self)
        return self.id.getEnergyProducedLastTick()
    end,
    steamIn = function(self)
        return self.id.getFluidFlowRate()
    end,

    setOn = function(self, status)
        self.id.setActive(status)
    end,
    setCoils = function(self, status)
        self.id.setInductorEngaged(status)
    end,
    setSteamIn = function(self, amount)
        self.id.setFluidFlowRateMax(amount)
    end

}

function newTurbine(name,id)
    local turbine = {}
    setmetatable(turbine,{__index = Turbine})

    turbine.name = name
    turbine.id = id

    return turbine
end







