local M = {}

local function convertToWindowsPath(dir)
    local linux_path = "\\wsl.localhost\\Ubuntu-20.04"
    dir = string.gsub(dir, "/", "\\")
    return linux_path .. dir
end

local function isValidData(data)
    if data == nil or data == "" or data == {} then
        return false
    end

    for _, i in ipairs(data) do
        local a = isValidData(i)
        if a == true then
            return true
        end
    end

    return false
end

M.openInBrowser = function (link, browser)
    local browser_path = Browsers[browser] or Browsers[Browsers["default"]]
    local command      = browser_path .. ' ' .. link
    vim.fn.jobstart(command, {
        on_stderr = function (_, data)
           if isValidData(data) then
                print("An error occured while opening the link in the browser")
            end
        end
    })
end

M.openFileInNotepad = function (file)
    local command = "notepad.exe " .. file
    vim.fn.jobstart(command, {
        on_stderr = function (_, data)
            if isValidData(data) then
                print("An error occured whlie opening the file in the Notepad")
            end
        end
    })
end

M.openDirInExplorer = function (dir)
    dir = convertToWindowsPath(dir)
    local command = {"explorer.exe", "\"" ..  dir .. "\""}
    vim.fn.jobstart(command, {
        on_stderr = function (_, data)
            if isValidData(data) then
                print("An error occured while opening the directory in the explorer")
            end
        end
    })
end

return M
