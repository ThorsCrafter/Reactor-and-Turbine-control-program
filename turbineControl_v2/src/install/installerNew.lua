-- Reaktor- und Turbinenprogramm von Thor_s_Crafter --
-- Version 2.2 --
-- Installationsprogramm --

--Lädt die Optionsdatei
if not fs.exists("/reactor-turbine-program/config/options.txt") then
	shell.run("pastebin get KFcHD2Bj /reactor-turbine-program/config/options.txt")
end

--Liest die Version ein
local optionList = {}
file = fs.open("/reactor-turbine-program/config/options.txt","r")
listElement = file.readLine()
while listElement do
	table.insert(optionList,listElement)
	listElement = file.readLine()
end
file.close()

local version = optionList[3]
local nVersion = 2.2
local lang = optionList[19]

--Aktualisiere Optionsdatei, wenn unter Version 2.1
if tonumber(version) < nVersion then
	if tonumber(version) < 2.2	then
		shell.run("rm /reactor-turbine-program/config/options.txt")
		shell.run("pastebin get KFcHD2Bj /reactor-turbine-program/config/options.txt")
	end
end

--Update?
if fs.exists("/reactor-turbine-program/program/turbineControl.lua") or fs.exists("/reactor-turbine-program/program/reactorControl.lua") then
	update = true
	print("Updating Program...")
end


if not update then
	out = true
	print("Ueber das Programm:")
	print("Das Programm kontrolliert einen BigReactors-Reaktor.")
	print("Es koennen auch Turbinen angeschlossen werden.")
	print("Der Computer muss mit Wired Modems am Reaktor (und ggf. Turbinen) verbunden werden.")
	print("Ausserdem muss eine Energiezelle (o.a.) und ein Monitor angeschlossen werden.")
	print("Der Monitor muss min. 7 Bloecke breit und 4 Bloecke hoch sein.")
	print("Wird das Programm mit Turbinen betrieben, sollte der Reaktor pro Turbine mindestens 2000mb/t Steam produzieren koennen.")
	print()
	write("Bitte Enter druecken...")
	leer = read()
	term.clear()
	term.setCursorPos(1,1)
	print("Es wird empfohlen den Computer zu labeln.")
	while out do
		write("Computer labeln? (j/n): ")
		input = read()
		if input == "j" then
			shell.run("label set \"TurbineComputer\"")
			print("ComputerLabel auf \"TurbineComputer\" gesetzt.")
			out = false
		elseif input == "n" then
			print("ComputerLabel wurde nicht gesetzt.")
			out = false
		else
			print("Ungueltige Eingabe.")
		end
	end

	sleep(1)
end

term.clear()
term.setCursorPos(1,1)

print("Checke auf vorhandene Programme...")
if fs.exists("/reactor-turbine-program/config/touchpoint.lua") then
	shell.run("delete /reactor-turbine-program/config/touchpoint.lua")
	print("touchpoint geloescht.")
end
if fs.exists("/reactor-turbine-program/program/turbineControl.lua") then
	shell.run("delete /reactor-turbine-program/program/turbineControl.lua")
	print("turbineControl geloescht.")
end
if fs.exists("/reactor-turbine-program/changelog/changelog.txt") then
	shell.run("delete /reactor-turbine-program/changelog/changelog.txt")
	print("changelog geloescht.")
end
if fs.exists("/reactor-turbine-program/program/editOptions.lua") then
	shell.run("delete /reactor-turbine-program/program/editOptions.lua")
	print("editOptions geloescht.")
end
if fs.exists("/reactor-turbine-program/start/menu.lua") then
	shell.run("delete /reactor-turbine-program/start/menu.lua")
	print("menu geloescht.")
end
if fs.exists("/reactor-turbine-program/start/start.lua") then
	shell.run("delete /reactor-turbine-program/start/start.lua")
	print("start geloescht.")
end
if fs.exists("/reactor-turbine-program/program/reactorControl.lua") then
  shell.run("delete /reactor-turbine-program/program/reactorControl.lua")
  print("reactorControl geloescht.")
end

print("Lade Touchpoint-Programm...")
shell.run("pastebin get yTXVvQ4s /reactor-turbine-program/config/touchpoint.lua")
print("Lade Turbinen-Programm...")
shell.run("pastebin get KdnLB5bx /reactor-turbine-program/program/turbineControl.lua")
print("Lade Reaktor-Programm")
shell.run("pastebin get KjwASAn2 /reactor-turbine-program/program/reactorControl.lua")
print("Lade Changelog...")
shell.run("pastebin get 3DLAa2HE /reactor-turbine-program/changelog/changelog.txt")
print("Lade editOptions...")
shell.run("pastebin get NwHaeCzh /reactor-turbine-program/program/editOptions.lua")
print("Lade Hauptmenue")
shell.run("pastebin get 4jRyfMz7 /reactor-turbine-program/start/menu.lua")
print("Lade Start")
shell.run("pastebin get uLQCLcV9 /reactor-turbine-program/start/start.lua")
print()

term.clear()
term.setCursorPos(1,1)

if not fs.exists("startup") then
	out2 = true
	while out2 do
		print("Startup hinzufuegen? (j/n): ")
		input = read()
		if input == "j" then
			local file = fs.open("startup","w")
			file.writeLine("shell.run(\"/reactor-turbine-program/start/start.lua\")")
			file.close()
			print("Startup wurde installiert.")
			out2 = false
		end
		if input == "n" then
			print("Startup wurde nicht installiert.")
			out2 = false
		else
			print("Ungueltige Eingabe.")
		end
	end
else
	shell.run("delete startup")
	local file = fs.open("startup","w")
	file.writeLine("shell.run(\"/reactor-turbine-program/start/start.lua\")")
	file.close()
end

print("-- Installation abgeschlossen. --")
sleep(1)
print("Bitte den Computer neu starten! (Strg+R gedrueckt halten!")
error("Installer beendet (Diese Meldung ignorieren!).")


