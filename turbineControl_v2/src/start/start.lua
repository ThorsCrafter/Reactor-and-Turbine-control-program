-- Reactor- and Turbine control by Thor_s_Crafter --
-- Version 2.6-beta01 --
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


--===== Automatic update detection =====

--Check for updates
function checkUpdates()

	--Check current branch (release or beta)
	local currBranch = ""
	local tmpString = string.sub(version,5,5)
	if tmpString == "" or tmpString == nil then
		currBranch = "master"
	elseif tmpString == "b" then
		currBranch = "beta"
	end

	--Get Remote version file
	downloadFile("https://raw.githubusercontent.com/ThorsCrafter/Reactor-and-Turbine-control-program/"..currBranch.."/turbineControl_v2/src/",currBranch..".ver")

	--Compare local and remote version
	local file = fs.open(currBranch..".ver","r")
	local remoteVer = file.readLine()
	file.close()

	print("remoteVer: "..remoteVer)
	print("localVer: "..version)
	print("Update? -> "..tostring(remoteVer > version))

	--Update if available
	if remoteVer > version then
		print("Update...")
		sleep(2)
		doUpdate(remoteVer,currBranch)
	end

	--Remove remote version file
	shell.run("rm "..currBranch..".ver")
end


function doUpdate(toVer,branch)

	--Set the monitor up
	local x,y = mon.getSize()
	mon.setBackgroundColor(colors.black)
	mon.clear()

	local x1 = x/2-15
	local y1 = y/2-4
	local x2 = x/2
	local y2 = y/2

	--Draw Box
	mon.setBackgroundColor(colors.gray)
	mon.setTextColor(colors.gray)
	mon.setCursorPos(x1,y1)
	for i=1,8 do
		mon.setCursorPos(x1,y1+i-1)
		mon.write("                              ") --30 chars
	end

	--Print update message
	mon.setTextColor(colors.white)

	if lang == "de" then

		mon.setCursorPos(x2-9,y1+1)
		mon.write("Update verfuegbar!") --18 chars

		mon.setCursorPos(x2-(math.ceil(string.len(toVer)/2)),y1+3)
		mon.write(toVer)

		mon.setCursorPos(x2-8,y1+5)
		mon.write("Zum installieren") --16 chars

		mon.setCursorPos(x2-12,y1+6)
		mon.write("in den Computer schauen") --23 chars

	elseif lang == "en" then

		mon.setCursorPos(x2-9,y1+1)
		mon.write("Update available!") --17 chars

		mon.setCursorPos(x2-(math.ceil(string.len(toVer)/2)),y1+3)
		mon.write(toVer)

		mon.setCursorPos(x2-8,y1+5)
		mon.write("To install look") --15 chars

		mon.setCursorPos(x2-12,y1+6)
		mon.write("at the computer terminal") --24 chars
	end

	--Print install instructions to the terminal
	term.clear()
	term.setCursorPos(1,1)
	local tx,ty = term.getSize()

	if lang == "de" then
		print("Soll das Update installiert werden (j/n)?")
		term.write("Eingabe: ")
	elseif lang == "en" then
		print("Do you want to install the update (y/n)?")
		term.write("Input: ")
	end

	--Run Counter for installation skipping
	local count = 10
	local out = false

	term.setCursorPos(tx/2-5,ty)
	term.write(" -- 10 -- ")

	while true do

		local timer1 = os.startTimer(1)

		while true do

			local event, p1 = os.pullEvent()

			if event == "key" then

				if p1 == 36 or p1 == 21 then
					shell.run("/reactor-turbine-program/install/installer.lua update "..branch)
					out = true
					break
				end

			elseif event == "timer" and p1 == timer1 then

				count = count - 1
				term.setCursorPos(tx/2-5,ty)
				term.write(" -- 0"..count.." -- ")
				break
			end
		end

		if out then break end

		if count == 0 then
			term.clear()
			term.setCursorPos(1,1)
			break
		end
	end
end

--Download Files (For Remote version file)
function downloadFile(relUrl,path)
	local gotUrl = http.get(relUrl..path)
	if gotUrl == nil then
		term.clear()
		error("File not found! Please check!\nFailed at "..relUrl..path)
	else
		url = gotUrl.readAll()
	end

	local file = fs.open(path,"w")
	file.write(url)
	file.close()
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
checkUpdates()

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
end


--========== END OF THE START.LUA FILE ==========
