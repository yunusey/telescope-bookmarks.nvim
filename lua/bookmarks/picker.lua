local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local bookmarkActions = require('bookmarks.actions')

Browsers = {
    default = "firefox", -- is used if the explorer given is not valid
    firefox = "/mnt/c/Program\\ Files/Mozilla\\ Firefox/firefox.exe",
    chrome  = "/mnt/c/Program\\ Files/Google/Chrome/Application/chrome.exe",
    -- other explorers here
}

Bookmarks = {
    ["📁 Open  APCSA"]     = "Ex ~/yunusey/APCSA",
    ["📁 Open  stapcsa"]   = "Ex ~/yunusey/APCSA/stapcsa/",
    ["📁 Open  dotfiles"]  = "Ex ~/yunusey/.dotfiles",
    ["📁 Open  bash"]      = "Ex ~/yunusey/.dotfiles/bash/",
    ["📁 Open  tmux"]      = "Ex ~/yunusey/.dotfiles/tmux/",
    ["📁 Open  quicklint"] = "Ex ~/yunusey/quick-lint-js",
    ["󰈹  Visit github.com"] = function ()
        bookmarkActions.openInBrowser("github.com", "firefox")
    end,
    [" Visit YouTube"]  = function ()
        bookmarkActions.openInBrowser("youtube.com", "chrome")
    end,
    ["󱞁 Open the current file in NotePad"] =  function ()
        local current_file = vim.fn.expand("%")
        bookmarkActions.openFileInNotepad(current_file)
    end,
    ["📁 Open current dir in explorer"] = function ()
        local directory = vim.fn.expand("%:h")
        bookmarkActions.openDirInExplorer(directory)
    end
}


local function getKeys()
    local keys = {}
    for i, _ in pairs(Bookmarks) do
        table.insert(keys, i)
    end
    return keys
end

local function act(bufnr)
    local selected  = action_state.get_selected_entry()
    local selection = selected[1]
    local todo      = Bookmarks[selection]
    actions.close(bufnr)

    if type(todo) == "string" then
        vim.cmd("tabnew")
        vim.cmd(Bookmarks[selection])
    elseif type(todo) == "function" then
        todo()
    end
end

local opts = {
    finder = finders.new_table(getKeys()),
    sorter = sorters.get_generic_fuzzy_sorter({}),
    prompt_title = "Bookmarks",
    prompt_prefix = "⭐: ",
    attach_mappings = function (_, map)
        map('i', "<CR>", act)
        return true
    end
}

local function picker(theme)
    pickers.new({}, theme(opts)):find()
end

return picker
