require'snippets'.use_suggested_mappings()

local nvim_lsp = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true;
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
function start_jdt()
    local config = {
        flags = {
            allow_incremental_sync = true,
        };
        capabilities = capabilities;
        cmd = {'java-lsp.sh'};

        settings = {
            java = {
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
