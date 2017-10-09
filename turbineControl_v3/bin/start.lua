-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

-- Start program for loading neccesary files, initializing variables, etc.

function init()
    --Run necessary binary files
    local binPath = "/reactor-turbine-program/bin/"
    shell.run(binPath.."File.lua")
    shell.run(binPath.."json.lua")
    shell.run(binPath.."Options.lua")
end









