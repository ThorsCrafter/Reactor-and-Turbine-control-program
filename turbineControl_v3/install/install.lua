-- Reactor / Turbine Control
-- (c) 2017 Thor_s_Crafter
-- Version 3.0

---------- Some variables

--If true, prints the debug output to the terminal
local debug = false
--String containers
local text = {}
--Terminal resolution
local termX, termY

---------- File functions

--Downloads any file
local function downloadFile(url, targetFile)
    if debug then print("Downloading " .. targetFile) end
    local request = http.get(url)
    local file = fs.open(targetFile, "w")
    file.write(request.readAll())
    file.close()
    request.close()
end

--Download the json API
local function getJson()
    downloadFile("https://pastebin.com/raw/4nRg9CHU", "json")
    shell.run("json")
end

local function getLanguageFiles(lang)
    downloadFile("https://raw.githubusercontent.com/ThorsCrafter/Reactor-and-Turbine-control-program/feature/code_restructuring/turbineControl_v3/lang/" .. lang .. "/install.json", "strings.json") --TODO Change branch
end

local function loadLanguageFile()
    local file = fs.open("strings.json", "r")
    text = decode(file.readAll())
    file.close()
end

--Download content from the git repository
local function downloadRepo(branch, rootDir)
    --Create the root Folder
    if fs.exists(rootDir) then shell.run("rm " .. rootDir) end
    shell.run("mkdir "..rootDir)

    --Get the folder structure of the repository
    local request = http.get("https://api.github.com/repos/ThorsCrafter/Reactor-and-Turbine-control-program/git/trees/" .. branch .. "?recursive=1")
    local folderStruct = decode(request.readAll())
    request.close()

    for _, entry in ipairs(folderStruct.tree) do
        local request = http.get("https://raw.githubusercontent.com/ThorsCrafter/Reactor-and-Turbine-control-program/" .. branch .. "/" .. entry.path)

        --Folders
        if entry.mode == "040000" then
            if debug then print("Creating Folder: " .. entry.path) end
            installScreen("folder",entry.path)
            shell.run("mkdir " .. rootDir .. "/" .. entry.path)

            --Files
        elseif entry.mode == "100644" then
            if debug then print("Downloading File: " .. entry.path) end
            installScreen("file",entry.path)
            local file = fs.open(rootDir .. "/" .. entry.path, "w")
            file.write(request.readAll())
            file.close()
            request.close()

            --Other
        else
            if debug then print("Invalid Type: " .. entry.path .. "! Skipping!") end
        end
    end
end

--Move files to the target folder
local function moveFiles(srcDir, targetDir)
    if not fs.exists(targetDir) then shell.run("mkdir " .. targetDir) end
    if debug then print("Moving all files from " .. srcDir .. " to " .. targetDir) end
    shell.run("mv " .. srcDir .. "/* " .. targetDir .. "/")
end

--Delete (tmp) folder
local function delFolder(folder)
    if debug then print("Deleting " .. folder) end
    shell.run("rm " .. folder)
end

--Delete json API
local function removeJson()
    --Remove the json API
    shell.run("rm json")
end

---------- UI functions

local function printHeader()
    --Header
    termX, termY = term.getSize()
    term.clear()
    term.setCursorPos(1, 1)
    for i = 1, termX do term.write("=") end
    term.setCursorPos(math.floor(termX / 2) - math.floor(45 / 2) + 1, 2)
    term.write("Reactor and Turbine Control by Thor_s_Crafter")
    term.setCursorPos(1, 3)
    for i = 1, termX do term.write("=") end
end

local function selectInstallLanguage()
    printHeader()

    --Body
    term.setCursorPos(2, 5)
    print("Please select your language:")
    term.setCursorPos(2, 7)
    term.setBackgroundColor(colors.gray)
    term.write(" English ")
    term.setCursorPos(2, 9)
    term.write(" German / Deutsch ")
    term.setBackgroundColor(colors.black)

    while true do
        local event, button, x, y = os.pullEvent("mouse_click")
        if y == 7 and x > 2 and x < 10 then
            if debug then print("English selected") end
            return "en"
        elseif y == 9 and x > 2 and x < 20 then
            if debug then print("German selected") end
            return "de"
        end
    end
end

local function selectVersion()
    printHeader()

    --Body
    term.setCursorPos(2, 5)
    print(text["selectBranch"])
    term.setCursorPos(2, 7)
    term.setBackgroundColor(colors.gray)
    term.write(text["master"])
    term.setBackgroundColor(colors.black)
    term.write(text["master_description"])
    term.setCursorPos(2, 9)
    term.setBackgroundColor(colors.gray)
    term.write(text["beta"])
    term.setBackgroundColor(colors.black)
    term.write(text["beta_description"])

    while true do
        local event, button, x, y = os.pullEvent("mouse_click")
        if y == 7 and x > 2 and x < 2 + string.len(text["master"]) then
            if debug then print("English selected") end
            return "master"
        elseif y == 9 and x > 2 and x < 2 + string.len(text["beta"]) then
            if debug then print("German selected") end
            return "beta"
        end
    end
end

local function installScreen(status,file)
    printHeader()

    --Body
    term.setCursorPos(2, 5)
    term.write(text["installScreen"])
    term.setCursorPos(2, 7)
    if status == "folder" then
        term.write(text["installStatusFolder"])
        term.write(file.."          ")
    elseif status == "file" then
        term.write(text["installStatusFile"])
        term.write(file.."          ")
    end
end

local function postInstallScreen()
    printHeader()

    --Body
    term.setCursorPos(2, 5)
    term.write(text["installComplete"])
    term.setCursorPos(2, 6)
    term.write(text["final"])

    --Footer
    term.setCursorPos(1,termY)
    term.write("(c) 2017 Thor_s_Crafter")
end

---------- Run installation

--Download all necessary files
local function runInstallation()
    getJson()
    getLanguageFiles(selectInstallLanguage())
    loadLanguageFile()

    local version = selectVersion()
    --installScreen()
    downloadRepo("feature/code_restructuring", "/tmp") --TODO Change to real branch
    moveFiles("/tmp/turbineControl_v3", "/reactor-turbine-program")
    delFolder("/tmp")

    postInstallScreen()
    removeJson()

    sleep(5)
    os.reboot()
end

runInstallation()