-- Reactor- und Turbine control by Thor_s_Crafter --
-- Version 2.4 --
-- Installer (English) --

--Loads the option file if not present yet
if not fs.exists("/reactor-turbine-program/config/options.txt") then
  shell.run("pastebin get KFcHD2Bj /reactor-turbine-program/config/options.txt")
end

--Reads the version --Currently deprecated
local optionList = {}
file = fs.open("/reactor-turbine-program/config/options.txt","r")
listElement = file.readLine()
while listElement do
  table.insert(optionList,listElement)
  listElement = file.readLine()
end
file.close()

local version = optionList[3]
local nVersion = 2.3

--Update?
if fs.exists("/reactor-turbine-program/program/turbineControl.lua") then
  update = true
else update = false
end

--First time installation
if not update then
  --Description
  term.clear()
  term.setCursorPos(1,1)
  print("Reactor- and Turbine control by Thor_s_Crafter")
  print("Version 2.3")
  print()
  print("About this program:")
  print("The program controls one BigReactors reactor.")
  print("You can also attach up to 32 turbines.")
  print("You must connect the computer with Wired Modems to the reactor (and the turbines).")
  print("Additionally some kind of Energy Storage and a monitor is required.")
  print("The size of the monitor has to be at least 7 wide and 4 high.")
  print("If set up with turbines, the reactor must be able to produce at least 2000mb/t of steam per turbine.")
  print()
  write("Press Enter...")
  leer = read()

  --Computer label
  local out = true
  while out do
    term.clear()
    term.setCursorPos(1,1)
    print("It is recommended to label the computer.")
    term.write("Do you want to label the computer? (y/n): ")

    local input = read()
    if input == "y" then
      print()
      shell.run("label set \"TurbineComputer\"")
      print()
      print("ComputerLabel set to \"TurbineComputer\".")
      print()
      sleep(2)
      out = false

    elseif input == "n" then
      print()
      print("ComputerLabel not set.")
      print()
      out = false
    end
  end

  --Startup
  local out2 = true
  while out2 do
    term.clear()
    term.setCursorPos(1,1)
    print("It is recommended to add the program to the computers' startup.")
    print("If you add the program to the startup, the program will automatically run when the computer is started.")
    term.write("Add startup? (y/n): ")

    local input = read()
    if input == "y" then
      local file = fs.open("startup","w")
      file.writeLine("shell.run(\"/reactor-turbine-program/start/start.lua\")")
      file.close()
      print()
      print("Startup installed.")
      print()
      out2 = false
    end
    if input == "n" then
      print()
      print("Startup not installed.")
      print()
      out2 = false
    end
  end

  sleep(1)
end --update

term.clear()
term.setCursorPos(1,1)

print("Checking an removing existing programs...")
--Removes input.lua and touchpoint.lua
if fs.exists("/reactor-turbine-program/config/input.lua") then
  shell.run("rm /reactor-turbine-program/config/input.lua")
end
if fs.exists("/reactor-turbine-program/config/touchpoint.lua") then
  shell.run("rm /reactor-turbine-program/config/touchpoint.lua")
end
--Removes the program folder
if fs.exists("/reactor-turbine-program/program/") then
  shell.run("rm /reactor-turbine-program/program/")
end
--Removes the start folder
if fs.exists("/reactor-turbine-program/start/") then
  shell.run("rm /reactor-turbine-program/start/")
end
--Removes the changelog folder
if fs.exists("/reactor-turbine-program/changelog/") then
  shell.run("rm /reactor-turbine-program/changelog/")
end

--Download all program parts
print("Lade neue Programmteile...")
shell.run("pastebin get yszvvGGG /reactor-turbine-program/config/input.lua")
shell.run("pastebin get yTXVvQ4s /reactor-turbine-program/config/touchpoint.lua")
shell.run("pastebin get NwHaeCzh /reactor-turbine-program/program/editOptions.lua")
shell.run("pastebin get KjwASAn2 /reactor-turbine-program/program/reactorControl.lua")
shell.run("pastebin get KdnLB5bx /reactor-turbine-program/program/turbineControl.lua")
shell.run("pastebin get 4jRyfMz7 /reactor-turbine-program/start/menu.lua")
shell.run("pastebin get uLQCLcV9 /reactor-turbine-program/start/start.lua")
shell.run("pastebin get 3DLAa2HE /reactor-turbine-program/changelog/changelogDe.txt")
shell.run("pastebin get h1G9tH7y /reactor-turbine-program/changelog/changelogEn.txt")
print("Done!")

term.clear()
term.setCursorPos(1,1)

--Refresh startup (if installed)
if fs.exists("startup") then
  shell.run("delete startup")
  local file = fs.open("startup","w")
  file.writeLine("shell.run(\"/reactor-turbine-program/start/start.lua\")")
  file.close()
end

--Install complete
term.clear()
term.setCursorPos(1,1)

if not update then
  print("Installation successful!")
  print("The program is now ready to run!")
  print()
  term.setTextColor(colors.yellow)
  print("You have just installed the program for the first time!")
  print("It is necessary to reboot the computer manually once.")
  print("In order to do this, please type in \"reboot\" or press \"Ctrl + R\" for a moment.")
  term.setTextColor(colors.white)
  print()
  print("Thanks for using my program! ;)")
  print("I hope you like it.")
  print("(Thor_s_Crafter)")
  print()
end
error("Installer terminated. (This is not an error! Please ignore!)")


