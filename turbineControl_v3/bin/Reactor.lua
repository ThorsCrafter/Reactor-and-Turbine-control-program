-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

local Reactor = {
    name = "",
    id = {},
    side = "",
    type = "",

    active = function(self)
        return self.id.getActive()
    end,
    controlRodLevel = function(self)
        return self.id.getControlRodLevel(0)
    end,
    controlRodCount = function(self)
        return self.id.getNumberOfControlRods()
    end,
    energy = function(self)
        return self.id.getEnergyStored()
    end,
    fuelTemp = function(self)
        return self.id.getFuelTemperature()
    end,
    casingTemp = function(self)
        return self.id.getCasingTemperature()
    end,
    fuel = function(self)
        return self.id.getFuelAmount()
    end,
    maxFuel = function(self)
        return self.id.getFuelAmountMax()
    end,
    fuelPer = function(self)
        return math.floor(self:fuel()/self:maxFuel()*100)
    end,
    waste = function(self)
        return self.id.getWasteAmount()
    end,
    energyProduction = function(self)
        return self.id.getEnergyProducedLastTick()
    end,
    steamOutput = function(self)
        return self.id.getHotFluidProducedLastTick()
    end,
    fuelConsumption = function(self)
        return self.id.getFuelConsumedLastTick()
    end,
    activeCooling = function(self)
        return self.id.isActivelyCooled()
    end,

    setOn = function(self,status)
        self.id.setActive(status)
    end,
    setRodLevel = function(self,level)
        self.id.setAllControlRodLevels(level)
    end
}


function newReactor(name,id, side, type)
    local reactor = {}
    setmetatable(reactor,{__index=Reactor})

    reactor.name = name
    reactor.id = id
    reactor.side = side
    reactor.type = type

    return reactor
end






