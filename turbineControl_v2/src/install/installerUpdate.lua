-- Installationsprogramm des Reaktor- und Turbinenprogramms von Thor_s_Crafter --
-- Hinweis: Das Benutzung des Programms geschieht auf eigene Gefahr des Nutzers. --

if fs.exists("/reactor-turbine-program/install/installer.lua") then
	shell.run("delete /reactor-turbine-program/install/installer.lua")
end
shell.run("pastebin get zsppf0Kw /reactor-turbine-program/install/installer.lua")
shell.run("/reactor-turbine-program/install/installer.lua")