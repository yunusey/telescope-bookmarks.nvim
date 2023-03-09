local s = require("bookmarks")

return require("telescope").register_extension {
	setup = s.setup,
	exports = {
		bookmarks = s.bookmarks,
	},
}
