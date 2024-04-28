return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count
    local harpoon = require("harpoon.mark")

    local colors = {
      blue = "#65D1FF",
      green = "#3EFFDC",
      violet = "#FF61EF",
      yellow = "#FFDA7B",
      red = "#FF4A4A",
      fg = "#c3ccdc",
      bg = "#112638",
      inactive_bg = "#2c3043",
    }

    local my_lualine_theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      insert = {
        a = { bg = colors.green, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      visual = {
        a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      command = {
        a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      replace = {
        a = { bg = colors.red, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      inactive = {
        a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
        b = { bg = colors.inactive_bg, fg = colors.semilightgray },
        c = { bg = colors.inactive_bg, fg = colors.semilightgray },
      },
    }
    
    local function harpoon_component()
	local total_marks = harpoon.get_length()

	if total_marks == 0 then
		return ""
	end

	local current_mark = "—"

	local mark_idx = harpoon.get_current_index()
	if mark_idx ~= nil then
		current_mark = tostring(mark_idx)
	end

	return string.format("󱡅 %s/%d", current_mark, total_marks)
end

local function truncate_branch_name(branch)
	if not branch or branch == "" then
		return ""
	end

	-- Match the branch name to the specified format
	local user, team, ticket_number = string.match(branch, "^(%w+)/(%w+)%-(%d+)")

	-- If the branch name matches the format, display {user}/{team}-{ticket_number}, otherwise display the full branch name
	if ticket_number then
		return user .. "/" .. team .. "-" .. ticket_number
	else
		return branch
	end
end

    -- configure lualine with modified theme
    lualine.setup({
      options = {
        theme = my_lualine_theme,
      },
      sections = {
	lualine_b = {
	  { "branch", icon = "", fmt = truncate_branch_name },
	  harpoon_component,
	  "diff",
	  "diagnostics",
	  },
	lualine_c = {
	  { "filename", path = 1 },
	  },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
      },
    })
  end,
}
