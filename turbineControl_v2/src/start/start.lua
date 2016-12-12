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
	--Inserts all elements into the optionList
	local listElement = file.readLine()
	while listElement do
		table.insert(optionList,listElement)
		listElement = file.readLine()
	end
	file.close()

	--Assign values to variables
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

--Saves all data basck to the options.txt file
function saveOptionFile()
	--Refresh option list
	refreshOptionList()
	--Save optionList to the config file
	local file = fs.open("/reactor-turbine-program/config/options.txt","w")
	for i=1,#optionList+1,1 do
		file.writeLine(optionList[i])
	end
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
--else
	--@TODO insert failsave for main menu bug(s)
end


--========== END OF THE START.LUA FILE ==========