-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

local Monitor = {
    name = "",
    id = {},

    size = function(self)
        return self.id.getSize()
    end,
    x = function(self)
        local x,y = self:size()
        return x
    end,
    y = function(self)
        local x,y = self:size()
        return y
    end,
    textColor = function(self, color)
        if color == nil then return self.id.getTextColor()
        else self.id.setTextColor(color)
        end
    end,
    backgroundColor = function(self, color)
        if color == nil then return self.id.getBackgroundColor()
        else self.id.setBackgroundColor(color)
        end
    end,
    clear = function(self)
        self.id.clear()
    end,
    setCursor = function(self, x, y)
        self.id.setCursorPos(x, y)
    end,
    textScale = function(self, value)
        self.id.setTextScale(value)
    end
}

function newMonitor(name,id)
    local monitor = {}
    setmetatable(monitor,{__index=Monitor})

    monitor.name = name
    monitor.id = id

    return monitor
end