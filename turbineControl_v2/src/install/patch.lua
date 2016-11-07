-- Reactor- und Turbine control by Thor_s_Crafter --
-- Patcher for all versions --

--Currently for: Version 2.3

--Remove all previous program parts
if fs.exists("changelog.txt") then shell.run("rm changelog.txt") end
if fs.exists("editOptions") then shell.run("rm editOptions") end
if fs.exists("installer") then shell.run("rm installer") end
if fs.exists("installerUpdate") then shell.run("rm installerUpdate") end
if fs.exists("menu") then shell.run("rm menu") end
if fs.exists("options.txt") then shell.run("rm options.txt") end
if fs.exists("reactorControl") then shell.run("rm reactorControl") end
if fs.exists("start") then shell.run("rm start") end
if fs.exists("startup") then shell.run("rm startup") end
if fs.exists("touchpoint") then shell.run("rm touchpoint") end
if fs.exists("turbineControl") then shell.run("rm turbineControl") end

--Create install directory
if not fs.exists("/reactor-turbine-program/install/") then
shell.run("mkdir /reactor-turbine-program/install/")
else shell.run("rm /reactor-turbine-program/") end

--User Input
local userInput = ""
while true do
  term.clear()
  term.setCursorPos(1,1)
  print("Bitte Sprache auswaehlen.")
  print("Please choose your language.")
  print("de / en")
  term.write("-> ")
  userInput = read()
  if userInput == "de" or userInput == "en" then
    break
  end
end

--Gets the current files
if userInput == "de" then
  shell.run("pastebin get 5BA3RTAf /reactor-turbine-program/install/installerUpdate.lua")
elseif userInput == "en" then
   shell.run("pastebin get np6WZLJw /reactor-turbine-program/install/installerUpdate.lua")
end

--Start new installer
shell.run("/reactor-turbine-program/install/installerUpdate.lua")




