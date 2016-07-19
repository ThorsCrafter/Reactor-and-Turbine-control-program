-- Reaktor- und Turbinenprogramm von Thor_s_Crafter --
-- Version 2.2 --
-- Turbinenkontrolle --

--Laedt die Touchpoint API
os.loadAPI("touchpoint")

local page = touchpoint.new(touchpointLocation)
local lastStat = 0
local currStat = 0
local rOn
local rOff
local tOn
local tOff
local aTOn
local aTOff
local aTN = {"  -  ",label="aTurbinesOn"}
local cOn
local cOff
local modeA
local modeM
if lang == "de" then
  rOn = {" Ein ",label = "reactorOn"}
  rOff = {" Aus ",label = "reactorOn"}
  tOn = {" Ein ",label = "turbineOn"}
  tOff = {" Aus ",label = "turbineOn"}
  aTOn = {" Ein ",label = "aTurbinesOn"}
  aTOff = {" Aus ",label = "aTurbinesOn"}
  cOn = {" Ein ",label = "coilsOn"}
  cOff = {" Aus ",label = "coilsOn"}
  modeA = {" Automatisch ",label = "modeSwitch"}
  modeM = {"  Manuell   ",label = "modeSwitch"}
elseif lang == "en" then
  rOn = {" On  ",label = "reactorOn"}
  rOff = {" Off ",label = "reactorOn"}
  tOn = {" On  ",label = "turbineOn"}
  tOff = {" Off ",label = "turbineOn"}
  aTOn = {" On ",label = "aTurbinesOn"}
  aTOff = {" Off ",label = "aTurbinesOn"}
  cOn = {" On  ",label = "coilsOn"}
  cOff = {" Off ",label = "coilsOn"}
  modeA = {" Automatic ",label = "modeSwitch"}
  modeM = {"  Manual   ",label = "modeSwitch"}
end


--Initialisiert das Programm
function startAutoMode()
  checkPeripherals()
  findOptimalFuelRodLevel()

  --Turbinen auf targetSpeed bringen
  term.clear()
  term.setCursorPos(1,1)
  print("Getting all Turbines to "..turbineTargetSpeed.." RPM...")

  mon.setBackgroundColor(backgroundColor)
  mon.setTextColor(textColor)
  mon.clear()
  mon.setCursorPos(1,1)
  --In Deutsch
  if lang == "de" then
    mon.write("Bringe Turbinen auf "..turbineTargetSpeed.." RPM. Bitte warten...")
    --In Englisch
  elseif lang == "en" then
    mon.write("Getting Turbines to "..turbineTargetSpeed.." RPM. Please wait...")
  end

  while not allAtTargetSpeed() do
    getToTargetSpeed()
    sleep(1)
    term.setCursorPos(1,2)
    for i=0,amountTurbines,1 do
      print("Speed: "..t[i].getRotorSpeed().."     ")

      local speed = tostring(t[i].getRotorSpeed())
      local speedstr = string.sub(speed,0,4)
      mon.setTextColor(textColor)
      mon.setCursorPos(1,(i+3))
      mon.write("Turbine "..(i+1)..": "..speedstr.." RPM")
      if t[i].getRotorSpeed() > turbineTargetSpeed then
        mon.setTextColor(colors.green)
        mon.write(" OK ")
      else
        mon.setTextColor(colors.red)
        mon.write(" ...")
      end
    end
  end

  --Schalte Reaktor & Turbinen an
  r.setActive(true)
  allTurbinesOn()

  --Anzeige auf Default setzen
  term.clear()
  term.setCursorPos(1,1)

  mon.setBackgroundColor(backgroundColor)
  mon.clear()
  mon.setTextColor(textColor)
  mon.setCursorPos(1,1)

  --Buttons erstellen
  createAllButtons()

  --Zeige erste Turbine an (default)
  printStatsAuto(0)

  while true do
    clickEvent()
  end
end
--Ende der startAutoMode()-Funktion

