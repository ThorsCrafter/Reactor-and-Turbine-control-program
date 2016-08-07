-- Reaktor- und Turbinenprogramm von Thor_s_Crafter --
-- Version 2.3 --
-- Optionseditor --

shell.run("cp /reactor-turbine-program/config/touchpoint.lua /touchpoint")
os.loadAPI("touchpoint")
shell.run("rm touchpoint")

shell.run("cp /reactor-turbine-program/config/input.lua /input")
os.loadAPI("input")
shell.run("rm input")

menuOn = true

local mode
local mode2
local continue = true
local touch1 = touchpoint.new(touchpointLocation)
local touch2 = touchpoint.new(touchpointLocation)
local touch3 = touchpoint.new(touchpointLocation)
local touch4 = touchpoint.new(touchpointLocation)
local currPage =  touchpoint.new(touchpointLocation)
local currFunct = mainMenu

function saveConfigFile()
  saveOptionFile()
  shell.run("/reactor-turbine-program/program/editOptions.lua")
  error("end editOptions")
end

function exit()
  mon.clear()
  continue = false
  if program == "turbine" then
    shell.run("/reactor-turbine-program/program/turbineControl.lua")
  elseif program == "reactor" then
    shell.run("/reactor-turbine-program/program/reactorControl.lua")
  end
  error("end editOptions")
end

function displayMenu()
  mon.clear()
  shell.run("/reactor-turbine-program/start/menu.lua")
  error("end editOptions")
end

