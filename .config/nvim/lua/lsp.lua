-- Setup
local nvim_lsp = require("lspconfig")
local util = require("lspconfig/util")
local capabilities = vim.lsp.protocol.make_client_capabilities()
local autocmd = vim.api.nvim_create_autocmd

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.workspace.configuration = true

-- Show diagnostics and signcolumn icons
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
        severity_limit = "Error",
        spacing = 4,
        prefix = "●",
    },

    signs = true,

    update_in_insert = false,
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

---- Java
local function start_jdt()
    local root = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" })
    local project_name = vim.fn.fnamemodify(root, ":t")
    local workspace_dir = vim.env.HOME .. "/.workspaces/" .. project_name
    local config = {
        init_options = {
            extendedClientCapabilities = require("jdtls").extendedClientCapabilities,
        },
        root_dir = root,
        capabilities = capabilities,
        cmd = {
            "java",
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
                ..
                "/.langservers/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",
            "-configuration",
            vim.env.HOME .. "/.langservers/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_linux",
            "-data",
            workspace_dir,
        },

        settings = {
            java = {
                configuration = {
                    runtimes = {
                        {
                            name = "JavaSE-1.8",
                            path = "/usr/lib/jvm/java-8-openjdk/",
                        },
                        {
                            name = "JavaSE-11",
                            path = "/usr/lib/jvm/java-11-openjdk/",
                        },
                    },
                },
            },
        },
    }
    require("jdtls").start_or_attach(config)
end

if vim.g.javaserveroff == nil then
    autocmd("FileType", { pattern = "java", callback = start_jdt })
end

---- Typescript
nvim_lsp.tsserver.setup({
    on_attach = function(client, _)
        client.server_capabilities.document_formatting = false
        client.server_capabilities.document_range_formatting = false
    end,
})

-- Go
require("lspconfig").gopls.setup({})

-- C++
if vim.g.javaserveroff == nil then
    require("lspconfig").ccls.setup({
        root_dir = util.root_pattern(
            "compile_commands.json",
            ".ccls",
            "compile_flags.txt",
            ".git",
            "build/compile_commands.json"
        ),
    })
end

-- HTML
nvim_lsp.html.setup({})

-- CSS
nvim_lsp.cssls.setup({})

-- JSON
require("lspconfig").jsonls.setup({})

-- Tailwind
nvim_lsp.tailwindcss.setup({})

-- Eslint
nvim_lsp.eslint.setup({})

---- Latex
nvim_lsp.texlab.setup({})

-- Ltex
require("lspconfig").ltex.setup({
    filetypes = { "bib", "gitcommit", "plaintex", "rst", "rnoweb", "tex" },
})

-- Lua
require("lspconfig").sumneko_lua.setup({
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

-- Python
nvim_lsp.pyright.setup({
    capabilities = capabilities,
})
