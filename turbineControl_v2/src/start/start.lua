-- Reactor- and Turbine control by Thor_s_Crafter --
-- Version 2.4 --
-- Start program --

--========== Global variables for all program parts ==========

--All options
optionList = {}
version = 0
rodLevel = 0
backgroundColor = 0
textColor = 0
reactorOffAt = 0
reactorOnAt = 0
mainMenu = ""
lang = ""
overallMode = ""
program = ""
turbineTargetSpeed = 0
targetSteam = 0
--Peripherals
mon = "" --Monitor
r = "" --Reactor
v = "" --Energy Storage
t = {} --Turbines
--Total count of all turbines
amountTurbines = 0
--TouchpointLocation (same as the monitor)
touchpointLocation = {}


--========== Global functions for all program parts ==========


--===== Functions for loading and saving the options =====

--Loads the options.txt file and adds values to the global variables
function loadOptionFile()
	--Loads the file
	local file = fs.open("/reactor-turbine-program/config/options.txt","r")
	local list = file.readAll()
	file.close()

    --Insert Elements and assign values
    optionList = textutils.unserialise(list)

	--Assign values to variables
	version = optionList["version"]
	rodLevel = optionList["rodLevel"]
	backgroundColor = tonumber(optionList["backgroundColor"])
	textColor = tonumber(optionList["textColor"])
	reactorOffAt = optionList["reactorOffAt"]
	reactorOnAt = optionList["reactorOnAt"]
	mainMenu = optionList["mainMenu"]
	lang = optionList["lang"]
	overallMode = optionList["overallMode"]
	program = optionList["program"]
	turbineTargetSpeed = optionList["turbineTargetSpeed"]
	targetSteam  = optionList["targetSteam"]
end

--Refreshes the options list
function refreshOptionList()
	optionList["version"] = version
	optionList["rodLevel"] = rodLevel
	optionList["backgroundColor"] = backgroundColor
	optionList["textColor"] = textColor
	optionList["reactorOffAt"] = reactorOffAt
	optionList["reactorOnAt"] = reactorOnAt
	optionList["mainMenu"] = mainMenu
	optionList["lang"] = lang
	optionList["overallMode"] = overallMode
	optionList["program"] = program
	optionList["turbineTargetSpeed"] = turbineTargetSpeed
	optionList["targetSteam"] = targetSteam
end

--Saves all data basck to the options.txt file
function saveOptionFile()
	--Refresh option list
	refreshOptionList()
    --Serialise the table
    local list = textutils.serialise(optionList)
	--Save optionList to the config file
	local file = fs.open("/reactor-turbine-program/config/options.txt","w")
    file.writeLine(list)
	file.close()
	print("Saved.")
end


--===== Initialization of all peripherals =====

function initPeripherals()
	--Get all peripherals
	local peripheralList = peripheral.getNames()
	for i = 1, #peripheralList do
		--Turbines
		if peripheral.getType(peripheralList[i]) == "BigReactors-Turbine" then
			t[amountTurbines] = peripheral.wrap(peripheralList[i])
			amountTurbines = amountTurbines + 1
			--Reactor
		elseif peripheral.getType(peripheralList[i]) == "BigReactors-Reactor" then
			r = peripheral.wrap(peripheralList[i])
			--Monitor & Touchpoint
		elseif peripheral.getType(peripheralList[i]) == "monitor" then
			mon = peripheral.wrap(peripheralList[i])
			touchpointLocation = peripheralList[i]
			--Capacitorbank / Energycell / Energy Core
		else
			local tmp = peripheral.wrap(peripheralList[i])
			local stat,err = pcall(function() tmp.getEnergyStored() end)
			if stat then
				v = tmp
			end
		end
	end

	--Check for errors
	term.clear()
	term.setCursorPos(1,1)
	--No Monitor
	if mon == "" then
		if lang == "de" then
			error("Monitor nicht gefunden!\nBitte pruefen und den Computer neu starten (Strg+R gedrueckt halten)")
		elseif lang == "en" then
			error("Monitor not found!\nPlease check and reboot the computer (Press and hold Ctrl+R)")
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
			mon.write("Monitor zu klein.\nBitte min. 7 breit und 4 hoch bauen und den Computer neu starten\n(Strg+R gedrueckt halten)")
			error("Monitor zu klein.\nBitte min. 7 breit und 4 hoch bauen und den Computer neu starten\n(Strg+R gedrueckt halten)")
		elseif lang == "en" then
			mon.write("Monitor too small\n Must be at least 7 in length and 4 in height.\nPlease check and reboot the computer (Press and hold Ctrl+R)")
			error("Monitor too small.\nMust be at least 7 in length and 4 in height.\nPlease check and reboot the computer (Press and hold Ctrl+R)")
		end
	end

	amountTurbines = amountTurbines - 1
end


--===== Shutdown and restart the computer =====

function restart()
	saveOptionFile()
	mon.clear()
	mon.setCursorPos(38,8)
	mon.write("Rebooting...")
	os.reboot()
end


--=========== Run the program ==========

--Load the option file and initialize the peripherals
loadOptionFile()
initPeripherals()

--Run program or main menu, based on the settings
if mainMenu then
	shell.run("/reactor-turbine-program/start/menu.lua")
	shell.completeProgram("/reactor-turbine-program/start/start.lua")
else
	if program == "turbine" then
		shell.run("/reactor-turbine-program/program/turbineControl.lua")
	elseif program == "reactor" then
		shell.run("/reactor-turbine-program/program/reactorControl.lua")
	end
	shell.completeProgram("/reactor-turbine-program/start/start.lua")
	--else
	--@TODO insert failsave for main menu bug(s)
end


--========== END OF THE START.LUA FILE ==========