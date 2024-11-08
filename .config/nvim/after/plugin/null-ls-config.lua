local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local ok, res = pcall(require, "null-ls")

if not ok then
    return
end

require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.prettierd.with(
            {
                extra_filetypes = { "graphql" },
                disabled_filetypes = { "markdown" },
            }
        ),
        require("null-ls").builtins.formatting.clang_format,
        require("null-ls").builtins.formatting.stylua,
        require("null-ls").builtins.formatting.gofmt,
        require("null-ls").builtins.formatting.goimports,
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            autocmd({ "BufWritePre" }, {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr })
                end,
            })
        end
    end,
})
