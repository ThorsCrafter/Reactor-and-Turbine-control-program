-- Reaktor- und Turbinenprogramm von Thor_s_Crafter --
-- Version 2.2 --
-- Reaktorkontrolle --

shell.run("cp /reactor-turbine-program/config/touchpoint.lua /touchpoint")
os.loadAPI("touchpoint")
shell.run("rm touchpoint")

shell.run("cp /reactor-turbine-program/config/input.lua /input")
os.loadAPI("input")
shell.run("rm input")

local page = touchpoint.new(touchpointLocation)
local rodLevel
local enPer
local fuel
local fuelPer
local rfGen
local fuelCons
local isOn
local enPerR
local rOn
local rOff
local modeA
local modeM

function createButtons()
  if lang == "de" then
    modeA = {" Automatisch ",label = "modeSwitch"}
    modeM = {"  Manuell   ",label = "modeSwitch"}
  elseif lang == "en" then
    modeA = {" Automatic ",label = "modeSwitch"}
    modeM = {"  Manual   ",label = "modeSwitch"}
  end

  page:add("modeSwitch",switchMode,19,22,33,22)
  if overallMode == "auto" then
    page:rename("modeSwitch",modeA,true)
  elseif overallMode == "manual" then
    page:rename("modeSwitch",modeM,true)
  end
  --In Deutsch
  if lang == "de" then
    page:add("Neu starten",restart,2,18,17,18)
    page:add("Optionen",function() run("/reactor-turbine-program/program/editOptions.lua") end,2,20,17,20)
    page:add("Hauptmenue",function() run("/reactor-turbine-program/start/menu.lua") end,2,22,17,22)
    --In Englisch
  elseif lang == "en" then
    page:add("Reboot",restart,2,18,17,18)
    page:add("Options",function() run("/reactor-turbine-program/program/editOptions.lua") end,2,20,17,20)
    page:add("Main Menu",function() run("/reactor-turbine-program/start/menu.lua") end,2,22,17,22)
  end
  page:draw()
end

function createButtonsMan()
  createButtons()
  if lang == "de" then
    rOn = {" Ein ",label = "reactorOn"}
    rOff = {" Aus ",label = "reactorOn"}
  elseif lang == "en" then
    rOn = {" On ",label = "reactorOn"}
    rOff = {" Off ",label = "reactorOn"}
  end
  page:add("reactorOn",toggleReactor,11,10,15,10)
  if r.getActive() then
    page:rename("reactorOn",rOn,true)
    page:toggleButton("reactorOn")
  else
    page:rename("reactorOn",rOff,true)
  end
  page:draw()
end

function checkPeripherals()
  mon.setBackgroundColor(colors.black)
  mon.clear()
  mon.setCursorPos(1,1)
  mon.setTextColor(colors.red)
  term.clear()
  term.setCursorPos(1,1)
  term.setTextColor(colors.red)
  if r == "" then
    if lang == "de" then
      mon.write("Reaktor nicht gefunden! Bitte pruefen und den Computer neu starten (Strg+R gedrueckt halten)")
      error("Reaktor nicht gefunden! Bitte pruefen und den Computer neu starten (Strg+R gedrueckt halten)")
    elseif lang == "en" then
      mon.write("Reactor not found! Please check and reboot the computer (Press and hold Ctrl+R)")
      error("Reactor not found! Please check and reboot the computer (Press and hold Ctrl+R)")
    end
  end
  if v == "" then
    if lang == "de" then
      mon.write("Energiezelle nicht gefunden! Bitte pruefen und den Computer neu starten (Strg+R gedrueckt halten)")
      error("Energiezelle nicht gefunden! Bitte pruefen und den Computer neu starten (Strg+R gedrueckt halten)")
    elseif lang == "en" then
      mon.write("Energy Cell not found! Please check and reboot the computer (Press and hold Ctrl+R)")
      error("Energy Cell not found! Please check and reboot the computer (Press and hold Ctrl+R)")
    end
  end
end

--Schaltet den Reaktor um
function toggleReactor()
  r.setActive(not r.getActive())
  page:toggleButton("reactorOn")
  if r.getActive() then
    page:rename("reactorOn",rOn,true)
  else
    page:rename("reactorOn",rOff,true)
  end
end

function getEnergy()
  local en = v.getEnergyStored()
  local enMax = v.getMaxEnergyStored()
  return math.floor(en/enMax*100)
end

function getEnergyR()
  local en = r.getEnergyStored()
  local enMax = 10000000
  return math.floor(en/enMax*100)
end

function getReactorData()
  rodLevel = r.getControlRodLevel(1)
  enPer = getEnergy()
  enPerR = getEnergyR()
  fuel = r.getFuelAmount()
  local fuelMax = r.getFuelAmountMax()
  fuelPer = math.floor(fuel/fuelMax*100)
  rfGen = r.getEnergyProducedLastTick()
  fuelCons = r.getFuelConsumedLastTick()
  isOn = r.getActive()
end

