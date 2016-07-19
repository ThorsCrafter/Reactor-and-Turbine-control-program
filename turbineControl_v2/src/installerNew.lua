-- Reaktor- und Turbinenprogramm von Thor_s_Crafter --
-- Version 2.2 --
-- Installationsprogramm --

--Lädt die Optionsdatei
if not fs.exists("options.txt") then
	shell.run("pastebin get KFcHD2Bj options.txt")
end

--Liest die Version ein
local optionList = {}
file = fs.open("options.txt","r")
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
		shell.run("rm options.txt")
		shell.run("pastebin get KFcHD2Bj options.txt")
	end
end

--Update?
if fs.exists("turbineControl") or fs.exists("reactorControl") then
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
if fs.exists("touchpoint") then
	shell.run("delete touchpoint")
	print("touchpoint geloescht.")
end
if fs.exists("turbineControl") then
	shell.run("delete turbineControl")
	print("turbineControl geloescht.")
end
if fs.exists("changelog.txt") then
	shell.run("delete changelog.txt")
	print("changelog geloescht.")
end
if fs.exists("showChangelog") then
	shell.run("delete showChangelog")
	print("showChangelog geloescht.")
end
if fs.exists("editOptions") then
	shell.run("delete editOptions")
	print("editOptions geloescht.")
end
if fs.exists("mainMenu") then
	shell.run("delete mainMenu")
	print("mainMenu geloescht.")
end
if fs.exists("menu") then
	shell.run("delete menu")
	print("menu geloescht.")
end
if fs.exists("start") then
	shell.run("delete start")
	print("start geloescht.")
end
if fs.exists("reactorControl") then
  shell.run("delete reactorControl")
  print("reactorControl geloescht.")
end

print("Lade Touchpoint-Programm...")
shell.run("pastebin get yTXVvQ4s touchpoint")
print("Lade Turbinen-Programm...")
shell.run("pastebin get KdnLB5bx turbineControl")
print("Lade Reaktor-Programm")
shell.run("pastebin get KjwASAn2 reactorControl")
print("Lade Changelog...")
shell.run("pastebin get 3DLAa2HE changelog.txt")
print("Lade editOptions...")
shell.run("pastebin get NwHaeCzh editOptions")
print("Lade Hauptmenue")
shell.run("pastebin get 4jRyfMz7 menu")
print("Lade Start")
shell.run("pastebin get uLQCLcV9 start")
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
			file.writeLine("shell.run(\"start\")")
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
	file.writeLine("shell.run(\"start\")")
	file.close()
end

print("-- Installation abgeschlossen. --")
sleep(1)
print("Bitte den Computer neu starten! (Strg+R gedrueckt halten!")
error("Installer beendet (Diese Meldung ignorieren!).")


