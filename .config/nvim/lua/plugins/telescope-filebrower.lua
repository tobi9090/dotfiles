return   {
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    local fb_actions = require("telescope._extensions.file_browser.actions")
     local actions = require("telescope.actions")
      local telescope = require("telescope")
	telescope.setup({
		extensions = {
			file_browser = {
				path = "%:p:h",
				-- disables netrw and use telescope-file-browser in its place
				hijack_netrw = true,
				mappings = {
					["i"] = {
					      ["<C-c>"] = fb_actions.create,
					      --["<S-CR>"] = fb_actions.create_from_prompt,
					      ["<C-r>"] = fb_actions.rename,
					      ["<A-m>"] = fb_actions.move,
					      ["<A-y>"] = fb_actions.copy,
					      ["<C-d>"] = fb_actions.remove,
					      --["<C-o>"] = fb_actions.open,
					      ["<C-w>"] = fb_actions.change_cwd,
					      ["<C-b>"] = fb_actions.toggle_browser,
					      ["<C-h>"] = fb_actions.toggle_hidden,
					      ["<C-a>"] = fb_actions.toggle_all,
					      ["<bs>"] = fb_actions.backspace,
					    },
				},
				hidden = true,
			},
		},
	})
	require("telescope").load_extension("file_browser")
end,
}