function getClick()
  getReactorData()

  if overallMode == "auto" then
    displayDataAuto()
  elseif overallMode == "manual" then
    displayDataMan()
  end

  local time = os.startTimer(0.5)

  local event, but = page:handleEvents(os.pullEvent())
  print(event)

  if event == "button_click" then
    page:flash(but)
    page.buttonList[but].func()
  elseif event == "terminate" then
    sleep(2)
    mon.clear()
    mon.setCursorPos(1,1)
    mon.setTextColor(colors.red)
    mon.write("Programm abgebrochen!")
    error("Manuell abgebrochen")
  end
end

function switchMode()
  if overallMode == "auto" then
    overallMode = "manual"
    saveOptionFile()
  elseif overallMode == "manual" then
    overallMode = "auto"
    saveOptionFile()
  end
  page = ""
  mon.clear()
  run("/reactor-turbine-program/program/reactorControl.lua")
end

function displayDataAuto()
  if enPer <= reactorOnAt then
    r.setActive(true)
  elseif enPer > reactorOffAt then
    r.setActive(false)
  end

  page:draw()

  mon.setBackgroundColor(tonumber(backgroundColor))
  mon.setTextColor(tonumber(textColor))

  mon.setCursorPos(2,2)
  if lang == "de" then
    mon.write("Energie: "..enPer.."%  ")
  elseif lang == "en" then
    mon.write("Energy: "..enPer.."%  ")
  end
  mon.setCursorPos(2,3)
  mon.setBackgroundColor(colors.green)
  for i=0 ,enPer,5 do
    mon.write(" ")
  end
  mon.setBackgroundColor(colors.lightGray)
  local tmpEn = enPer/5
  local pos = 22-(19-tmpEn)
  mon.setCursorPos(pos,3)
  for i=0,(19-tmpEn),1 do
    mon.write(" ")
  end

  mon.setBackgroundColor(tonumber(backgroundColor))

  mon.setCursorPos(2,5)
  if lang == "de" then
    mon.write("Energie (Reaktor): "..enPerR.."%  ")
  elseif lang == "en" then
    mon.write("Energy (Reactor): "..enPerR.."%  ")
  end
  mon.setCursorPos(2,6)
  mon.setBackgroundColor(colors.green)
  if enPerR > 5 then
    for i=0 ,enPerR,5 do
      mon.write(" ")
    end
  end
  mon.setBackgroundColor(colors.lightGray)
  if enPerR < 5 then
    for i=1,20 do
      mon.write(" ")
    end
  else
    local tmpEnR = enPerR/5
    local posR = 22-(19-tmpEnR)
    mon.setCursorPos(posR,6)
    for i=0,(19-tmpEnR),1 do
      mon.write(" ")
    end
  end

  mon.setBackgroundColor(tonumber(backgroundColor))

  mon.setCursorPos(30,2)
  mon.write("RodLevel: "..rodLevel.."  ")
  mon.setCursorPos(30,3)
  mon.setBackgroundColor(colors.green)
  for i=0 ,rodLevel,5 do
    mon.write(" ")
  end
  mon.setBackgroundColor(colors.lightGray)
  local tmpRod = rodLevel/5
  local posRL = 50-(19-tmpRod)
  mon.setCursorPos(posRL,3)
  for i=0,(19-tmpRod),1 do
    mon.write(" ")
  end

  mon.setBackgroundColor(tonumber(backgroundColor))

  mon.setCursorPos(2,8)
  if lang == "de" then
    mon.write("RF-Produktion: "..math.floor(rfGen).." RF/t      ")
  elseif lang == "en" then
    mon.write("RF-Production: "..math.floor(rfGen).." RF/t      ")
  end

  mon.setCursorPos(2,10)
  if lang == "de" then
    mon.write("Reaktor: ")
    if r.getActive() then
      mon.setTextColor(colors.green)
      mon.write("an ")
    end
    if not r.getActive() then
      mon.setTextColor(colors.red)
      mon.write("aus")
    end
  elseif lang == "en" then
    mon.write("Reactor: ")
    if r.getActive() then
      mon.setTextColor(colors.green)
      mon.write("on ")
    end
    if not r.getActive() then
      mon.setTextColor(colors.red)
      mon.write("off")
    end
  end

  mon.setTextColor(tonumber(textColor))

  mon.setCursorPos(2,12)
  local fuelCons = tostring(r.getFuelConsumedLastTick())
  local fuelCons2 = string.sub(fuelCons, 0,4)

  if lang == "de" then
    mon.write("Reaktor-Verbrauch: "..fuelCons2.."mb/t     ")
  elseif lang == "en" then
    mon.write("Fuel Consumption: "..fuelCons2.."mb/t     ")
  end

  local caT = tostring(r.getCasingTemperature())
  local caseTemp = string.sub(caT,0,6)
  local coT = tostring(r.getFuelTemperature())
  local coreTemp = string.sub(coT,0,6)

  mon.setCursorPos(2,14)
  if lang == "de" then
    mon.write("Huellentemperatur: "..caseTemp.."C    ")
    mon.setCursorPos(2,15)
    mon.write("Kerntemperatur: "..coreTemp.."C    ")
  elseif lang == "en" then
    mon.write("Casing Temperature: "..caseTemp.."C    ")
    mon.setCursorPos(2,15)
    mon.write("Core Temperature: "..coreTemp.."C    ")
  end


  mon.setCursorPos(2,25)
  mon.write("Version "..version)
