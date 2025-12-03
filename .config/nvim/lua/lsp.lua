-- Setup
local nvim_lsp = vim.lsp.config
local keymap = vim.keymap.set
local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities())
local autocmd = vim.api.nvim_create_autocmd

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.workspace.configuration = true

-- print(vim.inspect(capabilities))
capabilities.workspace.didChangeWatchedFiles = {
    dynamicRegistration = true,
    relativePatternSupport = true,
}

-- Format on save
autocmd({ "BufWritePre" },
    {
        callback = function()
            vim.lsp.buf.format()
        end
    }
)

-- Show diagnostics and signcolumn icons
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
        min = "Error",
        spacing = 4,
        prefix = "●",
    },
    severity_sort = { reverse = true },
    signs = true,
    update_in_insert = false,
})

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
            [vim.diagnostic.severity.WARN] = " "
        }
    }
})

-- Start servers
-- require("typescript-tools").setup({
--     on_attach = function(client, bufnr)
--         client.server_capabilities.documentFormattingProvider = false
--         client.server_capabilities.documentRangeFormattingProvider = false
--         client.server_capabilities.semanticTokensProvider = nil
--     end,
--     settings = {
--         tsserver_log = "verbose",   -- log level: "off", "normal", "terse", or "verbose"
--         tsserver_trace = "verbose", -- if supported: "off", "messages", or "verbose"
--         -- to actually persist logs:
--         tsserver_enableTracing = true,
--         separate_diagnostic_server = true,
--     },
-- })

vim.lsp.config("vtsls", {
    settings = {
        typescript = {
            tsserver = {
                maxTsServerMemory = 8192
            }
        }
    }
})

vim.lsp.config("relay_lsp", {})

vim.lsp.config("html", {
    capabilities = capabilities,
})
vim.lsp.config("cssls", {
    capabilities = capabilities,
})
vim.lsp.config("jsonls", {
    capabilities = capabilities,
})

vim.lsp.config("tailwindcss", {
    settings = {
        tailwindCSS = {
            experimental = {
                classRegex = {
                    "tailwind\\('([^)]*)\\')", "'([^']*)'"
                },
            },
        },
    },
})

-- Go
vim.lsp.config("gopls", {})

-- C++
vim.lsp.config("clangd", {})

-- Python
vim.lsp.config("pyright", {})

-- Lua
vim.lsp.config("lua_ls", {
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
                    vim.env.VIMRUNTIME
                },
            },
        },
    },
})

vim.lsp.config("roslyn", {
    cmd = {
        "dotnet",
        "C:\\Users\\jakobhansen\\Documents\\Roslyn\\Microsoft.CodeAnalysis.LanguageServer.dll",
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
        "--stdio"
    },
    init_options = {
        formattingOptions = {
            enableEditorConfigSupport = true,
            organizeImportsOnFormat = true,
            tabSize = 4,
            insertSpaces = true,
        },
    },
    settings = {
        ["csharp|formatting"] = {
            dotnet_organize_imports_on_format = true,
        },
    },
    on_attach = function(client, bufnr)
        -- make sure Neovim knows this server can format
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.documentRangeFormattingProvider = true
    end,
})
