-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

---------- Variables

--Loads the Touchpoint API
shell.run("cp /reactor-turbine-program/lib/touchpoint.lua /touchpoint")
os.loadAPI("touchpoint")
shell.run("rm touchpoint")

local buttons
local mon = monitorTable[1]
local menuText = loadLanguageFile(getOption("lang") .. "/mainMenu.json") --TODO Autoselect language

--Main Menu Toggle
local menuOn = { menuText.buttons.mainMenuOn, label = "menuOn" }
local menuOff = { menuText.buttons.mainMenuOff, label = "menuOn" }

---------- UI functions
local function createButtons()
    buttons = touchpoint.new(monitorTable[1].side)

    buttons:add(menuText.buttons.program_reactor, nil, 2, 7, 3 + string.len(menuText.buttons.program_reactor), 7)
    buttons:add(menuText.buttons.program_turbine, nil, 2, 9, 3 + string.len(menuText.buttons.program_turbine), 9)
    buttons:add(menuText.buttons.mode_auto, nil, 2, 13, 3 + string.len(menuText.buttons.mode_auto), 13)
    buttons:add(menuText.buttons.mode_man, nil, 2, 15, 3 + string.len(menuText.buttons.mode_man), 15)

    buttons:add(menuText.buttons.start, nil, 2, 19, 3 + string.len(menuText.buttons.start), 19)
    buttons:add(menuText.buttons.exit, nil, 2, 21, 3 + string.len(menuText.buttons.exit), 21)
    buttons:add(menuText.buttons.options, nil, 2, 23, 3 + string.len(menuText.buttons.options), 23)

    buttons:add("menuOn", nil, 36, 7, 39 + string.len(menuText.buttons.mainMenuOn), 7)
    buttons:rename("menuOn", menuOff, true)

    buttons:add(menuText.buttons.lang_de, function() switchLang("de") end, 36, 11, 39 + string.len(menuText.buttons.lang_de), 11)
    buttons:add(menuText.buttons.lang_en, function() switchLang("en") end, 36, 13, 39 + string.len(menuText.buttons.lang_en), 13)

    --Toggle buttons
    buttons:toggleButton(menuText.buttons["program_" .. getOption("program")])
    buttons:toggleButton(menuText.buttons["mode_" .. getOption("mode")])
    if getOption("mainMenu") then
        buttons:rename("menuOn", menuOn, true)
        buttons:toggleButton("menuOn")
    end
    buttons:toggleButton(menuText.buttons["lang_" .. getOption("lang")])
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
    mon:setCursor(math.floor(mon:x() / 2 - string.len("Version " .. getOption("version") .. " - (c) 2017 Thor_s_Crafter") / 2), mon:y())
    mon:write("Version " .. getOption("version") .. " - (c) 2017 Thor_s_Crafter")
end

local function drawMenu()
    mon:clear()
    buttons:draw()
    mon:backgroundColor(colors.gray)
    mon:textColor(colors.white)

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
end


local function switchLang(lang)
    setOption(lang)
    saveOptions()
    menu()
end

local function menu()
    createButtons()
    drawMenu()
end



menu()
