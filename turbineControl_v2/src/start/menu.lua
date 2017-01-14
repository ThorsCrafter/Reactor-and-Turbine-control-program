-- Reaktor- und Turbinenprogramm von Thor_s_Crafter --
-- Version 2.3 --
-- Hauptmenue --

--Loads the Touchpoint API (by Lyqyd)
shell.run("cp /reactor-turbine-program/config/touchpoint.lua /touchpoint")
os.loadAPI("touchpoint")
shell.run("rm touchpoint")

-- Lokale Variablen --
--Touchpoint Page
local page = touchpoint.new(touchpointLocation)
--	Button Labels
local startOn = {}
local startOff = {}

--Erstellt die Buttons im Hauptmenu
function createButtons()
  page:add("Deutsch",nil,39,11,49,11)
  page:add("English",nil,39,13,49,13)

  --In Deutsch
  if lang == "de" then
    page:add("Programm starten",startTC,3,5,20,5)
    page:add("Nur Reaktor",function() switchProgram("Reactor") end,3,9,20,9)
    page:add("Mit Turbinen",function() switchProgram("Turbine") end,3,11,20,11)
    page:add("Automatisch",nil,23,9,35,9)
    page:add("Manuell",nil,23,11,35,11)
    page:add("Optionen",displayOptions,3,16,20,16)
    page:add("Programm beenden",exit,3,18,20,18)
    page:add("Neu starten",reboot,3,20,20,20)
    page:add("menuOn",nil,39,7,49,7)
    startOn = {"   Ein   ",label = "menuOn"}
    startOff = {"   Aus   ",label = "menuOn"}
    page:toggleButton("Deutsch")
    --Programm
    if program == "turbine" then
      page:toggleButton("Mit Turbinen")
    elseif program == "reactor" then
      page:toggleButton("Nur Reaktor")
    end
    --Aktiv, je nach Modus
    if overallMode == "auto" then
      page:toggleButton("Automatisch")
    elseif overallMode == "manual" then
      page:toggleButton("Manuell")
    end

    --In Englisch
  elseif lang == "en" then
    page:add("Start program",startTC,3,5,20,5)
    page:add("Reactor only",function() switchProgram("Reactor") end,3,9,20,9)
    page:add("Turbines",function() switchProgram("Turbine") end,3,11,20,11)
    page:add("Automatic",nil,23,9,35,9)
    page:add("Manual",nil,23,11,35,11)
    page:add("Options",displayOptions,3,16,20,16)
    page:add("Quit program",exit,3,18,20,18)
    page:add("Reboot",restart,3,20,20,20)
    page:add("menuOn",nil,39,7,49,7)
    startOn = {"   On    ",label = "menuOn"}
    startOff = {"   Off   ",label = "menuOn"}
    page:toggleButton("English")
    --Programm
    if program == "turbine" then
      page:toggleButton("Turbines")
    elseif program == "reactor" then
      page:toggleButton("Reactor only")
    end
    --Aktiv, je nach Modus
    if overallMode == "auto" then
      page:toggleButton("Automatic")
    elseif overallMode == "manual" then
      page:toggleButton("Manual")
    end
  end

  --Aktiv, wenn mainMenu an ist
  if mainMenu then
    page:rename("menuOn",startOn,true)
    page:toggleButton("menuOn")
  else
    page:rename("menuOn",startOff,true)
  end
end

--Beendet das Programm
function exit()
  mon.clear()
  mon.setCursorPos(27,8)
  if lang == "de" then
    mon.write("Programm beendet!")
  elseif lang == "en" then
    mon.write("Program terminated!")
  end
  term.clear()
  term.setCursorPos(1,1)
  shell.completeProgram("/reactor-turbine-program/start/menu.lua")
end

function switchProgram(currBut)
  if program == "turbine" and currBut == "Reactor" then
    program = "reactor"
    if lang == "de" then
      if not page.buttonList["Nur Reaktor"].active then
        page:toggleButton("Nur Reaktor")
      end
      if page.buttonList["Mit Turbinen"].active then
        page:toggleButton("Mit Turbinen")
      end
    elseif lang == "en" then
      if not page.buttonList["Reactor only"].active then
        page:toggleButton("Reactor only")
      end
      if page.buttonList["Turbines"].active then
        page:toggleButton("Turbines")
      end
    end
  elseif program == "reactor" and currBut == "Turbine" then
    program = "turbine"
    if lang == "de" then
      if page.buttonList["Nur Reaktor"].active then
        page:toggleButton("Nur Reaktor")
      end
      if not page.buttonList["Mit Turbinen"].active then
        page:toggleButton("Mit Turbinen")
      end
    elseif lang == "en" then
      if page.buttonList["Reactor only"].active then
        page:toggleButton("Reactor only")
      end
      if not page.buttonList["Turbines"].active then
        page:toggleButton("Turbines")
      end
    end
  end
  saveOptionFile()
  page:draw()
  displayMenu()
