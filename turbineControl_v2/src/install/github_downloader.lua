-- Reactor- und Turbine control by Thor_s_Crafter --
-- Betaversion downloader (GitHub) --

--Release or beta version?
local selectInstaller = "release"

--Branch & Relative paths to the url and path
local installLang = ""
local branch = ""
local relUrl = ""
local relPath = "/reactor-turbine-program/"


--Select the installer language
function selectLanguage()
	clearTerm()
	print("Sprache/Language")
	print("1) Deutsch/German (de)")
	print("2) English (en)")
	term.write("Eingabe/Enter (1-2): ")
	local input = read()
	if input == "1" then installLang = "de"
	elseif input == "2" then installLang = "en"
	else
		print("Ungueltige Eingabe!")
		print("Invalid input!")
		sleep(2)
		selectLanguage()
	end
end

--Select the github branch to download
function selectBranch()
	clearTerm()
	if installLang == "de" then
		print("Welche Version soll geladen werden?")
		print("Verfuegbar:")
		print("1) master (Realeases)")
		print("2) build-2.4.2 (Betatestversion)")
		term.write("Eingabe (1-2): ")
	elseif installLang == "en" then
		print("Which version should be downloaded?")
		print("Available:")
		print("1) master (Realeases)")
		print("2) build-2.4.2 (Betaversion)")
		term.write("Input (1-2): ")
	end	
	local input = read()
	if input == "1" then branch = "master"
	elseif input == "2" then branch = "build-2.4.2"
	else
		if installLang == "de" then print("Ungueltige Eingabe!")
		elseif installLang == "en" then print("Invalid input!") end
		sleep(2)
		selectBranch()
	end
	relUrl = "https://raw.githubusercontent.com/ThorsCrafter/Reactor-and-Turbine-control-program/"..branch.."/turbineControl_v2/src/"
end

--Removes old installations
function removeAll()
	print("Removing old files...")
	if fs.exists(relPath) then
		shell.run("rm "..relPath)
	end
	if fs.exists("startup") then
		shell.run("rm startup")
	end
end

--Writes the files to the computer
function writeFile(url,path)
	local file = fs.open("/reactor-turbine-program/"..path,"w")
	file.write(url)
	file.close()
end

--Resolve the right url
function getURL(path)
	local gotUrl = http.get(relUrl..path)
	if gotUrl == nil then
		clearTerm()
		error("File not found! Please check, if the branch is correct!")
	else
		return gotUrl.readAll()
	end
end

--Gets all the files from github
function getFiles()
	clearTerm()
	print("Getting new files...")
	--Changelog
	print("Changelog files...")
	writeFile(getURL("changelog/changelogDE.txt"),"changelog/changelogDE.txt")
	writeFile(getURL("changelog/changelogEn.txt"),"changelog/changelogDE.txt")
	--Config
	print("Config files...")
	writeFile(getURL("config/input.lua"),"config/input.lua")
	writeFile(getURL("config/options.txt"),"config/options.txt")
	writeFile(getURL("config/touchpoint.lua"),"config/touchpoint.lua")
	--Install
	print("Install files...")
	writeFile(getURL("install/installer.lua"),"install/installer.lua")
	--Program
	print("Program files...")
	writeFile(getURL("program/editOptions.lua"),"program/editOptions.lua")
	writeFile(getURL("program/reactorControl.lua"),"program/reactorControl.lua")
	writeFile(getURL("program/turbineControl.lua"),"program/turbineControl.lua")
	--Start
	print("Start files...")
	writeFile(getURL("start/menu.lua"),"start/menu.lua")
	writeFile(getURL("start/start.lua"),"start/start.lua")
	--Startup
	print("Startup file...")
	local file = fs.open("startup","w")
  	file.writeLine("shell.run(\"/reactor-turbine-program/start/start.lua\")")
	file.close()
end

--Clears the terminal
function clearTerm()
	shell.run("clear")
	term.setCursorPos(1,1)
end

function releaseVersion()
	--Set branch (relUrl) to "master"
	relUrl = "https://raw.githubusercontent.com/ThorsCrafter/Reactor-and-Turbine-control-program/master/turbineControl_v2/src/"

	removeAll()
	--Downloads the installer
	if installLang == "de" then
		writeFile(getURL("install/installer.lua"),"install/installer.lua")
	elseif installLang == "en" then
		writeFile(getURL("install/installerEn.lua"),"install/installer.lua")
	end
	shell.run("/reactor-turbine-program/install/installer.lua")
end

function betaVersion()
	selectBranch()
	removeAll()
	getFiles()
	print("Done!")
	sleep(2)
end

--Run
selectLanguage()

if selectInstaller == "beta" then
	betaVersion()
elseif selectInstaller == "release" then
	releaseVersion()
else
	error("Enter a release version! (\"beta\"/\"release\") in line 5!")
end

os.reboot()