end

function displayDataMan()

  if r.getActive() then
    if not page.buttonList["reactorOn"].active then
      page:toggleButton("reactorOn")
      page:rename("reactorOn",rOn,true)
    end
  else
    if page.buttonList["reactorOn"].active then
      page:toggleButton("reactorOn")
      page:rename("reactorOn",rOff,true)
    end
  end

  page:draw()

  mon.setBackgroundColor(tonumber(backgroundColor))
  mon.setTextColor(tonumber(textColor))

  mon.setCursorPos(2,2)
  if lang == "de" then
    mon.write("Energie: "..enPer.."%  ")
  elseif lang == "en" then
    mon.write("Energy: "..enPer.."%  ")
  end
  mon.setCursorPos(2,3)
  mon.setBackgroundColor(colors.green)
  for i=0 ,enPer,5 do
    mon.write(" ")
  end
  mon.setBackgroundColor(colors.lightGray)
  local tmpEn = enPer/5
  local pos = 22-(19-tmpEn)
  mon.setCursorPos(pos,3)
  for i=0,(19-tmpEn),1 do
    mon.write(" ")
  end

  mon.setBackgroundColor(tonumber(backgroundColor))

  mon.setCursorPos(2,5)
  if lang == "de" then
    mon.write("Energie (Reaktor): "..enPerR.."%  ")
  elseif lang == "en" then
    mon.write("Energy (Reactor): "..enPerR.."%  ")
  end
  mon.setCursorPos(2,6)
  mon.setBackgroundColor(colors.green)
  if enPerR > 5 then
    for i=0 ,enPerR,5 do
      mon.write(" ")
    end
  end
  mon.setBackgroundColor(colors.lightGray)
  if enPerR < 5 then
    for i=1,20 do
      mon.write(" ")
    end
  else
    local tmpEnR = enPerR/5
    local posR = 22-(19-tmpEnR)
    mon.setCursorPos(posR,6)
    for i=0,(19-tmpEnR),1 do
      mon.write(" ")
    end
  end

  mon.setBackgroundColor(tonumber(backgroundColor))

  mon.setCursorPos(30,2)
  mon.write("RodLevel: "..rodLevel.."  ")
  mon.setCursorPos(30,3)
  mon.setBackgroundColor(colors.green)
  for i=0 ,rodLevel,5 do
    mon.write(" ")
  end
  mon.setBackgroundColor(colors.lightGray)
  local tmpRod = rodLevel/5
  local posRL = 50-(19-tmpRod)
  mon.setCursorPos(posRL,3)
  for i=0,(19-tmpRod),1 do
    mon.write(" ")
  end

  mon.setBackgroundColor(tonumber(backgroundColor))

  mon.setCursorPos(2,8)
  if lang == "de" then
    mon.write("RF-Produktion: "..math.floor(rfGen).." RF/t      ")
  elseif lang == "en" then
    mon.write("RF-Production: "..math.floor(rfGen).." RF/t      ")
  end

  mon.setCursorPos(2,10)
  if lang == "de" then
    mon.write("Reaktor: ")
  elseif lang == "en" then
    mon.write("Reactor: ")
  end

  mon.setTextColor(tonumber(textColor))

  mon.setCursorPos(2,12)
  local fuelCons = tostring(r.getFuelConsumedLastTick())
  local fuelCons2 = string.sub(fuelCons, 0,4)

  if lang == "de" then
    mon.write("Reaktor-Verbrauch: "..fuelCons2.."mb/t     ")
  elseif lang == "en" then
    mon.write("Fuel Consumption: "..fuelCons2.."mb/t     ")
  end

  local caT = tostring(r.getCasingTemperature())
  local caseTemp = string.sub(caT,0,6)
  local coT = tostring(r.getFuelTemperature())
  local coreTemp = string.sub(coT,0,6)

  mon.setCursorPos(2,14)
  if lang == "de" then
    mon.write("Huellentemperatur: "..caseTemp.."C    ")
    mon.setCursorPos(2,15)
    mon.write("Kerntemperatur: "..coreTemp.."C    ")
  elseif lang == "en" then
    mon.write("Casing Temperature: "..caseTemp.."C    ")
    mon.setCursorPos(2,15)
    mon.write("Core Temperature: "..coreTemp.."C    ")
  end


  mon.setCursorPos(2,25)
  mon.write("Version "..version)
end

function run(program)
  shell.run(program)
  error("end reactorControl")
end

checkPeripherals()
if overallMode == "auto" then
  createButtons()
elseif overallMode == "manual" then
  createButtonsMan()
end
mon.setBackgroundColor(tonumber(backgroundColor))
mon.setTextColor(tonumber(textColor))
mon.clear()
while true do
  getClick()
end























