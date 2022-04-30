local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

local util = lspconfig.util
local sysname = vim.loop.os_uname().sysname

local command = vim.api.nvim_command

local JAVA_HOME = os.getenv 'JAVA_HOME'

local function get_java_executable()
  local executable = JAVA_HOME and util.path.join(JAVA_HOME, 'bin', 'java') or 'java'

  return sysname:match 'Windows' and executable .. '.exe' or executable
end


local jar = vim.env.HOME .. "/Documents/Dev/CCDetect-lsp/app/build/libs/app-all.jar"

local cmd = { get_java_executable(), '-jar', jar }

local function on_show_document(err, result, ctx, config, params)
	local uri = result.uri
	command("e +" .. result.selection.start.line + 1 .. " " .. uri)

	return result
end

configs["ccdetect"] = {
	default_config = {
		cmd = cmd,
		filetypes = { "ccdetect" },
		root_dir = function(fname)
			return util.root_pattern(".git")(fname)
		end,
		handlers = {
			["window/showDocument"] = on_show_document,
		},
	},
	config = {},
}

lspconfig["ccdetect"].setup({})