function startManualMode()
  checkPeripherals()
  createAllButtons()
  createManualButtons()
  for i=0,#t do
    t[i].setFluidFlowRateMax(2000)
  end
  printStatsMan(0)
  while true do
    clickEvent()
  end
end

--Überprüft auf Fehler beim Starten
function checkPeripherals()
  mon.setBackgroundColor(colors.black)
  mon.clear()
  mon.setCursorPos(1,1)
  mon.setTextColor(colors.red)
  term.clear()
  term.setCursorPos(1,1)
  term.setTextColor(colors.red)
  if t[0] == nil then
    if lang == "de" then
      mon.write("Turbinen nicht gefunden! Bitte pruefen und den Computer neu starten (Strg+R gedrueckt halten)")
      error("Turbinen nicht gefunden! Bitte pruefen und den Computer neu starten (Strg+R gedrueckt halten)")
    elseif lang == "en" then
      mon.write("Turbines not found! Please check and reboot the computer (Press and hold Ctrl+R)")
      error("Turbines not found! Please check and reboot the computer (Press and hold Ctrl+R)")
    end
  end
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

-- Kleine Methoden
function getEnergy()
  return v.getEnergyStored()
end
function getEnergyMax()
  return v.getMaxEnergyStored()
end
function getEnergyPer()
  local en = getEnergy()
  local enMax = getEnergyMax()
  local enPer = math.floor(en/enMax*100)
  return enPer
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

--Schaltet eine Turbine um
function toggleTurbine(i)
  t[i].setActive(not t[i].getActive())
  page:toggleButton("turbineOn")
  if t[i].getActive() then
    page:rename("turbineOn",tOn,true)
  else
    page:rename("turbineOn",tOff,true)
  end
end

function toggleCoils(i)
  t[i].setInductorEngaged(not t[i].getInductorEngaged())
  page:toggleButton("coilsOn")
  if t[i].getInductorEngaged() then
    page:rename("coilsOn",cOn,true)
  else
    page:rename("coilsOn",cOff,true)
  end
end

--Alle Turbinen an (Coils an, FluidRate 2000mb/t)
function allTurbinesOn()
  for i=0,amountTurbines,1 do
    t[i].setActive(true)
    t[i].setInductorEngaged(true)
    t[i].setFluidFlowRateMax(2000)
  end
end

--Alle Turbinen aus (Coils aus, FluidRate 0mb/t)
function allTurbinesOff()
  for i=0,amountTurbines,1 do
    t[i].setInductorEngaged(false)
    t[i].setFluidFlowRateMax(0)
  end
end

--Eine Turbine an
function turbineOn(i)
  t[i].setInductorEngaged(true)
  t[i].setFluidFlowRateMax(2000)
end

--Eine Turbine aus
function turbineOff(i)
  t[i].setInductorEngaged(false)
  t[i].setFluidFlowRateMax(0)
end

function toggleAllTurbines()
  page:rename("aTurbinesOn",aTOff,true)
  local onOff
  if t[0].getActive() then onOff = "off" else onOff = "on" end
  for i=0,amountTurbines do
    if onOff == "off" then
      t[i].setActive(false)
      if page.buttonList["aTurbinesOn"].active then
        page:toggleButton("aTurbinesOn")
        page:rename("aTurbinesOn",aTOff,true)
      end
    else
      t[i].setActive(true)
      if not page.buttonList["aTurbinesOn"].active then
        page:toggleButton("aTurbinesOn")
        page:rename("aTurbinesOn",aTOn,true)
      end--if
    end--else
  end--for
end--function

function toggleAllCoils()
  local coilsOnOff
  if t[0].getInductorEngaged() then coilsOnOff = "off" else coilsOnOff = "on" end
  for i=0,amountTurbines do
    if coilsOnOff == "off" then
      t[i].setInductorEngaged(false)
      if page.buttonList["Coils"].active then
        page:toggleButton("Coils")
      end
    else
      t[i].setInductorEngaged(true)
      if not page.buttonList["Coils"].active then
        page:toggleButton("Coils")
      end
    end
  end
end

