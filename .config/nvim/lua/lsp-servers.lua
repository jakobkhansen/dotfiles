require'snippets'.use_suggested_mappings()

-- Setup
local nvim_lsp = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true;
capabilities.workspace.configuration = true
USER = vim.fn.expand('$USER')


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


local function jdtls_on_attach(client, bufnr)
    on_attach(client, bufnr)
    local opts = { silent = true; }
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
