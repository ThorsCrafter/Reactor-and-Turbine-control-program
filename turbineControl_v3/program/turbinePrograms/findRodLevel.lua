-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0



--------- Variables
local exit = false
local options = newOptions()
local text = loadLanguageFile(options:get("lang") .. "/turbineControl.json")
local r = reactorTable:get("r1") --TODO change to read from config file


--------- Control Functions


local function isRodLevelSet()
    local optionRodLevel = options:get("rodLevel")
    if optionRodLevel == 0 or optionRodLevel == nil then
        return false
    end
    return true
end

local function coolReactor()

end

local function calculateRodLevel()

end

local function findPreciseLevel()

end

local function recheckRodLevel()

end

local function setRodLevel()
    if not isRodLevelSet() then

        coolReactor()
        calculateRodLevel()
        findPreciseLevel()
        recheckRodLevel()

    else
        exit = true
        break
    end
end



--------- UI functions





--Main loop
while not exit do

end