--Sucht das optimale RodLevel
function findOptimalFuelRodLevel()
  --Versuche Level aus der Config zu laden
  if not (math.floor(rodLevel) == 0)  then
    r.setAllControlRodLevels(rodLevel)

  else
    --Bringe Turbinen unter 99 Grad
    getTo99c()

    --Schalte alles ein
    r.setActive(true)
    allTurbinesOn()

    --Lokale Variablen zur Berechnung
    local controlRodLevel = 99
    local diff = 0
    local targetSteamOutput = 2000*(amountTurbines+1)
    local targetLevel = 99

    --Anzeige auf dem Bildschirm
    mon.setBackgroundColor(backgroundColor)
    mon.setTextColor(textColor)
    mon.clear()
    --In Deutsch
    if lang == "de" then
      mon.setCursorPos(1,1)
      mon.write("Finde optimales FuelRod Level...")
      mon.setCursorPos(1,3)
      mon.write("Berechne Level...")
      mon.setCursorPos(1,5)
      mon.write("Gesuchter Steam-Output: "..targetSteamOutput.."mb/t")
      --In Englisch
    elseif lang == "en" then
      mon.setCursorPos(1,1)
      mon.write("Finding optimal FuelRod Level...")
      mon.setCursorPos(1,3)
      mon.write("Calculating Level...")
      mon.setCursorPos(1,5)
      mon.write("Target Steam-Output: "..targetSteamOutput.."mb/t")
    end

    --Berechne bestes Level
    r.setAllControlRodLevels(controlRodLevel)
    sleep(2)
    local steamOutput1 = r.getHotFluidProducedLastTick()
    print("SO1: "..steamOutput1)
    r.setAllControlRodLevels(controlRodLevel-1)
    sleep(2)
    local steamOutput2 = r.getHotFluidProducedLastTick()
    print("SO2: "..steamOutput2)
    diff = steamOutput2 - steamOutput1
    print("Diff: "..diff)

    targetLevel= 100-math.floor(targetSteamOutput/diff)
    print("Target: "..targetLevel)
    r.setAllControlRodLevels(targetLevel)
    controlRodLevel = targetLevel

    --Laeuft durch bis das optimale Level gefunden wurde
    while true do
      sleep(5)

      local steamOutput = r.getHotFluidProducedLastTick()
      mon.setCursorPos(1,3)
      mon.write("FuelRod Level: "..controlRodLevel.."  ")
      --In Deutsch
      if lang == "de" then
        mon.setCursorPos(1,6)
        mon.write("Aktueller Steam-Output: "..steamOutput.."mb/t    ")
        --In Englisch
      elseif lang == "en" then
        mon.setCursorPos(1,6)
        mon.write("Current Steam-Output: "..steamOutput.."mb/t    ")
      end

      --Level zu gross
      if steamOutput < targetSteamOutput then
        controlRodLevel = controlRodLevel - 1
        r.setAllControlRodLevels(controlRodLevel)

      else
        --Level gefunden?
        if steamOutput-targetSteamOutput < 50 then
          r.setAllControlRodLevels(controlRodLevel)
          rodLevel = controlRodLevel
          saveOptionFile()
          print("Target RodLevel: "..controlRodLevel)
          sleep(2)
          break
          --Level zu klein
        else
          controlRodLevel = controlRodLevel + 1
        end--else
      end --else

    end --while

  end --else
end --function
--Ende der findOptimalFuelRodlevel()-Funktion

