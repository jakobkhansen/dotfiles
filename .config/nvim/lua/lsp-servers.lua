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

-- CSS
nvim_lsp.cssls.setup {
    capabilities = capabilities;
}

-- Java
local extendedClientCapabilities = require'jdtls'.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true


local function jdtls_on_attach()
    require('jdtls').setup_dap({ hotcodereplace = 'auto' })
    require('virtualtypes').on_attach()
    require'jdtls.setup'.add_commands()
end

function Find_root_better(markers, bufname)
  bufname = bufname or vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  local dirname = vim.fn.fnamemodify(bufname, ':p:h')
  local getparent = function(p)
    return vim.fn.fnamemodify(p, ':h')
  end
  while not (getparent(dirname) == dirname) do
    for _, marker in ipairs(markers) do
      if vim.loop.fs_stat(require('jdtls.path').join(dirname, marker)) then
        return dirname
      end
    end
    dirname = getparent(dirname)
  end
  return vim.fn.getcwd()
end



function start_jdt()
    local config = {
        init_options = {
            extendedClientCapabilities = extendedClientCapabilities;
        },
        --root_dir = vim.fn.getcwd(),
        root_dir = Find_root_better({'build.gradle', 'pom.xml'}),
        on_attach = jdtls_on_attach,
        flags = {
            allow_incremental_sync = true,
            server_side_fuzzy_completion = true,
        };
        capabilities = capabilities;
        cmd = {'java-lsp.sh'};

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
nvim_lsp.tsserver.setup{
    on_attach = function(client, bufnr)
    -- disable tsserver formatting if you plan on formatting via null-ls

        local ts_utils = require("nvim-lsp-ts-utils")

        -- defaults
        ts_utils.setup {
            debug = false,
            disable_commands = false,
            enable_import_on_completion = false,

            -- eslint
            eslint_enable_code_actions = true,
            eslint_enable_disable_comments = true,
            eslint_bin = "eslint",
            eslint_config_fallback = nil,

            -- eslint diagnostics
            eslint_enable_diagnostics = true,
            eslint_diagnostics_debounce = 250,

            -- formatting
            enable_formatting = false,
            formatter = "prettier",
            formatter_config_fallback = nil,

            -- parentheses completion
            complete_parens = false,
            signature_help_in_parens = false,

            -- update imports on file move
            update_imports_on_move = false,
            require_confirmation_on_move = false,
            watch_dir = nil,
        }

        -- required to fix code action ranges
        ts_utils.setup_client(client)

    end
}

-- Latex
nvim_lsp.texlab.setup{}

-- Kotlin
nvim_lsp.kotlin_language_server.setup{}

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