function createAllButtons()
  if lang == "de" then
    touch1:add("Hintergrund",setBackground,3,5,19,5)
    touch1:add("Text",setText,3,7,19,7)
    touch1:add("Reaktor Aus",setOffAt,3,9,19,9)
    touch1:add("Reaktor An",setOnAt,3,11,19,11)
    touch1:add("Turbinen Speed",setTurbineSpeed,3,13,19,13)
    touch1:add("Config loeschen",resetConfig,3,15,19,15)
    touch1:add("Speichern",saveConfigFile,3,19,19,19)
    touch1:add("Zum Programm",exit,3,21,19,21)
    touch1:add("Hauptmenue",displayMenu,3,23,19,23)

    touch2:add("Weiss",function() setColor(1) end,35,5,48,5)
    touch2:add("Orange",function() setColor(2) end,50,5,63,5)
    touch2:add("Magenta",function() setColor(4) end,35,7,48,7)
    touch2:add("Hellblau",function() setColor(8) end,50,7,63,7)
    touch2:add("Gelb",function() setColor(16) end,35,9,48,9)
    touch2:add("Hellgruen",function() setColor(32) end,50,9,63,9)
    touch2:add("Pink",function() setColor(64) end,35,11,48,11)
    touch2:add("Grau",function() setColor(128) end,50,11,63,11)
    touch2:add("Hellgrau",function() setColor(256) end,35,13,48,13)
    touch2:add("Cyan",function() setColor(512) end,50,13,63,13)
    touch2:add("Lila",function() setColor(1024) end,35,15,48,15)
    touch2:add("Blau",function() setColor(2048) end,50,15,63,15)
    touch2:add("Braun",function() setColor(4096) end,35,17,48,17)
    touch2:add("Gruen",function() setColor(8192) end,50,17,63,17)
    touch2:add("Rot",function() setColor(16384) end,35,19,48,19)
    touch2:add("Schwarz",function() setColor(32768) end,50,19,63,19)
    touch2:add("Zurueck",mainMenu,3,8,19,8)

    touch3:add("-1",function() setOnOffAt("-",1) end,3,8,6,8)
    touch3:add("-10",function() setOnOffAt("-",10) end,8,8,12,8)
    touch3:add("-100",function() setOnOffAt("-",100) end,14,8,19,8)
    touch3:add("+1", function() setOnOffAt("+",1) end,3,10,6,10)
    touch3:add("+10",function() setOnOffAt("+",10) end,8,10,12,10)
    touch3:add("+100",function() setOnOffAt("+",100) end,14,10,19,10)
    touch3:add("Zurueck",mainMenu,3,13,19,13)
    
    touch4:add("-1",function() setOnOffAt("-",1) end,3,8,6,8)
    touch4:add("-10",function() setOnOffAt("-",10) end,8,8,12,8)
    touch4:add("-100",function() setOnOffAt("-",100) end,14,8,19,8)
    touch4:add("-1000",function() setOnOffAt("-",1000) end,21,8,28,8)
    touch4:add("+1", function() setOnOffAt("+",1) end,3,10,6,10)
    touch4:add("+10",function() setOnOffAt("+",10) end,8,10,12,10)
    touch4:add("+100",function() setOnOffAt("+",100) end,14,10,19,10)
    touch4:add("+1000",function() setOnOffAt("+",1000) end,21,10,28,10)
    touch4:add("Zurueck",mainMenu,3,13,19,13)

  elseif lang == "en" then
    touch1:add("Background",setBackground,3,5,19,5)
    touch1:add("Text",setText,3,7,19,7)
    touch1:add("Reactor Off",setOffAt,3,9,19,9)
    touch1:add("Reactor On",setOnAt,3,11,19,11)
    touch1:add("Turbine Speed",setTurbineSpeed,3,13,19,13)
    touch1:add("Delete Config",resetConfig,3,15,19,15)
    touch1:add("Save",saveConfigFile,3,19,19,19)
    touch1:add("Back to program",exit,3,21,19,21)
    touch1:add("Main menu",displayMenu,3,23,19,23)

    touch2:add("White",function() setColor(1) end,35,5,48,5)
    touch2:add("Orange",function() setColor(2) end,50,5,63,5)
    touch2:add("Magenta",function() setColor(4) end,35,7,48,7)
    touch2:add("Lightblue",function() setColor(8) end,50,7,63,7)
    touch2:add("Yellow",function() setColor(16) end,35,9,48,9)
    touch2:add("Lime",function() setColor(32) end,50,9,63,9)
    touch2:add("Pink",function() setColor(64) end,35,11,48,11)
    touch2:add("Gray",function() setColor(128) end,50,11,63,11)
    touch2:add("Lightgray",function() setColor(256) end,35,13,48,13)
    touch2:add("Cyan",function() setColor(512) end,50,13,63,13)
    touch2:add("Purple",function() setColor(1024) end,35,15,48,15)
    touch2:add("Blue",function() setColor(2048) end,50,15,63,15)
    touch2:add("Brown",function() setColor(4096) end,35,17,48,17)
    touch2:add("Green",function() setColor(8192) end,50,17,63,17)
    touch2:add("Red",function() setColor(16384) end,35,19,48,19)
    touch2:add("Black",function() setColor(32768) end,50,19,63,19)
    touch2:add("Back",mainMenu,3,8,19,8)

    touch3:add("-1",function() setOnOffAt("-",1) end,3,8,6,8)
    touch3:add("-10",function() setOnOffAt("-",10) end,8,8,12,8)
    touch3:add("-100",function() setOnOffAt("-",100) end,14,8,19,8)
    touch3:add("+1", function() setOnOffAt("+",1) end,3,10,6,10)
    touch3:add("+10",function() setOnOffAt("+",10) end,8,10,12,10)
    touch3:add("+100",function() setOnOffAt("+",100) end,14,10,19,10)
    touch3:add("Back",mainMenu,3,13,19,13)
    
     touch4:add("-1",function() setOnOffAt("-",1) end,3,8,6,8)
    touch4:add("-10",function() setOnOffAt("-",10) end,8,8,12,8)
    touch4:add("-100",function() setOnOffAt("-",100) end,14,8,19,8)
    touch4:add("-1000",function() setOnOffAt("-",1000) end,21,8,28,8)
    touch4:add("+1", function() setOnOffAt("+",1) end,3,10,6,10)
    touch4:add("+10",function() setOnOffAt("+",10) end,8,10,12,10)
    touch4:add("+100",function() setOnOffAt("+",100) end,14,10,19,10)
    touch4:add("+1000",function() setOnOffAt("+",1000) end,21,10,28,10)
    touch4:add("Back",mainMenu,3,13,19,13)
  end
