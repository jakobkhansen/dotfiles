require'snippets'.use_suggested_mappings()

-- Setup
local nvim_lsp = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true;
capabilities.workspace.configuration = true


-- Python
nvim_lsp.pyright.setup{
    capabilities = capabilities;
}

-- HTML
nvim_lsp.html.setup {
    capabilities = capabilities;
}

-- Java
local extendedClientCapabilities = require'jdtls'.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true


local function jdtls_on_attach()
    require'jdtls.setup'.add_commands()
end

function start_jdt()
    local config = {
        init_options = {
            extendedClientCapabilities = extendedClientCapabilities
        },
        root_dir = vim.fn.getcwd(),       --root_dir = require('jdtls.setup').find_root({'gradle.build', 'pom.xml'}),
        on_attach = jdtls_on_attach,
        flags = {
            allow_incremental_sync = true,
            server_side_fuzzy_completion = true,
        };
        capabilities = capabilities;
        cmd = {'jdtls'};

        settings = {
            java = {
                signatureHelp = { enabled = true };
                contentProvider = { preferred = 'fernflower' };
                configuration = {
                    runtimes = {
                        {
                            name = "JavaSE-1.8",
                            path = "/usr/lib/jvm/java-8-openjdk/",
                            default = true,
                        },
                        {
                            name = "JavaSE-11",
                            path = "/usr/lib/jvm/java-11-openjdk/"
                        }
                    }
                },
                errors = {
                    incompleteClasspath = {
                        severity = "ignore"
                    }
                }
            }
        },
        on_init = function(client)
            client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
        end
    }

    require('jdtls').start_or_attach(config)
end

-- Typescript
nvim_lsp.tsserver.setup{}

-- Latex
nvim_lsp.texlab.setup{}

-- Lua
USER = vim.fn.expand('$USER')

local sumneko_root_path = "/home/" .. USER .. "/.langservers/lua-language-server"
local sumneko_binary = "/home/" .. USER .. "/.langservers/lua-language-server/bin/Linux/lua-language-server"

require'lspconfig'.sumneko_lua.setup {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = vim.split(package.path, ';')
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true}
            }
        }
    }
}
