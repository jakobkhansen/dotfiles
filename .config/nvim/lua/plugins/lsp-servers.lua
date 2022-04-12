-- Setup
local nvim_lsp = require("lspconfig")
local util = require("lspconfig/util")
local capabilities = vim.lsp.protocol.make_client_capabilities()
local autocmd = vim.api.nvim_create_autocmd
local add_command = vim.api.nvim_add_user_command
local vimscript = vim.api.nvim_exec

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.workspace.configuration = true

-- Python
nvim_lsp.pyright.setup({
	capabilities = capabilities,
})

-- HTML
nvim_lsp.html.setup({
	capabilities = capabilities,
	commands = {
		Format = {
			function()
				vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
			end,
		},
	},
})

-- CSS
nvim_lsp.cssls.setup({
	capabilities = capabilities,
})

-- JSON
require("lspconfig").jsonls.setup({
	commands = {
		Format = {
			function()
				vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
			end,
		},
	},
})

---- Java
local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local function jdtls_on_attach()
	require("virtualtypes").on_attach()
	require("jdtls.setup").add_commands()
	require("jdtls").setup_dap({ hotcodereplace = "auto" })
end

function Find_root_better(markers, bufname)
	bufname = bufname or vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
	local dirname = vim.fn.fnamemodify(bufname, ":p:h")
	local getparent = function(p)
		return vim.fn.fnamemodify(p, ":h")
	end
	while not (getparent(dirname) == dirname) do
		for _, marker in ipairs(markers) do
			if vim.loop.fs_stat(require("jdtls.path").join(dirname, marker)) then
				return dirname
			end
		end
		dirname = getparent(dirname)
	end
	return vim.fn.getcwd()
end

local function start_jdt()
    vimscript("cd %:p:h", false)
	local project_name = vim.fn.fnamemodify(Find_root_better({ "build.gradle", "pom.xml", "build.xml" }), ":p:h:t")
	local workspace_dir = vim.env.HOME .. "/.workspaces/" .. project_name

	local bundles = {
		vim.fn.glob(
			vim.env.HOME
				.. "/.langservers/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
		),
	}
	vim.list_extend(
		bundles,
		vim.split(vim.fn.glob(vim.env.HOME .. "/.langservers/vscode-java-test/server/*.jar"), "\n")
	)

	local config = {
		init_options = {
			extendedClientCapabilities = extendedClientCapabilities,
			bundles = bundles,
		},
		root_dir = Find_root_better({ "build.gradle", "pom.xml", "build.xml" }),
		on_attach = jdtls_on_attach,
		flags = {
			allow_incremental_sync = true,
			server_side_fuzzy_completion = true,
		},
		capabilities = capabilities,
		cmd = {

			"/usr/lib/jvm/java-11-openjdk/bin/java", -- or '/path/to/java11_or_newer/bin/java'
			-- depends on if `java` is in your $PATH env variable and if it points to the right version.

			"-Declipse.application=org.eclipse.jdt.ls.core.id1",
			"-Dosgi.bundles.defaultStartLevel=4",
			"-Declipse.product=org.eclipse.jdt.ls.core.product",
			"-Dlog.protocol=true",
			"-Dlog.level=ALL",
			"-Xms1g",
			"-Xmx2G",
			"--add-modules=ALL-SYSTEM",
			"--add-opens",
			"java.base/java.util=ALL-UNNAMED",
			"--add-opens",
			"java.base/java.lang=ALL-UNNAMED",

			"-jar",
			vim.env.HOME
				.. "/.langservers/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",

			"-configuration",
			vim.env.HOME .. "/.langservers/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_linux",

			"-data",
			workspace_dir,
		},

		settings = {
			java = {
				signatureHelp = { enabled = true },
				contentProvider = { preferred = "fernflower" },
				configuration = {
					runtimes = {
						{
							name = "JavaSE-1.8",
							path = "/usr/lib/jvm/java-8-openjdk/",
							default = true,
						},
						{
							name = "JavaSE-11",
							path = "/usr/lib/jvm/java-11-openjdk/",
						},
					},
				},
				errors = {
					incompleteClasspath = {
						severity = "ignore",
					},
				},
			},
		},
	}

	require("jdtls").start_or_attach(config)
end

autocmd("FileType", { pattern = "java", callback = start_jdt })

add_command("JdtUpdateConfig", require("jdtls").update_project_config, {})
add_command("JdtDap", function()
	require("jdtls.dap").setup_dap_main_class_configs()
    require("jdtls").setup_dap({ hotcodereplace = "auto" })
end, {})
add_command("JdtRun", require("dap").continue, {})

---- Typescript

-- require("null-ls").setup({})

nvim_lsp.tsserver.setup({
	on_attach = function(client, bufnr)
		local ts_utils = require("nvim-lsp-ts-utils")

		-- defaults
		ts_utils.setup({
			debug = false,
			disable_commands = false,
			enable_import_on_completion = true,

			-- import all
			import_all_timeout = 5000, -- ms
			-- lower numbers indicate higher priority
			import_all_priorities = {
				same_file = 1, -- add to existing import statement
				local_files = 2, -- git files or files with relative path markers
				buffer_content = 3, -- loaded buffer content
				buffers = 4, -- loaded buffer names
			},
			import_all_scan_buffers = 100,
			import_all_select_source = true,

			-- eslint
			eslint_enable_code_actions = false,
			eslint_enable_disable_comments = true,
			eslint_bin = "eslint",
			eslint_enable_diagnostics = false,
			eslint_opts = {},

			-- formatting
			enable_formatting = false,
			formatter = "prettier",
			formatter_opts = {},

			-- update imports on file move
			update_imports_on_move = true,
			require_confirmation_on_move = false,
			watch_dir = nil,

			-- filter diagnostics
			filter_out_diagnostics_by_severity = {},
			filter_out_diagnostics_by_code = {},
		})

		-- required to fix code action ranges and filter diagnostics
		ts_utils.setup_client(client)
	end,
})

---- Latex
nvim_lsp.texlab.setup({})

---- Lua
USER = vim.fn.expand("$USER")

local sumneko_root_path = "/home/" .. USER .. "/.langservers/lua-language-server"
local sumneko_binary = "/home/" .. USER .. "/.langservers/lua-language-server/bin/Linux/lua-language-server"

require("lspconfig").sumneko_lua.setup({
	cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = vim.split(package.path, ";"),
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				},
			},
		},
	},
})

---- C++
require("lspconfig").ccls.setup({
	init_options = {
		compilationDatabaseDirectory = "build",
		index = {
			threads = 0,
		},
		clang = {
			excludeArgs = { "-frounding-math" },
		},
	},
	root_dir = util.root_pattern(
		"compile_commands.json",
		".ccls",
		"compile_flags.txt",
		".git",
		"build/compile_commands.json"
	),
})

-- Tailwind CSS
nvim_lsp.tailwindcss.setup({
	settings = {
		tailwindCSS = {
			experimental = {
				classRegex = {
					"tailwind\\('([^)]*)\\')",
					"'([^']*)'",
				},
			},
		},
	},
})

-- Ltex
require("lspconfig").ltex.setup({
	filetypes = { "bib", "gitcommit", "org", "plaintex", "rst", "rnoweb", "tex" },
})
