-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0


local UI = {
    id = "",
    mon = {},
    title = "",
    version = "",
    background = 0,
    foreground = 0,

    header = function(self)
        self.mon:setCursor(1, 1)
        for i = 1, self.mon:x() do
            self.mon:write("=")
        end
        self.mon:setCursor(math.floor(self.mon:x() / 2 - string.len(self.title) / 2), 2)
        self.mon:write(self.title)
        self.mon:setCursor(1, 3)
        for i = 1, self.mon:x() do
            self.mon:write("=")
        end
    end,

    footer = function(self)
        self.mon:setCursor(1, self.mon:y() - 1)
        for i = 1, self.mon:x() do
            self.mon:write("-")
        end
        self.mon:setCursor(math.floor(self.mon:x() / 2 - string.len("Version " .. self.version .. " - (c) 2017 Thor_s_Crafter") / 2), self.mon:y())
        self.mon:write("Version " .. self.version .. " - (c) 2017 Thor_s_Crafter")
    end,

    clear = function(self)
        self.mon:backgroundColor(self.background)
        self.mon:textColor(self.foreground)
        self.mon:clear()
    end,

    drawFrame = function(self)
        self.mon:backgroundColor(self.background)
        self.mon:textColor(self.foreground)
        self:header()
        self:footer()
    end,

    writeContent = function(self, row, column, content, textColor, backgroundColor)
        textColor = textColor or self.foreground
        backgroundColor = backgroundColor or self.background

        self.mon:backgroundColor(backgroundColor)
        self.mon:textColor(textColor)

        self.mon:setCursor(row,column)
        self.mon:write(content)
    end
}

function newUI(id, mon, title, version, background, foreground)
    local ui = {}
    setmetatable(ui, { __index = UI })

    ui.id = id
    ui.mon = mon
    ui.title = title
    ui.version = version
    ui.background = background
    ui.foreground = foreground

    return ui
end

