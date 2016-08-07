-- Reactor- und Turbine control by Thor_s_Crafter --
-- installerUpdate (all versions) --
-- Deutsch -- 

if fs.exists("/reactor-turbine-program/install/installer.lua") then
	shell.run("rm /reactor-turbine-program/install/installer.lua")
end
shell.run("pastebin get zsppf0Kw /reactor-turbine-program/install/installer.lua")
shell.run("/reactor-turbine-program/install/installer.lua")