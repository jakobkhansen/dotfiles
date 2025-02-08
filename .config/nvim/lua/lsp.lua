-- Setup
local nvim_lsp = require("lspconfig")
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
require("typescript-tools").setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
})

nvim_lsp.relay_lsp.setup({
    auto_start_compiler = true,
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

nvim_lsp.tailwindcss.setup({
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
                    vim.env.VIMRUNTIME
                },
            },
        },
    },
})
