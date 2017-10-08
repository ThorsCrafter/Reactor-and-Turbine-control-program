-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0


local File = {
    -- Read file content
    read = function(self)
        --Check if file exists
        if self.path == nil or self.path == "" then
            error("Can not read file. No path specified!")
        end
        if not fs.exists(self.path) then
            error("File (" .. self.path .. ") not found!")
        else
            local file = fs.open(self.path, self.access)
            local list = file.readAll()
            file.close()

            return list
        end
    end,

    --Write content to a file
    write = function(self,content)
        local file = fs.open(self.path, self.access)
        file.writeLine(content)
        file.close()
    end
}


function getFileContent(file, access)
    local fileInstance = {
        path = file,
        access = access or "r"
    }
    setmetatable(fileInstance, { __index = File })
    return fileInstance:read()
end

function writeFileContent(file,content)
    local fileInstance = {
        path = file,
        access = "w",
    }
    setmetatable(fileInstance,{__index = File})
    fileInstance:write(content)
    return true
end