end

function mainMenu()
  mon.clear()
  currPage=touch1
  currPage:draw()
  mon.setCursorPos(2,2)
  mon.setTextColor(tonumber(optionList[9]))
  mon.setBackgroundColor(tonumber(optionList[7]))
  mon.setCursorPos(4,2)

  if lang == "de" then
    mon.write("-- Optionen --")
  elseif lang == "en" then
    mon.write("-- Options --")
  end

  mon.setCursorPos(24,5)
  local col = printColor(tonumber(optionList[7]))
  local col2 = printColor(backgroundColor)
  if tonumber(optionList[7]) ~= backgroundColor then
    if lang == "de" then
      mon.write("Hintergrundfarbe: "..col.." -> "..col2.."   ")
    elseif lang == "en" then
      mon.write("BackgroundColor: "..col.." -> "..col2.."   ")
    end
  else
    if lang == "de" then
      mon.write("Hintergrundfarbe: "..col2.."    ")
    elseif lang == "en" then
      mon.write("BackgroundColor: "..col2.."    ")
    end
  end

  mon.setCursorPos(24,7)
  local col3 = printColor(tonumber(optionList[9]))
  local col4 = printColor(textColor)
  if tonumber(optionList[9]) ~= textColor then
    if lang == "de" then
      mon.write("Textfarbe: "..col3.." -> "..col4.."   ")
    elseif lang == "en" then
      mon.write("TextColor: "..col3.." -> "..col4.."   ")
    end
  else
    if lang == "de" then
      mon.write("Textfarbe: "..col4.."   ")
    elseif lang == "en" then
      mon.write("TextColor: "..col4.."   ")
    end
  end

  mon.setCursorPos(24,9)
  if math.floor(tonumber(optionList[11])) ~= math.floor(reactorOffAt) then
    if lang == "de" then
      mon.write("Reaktor aus bei ueber "..math.floor(tonumber(optionList[11])).."% -> "..math.floor(reactorOffAt).."%   ")
    elseif lang == "en" then
      mon.write("Reactor off above "..math.floor(tonumber(optionList[11])).."% -> "..math.floor(reactorOffAt).."%   ")
    end
  else
    if lang == "de" then
      mon.write("Reaktor aus bei ueber "..math.floor(reactorOffAt).."%   ")
    elseif lang == "en" then
      mon.write("Reactor off above "..math.floor(reactorOffAt).."%   ")
    end
  end

  mon.setCursorPos(24,11)
  if math.floor(tonumber(optionList[13])) ~= math.floor(reactorOnAt) then
    if lang == "de" then
      mon.write("Reaktor an bei unter "..math.floor(tonumber(optionList[13])).."% -> "..math.floor(reactorOnAt).."%   ")
    elseif lang == "en" then
      mon.write("Reactor on below "..math.floor(tonumber(optionList[13])).."% -> "..math.floor(reactorOnAt).."%   ")
    end

  else
    if lang == "de" then
      mon.write("Reaktor an bei unter "..math.floor(reactorOnAt).."%   ")
    elseif lang == "en" then
      mon.write("Reactor on below "..math.floor(reactorOnAt).."%   ")
    end
  end
  
  mon.setCursorPos(24,13)
  if tonumber(optionList[25]) ~= turbineTargetSpeed then
    if lang == "de" then
      mon.write("Turbinen Max. Speed: "..(input.formatNumber(math.floor(tonumber(optionList[25])))).." -> "..(input.formatNumber(turbineTargetSpeed)).."RPM      ")
    elseif lang == "en" then
      mon.write("Turbines Max. Speed: "..(input.formatNumberComma(math.floor(tonumber(optionList[25])))).." -> "..(input.formatNumberComma(turbineTargetSpeed)).."RPM      ")
    end

  else
    if lang == "de" then
      mon.write("Turbinen Max. Speed: "..(input.formatNumber(turbineTargetSpeed)).."RPM     ")
    elseif lang == "en" then
      mon.write("Turbines Max. Speed: "..(input.formatNumberComma(turbineTargetSpeed)).."RPM     ")
    end
  end

  mon.setCursorPos(24,15)
  if lang == "de" then
    mon.write("Config vorhanden: ")
  elseif lang == "en" then
    mon.write("Config available: ")
  end
  if math.floor(tonumber(optionList[5])) ~= math.floor(rodLevel) then
    if lang == "de" then
      mon.write("ja -> nein")
    elseif lang == "en" then
      mon.write("yes -> no")
    end
  else
    if math.floor(rodLevel) == 0 then
      if lang == "de" then
        mon.write("nein   ")
      elseif lang == "en" then
        mon.write("no     ")
      end
    else
      if lang == "de" then
        mon.write("ja   ")
      elseif lang == "en" then
        mon.write("yes   ")
      end
    end
  end
  getClick(mainMenu)
