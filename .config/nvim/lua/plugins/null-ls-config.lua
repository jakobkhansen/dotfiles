local autocmd = vim.api.nvim_create_autocmd

require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.prettierd,
        require("null-ls").builtins.code_actions.gitsigns,
        -- require("null-ls").builtins.formatting.prettier_d_slim
    },
    on_attach = function(client, bufnr)
        autocmd({ "BufWritePre" }, { callback = function() vim.lsp.buf.formatting_sync() end, pattern = "*.tsx,*.ts,*.jsx,*.js" })
    end
})
