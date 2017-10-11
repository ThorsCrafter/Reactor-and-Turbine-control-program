-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

---------- Global variables


---------- Global functions

function loadLanguageFile(relPath)
    local file = fs.open("/reactor-turbine-program/lang/"..relPath, "r")
    local text = decode(file.readAll())
    file.close()
    return text
end

---------- Local (load) functions

local function initBinaries()
    --Execute necessary binary files
    local binPath = "/reactor-turbine-program/bin/"
    shell.run(binPath.."File.lua")
    shell.run("/reactor-turbine-program/lib/json.lua")
    shell.run(binPath.."Options.lua")
    shell.run(binPath.."Reactor.lua")
    shell.run(binPath.."Turbine.lua")
    shell.run(binPath.."Monitor.lua")
    shell.run(binPath.."EnergyStorage.lua")
    shell.run(binPath.."Peripherals.lua")
end

local function load()
    initBinaries()
    createOptions()
    initPeripherals()
end


load()