--Bringt den Reaktor unter 99 Grad
function getTo99c()
  mon.setBackgroundColor(backgroundColor)
  mon.setTextColor(textColor)
  mon.clear()
  mon.setCursorPos(1,1)
  --In Deutsch
  if lang == "de" then
    mon.write("Bringe Reaktor unter 99 Grad...")
    --In Englisch
  elseif lang == "en" then
    mon.write("Getting Reactor below 99c ...")
  end

  --Schalte Reaktor und Turbinen aus
  r.setActive(false)
  allTurbinesOn()

  --Lokale Variablen
  local fTemp = r.getFuelTemperature()
  local cTemp = r.getCasingTemperature()
  local isNotBelow = true

  --Läuft durch, bis die Kern-und Hüllentemperatur unter 99 Grad sind
  while isNotBelow do
    term.setCursorPos(1,2)
    print("CoreTemp: "..fTemp.."      ")
    print("CasingTemp: "..cTemp.."      ")

    fTemp = r.getFuelTemperature()
    cTemp = r.getCasingTemperature()

    if fTemp < 99 then
      if cTemp < 99 then
        isNotBelow = false
      end
    end

    sleep(1)
  end
end
--Ende der getTo99c()-Funktion

--Ueberprueft das Energielevel der Capacitorbank
--und verwaltet die Turbinen und den Reaktor entsprechend
function checkEnergyLevel()
  --Bildschirmausgabe
  printStatsAuto(currStat)
  --Energielevel über der Ausschalt-Grenze (def: 90%)
  if getEnergyPer() >= reactorOffAt then
    printStatsAuto(currStat)
    print("Energy >= reactorOffAt")
    --Ueberprueft, ob die Turbinen ueber targetSpeed sind
    while not allAtTargetSpeed() do
      print("while...")
      getToTargetSpeed()
      printStatsAuto(currStat)
      sleep(0.2)
    end
    --Alle Turbinen sind auf targetSpeed
    --Schaltet Turbinen und Reaktor aus
    if allAtTargetSpeed() then
      print("AllAtTargetSpeed.")
      allTurbinesOff()
      r.setActive(false)
    end
    print("end while")

    --Energielevel ist unter der Einschalt-Grenze
  elseif getEnergyPer() < reactorOnAt then
    --Bringt Turbinen auf targetSpeed
    getToTargetSpeed()
    --Schaltet den Reaktor und die Turbinen ein
    if allAtTargetSpeed() then
      r.setActive(true)
      allTurbinesOn()
    end

    --Energielevel ist zwischen Ober-und Untergrenze
  else
    printStatsAuto(currStat)
    --Behaelt Turbinen konstant auf targetrSpeed
    for i=0,amountTurbines,1 do
      if t[i].getInductorEngaged() and t[i].getRotorSpeed() < turbineTargetSpeed then
        t[i].setInductorEngaged(false)
      end
      if (not t[i].getInductorEngaged()) and t[i].getRotorSpeed() >= (turbineTargetSpeed+20) and r.getActive() then
        t[i].setInductorEngaged(true)
      end
      if (not t[i].getInductorEngaged()) and t[i].getRotorSpeed() >= (turbineTargetSpeed+50) then
        t[i].setInductorEngaged(true)
      end
    end
  end
end
--Ende der checkEnergyLevel()-Funktion

--Bringt Turbinen auf targetSpeed
function getToTargetSpeed()
  for i=0,amountTurbines,1 do
    if t[i].getRotorSpeed() <= turbineTargetSpeed then
      r.setActive(true)
      t[i].setActive(true)
      t[i].setInductorEngaged(false)
      t[i].setFluidFlowRateMax(2000)
    end
    if t[i].getRotorSpeed() > turbineTargetSpeed then
      turbineOff(i)
    end
  end
end

--Gibt true zurueck, wenn alle Turbinen auf targetSpeed sind
function allAtTargetSpeed()
  for i=0,amountTurbines do
    if t[i].getRotorSpeed() < turbineTargetSpeed then
      return false
    end
  end
  return true
end

function run(program)
  shell.run(program)
  error("end turbineControl")
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
  run("turbineControl")
end

