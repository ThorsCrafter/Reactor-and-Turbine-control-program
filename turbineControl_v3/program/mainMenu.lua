-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

---------- Variables

--Loads the Touchpoint API
shell.run("cp /reactor-turbine-program/lib/touchpoint.lua /touchpoint")
os.loadAPI("touchpoint")
shell.run("rm touchpoint")

local exit = false
local buttons
local mon = monitorTable[1]
local options = newOptions()
local menuText = loadLanguageFile(options:get("lang") .. "/mainMenu.json")

--Main Menu Toggle
local menuOn = { menuText.buttons.mainMenuOn, label = "menuOn" }
local menuOff = { menuText.buttons.mainMenuOff, label = "menuOn" }

---------- Button functions
local function switchLang(lang)
    options:set("lang", lang)
    options:save()
    menuText = loadLanguageFile(options:get("lang") .. "/mainMenu.json")
end

local function quitProgram()
    mon:backgroundColor(colors.black)
    mon:clear()
    exit = true
end

local function selectProgram(program)
    options:set("program", program)
    options:save()
end

local function selectMode(mode)
    options:set("mode", mode)
    options:save()
end

local function toggleMainMenu()
    if options:get("mainMenu") then
        options:set("mainMenu", false)
        buttons.buttonList["menuOn"].active = false
    else
        options:set("mainMenu", true)
        buttons.buttonList["menuOn"].active = true
    end
end

local function runProgram(program)
    shell.run("/reactor-turbine-program/"..program)
    exit = true
end

---------- UI functions
local function createButtons()
    buttons = touchpoint.new(monitorTable[1].side)

    buttons:add(menuText.buttons.program_reactor, function() selectProgram("reactor") end, 2, 7, 3 + string.len(menuText.buttons.program_reactor), 7)
    buttons:add(menuText.buttons.program_turbine, function() selectProgram("turbine") end, 2, 9, 3 + string.len(menuText.buttons.program_turbine), 9)
    buttons:add(menuText.buttons.mode_auto, function() selectMode("auto") end, 2, 13, 3 + string.len(menuText.buttons.mode_auto), 13)
    buttons:add(menuText.buttons.mode_man, function() selectMode("man") end, 2, 15, 3 + string.len(menuText.buttons.mode_man), 15)

    buttons:add(menuText.buttons.start, nil, 2, 19, 3 + string.len(menuText.buttons.start), 19) --TODO Change to start the program
    buttons:add(menuText.buttons.exit, quitProgram, 2, 21, 3 + string.len(menuText.buttons.exit), 21)
    buttons:add(menuText.buttons.options, function() runProgram("program/setOptions.lua") end, 2, 23, 3 + string.len(menuText.buttons.options), 23) --TODO Change to start the options menu

    buttons:add("menuOn", toggleMainMenu, 36, 7, 39 + string.len(menuText.buttons.mainMenuOn), 7)
    buttons:rename("menuOn", menuOff, true)

    buttons:add(menuText.buttons.lang_de, function() switchLang("de") end, 36, 11, 39 + string.len(menuText.buttons.lang_de), 11)
    buttons:add(menuText.buttons.lang_en, function() switchLang("en") end, 36, 13, 39 + string.len(menuText.buttons.lang_en), 13)

    --Toggle buttons
    buttons:toggleButton(menuText.buttons["program_" .. options:get("program")])
    buttons:toggleButton(menuText.buttons["mode_" .. options:get("mode")])
    if options:get("mainMenu") then
        buttons:rename("menuOn", menuOn, true)
        buttons:toggleButton("menuOn")
    end
    buttons:toggleButton(menuText.buttons["lang_" .. options:get("lang")])
end

local function drawHeader()
    mon:setCursor(1, 1)
    for i = 1, mon:x() do mon:write("=") end
    mon:setCursor(math.floor(mon:x() / 2 - string.len(menuText.title) / 2), 2)
    mon:write(menuText.title)
    mon:setCursor(1, 3)
    for i = 1, mon:x() do mon:write("=") end
end

local function drawFooter()
    mon:setCursor(1, mon:y() - 1)
    for i = 1, mon:x() do mon:write("-") end
    mon:setCursor(math.floor(mon:x() / 2 - string.len("Version " .. options:get("version") .. " - (c) 2017 Thor_s_Crafter") / 2), mon:y())
    mon:write("Version " .. options:get("version") .. " - (c) 2017 Thor_s_Crafter")
end

local function drawMenu()
    mon:clear()
    buttons:draw()
    mon:backgroundColor(options:get("backgroundColor"))
    mon:textColor(options:get("textColor"))

    drawHeader()

    mon:setCursor(2, 5)
    mon:write(menuText.program)
    mon:setCursor(2, 11)
    mon:write(menuText.mode)
    mon:setCursor(2, 17)
    mon:write(menuText.control)
    mon:setCursor(36, 5)
    mon:write(menuText.displayMainMenu)
    mon:setCursor(36, 9)
    mon:write(menuText.language)

    drawFooter()
end

---------- Event functions
local function handleClicks()
    --timer
    local timer1 = os.startTimer(1)

    while true do
        --gets the event
        local event, but = buttons:handleEvents(os.pullEvent())

        --execute a buttons function if clicked
        if event == "button_click" then
            if buttons.buttonList[but].func == nil then break end
            buttons:flash(but)
            buttons.buttonList[but].func()
            break
        elseif event == "timer" and p1 == timer1 then
            break
        end
    end
end

--------- Other functions
local function menu()
    createButtons()
    drawMenu()
end


while not exit do
    menu()
    handleClicks()
end


