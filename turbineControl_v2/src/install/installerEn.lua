-- Reactor- und Turbinecontrolprogram by Thor_s_Crafter --
-- Version 2.2 --
-- Installationsprogramm --

if not fs.exists("/reactor-turbine-program/config/options.txt") then
	shell.run("pastebin get KFcHD2Bj /reactor-turbine-program/program/options.txt")
end

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

if tonumber(version) < nVersion then
	
	if tonumber(version) < 2.2	then
		shell.run("rm /reactor-turbine-program/config/options.txt")
		shell.run("pastebin get KFcHD2Bj /reactor-turbine-program/config/options.txt")
	end

end

term.clear()
term.setCursorPos(1,1)

--Header
print("-- Installer of the Reactor- und Turbinecontrolprogram by Thor_s_Crafter --")
print("-- Version "..nVersion.." --")
print()

if fs.exists("/reactor-turbine-program/program/turbineControl.lua") then
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
if fs.exists("/reactor-turbine-program/config/touchpoint.lua") then
	shell.run("delete /reactor-turbine-program/config/touchpoint.lua")
	print("touchpoint deleted.")
end
if fs.exists("/reactor-turbine-program/program/turbineControl.lua") then
	shell.run("delete /reactor-turbine-program/program/turbineControl.lua")
	print("turbineControl deleted.")
end
if fs.exists("/reactor-turbine-program/changelog/changelog.txt") then
	shell.run("delete /reactor-turbine-program/changelog/changelog.txt")
	print("changelog deleted.")
end
if fs.exists("/reactor-turbine-program/program/editOptions.lua") then
	shell.run("delete /reactor-turbine-program/program/editOptions.lua")
	print("editOptions deleted.")
end
if fs.exists("/reactor-turbine-program/start/menu.lua") then
	shell.run("delete /reactor-turbine-program/start/menu.lua")
	print("menu deleted.")
end
if fs.exists("/reactor-turbine-program/start/start.lua") then
	shell.run("delete /reactor-turbine-program/start/start.lua")
	print("start deleted.")
end
if fs.exists("/reactor-turbine-program/program/reactorControl.lua") then
  shell.run("delete /reactor-turbine-program/program/reactorControl.lua")
  print("reactorControl geloescht.")
end

print("Loading Touchpoint-Program...")
shell.run("pastebin get yTXVvQ4s /reactor-turbine-program/config/touchpoint.lua")
print("Loading Turbine-Program...")
shell.run("pastebin get KdnLB5bx /reactor-turbine-program/config/turbineControl.lua")
print("Loading Reactor-Program")
shell.run("pastebin get KjwASAn2 /reactor-turbine-program/program/reactorControl.lua")
print("Loading Changelog...")
shell.run("pastebin get h1G9tH7y /reactor-turbine-program/changelog/changelog.txt")
print("Loading editOptions...")
shell.run("pastebin get NwHaeCzh /reactor-turbine-program/program/editOptions.lua")
print("Loading Hauptmenue")
shell.run("pastebin get 4jRyfMz7 /reactor-turbine-program/start/menu.lua")
print("Loading Start")
shell.run("pastebin get uLQCLcV9  /reactor-turbine-program/start/start.lua")
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
			file.writeLine("shell.run(\"/reactor-turbine-program/start/start.lua\")")
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
	file.writeLine("shell.run(\"/reactor-turbine-program/start/start.lua\")")
	file.close()	
end

print("-- Installation completed. --")
sleep(1)
print("Please restart the computer! (Press and hold Ctrl+R!")
error("Installer terminated (Ignore this!).")

