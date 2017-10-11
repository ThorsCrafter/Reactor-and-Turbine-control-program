-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

local Options = {

    -- Load the option file
    load = function(self)
        local string = getFileContent(self.filePath)
        self.optionTable = decode(string)
    end,

    save = function(self)
        local string = encodePretty(self.optionTable)
        writeFileContent(self.filePath,string)
    end,
    getOptions = function(self)
        return self.optionTable
    end,
    get = function(self,option)
        return self.optionTable[option]
    end,
    set = function(self,option,value)
        self.optionTable[option] = value
    end

}

function newOptions(path)
    local optionFile = {
        filePath = path or "/reactor-turbine-program/config/options.json",
        optionTable = {}
    }
    setmetatable(optionFile,{__index=Options})
    optionTable = optionFile:load()

    return optionFile
end










