require'snippets'.use_suggested_mappings()

local nvim_lsp = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true;

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
    require('jdtls').start_or_attach({cmd = {'java-lsp.sh'},})
end


-- Typescript
nvim_lsp.tsserver.setup{}
