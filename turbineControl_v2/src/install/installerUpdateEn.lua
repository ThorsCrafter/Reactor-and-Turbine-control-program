-- Installer of the Reactor- and Turbinecontrolprogram by Thor_s_Crafter --

if fs.exists("/reactor-turbine-program/install/installer.lua") then
	shell.run("delete /reactor-turbine-program/install/installer.lua")
end
shell.run("pastebin get TArFjRRJ /reactor-turbine-program/install/installer.lua")
shell.run("/reactor-turbine-program/install/installer.lua")