--Erstellt alle Buttons
function createAllButtons()
  local xMin = 40
  local xMax = 52
  local yMin = 4
  local yMax = 4

  --Turbinenbuttons
  for i=0,amountTurbines,1 do
    --Gerade Anzahl (wird in der linken Spalte angezeigt)
    if math.floor(i/2)*2 == i then
      if overallMode == "auto" then
        page:add("Turbine "..(i+1),function() printStatsAuto(i) end,xMin,yMin,xMax,yMax)
      elseif overallMode == "manual" then
        page:add("Turbine "..(i+1),function() printStatsMan(i) end,xMin,yMin,xMax,yMax)
      end
    else
      --Ungerade Anzahl (wird in der rechten Spalte angezeigt)
      if overallMode == "auto" then
        page:add("Turbine "..(i+1),function() printStatsAuto(i) end,xMin+15,yMin,xMax+15,yMax)
      elseif overallMode == "manual" then
        page:add("Turbine "..(i+1),function() printStatsMan(i) end,xMin+15,yMin,xMax+15,yMax)
      end
      yMin = yMin + 2
      yMax = yMax + 2
    end
  end
  page:add("modeSwitch",switchMode,19,23,33,23)
  if overallMode == "auto" then
    page:rename("modeSwitch",modeA,true)
  elseif overallMode == "manual" then
    page:rename("modeSwitch",modeM,true)
  end
  --In Deutsch
  if lang == "de" then
    page:add("Neu starten",restart,2,19,17,19)
    page:add("Optionen",function() run("editOptions") end,2,21,17,21)
    page:add("Hauptmenue",function() run("menu") end,2,23,17,23)
    --In Englisch
  elseif lang == "en" then
    page:add("Reboot",restart,2,19,17,19)
    page:add("Options",function() run("editOptions") end,2,21,17,21)
    page:add("Main Menu",function() run("menu") end,2,23,17,23)
  end
  page:draw()
end

function createManualButtons()
  --Reaktor Button
  page:add("reactorOn",toggleReactor,11,11,15,11)
  page:add("Coils",toggleAllCoils,25,17,31,17)
  page:add("aTurbinesOn",toggleAllTurbines,18,17,23,17)
  page:rename("aTurbinesOn",aTN,true)

  if r.getActive() then
    page:rename("reactorOn",rOn,true)
    page:toggleButton("reactorOn")
  else
    page:rename("reactorOn",rOff,true)
  end
  --Turbinen Button (An/Aus)
  page:add("turbineOn",function() toggleTurbine(currStat) end,20,13,24,13)
  if t[currStat].getActive() then
    page:rename("turbineOn",tOn,true)
    page:toggleButton("turbineOn")
  else
    page:rename("turbineOn",tOff,true)
  end
  -- Turbinen Button (Coils)
  page:add("coilsOn",function() toggleCoils(currStat) end,9,15,13,15)
  if t[currStat].getInductorEngaged() then
    page:rename("coilsOn",cOn,true)
  else
    page:rename("coilsOn",cOff,true)
  end
  page:draw()
end

--Überprüft Eingaben des Benutzers auf dem Touchscreen
function clickEvent()

  if overallMode == "auto" then
    printStatsAuto(currStat)
    checkEnergyLevel()
  elseif overallMode == "manual" then
    printStatsMan(currStat)
  end

  local time = os.startTimer(0.5)

  local event, but = page:handleEvents(os.pullEvent())
  print(event)

  if event == "button_click" then
    page:flash(but)
    page.buttonList[but].func()
  end
end