end

function setBackground()
  mode = "background"
  mon.clear()
  currPage = touch2
  currPage:draw()
  mon.setBackgroundColor(backgroundColor)
  mon.setTextColor(textColor)
  mon.setCursorPos(3,2)
  if lang == "de" then
    mon.write("-- Hintergrundfarbe aendern --")
    mon.setCursorPos(3,5)
    mon.write("Hintergrundfarbe: ")
  elseif lang == "en" then
    mon.write("-- Change BackgroundColor --")
    mon.setCursorPos(3,5)
    mon.write("BackgroundColor: ")
  end
  local col = printColor(backgroundColor)
  mon.write(col)
  --refreshOptionList()
  getClick(setBackground)
end

function setText()
  mode = "text"
  mon.clear()
  currPage = touch2
  currPage:draw()
  mon.setBackgroundColor(backgroundColor)
  mon.setTextColor(textColor)
  mon.setCursorPos(3,2)
  if lang == "de" then
    mon.write("-- Textfarbe aendern --")
    mon.setCursorPos(3,5)
    mon.write("Textfarbe: ")
  elseif lang == "en" then
    mon.write("-- Change TextColor --")
    mon.setCursorPos(3,5)
    mon.write("TextColor: ")
  end
  local col = printColor(textColor)
  mon.write(col)
  --refreshOptionList()
  getClick(setText)
end

function setOffAt()
  mode2 = "off"
  mon.clear()
  currPage = touch3
  currPage:draw()
  mon.setBackgroundColor(backgroundColor)
  mon.setTextColor(textColor)
  mon.setCursorPos(3,2)
  if lang == "de"	then
    mon.write("-- Reaktor aus --")
    mon.setCursorPos(3,5)
    mon.write("Reaktor aus bei ueber "..math.floor(reactorOffAt).."%  ")
  elseif lang == "en" then
    mon.write("-- Reactor off --")
    mon.setCursorPos(3,5)
    mon.write("Reactor off above "..math.floor(reactorOffAt).."%  ")
  end
  --refreshOptionList()
  getClick(setOffAt)
end

function setOnAt()
  mode2 = "on"
  mon.clear()
  currPage = touch3
  currPage:draw()
  mon.setBackgroundColor(backgroundColor)
  mon.setTextColor(textColor)
  mon.setCursorPos(3,2)
  if lang == "de" then
    mon.write("-- Reaktor an --")
    mon.setCursorPos(3,5)
    mon.write("Reaktor an bei unter "..math.floor(reactorOnAt).."%  ")
  elseif lang == "en" then
    mon.write("-- Reactor on --")
    mon.setCursorPos(3,5)
    mon.write("Reactor on below "..math.floor(reactorOnAt).."%  ")
  end
  --refreshOptionList()
  getClick(setOnAt)
end

function setColor(id)
  if mode == "background" then
    backgroundColor = id
    setBackground()
  elseif mode == "text" then
    textColor = id
    setText()
  end
