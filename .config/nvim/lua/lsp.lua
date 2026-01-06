local autocmd = vim.api.nvim_create_autocmd
local home = vim.loop.os_homedir()

-- Format on save
autocmd({ "BufWritePre" },
    {
        callback = function()
            vim.lsp.buf.format()
        end
    }
)

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

-- No config servers
vim.lsp.enable("jsonls")
vim.lsp.enable("html")
vim.lsp.enable("cssls")
vim.lsp.enable("gopls")
vim.lsp.enable("clangd")
vim.lsp.enable("pyright")

-- Typescript
vim.lsp.enable("vtsls")
vim.lsp.config("vtsls", {
    settings = {
        typescript = {
            tsserver = {
                maxTsServerMemory = 8192
            }
        }
    },
})

-- Lua
vim.lsp.enable("lua_ls")
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

-- C# / Roslyn
local roslyn_path = home
    .. "/Documents/Roslyn/Microsoft.CodeAnalysis.LanguageServer.dll"

-- Windows uses backslashes and .exe-style paths, but dotnet itself is the same
if vim.loop.os_uname().sysname == "Windows_NT" then
    roslyn_path = home
        .. "\\Documents\\Roslyn\\Microsoft.CodeAnalysis.LanguageServer.dll"
end


vim.lsp.config("roslyn", {
    cmd = {
        "dotnet",
        roslyn_path,
        "--logLevel=Information",
        '--extensionLogDirectory', vim.fs.joinpath(vim.uv.os_tmpdir(), 'roslyn_ls/logs'),
        "--stdio"
    },
    settings = {
        ["csharp|formatting"] = {
            dotnet_organize_imports_on_format = true,
        },
    },
})
