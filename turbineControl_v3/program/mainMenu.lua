-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

--Loads the Touchpoint API
shell.run("cp /reactor-turbine-program/lib/touchpoint.lua /touchpoint")
os.loadAPI("touchpoint")
shell.run("rm touchpoint")

local buttons
local mon = monitorTable[1]
local menuText = loadLanguageFile("de/mainMenu.json") --TODO Autoselect language

local function createButtons()
    buttons = touchpoint.new(monitorTable[1].side)
    buttons:add(menuText.buttons.lang_de,nil,39,11,49,11)
    buttons:add(menuText.buttons.lang_en,nil,39,13,49,13)
end

local function drawMenu()
    mon:clear()
    buttons:draw()
    mon:backgroundColor(colors.gray)
    mon:textColor(colors.white)

    mon:setCursor(3, 2)
    mon:write(menuText.title)
    mon:setCursor(39, 5)
    mon:write(menuText.displayMainMenu)
    mon:setCursor(39, 9)
    mon:write(menuText.language)
    mon:setCursor(3, 7)
    mon:write(menuText.program)
    mon:setCursor(23, 7)
    mon:write(menuText.mode)
end


local function menu()
    createButtons()
    drawMenu()
end

menu()