--Gibt alle Daten auf dem Bildschirm aus - Auto Modus
function printStatsAuto(turbine)
  currStat = turbine

  if not page.buttonList["Turbine "..currStat+1].active then
    page:toggleButton("Turbine "..currStat+1)
  end
  if currStat ~= lastStat then
    if page.buttonList["Turbine "..lastStat+1].active then
      page:toggleButton("Turbine "..lastStat+1)
    end
  end

  local rfGen = 0
  for i=0,amountTurbines,1 do
    rfGen = rfGen + t[i].getEnergyProducedLastTick()
  end

  mon.setBackgroundColor(tonumber(backgroundColor))
  mon.setTextColor(tonumber(textColor))

  mon.setCursorPos(2,2)
  if lang == "de" then
    mon.write("Energie: "..getEnergyPer().."%  ")
  elseif lang == "en" then
    mon.write("Energy: "..getEnergyPer().."%  ")
  end

  mon.setCursorPos(2,3)
  mon.setBackgroundColor(colors.green)
  for i=0 ,getEnergyPer(),5 do
    mon.write(" ")
  end

  mon.setBackgroundColor(colors.lightGray)
  local tmpEn = getEnergyPer()/5
  local pos = 22-(19-tmpEn)
  mon.setCursorPos(pos,3)
  for i=0,(19-tmpEn),1 do
    mon.write(" ")
  end

  mon.setBackgroundColor(tonumber(backgroundColor))

  mon.setCursorPos(2,5)
  if lang == "de" then
    mon.write("RF-Produktion: "..math.floor(rfGen).." RF/t      ")
  elseif lang == "en" then
    mon.write("RF-Production: "..math.floor(rfGen).." RF/t      ")
  end

  mon.setCursorPos(2,7)
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

  mon.setCursorPos(2,9)
  local fuelCons = tostring(r.getFuelConsumedLastTick())
  local fuelCons2 = string.sub(fuelCons, 0,4)

  if lang == "de" then
    mon.write("Reaktor-Verbrauch: "..fuelCons2.."mb/t     ")
    mon.setCursorPos(2,10)
    mon.write("Steam: "..math.floor(r.getHotFluidProducedLastTick()).."mb/t    ")
    mon.setCursorPos(40,2)
    mon.write("Turbinen: "..(amountTurbines+1).."  ")
    mon.setCursorPos(19,21)
    mon.write("Modus:")
    mon.setCursorPos(2,12)
    mon.write("-- Turbine "..(turbine+1).." --")
  elseif lang == "en" then
    mon.write("Fuel Consumption: "..fuelCons2.."mb/t     ")
    mon.setCursorPos(2,10)
    mon.write("Steam: "..math.floor(r.getHotFluidProducedLastTick()).."mb/t    ")
    mon.setCursorPos(40,2)
    mon.write("Turbines: "..(amountTurbines+1).."  ")
    mon.setCursorPos(19,21)
    mon.write("Mode:")
    mon.setCursorPos(2,12)
    mon.write("-- Turbine "..(turbine+1).." --")
  end

  mon.setCursorPos(2,13)
  mon.write("Coils: ")

  if t[turbine].getInductorEngaged() then
    mon.setTextColor(colors.green)
    if lang == "de" then
      mon.write("eingehaengt   ")
    elseif lang == "en" then
      mon.write("engaged     ")
    end
  end
  if t[turbine].getInductorEngaged() == false  then
    mon.setTextColor(colors.red)
    if lang == "de" then
      mon.write("ausgehaengt   ")
    elseif lang == "en" then
      mon.write("disengaged")
    end
  end
  mon.setTextColor(tonumber(textColor))

  mon.setCursorPos(2,14)
  if lang == "de" then
    mon.write("Rotor Geschwindigkeit: ")
    mon.write(math.floor(t[turbine].getRotorSpeed()).." RPM   ")
    mon.setCursorPos(2,15)
    mon.write("RF-Produktion: "..math.floor(t[turbine].getEnergyProducedLastTick()).." RF/t           ")
  elseif lang == "en" then
    mon.write("Rotor Speed: ")
    mon.write(math.floor(t[turbine].getRotorSpeed()))
    mon.setCursorPos(2,15)
    mon.write("RF-Production: "..math.floor(t[turbine].getEnergyProducedLastTick()).." RF/t           ")
  end

  mon.setCursorPos(2,25)
  mon.write("Version "..version)
  lastStat = turbine
end

