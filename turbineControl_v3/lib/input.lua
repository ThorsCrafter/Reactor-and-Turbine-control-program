-- Input API for ComputerCraft
-- (c) 2017 Thor_s_Crafter
-- Version 1.1

--Formats big numbers into a String (e.g. 1.000)
function formatNumber(seperator,value)
    --Values smaller than 1000 don't have to be formatted
    if value < 1000 then return value end

    --Variables for calculation
    local array = {}
    local vStr = tostring(value)
    local len = string.len(vStr)
    local modulo = math.fmod(len, 3)

    --Save single characters in an array
    for i = 1, len do array[i] = string.sub(vStr, i, i) end

    --Select up to 2 numbers at the beginning of the array
    --and deletes it from the old one
    local array2 = {}
    if modulo ~= 0 then
        for i = 1, modulo do
            array2[i] = array[1]
            table.remove(array, 1)
        end
    end

    --Insert dots
    for i = 1, #array + 1, 4 do
        table.insert(array, i, seperator)
    end

    --Concatenate arrays
    for i = #array2, 1, -1 do table.insert(array, 1, array2[i]) end
    if modulo == 0 then table.remove(array, 1) end --Remove possible seperator in the front

    --Format array back to a String and return it
    local final = ""
    for k, v in pairs(array) do final = final .. v end
    return final
end

--Wait for pressing Enter
function getEnter(text,timeout)
    term.write(text)
    while true do
        local event, keyCode = os.pullEvent("key")
        if keyCode == 28 then
            break
        end
    end
end

--Returns true or false depending on the user input
function yesNoInput(message,yesOption,noOption)
    local input = ""
    while true do
        print(message .. " ("..yesOption.."/"..noOption..")?")
        term.write("Eingabe: ")
        input = read()
        if input == yesOption.."\n" then return true
        elseif input == noOption.."\n" then return false
        end
    end
end

--Returns a string, the user is prompted to insert
function stringInput(message)
    print(message)
    term.write("Eingabe: ")
    local input = read()
    return input
end

--Returns a number between min/max, depending on the users input
function numberInput(message, min, max)
    local input = ""
    while true do
        print(message .. " (" .. min .. "-" .. max .. ")")
        term.write("Eingabe: ")
        input = read()
        if tonumber(input) ~= nil then
            local inputNr = tonumber(input)
            if inputNr >= min and inputNr <= max then return inputNr end
        end
    end
end