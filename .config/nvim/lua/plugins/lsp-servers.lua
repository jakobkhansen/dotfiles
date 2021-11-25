-- Setup
local nvim_lsp = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
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

-- Java
local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local function jdtls_on_attach()
	require("jdtls").setup_dap({ hotcodereplace = "auto" })
	require("virtualtypes").on_attach()
	require("jdtls.setup").add_commands()
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

function start_jdt()
	vimscript("cd %:p:h", false)
	local config = {
		init_options = {
			extendedClientCapabilities = extendedClientCapabilities,
		},
		--root_dir = vim.fn.getcwd(),
		root_dir = Find_root_better({ "build.gradle", "pom.xml" }),
		on_attach = jdtls_on_attach,
		flags = {
			allow_incremental_sync = true,
			server_side_fuzzy_completion = true,
		},
		capabilities = capabilities,
		cmd = { "java-lsp.sh" },

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
		on_init = function(client)
			client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
		end,
	}

	require("jdtls").start_or_attach(config)
end

vimscript("au FileType java lua start_jdt()", false)

-- Typescript

require("null-ls").config{}

require("lspconfig")["null-ls"].setup {}

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


-- Latex
nvim_lsp.texlab.setup({})

-- Kotlin
nvim_lsp.kotlin_language_server.setup({})

-- Lua
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

-- C++
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
})

