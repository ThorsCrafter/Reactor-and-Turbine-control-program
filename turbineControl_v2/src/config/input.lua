-- Input API --
-- von Thor_s_Crafter --
-- Version 1.0 --


--Formatiert grosse Zahlenwerte in String (z.B. 1.000)
function formatNumber(value)
  --Werte kleiner 1000 muessen nicht formatiert werden
  if value < 1000 then return value end

  --Legt Berechnungsvariablen fest
  local array = {}
  local vStr = tostring(value)
  local len = string.len(vStr)
  local modulo = math.fmod(len,3)

  --Speichert einzelne Ziffern in einem Array ab
  for i=1,len do array[i] = string.sub(vStr,i,i) end

  --Legt (max. 2) Ziffern am Anfang in ein extra Array und entfernt
  --Diese aus dem alten Array
  local array2 = {}
  if modulo ~= 0 then
    for i=1,modulo do
      array2[i] = array[i]
      table.remove(array,i)
    end
  end

  --Fuegt die Punkte als Feld im ersten Array ein
  for i=1,#array+1,4 do
    table.insert(array,i,".")
  end

  --Fuegt beide Arrays zusammen
  for i=#array2,1,-1 do table.insert(array,1,array2[i]) end
  if modulo == 0 then table.remove(array,1) end --Entfernt ggf. Punkt am Anfang

  --Wandelt alles in einen String zurueck und gibt diesen zurueck
  local final = ""
  for k,v in pairs(array) do final = final..v end
  return final
end

--Wartet darauf das "Enter" gedrueckt wird
function getEnter()
  term.write("Enter druecken...")
  while true do
    local event,keyCode = os.pullEvent("key")
    if keyCode == 28 then
      print()
      break
    end
  end
end

function formatNumberComma(value)
  --Werte kleiner 1000 muessen nicht formatiert werden
  if value < 1000 then return value end

  --Legt Berechnungsvariablen fest
  local array = {}
  local vStr = tostring(value)
  local len = string.len(vStr)
  local modulo = math.fmod(len,3)

  --Speichert einzelne Ziffern in einem Array ab
  for i=1,len do array[i] = string.sub(vStr,i,i) end

  --Legt (max. 2) Ziffern am Anfang in ein extra Array und entfernt
  --Diese aus dem alten Array
  local array2 = {}
  if modulo ~= 0 then
    for i=1,modulo do
      array2[i] = array[i]
      table.remove(array,i)
    end
  end

  --Fuegt die Punkte als Feld im ersten Array ein
  for i=1,#array+1,4 do
    table.insert(array,i,",")
  end

  --Fuegt beide Arrays zusammen
  for i=#array2,1,-1 do table.insert(array,1,array2[i]) end
  if modulo == 0 then table.remove(array,1) end --Entfernt ggf. Punkt am Anfang

  --Wandelt alles in einen String zurueck und gibt diesen zurueck
  local final = ""
  for k,v in pairs(array) do final = final..v end
  return final
end

--Wartet darauf das "Enter" gedrueckt wird
function getEnter()
  term.write("Enter druecken...")
  while true do
    local event,keyCode = os.pullEvent("key")
    if keyCode == 28 then
      print()
      break
    end
  end
end

--Gibt true oder false zurueck - Anfrage an den Anwender
function yesNoInput(message)
  local input = ""
  while true do
    print(message.." (j/n)?")
    term.write("Eingabe: ")
    input = read()
    if input == "j" then return true
    elseif input == "n" then return false
    end
  end  
end

--Gibt einen String zurueck - Anfrage an den Anwender
function stringInput(message)
  print(message)
  term.write("Eingabe: ")
  local input = read()
  return input
end

--Gibt eine Zahl zwischen min und max zurueck - Anfrage an den Anwender
function numberInput(message,min,max)
  local input = ""
  while true do
    print(message.." ("..min.."-"..max..")")
    term.write("Eingabe: ")
    input = read()
    if tonumber(input) ~= nil then
      local inputNr = tonumber(input)
      if inputNr >= min and inputNr <= max then return inputNr end
    end
  end
end