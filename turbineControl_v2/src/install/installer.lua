-- Reactor- und Turbine control by Thor_s_Crafter --
-- Version 2.6-beta02 --
-- Installer (Deutsch) --


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
  print("Reaktor- und Turbinenprogramm von Thor_s_Crafter")
  print("Version 2.5")
  print()
  print("Ueber das Programm:")
  print("Das Programm kontrolliert einen BigReactors-Reaktor.")
  print("Es koennen auch bis zu 32 Turbinen angeschlossen werden.")
  print("Der Computer muss mit Wired Modems am Reaktor (und ggf. Turbinen) verbunden werden.")
  print("Ausserdem muss ein Energiespeicher und ein Monitor angeschlossen werden.")
  print("Der Monitor muss min. 7 Bloecke breit und 4 Bloecke hoch sein.")
  print("Wird das Programm mit Turbinen betrieben, sollte der Reaktor pro Turbine mindestens 2000mb/t Steam produzieren koennen.")
  print()
  write("Bitte Enter druecken...")
  leer = read()

  --Computer label
  local out = true
  while out do
    term.clear()
    term.setCursorPos(1,1)
    print("Es wird empfohlen den Computer zu labeln.")
    term.write("Computer labeln? (j/n): ")

    local input = read()
    if input == "j" then
      print()
      shell.run("label set \"TurbineComputer\"")
      print()
      print("ComputerLabel auf \"TurbineComputer\" gesetzt.")
      print()
      sleep(2)
      out = false

    elseif input == "n" then
      print()
      print("ComputerLabel wurde nicht gesetzt.")
      print()
      out = false
    end
  end

  --Startup
  local out2 = true
  while out2 do
    term.clear()
    term.setCursorPos(1,1)
    print("Es wird empfohlen das Programm zum Startup hinzuzufugen.")
    print("Dadurch wird das Programm beim Starten des Computers automatisch ausgefuehrt.")
    term.write("Startup hinzufuegen? (j/n): ")

    local input = read()
    if input == "j" then
      local file = fs.open("startup","w")
      file.writeLine("shell.run(\"/reactor-turbine-program/start/start.lua\")")
      file.close()
      print()
      print("Startup wurde installiert.")
      print()
      out2 = false
    end
    if input == "n" then
      print()
      print("Startup wurde nicht installiert.")
      print()
      out2 = false
    end
  end

  sleep(1)
end --update



term.clear()
term.setCursorPos(1,1)

print("Checke und loesche vorhandene Programme...")

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
writeFile(getURL("install/installer.lua"),"install/installer.lua")
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
  print("Die Installation wurde erfolgreich abgeschlossen!")
  print("Das Programm ist nun einsatzbereit!")
  print()
  term.setTextColor(colors.green)
  print()
  print("Danke, dass du mein Programm benutzt! ;)")
  print("Viel Spass damit!")
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
