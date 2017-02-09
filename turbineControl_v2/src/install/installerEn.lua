-- Reactor- und Turbine control by Thor_s_Crafter --
-- Version 2.5 --
-- Installer (English) --


--===== Local Variables =====

local arg = {... }
local update
local branch = ""

--Program arguments for updates
if #arg == 0 then

  --No update
  update = false
  branch = "master"

elseif #arg == 2 then

  if arg[1] == "update" then

    --Update!
    update = true

    --Select update branch
    if arg[2] == "release" then branch = "master"
    elseif arg[2] == "beta" then branch = "beta"
    else
      error("Invalid 2nd argument!")
    end

  else
    error("Invalid 1st argument!")
  end

else
  error("0 or 2 arguments required!")
end

--Url for file downloads
local relUrl = "https://raw.githubusercontent.com/ThorsCrafter/Reactor-and-Turbine-control-program/"..branch.."/turbineControl_v2/src/"


--===== Functions =====

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
    term.clear()
    term.setCursorPos(1,1)
    error("File not found! Please check!\nFailed at "..relUrl..path)
  else
    return gotUrl.readAll()
  end
end


--===== Run installation =====

--First time installation
if not update then
  --Description
  term.clear()
  term.setCursorPos(1,1)
  print("Reactor- and Turbine control by Thor_s_Crafter")
  print("Version 2.5")
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

print("Checking and deleting existing files...")
--Removes old files
if fs.exists("/reactor-turbine-program/program/") then
  shell.run("rm /reactor-turbine-program/")
end

--Download all program parts
print("Lade neue Programmteile...")
print("Getting new files...")
--Changelog
term.write("Downloading Changelog files...")
writeFile(getURL("changelog/changelogDE.txt"),"changelog/changelogDE.txt")
writeFile(getURL("changelog/changelogEn.txt"),"changelog/changelogEn.txt")
print("     Done.")
--Config
term.write("Config files...")
writeFile(getURL("config/input.lua"),"config/input.lua")
writeFile(getURL("config/options.txt"),"config/options.txt")
writeFile(getURL("config/touchpoint.lua"),"config/touchpoint.lua")
print("     Done.")
--Install
term.write("Install files...")
writeFile(getURL("install/installerEn.lua"),"install/installer.lua")
print("     Done.")
--Program
term.write("Program files...")
writeFile(getURL("program/editOptions.lua"),"program/editOptions.lua")
writeFile(getURL("program/reactorControl.lua"),"program/reactorControl.lua")
writeFile(getURL("program/turbineControl.lua"),"program/turbineControl.lua")
print("     Done.")
--Start
term.write("Start files...")
writeFile(getURL("start/menu.lua"),"start/menu.lua")
writeFile(getURL("start/start.lua"),"start/start.lua")
print("     Done.")
print()
print("Fertig!")

term.clear()
term.setCursorPos(1,1)

--Refresh startup (if installed)
if fs.exists("startup") then
  shell.run("rm startup")
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
  term.setTextColor(colors.green)
  print()
  print("Thanks for using my program! ;)")
  print("I hope you like it.")
  print()
  print("Thor_s_Crafter")
  print("(c) 2016")

  local x,y = term.getSize()
  term.setTextColor(colors.yellow)
  term.setCursorPos(1,y)
  term.write("Reboot in ")
  for i=5,0,-1 do
    term.setCursorPos(11,y)
    term.write(i)
    sleep(1)
  end
end

shell.completeProgram("/reactor-turbine-program/install/installer.lua")


