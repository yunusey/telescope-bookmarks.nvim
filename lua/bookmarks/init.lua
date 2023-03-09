local M = {}

local picker = require("bookmarks.picker")

M.bookmarks = function (opts)
	local theme = opts["theme"] or require("telescope.config").values["theme"] or "dropdown"
	local fun   = require("telescope.themes")["get_" .. theme]
	return picker(fun)
end

M.setup = function (ext_conf, opts)
	
end

return M