end

function startTC()
  if program == "turbine" then
    shell.run("/reactor-turbine-program/program/turbineControl.lua")
  elseif program == "reactor" then
    shell.run("/reactor-turbine-program/program/reactorControl.lua")
  end
end
function displayOptions()
  shell.run("/reactor-turbine-program/program/editOptions.lua")
end
function reboot()
  restart()
end

--Überprüft auf Button-Klicks
local function getClick(funct)
  local event,but = page:handleEvents(os.pullEvent())
  if event == "button_click" then
    if but == "menuOn" then
      print("menuOn")
      if not mainMenu then
        mainMenu = true
        saveOptionFile()
        page:rename("menuOn",startOn,true)
      elseif mainMenu then
        mainMenu = false
        saveOptionFile()
        page:rename("menuOn",startOff,true)
      end
      page:toggleButton(but)
      funct()

    elseif but == "Automatisch" or but == "Automatic" then
      if page.buttonList[but].active == false then
        page:toggleButton(but)
      end
      if overallMode == "manual" then
        if lang == "de" then
          page:toggleButton("Manuell")
        elseif lang == "en" then
          page:toggleButton("Manual")
        end
      elseif overallMode == "semi-manual" then
        if lang == "de" then
          page:toggleButton("Halbautomatisch")
        elseif lang == "en" then
          page:toggleButton("Semi-Manual")
        end
      end
      overallMode = "auto"
      saveOptionFile()
      funct()

    elseif but == "Manuell" or but == "Manual" then
      if page.buttonList[but].active == false then
        page:toggleButton(but)
      end
      if overallMode == "auto" then
        if lang == "de" then
          page:toggleButton("Automatisch")
        elseif lang == "en" then
          page:toggleButton("Automatic")
        end
      elseif overallMode == "semi-manual" then
        if lang == "de" then
          page:toggleButton("Halbautomatisch")
        elseif lang == "en" then
          page:toggleButton("Semi-Manual")
        end
      end
      overallMode = "manual"
      saveOptionFile()
      funct()

    elseif but == "Deutsch" then
      page.buttonList["Deutsch"].active = true
      page.buttonList["English"].active = false
      if lang == "en" then lang = "de" end
      saveOptionFile()
      mon.clear()
      page = {}
      page = touchpoint.new(touchpointLocation)
      createButtons()
      funct()

    elseif but == "English" then
      page.buttonList["Deutsch"].active = false
      page.buttonList["English"].active = true
      if lang == "de" then lang = "en" end
      saveOptionFile()
      mon.clear()
      page = {}
      page = touchpoint.new(touchpointLocation)
      createButtons()
      funct()
    else
      page:flash(but)
      page.buttonList[but].func()
    end

  else
    sleep(1)
    funct()
  end
end

--Zeigt das Menü an
function displayMenu()
  mon.clear()
  page:draw()
  mon.setBackgroundColor(backgroundColor)
  mon.setTextColor(textColor)
  --In Deutsch
  if lang == "de" then
    mon.setCursorPos(3,2)
    mon.write("-- Hauptmenue --")
    mon.setCursorPos(39,5)
    mon.write("Hauptmenue zeigen: ")
    mon.setCursorPos(39,9)
    mon.write("Sprache: ")
    mon.setCursorPos(3,7)
    mon.write("Programm: ")
    mon.setCursorPos(23,7)
    mon.write("Modus:")
    --In Englisch
  elseif lang == "en" then
    mon.setCursorPos(3,2)
    mon.write("-- Main Menu --")
    mon.setCursorPos(39,5)
    mon.write("Show this screen on startup: ")
    mon.setCursorPos(39,9)
    mon.write("Language: ")
    mon.setCursorPos(3,7)
    mon.write("Program: ")
    mon.setCursorPos(23,7)
    mon.write("Mode:")

  end

  getClick(displayMenu)
end

createButtons()
displayMenu()