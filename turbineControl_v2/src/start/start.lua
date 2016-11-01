-- Reactor- und Turbine control by Thor_s_Crafter --
-- Version 2.4 --
-- Start program --

--Global variables
--All options
optionList = {}
version = 0
rodLevel = 0
backgroundColor = 0
textColor = 0
reactorOffAt = 0
reactorOnAt = 0
mainMenu = ""
autoUpdate = "" --deprecated
lang = ""
overallMode = ""
program = ""
turbineTargetSpeed = 0
targetSteam = 0
--Peripherals
mon = "" --Monitor
r = ""
v = ""
t = {}

amountTurbines = 0
--Touchpoint
touchpointLocation = {}

--Global functions
--Loads the options.txt file
function loadOptionFile()
	--Read the file
	local file = fs.open("/reactor-turbine-program/config/options.txt","r")
	local listElement = file.readLine()
	while listElement do
		table.insert(optionList,listElement)
		listElement = file.readLine()
	end
	file.close()

	--Assign values
	version = optionList[3]
	rodLevel = tonumber(optionList[5])
	backgroundColor = tonumber(optionList[7])
	textColor = tonumber(optionList[9])
	reactorOffAt = tonumber(optionList[11])
	reactorOnAt = tonumber(optionList[13])
	mainMenu = optionList[15]
	autoUpdate = optionList[17] --deprecated
	lang = optionList[19]
	overallMode = optionList[21]
	program = optionList[23]
	turbineTargetSpeed = tonumber(optionList[25])
	targetSteam  = tonumber(optionList[27])
end

--Saves all data basck to the options.txt file
function saveOptionFile()
	--Aktualisieren
	refreshOptionList()
	--Daten in die Datei schreiben
	local file = fs.open("/reactor-turbine-program/config/options.txt","w")
	for i=1,#optionList+1,1 do
		file.writeLine(optionList[i])
	end
	file.close()
	print("Saved.")
end

--Refreshes th options list
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
	optionList[27] = targetSteam
end

--Initializing all attached peripherals
function initPeripherals()
    --Get all peripherals
    local peripheralList = peripheral.getNames()
    for i = 1, #peripheralList do
        --Turbinen
        if peripheral.getType(peripheralList[i]) == "BigReactors-Turbine" then
            t[amountTurbines] = peripheral.wrap(peripheralList[i])
            amountTurbines = amountTurbines + 1
        end
        --Reactor
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
        elseif peripheral.getType(peripheralList[i]) == "cofh_thermal_expansion_energycell" then
            v = peripheralList.wrap(peripheralList[i])
        elseif peripheral.getType(peripheralList[i]) == "draconic_rf_storage" then
        v = peripheral.wrap(peripheralList[i])
        end
    end

	--Check for errors
	term.clear()
	term.setCursorPos(1,1)
	--No Monitor
	if mon == "" then
		if lang == "de" then
			error("Monitor nicht gefunden! Bitte pruefen und den Computer neu starten (Strg+R gedrueckt halten)")
		elseif lang == "en" then
			error("Monitor not found! Please check and reboot the computer (Press and hold Ctrl+R)")
		end
	end
	--Monitor clear
	mon.setBackgroundColor(colors.black)
	mon.setTextColor(colors.red)
	mon.clear()
	mon.setCursorPos(1,1)
	--Monitor too small
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

--Restarts the computer
function restart()
	refreshOptionList()
	saveOptionFile()
	mon.clear()
	mon.setCursorPos(38,8)
	mon.write("Reboot...")
	if autoUpdate == true then
		shell.run("/reactor-turbine-program/install/installerUpdate.lua")
	else
		os.reboot()
	end
end

--Start the program
loadOptionFile()
initPeripherals()

--Deprecated
--if autoUpdate == "true" then
--	shell.run("/reactor-turbine-program/install/installerUpdate.lua")
--end

if mainMenu == "true" then
	shell.run("/reactor-turbine-program/start/menu.lua")
	shell.completeProgram("/reactor-turbine-program/start/start.lua")
elseif mainMenu == "false" then
  if program == "turbine" then
	 shell.run("/reactor-turbine-program/program/turbineControl.lua")
  elseif program == "reactor" then
    shell.run("/reactor-turbine-program/program/reactorControl.lua")
  end
	shell.completeProgram("/reactor-turbine-program/start/start.lua")

--Deprecated?
--else
--	mainMenu = "true"
--	saveOptionFile()
--	shell.run("/reactor-turbine-program/start/menu.lua")
--	shell.completeProgram("/reactor-turbine-program/start/start.lua")
end