--printStats - Manueller Modus
function printStatsMan(turbine)
  currStat = turbine

  if not page.buttonList["Turbine "..currStat+1].active then
    page:toggleButton("Turbine "..currStat+1)
  end
  if currStat ~= lastStat then
    if page.buttonList["Turbine "..lastStat+1].active then
      page:toggleButton("Turbine "..lastStat+1)
    end
  end

  --Ein/Aus Buttons
  if t[currStat].getActive() and not page.buttonList["turbineOn"].active then
    page:rename("turbineOn",tOn,true)
    page:toggleButton("turbineOn")
  end
  if not t[currStat].getActive() and page.buttonList["turbineOn"].active then
    page:rename("turbineOn",tOff,true)
    page:toggleButton("turbineOn")
  end
  if t[currStat].getInductorEngaged() and not page.buttonList["coilsOn"].active then
    page:rename("coilsOn",cOn,true)
    page:toggleButton("coilsOn")
  end
  if not t[currStat].getInductorEngaged() and page.buttonList["coilsOn"].active then
    page:rename("coilsOn",cOff,true)
    page:toggleButton("coilsOn")
  end

  mon.setBackgroundColor(tonumber(backgroundColor))
  mon.setTextColor(tonumber(textColor))

  mon.setCursorPos(2,2)
  if lang == "de" then
    mon.write("Energie: "..getEnergyPer().."%  ")
  elseif lang == "en" then
    mon.write("Energy: "..getEnergyPer().."%  ")
  end

  mon.setCursorPos(2,3)
  mon.setBackgroundColor(colors.green)
  for i=0 ,getEnergyPer(),5 do
    mon.write(" ")
  end

  mon.setBackgroundColor(colors.lightGray)
  local tmpEn = getEnergyPer()/5
  local pos = 22-(19-tmpEn)
  mon.setCursorPos(pos,3)
  for i=0,(19-tmpEn),1 do
    mon.write(" ")
  end

  local rfGen = 0
  for i=0,amountTurbines,1 do
    rfGen = rfGen + t[i].getEnergyProducedLastTick()
  end

  mon.setBackgroundColor(tonumber(backgroundColor))

  if lang == "de" then
    mon.setCursorPos(2,5)
    mon.write("RF-Produktion: "..math.floor(rfGen).." RF/t      ")
    mon.setCursorPos(2,7)
    local fuelCons = tostring(r.getFuelConsumedLastTick())
    local fuelCons2 = string.sub(fuelCons, 0,4)
    mon.write("Reaktor-Verbrauch: "..fuelCons2.."mb/t     ")
    mon.setCursorPos(2,9)
    mon.write("Rotor Geschwindigkeit: ")
    mon.write(math.floor(t[turbine].getRotorSpeed()).." RPM   ")
    mon.setCursorPos(2,11)
    mon.write("Reaktor: ")
    mon.setCursorPos(19,21)
    mon.write("Modus:")
    mon.setCursorPos(2,13)
    mon.write("Aktuelle Turbine: ")
    mon.setCursorPos(2,17)
    mon.write("Alle Turbinen: ")
  elseif lang == "en" then
    mon.setCursorPos(2,5)
    mon.write("RF-Production: "..math.floor(rfGen).." RF/t      ")
    mon.setCursorPos(2,7)
    local fuelCons = tostring(r.getFuelConsumedLastTick())
    local fuelCons2 = string.sub(fuelCons, 0,4)
    mon.write("Fuel Consumption: "..fuelCons2.."mb/t     ")
    mon.setCursorPos(2,9)
    mon.write("Rotor Speed: ")
    mon.write(math.floor(t[turbine].getRotorSpeed()))
    mon.setCursorPos(2,11)
    mon.write("Reactor: ")
    mon.setCursorPos(19,21)
    mon.write("Mode:")
    mon.setCursorPos(2,13)
    mon.write("Current Turbine: ")
    mon.setCursorPos(2,17)
    mon.write("All Turbines: ")
  end
  mon.setCursorPos(2,15)
  mon.write("Coils: ")

  mon.setCursorPos(40,2)
  if lang == "de" then
    mon.write("Turbinen: "..(amountTurbines+1).."  ")
  elseif lang == "en" then
    mon.write("Turbines: "..(amountTurbines+1).."  ")
  end

  mon.setCursorPos(2,25)
  mon.write("Version "..version)

  lastStat = turbine
end

if overallMode == "auto" then
  startAutoMode()
elseif overallMode == "manual" then
  startManualMode()
end
