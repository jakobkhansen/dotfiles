-- Setup
local nvim_lsp = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
local autocmd = vim.api.nvim_create_autocmd

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.workspace.configuration = true

-- print(vim.inspect(capabilities))
capabilities.workspace.didChangeWatchedFiles = {
    dynamicRegistration = true,
    relativePatternSupport = true,
}

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
require("typescript-tools").setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
})


nvim_lsp.csharp_ls.setup({
    handlers = {
        ["textDocument/definition"] = require('csharpls_extended').handler,
        ["textDocument/typeDefinition"] = require('csharpls_extended').handler,
    },
})

nvim_lsp.jdtls.setup({

    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
})

nvim_lsp.html.setup({
    capabilities = capabilities,
})
nvim_lsp.cssls.setup({
    capabilities = capabilities,
})
nvim_lsp.jsonls.setup({
    capabilities = capabilities,
})

-- Go
require("lspconfig").gopls.setup({})

-- C++
require("lspconfig").clangd.setup({})

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
