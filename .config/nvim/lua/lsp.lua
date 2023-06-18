-- Setup
local nvim_lsp = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
local autocmd = vim.api.nvim_create_autocmd

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.workspace.configuration = true

capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

-- Show diagnostics and signcolumn icons
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
        severity_limit = "Error",
        spacing = 4,
        prefix = "●",
    },
    severity_sort = { reverse = true },
    signs = true,
    update_in_insert = false,
})

-- Set signcolumn icons
local function lspSymbol(name, icon)
    vim.fn.sign_define("DiagnosticSign" .. name, { text = icon, texthl = "DiagnosticSign" .. name })
end
lspSymbol("Error", " ")
lspSymbol("Info", " ")
lspSymbol("Hint", "󰌶 ")
lspSymbol("Warn", " ")

-- Disable semantic tokens
autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        client.server_capabilities.semanticTokensProvider = nil
    end,
})

-- Start servers


-- Typescript, Webdev
nvim_lsp.tsserver.setup({
    on_attach = function(client, _)
        client.server_capabilities.document_formatting = false
        client.server_capabilities.document_range_formatting = false
    end,
})

nvim_lsp.tailwindcss.setup({})
nvim_lsp.eslint.setup({})

nvim_lsp.html.setup({})
nvim_lsp.cssls.setup({})
nvim_lsp.jsonls.setup({})

-- Go
require("lspconfig").gopls.setup({})

-- C++
require("lspconfig").clangd.setup({})

-- Latex
nvim_lsp.texlab.setup({})

-- Ltex
nvim_lsp.ltex.setup({})

-- Python
nvim_lsp.pyright.setup({})

-- Lua
require("lspconfig").lua_ls.setup({
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

nvim_lsp.zls.setup({})
