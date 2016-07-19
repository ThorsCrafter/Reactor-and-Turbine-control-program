--Reaktor- und Turbinenprogramm von Thor_s_Crafter --
-- Version 2.2 --
-- Globale Einstellungen --

--Globale Variablen fuer alle Programmteile
--Alle Optionen
optionList = {}
version = 0
rodLevel = 0
backgroundColor = 0
textColor = 0
reactorOffAt = 0
reactorOnAt = 0
mainMenu = ""
autoUpdate = ""
lang = ""
overallMode = ""
program = ""
turbineTargetSpeed = 0
--Peripherals
mon = "" --Monitor
r = ""
v = ""
t = {}

amountTurbines = 0
--Touchpoint
touchpointLocation = {}

-- Globale Funktionen --
--Lädt die Optionsdatei
function loadOptionFile()
	--Datei einlesen
	local file = fs.open("options.txt","r")
	listElement = file.readLine()
	while listElement do
		table.insert(optionList,listElement)
		listElement = file.readLine()
	end
	file.close()

	--Werte zuordnen
	version = optionList[3]
	rodLevel = tonumber(optionList[5])
	backgroundColor = tonumber(optionList[7])
	textColor = tonumber(optionList[9])
	reactorOffAt = tonumber(optionList[11])
	reactorOnAt = tonumber(optionList[13])
	mainMenu = optionList[15]
	autoUpdate = optionList[17]
	lang = optionList[19]
	overallMode = optionList[21]
	program = optionList[23]
	turbineTargetSpeed = tonumber(optionList[25])
end

--Speichert alle Daten in der Optionsdatei
function saveOptionFile()
	--Aktualisieren
	refreshOptionList()
	--Daten in die Datei schreiben
	local file = fs.open("options.txt","w")
	for i=1,#optionList+1,1 do
		file.writeLine(optionList[i])
	end
	file.close()
	print("Saved.")
end

--Aktualisiert optionList
function refreshOptionList()
	optionList[3] = version
	optionList[5] = rodLevel
	optionList[7] = backgroundColor
	optionList[9] = textColor
	optionList[11] = reactorOffAt
	optionList[13] = reactorOnAt
	optionList[15] = mainMenu
	optionList[17] = autoUpdate
	optionList[19] = lang
	optionList[21] = overallMode
	optionList[23] = program
	optionList[25] = turbineTargetSpeed
end

--Initialisiert alle angeschlossenen Geräte
function initPeripherals()
	--Sucht nach allen angeschlossenen Geräten
	local peripheralList = peripheral.getNames()
	for i=1,#peripheralList do
		--Turbinen
		if peripheral.getType(peripheralList[i]) == "BigReactors-Turbine" then
			t[amountTurbines]=peripheral.wrap(peripheralList[i])
			amountTurbines = amountTurbines + 1
		end
		--Reaktor
		if peripheral.getType(peripheralList[i]) == "BigReactors-Reactor" then
			r = peripheral.wrap(peripheralList[i])
		end
		--Monitor & Touchpoint
		if peripheral.getType(peripheralList[i]) == "monitor" then
			mon = peripheral.wrap(peripheralList[i])
			touchpointLocation = peripheralList[i]
		end
		--Capacitorbank / Energycell / Energy Core
		if peripheral.getType(peripheralList[i]) == "tile_blockcapacitorbank_name" then
			v = peripheral.wrap(peripheralList[i])
		elseif peripheral.getType(peripheralList[i]) == "capacitor_bank" then
			v = peripheral.wrap(peripheralList[i])
		elseif peripheral.getType(peripheralList[i]) == "tile_thermalexpansion_cell_basic_name" then
			v = peripheral.wrap(peripheralList[i])
		elseif peripheral.getType(peripheralList[i]) == "tile_thermalexpansion_cell_hardened_name" then
			v = peripheral.wrap(peripheralList[i])
		elseif peripheral.getType(peripheralList[i]) == "tile_thermalexpansion_cell_reinforced_name" then
			v = peripheral.wrap(peripheralList[i])
		elseif peripheral.getType(peripheralList[i]) == "tile_thermalexpansion_cell_resonant_name" then
			v = peripheral.wrap(peripheralList[i])
		elseif peripheral.getType(peripheralList[i]) == "draconic_rf_storage" then
			v = peripheral.wrap(peripheralList[i])
		end

	end

	--Fehlererkennung
	term.clear()
	term.setCursorPos(1,1)
	mon.setBackgroundColor(colors.black)
	mon.setTextColor(colors.red)
	mon.clear()
	mon.setCursorPos(1,1)
	--Kein Monitor
	if mon == "" then
		if lang == "de" then
			error("Monitor nicht gefunden! Bitte pruefen und den Computer neu starten (Strg+R gedrueckt halten)")
		elseif lang == "en" then
			error("Monitor not found! Please check and reboot the computer (Press and hold Ctrl+R)")
		end
	end
	--Monitor zu klein
	local monX,monY = mon.getSize()
	if monX < 71 or monY < 26 then
		if lang == "de" then
			mon.write("Monitor zu klein. Bitte min. 7 breit und 4 hoch bauen und den Computer neu starten (Strg+R gedrueckt halten)")
			error("Monitor zu klein. Bitte min. 7 breit und 4 hoch bauen  und den Computer neu starten (Strg+R gedrueckt halten)")
		elseif lang == "en" then
			mon.write("Monitor too small. Must be at least 7 in length and 4 in height.  Please check and reboot the computer (Press and hold Ctrl+R)")
			error("Monitor too small. Must be at least 7 in length and 4 in height.  Please check and reboot the computer (Press and hold Ctrl+R)")
		end
	end

	amountTurbines = amountTurbines - 1
end

function restart()
	refreshOptionList()
	saveOptionFile()
	mon.clear()
	mon.setCursorPos(38,8)
	mon.write("Reboot...")
	if autoUpdate == true then
		shell.run("installerUpdate")
	else
		os.reboot()
	end
end

-- Startet das Programm --
loadOptionFile()
initPeripherals()
if autoUpdate == "true" then
	shell.run("installerUpdate")
end
if mainMenu == "true" then
	shell.run("menu")
	error("end start")
elseif mainMenu == "false" then
  if program == "turbine" then
	 shell.run("turbineControl")
  elseif program == "reactor" then
    shell.run("reactorControl")
  end
	error("end start")
else
	mainMenu = "true"
	saveOptionFile()
	shell.run("menu")
	error("end start")
end





