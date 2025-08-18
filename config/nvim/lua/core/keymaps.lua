
local keymap = vim.keymap -- for conciseness
local harpoon_ui = require("harpoon.ui")
local harpoon_mark = require("harpoon.mark")

local export_keymaps = {}

keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit Nvim" })
keymap.set("n", "<leader>Q", "<cmd>wq<cr>", { desc = "Save and Quit Nvim" })
keymap.set("n", "U", "<C-r>", { desc = "Redo" })
vim.keymap.set({ "n", "v" }, "<leader>ff", function()
	require("conform").format({lsp_fallback = true, async = false})
	end, { desc = "Format file or range (in visual mode)" })
	
vim.keymap.set("n", "<leader>l", function()
	lint.try_lint()
	end, { desc = "Trigger linting for current file" })

-- Options --
keymap.set("n", "<leader>o", function() end, { desc = "Options" })
keymap.set("n", "<leader>oh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Window management --
keymap.set("n", "<leader>s", function() end, { desc = "Window management" })
keymap.set("n", "<leader>s<right>", ":vsplit | :Telescope buffers<CR>", { desc = " New split window vertically" })
keymap.set("n", "<leader>s<down>", ":split<CR>", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make window splits equal size" })
keymap.set("n", "<leader>sc", ":close<CR>", { desc = "Close current split window" })
keymap.set("n", "<leader>sr", ":wincmd r<cr>", { desc = "Rotate Windows (vertically)" })
keymap.set("n", "<A-Up>", ":wincmd k<CR>", { desc = "Move to the window (Up)" })
keymap.set("n", "<A-Down>", ":wincmd j<CR>", { desc = "Move to the window (Down)" })
keymap.set("n", "<A-Right>", ":wincmd l<CR>", { desc = "Move to the window (Right)" })
keymap.set("n", "<A-Left>", ":wincmd h<CR>", { desc = "Move to the window (Left)" })

-- Harpoon --
keymap.set("n", "<leader>h", function() end, { desc = "Harpoon" })
keymap.set("n", "<leader>ho", function() harpoon_ui.toggle_quick_menu() end, { desc = "Open Harpoon menu" })
keymap.set("n", "<leader>ha", function() harpoon_mark.add_file() end, { desc = "Add file" })
keymap.set("n", "<leader>hr", function() harpoon_mark.rm_file() end, { desc = "Remove file" })
keymap.set("n", "<leader>hc", function() harpoon_mark.clear_all() end, { desc = "Remove all files" })
keymap.set("n", "<leader>1", function() harpoon_ui.nav_file(1) end, { desc = "Goto file 1" })
keymap.set("n", "<leader>2", function() harpoon_ui.nav_file(2) end, { desc = "Goto file 2" })
keymap.set("n", "<leader>3", function() harpoon_ui.nav_file(3) end, { desc = "Goto file 3" })
keymap.set("n", "<leader>4", function() harpoon_ui.nav_file(4) end, { desc = "Goto file 4" })
keymap.set("n", "<leader>5", function() harpoon_ui.nav_file(5) end, { desc = "Goto file 5" })

-- Nvim tree --
keymap.set("n", "<leader>e", function() end, { desc = "Nvim tree" })
keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer

-- Telescope --
keymap.set("n", "<leader>f", function() end, { desc = "Telescope" })
keymap.set("n", "S", ":Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
keymap.set("n", "B", ":Telescope buffers<cr>", { desc = "Find string under cursor in cwd" })
keymap.set("n", "b", ":Telescope file_browser<CR>", { desc = "Telescope file browser" }) -- Skal jeg beholde den??
keymap.set("n", "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Find string in cwd" })
keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

-- LSP Keybinds --
export_keymaps.lsp_keybinds = function(buffer)
  local opts = { buffer = buffer, silent = true }
  
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  keymap.set("n", "<leader>g", function() end, { desc = "LSP" })
  
  opts.desc = "Show LSP references"
  keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

  opts.desc = "Go to declaration"
  keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

  opts.desc = "Show LSP definitions"
  keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

  opts.desc = "Show LSP implementations"
  keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

  opts.desc = "Show LSP type definitions"
  keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions
  

  opts.desc = "See available code actions"
  keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

  opts.desc = "Smart rename"
  keymap.set("n", "<leader>or", vim.lsp.buf.rename, opts) -- smart rename

  keymap.set("n", "<leader>d", function() end, { desc = "Diagnostics" })
  opts.desc = "Show buffer diagnostics"
  keymap.set("n", "<leader>dD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

  opts.desc = "Show line diagnostics"
  keymap.set("n", "<leader>dd", vim.diagnostic.open_float, opts) -- show diagnostics for line

  opts.desc = "Go to previous diagnostic"
  keymap.set("n", "d[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

  opts.desc = "Go to next diagnostic"
  keymap.set("n", "d]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer
  

  opts.desc = "Show documentation for what is under cursor"
  keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

  opts.desc = "Restart LSP"
  keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
end




return export_keymaps
