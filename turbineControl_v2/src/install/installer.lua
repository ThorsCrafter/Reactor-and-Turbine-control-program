-- Reactor- und Turbine control by Thor_s_Crafter --
-- Version 2.3 --
-- Installer (Deutsch) --

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
  print("Reaktor- und Turbinenprogramm von Thor_s_Crafter")
  print("Version 2.3")
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
print("Fertig!")

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
  print("Die Installation wurde erfolgreich abgeschlossen!")
  print("Das Programm ist nun einsatzbereit!")
  print()
  term.setTextColor(colors.yellow)
  print("Beim ersten Start ist es notwendig den Computer manuell neu zu starten!")
  print("Dazu bitte \"reboot\" eingeben oder \"Strg + R\" kurz gedrueckt halten.")
  term.setTextColor(colors.white)
  print()
  print("Danke, dass du mein Programm benutzt! ;)")
  print("Viel Spass damit.")
  print("(Thor_s_Crafter)")
  print()
end
error("Installer beendet. (Das ist kein Fehler! Bitte ignorieren!)")