end

function printColor(which)
  --	local which
  --	if mode == "background" then which = backgroundColor
  --	elseif mode == "text" then which = textColor end
  if lang == "en" then
    if which == 1 then return "White"
    elseif which == 2 then return "Orange"
    elseif which == 4 then return "Magenta"
    elseif which == 8 then return "Lightblue"
    elseif which == 16 then return "Yellow"
    elseif which == 32 then return "Lime"
    elseif which == 64 then return "Pink"
    elseif which == 128 then return "Gray"
    elseif which == 256 then return "Lightgray"
    elseif which == 512 then return "Cyan"
    elseif which == 1024 then return "Purple"
    elseif which == 2048 then return "Blue"
    elseif which == 4096 then return "Brown"
    elseif which == 8192 then return "Green"
    elseif which == 16384 then return "Red"
    elseif which == 32768 then return "Black"
    end
  elseif lang == "de" then
    if which == 1 then return "Weiss"
    elseif which == 2 then return "Orange"
    elseif which == 4 then return "Magenta"
    elseif which == 8 then return "Hellblau"
    elseif which == 16 then return "Gelb"
    elseif which == 32 then return "Hellgruen"
    elseif which == 64 then return "Pink"
    elseif which == 128 then return "Grau"
    elseif which == 256 then return "Hellgrau"
    elseif which == 512 then return "Cyan"
    elseif which == 1024 then return "Lila"
    elseif which == 2048 then return "Blau"
    elseif which == 4096 then return "Braun"
    elseif which == 8192 then return "Gruen"
    elseif which == 16384 then return "Rot"
    elseif which == 32768 then return "Schwarz"
    end
  end
end

function setOnOffAt(vorz,anz)
  if vorz == "-" then
    if mode2 == "off" then
      reactorOffAt = reactorOffAt - anz
      if reactorOffAt < 0 then reactorOffAt = 0 end
    elseif mode2 == "on" then
      reactorOnAt = reactorOnAt - anz
      if reactorOnAt < 0 then reactorOnAt = 0 end
    elseif mode2 == "speed" then
      turbineTargetSpeed = turbineTargetSpeed - anz
      if turbineTargetSpeed < 0 then turbineTargetSpeed = 0 end
    end
  elseif vorz == "+" then
    if mode2 == "off" then
      reactorOffAt = reactorOffAt + anz
      if reactorOffAt >100 then reactorOffAt = 100 end
    elseif mode2 == "on" then
      reactorOnAt = reactorOnAt + anz
      if reactorOnAt >100 then reactorOnAt = 100 end
    elseif mode2 == "speed" then
      turbineTargetSpeed = turbineTargetSpeed + anz
    end
  end
  if mode2 == "off" then setOffAt()
  elseif mode2 == "on" then setOnAt() end
end

function setTurbineSpeed()
mode2 = "speed"
  mon.clear()
  currPage = touch4
  currPage:draw()
  mon.setBackgroundColor(backgroundColor)
  mon.setTextColor(textColor)
  mon.setCursorPos(3,2)
  if lang == "de" then
    mon.write("-- Turbinen Speed --")
    mon.setCursorPos(3,5)
    mon.write("Maximale Turbinengeschwindigkeit: "..(input.formatNumber(turbineTargetSpeed)).."RPM      ")
  elseif lang == "en" then
    mon.write("-- Turbine Speed --")
    mon.setCursorPos(3,5)
    mon.write("Maximum Turbine speed: "..(input.formatNumberComma(turbineTargetSpeed)).."RPM      ")
  end
  --refreshOptionList()
  getClick(setTurbineSpeed)
  setTurbineSpeed()
end

function resetConfig()
  rodLevel = 0
  mainMenu()
end

function getClick(funct)
  local event,but = currPage:handleEvents(os.pullEvent())
  if event == "button_click" then
    currPage:flash(but)
    currPage.buttonList[but].func()
  else
    sleep(1)
    funct()
  end
end

mon.clear()
createAllButtons()
mainMenu()






