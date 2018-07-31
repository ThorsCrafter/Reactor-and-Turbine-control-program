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
    -- Switch Reactor off
    r:setOn(false)

    --Activate and Engage Coils of all turbines
    for i=1, #t do
        t:setOn(true);
        t:setCoils(true)
    end

    --Wait for the reactor to cool < 100 deg
    while true do
        fTemp = r:fuelTemp()
        cTemp = r:casingTemp()

        if fTemp < 100 and cTemp < 100 then
            break
        end
    end

end

local function calculateRodLevel()
    --Calculation variables
    local controlRodLevel = 99 --Start Rod Level
    local diff = 0 --Difference in steam output
    local targetSteamOutput = options:get("targetSteam") * (#t + 1) --calculated target steam output (#turbines * target Steam level)
    local targetLevel = 99 --Current Target Rod level (will be calculated below)
    local failCounter = 0

    --(Re) Activate Reactor
    r:setOn(true)

    -- Wait 5 seconds for the reactor to balance a bit
    sleep(5)

    --Calculate Level based on steam output levels
    while true do
        r:setRodLevel(controlRodLevel)

        sleep(2)

        local steamOutput1 = r:steamOutput()
        r:setRodLevel(controlRodLevel - 1)

        sleep(5)

        local steamOutput2 = r.steamOutput()
        local diff = steamOutput2 - steamOutput1

        --Calculate target steam level based on the first measurement
        targetLevel = 100 - math.floor(targetSteamOutput / diff)

        --Check target level (valid value?)
        if targetLevel < 0 or targetLevel == "-inf" then

            --Calculation failed 3 times?
            if failCounter > 2 then

                --Disable reactor and turbines (leave the coils engaged)
                r:setOn(false)
                for i = 1, #t do
                    t[i]:setOn(false)
                    t[i]:setCoils(true)
                end

                --Print an error message and end the program
                error("Failed to calculate RodLevel!")
                break
                exit()

            --Increment failCounter
            else
                failCounter = failCounter + 1
                sleep(2)
            end

        else
            return targetLevel
            break
        end
    end

    --RodLevel calculation successful
    r:setRodLevel(targetLevel)
    controlRodLevel = targetLevel
end

local function findPreciseLevel(targetLevel)
    --Calculation variables
    local targetSteamOutput = options:get("targetSteam") * (#t + 1) --calculated target steam output

    while true do
        sleep(5)
        local steamOutput = r:steamOutput()

        --Level too high
        if steamOutput < targetSteamOutput then
            targetLevel = targetLevel - 1
            r:setRodLevel(targetLevel)

        else
            r:setRodLevel(targetLevel)
            options:set("rodLevel",targetLevel)
            options:save()
            sleep(2)
            break
        end
    end
end

local function recheckRodLevel()
    local targetSteamOutput = options:get("targetSteam") * (#t + 1)
    local targetLevel = options:get("rodLevel")
    local targetLevelTemp = targetLevel

    -- Enable reactor & turbines
    r:setOn(true)
    for i=1, #t do
        t[i]:setOn(true)
        t[i]:setCoils(true)
    end

    local counter = 5

    while true do
        --Wait 5 seconds
        sleep(5)

        --Check current steam ouput to target steam output
        currentSteamOutput = r:steamOutput()

        if currentSteamOutput < targetSteamOutput then

            --Something went really wrong if we get here!
            if (targetLevelTemp < targetLevel + 5) then
                return false
            end

            sleep(5)

            --Increase rodLevel even further
            if currentSteamOutput < targetSteamOutput then
                targetLevelTemp = targetLevelTemp + 1
                r:setRodLevel(targetLevelTemp)
            end

        else
            --Try 5 times before being on the safe site
            if counter == 0 then
                return true
            end
            counter = counter - 1
        end
    end
end

local function setRodLevel()
    if not isRodLevelSet() then

        coolReactor()
        local targetLevel = calculateRodLevel()
        findPreciseLevel(targetLevel)
        local success = recheckRodLevel()
        if not success then
            error("Rod calculation was successful, but target steam output could not be reached! Please check your setup!")
            exit()
        end

        print("Rod Level successfully calculated!")

    else
        exit = true
        break
    end
end



--------- UI functions
-- TODO add UI




--Main loop
while not exit do
    setRodLevel()
end