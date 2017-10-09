-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

local optionFile

local Options = {

    -- Load the option file
    load = function(self)
        local string = getFileContent(self.filePath)
        self.optionTable = decode(string)
    end,

    save = function(self)
        local string = encodePretty(self.optionTable)
        writeFileContent(self.filePath,string)
    end

}

function createOptions()
    optionFile = {
        filePath = "/reactor-turbine-program/config/options.json",
        optionTable = {}
    }
    setmetatable(optionFile,{__index=Options})
    optionTable = optionFile:load()
end

function saveOptions()
    optionFile:save()
end

function getOptions()
    return optionFile.optionTable
end

function getOption(name)
    return optionFile.optionTable[name]
end

function setOption(option,value)
    optionFile.optionTable[option] = value
end










