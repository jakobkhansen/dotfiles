-- Setup
local nvim_lsp = require("lspconfig")
local util = require("lspconfig/util")
local capabilities = vim.lsp.protocol.make_client_capabilities()
local autocmd = vim.api.nvim_create_autocmd

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.workspace.configuration = true

---- Java
local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
local find_root = function()
    return require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" })
end

local function start_jdt()
    local root = find_root()
    local project_name = vim.fn.fnamemodify(root, ":t")
    local workspace_dir = vim.env.HOME .. "/.workspaces/" .. project_name

    require("jdtls.setup").add_commands()

    local config = {
        init_options = {
            extendedClientCapabilities = extendedClientCapabilities,
        },
        root_dir = root,
        flags = {
            allow_incremental_sync = true,
            server_side_fuzzy_completion = true,
        },
        capabilities = capabilities,
        cmd = {
            "java", -- or '/path/to/java11_or_newer/bin/java'
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
                ..
                "/.langservers/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",

            "-configuration",
            vim.env.HOME .. "/.langservers/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_linux",

            "-data",
            workspace_dir,
        },

        settings = {
            java = {
                signatureHelp = { enabled = true },
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

local function organize_imports()
    local params = {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = "",
    }
    vim.lsp.buf.execute_command(params)
end

nvim_lsp.tsserver.setup({
    root_dir = util.root_pattern(".git", "packages/"),
    on_attach = function(client, _)
        client.server_capabilities.document_formatting = false
        client.server_capabilities.document_range_formatting = false
    end,
    commands = {
        OrganizeImports = {
            organize_imports,
            description = "Organize Imports",
        },
    },
})

---- C++
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

-- Scheme
require("lspconfig").racket_langserver.setup({})
