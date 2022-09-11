-- Setup
local nvim_lsp = require("lspconfig")
local util = require("lspconfig/util")
local capabilities = vim.lsp.protocol.make_client_capabilities()
local autocmd = vim.api.nvim_create_autocmd
local add_command = vim.api.nvim_create_user_command
local vimscript = vim.api.nvim_exec
local command = vim.api.nvim_command

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
require("lspconfig").jsonls.setup({})

---- Java
local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

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

    require("jdtls.setup").add_commands()
    require("jdtls").setup_dap({ hotcodereplace = "auto" })

    -- JDTLS related commands
    add_command("JdtDap", function()
        require("jdtls.dap").setup_dap_main_class_configs()
    end, {})
    add_command("JdtClearWorkspace", function()
        command("silent ! rm -r " .. workspace_dir)
    end, {})
    add_command("JdtClearAllWorkspaces", function()
        local workspace_dirs = vim.fn.glob(vim.env.HOME .. "/.workspaces/*")
        for _, workspace in pairs(vim.split(workspace_dirs, "\n")) do
            command("silent ! rm -r " .. workspace)
        end
    end, {})

    local config = {
        init_options = {
            extendedClientCapabilities = extendedClientCapabilities,
            bundles = bundles,
        },
        root_dir = Find_root_better({ "build.gradle", "pom.xml", "build.xml" }),
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

-- Tailwind
nvim_lsp.tailwindcss.setup({})

nvim_lsp.eslint.setup({
    on_attach = function(client, _)
        -- autocmd({ "BufWritePre" }, { command = ":EslintFixAll", pattern = "*.tsx,*.ts,*.jsx,*.js" })
    end,
})

---- Latex
nvim_lsp.texlab.setup({})

-- Ltex
require("lspconfig").ltex.setup({
    filetypes = { "bib", "gitcommit", "plaintex", "rst", "rnoweb", "tex" },
})

-- Lua
USER = vim.fn.expand("$USER")

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

-- Kotlin
nvim_lsp.kotlin_language_server.setup({})
