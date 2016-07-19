-- Reactor- und Turbinecontrolprogram by Thor_s_Crafter --
-- Version 2.2 --
-- Installationsprogramm --

if not fs.exists("options.txt") then
	shell.run("pastebin get KFcHD2Bj options.txt")
end

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

if tonumber(version) < nVersion then
	
	if tonumber(version) < 2.2	then
		shell.run("rm options.txt")
		shell.run("pastebin get KFcHD2Bj options.txt")
	end

end

term.clear()
term.setCursorPos(1,1)

--Header
print("-- Installer of the Reactor- und Turbinecontrolprogram by Thor_s_Crafter --")
print("-- Version "..nVersion.." --")
print()

if fs.exists("turbineControl") then
	update = true
	print("Updating Program...")
end


if not update then
	out = true
	print("About this program:")
	print("The program controls one BigReactors reactor.")
	print("You can also attach up to 16 turbines.")
	print("You must connect the computer with Wired Modems to the reactor (and the turbines).")
	print("Additionally some kind of Energy Cell and a monitor is required.")
	print("The size of the monitor has to be at least 7 in length and 4 high.")
	print("If set up with turbines, the reactor must be able to produce at least 2000mb/t of steam per turbine.")
	print()
	write("Press Enter...")
	leer = read()
	term.clear()
	term.setCursorPos(1,1)
	print("It is recommended to label the computer.")
	while out do
		write("Label computer? (y/n): ")
		input = read()
		if input == "y" then
			shell.run("label set \"TurbineComputer\"")
			print("ComputerLabel set to \"TurbineComputer\"")
			out = false
		elseif input == "n" then
			print("ComputerLabel not set.")
			out = false
		else
			print("Wrong input.")
		end
	end

	sleep(1)
end

term.clear()
term.setCursorPos(1,1)

print("Checking existing programs...")
if fs.exists("touchpoint") then
	shell.run("delete touchpoint")
	print("touchpoint deleted.")
end
if fs.exists("turbineControl") then
	shell.run("delete turbineControl")
	print("turbineControl deleted.")
end
if fs.exists("changelog.txt") then
	shell.run("delete changelog.txt")
	print("changelog deleted.")
end
if fs.exists("showChangelog") then
	shell.run("delete showChangelog")
	print("showChangelog deleted.")
end
if fs.exists("editOptions") then
	shell.run("delete editOptions")
	print("editOptions deleted.")
end
if fs.exists("mainMenu") then
	shell.run("delete mainMenu")
	print("mainMenu deleted.")
end
if fs.exists("menu") then
	shell.run("delete menu")
	print("menu deleted.")
end
if fs.exists("start") then
	shell.run("delete start")
	print("start deleted.")
end
if fs.exists("reactorControl") then
  shell.run("delete reactorControl")
  print("reactorControl geloescht.")
end

print("Loading Touchpoint-Program...")
shell.run("pastebin get yTXVvQ4s touchpoint")
print("Loading Turbine-Program...")
shell.run("pastebin get KdnLB5bx turbineControl")
print("Loading Reactor-Program")
shell.run("pastebin get KjwASAn2 reactorControl")
print("Loading Changelog...")
shell.run("pastebin get h1G9tH7y changelog.txt")
print("Loading editOptions...")
shell.run("pastebin get NwHaeCzh editOptions")
print("Loading Hauptmenue")
shell.run("pastebin get 4jRyfMz7 menu")
print("Loading Start")
shell.run("pastebin get uLQCLcV9  start")
print()

term.clear()
term.setCursorPos(1,1)

if not fs.exists("startup") then
	out2 = true
	while out2 do
		print("Add startup? (y/n): ")
		input = read()
		if input == "y" then
			local file = fs.open("startup","w")
			file.writeLine("shell.run(\"start\")")
			file.close()
			print("Startup installed.")
			out2 = false
		end
		if input == "n" then
			print("Startup not installed.")
			out2 = false
		else
			print("Wrong input.")
		end
	end
else
	shell.run("delete startup")
	local file = fs.open("startup","w")
	file.writeLine("shell.run(\"start\")")
	file.close()	
end

print("-- Installation completed. --")
sleep(1)
print("Please restart the computer! (Press and hold Ctrl+R!")
error("Installer terminated (Ignore this!).")

